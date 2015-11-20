From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v9 1/6] target-arm: kvm64 - introduce kvm_arm_init_debug()
Date: Fri, 20 Nov 2015 15:05:17 +0000
Message-ID: <CAFEAcA-u3ACj=99NkTRsEL=2KA6LETeAmEf+5Vo03gz0GMh5Zw@mail.gmail.com>
References: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org>
 <1447345251-22625-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C85DD4852C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 10:04:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DDsX8WHqm9Xc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2015 10:04:53 -0500 (EST)
Received: from mail-yk0-f174.google.com (mail-yk0-f174.google.com
 [209.85.160.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5134419D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 10:04:53 -0500 (EST)
Received: by ykdv3 with SMTP id v3so166019902ykd.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 07:05:36 -0800 (PST)
In-Reply-To: <1447345251-22625-2-git-send-email-alex.bennee@linaro.org>
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

T24gMTIgTm92ZW1iZXIgMjAxNSBhdCAxNjoyMCwgQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBs
aW5hcm8ub3JnPiB3cm90ZToKPiBBcyB3ZSBoYXZlbid0IGFsd2F5cyBoYWQgZ3Vlc3QgZGVidWcg
c3VwcG9ydCB3ZSBuZWVkIHRvIHByb2JlIGZvciBpdC4KPiBBZGRpdGlvbmFsbHkgd2UgZG9uJ3Qg
ZG8gdGhpcyBpbiB0aGUgc3RhcnQtdXAgY2FwYWJpbGl0eSBjb2RlIHNvIHdlCj4gZG9uJ3QgZmFs
bCBvdmVyIG9uIG9sZCBrZXJuZWxzLgo+Cj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxh
bGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+IC0tLQo+ICB0YXJnZXQtYXJtL2t2bTY0LmMgfCAxOCAr
KysrKysrKysrKysrKysrKysKPiAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKykKPgo+
IGRpZmYgLS1naXQgYS90YXJnZXQtYXJtL2t2bTY0LmMgYi90YXJnZXQtYXJtL2t2bTY0LmMKPiBp
bmRleCBjZWViZmViLi5kMDg3Nzk0IDEwMDY0NAo+IC0tLSBhL3RhcmdldC1hcm0va3ZtNjQuYwo+
ICsrKyBiL3RhcmdldC1hcm0va3ZtNjQuYwo+IEBAIC0yNSw2ICsyNSwyMiBAQAo+ICAjaW5jbHVk
ZSAiaW50ZXJuYWxzLmgiCj4gICNpbmNsdWRlICJody9hcm0vYXJtLmgiCj4KPiArc3RhdGljIGJv
b2wgaGF2ZV9ndWVzdF9kZWJ1ZzsKPiArCj4gKy8qKgo+ICsgKiBrdm1fYXJtX2luaXRfZGVidWco
KQo+ICsgKiBAY3M6IENQVVN0YXRlCj4gKyAqCj4gKyAqIENoZWNrIGZvciBndWVzdCBkZWJ1ZyBj
YXBhYmlsaXRpZXMuCj4gKyAqCj4gKyAqLwo+ICtzdGF0aWMgdm9pZCBrdm1fYXJtX2luaXRfZGVi
dWcoQ1BVU3RhdGUgKmNzKQo+ICt7Cj4gKyAgICBoYXZlX2d1ZXN0X2RlYnVnID0ga3ZtX2NoZWNr
X2V4dGVuc2lvbihjcy0+a3ZtX3N0YXRlLAo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgS1ZNX0NBUF9TRVRfR1VFU1RfREVCVUcpOwo+ICsgICAgcmV0dXJuOwo+
ICt9Cj4gKwo+ICBzdGF0aWMgaW5saW5lIHZvaWQgc2V0X2ZlYXR1cmUodWludDY0X3QgKmZlYXR1
cmVzLCBpbnQgZmVhdHVyZSkKPiAgewo+ICAgICAgKmZlYXR1cmVzIHw9IDFVTEwgPDwgZmVhdHVy
ZTsKPiBAQCAtMTIxLDYgKzEzNyw4IEBAIGludCBrdm1fYXJjaF9pbml0X3ZjcHUoQ1BVU3RhdGUg
KmNzKQo+ICAgICAgfQo+ICAgICAgY3B1LT5tcF9hZmZpbml0eSA9IG1waWRyICYgQVJNNjRfQUZG
SU5JVFlfTUFTSzsKPgo+ICsgICAga3ZtX2FybV9pbml0X2RlYnVnKGNzKTsKPiArCj4gICAgICBy
ZXR1cm4ga3ZtX2FybV9pbml0X2NwcmVnX2xpc3QoY3B1KTsKPiAgfQoKSSBhc3N1bWUgaW4gcHJh
Y3RpY2UgdGhlIGtlcm5lbCBndWFyYW50ZWVzIHRoYXQgZWl0aGVyIGFsbApDUFVzIGhhdmUgdGhl
IFNFVF9HVUVTVF9ERUJVRyBjYXAsIG9yIG5vbmUgZG8gOi0pCgpSZXZpZXdlZC1ieTogUGV0ZXIg
TWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5hcm8ub3JnPgoKdGhhbmtzCi0tIFBNTQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
