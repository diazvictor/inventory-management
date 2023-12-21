/**!
 * @package   Inventory Management
 * @filename  form.src.js
 * @version   1.0
 * @author    Díaz Urbaneja Víctor Eduardo Diex <diazvictor@tutamail.com>
 * @date      07.12.2023 02:34:12 -04
 */

import * as app from '../../common/common.js';
import BulmaTagsInput from '@creativebulma/bulma-tagsinput';

BulmaTagsInput.attach('input[data-type="tags"], input[type="tags"], select[data-type="tags"], select[type="tags"]', {
	noResultsLabel: 'No results',
	removable: true,
	selectable: false,
	tagClass: 'is-rounded',
	trim: true
});

app.start();
