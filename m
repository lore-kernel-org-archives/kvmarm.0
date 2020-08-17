Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0855BC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 09:49:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8992C206C0
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 09:49:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8992C206C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D09E14BFCB;
	Mon, 17 Aug 2020 05:49:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sG33wVpvwWdn; Mon, 17 Aug 2020 05:49:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98D44BFCE;
	Mon, 17 Aug 2020 05:49:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A5E4BFCC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 05:49:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9S7vCct3vWLp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 05:49:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 611B84BFCB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 05:49:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECBB631B;
 Mon, 17 Aug 2020 02:49:14 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84E493F66B;
 Mon, 17 Aug 2020 02:49:13 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: uapi: Remove KVM_DEV_TYPE_ARM_PV_TIME in
 kvm_device_type
To: zhukeqian <zhukeqian1@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-3-zhukeqian1@huawei.com>
 <f97633b4a39c301f916bb76030dcabf0@kernel.org>
 <4cd543a2-4d5b-882c-38d6-f5055512f0dc@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <72e34f84-5bea-8f69-6699-29e2970c80b4@arm.com>
Date: Mon, 17 Aug 2020 10:49:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4cd543a2-4d5b-882c-38d6-f5055512f0dc@huawei.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
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

On 17/08/2020 09:43, zhukeqian wrote:
> Hi Marc,
> 
> On 2020/8/17 15:39, Marc Zyngier wrote:
>> On 2020-08-17 04:37, Keqian Zhu wrote:
>>> ARM64 PV-time ST is configured by userspace through vCPU attribute,
>>> and KVM_DEV_TYPE_ARM_PV_TIME is unused.
>>>
>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>> ---
>>>   include/uapi/linux/kvm.h       | 2 --
>>>   tools/include/uapi/linux/kvm.h | 2 --
>>>   2 files changed, 4 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 4fdf303..9a6b97e 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>>>   #define KVM_DEV_TYPE_ARM_VGIC_ITS    KVM_DEV_TYPE_ARM_VGIC_ITS
>>>       KVM_DEV_TYPE_XIVE,
>>>   #define KVM_DEV_TYPE_XIVE        KVM_DEV_TYPE_XIVE
>>> -    KVM_DEV_TYPE_ARM_PV_TIME,
>>> -#define KVM_DEV_TYPE_ARM_PV_TIME    KVM_DEV_TYPE_ARM_PV_TIME
>>>       KVM_DEV_TYPE_MAX,
>>>   };
>>>
>>> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
>>> index 4fdf303..9a6b97e 100644
>>> --- a/tools/include/uapi/linux/kvm.h
>>> +++ b/tools/include/uapi/linux/kvm.h
>>> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>>>   #define KVM_DEV_TYPE_ARM_VGIC_ITS    KVM_DEV_TYPE_ARM_VGIC_ITS
>>>       KVM_DEV_TYPE_XIVE,
>>>   #define KVM_DEV_TYPE_XIVE        KVM_DEV_TYPE_XIVE
>>> -    KVM_DEV_TYPE_ARM_PV_TIME,
>>> -#define KVM_DEV_TYPE_ARM_PV_TIME    KVM_DEV_TYPE_ARM_PV_TIME
>>>       KVM_DEV_TYPE_MAX,
>>>   };
>>
>> No. You can't drop anything from UAPI, used or not. Doing so will
>> break the compilation of any userspace that, for any reason, references
>> this value. We cannot reuse this value in the future either, as it would
>> create a we wouldn't know which device to create.
>>
>> It is pretty unfortunate that PV time has turned into such a train wreck,
>> but that's what we have now, and it has to stay.
> Well, I see. It is a sad thing indeed.

Sorry about that, this got refactored so many times I guess I lost track 
of what was actually needed and this hunk remained when it should have 
been removed.

I would hope that I'm the only one who has any userspace code which uses 
this, but I guess we should still be cautious since this has been in 
several releases now.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
