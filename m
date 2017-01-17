From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH 6/6] run_tests: allow passing of options to
 QEMU
Date: Tue, 17 Jan 2017 12:07:49 +0000
Message-ID: <87wpdtubxm.fsf@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-7-alex.bennee@linaro.org>
 <20170112173204.ufd2ggw7iz7xv772@hawk.localdomain>
 <648638bd-a90e-ee98-337a-223ed533f53a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4615240419
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 07:06:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fu86BfdQiEmo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 07:06:01 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBDC5402EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 07:06:00 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id r126so197855234wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 04:07:53 -0800 (PST)
In-reply-to: <648638bd-a90e-ee98-337a-223ed533f53a@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ClBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+IHdyaXRlczoKCj4gT24gMTIvMDEv
MjAxNyAxODozMiwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+Pj4KPj4+ICsjIEFueSBvcHRpb25zIGxl
ZnQgZm9yIFFFTVU/Cj4+PiArc2hpZnQgJCgoT1BUSU5ELTEpKQo+Pj4gK2lmIFsgIiQjIiAtZ3Qg
IDAgXTsgdGhlbgo+Pj4gKyAgICBleHRyYV9vcHRzPSIkQCIKPj4+ICtmaQo+PiBXZSBjYW4gdW5j
b25kaXRpb25hbGx5IGRvIHRoZSBleHRyYV9vcHRzPSIkQCIsIGV4dHJhX29wdHMgd2lsbCBqdXN0
Cj4+IGJlIG51bGwgaW4gdGhlIGNhc2UgdGhlcmUgYXJlbid0IG1vcmUgYXJncywgbGlrZSBpdCB3
YXMgYmVmb3JlLgo+Cj4gZXh0cmFfb3B0cyBpcyBub3QgYW4gYXJyYXksIHNvIHRoaXMgd291bGQg
bWVzcyB1cCBvcHRpb25zIHRoYXQgY29udGFpbgo+IHNwYWNlcy4gIChBbGV4J3MgcGF0Y2ggaW4g
Z2VuZXJhbCwgbm90IHlvdXIgdHdlYWspLgoKSXMgaXQgd29ydGggdHJlYXRpbmcgZXh0cmFfb3B0
cyBhcyBhbiBhcnJheT8KCj4KPiBQYW9sbwo+Cj4+PiArCj4+PiAgUlVOVElNRV9sb2dfc3RkZXJy
ICgpIHsgY2F0ID4+IHRlc3QubG9nOyB9Cj4+PiAgUlVOVElNRV9sb2dfc3Rkb3V0ICgpIHsKPj4+
ICAgICAgaWYgWyAiJFBSRVRUWV9QUklOVF9TVEFDS1MiID0gInllcyIgXTsgdGhlbgo+Pj4gQEAg
LTU5LDQgKzY4LDQgQEAgUlVOVElNRV9sb2dfc3Rkb3V0ICgpIHsKPj4+ICBjb25maWc9JFRFU1Rf
RElSL3VuaXR0ZXN0cy5jZmcKPj4+ICBybSAtZiB0ZXN0LmxvZwo+Pj4gIHByaW50ZiAiQlVJTERf
SEVBRD0kKGNhdCBidWlsZC1oZWFkKVxuXG4iID4gdGVzdC5sb2cKPj4+IC1mb3JfZWFjaF91bml0
dGVzdCAkY29uZmlnIHJ1bgo+Pj4gK2Zvcl9lYWNoX3VuaXR0ZXN0ICRjb25maWcgcnVuICIkZXh0
cmFfb3B0cyIKCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
