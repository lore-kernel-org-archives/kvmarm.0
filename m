Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3524C47096
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:36:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82FEC61242
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82FEC61242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DED64B0DA;
	Thu,  3 Jun 2021 08:36:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1rX3WMf9rxRH; Thu,  3 Jun 2021 08:36:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E53314B0BB;
	Thu,  3 Jun 2021 08:36:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1D0B4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:36:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3JpiurxCmCyw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 08:36:09 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55CB64A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:36:09 -0400 (EDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fwlg32jSmzYqSD;
 Thu,  3 Jun 2021 20:33:19 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:36:04 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:36:02 +0800
Subject: Re: [PATCH v5 1/6] KVM: arm64: Introduce KVM_PGTABLE_S2_GUEST stage-2
 flag
To: Quentin Perret <qperret@google.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-2-wangyanan55@huawei.com> <YLdg3K6m0P+cis2P@google.com>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <2d5ed3b0-5e8f-572e-cee9-84d6c9d2410c@huawei.com>
Date: Thu, 3 Jun 2021 20:36:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YLdg3K6m0P+cis2P@google.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Quentin,

On 2021/6/2 18:43, Quentin Perret wrote:
> Hi Yanan,
>
> On Thursday 15 Apr 2021 at 19:50:27 (+0800), Yanan Wang wrote:
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index c3674c47d48c..a43cbe697b37 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -61,10 +61,12 @@ struct kvm_pgtable_mm_ops {
>>    * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
>>    *				ARM64_HAS_STAGE2_FWB.
>>    * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
>> + * @KVM_PGTABLE_S2_GUEST:	Whether the page-tables are guest stage-2.
>>    */
>>   enum kvm_pgtable_stage2_flags {
>>   	KVM_PGTABLE_S2_NOFWB			= BIT(0),
>>   	KVM_PGTABLE_S2_IDMAP			= BIT(1),
>> +	KVM_PGTABLE_S2_GUEST			= BIT(2),
> Assuming that we need this flag (maybe not given Marc's suggestion on
> another patch), I'd recommend re-naming it to explain _what_ it does,
> rather than _who_ is using it.
I agree with this.
> That's the principle we followed for e.g. KVM_PGTABLE_S2_IDMAP, so we
> should be consistent here as well.
But I think maybe we don't need the new flag anymore with Marc's suggestion.
Currently the CMOs right before installation or update of a PTE are 
guest-specific.
So if we also take the new optional callbacks as guest specific, then a 
new flag is
not necessary because we can check whether the callbacks have been 
initialized
to determine if we are managing a guest S2 PTE.

Thanks,
Yanan
> Thanks,
> Quentin
> .

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
