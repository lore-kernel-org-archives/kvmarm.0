From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug,
 add SW break point support
Date: Tue, 28 Apr 2015 09:42:38 +0100
Message-ID: <87wq0wr6dd.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
 <20150414082558.GS6186@cbox> <87y4li6hua.fsf@linaro.org>
 <20150427200407.GG23335@cbox>
 <CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8664EC92
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 04:33:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aiDs6mqG0snd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 04:33:53 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43D054EC85
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 04:33:53 -0400 (EDT)
In-reply-to: <CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm-devel <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <marc.zyngier@arm.com>, "J. Kiszka" <jan.kiszka@siemens.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Zhichao Huang <zhichao.huang@linaro.org>, Bharat Bhushan <r65777@freescale.com>, Paolo Bonzini <pbonzini@redhat.com>, bp@suse.de, Gleb Natapov <gleb@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

ClBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBPbiAy
NyBBcHJpbCAyMDE1IGF0IDIxOjA0LCBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxs
QGxpbmFyby5vcmc+IHdyb3RlOgo+PiBPbiBUaHUsIEFwciAyMywgMjAxNSBhdCAwMzoyNjo1M1BN
ICswMTAwLCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4+Pgo+Pj4gQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hy
aXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPiB3cml0ZXM6Cj4+Pgo+Pj4gPiBPbiBUdWUsIE1hciAz
MSwgMjAxNSBhdCAwNDowODowNFBNICswMTAwLCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4+PiA+PiAr
ICoganVzdCBuZWVkIHRvIHJlcG9ydCB0aGUgUEMgYW5kIHRoZSBIU1IgdmFsdWVzIHRvIHVzZXJz
cGFjZS4KPj4+ID4+ICsgKiBVc2Vyc3BhY2UgbWF5IGRlY2lkZSB0byByZS1pbmplY3QgdGhlIGV4
Y2VwdGlvbiBhbmQgZGVsaXZlciBpdCB0bwo+Pj4gPj4gKyAqIHRoZSBndWVzdCBpZiBpdCB3YXNu
J3QgZm9yIHRoZSBob3N0IHRvIGRlYWwgd2l0aC4KPj4+ID4KPj4+ID4gbm93IEknbSBjb25mdXNl
ZCAtIGRvZXMgdXNlcnNwYWNlIHNldHVwIHRoZSBndWVzdCB0byByZWNlaXZlIGFuCj4+PiA+IGV4
Y2VwdGlvbiBvciBkb2VzIGl0IHRlbGwgS1ZNIHRvIGVtdWxhdGUgYW4gZXhjZXB0aW9uIGZvciB0
aGUgZ3Vlc3Qgb3IKPj4+ID4gZG8gd2UgZXhlY3V0ZSB0aGUgYnJlYWtwb2ludCB3aXRob3V0IHRy
YXBwaW5nIHRoZSBkZWJ1ZyBleGNlcHRpb24/Cj4+Pgo+Pj4gSSd2ZSBtYWRlIGl0IGFsbCBnbyB0
aHJvdWdoIHVzZXJzcGFjZSBhcyB3ZSBtYXkgaGF2ZSB0byB0cmFuc2xhdGUgdGhlCj4+PiBoeXBl
cnZpc29yIHZpc2libGUgZXhjZXB0aW9uIGNvZGUgdG8gd2hhdCB0aGUgZ3Vlc3Qgd2FzIGV4cGVj
dGluZyB0byBzZWUuCj4+Pgo+Pgo+PiBvaywgc28gSSB0aGluayB5b3Ugc2hvdWxkIHJlLXBocmFz
ZSBzb21ldGhpbmcgbGlrZToKPj4KPj4gIlVzZXJzcGFjZSBtYXkgZGVjaWRlIHRoYXQgdGhpcyBl
eGNlcHRpb24gaXMgY2F1c2VkIGJ5IHRoZSBndWVzdCB1c2luZwo+PiBkZWJ1Z2dpbmcgaXRzZWxm
LCBhbmQgbWF5IGluIHRoYXQgY2FzZSBlbXVsYXRlIHRoZSBndWVzdCBkZWJ1ZyBleGNlcHRpb24K
Pj4gaW4gdXNlcnNwYWNlIGJlZm9yZSByZXN1bWluZyBLVk0uIgo+Pgo+PiBCdXQgZG9lcyB0aGF0
IHJlYWxseSB3b3JrPyAgR2l2ZW4gdGhhdCB3ZSBkb24ndCBzdXBwb3J0IEtWTS1UQ0cKPj4gbWln
cmF0aW9uLCB0aGlzIHNvdW5kcyBhIGxpdHRsZSBzdHJhbmdlLiAgRGlkIHdlIHRlc3QgaXQ/Cj4K
PiBUaGUgUUVNVSBwYXRjaGVzIGhhdmUgYSBUT0RPIG5vdGUgYXQgdGhlIHBvaW50IHdoZXJlIHlv
dSdkIHdhbnQKPiB0byBkbyB0aGlzLi4uIERlc2lnbi13aXNlIHlvdSBjYW4gZG8gdGhlIHJlaW5q
ZWN0aW9uIGluIHRoZQo+IGtlcm5lbCBvciBpbiB1c2Vyc3BhY2UgKHBwYyBRRU1VIGRvZXMgdGhp
cyBpbiB1c2Vyc3BhY2UsIGZvcgo+IGluc3RhbmNlKSBiZWNhdXNlIGl0J3MgcHJldHR5IG11Y2gg
anVzdCBzZXR0aW5nIHJlZ2lzdGVycyB0byBmYWtlCj4gdXAgdGhlIGV4Y2VwdGlvbi1lbnRyeSBp
bnRvIEVMMS4gQ29kZS13aXNlIFFFTVUncyBBUk0gY29kZSBpc24ndAo+IHNldCB1cCB0byBkbyBp
dCByaWdodCBub3csIGJ1dCBpdCBzaG91bGRuJ3QgYmUgdG9vIGRpZmZpY3VsdCB0bwo+IHBlcnN1
YWRlIHRoZSBUQ0cgZXhjZXB0aW9uLWVudHJ5IGNvZGUgdG8gd29yayBmb3IgdGhpcyBjYXNlIHRv
by4KPgo+IERvZXMgdGhlIGtlcm5lbCBhbHJlYWR5IGhhdmUgYSBjb252ZW5pZW50bHkgaW1wbGVt
ZW50ZWQgImluamVjdAo+IGV4Y2VwdGlvbiBpbnRvIGd1ZXN0IiBsdW1wIG9mIGNvZGU/IElmIHNv
IGl0IG1pZ2h0IGJlIGxlc3MgZWZmb3J0Cj4gdG8gZG8gaXQgdGhhdCB3YXkgcm91bmQsIG1heWJl
LgoKU28geW91IHBvaW50ZWQgb3V0IHdlIGNhbid0IGp1c3QgcmUtaW5qZWN0IHRoZSBleGNlcHRp
b25zIHdlIGdldCBhcyB3ZQpuZWVkIHRvIG1hcCBmcm9tIHRoaW5ncyBsaWtlIEVTUl9FTHhfRUNf
V0FUQ0hQVF9MT1cgdG8KRVNSX0VMeF9FQ19XQVRDSFBUX0NVUiBiZWZvcmUgcmUtaW5qZWN0aW9u
LgoKT2YgY291cnNlIGlmIGl0IGlzIGFzIHNpbXBsZSBhcyBtb2RpZnlpbmcgdGhlIEVTUl9FTDEg
cmVnaXN0ZXIgYW5kCnJldHVybmluZyArdmUgaW4gdGhlIGhhbmRsZV9leGl0IHBhdGggdGhlbiBJ
IGNhbiBkbyB0aGF0IGJ1dCBJIGFzc3VtZWQKaWYgYW55IG90aGVyIHdyYW5nbGluZyBuZWVkcyBk
b2luZyBpdCBzaG91bGQgYmUgZG9uZSBpbiB1c2Vyc3BhY2UuCgo+Cj4gLS0gUE1NCgotLSAKQWxl
eCBCZW5uw6llCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
