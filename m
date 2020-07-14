Return-Path: <SRS0=ASFk=AZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C0CC433E4
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jul 2020 02:20:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 18BE320890
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jul 2020 02:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18BE320890
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938084B1E4;
	Mon, 13 Jul 2020 22:20:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2UAMhCpIFzr7; Mon, 13 Jul 2020 22:20:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A38534B0D5;
	Mon, 13 Jul 2020 22:20:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93ADE4B0D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 22:20:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zJMWigRdBqB2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 22:20:18 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 264A94B0BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 22:20:18 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 8A0D837A6564268E680D;
 Tue, 14 Jul 2020 10:20:14 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 14 Jul 2020 10:20:08 +0800
To: <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>, James Morse
 <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, "Suzuki K, Poulose" <suzuki.poulose@arm.com>
From: zhukeqian <zhukeqian1@huawei.com>
Subject: [Question] About scaling factor of Enhanced Counter Virtualization
Message-ID: <e435efd2-f894-ecbb-5eb4-abf446aa1e56@huawei.com>
Date: Tue, 14 Jul 2020 10:20:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: yebiaoxiang@huawei.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi all,

We are studying Enhanced Counter Virtualization (introduced by ARMv8.6 extension), and here is a question
raised by Biaoxiang Ye <yebiaoxiang@huawei.com>:

Described in the ARMv8.6 Extension Specification:
Note: the scaling factor CNTSCALE is designed as a 2.62 bit fixed point number, so permitting a scaling up by
(nearly) a factor 4. The scaling factor CNTISCALE is signed as an 8.56 number for the scaling of the values
written into the timers for comparison with the actual count. This implies that the greatest scaling down of the
counter supported in (nearly) a factor of *512*.

We think the number "512" should be "256" (2^8), or do we miss something?

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
