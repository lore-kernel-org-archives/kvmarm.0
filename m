Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1048C433E3
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:43:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87E4720758
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:43:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87E4720758
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 083B74B647;
	Mon, 17 Aug 2020 04:43:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zkEH4jZa1Eho; Mon, 17 Aug 2020 04:43:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C7B4BF34;
	Mon, 17 Aug 2020 04:43:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 123514BF34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:43:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GuXqXtc0UHYY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 04:43:25 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAE9C4B647
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:43:24 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id B2129354BE937E759B8A;
 Mon, 17 Aug 2020 16:43:20 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 16:43:14 +0800
Subject: Re: [PATCH 2/3] KVM: uapi: Remove KVM_DEV_TYPE_ARM_PV_TIME in
 kvm_device_type
To: Marc Zyngier <maz@kernel.org>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-3-zhukeqian1@huawei.com>
 <f97633b4a39c301f916bb76030dcabf0@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <4cd543a2-4d5b-882c-38d6-f5055512f0dc@huawei.com>
Date: Mon, 17 Aug 2020 16:43:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f97633b4a39c301f916bb76030dcabf0@kernel.org>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Steven
 Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/8/17 15:39, Marc Zyngier wrote:
> On 2020-08-17 04:37, Keqian Zhu wrote:
>> ARM64 PV-time ST is configured by userspace through vCPU attribute,
>> and KVM_DEV_TYPE_ARM_PV_TIME is unused.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  include/uapi/linux/kvm.h       | 2 --
>>  tools/include/uapi/linux/kvm.h | 2 --
>>  2 files changed, 4 deletions(-)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4fdf303..9a6b97e 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>>  #define KVM_DEV_TYPE_ARM_VGIC_ITS    KVM_DEV_TYPE_ARM_VGIC_ITS
>>      KVM_DEV_TYPE_XIVE,
>>  #define KVM_DEV_TYPE_XIVE        KVM_DEV_TYPE_XIVE
>> -    KVM_DEV_TYPE_ARM_PV_TIME,
>> -#define KVM_DEV_TYPE_ARM_PV_TIME    KVM_DEV_TYPE_ARM_PV_TIME
>>      KVM_DEV_TYPE_MAX,
>>  };
>>
>> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
>> index 4fdf303..9a6b97e 100644
>> --- a/tools/include/uapi/linux/kvm.h
>> +++ b/tools/include/uapi/linux/kvm.h
>> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>>  #define KVM_DEV_TYPE_ARM_VGIC_ITS    KVM_DEV_TYPE_ARM_VGIC_ITS
>>      KVM_DEV_TYPE_XIVE,
>>  #define KVM_DEV_TYPE_XIVE        KVM_DEV_TYPE_XIVE
>> -    KVM_DEV_TYPE_ARM_PV_TIME,
>> -#define KVM_DEV_TYPE_ARM_PV_TIME    KVM_DEV_TYPE_ARM_PV_TIME
>>      KVM_DEV_TYPE_MAX,
>>  };
> 
> No. You can't drop anything from UAPI, used or not. Doing so will
> break the compilation of any userspace that, for any reason, references
> this value. We cannot reuse this value in the future either, as it would
> create a we wouldn't know which device to create.
> 
> It is pretty unfortunate that PV time has turned into such a train wreck,
> but that's what we have now, and it has to stay.
Well, I see. It is a sad thing indeed.

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
