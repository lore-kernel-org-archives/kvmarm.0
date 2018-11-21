From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH v2 17/23] arm64/sve: In-kernel vector length
 availability query interface
Date: Wed, 21 Nov 2018 16:46:47 +0000
Message-ID: <87h8gaidjc.fsf@linaro.org>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-18-git-send-email-Dave.Martin@arm.com>
 <87in0qiexh.fsf@linaro.org> <20181121163525.GD3505@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 217BB4A2EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 11:46:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5xNk6UVm3T9O for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Nov 2018 11:46:50 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19E7949F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 11:46:50 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id u13-v6so6455470wmc.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 08:46:50 -0800 (PST)
In-reply-to: <20181121163525.GD3505@e103592.cambridge.arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIFdlZCwgTm92
IDIxLCAyMDE4IGF0IDA0OjE2OjQyUE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
RGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+IHdyaXRlczoKPj4KPj4gPiBLVk0gd2ls
bCBuZWVkIHRvIGludGVycm9nYXRlIHRoZSBzZXQgb2YgU1ZFIHZlY3RvciBsZW5ndGhzCj4+ID4g
YXZhaWxhYmxlIG9uIHRoZSBzeXN0ZW0uCj4+ID4KPj4gPiBUaGlzIHBhdGNoIGV4cG9zZXMgdGhl
IHJlbGV2YW50IGJpdHMgdG8gdGhlIGtlcm5lbCwgYWxvbmcgd2l0aCBhCj4+ID4gc3ZlX3ZxX2F2
YWlsYWJsZSgpIGhlbHBlciB0byBjaGVjayB3aGV0aGVyIGEgcGFydGljdWxhciB2ZWN0b3IKPj4g
PiBsZW5ndGggaXMgc3VwcG9ydGVkLgo+PiA+Cj4+ID4gdnFfdG9fYml0KCkgYW5kIGJpdF90b192
cSgpIGFyZSBub3QgaW50ZW5kZWQgZm9yIHVzZSBvdXRzaWRlIHRoZXNlCj4+ID4gZnVuY3Rpb25z
LCBzbyB0aGV5IGFyZSBnaXZlbiBhIF9fIHByZWZpeCB0byB3YXJuIHBlb3BsZSBub3QgdG8gdXNl
Cj4+ID4gdGhlbSB1bmxlc3MgdGhleSByZWFsbHkga25vdyB3aGF0IHRoZXkgYXJlIGRvaW5nLgo+
Pgo+PiBQZXJzb25hbGx5IEkgd291bGRuJ3QgaGF2ZSBib3RoZXJlZCB3aXRoIHRoZSBfXyBidXQg
d2hhdGV2ZXI6Cj4+Cj4+IFJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxp
bmFyby5vcmc+Cj4KPiBPSywgdGhhbmtzCj4KPiBJJ2xsIHByb2JhYmx5IGtlZXAgdGhlIF9fIHVu
bGVzcyBzb21lYm9keSBlbHNlIG9iamVjdHMsIGJ1dCBpZiB5b3UgZmVlbAo+IHN0cm9uZ2x5IEkg
Y291bGQgZ2V0IHJpZCBvZiBpdC4KCm5haCAtIGl0J3MganVzdCBhIHBlcnNvbmFsIG9waW5pb24u
Li4KCj4gUGVyaGFwcyBJIHNpbXBseSBzaG91bGRuJ3QgaGF2ZSBjYWxsZWQgYXR0ZW50aW9uIHRv
IGl0IGluIHRoZSBjb21taXQKPiBtZXNzYWdlIDspCgpQc3ljaG9sb2dpY2FsIHByaW1pbmcgOy0p
Cgo+Cj4gQ2hlZXJzCj4gLS0tRGF2ZQo+Cj4+Cj4+ID4KPj4gPiBTaWduZWQtb2ZmLWJ5OiBEYXZl
IE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4KPj4gPiAtLS0KPj4gPiAgYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9mcHNpbWQuaCB8IDI5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4+
ID4gIGFyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jICAgICAgfCAzNSArKysrKysrKy0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQo+PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDM3IGluc2VydGlvbnMo
KyksIDI3IGRlbGV0aW9ucygtKQo+PiA+Cj4+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20vZnBzaW1kLmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2Zwc2ltZC5oCj4+ID4g
aW5kZXggZGY3YTE0My4uYWQ2ZDJlNCAxMDA2NDQKPj4gPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2Zwc2ltZC5oCj4+ID4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9mcHNpbWQu
aAo+PiA+IEBAIC0yNCwxMCArMjQsMTMgQEAKPj4gPgo+PiA+ICAjaWZuZGVmIF9fQVNTRU1CTFlf
Xwo+PiA+Cj4+ID4gKyNpbmNsdWRlIDxsaW51eC9iaXRtYXAuaD4KPj4gPiAgI2luY2x1ZGUgPGxp
bnV4L2J1aWxkX2J1Zy5oPgo+PiA+ICsjaW5jbHVkZSA8bGludXgvYnVnLmg+Cj4+ID4gICNpbmNs
dWRlIDxsaW51eC9jYWNoZS5oPgo+PiA+ICAjaW5jbHVkZSA8bGludXgvaW5pdC5oPgo+PiA+ICAj
aW5jbHVkZSA8bGludXgvc3RkZGVmLmg+Cj4+ID4gKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgo+
PiA+Cj4+ID4gICNpZiBkZWZpbmVkKF9fS0VSTkVMX18pICYmIGRlZmluZWQoQ09ORklHX0NPTVBB
VCkKPj4gPiAgLyogTWFza3MgZm9yIGV4dHJhY3RpbmcgdGhlIEZQU1IgYW5kIEZQQ1IgZnJvbSB0
aGUgRlBTQ1IgKi8KPj4gPiBAQCAtODksNiArOTIsMzIgQEAgZXh0ZXJuIHU2NCByZWFkX3pjcl9m
ZWF0dXJlcyh2b2lkKTsKPj4gPgo+PiA+ICBleHRlcm4gaW50IF9fcm9fYWZ0ZXJfaW5pdCBzdmVf
bWF4X3ZsOwo+PiA+ICBleHRlcm4gaW50IF9fcm9fYWZ0ZXJfaW5pdCBzdmVfbWF4X3ZpcnR1YWxp
c2FibGVfdmw7Cj4+ID4gKy8qIFNldCBvZiBhdmFpbGFibGUgdmVjdG9yIGxlbmd0aHMsIGFzIHZx
X3RvX2JpdCh2cSk6ICovCj4+ID4gK2V4dGVybiBfX3JvX2FmdGVyX2luaXQgREVDTEFSRV9CSVRN
QVAoc3ZlX3ZxX21hcCwgU1ZFX1ZRX01BWCk7Cj4+ID4gKwo+PiA+ICsvKgo+PiA+ICsgKiBIZWxw
ZXJzIHRvIHRyYW5zbGF0ZSBiaXQgaW5kaWNlcyBpbiBzdmVfdnFfbWFwIHRvIFZRIHZhbHVlcyAo
YW5kCj4+ID4gKyAqIHZpY2UgdmVyc2EpLiAgVGhpcyBhbGxvd3MgZmluZF9uZXh0X2JpdCgpIHRv
IGJlIHVzZWQgdG8gZmluZCB0aGUKPj4gPiArICogX21heGltdW1fIFZRIG5vdCBleGNlZWRpbmcg
YSBjZXJ0YWluIHZhbHVlLgo+PiA+ICsgKi8KPj4gPiArc3RhdGljIGlubGluZSB1bnNpZ25lZCBp
bnQgX192cV90b19iaXQodW5zaWduZWQgaW50IHZxKQo+PiA+ICt7Cj4+ID4gKwlyZXR1cm4gU1ZF
X1ZRX01BWCAtIHZxOwo+PiA+ICt9Cj4+ID4gKwo+PiA+ICtzdGF0aWMgaW5saW5lIHVuc2lnbmVk
IGludCBfX2JpdF90b192cSh1bnNpZ25lZCBpbnQgYml0KQo+PiA+ICt7Cj4KPiBbLi4uXQoKCi0t
CkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
