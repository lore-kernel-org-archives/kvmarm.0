Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDB7C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 05:56:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2069461A1F
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 05:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2069461A1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DE864B459;
	Thu, 25 Mar 2021 01:56:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RLFYQn5QkXJi; Thu, 25 Mar 2021 01:56:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 856F94B455;
	Thu, 25 Mar 2021 01:56:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BDB64B419
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 01:56:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FjfqNTUotJIY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 01:56:25 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 201A94B354
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 01:56:25 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5Z71353SzwPVX;
 Thu, 25 Mar 2021 13:54:21 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 13:56:11 +0800
Subject: Re: [PATCH v5 0/6] KVM: arm64: Add VLPI migration support on GICv4.1
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Eric Auger
 <eric.auger@redhat.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>
References: <20210322060158.1584-1-lushenming@huawei.com>
 <161660992482.2080654.11109199563385851665.b4-ty@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <5c966333-97ec-aa52-068e-b037b42baf2c@huawei.com>
Date: Thu, 25 Mar 2021 13:56:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <161660992482.2080654.11109199563385851665.b4-ty@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Cornelia Huck <cohuck@redhat.com>
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

On 2021/3/25 2:19, Marc Zyngier wrote:
> On Mon, 22 Mar 2021 14:01:52 +0800, Shenming Lu wrote:
>> In GICv4.1, migration has been supported except for (directly-injected)
>> VLPI. And GICv4.1 Spec explicitly gives a way to get the VLPI's pending
>> state (which was crucially missing in GICv4.0). So we make VLPI migration
>> capable on GICv4.1 in this series.
>>
>> In order to support VLPI migration, we need to save and restore all
>> required configuration information and pending states of VLPIs. But
>> in fact, the configuration information of VLPIs has already been saved
>> (or will be reallocated on the dst host...) in vgic(kvm) migration.
>> So we only have to migrate the pending states of VLPIs specially.
>>
>> [...]
> 
> Applied to next, thanks!

Thanks a lot again for all the comments and suggestions. :-)

Shenming

> 
> [1/6] irqchip/gic-v3-its: Add a cache invalidation right after vPE unmapping
>       commit: 301beaf19739cb6e640ed44e630e7da993f0ecc8
> [2/6] irqchip/gic-v3-its: Drop the setting of PTZ altogether
>       commit: c21bc068cdbe5613d3319ae171c3f2eb9f321352
> [3/6] KVM: arm64: GICv4.1: Add function to get VLPI state
>       commit: 80317fe4a65375fae668672a1398a0fb73eb9023
> [4/6] KVM: arm64: GICv4.1: Try to save VLPI state in save_pending_tables
>       commit: f66b7b151e00427168409f8c1857970e926b1e27
> [5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to physical side
>       commit: 12df7429213abbfa9632ab7db94f629ec309a58b
> [6/6] KVM: arm64: GICv4.1: Give a chance to save VLPI state
>       commit: 8082d50f4817ff6a7e08f4b7e9b18e5f8bfa290d
> 
> Cheers,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
