Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B478BC4332B
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 12:09:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47A9520732
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 12:09:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47A9520732
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC7C4A4A0;
	Fri, 20 Mar 2020 08:09:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TIsQDSH+lWkb; Fri, 20 Mar 2020 08:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 725BD4B080;
	Fri, 20 Mar 2020 08:09:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D93E04B080
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 08:09:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fkCsCLGbrdN7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 08:09:31 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9B724A4A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 08:09:30 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 01604CD906C56B9B967F;
 Fri, 20 Mar 2020 20:09:21 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 20:09:13 +0800
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
 <e1a1e537-9f8e-5cfb-0132-f796e8bf06c9@huawei.com>
 <b63950513f519d9a04f9719f5aa6a2db@kernel.org>
 <8d7fdb7f-7a21-da22-52a2-51ee8ac9393f@huawei.com>
 <40cbdf23c0f8bfc229400c14899ecbe0@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <facb4eb5-57c6-e0d0-003d-ebaa0b83e6f2@huawei.com>
Date: Fri, 20 Mar 2020 20:09:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <40cbdf23c0f8bfc229400c14899ecbe0@kernel.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/3/20 19:46, Marc Zyngier wrote:
>>> Side note: it'd be good to know what the rules are for your own GICv4
>>> implementations, so that we can at least make sure the current code 
>>> is safe.
>>
>> As far as I know, there will be some clean and invalidate operations
>> when v4.0 VPENDBASER.Valid gets programmed.
> 
> Interesting. The ideal behaviour would be that the VPT is up-to-date and
> the caches clean when Valid is cleared (and once Dirty flips to 0).
> 
>> But not sure about behaviors
>> on VMAPP (unmap), it may be a totally v4.1 stuff. I'll have a talk with
>> our SOC team.
> 
> The VMAPP stuff is purely v4.1.
> 
>> But how can the current code be unsafe? Is anywhere in the current code
>> will peek/poke the vpt (whilst GIC continues writing things into it)?
> 
> No. But on VM termination, the memory will be freed, and will eventually be
> reallocated. If the GIC can still write to that memory after it has been
> freed, you end-up with memory corruption... Which is why I'm curious of
> what ensures that on your implementation.

Ah, I got it. I will check it with HiSilicon people next week and go
back to you if the code becomes unsafe due to the incomplete GICv4.


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
