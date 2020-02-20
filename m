Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B45AC7619D
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 03:26:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2143F21D56
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 03:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2143F21D56
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E06E4AE92;
	Wed, 19 Feb 2020 22:26:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fzshTtAOlESY; Wed, 19 Feb 2020 22:26:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 874804AEAB;
	Wed, 19 Feb 2020 22:26:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1EFB4AE93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 22:25:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P8hjBfCzvOGf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 22:25:58 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98BB44AE92
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 22:25:58 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 51068A1533B41914DC60;
 Thu, 20 Feb 2020 11:25:49 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 11:25:43 +0800
Subject: Re: [PATCH v4 06/20] irqchip/gic-v4.1: Add initial SGI configuration
To: Marc Zyngier <maz@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-7-maz@kernel.org>
 <e47baffb-83a5-57d7-1721-eaee28aaaabf@huawei.com>
 <4a64bf17c015cb10e62d9c1a1ff64db5@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5d511c78-2339-2aea-8bfc-e13ed464af11@huawei.com>
Date: Thu, 20 Feb 2020 11:25:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <4a64bf17c015cb10e62d9c1a1ff64db5@kernel.org>
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

SGkgTWFyYywKCk9uIDIwMjAvMi8xOCAxNzo0NiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFpl
bmdodWksCj4gCj4gT24gMjAyMC0wMi0xOCAwNzoyNSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4gSGkg
TWFyYywKPiAKPiBbLi4uXQo+IAo+Pj4gwqDCoMKgIHN0YXRpYyB2b2lkIGl0c19zZ2lfaXJxX2Rv
bWFpbl9kZWFjdGl2YXRlKHN0cnVjdCBpcnFfZG9tYWluICpkb21haW4sCj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBpcnFfZGF0YSAqZCkK
Pj4+IMKgIHsKPj4+IC3CoMKgwqAgLyogTm90aGluZyB0byBkbyAqLwo+Pj4gK8KgwqDCoCBzdHJ1
Y3QgaXRzX3ZwZSAqdnBlID0gaXJxX2RhdGFfZ2V0X2lycV9jaGlwX2RhdGEoZCk7Cj4+PiArCj4+
PiArwqDCoMKgIHZwZS0+c2dpX2NvbmZpZ1tkLT5od2lycV0uZW5hYmxlZCA9IGZhbHNlOwo+Pj4g
K8KgwqDCoCBpdHNfY29uZmlndXJlX3NnaShkLCB0cnVlKTsKPj4KPj4gVGhlIHNwZWMgc2F5cywg
d2hlbiBDPT0xLCBWU0dJIGNsZWFycyB0aGUgcGVuZGluZyBzdGF0ZSBvZiB0aGUgdlNHSSwKPj4g
bGVhdmluZyB0aGUgY29uZmlndXJhdGlvbiB1bmNoYW5nZWQuwqAgU28gc2hvdWxkIHdlIGZpcnN0
IGNsZWFyIHRoZQo+PiBwZW5kaW5nIHN0YXRlIGFuZCB0aGVuIGRpc2FibGUgdlNHSSAobGV0IEU9
PTApPwo+IAo+IFJpZ2h0IHlvdSBhcmUgYWdhaW4uIFdlIG5lZWQgdHdvIGNvbW1hbmRzLCBub3Qg
anVzdCBvbmUgKHRoZSBwc2V1ZG9jb2RlIGlzCj4gcHJldHR5IGV4cGxpY2l0KS4KCldpdGggdGhh
dCBjaGFuZ2UsCgpSZXZpZXdlZC1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+
CgoKVGhhbmtzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
