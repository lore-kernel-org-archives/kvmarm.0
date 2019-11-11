Return-Path: <SRS0=kGQk=ZD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3108FC43331
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 17:16:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8C9820656
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 17:16:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8C9820656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CB524B00F;
	Mon, 11 Nov 2019 12:16:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BNROpTb5tkuS; Mon, 11 Nov 2019 12:16:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E89C74B0EC;
	Mon, 11 Nov 2019 12:16:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7F874B0FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 12:16:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rBNPjcBomM0G for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Nov 2019 12:16:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6273C4B09A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 12:16:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2D0731B;
 Mon, 11 Nov 2019 09:16:44 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8ED4D3F534;
 Mon, 11 Nov 2019 09:16:43 -0800 (PST)
Date: Mon, 11 Nov 2019 17:16:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 1/2] arm64: Rename WORKAROUND_1165522 to SPECULATIVE_AT
Message-ID: <20191111171621.GA30274@lakrids.cambridge.arm.com>
References: <20191111141157.55062-1-steven.price@arm.com>
 <20191111141157.55062-2-steven.price@arm.com>
 <160a852027f4481cc63aed72c4f4a409@www.loen.fr>
 <013eec05-b558-d97a-bf95-248a62f25dc5@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <013eec05-b558-d97a-bf95-248a62f25dc5@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gTW9uLCBOb3YgMTEsIDIwMTkgYXQgMDQ6MDc6MzlQTSArMDAwMCwgU3RldmVuIFByaWNlIHdy
b3RlOgo+IE9uIDExLzExLzIwMTkgMTU6NDIsIE1hcmMgWnluZ2llciB3cm90ZToKPiA+PiArY29u
ZmlnIEFSTTY0X1dPUktBUk9VTkRfU1BFQ1VMQVRJVkVfQVQKPiA+PiArwqDCoMKgIGJvb2wKPiA+
PiArCj4gPj4gwqBjb25maWcgQVJNNjRfRVJSQVRVTV8xMTY1NTIyCj4gPj4gwqDCoMKgwqAgYm9v
bCAiQ29ydGV4LUE3NjogU3BlY3VsYXRpdmUgQVQgaW5zdHJ1Y3Rpb24gdXNpbmcgb3V0LW9mLWNv
bnRleHQKPiA+PiB0cmFuc2xhdGlvbiByZWdpbWUgY291bGQgY2F1c2Ugc3Vic2VxdWVudCByZXF1
ZXN0IHRvIGdlbmVyYXRlIGFuCj4gPj4gaW5jb3JyZWN0IHRyYW5zbGF0aW9uIgo+ID4+IMKgwqDC
oMKgIGRlZmF1bHQgeQo+ID4+ICvCoMKgwqAgc2VsZWN0IEFSTTY0X1dPUktBUk9VTkRfU1BFQ1VM
QVRJVkVfQVQKPiA+IAo+ID4gSSdkIG9iamVjdCB0aGF0IEFSTTY0X0VSUkFUVU1fMTMxOTM2NyAo
YW5kIGl0cyBiaWcgYnJvdGhlciAxMzE5NTM3KQo+ID4gYXJlIGFsc28gcmVsYXRlZCB0byBzcGVj
dWxhdGl2ZSBBVCBleGVjdXRpb24sIGFuZCB5ZXQgYXJlIG5vdCBjb3ZlcmVkCj4gPiBieSB0aGlz
IGNvbmZpZ3VyYXRpb24gc3ltYm9sLgo+IAo+IEdvb2QgcG9pbnQuCj4gCj4gPiBJIGNhbiBzZWUg
dGhyZWUgc29sdXRpb25zIHRvIHRoaXM6Cj4gPiAKPiA+IC0gRWl0aGVyIHlvdSBjYWxsIGl0IFNQ
RUNVTEFUSVZFX0FUX1ZIRSBhbmQgaW50cm9kdWNlIFNQRUNVTEFUSVZFX0FUX05WSEUKPiA+IMKg
IGZvciBzeW1tZXRyeQo+IAo+IFRlbXB0aW5nLi4uCgpGV0lXLCB0aGlzIHNvdW5kcyBmaW5lIHRv
IG1lLgoKPiA+IC0gT3IgeW91IG1ha2UgU1BFQ1VMQVRJVkVfQVQgY292ZXIgYWxsIHRoZSBzcGVj
dWxhdGl2ZSBBVCBlcnJhdGEsIHdoaWNoCj4gPiDCoCBtYXkgb3IgbWF5IG5vdCB3b3JrLi4uCj4g
Cj4gVGhpcyBhY3R1YWxseSBzb3VuZHMgdGhlIG5lYXRlc3QsIGJ1dCBJJ20gbm90IHN1cmUgd2hl
dGhlciB0aGVyZSdzIGdvaW5nCj4gdG8gYmUgYW55IGNvbmZsaWN0cyBiZXR3ZWVuIFZIRS9OVkhF
LiBJJ2xsIHByb3RvdHlwZSB0aGlzIGFuZCBzZWUgaG93Cj4gdWdseSBpdCBpcy4KPiAKPiA+IC0g
T3IgZXZlbiBiZXR0ZXIsIHlvdSBqdXN0IGFtbWVuZCB0aGUgZG9jdW1lbnRhdGlvbiB0byBzYXkg
dGhhdCAxMTY1NTIyCj4gPiDCoCBhbHNvIGNvdmVycyB0aGUgbmV3bHkgZm91bmQgQTU1IG9uZSAo
anVzdCBsaWtlIHdlIGhhdmUgZm9yIEE1Ny9BNzIpCj4gCj4gV2VsbCBNYXJrIFJ1dGxhbmQgZGlz
bGlrZWQgbXkgaW5pdGlhbCB0aG91Z2h0cyBhYm91dCBqdXN0IGluY2x1ZGluZyBib3RoCj4gZXJy
YXRhIGluIG9uZSBvcHRpb24gbGlrZSB0aGF0IC0gaGVuY2UgdGhlIHJlZmFjdG9yaW5nIGluIHRo
aXMgcGF0Y2guCj4gQWx0aG91Z2ggb2YgY291cnNlIHRoYXQncyBleGFjdGx5IHdoYXQncyBoYXBw
ZW5lZCB3aXRoIDEzMTkzNjcvMTMxOTUzNy4uLgoKTXkgdmlldyBvbiB0aGlzIGlzIHRoYXQgdXNp
bmcgb25lIGVycmF0dW0gY29uZmlnIHN5bWJvbCB0byBjb3ZlciB0aGUKd29ya2Fyb3VuZCBmb3Ig
YW5vdGhlciBpcyBtb3JlIGNvbmZ1c2luZyB0aGFuIGhhdmluZyBhIGxldmVsIG9mCmluZGlyZWN0
aW9uLCBhbmQgSSB3b3VsZCd2ZSBwcmVmZXJyZWQgdGhlIGluZGlyZWN0aW9uIGZvciB0aGF0IGNh
c2UgdG9vLgogCj4gPiBXaGF0IGRvIHlvdSB0aGluaz8KPiAKPiBJJ2xsIGhhdmUgYSBnbyBhdCBT
UEVDVUxBVElWRV9BVCBjb3ZlcmluZyBib3RoIFZIRS9OVkhFIC0gZnJvbSBhbgo+IGluaXRpYWwg
bG9vayBpdCBzZWVtcyBsaWtlIGl0IHNob3VsZCB3b3JrIGFuZCBpdCB3b3VsZCBiZSBuZWF0IGlm
IGl0Cj4gZG9lcy4gSW4gcGFydGljdWxhciBpdCBzaG91bGQgYXZvaWQgdGhlIG5lY2Vzc2l0eSB0
byByZXF1aXJlIFZIRSB3aGVuCj4gdGhlIGVycmF0dW0gaXMgcHJlc2VudC4KPiAKPiBPdGhlcndp
c2UgSSBndWVzcyBTUEVDVUxBVElWRV9BVF97LE59VkhFIGlzIHByb2JhYmx5IHNlY29uZCBiZXN0
LgoKQm90aCBzb3VuZCBnb29kIHRvIG1lLgoKVGhhbmtzIGZvciBkZWFsaW5nIHdpdGggdGhpcyEK
Ck1hcmsuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
