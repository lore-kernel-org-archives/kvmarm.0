From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug,
 add SW break point support
Date: Wed, 29 Apr 2015 10:18:18 +0100
Message-ID: <87r3r31eed.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
 <20150414082558.GS6186@cbox> <87y4li6hua.fsf@linaro.org>
 <20150427200407.GG23335@cbox>
 <CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
 <87wq0wr6dd.fsf@linaro.org>
 <CAFEAcA85i_1JybEFBg91NA3-LpAzYh4RSDnqryOd=rZN7gZP5A@mail.gmail.com>
 <20150428125645.GA4137@cbox> <87tww0qqh9.fsf@linaro.org>
 <20150429081047.GB4137@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23DFF4EEAF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 05:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wng71YwKPQwP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2015 05:09:31 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEC934EEAB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 05:09:30 -0400 (EDT)
In-reply-to: <20150429081047.GB4137@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm-devel <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <marc.zyngier@arm.com>, "J. Kiszka" <jan.kiszka@siemens.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Zhichao Huang <zhichao.huang@linaro.org>, Bharat Bhushan <r65777@freescale.com>, Paolo Bonzini <pbonzini@redhat.com>, bp@suse.de, Gleb Natapov <gleb@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

CkNocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoK
PiBPbiBUdWUsIEFwciAyOCwgMjAxNSBhdCAwMzozNzowMVBNICswMTAwLCBBbGV4IEJlbm7DqWUg
d3JvdGU6Cj4+IAo+PiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxpbmFyby5v
cmc+IHdyaXRlczoKPj4gCj4+ID4gT24gVHVlLCBBcHIgMjgsIDIwMTUgYXQgMTA6MzQ6MTJBTSAr
MDEwMCwgUGV0ZXIgTWF5ZGVsbCB3cm90ZToKPj4gPj4gT24gMjggQXByaWwgMjAxNSBhdCAwOTo0
MiwgQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPiB3cm90ZToKPj4gPj4gPiBQ
ZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+IHdyaXRlczoKPj4gPj4gPj4g
RG9lcyB0aGUga2VybmVsIGFscmVhZHkgaGF2ZSBhIGNvbnZlbmllbnRseSBpbXBsZW1lbnRlZCAi
aW5qZWN0Cj4+ID4+ID4+IGV4Y2VwdGlvbiBpbnRvIGd1ZXN0IiBsdW1wIG9mIGNvZGU/IElmIHNv
IGl0IG1pZ2h0IGJlIGxlc3MgZWZmb3J0Cj4+ID4+ID4+IHRvIGRvIGl0IHRoYXQgd2F5IHJvdW5k
LCBtYXliZS4KPj4gPj4gPgo+PiA+PiA+IFNvIHlvdSBwb2ludGVkIG91dCB3ZSBjYW4ndCBqdXN0
IHJlLWluamVjdCB0aGUgZXhjZXB0aW9ucyB3ZSBnZXQgYXMgd2UKPj4gPj4gPiBuZWVkIHRvIG1h
cCBmcm9tIHRoaW5ncyBsaWtlIEVTUl9FTHhfRUNfV0FUQ0hQVF9MT1cgdG8KPj4gPj4gPiBFU1Jf
RUx4X0VDX1dBVENIUFRfQ1VSIGJlZm9yZSByZS1pbmplY3Rpb24uCj4+ID4+ID4KPj4gPj4gPiBP
ZiBjb3Vyc2UgaWYgaXQgaXMgYXMgc2ltcGxlIGFzIG1vZGlmeWluZyB0aGUgRVNSX0VMMSByZWdp
c3RlciBhbmQKPj4gPj4gPiByZXR1cm5pbmcgK3ZlIGluIHRoZSBoYW5kbGVfZXhpdCBwYXRoIHRo
ZW4gSSBjYW4gZG8gdGhhdCBidXQgSSBhc3N1bWVkCj4+ID4+ID4gaWYgYW55IG90aGVyIHdyYW5n
bGluZyBuZWVkcyBkb2luZyBpdCBzaG91bGQgYmUgZG9uZSBpbiB1c2Vyc3BhY2UuCj4+ID4+IAo+
PiA+PiBXZWxsLCBzb21lYm9keSdzIGdvdCB0byBkbyBpdCwgYW5kIGl0J3MgdGhlIHNhbWUgYW1v
dW50IG9mIHdvcmsKPj4gPj4gZWl0aGVyIHdheSAoZmlkZGxpbmcgd2l0aCBFU1IsIG1ha2luZyBz
dXJlIHdlIGRpcmVjdCB0aGUgZ3Vlc3QKPj4gPj4gdG8gdGhlIHJpZ2h0IGV4Y2VwdGlvbiB2ZWN0
b3IgZW50cnkgcG9pbnQsIG1heWJlIGEgZmV3IG90aGVyCj4+ID4+IHRoaW5ncykuCj4+ID4+IAo+
PiA+IFdlIGFscmVhZHkgaGF2ZSBjb2RlIGluIHRoZSBrZXJuZWwgdG8gaW5qZWN0IGRhdGEvaW5z
dHJ1Y3Rpb24gYWJvcnRzLAo+PiA+IGJ1dCBub3Qgc3VyZSBob3cgbXVjaCBiZW5lZml0IHRoZXJl
IGlzIGluIHJlLXVzaW5nIHRoYXQuICBJdCdzIHVwIHRvIHlvdQo+PiA+IHJlYWxseSwgYnV0IEkg
dGhpbmsgdGhlIGtlcm5lbCBjb2RlIHNob3VsZCBiZSBjbGVhciBhYm91dCB3aGF0IHRoZQo+PiA+
IGludGVudGlvbiBpcyBzbyB0aGF0IHdlIGRvbid0IGVuZCB1cCBpbiBhIHNpdHVhdGlvbiB3aGVy
ZTogKDEpIFRoZQo+PiA+IGludGVuZGVkIGJlaGF2aW9yIGlzIHVuY2xlYXIvdmFndWUsIGFuZCAo
MikgaXQgZG9lc24ndCBhY3R1YWxseSB3b3JrIGluCj4+ID4gcHJhY3RpY2Ugc28gbm9ib2R5IGNh
biBmb2xsb3cgdGhlIGNvZGUuCj4+IAo+PiBDZXJ0YWlubHkgdGhlcmUgYXJlIHNvbWUgY2FzZXMg
d2hlcmUgdGhlIGtlcm5lbCBkb2Vzbid0IGhhdmUgYWxsIHRoZQo+PiBpbmZvcm1hdGlvbi4gRm9y
IGV4YW1wbGUgaXQgZG9lc24ndCBrbm93IGlmIHRoZSBzb2Z0IGJyZWFrIHdhcyBpbnNlcnRlZAo+
PiBieSB0aGUgZ3Vlc3Qgb3IgdGhlIGhvc3QuIFRoYXQgdG8gbWUgZmF2b3VycyB0aGUgImxldCB1
c2Vyc3BhY2UgZGVhbAo+PiB3aXRoIHRoZSB1Z2x5IiBhcHByb2FjaC4KPj4gCj4gTm90IHN1cmUg
SSBmb2xsb3cuCj4KPiBJZiBpdCdzIGFuIGV4Y2VwdGlvbiBmb3IgdGhlIGd1ZXN0LCB0aGVuIHRo
YXQgbXVzdCBiZSBiZWNhdXNlIHRoZSBndWVzdAo+IHB1dCBpbiB0aGUgYnJlYWtwb2ludCBpbnN0
cnVjdGlvbiwgcmlnaHQ/CgpObyB0aGUgaG9zdCBjYW4gYWRkIGJyZWFrcG9pbnQgaW5zdHJ1Y3Rp
b25zIGFzIHdlbGwuIFRoZXkgYm90aCBnZW5lcmF0ZQp0aGUgc2FtZSAocmVkaXJlY3RlZCkgZXhj
ZXB0aW9uIHRvIHRoZSBoeXBlcnZpc29yIHdoaWNoIHRoZW4gaGFzIHRvCmZpZ3VyZSBvdXQgd2hv
IHBsYW50ZWQgdGhlIGJyZWFrcG9pbnQgYW5kIHdoZXJlIHRoZSBldmVudHVhbCBleGNlcHRpb24K
d2lsbCBiZSBoYW5kbGVkLgoKPiBIb3dldmVyLCB0aGF0J3MgYSBzZXBhcmF0ZSBkaXNjdXNzaW9u
IGZyb20gdGhhdCBvZiAqaG93KiB1c2Vyc3BhY2Ugb3IKPiB0aGUga2VybmVsIHRoZW4gaW5qZWN0
cyBhbiBleGNlcHRpb24gdG8gdGhlIGd1ZXN0Lgo+Cj4gQnkgdXNpbmcgc29tZSBRRU1VIFRDRyBm
dW5jdGlvbmFsaXR5IG9yIGJ5IFFFTVUgY2FsbGluZyBiYWNrIGludG8gS1ZNCj4gYW5kIGFza2lu
ZyBpdCB0byBpbmplY3QgYW4gZXhjZXB0aW9uIGZvciBpdC4KCkkgZG9uJ3Qga25vdyBpZiB0aGVy
ZSBpcyBleHBsaWNpdCBUQ0cgZnVuY3Rpb25hbGl0eSB0byB1c2UgYnV0IFFFTVUgY2FuCnNldCB0
aGUgcmVnaXN0ZXJzIGFuZCBQQyB1cCBmb3IgZXhjZXB0aW9uIGVudHJ5IGFuZCByZS1lbnRlciBL
Vk0uCgo+Cj4gV2hhdCBhbSBJIG1pc3Npbmc/Cj4KPiAtQ2hyaXN0b2ZmZXIKCi0tIApBbGV4IEJl
bm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
