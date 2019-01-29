From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: Kernel boot regression with PAuth and aarch64-softmmu -cpu max
 and el2 enabled
Date: Tue, 29 Jan 2019 11:54:13 +0000
Message-ID: <CAFEAcA-_ShbUthqPSPgEPmV0EeRUO85n=sC-+76gRAH830co_g@mail.gmail.com>
References: <87va27n2l8.fsf@linaro.org>
 <20190129114609.GA25983@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1EBC4A369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 06:54:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uge8+yjrmXIw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 06:54:24 -0500 (EST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com
 [209.85.210.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99C3B4A2D3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 06:54:24 -0500 (EST)
Received: by mail-ot1-f48.google.com with SMTP id 32so17564897ota.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 03:54:24 -0800 (PST)
In-Reply-To: <20190129114609.GA25983@lakrids.cambridge.arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Richard Henderson <richard.henderson@linaro.org>, qemu-devel <qemu-devel@nongnu.org>, Kristina Martsenko <kristina.martsenko@arm.com>, "open list:ARM" <qemu-arm@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gVHVlLCAyOSBKYW4gMjAxOSBhdCAxMTo0NiwgTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRA
YXJtLmNvbT4gd3JvdGU6Cj4gT24gVHVlLCBKYW4gMjksIDIwMTkgYXQgMTE6MDg6MTlBTSArMDAw
MCwgQWxleCBCZW5uw6llIHdyb3RlOgo+ID4gVGhlIC1jcHUgbWF4IGVuYWJsZWQgYSBjb3J0ZXgt
YTU3ICsgd2hhdGV2ZXIgZXh0cmEgZmVhdHVyZXMgd2UndmUKPiA+IGVuYWJsZWQgaW4gUUVNVSBz
byBmYXIuIEl0IHdvbid0IG1hdGNoIGFueSAicmVhbCIgQ1BVIGJ1dCBpdCBzaG91bGQgYmUKPiA+
IGFyY2hpdGVjdHVyYWxseSBjb3JyZWN0IGluIHNvIGZhciB3ZSBpbXBsZW1lbnQgcHJlcmVxdWlz
aXRlIGZlYXR1cmVzIGZvcgo+ID4gYW55IGdpdmVuIGZlYXR1cmUuIFRoZSBjcHVpZCBmZWF0dXJl
IGJpdHMgc2hvdWxkIGFsc28gYmUgY29ycmVjdCBhcyB3ZQo+ID4gdGVzdCB0aGVtIGludGVybmFs
bHkgaW4gUUVNVSB0byBlbmFibGUgZmVhdHVyZXMuCj4KPiBKdXN0IHRvIGNoZWNrLCBkb2VzIHRo
aXMgZW5hYmxlIFZIRT8KCkl0IGRvZXMgbm90LiAoV2UgaGF2ZSBubyBpbXBsZW1lbnRhdGlvbiBv
ZiBWSEUgeWV0IC0tIGFzIGFuZCB3aGVuCndlIGRvIGltcGxlbWVudCB0aGF0ICItY3B1IG1heCIg
d2lsbCB0dXJuIGl0IG9uLCBidXQgdG9kYXkgaXQgZG9lc24ndC4pCgp0aGFua3MKLS0gUE1NCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
