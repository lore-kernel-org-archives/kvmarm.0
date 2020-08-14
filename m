Return-Path: <SRS0=xxyy=BY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D49EC433E1
	for <kvmarm@archiver.kernel.org>; Fri, 14 Aug 2020 11:49:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D17052087D
	for <kvmarm@archiver.kernel.org>; Fri, 14 Aug 2020 11:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D17052087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F8364BC28;
	Fri, 14 Aug 2020 07:49:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yP7jjUAh1aUJ; Fri, 14 Aug 2020 07:49:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D42D4BC25;
	Fri, 14 Aug 2020 07:49:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 937504BBEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Aug 2020 07:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M-TPIlzSZOoX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Aug 2020 07:49:34 -0400 (EDT)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F0724BC28
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Aug 2020 07:49:33 -0400 (EDT)
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 449D8406FB90134A6F63;
 Fri, 14 Aug 2020 19:49:31 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 14 Aug 2020 19:49:30 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 14 Aug 2020 19:49:30 +0800
Subject: Re: [RFC 4/4] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
To: Andrew Jones <drjones@redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-5-liangpeng10@huawei.com>
 <20200813091032.blyfvuiti7m2xw5i@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <9bd25141-8cff-ac92-29a5-66c499d26273@huawei.com>
Date: Fri, 14 Aug 2020 19:49:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200813091032.blyfvuiti7m2xw5i@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Cc: Zhanghailiang <zhang.zhanghailiang@huawei.com>, kvm@vger.kernel.org,
 maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 8/13/2020 5:10 PM, Andrew Jones wrote:
> On Thu, Aug 13, 2020 at 02:05:17PM +0800, Peng Liang wrote:
>> Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
>> supports to set CPU features in AArch64.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/kvm/arm.c     | 1 +
>>  include/uapi/linux/kvm.h | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 18ebbe1c64ee..72b9e8fc606f 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -194,6 +194,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>>  	case KVM_CAP_ARM_NISV_TO_USER:
>>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
>> +	case KVM_CAP_ARM_CPU_FEATURE:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 1029444d04aa..0eca4f7c7fef 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_LAST_CPU 184
>>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>>  #define KVM_CAP_S390_DIAG318 186
>> +#define KVM_CAP_ARM_CPU_FEATURE 187
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>> -- 
>> 2.18.4
>>
> 
> All new caps should be documented in Documentation/virt/kvm/api.rst
> 
> Thanks,
> drew 
> 
> .
> 
Sorry, I'll document it.

Thanks,
Peng
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
