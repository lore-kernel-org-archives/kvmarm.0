From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH 1/6] libcflat: add PRI(dux)32 format types
Date: Thu, 12 Jan 2017 18:01:49 +0000
Message-ID: <87eg082m42.fsf@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-2-alex.bennee@linaro.org>
 <4286b719-ff75-d2cd-68b5-cb9d9bb89553@redhat.com>
 <20170112165629.nbczamlqlpsqaauh@hawk.localdomain>
 <87fuko2o4e.fsf@linaro.org> <144fdce4-ddd4-0c93-296b-44aeec57c664@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FC8402AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 13:00:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WnkBOQSjUpS5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 13:00:06 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F97840194
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 13:00:06 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id c85so30659359wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:01:52 -0800 (PST)
In-reply-to: <144fdce4-ddd4-0c93-296b-44aeec57c664@redhat.com>
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ClBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+IHdyaXRlczoKCj4gT24gMTIvMDEv
MjAxNyAxODoxOCwgQWxleCBCZW5uw6llIHdyb3RlOgo+Pj4gQWx0aG91Z2ggSSBmZWVsIHRoZXJl
IHNob3VsZCBiZSBhIGNvbXBpbGVyIG1hY3JvIHdheSB0byBkbyB0aGlzIHdpdGhvdXQKPj4+IGEg
bmVlZCBmb3IgY29uZmlndXJlL21ha2VmaWxlIHRyaWNrZXJ5IGF0IGFsbC4uLgo+Pgo+PiBJIGRp
ZCBhc2sgb3VyIHRvb2xjaGFpbiBib2RzLiBUaGV5IHN0YXJ0ZWQgZ29pbmcgb24gYWJvdXQgcG90
ZW50aWFsCj4+IHNvbHV0aW9ucyB1c2luZyBfR2VuZXJpYyBidXQgSSBmZWFyIHRoYXQgbWlnaHQg
YmUgd29yc2UgaW4gdGhpcyBjYXNlIQo+Cj4gSSBkb24ndCB0aGluayBfR2VuZXJpYyBjYW4gZG8g
c3RyaW5nIGNvbmNhdGVuYXRpb24sIGNhbiBpdD8KPgo+IGludHR5cGVzLmggaXMgbm90IHBhcnQg
b2YgdGhlIHNldCBvZiBmcmVlc3RhbmRpbmcgaGVhZGVycywgb25seSBzdGRpbnQuaAo+IGlzLiAg
V2hvIGlzIHByb3ZpZGluZyBzdGRpbnQuaCBpbiB5b3VyIGNhc2U/CgovdXNyL2xpYi9nY2MvYXJt
LW5vbmUtZWFiaS81LjQuMS9pbmNsdWRlL3N0ZGludC5oCgppcyBwYXJ0IG9mIHRoZSBjb21waWxl
ciBwYWNrYWdlIGFsdGhvdWdoIGl0IGNhbiBqdXN0IGluY2x1ZGUgdGhlIGxpYgpzdGRpbnQuaCBp
ZiBpdCBpcyB0aGVyZToKCiAgI2lmbmRlZiBfR0NDX1dSQVBfU1RESU5UX0gKICAjaWYgX19TVERD
X0hPU1RFRF9fCiAgIyBpZiBkZWZpbmVkIF9fY3BsdXNwbHVzICYmIF9fY3BsdXNwbHVzID49IDIw
MTEwM0wKICAjICB1bmRlZiBfX1NURENfTElNSVRfTUFDUk9TCiAgIyAgZGVmaW5lIF9fU1REQ19M
SU1JVF9NQUNST1MKICAjICB1bmRlZiBfX1NURENfQ09OU1RBTlRfTUFDUk9TCiAgIyAgZGVmaW5l
IF9fU1REQ19DT05TVEFOVF9NQUNST1MKICAjIGVuZGlmCiAgIyBpbmNsdWRlX25leHQgPHN0ZGlu
dC5oPgogICNlbHNlCiAgIyBpbmNsdWRlICJzdGRpbnQtZ2NjLmgiCiAgI2VuZGlmCiAgI2RlZmlu
ZSBfR0NDX1dSQVBfU1RESU5UX0gKICAjZW5kaWYKClNvIHVzaW5nIGludHR5cGVzIHdlIHdvdWxk
IGdldDoKCj5hcm0tbm9uZS1lYWJpLWdjYyAuL3Rlc3QuYyAtRSB8IGdyZXAgdHlwZWRlZiB8IGdy
ZXAgdWludDMyCnR5cGVkZWYgbG9uZyB1bnNpZ25lZCBpbnQgX191aW50MzJfdDsKdHlwZWRlZiBf
X3VpbnQzMl90IHVpbnQzMl90IDsKCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
