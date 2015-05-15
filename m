From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 03/12] KVM: arm64: guest debug, define API headers
Date: Fri, 15 May 2015 16:17:46 +0100
Message-ID: <CAFEAcA8ZpndRyT84ta2r4bPTE1uGTN1XTfMpUn8qW022ben3BQ@mail.gmail.com>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-4-git-send-email-alex.bennee@linaro.org>
 <20150515144423.GA23652@leverpostej> <874mndlvny.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFF6F51745
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 11:08:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1y2-sabtM0Zx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 11:08:56 -0400 (EDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
 [209.85.213.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C79F5173C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 11:08:55 -0400 (EDT)
Received: by igbyr2 with SMTP id yr2so224361085igb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 08:18:07 -0700 (PDT)
In-Reply-To: <874mndlvny.fsf@linaro.org>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "r65777@freescale.com" <r65777@freescale.com>, Will Deacon <Will.Deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "bp@suse.de" <bp@suse.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMTUgTWF5IDIwMTUgYXQgMTY6MTQsIEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4gd3JvdGU6Cj4KPiBNYXJrIFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0uY29tPiB3cml0
ZXM6Cj4KPj4gT24gRnJpLCBNYXkgMTUsIDIwMTUgYXQgMDM6Mjc6MDZQTSArMDEwMCwgQWxleCBC
ZW5uw6llIHdyb3RlOgo+Pj4gKy8qCj4+PiArICogU2VlIHY4IEFSTSBBUk0gRDcuMzogRGVidWcg
UmVnaXN0ZXJzCj4+PiArICoKPj4+ICsgKiBUaGUgY29udHJvbCByZWdpc3RlcnMgYXJlIGFyY2hp
dGVjdHVyYWxseSBkZWZpbmVkIGFzIDMyIGJpdHMgYnV0IGFyZQo+Pj4gKyAqIHN0b3JlZCBhcyA2
NCBiaXQgdmFsdWVzIGFsb25nc2lkZSB0aGUgdmFsdWUgcmVnaXN0ZXJzLiBUaGlzIGlzIGRvbmUK
Pj4KPj4gU3RhbGUgY29tbWVudD8gVGhleSdyZSBzdG9yZWQgYXMgX191MzIgYmVsb3cuCj4KPiBH
YWggeWVzIGl0IGlzLgo+Cj4+IEl0J3MgcG9zc2libGUgdGhhdCB0aGUgcmVnaXN0ZXJzIGNvdWxk
IGdyb3cgaW4gZnV0dXJlIGFzIGhhcHBlbmVkIGluIHRoZQo+PiBjYXNlIG9mIENMSURSX0VMMSwg
c28gaXQgbWlnaHQgYmUgd29ydGggdHJlYXRpbmcgc3lzdGVtIHJlZ2lzdGVycwo+PiBnZW5lcmFs
bHkgYXMgdTY0IHZhbHVlcy4KPgo+IFJlYWxseT8gSSBtZWFuIHRoZSBleGlzdGluZyBkZWJ1ZyAq
Y29udHJvbCogcmVnaXN0ZXJzIGhhdmUgcmVzZXJ2ZWQgYml0cwo+IDI0LTMxIHNvIHRoZXJlIGlz
IHNwYWNlIGZvciBleHBhbnNpb24uCgpPdGhlciBwbGFjZXMgaW4gdGhlIHVzZXJzcGFjZSBBQkkg
d2hpY2ggZGVhbCB3aXRoIHN5c3JlZ3MgKG5vdGFibHkKT05FX1JFRykgY29uc2lzdGVudGx5IGRl
ZmluZSB0aGVtIGFsbCBhcyA2NC1iaXQgKHdoaWNoIG1ha2VzIHNlbnNlCmFueXdheSBzaW5jZSB0
aGUgSVNBIG9ubHkgcHJvdmlkZXMgNjQtYml0IGFjY2Vzc29ycyB0byB0aGVtKS4KIkFyY2hpdGVj
dHVyYWxseSAzMiBiaXRzIiBvbmx5IG1lYW5zICJ0b3AgMzIgYml0cyByZXNlcnZlZCIuCgotLSBQ
TU0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
