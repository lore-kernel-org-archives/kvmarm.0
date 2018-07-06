From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
Date: Fri, 06 Jul 2018 11:11:39 +0100
Message-ID: <87601s8yhw.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <87h8lc93jc.fsf@linaro.org>
 <20180706090534.GD26019@e103592.cambridge.arm.com>
 <87d0w090vv.fsf@linaro.org>
 <CAFEAcA8NQFvHzgCvCQBmq7us4PvqSFK2Le=pMiz5dE4D3WGXdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAFFA4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:59:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uXVkbIpKL0tn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 05:59:08 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 817F24065F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:59:08 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id p11-v6so13879278wmc.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jul 2018 03:11:41 -0700 (PDT)
In-reply-to: <CAFEAcA8NQFvHzgCvCQBmq7us4PvqSFK2Le=pMiz5dE4D3WGXdQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

ClBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBPbiA2
IEp1bHkgMjAxOCBhdCAxMDoyMCwgQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3Jn
PiB3cm90ZToKPj4gRm9yIHRoZSBtb3N0IHBhcnQgaW4gUUVNVSB3aXRoIEtWTSB3ZSBqdXN0IHRy
ZWF0IHRoZSBsaXN0IG9mIHJlZ2lzdGVycwo+PiB3ZSBnZXQgZnJvbSB0aGUgT1MgYXMgYW4gb3Bh
cXVlIGJsb2Igb2YgdGhpbmdzIHdlIHNhdmUgdG8gbWVtb3J5IGFuZAo+PiBwYXNzIGJhY2suCj4K
PiBUaGlzIGlzIHNwZWNpZmljYWxseSBub3QgdGhlIGNhc2UgZm9yIHRoZSBTVkUgcmVnaXN0ZXJz
IC0tIHdlCj4gd2lsbCBuZWVkIGV4dHJhIGNvZGUgdG8gaGFuZGxlIHRoZW0uIChUaGUgY3VycmVu
dCBjb2RlIG9ubHkKPiBhbGxvd3MgZm9yIHRoZSBwb3NzaWJpbGl0eSBvZiA2NC1iaXQgcmVnaXN0
ZXJzLCBzbyBpZiB3ZSdkCj4gYWxsb3dlZCB0aGUga2VybmVsIHRvIGhhbmQgaXQgdGhlIGxhcmdl
ciBTVkUgcmVnaXN0ZXJzIGl0IHdvdWxkCj4ganVzdCBoYXZlIGZhbGxlbiBvdmVyLiBUaGlzIGlz
IHdoeSBRRU1VIG5lZWRzIHRvIHNwZWNpZmljYWxseQo+IGVuYWJsZSBTVkUgdmlhIHRoZSBWQ1BV
X0lOSVQgY2FsbC4pCgpBaGggcmlnaHQuIFNvIGN1cnJlbnRseSBib3RoIHRoZSBLVk1fR0VUX1JF
R19MSVNUIGFuZCB0aGUgY29yZSByZWdpc3RlcnMKdXNlIEtWTV9HRVQvU0VUX09ORV9SRUcgd2hp
Y2ggY2VydGFpbmx5IHdvbid0IGRvIHRoZSB0cmljay4gU28gSSBndWVzcwp3ZSBuZWVkIGFub3Ro
ZXIgSU9DVEwgKG9yIHRvIGVuaGFuY2UgdGhlIGN1cnJlbnQgb25lKSBhbmQgYSBLVk0KY2FwYWJp
bGl0eSBiaXQgYXMgd2VsbD8KCj4KPiB0aGFua3MKPiAtLSBQTU0KCgotLQpBbGV4IEJlbm7DqWUK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
