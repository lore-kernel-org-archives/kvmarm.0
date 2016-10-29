From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Sat, 29 Oct 2016 20:55:11 +0200
Message-ID: <5D593F44-F76B-4E2C-B2F8-CA08DFE2D87F@suse.de>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de> <20160930154335.GB7996@cbox>
 <71b0ae9d-baea-1f65-3c01-5d87f4f4746f@suse.de>
 <3928feee-cb23-8635-20bd-4c068b649a1d@arm.com>
 <7500DEDE-EC21-4287-9B11-04C058A48747@suse.de>
 <56812724-4bac-8265-b6f6-b1ff00308ec0@arm.com>
 <554F7514-1900-41B4-8DDC-36C00B903164@suse.de>
 <1154342410.9324183.1477747141878.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 337D7404AC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Oct 2016 14:55:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id URFr9-xjXkxw for <kvmarm@lists.cs.columbia.edu>;
 Sat, 29 Oct 2016 14:55:12 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D64F640430
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Oct 2016 14:55:11 -0400 (EDT)
In-Reply-To: <1154342410.9324183.1477747141878.JavaMail.zimbra@redhat.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Cj4gT24gMjkgT2N0IDIwMTYsIGF0IDE1OjE5LCBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRo
YXQuY29tPiB3cm90ZToKPiAKPj4+Pj4gV2hhdCB0aGUgc3RhdHVzIG9mIHVzZXJzcGFjZSBmb3Ig
dGhpcyB0aGluZz8gQXJlIFFFTVUgcGF0Y2hlcyBiZWluZwo+Pj4+PiBwb3N0ZWQgYW5kIHJldmll
d2VkPwo+Pj4+IAo+Pj4+IEkgZGlkbid0IHNlZSBhIG5vdGlmaWNhdGlvbiB0aGF0IHRoZSBwYXRj
aGVzIHdlcmUgbWVyZ2VkLiBBcmUgdGhleSBpbgo+Pj4+IExpbnVzJyB0cmVlIHlldD8gVGhlbiBJ
IGNhbiBwb3N0IGVuYWJsZW1lbnQgdG8gcWVtdS1kZXZlbC4KPj4+IAo+Pj4gSSB0aGluayB5b3Ug
Z290IGl0IGJhY2t3YXJkLiBJIGhhdmUgbm8gaW50ZW50aW9uIG9mIG1lcmdpbmcgdGhlbSB1bnRp
bCBJCj4+PiBzZWUgYSB2YWd1ZSBjb25zZW5zdXMgb24gdGhlIHVzZXJzcGFjZSBBUEksIGFuZCBh
IHNldCBvZiBwYXRjaGVzIHJlYWR5Cj4+PiB0byBiZSBtZXJnZWQgaW4gUUVNVS4KPj4gCj4+IFRo
YXQncyBub3QgaG93IGt2bSBhcGlzIGFyZSBtYWRlLgo+IAo+IEFjdHVhbGx5IEkgdGhpbmsgaXQn
cyBhbHdheXMgYmVlbiBsaWtlIHRoaXMsIGRlcGVuZGluZyBvbiB3aGF0IE1hcmMgbWVhbnQgZm9y
Cj4gInJlYWR5IHRvIGJlIG1lcmdlZCBpbiBRRU1VIi4gIEl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0
byBtZXJnZSBLVk0gQVBJcyB3aXRob3V0Cj4gaGF2aW5nIHVzZXJzcGFjZSBwYXRjaGVzIGF0IGxl
YXN0IHBvc3RlZCBhcyBSRkMgdG8gcWVtdS1kZXZlbCwgYW5kIHdpdGhvdXQKPiBoYXZpbmcgYXQg
bGVhc3QgYSBwb3NpdGl2ZSByZXNwb25zZSBmcm9tIHRoZSBRRU1VIGFyY2hpdGVjdHVyZSBtYWlu
dGFpbmVyLgoKSSBoYWxmd2F5IGFncmVlLiBJIGRvIGFncmVlIHRoYXQgdGhlcmUgbmVlZHMgdG8g
YmUgYSByZWZlcmVuY2UgaW1wbGVtZW50YXRpb24gdGhhdCBwcm92ZXMgdGhlIEFQSSB0byBtYWtl
IHNlbnNlLiBUaGF0IGJpdCBpcyByZWZlcmVuY2VkIGluIHRoZSBjb3ZlciBsZXR0ZXIgb2YgdGhl
IHBhdGNoIHNldC4KClBldGVyIGFzIHRoZSBRRU1VIGFyY2hpdGVjdHVyZSBtYWludGFpbmVyIGhh
cyBiZWVuIHBhcnQgb2YgdGhlIHJldmlldyBwcm9jZXNzIGFuZCBpbnZvbHZlZCBmcm9tIHRoZSBi
ZWdpbm5pbmcuIEluIGZhY3QsIHRoZSBjdXJyZW50IGFwcHJvYWNoIHdhcyBoaXMgaWRlYS4KCkRv
IHdlIG5lZWQgdG8gZmx5IHRoZSBsb29wIG92ZXIgcWVtdS1kZXZlbD8gSSBkb3VidCBpdCwgYnV0
IGlmIGl0IG1ha2VzIHlvdSBoYXBweSBJIGNhbiBwb3N0IGFuIFJGQyB0aGVyZSB0b28uCgo+IEFS
TSBkb2VzIHJlcXVpcmUgYSBiaXQgbW9yZSBjYXJlIGJlY2F1c2UgdGhlcmUncyBubyBvdmVybGFw
IGJldHdlZW4ga2VybmVsCj4gYW5kIHVzZXJzcGFjZSBtYWludGFpbmVycywgc28gcGVyaGFwcyB0
aGF0J3MgdGhlIHNvdXJjZSBvZiB0aGUgY29uZnVzaW9uPwo+IAo+IE5vdywgb2YgY291cnNlIG1l
cmdpbmcgdGhlIHBhdGNoZXMgaW4gUUVNVSBtYXkgdGFrZSBhIG1vbnRoIG9yIHR3byBkZXBlbmRp
bmcKPiBvbiB0aGUgdGltaW5nIChiZWNhdXNlIHlvdSBoYXZlIHRvIHdhaXQgZm9yIHRoZSBwYXRj
aGVzIHRvIGJlIG1lcmdlZCBpbnRvCj4gTGludXMncyB0cmVlIGFuZCBmb3IgdGhlIEtWTSBoZWFk
ZXJzIHRvIGJlIHVwZGF0ZWQgaW4gUUVNVS0tLXdoaWNoIGlzIG5vdAo+IGdvaW5nIHRvIGhhcHBl
biBkdXJpbmcgZnJlZXplIG9mIGNvdXJzZSkuICBTbyBvZiBjb3Vyc2UgdGhlIEtWTSBwYXRjaCB0
aHVzCj4gY2FuIGJlIGNvbW1pdHRlZCBldmVuIGlmIFFFTVUgaXMgaW4gZnJlZXplLCBhcyBsb25n
IGFzIHRoZSBRRU1VIGFyY2hpdGVjdHVyZQo+IG1haW50YWluZXIgZ2l2ZXMgYW4gb3ZlcmFsbCBn
cmVlbiBsaWdodC4KClJpZ2h0LiBNeSBwbGFuIHdhcyB0byBtYWtlIHN1cmUgdGhhdCBwZW9wbGUg
YWdyZWUgb24gdGhlIEtWTSBpbnRlcmZhY2UuIFRoZW4gZGlyZWN0bHkgc2VuZCBub24tUkZDIHBh
dGNoZXMgdG8gcWVtdS1kZXZlbCwgd2hpY2ggY2FuIG9ubHkgaGFwcGVuIHdoZW4gdGhlIEtWTSBw
YXRjaGVzIGFyZSBtZXJnZWQuIEkgZGlkbuKAmXQgc2VlIGFueSByZWFzb24gd2h5IHRoYXQgYXBw
cm9hY2ggd291bGQgYmUgY29udHJvdmVyc2lhbCwgc2luY2UgZXZlcnlvbmUgd2hvIHJlYWxseSBj
YXJlZCB3YXMgaW52b2x2ZWQuCgpCdXQgYWdhaW4sIEkgZG9u4oCZdCBjYXJlIHN0cm9uZ2x5IGVu
b3VnaCB0byBtYWtlIGEgZnVzcy4gSWYgcGVvcGxlIGFyZSBoYXBwaWVyIHdpdGggUkZDIHBhdGNo
ZXMgb24gdGhlIE1MIHJhdGhlciB0aGFuIGEgZ2l0aHViIGxpbmsgdG8gUkZDIHBhdGNoZXMsIEni
gJlsbCBzZW5kIHRoZW0uCgoKQWxleAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
