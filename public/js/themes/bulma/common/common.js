/**!
 * @package   Inventory Management
 * @filename  common.js
 * @version   1.0
 * @author    Díaz Urbaneja Víctor Eduardo Diex <diazvictor@tutamail.com>
 * @date      20.11.2023 00:41:26 -04
 */

const launch = {};
launch.sidebar = {};

launch.sidebar.toggle = () => {
	let sidebarToggle = document.getElementsByClassName('sidebar-toggle')[0];
	sidebarToggle.addEventListener('click', e => {
		const icon = e.currentTarget
			.getElementsByClassName('icon')[0]
			.getElementsByClassName('fas')[0];

		document.documentElement.classList.toggle('has-sidebar-mobile-expanded');
		icon.classList.toggle('fa-chevron-right');
		icon.classList.toggle('fa-chevron-left');
	});
};

launch.sidebar.submenus = () => {
	const menu = document.querySelector('.menu.is-menu-main');
	const submenus = menu.querySelectorAll('.has-dropdown-icon');

	submenus.forEach((item) => {
		item.addEventListener('click', (e) => {
			const icon = e.currentTarget
				.getElementsByClassName('dropdown-icon')[0]
				.getElementsByClassName('fas')[0];

			e.currentTarget.parentNode.classList.toggle('is-active');
			icon.classList.toggle('fa-plus');
			icon.classList.toggle('fa-minus');
		});
	});
};

/* NavBar menu mobile toggle */
// Array.from(document.getElementsByClassName('jb-navbar-menu-toggle')).forEach(el => {
  // el.addEventListener('click', e => {
    // const dropdownIcon = e.currentTarget
        // .getElementsByClassName('icon')[0]
        // .getElementsByClassName('mdi')[0]

    // document.getElementById(e.currentTarget.getAttribute('data-target')).classList.toggle('is-active')
    // dropdownIcon.classList.toggle('mdi-dots-vertical')
    // dropdownIcon.classList.toggle('mdi-close')
  // })
// })

const start = () => {
	console.log('APP STARTING');

	// const currentModule = document.querySelector('meta[name="module"]').getAttribute('content') || window.location.pathname;
	const currentModule = window.location.pathname;
	document.querySelector(`a[href='${currentModule}']`).classList.add('is-active');

	launch.sidebar.toggle();
	launch.sidebar.submenus();
};

export { start };
