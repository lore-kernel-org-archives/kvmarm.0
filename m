From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 03/16] KVM: arm64: Refactor kvm_arm_num_regs() for
 easier maintenance
Date: Fri, 06 Jul 2018 10:20:48 +0100
Message-ID: <87bmbk90un.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C78B2408B1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:08:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y0b-WiUdkeit for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 05:08:18 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E863B49F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:08:17 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id b188-v6so14202263wme.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jul 2018 02:20:50 -0700 (PDT)
In-reply-to: <1529593060-542-4-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IGt2bV9hcm1fbnVt
X3JlZ3MoKSBhZGRzIHRvZ2V0aGVyIHZhcmlvdXMgcGFydGlhbCByZWdpc3RlciBjb3VudHMgaW4K
PiBhIGZyZWVmb3JtIHN1bSBleHByZXNzaW9uLCB3aGljaCBtYWtlcyBpdCBoYXJkZXIgdGhhbiBu
ZWNlc3NhcnkgdG8KPiByZWFkIGRpZmZzIHRoYXQgYWRkLCBtb2RpZnkgb3IgcmVtb3ZlIGEgc2lu
Z2xlIHRlcm0gaW4gdGhlIHN1bQo+ICh3aGljaCBpcyBleHBlY3RlZCB0byB0aGUgY29tbW9uIGNh
c2UgdW5kZXIgbWFpbnRlbmFuY2UpLgo+Cj4gVGhpcyBwYXRjaCByZWZhY3RvcnMgdGhlIGNvZGUg
dG8gYWRkIHRoZSB0ZXJtIG9uZSBwZXIgbGluZSwgZm9yCj4gbWF4aW11bSByZWFkYWJpbGl0eS4K
Pgo+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgoKUmV2
aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCj4gLS0tCj4g
IGFyY2gvYXJtNjQva3ZtL2d1ZXN0LmMgfCAxMCArKysrKysrKy0tCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vZ3Vlc3QuYyBiL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMKPiBpbmRleCA1NmEwMjYw
Li40YTlkNzdjIDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2d1ZXN0LmMKPiArKysgYi9h
cmNoL2FybTY0L2t2bS9ndWVzdC5jCj4gQEAgLTIwNSw4ICsyMDUsMTQgQEAgc3RhdGljIGludCBn
ZXRfdGltZXJfcmVnKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgY29uc3Qgc3RydWN0IGt2bV9vbmVf
cmVnICpyZWcpCj4gICAqLwo+ICB1bnNpZ25lZCBsb25nIGt2bV9hcm1fbnVtX3JlZ3Moc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQo+ICB7Cj4gLQlyZXR1cm4gbnVtX2NvcmVfcmVncygpICsga3ZtX2Fy
bV9udW1fc3lzX3JlZ19kZXNjcyh2Y3B1KQo+IC0JCSsga3ZtX2FybV9nZXRfZndfbnVtX3JlZ3Mo
dmNwdSkJKyBOVU1fVElNRVJfUkVHUzsKPiArCXVuc2lnbmVkIGxvbmcgcmVzID0gMDsKPiArCj4g
KwlyZXMgKz0gbnVtX2NvcmVfcmVncygpOwo+ICsJcmVzICs9IGt2bV9hcm1fbnVtX3N5c19yZWdf
ZGVzY3ModmNwdSk7Cj4gKwlyZXMgKz0ga3ZtX2FybV9nZXRfZndfbnVtX3JlZ3ModmNwdSk7Cj4g
KwlyZXMgKz0gTlVNX1RJTUVSX1JFR1M7Cj4gKwo+ICsJcmV0dXJuIHJlczsKPiAgfQo+Cj4gIC8q
KgoKCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
