From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v9 1/6] target-arm: kvm64 - introduce kvm_arm_init_debug()
Date: Fri, 20 Nov 2015 15:11:50 +0000
Message-ID: <CAFEAcA8bdjYaDiCParJt8jVe+720+tzh4CuKD2YGfHeo2UJNcQ@mail.gmail.com>
References: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org>
 <1447345251-22625-2-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-u3ACj=99NkTRsEL=2KA6LETeAmEf+5Vo03gz0GMh5Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A271E48531
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 10:11:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZmxVxx8onRQC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2015 10:11:38 -0500 (EST)
Received: from mail-yk0-f174.google.com (mail-yk0-f174.google.com
 [209.85.160.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91CED4852C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 10:11:38 -0500 (EST)
Received: by ykba77 with SMTP id a77so166064750ykb.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 07:12:21 -0800 (PST)
In-Reply-To: <CAFEAcA-u3ACj=99NkTRsEL=2KA6LETeAmEf+5Vo03gz0GMh5Zw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, qemu-arm@nongnu.org, Zhichao Huang <zhichao.huang@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjAgTm92ZW1iZXIgMjAxNSBhdCAxNTowNSwgUGV0ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVs
bEBsaW5hcm8ub3JnPiB3cm90ZToKPiBPbiAxMiBOb3ZlbWJlciAyMDE1IGF0IDE2OjIwLCBBbGV4
IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+IHdyb3RlOgo+PiBBcyB3ZSBoYXZlbid0
IGFsd2F5cyBoYWQgZ3Vlc3QgZGVidWcgc3VwcG9ydCB3ZSBuZWVkIHRvIHByb2JlIGZvciBpdC4K
Pj4gQWRkaXRpb25hbGx5IHdlIGRvbid0IGRvIHRoaXMgaW4gdGhlIHN0YXJ0LXVwIGNhcGFiaWxp
dHkgY29kZSBzbyB3ZQo+PiBkb24ndCBmYWxsIG92ZXIgb24gb2xkIGtlcm5lbHMuCj4+Cj4+IFNp
Z25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPj4gLS0t
Cj4+ICB0YXJnZXQtYXJtL2t2bTY0LmMgfCAxOCArKysrKysrKysrKysrKysrKysKPj4gIDEgZmls
ZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS90YXJnZXQtYXJt
L2t2bTY0LmMgYi90YXJnZXQtYXJtL2t2bTY0LmMKPj4gaW5kZXggY2VlYmZlYi4uZDA4Nzc5NCAx
MDA2NDQKPj4gLS0tIGEvdGFyZ2V0LWFybS9rdm02NC5jCj4+ICsrKyBiL3RhcmdldC1hcm0va3Zt
NjQuYwo+PiBAQCAtMjUsNiArMjUsMjIgQEAKPj4gICNpbmNsdWRlICJpbnRlcm5hbHMuaCIKPj4g
ICNpbmNsdWRlICJody9hcm0vYXJtLmgiCj4+Cj4+ICtzdGF0aWMgYm9vbCBoYXZlX2d1ZXN0X2Rl
YnVnOwo+PiArCj4+ICsvKioKPj4gKyAqIGt2bV9hcm1faW5pdF9kZWJ1ZygpCj4+ICsgKiBAY3M6
IENQVVN0YXRlCj4+ICsgKgo+PiArICogQ2hlY2sgZm9yIGd1ZXN0IGRlYnVnIGNhcGFiaWxpdGll
cy4KPj4gKyAqCj4+ICsgKi8KPj4gK3N0YXRpYyB2b2lkIGt2bV9hcm1faW5pdF9kZWJ1ZyhDUFVT
dGF0ZSAqY3MpCj4+ICt7Cj4+ICsgICAgaGF2ZV9ndWVzdF9kZWJ1ZyA9IGt2bV9jaGVja19leHRl
bnNpb24oY3MtPmt2bV9zdGF0ZSwKPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBLVk1fQ0FQX1NFVF9HVUVTVF9ERUJVRyk7Cj4+ICsgICAgcmV0dXJuOwo+PiAr
fQo+PiArCj4+ICBzdGF0aWMgaW5saW5lIHZvaWQgc2V0X2ZlYXR1cmUodWludDY0X3QgKmZlYXR1
cmVzLCBpbnQgZmVhdHVyZSkKPj4gIHsKPj4gICAgICAqZmVhdHVyZXMgfD0gMVVMTCA8PCBmZWF0
dXJlOwo+PiBAQCAtMTIxLDYgKzEzNyw4IEBAIGludCBrdm1fYXJjaF9pbml0X3ZjcHUoQ1BVU3Rh
dGUgKmNzKQo+PiAgICAgIH0KPj4gICAgICBjcHUtPm1wX2FmZmluaXR5ID0gbXBpZHIgJiBBUk02
NF9BRkZJTklUWV9NQVNLOwo+Pgo+PiArICAgIGt2bV9hcm1faW5pdF9kZWJ1Zyhjcyk7Cj4+ICsK
Pj4gICAgICByZXR1cm4ga3ZtX2FybV9pbml0X2NwcmVnX2xpc3QoY3B1KTsKPj4gIH0KPgo+IEkg
YXNzdW1lIGluIHByYWN0aWNlIHRoZSBrZXJuZWwgZ3VhcmFudGVlcyB0aGF0IGVpdGhlciBhbGwK
PiBDUFVzIGhhdmUgdGhlIFNFVF9HVUVTVF9ERUJVRyBjYXAsIG9yIG5vbmUgZG8gOi0pCj4KPiBS
ZXZpZXdlZC1ieTogUGV0ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5hcm8ub3JnPgoKLi4u
ZXhjZXB0IEkndmUganVzdCBub3RpY2VkIHRoYXQgbm90aGluZyBlbHNlIGluIHRoaXMgcGF0Y2hz
ZXQKZXZlciByZWFkcyB0aGUgaGF2ZV9ndWVzdF9kZWJ1ZyBib29sIHdlIGp1c3Qgc2V0LCBzbyB3
aGF0IGlzCnRoZSBwdXJwb3NlIG9mIHRoaXMgcGF0Y2g/Cgp0aGFua3MKLS0gUE1NCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
