Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D960C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 13:40:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7256D221FB
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 13:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7256D221FB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D0BF4B363;
	Wed,  2 Dec 2020 08:40:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7dsRlvS6TyB6; Wed,  2 Dec 2020 08:40:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FF314B347;
	Wed,  2 Dec 2020 08:40:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 526E04B340
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 08:00:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V60wHDgr8hyh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 08:00:21 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 493DC4B33E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 08:00:21 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CmJw55c63zhlpC;
 Wed,  2 Dec 2020 20:59:49 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Wed, 2 Dec 2020 21:00:01 +0800
To: Auger Eric <eric.auger@redhat.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
From: Wang Xingang <wangxingang5@huawei.com>
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Message-ID: <8cf8fa21-41e3-f3f9-81e4-90f0bfc26fc0@huawei.com>
Date: Wed, 2 Dec 2020 20:59:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Wed, 02 Dec 2020 08:40:00 -0500
Cc: xieyingtai@huawei.com, jean-philippe@linaro.org, kvm@vger.kernel.org,
 maz@kernel.org, joro@8bytes.org, will@kernel.org,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 vivek.gautam@arm.com, alex.williamson@redhat.com, zhangfei.gao@linaro.org,
 robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

Thanks for your reply. We are testing vSVA, and will let you know if
other problems are found.

On 2020/12/1 21:58, Auger Eric wrote:
> Hi Xingang,
> 
> On 12/1/20 2:33 PM, Xingang Wang wrote:
>> Hi Eric
>>
>> On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
>>> @@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>>> 	 * insertion to guarantee those are observed before the TLBI. Do be
>>> 	 * careful, 007.
>>> 	 */
>>> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>> +	if (ext_asid >= 0) { /* guest stage 1 invalidation */
>>> +		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>>> +		cmd.tlbi.asid	= ext_asid;
>>> +		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
>>> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>
>> Found a problem here, the cmd for guest stage 1 invalidation is built,
>> but it is not delivered to smmu.
>>
> 
> Thank you for the report. I will fix that soon. With that fixed, have
> you been able to run vSVA on top of the series. Do you need other stuff
> to be fixed at SMMU level? As I am going to respin soon, please let me
> know what is the best branch to rebase to alleviate your integration.
> 
> Best Regards
> 
> Eric
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
