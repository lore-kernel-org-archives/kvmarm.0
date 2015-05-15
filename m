From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v4 03/12] KVM: arm64: guest debug, define API headers
Date: Fri, 15 May 2015 17:19:03 +0100
Message-ID: <87wq09ke4o.fsf@linaro.org>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-4-git-send-email-alex.bennee@linaro.org>
 <20150515144423.GA23652@leverpostej> <874mndlvny.fsf@linaro.org>
 <CAFEAcA8ZpndRyT84ta2r4bPTE1uGTN1XTfMpUn8qW022ben3BQ@mail.gmail.com>
 <20150515154324.GC23652@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0335178C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 12:08:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XlxVu3Gnmv3h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 12:08:56 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C97865173D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 12:08:56 -0400 (EDT)
In-reply-to: <20150515154324.GC23652@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "r65777@freescale.com" <r65777@freescale.com>, Will Deacon <Will.Deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "bp@suse.de" <bp@suse.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Ck1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+IHdyaXRlczoKCj4gT24gRnJpLCBN
YXkgMTUsIDIwMTUgYXQgMDQ6MTc6NDZQTSArMDEwMCwgUGV0ZXIgTWF5ZGVsbCB3cm90ZToKPj4g
T24gMTUgTWF5IDIwMTUgYXQgMTY6MTQsIEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4gd3JvdGU6Cj4+ID4KPj4gPiBNYXJrIFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0uY29t
PiB3cml0ZXM6Cj4+ID4KPj4gPj4gT24gRnJpLCBNYXkgMTUsIDIwMTUgYXQgMDM6Mjc6MDZQTSAr
MDEwMCwgQWxleCBCZW5uw6llIHdyb3RlOgo+PiA+Pj4gKy8qCj4+ID4+PiArICogU2VlIHY4IEFS
TSBBUk0gRDcuMzogRGVidWcgUmVnaXN0ZXJzCj4+ID4+PiArICoKPj4gPj4+ICsgKiBUaGUgY29u
dHJvbCByZWdpc3RlcnMgYXJlIGFyY2hpdGVjdHVyYWxseSBkZWZpbmVkIGFzIDMyIGJpdHMgYnV0
IGFyZQo+PiA+Pj4gKyAqIHN0b3JlZCBhcyA2NCBiaXQgdmFsdWVzIGFsb25nc2lkZSB0aGUgdmFs
dWUgcmVnaXN0ZXJzLiBUaGlzIGlzIGRvbmUKPj4gPj4KPj4gPj4gU3RhbGUgY29tbWVudD8gVGhl
eSdyZSBzdG9yZWQgYXMgX191MzIgYmVsb3cuCj4+ID4KPj4gPiBHYWggeWVzIGl0IGlzLgo+PiA+
Cj4+ID4+IEl0J3MgcG9zc2libGUgdGhhdCB0aGUgcmVnaXN0ZXJzIGNvdWxkIGdyb3cgaW4gZnV0
dXJlIGFzIGhhcHBlbmVkIGluIHRoZQo+PiA+PiBjYXNlIG9mIENMSURSX0VMMSwgc28gaXQgbWln
aHQgYmUgd29ydGggdHJlYXRpbmcgc3lzdGVtIHJlZ2lzdGVycwo+PiA+PiBnZW5lcmFsbHkgYXMg
dTY0IHZhbHVlcy4KPj4gPgo+PiA+IFJlYWxseT8gSSBtZWFuIHRoZSBleGlzdGluZyBkZWJ1ZyAq
Y29udHJvbCogcmVnaXN0ZXJzIGhhdmUgcmVzZXJ2ZWQgYml0cwo+PiA+IDI0LTMxIHNvIHRoZXJl
IGlzIHNwYWNlIGZvciBleHBhbnNpb24uCj4+IAo+PiBPdGhlciBwbGFjZXMgaW4gdGhlIHVzZXJz
cGFjZSBBQkkgd2hpY2ggZGVhbCB3aXRoIHN5c3JlZ3MgKG5vdGFibHkKPj4gT05FX1JFRykgY29u
c2lzdGVudGx5IGRlZmluZSB0aGVtIGFsbCBhcyA2NC1iaXQKPgo+IEFsc28gZm9yIHB0X3JlZ3Mu
cHN0YXRlLgo+Cj4gSSBqdXN0IHNwb3R0ZWQgdGhhdCBpbiB1c2VyX2h3ZGVidWdfc3RhdGUgaW4g
cHRyYWNlLmggd2Ugc2VlbSB0byBleHBvc2UKPiB0aGUgZGVidWcgY29udHJvbCByZWdzaXRlcnMg
YXMgX191MzIgYWxyZWFkeSwgYWFsb25nIHdpdGggc29tZSBvdGhlcgo+IHJlZ2lzdGVycy4KCkkg
dGhvdWdodCB0aG9zZSB3aGVyZSBwdHJhY2Ugc3BlY2lmaWMgZmllbGRzIHdoaWNoIHRoZW4gZ2V0
IG11bmdlZCBpbnRvCnRoZSBmaW5hbCB2YWx1ZXMgaW5zaWRlIHRoZSBrZXJuZWw/Cgo+Cj4gU28g
d2UncmUgYWxyZWFkeSBpbmNvbnNpc3RlbnQgdy5yLnQuIGhvdyB3ZSBleHBvc2UgdGhvc2UgcmVn
aXN0ZXJzLCBhbmQKPiBJJ20gbm90IHN1cmUgd2hhdCB3ZSdkIGRvIGVsc2V3aGVyZSBpZiBhbnkg
cmVnaXN0ZXJzIGdvdCBleHBhbmRlZC4gOi8KPgo+IE1hcmsuCgotLSAKQWxleCBCZW5uw6llCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
