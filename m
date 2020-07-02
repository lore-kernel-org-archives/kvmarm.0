Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8069CC433E1
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:02:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1210F20899
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1210F20899
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C6864B55E;
	Thu,  2 Jul 2020 05:02:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MoxBMTOPlyIp; Thu,  2 Jul 2020 05:02:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F63C4B5D2;
	Thu,  2 Jul 2020 05:02:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C738C4B517
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:02:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g713OhsCPG0w for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 05:02:25 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE7804B55E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:02:25 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id E0D8D6949F651C2B6A06;
 Thu,  2 Jul 2020 17:02:22 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Jul 2020
 17:02:18 +0800
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To: Marc Zyngier <maz@kernel.org>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <a570c59c-965f-8832-b0c3-4cfc342f18fe@huawei.com>
Date: Thu, 2 Jul 2020 17:02:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fe9699e3ee2131fe800911aea1425af4@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

SGkgTWFyYywKCk9uIDcvMi8yMDIwIDQ6MjIgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDIwLTA3LTAyIDA0OjAxLCBKaW5neWkgV2FuZyB3cm90ZToKPj4gSWYgZ2ljdjQuMShzZ2kgaGFy
ZHdhcmUgaW5qZWN0aW9uKSBzdXBwb3J0ZWQsIHdlIHRlc3QgaXBpIGluamVjdGlvbgo+PiB2aWEg
aHcvc3cgd2F5IHNlcGFyYXRlbHkuCj4gCj4gbml0OiBhY3RpdmUtbGVzcyBTR0lzIGFyZSBub3Qg
c3RyaWN0bHkgYSBmZWF0dXJlIG9mIEdJQ3Y0LjEgKHlvdSBjb3VsZAo+IGltYWdpbmUgYSBHSUMg
ZW11bGF0aW9uIG9mZmVyaW5nIHRoZSBzYW1lIHRoaW5nKS4gRnVydGhlcm1vcmUsIEdJQ3Y0LjEK
PiBpc24ndCBhcyBzdWNoIHZpc2libGUgdG8gdGhlIGd1ZXN0IGl0c2VsZiAoaXQgb25seSBzZWVz
IGEgR0lDdjMpLgo+IAo+IFRoYW5rcywKPiAKPiAgwqDCoMKgwqDCoMKgwqAgTS4KClllcywgYnV0
IHRvIG1lYXN1cmUgdGhlIHBlcmZvcm1hbmNlIGRpZmZlcmVuY2Ugb2YgaHcvc3cgU0dJIGluamVj
dGlvbiwKZG8geW91IHRoaW5rIGl0IGlzIGFjY2VwdGFibGUgdG8gbWFrZSBpdCB2aXNpYmxlIHRv
IGd1ZXN0IGFuZCBsZXQgaXQKc3dpdGNoIFNHSSBpbmplY3Rpb24gbW9kZT8KClRoYW5rcywKSmlu
Z3lpCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
