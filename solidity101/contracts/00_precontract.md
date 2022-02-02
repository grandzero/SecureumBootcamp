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

<h4>Import</h4>
<p> Aynı dosya altındaki dosyayı çağırmak için :  <b>import "./x.sol";</b> </p>
<p> Github üzerinden çağırmak için :<b> import "https://github.com/owner/repo/blob/branch/path/to/Contract.sol";</b></p>

<h4>Comments</h4>
<p>Tek satır için // çoklu satır için /*...*/  </p>

<h4>State Variables</h4>
<p>State variables, storage de tutulur. Fonksiyon içinde yazılmayan tüm değişkenler state variable dir.(Bu böyle ifade edilmeyebilir )</p>

<h4> State Visibility Specifiers</h4>
Visibility basitçe değişkene başka bir yerden ulaşma durumudur. Görünür olma durumu.

public: Her yerden ulaşabiliriz.
internal: Sadece tanımlandığı kontrat ve kontrattan türeyen kontrattan ulaşabiliriz.
private: Sadece Tanımlandığı kontrattan ulaşılır.


// SPDX-License-Identifier:any string representing the license
pragma solidity 0.8.7;

contract VarVis {

    // Otomatik getter fonksiyonu oluşturulur. Dış kontratlar okuyabilir
    // Bu kontrattan türeyen kontratlar hem okur hem değiştirir
    uint public aPublicVar;

    // Bu kontrattan türeyen kontratlar hem okur hem değiştirir
    uint internal anInternalVar;

    // Sadece bu kontrattan ulaşılır.
    uint private aPrivateVar;
}

contract Demo is VarVis {

   

    function incrementPublicVar() public {
        
        aPublicVar += 1;
    }

    function incrementInternalVar() public {
       
        anInternalVar += 1;
    }

    function incrementPrivateVar() public {
        // Çalışmaz
        // aPrivateVar += 1;
    }
}

