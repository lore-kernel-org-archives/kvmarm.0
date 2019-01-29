From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: Kernel boot regression with PAuth and aarch64-softmmu -cpu max
 and el2 enabled
Date: Tue, 29 Jan 2019 12:51:02 +0000
Message-ID: <20190129125101.GC25983@lakrids.cambridge.arm.com>
References: <87va27n2l8.fsf@linaro.org>
 <20190129114609.GA25983@lakrids.cambridge.arm.com>
 <CAFEAcA-_ShbUthqPSPgEPmV0EeRUO85n=sC-+76gRAH830co_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5229F4A321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 07:51:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UNb+miY9bDGh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 07:51:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ABBC4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 07:51:07 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA-_ShbUthqPSPgEPmV0EeRUO85n=sC-+76gRAH830co_g@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Richard Henderson <richard.henderson@linaro.org>, qemu-devel <qemu-devel@nongnu.org>, Kristina Martsenko <kristina.martsenko@arm.com>, "open list:ARM" <qemu-arm@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gVHVlLCBKYW4gMjksIDIwMTkgYXQgMTE6NTQ6MTNBTSArMDAwMCwgUGV0ZXIgTWF5ZGVsbCB3
cm90ZToKPiBPbiBUdWUsIDI5IEphbiAyMDE5IGF0IDExOjQ2LCBNYXJrIFJ1dGxhbmQgPG1hcmsu
cnV0bGFuZEBhcm0uY29tPiB3cm90ZToKPiA+IE9uIFR1ZSwgSmFuIDI5LCAyMDE5IGF0IDExOjA4
OjE5QU0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPiA+ID4gVGhlIC1jcHUgbWF4IGVuYWJs
ZWQgYSBjb3J0ZXgtYTU3ICsgd2hhdGV2ZXIgZXh0cmEgZmVhdHVyZXMgd2UndmUKPiA+ID4gZW5h
YmxlZCBpbiBRRU1VIHNvIGZhci4gSXQgd29uJ3QgbWF0Y2ggYW55ICJyZWFsIiBDUFUgYnV0IGl0
IHNob3VsZCBiZQo+ID4gPiBhcmNoaXRlY3R1cmFsbHkgY29ycmVjdCBpbiBzbyBmYXIgd2UgaW1w
bGVtZW50IHByZXJlcXVpc2l0ZSBmZWF0dXJlcyBmb3IKPiA+ID4gYW55IGdpdmVuIGZlYXR1cmUu
IFRoZSBjcHVpZCBmZWF0dXJlIGJpdHMgc2hvdWxkIGFsc28gYmUgY29ycmVjdCBhcyB3ZQo+ID4g
PiB0ZXN0IHRoZW0gaW50ZXJuYWxseSBpbiBRRU1VIHRvIGVuYWJsZSBmZWF0dXJlcy4KPiA+Cj4g
PiBKdXN0IHRvIGNoZWNrLCBkb2VzIHRoaXMgZW5hYmxlIFZIRT8KPiAKPiBJdCBkb2VzIG5vdC4g
KFdlIGhhdmUgbm8gaW1wbGVtZW50YXRpb24gb2YgVkhFIHlldCAtLSBhcyBhbmQgd2hlbgo+IHdl
IGRvIGltcGxlbWVudCB0aGF0ICItY3B1IG1heCIgd2lsbCB0dXJuIGl0IG9uLCBidXQgdG9kYXkg
aXQgZG9lc24ndC4pCgpPay4gSW4gdGhhdCBjYXNlLCB0aGUga2VybmVsIHNob3VsZCBkcm9wIHRv
IEVMMU4gYW5kIHN0YXkgdGhlcmUgYWZ0ZXIgaXQKY29uZmlndXJlcyBFTDIuCgpUaGVyZSBhcmUg
bm8gcG9pbnRlciBhdXRoZW50aWNhdGlvbiB0cmFwcyB0YWtlbiB0byBFTDFOLCBzbyBpZiBzb21l
dGhpbmcKaXMgZ29pbmcgd3JvbmcsIEkgc3VzcGVjdCBlaXRoZXI6CgoqIGEgdHJhcCBpcyB0YWtl
biB0byBFTDIsIGFuZCB3ZSBoeXBfcGFuaWMoKQoqIGFuIFVOREVGIGlzIGJlaW5nIHRha2VuIHRv
IEVMMU4KClRoYW5rcywKTWFyay4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
