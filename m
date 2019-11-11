Return-Path: <SRS0=kGQk=ZD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ECDC17441
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 16:07:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFDF62196E
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 16:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFDF62196E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 394944B050;
	Mon, 11 Nov 2019 11:07:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e46uvE-jQ1y8; Mon, 11 Nov 2019 11:07:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 032A24AF74;
	Mon, 11 Nov 2019 11:07:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF5BC4AF74
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 11:07:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LMSg6XQI3E39 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Nov 2019 11:07:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 662B84AF56
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 11:07:43 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05B0B31B;
 Mon, 11 Nov 2019 08:07:43 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6C8A3F534;
 Mon, 11 Nov 2019 08:07:41 -0800 (PST)
Subject: Re: [PATCH 1/2] arm64: Rename WORKAROUND_1165522 to SPECULATIVE_AT
To: Marc Zyngier <maz@kernel.org>
References: <20191111141157.55062-1-steven.price@arm.com>
 <20191111141157.55062-2-steven.price@arm.com>
 <160a852027f4481cc63aed72c4f4a409@www.loen.fr>
From: Steven Price <steven.price@arm.com>
Message-ID: <013eec05-b558-d97a-bf95-248a62f25dc5@arm.com>
Date: Mon, 11 Nov 2019 16:07:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <160a852027f4481cc63aed72c4f4a409@www.loen.fr>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

T24gMTEvMTEvMjAxOSAxNTo0MiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFN0ZXZlbiwKPiAK
PiBPbiAyMDE5LTExLTExIDE1OjIxLCBTdGV2ZW4gUHJpY2Ugd3JvdGU6Cj4+IENvcnRleC1BNTUg
aXMgYWZmZWN0ZWQgYnkgYSBzaW1pbGFyIGVycmF0dW0sIHNvIHJlbmFtZSB0aGUgZXhpc3RpbmcK
Pj4gd29ya2Fyb3VuZCBmb3IgZXJyYXJ1bSAxMTY1NTIyIHNvIGl0IGNhbiBiZSB1c2VkIGZvciBi
b3RoIGVycmF0YS4KPiAKPiBuaXQ6IGVycmF0dW0KClRoYW5rcywgSSBkbyBzZWVtIHRvIGhhdmUg
dHJvdWJsZSBzcGVsbGluZyBpdCBjb3JyZWN0bHkgOikKCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFN0
ZXZlbiBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+Cj4+IC0tLQo+PiDCoGFyY2gvYXJtNjQv
S2NvbmZpZ8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNCArKysrCj4+IMKgYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9jcHVjYXBzLmjCoCB8wqAgMiArLQo+PiDCoGFyY2gvYXJtNjQv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8wqAgMiArLQo+PiDCoGFyY2gvYXJtNjQvaW5jbHVkZS9h
c20va3ZtX2h5cC5owqAgfMKgIDMgKy0tCj4+IMKgYXJjaC9hcm02NC9rZXJuZWwvY3B1X2VycmF0
YS5jwqDCoMKgIHwgMTcgKysrKysrKysrKysrKy0tLS0KPj4gwqBhcmNoL2FybTY0L2t2bS9oeXAv
c3dpdGNoLmPCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPj4gwqBhcmNoL2FybTY0L2t2bS9oeXAvdGxi
LmPCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQgKystLQo+PiDCoDcgZmlsZXMgY2hhbmdlZCwgMjMg
aW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L0tjb25maWcgYi9hcmNoL2FybTY0L0tjb25maWcKPj4gaW5kZXggM2YwNDdhZmI5ODJjLi42
Y2I0ZWZmNjAyYzYgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQvS2NvbmZpZwo+PiArKysgYi9h
cmNoL2FybTY0L0tjb25maWcKPj4gQEAgLTUxMCw5ICs1MTAsMTMgQEAgY29uZmlnIEFSTTY0X0VS
UkFUVU1fMTQxODA0MAo+Pgo+PiDCoMKgwqDCoMKgwqAgSWYgdW5zdXJlLCBzYXkgWS4KPj4KPj4g
K2NvbmZpZyBBUk02NF9XT1JLQVJPVU5EX1NQRUNVTEFUSVZFX0FUCj4+ICvCoMKgwqAgYm9vbAo+
PiArCj4+IMKgY29uZmlnIEFSTTY0X0VSUkFUVU1fMTE2NTUyMgo+PiDCoMKgwqDCoCBib29sICJD
b3J0ZXgtQTc2OiBTcGVjdWxhdGl2ZSBBVCBpbnN0cnVjdGlvbiB1c2luZyBvdXQtb2YtY29udGV4
dAo+PiB0cmFuc2xhdGlvbiByZWdpbWUgY291bGQgY2F1c2Ugc3Vic2VxdWVudCByZXF1ZXN0IHRv
IGdlbmVyYXRlIGFuCj4+IGluY29ycmVjdCB0cmFuc2xhdGlvbiIKPj4gwqDCoMKgwqAgZGVmYXVs
dCB5Cj4+ICvCoMKgwqAgc2VsZWN0IEFSTTY0X1dPUktBUk9VTkRfU1BFQ1VMQVRJVkVfQVQKPiAK
PiBJJ2Qgb2JqZWN0IHRoYXQgQVJNNjRfRVJSQVRVTV8xMzE5MzY3IChhbmQgaXRzIGJpZyBicm90
aGVyIDEzMTk1MzcpCj4gYXJlIGFsc28gcmVsYXRlZCB0byBzcGVjdWxhdGl2ZSBBVCBleGVjdXRp
b24sIGFuZCB5ZXQgYXJlIG5vdCBjb3ZlcmVkCj4gYnkgdGhpcyBjb25maWd1cmF0aW9uIHN5bWJv
bC4KCkdvb2QgcG9pbnQuCgo+IEkgY2FuIHNlZSB0aHJlZSBzb2x1dGlvbnMgdG8gdGhpczoKPiAK
PiAtIEVpdGhlciB5b3UgY2FsbCBpdCBTUEVDVUxBVElWRV9BVF9WSEUgYW5kIGludHJvZHVjZSBT
UEVDVUxBVElWRV9BVF9OVkhFCj4gwqAgZm9yIHN5bW1ldHJ5CgpUZW1wdGluZy4uLgoKPiAtIE9y
IHlvdSBtYWtlIFNQRUNVTEFUSVZFX0FUIGNvdmVyIGFsbCB0aGUgc3BlY3VsYXRpdmUgQVQgZXJy
YXRhLCB3aGljaAo+IMKgIG1heSBvciBtYXkgbm90IHdvcmsuLi4KClRoaXMgYWN0dWFsbHkgc291
bmRzIHRoZSBuZWF0ZXN0LCBidXQgSSdtIG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUncyBnb2luZwp0
byBiZSBhbnkgY29uZmxpY3RzIGJldHdlZW4gVkhFL05WSEUuIEknbGwgcHJvdG90eXBlIHRoaXMg
YW5kIHNlZSBob3cKdWdseSBpdCBpcy4KCj4gLSBPciBldmVuIGJldHRlciwgeW91IGp1c3QgYW1t
ZW5kIHRoZSBkb2N1bWVudGF0aW9uIHRvIHNheSB0aGF0IDExNjU1MjIKPiDCoCBhbHNvIGNvdmVy
cyB0aGUgbmV3bHkgZm91bmQgQTU1IG9uZSAoanVzdCBsaWtlIHdlIGhhdmUgZm9yIEE1Ny9BNzIp
CgpXZWxsIE1hcmsgUnV0bGFuZCBkaXNsaWtlZCBteSBpbml0aWFsIHRob3VnaHRzIGFib3V0IGp1
c3QgaW5jbHVkaW5nIGJvdGgKZXJyYXRhIGluIG9uZSBvcHRpb24gbGlrZSB0aGF0IC0gaGVuY2Ug
dGhlIHJlZmFjdG9yaW5nIGluIHRoaXMgcGF0Y2guCkFsdGhvdWdoIG9mIGNvdXJzZSB0aGF0J3Mg
ZXhhY3RseSB3aGF0J3MgaGFwcGVuZWQgd2l0aCAxMzE5MzY3LzEzMTk1MzcuLi4KCj4gV2hhdCBk
byB5b3UgdGhpbms/CgpJJ2xsIGhhdmUgYSBnbyBhdCBTUEVDVUxBVElWRV9BVCBjb3ZlcmluZyBi
b3RoIFZIRS9OVkhFIC0gZnJvbSBhbgppbml0aWFsIGxvb2sgaXQgc2VlbXMgbGlrZSBpdCBzaG91
bGQgd29yayBhbmQgaXQgd291bGQgYmUgbmVhdCBpZiBpdApkb2VzLiBJbiBwYXJ0aWN1bGFyIGl0
IHNob3VsZCBhdm9pZCB0aGUgbmVjZXNzaXR5IHRvIHJlcXVpcmUgVkhFIHdoZW4KdGhlIGVycmF0
dW0gaXMgcHJlc2VudC4KCk90aGVyd2lzZSBJIGd1ZXNzIFNQRUNVTEFUSVZFX0FUX3ssTn1WSEUg
aXMgcHJvYmFibHkgc2Vjb25kIGJlc3QuCgpUaGFua3MsCgpTdGV2ZQpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
