From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH kvm-unit-tests v8 03/10] arm/arm64: add some delay routines
Date: Tue, 13 Dec 2016 17:09:33 +0000
Message-ID: <874m27u56a.fsf@linaro.org>
References: <20161208175030.12269-1-drjones@redhat.com>
 <20161208175030.12269-4-drjones@redhat.com> <8760mnu6ga.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA07D4028D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2016 12:08:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I4anwCEY98+P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2016 12:08:28 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8901740284
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2016 12:08:28 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id f82so127906733wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2016 09:09:35 -0800 (PST)
In-reply-to: <8760mnu6ga.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CkFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBBbmRyZXcg
Sm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4gd3JpdGVzOgo+Cj4+IEFsbG93IGEgdGhyZWFkIHRv
IHdhaXQgc29tZSBzcGVjaWZpZWQgYW1vdW50IG9mIHRpbWUuIENhbgo+PiBzcGVjaWZ5IGluIGN5
Y2xlcywgdXNlY3MsIGFuZCBtc2Vjcy4KPHNuaXA+Cj4+IGRpZmYgLS1naXQgYS9saWIvYXJtL2Fz
bS9wcm9jZXNzb3IuaCBiL2xpYi9hcm0vYXNtL3Byb2Nlc3Nvci5oCj4+IGluZGV4IDZiMGQzNmI4
NzgxNy4uODU3YmRkOTZhM2NjIDEwMDY0NAo+PiAtLS0gYS9saWIvYXJtL2FzbS9wcm9jZXNzb3Iu
aAo+PiArKysgYi9saWIvYXJtL2FzbS9wcm9jZXNzb3IuaAo+PiBAQCAtNyw2ICs3LDcgQEAKPj4g
ICAqLwo+PiAgI2luY2x1ZGUgPGFzbS9wdHJhY2UuaD4KPj4gICNpbmNsdWRlIDxhc20vc3lzcmVn
Lmg+Cj4+ICsjaW5jbHVkZSA8YXNtL2JhcnJpZXIuaD4KPgo+IEhtbSB0aGlzIGZhaWxzIHRvIGFw
cGx5IGNsZWFubHkgdG8gbWFzdGVyIGFuZCBkb2Vzbid0IGJ1aWxkIGFzIHN5c3JlZy5oCj4gaXNu
J3QgaW4gbXkgdHJlZS4gV2hhdCBoYXBwZW5lZCB0byBpdD8KPHNuaXA+CgpBaGggSSBtaXNzZWQg
dGhpcyBpcyBiYXNlZCBvbiBhcm0vbmV4dAoKLS0KQWxleCBCZW5uw6llCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
