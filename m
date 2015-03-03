From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 1/6] target-arm: kvm: save/restore mp state
Date: Tue, 03 Mar 2015 16:30:54 +0000
Message-ID: <87zj7u59hd.fsf@linaro.org>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
 <1424880159-29348-2-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA9oWeYGYcGtf8So6VrYLMXjWr4FiZ2tS+jBnDtv87jAKw@mail.gmail.com>
 <8761ai73j1.fsf@linaro.org> <54F595C0.5060004@redhat.com>
 <CAFEAcA8SaBuH6izzuD6CmknSU9mbQPo0YNO=knTgRCPZ2EvXcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38641478A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 11:25:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aXTjVSdfuhRi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Mar 2015 11:24:56 -0500 (EST)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8084C47872
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 11:24:56 -0500 (EST)
In-reply-to: <CAFEAcA8SaBuH6izzuD6CmknSU9mbQPo0YNO=knTgRCPZ2EvXcQ@mail.gmail.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

ClBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBPbiAz
IE1hcmNoIDIwMTUgYXQgMjA6MDYsIFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+
IHdyb3RlOgo+Pgo+Pgo+PiBPbiAwMy8wMy8yMDE1IDExOjU2LCBBbGV4IEJlbm7DqWUgd3JvdGU6
Cj4+PiA+ID4gVGhpcyBhZGRzIHRoZSBzYXZpbmcgYW5kIHJlc3RvcmUgb2YgdGhlIGN1cnJlbnQg
TXVsdGktUHJvY2Vzc2luZyBzdGF0ZQo+Pj4gPiA+IG9mIHRoZSBtYWNoaW5lLiBXaGlsZSB0aGUg
S1ZNX0dFVC9TRVRfTVBfU1RBVEUgQVBJIGV4cG9zZXMgYSBudW1iZXIgb2YKPj4+ID4gPiBwb3Rl
bnRpYWwgc3RhdGVzIGZvciB4ODYgd2Ugb25seSB1c2UgdHdvIGZvciBBUk0uIEVpdGhlciB0aGUg
cHJvY2VzcyBpcwo+Pj4gPiA+IHJ1bm5pbmcgb3Igbm90Lgo+Pj4gPgo+Pj4gPiBCeSB0aGlzIHlv
dSBtZWFuICJpcyB0aGUgQ1BVIGluIHRoZSBQU0NJIHBvd2VyZWQgZG93biBzdGF0ZSBvciBub3Qi
LAo+Pj4gPiByaWdodD8KPj4+Cj4+PiBGcm9tIHRoZSB2Y3B1J3MgcGVyc3BlY3RpdmUgaXQgaXMg
ZWl0aGVyIHJ1bm5pbmcgb3Igbm90LiBIb3dldmVyIGl0IGlzCj4+PiB0aGUgc2FtZSBtZWNoYW5p
c20gdGhhdCBpcyB1c2VkIHdoZW4gUFNDSV8wXzJfRk5fQ1BVX09GRiBpcyBwYXNzZWQgdGhlCj4+
PiBWTSwgaW50ZXJuYWxseSBzZXR0aW5nIHZjcHUtPmFyY2gucGF1c2VkLgo+Cj4gV2VsbCwgaXQg
aGFzIHRvIGJlIChBQkkgZGVmaW5lZCB0byBiZSkgaWRlbnRpY2FsIHdpdGggYmVpbmcgUFNDSQo+
IHBvd2VyZWQgZG93bi91cCwgYmVjYXVzZSB0aGF0J3MgaG93IHVzZXJzcGFjZSBpcyBnb2luZyB0
byBiZQo+IHRyZWF0aW5nIGl0LiBJZiB3ZSBtaWdodCB0ZWxsIHVzZXJzcGFjZSB3ZSdyZSBpbiB0
aGUgIm5vdCBydW5uaW5nIgo+IHN0YXRlIGZvciBvdGhlciBjYXNlcyB0aGFuIFBTQ0ktcG93ZXJl
ZC1kb3duIHRoZW4gd2UgcHJvYmFibHkgbmVlZAo+IHRvIGNvbnNpZGVyIHNlcGFyYXRpbmcgdGhv
c2Ugb3V0IGludG8gc2VwYXJhdGUgc3RhdGVzLgo+Cj4+IEkgc3VnZ2VzdCB0aGF0IHlvdSBkZWZp
bmUgYSBuZXcgTVBfU1RBVEUgY29uc3RhbnQgZm9yIHRoaXMuICBIQUxURUQgaW4KPj4geDg2IGFu
ZCBzMzkwIGlzIHRoZSBzdGF0ZSBhbiBBUk0gcHJvY2Vzc29yIGVudGVycyB3aGVuIHlvdSBleGVj
dXRlIHdmaS4KPgo+IEFyY2hpdGVjdHVyYWxseSB0aGUgQ1BVIGRvZXNuJ3QgaGF2ZSB0byBlbnRl
ciBhbnkgc3RhdGUgYXQgYWxsCj4gaWYgeW91IGV4ZWN1dGUgYSBXRkkgLS0gaXQgbWlnaHQgYmUg
aW1wbGVtZW50ZWQgYXMgImdvIHRvIGxvdwo+IHBvd2VyIHN0YXRlIGFuZCB3YWl0IGZvciBhbiBp
bnRlcnJ1cHQiIG9yICJnbyBsb3cgcG93ZXIgYnV0Cj4gbWF5YmUgYmUgdW5uZWNlc3NhcmlseSB3
b2tlbiB1cCIgb3IgIm5vcCwgZG8gbm90aGluZyIuLi4KPgo+PiAgUmlnaHQgbm93IHRoaXMgaXMg
bm90IG1pZ3JhdGVkIG9uIEFSTSBpZiBJIHJlbWVtYmVyIGNvcnJlY3RseSwgYnV0Cj4+IHBlcmhh
cHMgeW91J2xsIHdhbnQgdG8gYWRkIGl0IGluIHRoZSBmdXR1cmUuCj4KPiAuLi53aGljaCBpcyB3
aHkgd2UgZG9uJ3QgbmVlZCB0byBtaWdyYXRlIHRoaXM6IGl0IGp1c3QgbWVhbnMKPiB0aGF0IG1p
Z3JhdGlvbiBkdXJpbmcgV0ZJIGNhdXNlcyBhbiB1bm5lY2Vzc2FyeS13YWtldXAsIHdoaWNoCj4g
aXMgYXJjaGl0ZWN0dXJhbGx5IGZpbmUuCgpXaGF0IGhhcHBlbnMgd2hlbiB5b3UgYm9vdCBhIFNN
UCBzeXN0ZW0gYnV0IG9ubHkgZXZlciBwb3dlciB1cCBvbmUgb2YgdGhlCkNQVXM/IFlvdSBjYW4n
dCBqdXN0IHJhbmRvbWx5IHN0YXJ0IHRoZSBzZWNvbmQgQ1BVIGlmIGl0J3MgaW4gdGhlCnBvd2Vy
ZWQgb2ZmIHN0YXRlLCB3aG8ga25vd3Mgd2hhdCBpdCB3b3VsZCBkbz8KCi0tIApBbGV4IEJlbm7D
qWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
