Return-Path: <SRS0=NSSj=46=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E820C1975A
	for <kvmarm@archiver.kernel.org>; Fri, 13 Mar 2020 01:39:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 236A9206E7
	for <kvmarm@archiver.kernel.org>; Fri, 13 Mar 2020 01:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 236A9206E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6384B4A7FE;
	Thu, 12 Mar 2020 21:39:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RYRriRsrzHak; Thu, 12 Mar 2020 21:39:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5515D4A650;
	Thu, 12 Mar 2020 21:39:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D16E94A5A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 21:39:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hsc2kbCVa+Um for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 21:39:21 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3331D4A51D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 21:39:21 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id F35E4EF00CE69FBB0358;
 Fri, 13 Mar 2020 09:39:17 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 13 Mar 2020
 09:39:10 +0800
Subject: Re: [PATCH v5 01/23] irqchip/gic-v3: Use SGIs without active state if
 offered
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-2-maz@kernel.org>
 <63f6530a-9369-31e6-88d0-5337173495b9@huawei.com>
 <51b2c74fdbcca049cc01be6d78c7c693@kernel.org>
 <1bff1835ba7d6e22edb836d38cf16a14@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3e20f3c3-0312-bd29-dcfc-2afee764ef19@huawei.com>
Date: Fri, 13 Mar 2020 09:39:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1bff1835ba7d6e22edb836d38cf16a14@kernel.org>
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

SGkgTWFyYywKCk9uIDIwMjAvMy8xMiAyMDowNSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MjAtMDMtMTIgMDk6MjgsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkgWmVuZ2h1aSwKPj4KPj4g
T24gMjAyMC0wMy0xMiAwNjozMCwgWmVuZ2h1aSBZdSB3cm90ZToKPj4+IEhpIE1hcmMsCj4+Pgo+
Pj4gT24gMjAyMC8zLzUgNDozMywgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IFRvIGFsbG93IHRo
ZSBkaXJlY3QgaW5qZWN0aW9uIG9mIFNHSXMgaW50byBhIGd1ZXN0LCB0aGUgR0lDdjQuMQo+Pj4+
IGFyY2hpdGVjdHVyZSBoYXMgdG8gc2FjcmlmaWNlIHRoZSBBY3RpdmUgc3RhdGUgc28gdGhhdCBT
R0lzIGxvb2sKPj4+PiBhIGxvdCBsaWtlIExQSXMgKHRoZXkgYXJlIGluamVjdGVkIGJ5IHRoZSBz
YW1lIG1lY2hhbmlzbSkuCj4+Pj4KPj4+PiBJbiBvcmRlciBub3QgdG8gYnJlYWsgZXhpc3Rpbmcg
c29mdHdhcmUsIHRoZSBhcmNoaXRlY3R1cmUgZ2l2ZXMKPj4+PiBvZmZlcnMgZ3Vlc3RzIE9TcyB0
aGUgY2hvaWNlOiBTR0lzIHdpdGggb3Igd2l0aG91dCBhbiBhY3RpdmUKPj4+PiBzdGF0ZS4gSXQg
aXMgdGhlIGh5cGVydmlzb3JzIGR1dHkgdG8gaG9ub3IgdGhlIGd1ZXN0J3MgY2hvaWNlLgo+Pj4+
Cj4+Pj4gRm9yIHRoaXMsIHRoZSBhcmNoaXRlY3R1cmUgb2ZmZXJzIGEgZGlzY292ZXJ5IGJpdCBp
bmRpY2F0aW5nIHdoZXRoZXIKPj4+PiB0aGUgR0lDIHN1cHBvcnRzIEdJQ3Y0LjEgU0dJcyAoR0lD
RF9UWVBFUjIubkFTU0dJY2FwKSwgYW5kIGFub3RoZXIKPj4+PiBiaXQgaW5kaWNhdGluZyB3aGV0
aGVyIHRoZSBndWVzdCB3YW50cyBBY3RpdmUtbGVzcyBTR0lzIG9yIG5vdAo+Pj4+IChjb250cm9s
bGVkIGJ5IEdJQ0RfQ1RMUi5uQVNTR0lyZXEpLgo+Pj4KPj4+IEkgc3RpbGwgY2FuJ3QgZmluZCB0
aGUgZGVzY3JpcHRpb24gb2YgdGhlc2UgdHdvIGJpdHMgaW4gSUhJMDA2OUYuCj4+PiBBcmUgdGhl
eSBhY3R1YWxseSBhcmNoaXRlY3RlZCBhbmQgd2lsbCBiZSBhdmFpbGFibGUgaW4gdGhlIGZ1dHVy
ZQo+Pj4gdmVyc2lvbiBvZiB0aGUgc3BlYz/CoCBJIHdhbnQgdG8gY29uZmlybSBpdCBhZ2FpbiBz
aW5jZSB0aGlzIGhhcyBhCj4+PiBncmVhdCBpbXBhY3Qgb24gdGhlIEtWTSBjb2RlLCBhbnkgcG9p
bnRlcnM/Cj4+Cj4+IERhbW4uIFRoZSBiaXRzICphcmUqIGluIHRoZSBlbmdpbmVlcmluZyBzcGVj
IHZlcnNpb24gMTkgKHVuZm9ydHVuYXRlbHkKPj4gbm90IGEgcHVibGljIGRvY3VtZW50LCBidXQg
SSBiZWxpZXZlIHlvdSBzaG91bGQgaGF2ZSBhY2Nlc3MgdG8gaXQpLgo+Pgo+PiBJZiB0aGUgYml0
cyBoYXZlIGVmZmVjdGl2ZWx5IGJlZW4gcmVtb3ZlZCBmcm9tIHRoZSBzcGVjLCBJJ2xsIGRyb3Ag
dGhlCj4+IEdJQ3Y0LjEgY29kZSBmcm9tIHRoZSA1LjcgcXVldWUgdW50aWwgd2UgZmluZCBhIHdh
eSB0byBhY2hpZXZlIHRoZSBzYW1lCj4+IGxldmVsIG9mIHN1cHBvcnQuCj4+Cj4+IEkndmUgZW1h
aWxlZCBwZW9wbGUgaW5zaWRlIEFSTSB0byBmaW5kIG91dC4KPiAKPiBJJ3ZlIG5vdyBoYWQgd3Jp
dHRlbiBjb25maXJtYXRpb24gdGhhdCB0aGUgYml0cyBhcmUgc3RpbGwgdGhlcmUuCj4gCj4gSXQg
aXMganVzdCB0aGF0IHRoZSBjdXJyZW50IHJldmlzaW9uIG9mIHRoZSBkb2N1bWVudGF0aW9uIHdh
cyBjdXQgKmJlZm9yZSoKPiB0aGV5IG1hZGUgaXQgaW50byB0aGUgYXJjaGl0ZWN0dXJlICh0aGVy
ZSBzZWVtIHRvIGJlIGEgNiBtb250aCBkZWxheSAKPiBiZXR3ZWVuCj4gdGhlIGFyY2hpdGVjdHVy
ZSBiZWluZyBzYW1wbGVkIGFuZCB0aGUgZG9jdW1lbnRhdGlvbiBiZWluZyByZWxlYXNlZCkuCgpJ
IHNlZS4gVGhhbmtzIGZvciB0aGUgY29uZmlybWF0aW9uIQoKClplbmdodWkKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
