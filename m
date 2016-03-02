From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 8/8] arm64: kvm: Check support for AArch32 for 32bit
 guests
Date: Wed, 2 Mar 2016 10:22:39 +0000
Message-ID: <56D6BEEF.3000208@arm.com>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
 <1456393968-17386-9-git-send-email-suzuki.poulose@arm.com>
 <56D6AD72.8010108@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F1341145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 05:15:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6dJn5zFUlCwN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2016 05:15:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA41410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 05:15:33 -0500 (EST)
In-Reply-To: <56D6AD72.8010108@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, ynorov@caviumnetworks.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gMDIvMDMvMTYgMDk6MDgsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyNS8wMi8xNiAwOTo1
MiwgU3V6dWtpIEsgUG91bG9zZSB3cm90ZToKCj4+IEkgcmVhbGx5IHdhbnRlZCB0byBwYXNzIGt2
bV92Y3B1IGRvd24gdG8gdGhlIGhlbHBlcnMuIEJ1dCB0aGVuLCBJIGNhbid0Cj4+IGRlZmluZSB0
aGUgYXJjaCBzcGVjaWZpYyBoZWxwZXIgaW4gYXNtL2t2bV9ob3N0LmggZHVlIHRvIGxhY2sgb2Yg
a3ZtX3ZjcHUncwo+PiBkZWZpbml0aW9uIHlldDoKPj4KPj4gICBJbiBmaWxlIGluY2x1ZGVkIGZy
b20gaW5jbHVkZS9saW51eC9rdm1faG9zdC5oOjM1OjAsCj4+ICAgICAgICAgICAgICAgICAgICBm
cm9tIGFyY2gvYXJtNjQva2VybmVsL2FzbS1vZmZzZXRzLmM6MjQ6Cj4+ICAgLi9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2t2bV9ob3N0Lmg6IEluIGZ1bmN0aW9uIOKAmGt2bV9hcmNoX3ZjcHVfdmFs
aWRhdGVfZmVhdHVyZXPigJk6Cj4+ICAgLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0
Lmg6MzQ0OjQ4OiBlcnJvcjogZGVyZWZlcmVuY2luZyBwb2ludGVyIHRvIGluY29tcGxldGUgdHlw
ZQo+PiAgICAgcmV0dXJuICAhdGVzdF9iaXQoS1ZNX0FSTV9WQ1BVX0VMMV8zMkJJVCwgdmNwdS0+
YXJjaC5mZWF0dXJlcykgfHwKPgo+IFdoeSBkb24ndCB5b3UganVzdCBoYXZlIHRoZSBwcm90b3R5
cGUgaW4ga3ZtX2hvc3QuaCwgYW5kIG1vdmUgdGhlIGFjdHVhbAo+IGltcGxlbWVudGF0aW9uIHRv
IHNvbWV0aGluZyBsaWtlIGd1ZXN0LmM/IEJ1dCBJIHRoaW5rIHRoZXJlIGlzIGEgYmV0dGVyCj4g
YXBwcm9hY2gsIHNlZSBiZWxvdy4KCkkgdGhvdWdodCBpdCB3b3VsZCBiZXR0ZXIgYmUgYSBzdGF0
aWMgaW5saW5lLiBCdXQsIHRoZSBHQ0MgY2FuIGRvIHRoYXQsIHNpbGx5IG1lIDopCgo+Cj4gVGhp
cyBpcyByZWFsbHkgY29udm9sdXRlZCAoaXQgdG9vayBtZSA1IG1pbnV0ZXMgc3RhcmluZyBhdCB0
aGUKPiBleHByZXNzaW9uIGFuZCByZW1lbWJlcmluZyB0aGF0IEFBcmNoMzIgRUwxIGltcGxpZXMg
QUFyY2gzMiBFTDAgdG8gZ2V0IGl0KS4KPgo+IE5vdywgd2UgYWxyZWFkeSBoYXZlIGt2bV9yZXNl
dF92Y3B1KCkgdGhhdCB2YWxpZGF0ZXMgQUFyY2gzMiBzdXBwb3J0LiBJdAo+IHdvdWxkIHByb2Jh
Ymx5IGJlIGJldHRlciB0byBtb3ZlIHRoaW5ncyB0aGVyZS4gVGhvdWdodHM/CgpEZWZpbml0ZWx5
LiBJIG92ZXJsb29rZWQgdGhlIGZ1bmN0aW9uIG5hbWUgdG8gZG8gc29tZXRoaW5nCnNwZWNpZmlj
IHRvIHJlc2V0dGluZyB0aGUgQ1BVIHRoYW4gZG9pbmcgc29tZSBjaGVja3MgOiguCkkgd2lsbCBy
ZXNwaW4gaXQuCgpDaGVlcnMKU3V6dWtpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
