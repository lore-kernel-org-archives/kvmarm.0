Return-Path: <SRS0=2z/n=4T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E90C3F2D2
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10FD6246B4
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10FD6246B4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0C34AF13;
	Mon,  2 Mar 2020 03:18:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fzzQ9lksY0xR; Mon,  2 Mar 2020 03:18:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 586D84AF10;
	Mon,  2 Mar 2020 03:18:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D238C4AF13
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2020 03:18:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w893ZIeTdV9C for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2020 03:18:24 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8FB34AEFC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2020 03:18:23 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id BEDB48D133E4FD5F10B3;
 Mon,  2 Mar 2020 16:18:17 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 2 Mar 2020
 16:18:09 +0800
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To: Marc Zyngier <maz@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
 <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
 <dd9f1224b3b21ad793862406bd8855ba@kernel.org>
 <54c52057161f925c818446953050c951@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4f8f3958-2976-b0a7-8d17-440ecaba0fc8@huawei.com>
Date: Mon, 2 Mar 2020 16:18:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <54c52057161f925c818446953050c951@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert
 Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC8zLzIgMzowMCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMDItMjggMTk6
MzcsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMC0wMi0yMCAwMzoxMSwgWmVuZ2h1aSBZ
dSB3cm90ZToKPiAKPj4+IERvIHdlIHJlYWxseSBuZWVkIHRvIGdyYWIgdGhlIHZwZV9sb2NrIGZv
ciB0aG9zZSB3aGljaCBhcmUgYmVsb25nIHRvCj4+PiB0aGUgc2FtZSBpcnFjaGlwIHdpdGggaXRz
X3ZwZV9zZXRfYWZmaW5pdHkoKT8gVGhlIElSUSBjb3JlIGNvZGUgc2hvdWxkCj4+PiBhbHJlYWR5
IGVuc3VyZSB0aGUgbXV0dWFsIGV4Y2x1c2lvbiBhbW9uZyB0aGVtLCB3cm9uZz8KPj4KPj4gSSd2
ZSBiZWVuIHRyeWluZyB0byB0aGluayBhYm91dCB0aGF0LCBidXQgamV0LWxhZyBrZWVwcyBnZXR0
aW5nIGluIHRoZSAKPj4gd2F5Lgo+PiBJIGVtcGlyaWNhbGx5IHRoaW5rIHRoYXQgeW91IGFyZSBy
aWdodCwgYnV0IEkgbmVlZCB0byBnbyBhbmQgY2hlY2sgdGhlIAo+PiB2YXJpb3VzCj4+IGNvZGUg
cGF0aHMgdG8gYmUgc3VyZS4gSG9wZWZ1bGx5IEknbGwgaGF2ZSBhIGJpdCBtb3JlIGJyYWluIHNw
YWNlIG5leHQgCj4+IHdlZWsuCj4gCj4gU28gSSBzbGVwdCBvbiBpdCBhbmQgY2FtZSBiYWNrIHRv
IG15IHNlbnNlcy4gVGhlIG9ubHkgY2FzZSB3ZSBhY3R1YWxseSBuZWVkCj4gdG8gZGVhbCB3aXRo
IGlzIHdoZW4gYW4gYWZmaW5pdHkgY2hhbmdlIGltcGFjdHMgKmFub3RoZXIqIGludGVycnVwdC4K
PiAKPiBUaGVyZSBpcyBvbmx5IHR3byBpbnN0YW5jZXMgb2YgdGhpcyBpc3N1ZToKPiAKPiAtIHZM
UElzIGhhdmUgdGhlaXIgKnBoeXNpY2FsKiBhZmZpbml0eSBpbXBhY3RlZCBieSB0aGUgYWZmaW5p
dHkgb2YgdGhlCj4gIMKgIHZQRS4gVGhlaXIgdmlydHVhbCBhZmZpbml0eSBpcyBvZiBjb3Vyc2Ug
dW5jaGFuZ2VkLCBidXQgdGhlIHBoeXNpY2FsCj4gIMKgIG9uZSBiZWNvbWVzIGltcG9ydGFudCB3
aXRoIGRpcmVjdCBpbnZhbGlkYXRpb24uIFRha2luZyBhIHBlci1WUEUgbG9jawo+ICDCoCBpbiBz
dWNoIGNvbnRleHQgc2hvdWxkIGFkZHJlc3MgdGhlIGlzc3VlLgo+IAo+IC0gdlNHSXMgaGF2ZSB0
aGUgZXhhY3Qgc2FtZSBpc3N1ZSwgcGx1cyB0aGUgbWF0dGVyIG9mIHJlcXVpcmluZyBzb21lCj4g
IMKgICpleHRyYSogb25lIHdoZW4gcmVhZGluZyB0aGUgcGVuZGluZyBzdGF0ZSwgd2hpY2ggcmVx
dWlyZXMgYSBSTVcKPiAgwqAgb24gdHdvIGRpZmZlcmVudCByZWdpc3RlcnMuIFRoaXMgcmVxdWly
ZXMgYW4gZXh0cmEgcGVyLVJEIGxvY2suCgpBZ3JlZWQgd2l0aCBib3RoIQoKPiAKPiBNeSBvcmln
aW5hbCBwYXRjaCB3YXMgc3R1cGlkbHkgY29tcGxleCwgYW5kIHRoZSBpcnFfZGVzYyBsb2NrIGlz
Cj4gcGVyZmVjdGx5IGVub3VnaCB0byBkZWFsIHdpdGggYW55dGhpbmcgdGhhdCBvbmx5IGFmZmVj
dHMgdGhlIGludGVycnVwdAo+IHN0YXRlIGl0c2VsZi4KPiAKPiBHSUN2NCArIGRpcmVjdCBpbnZh
bGlkYXRpb24gZm9yIHZMUElzIGJyZWFrcyB0aGlzIGJ5IGJ5cGFzc2luZyB0aGUKPiBzZXJpYWxp
emF0aW9uIGluaXRpYWxseSBwcm92aWRlZCBieSB0aGUgSVRTLCBhcyB0aGUgUkQgaXMgY29tcGxl
dGVseQo+IG91dCBvZiBiYW5kLiBUaGUgcGVyLXZQRSBsb2NrIGJyaW5ncyBiYWNrIHRoaXMgc2Vy
aWFsaXphdGlvbi4KPiAKPiBJJ3ZlIHVwZGF0ZWQgdGhlIGJyYW5jaCwgd2hpY2ggc2VlbXMgdG8g
cnVuIE9LIG9uIEQwNS4gSSBzdGlsbCBuZWVkCj4gdG8gcnVuIHRoZSB1c3VhbCB0ZXN0cyBvbiB0
aGUgRlZQIG1vZGVsIHRob3VnaC4KCkkgaGF2ZSBwdWxsZWQgdGhlIGxhdGVzdCBicmFuY2ggYW5k
IGl0IGxvb2tzIGdvb2QgdG8gbWUsIGV4Y2VwdCBmb3IKb25lIHJlbWFpbmluZyBjb25jZXJuOgoK
R0lDUl9JTlZ7TFBJLCBBTEx9UiArIEdJQ1JfU1lOQ1IgY2FuIGFsc28gYmUgYWNjZXNzZWQgY29u
Y3VycmVudGx5CmJ5IG11bHRpcGxlIGRpcmVjdCBpbnZhbGlkYXRpb24sIHNob3VsZCB3ZSBhbHNv
IHVzZSB0aGUgcGVyLVJEIGxvY2sKdG8gZW5zdXJlIG11dHVhbCBleGNsdXNpb24/ICBJdCBsb29r
cyBub3Qgc28gaGFybWZ1bCB0aG91Z2gsIGFzIHRoaXMKd2lsbCBvbmx5IGluY3JlYXNlIG9uZSdz
IHBvbGxpbmcgdGltZSBhZ2FpbnN0IHRoZSBCdXN5IGJpdCAoaW4gbXkgdmlldykuCgpCdXQgSSBw
b2ludCBpdCBvdXQgYWdhaW4gZm9yIGNvbmZpcm1hdGlvbi4KCgpUaGFua3MsClplbmdodWkKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
