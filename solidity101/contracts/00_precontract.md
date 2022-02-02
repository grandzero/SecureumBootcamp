<h4>//SPDX License Identifier</h4>
<p>Genelde  solidity dosyalarının tepesinde // SPDX-License-Identifier: MIT  ifadesini görürüz. Bu kodu yazan kişinin, kodun 3.kişiler tarafından
kullanılmasına ilişkin bildirimi gösterir. Şöyle ki; "https://spdx.org/licenses/MIT.html" sayfası üzerinde bu kodun sınırsız kullanılacağı belirtilmektedir.</p>
<p>Uniswap v3 de kodlara bakarsanız "// SPDX-License-Identifier: BUSL-1.1 " ifadesini görürsünüz. https://spdx.org/licenses/BUSL-1.1.html sayfası üzerinde bu kodun 3. kişiler tarafından
tekrar kullanılamayacağı açıkca belirtilir.</p>

<h4>Pragmas</h4>
<p>Pragma, Solidity'in compiler sürümünü ifade eder. Bu yazının yazıldığı tarihte (02.02.2022) v0.8.11 versiyonu kullanılmaktaydı.</p>
<p> v0.8.11 = x.y.z ise; "y" Büyük değişiklik yapılan versiyonları ve "z" her büyük değişikliğinin içindeki küçük değişikleri belirtmek için kullanılır.</p>
<p> v0.8.11 ile birlikte "ABI Coder Version" otomatik olarak solidity dosyasına eklenmektedir. Önceki yıllarda bunu belirtmek zorundaydınız.</p>
<p> ^ işareti şu anlama gelir : pragma solidity ^0.8.7; 0.8.7 ve sonrasındaki tüm sürümler! </p>
