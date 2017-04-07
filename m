From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC kvm-unit-tests PATCH 9/8] Makefiles: Fix up the powerpc
 build include and link paths
Date: Fri, 07 Apr 2017 09:02:01 +0100
Message-ID: <87o9w8abnq.fsf@linaro.org>
References: <20170406190727.5624-9-alex.bennee@linaro.org>
 <1491548290-11401-1-git-send-email-thuth@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 091E240C25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 03:59:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XvAS7dfZ3EuD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Apr 2017 03:59:42 -0400 (EDT)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95EB540C1D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 03:59:42 -0400 (EDT)
Received: by mail-wr0-f179.google.com with SMTP id c55so21879850wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Apr 2017 01:01:59 -0700 (PDT)
In-reply-to: <1491548290-11401-1-git-send-email-thuth@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

ClRob21hcyBIdXRoIDx0aHV0aEByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IFRoZSBjaGFuZ2VzIGZv
ciBvdXQtb2YtdHJlZSBidWlsZHMgYXJlIGhlcmUgcHJldHR5IG11Y2ggdGhlIHNhbWUKPiBhcyBm
b3IgdGhlIEFSTSBNYWtlZmlsZS5jb21tb24uCj4KPiBTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgSHV0
aCA8dGh1dGhAcmVkaGF0LmNvbT4KCkl0IHdhcyBvbmx5IHdoZW4gSSBwb3N0ZWQgSSByZWFsaXNl
ZCB0aGF0IHRoZXJlIHdhcyBvbmx5IG9uZQphcmNoaXRlY3R1cmUgbGVmdCAodG9vIHVzZWQgdG8g
UUVNVXMgbXVsdGl0dWRlKS4gSSBkaWRuJ3QgaW50ZW5kIGZvcgpQb3dlclBDIHRvIGJlIHRoZSBs
YXN0IHB1cHB5IGluIHRoZSBzaG9wIQoKVGhhbmtzIGZvciB5b3UgcGF0Y2guIEFwcGxpZWQgOy0p
Cgo+IC0tLQo+ICBwb3dlcnBjL01ha2VmaWxlLmNvbW1vbiB8IDE2ICsrKysrKysrKystLS0tLS0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4KPiBk
aWZmIC0tZ2l0IGEvcG93ZXJwYy9NYWtlZmlsZS5jb21tb24gYi9wb3dlcnBjL01ha2VmaWxlLmNv
bW1vbgo+IGluZGV4IGU1MzZmZmUuLjFmYmNhZmIgMTAwNjQ0Cj4gLS0tIGEvcG93ZXJwYy9NYWtl
ZmlsZS5jb21tb24KPiArKysgYi9wb3dlcnBjL01ha2VmaWxlLmNvbW1vbgo+IEBAIC0xMiw3ICsx
MiwxMCBAQCB0ZXN0cy1jb21tb24gPSBcCj4gIAkkKFRFU1RfRElSKS90bS5lbGYgXAo+ICAJJChU
RVNUX0RJUikvc3Bycy5lbGYKPgo+IC10ZXN0cy1hbGwgPSAkKHRlc3RzLWNvbW1vbikgJCh0ZXN0
cykKPiArc2NyaXB0cy1jb21tb24gKz0gJChURVNUX0RJUikvcnVuCj4gK3NjcmlwdHMtY29tbW9u
ICs9ICQoVEVTVF9ESVIpL3VuaXR0ZXN0cy5jZmcKPiArCj4gK3Rlc3RzLWFsbCA9ICQodGVzdHMt
Y29tbW9uKSAkKHRlc3RzKSAkKHNjcmlwdHNfY29tbW9uKQo+ICBhbGw6ICQoVEVTVF9ESVIpL2Jv
b3Rfcm9tLmJpbiAkKHRlc3RzLWFsbCkKPgo+ICAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKPiBAQCAtMjEsMTQgKzI0LDE0
IEBAIENGTEFHUyArPSAtc3RkPWdudTk5Cj4gIENGTEFHUyArPSAtZmZyZWVzdGFuZGluZwo+ICBD
RkxBR1MgKz0gLVdleHRyYQo+ICBDRkxBR1MgKz0gLU8yCj4gLUNGTEFHUyArPSAtSSBsaWIgLUkg
bGliL2xpYmZkdAo+ICtDRkxBR1MgKz0gLUkgJChTUkNESVIpL2xpYiAtSSAkKFNSQ0RJUikvbGli
L2xpYmZkdCAtSSBsaWIKPiAgQ0ZMQUdTICs9IC1XYSwtbXJlZ25hbWVzCj4KPiAgIyBXZSB3YW50
IHRvIGtlZXAgaW50ZXJtZWRpYXRlIGZpbGVzCj4gIC5QUkVDSU9VUzogJS5vCj4KPiAgYXNtLW9m
ZnNldHMgPSBsaWIvJChBUkNIKS9hc20tb2Zmc2V0cy5oCj4gLWluY2x1ZGUgc2NyaXB0cy9hc20t
b2Zmc2V0cy5tYWsKPiAraW5jbHVkZSAkKFNSQ0RJUikvc2NyaXB0cy9hc20tb2Zmc2V0cy5tYWsK
Pgo+ICBjZmxhdG9ianMgKz0gbGliL3V0aWwubwo+ICBjZmxhdG9ianMgKz0gbGliL2FsbG9jLm8K
PiBAQCAtNDQsMTAgKzQ3LDExIEBAIGNmbGF0b2JqcyArPSBsaWIvcG93ZXJwYy9zbXAubwo+ICBG
TEFUTElCUyA9ICQobGliY2ZsYXQpICQoTElCRkRUX2FyY2hpdmUpCj4gICUuZWxmOiBDRkxBR1Mg
Kz0gJChhcmNoX0NGTEFHUykKPiAgJS5lbGY6IExERkxBR1MgPSAkKGFyY2hfTERGTEFHUykgLW5v
c3RkbGliIC1waWUgLW4KPiAtJS5lbGY6ICUubyAkKEZMQVRMSUJTKSBwb3dlcnBjL2ZsYXQubGRz
ICQoY3N0YXJ0Lm8pICQocmVsb2MubykKPiAtCSQoQ0MpICQoQ0ZMQUdTKSAtYyAtbyAkKEA6LmVs
Zj0uYXV4Lm8pIGxpYi9hdXhpbmZvLmMgLURQUk9HTkFNRT1cIiRAXCIKPiArJS5lbGY6ICUubyAk
KEZMQVRMSUJTKSAkKFNSQ0RJUikvcG93ZXJwYy9mbGF0LmxkcyAkKGNzdGFydC5vKSAkKHJlbG9j
Lm8pCj4gKwkkKENDKSAkKENGTEFHUykgLWMgLW8gJChAOi5lbGY9LmF1eC5vKSAkKFNSQ0RJUikv
bGliL2F1eGluZm8uYyBcCj4gKwkJLURQUk9HTkFNRT1cIiRAXCIKPiAgCSQoTEQpICQoTERGTEFH
UykgLW8gJEAgXAo+IC0JCS1UIHBvd2VycGMvZmxhdC5sZHMgLS1idWlsZC1pZD1ub25lIFwKPiAr
CQktVCAkKFNSQ0RJUikvcG93ZXJwYy9mbGF0LmxkcyAtLWJ1aWxkLWlkPW5vbmUgXAo+ICAJCSQo
ZmlsdGVyICUubywgJF4pICQoRkxBVExJQlMpICQoQDouZWxmPS5hdXgubykKPiAgCSQoUk0pICQo
QDouZWxmPS5hdXgubykKPiAgCUBlY2hvIC1uIENoZWNraW5nICRAIGZvciB1bnN1cHBvcnRlZCBy
ZWxvYyB0eXBlcy4uLgoKCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
