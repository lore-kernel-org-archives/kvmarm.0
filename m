Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6352AC432C2
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 08:13:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E37772082F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 08:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E37772082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BD274A6B4;
	Wed, 25 Sep 2019 04:13:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tyl3hgYl7bRq; Wed, 25 Sep 2019 04:13:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9EC4A6B5;
	Wed, 25 Sep 2019 04:13:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA9544A6B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 04:13:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zrQBraZGkejF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 04:13:00 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 616874A697
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 04:12:59 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id EF74175CD047DB4EC037;
 Wed, 25 Sep 2019 16:12:44 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 25 Sep 2019
 16:12:35 +0800
Subject: Re: [RFC PATCH 01/12] linux-headers: import arm_sdei.h
To: "Michael S. Tsirkin" <mst@redhat.com>
References: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
 <1569338511-3572-2-git-send-email-guoheyi@huawei.com>
 <20190924113640-mutt-send-email-mst@kernel.org>
From: Guoheyi <guoheyi@huawei.com>
Message-ID: <f0096ac1-e7d4-78d2-9e8a-21a7f6f266ad@huawei.com>
Date: Wed, 25 Sep 2019 16:12:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20190924113640-mutt-send-email-mst@kernel.org>
X-Originating-IP: [10.133.216.73]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <marc.zyngier@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 qemu-devel@nongnu.org, Dave Martin <Dave.Martin@arm.com>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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



On 2019/9/24 23:39, Michael S. Tsirkin wrote:
> On Tue, Sep 24, 2019 at 11:21:40PM +0800, Heyi Guo wrote:
>> Import Linux header file include/uapi/linux/arm_sdei.h from kernel
>> v5.3 release.
>>
>> This is to prepare for qemu SDEI emulation.
>>
>> Signed-off-by: Heyi Guo <guoheyi@huawei.com>
>> Cc: Peter Maydell <peter.maydell@linaro.org>
>> Cc: Dave Martin <Dave.Martin@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Some issues with this.  First linux-headers is for linux as a host.
> This is for linux as a guest, so belongs in include/standard-headers.
>
> Second, please add to scripts/update-linux-headers.sh in a 1st patch,
> then add the file in the second patch.

Thanks; now I understand the differences. I'll do that in next version.

HG

>
>
>
>> ---
>>   linux-headers/linux/arm_sdei.h | 73 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 73 insertions(+)
>>   create mode 100644 linux-headers/linux/arm_sdei.h
>>
>> diff --git a/linux-headers/linux/arm_sdei.h b/linux-headers/linux/arm_sdei.h
>> new file mode 100644
>> index 0000000..af0630b
>> --- /dev/null
>> +++ b/linux-headers/linux/arm_sdei.h
>> @@ -0,0 +1,73 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/* Copyright (C) 2017 Arm Ltd. */
>> +#ifndef _UAPI_LINUX_ARM_SDEI_H
>> +#define _UAPI_LINUX_ARM_SDEI_H
>> +
>> +#define SDEI_1_0_FN_BASE			0xC4000020
>> +#define SDEI_1_0_MASK				0xFFFFFFE0
>> +#define SDEI_1_0_FN(n)				(SDEI_1_0_FN_BASE + (n))
>> +
>> +#define SDEI_1_0_FN_SDEI_VERSION			SDEI_1_0_FN(0x00)
>> +#define SDEI_1_0_FN_SDEI_EVENT_REGISTER			SDEI_1_0_FN(0x01)
>> +#define SDEI_1_0_FN_SDEI_EVENT_ENABLE			SDEI_1_0_FN(0x02)
>> +#define SDEI_1_0_FN_SDEI_EVENT_DISABLE			SDEI_1_0_FN(0x03)
>> +#define SDEI_1_0_FN_SDEI_EVENT_CONTEXT			SDEI_1_0_FN(0x04)
>> +#define SDEI_1_0_FN_SDEI_EVENT_COMPLETE			SDEI_1_0_FN(0x05)
>> +#define SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME	SDEI_1_0_FN(0x06)
>> +#define SDEI_1_0_FN_SDEI_EVENT_UNREGISTER		SDEI_1_0_FN(0x07)
>> +#define SDEI_1_0_FN_SDEI_EVENT_STATUS			SDEI_1_0_FN(0x08)
>> +#define SDEI_1_0_FN_SDEI_EVENT_GET_INFO			SDEI_1_0_FN(0x09)
>> +#define SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET		SDEI_1_0_FN(0x0A)
>> +#define SDEI_1_0_FN_SDEI_PE_MASK			SDEI_1_0_FN(0x0B)
>> +#define SDEI_1_0_FN_SDEI_PE_UNMASK			SDEI_1_0_FN(0x0C)
>> +#define SDEI_1_0_FN_SDEI_INTERRUPT_BIND			SDEI_1_0_FN(0x0D)
>> +#define SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE		SDEI_1_0_FN(0x0E)
>> +#define SDEI_1_0_FN_SDEI_PRIVATE_RESET			SDEI_1_0_FN(0x11)
>> +#define SDEI_1_0_FN_SDEI_SHARED_RESET			SDEI_1_0_FN(0x12)
>> +
>> +#define SDEI_VERSION_MAJOR_SHIFT			48
>> +#define SDEI_VERSION_MAJOR_MASK				0x7fff
>> +#define SDEI_VERSION_MINOR_SHIFT			32
>> +#define SDEI_VERSION_MINOR_MASK				0xffff
>> +#define SDEI_VERSION_VENDOR_SHIFT			0
>> +#define SDEI_VERSION_VENDOR_MASK			0xffffffff
>> +
>> +#define SDEI_VERSION_MAJOR(x)	(x>>SDEI_VERSION_MAJOR_SHIFT & SDEI_VERSION_MAJOR_MASK)
>> +#define SDEI_VERSION_MINOR(x)	(x>>SDEI_VERSION_MINOR_SHIFT & SDEI_VERSION_MINOR_MASK)
>> +#define SDEI_VERSION_VENDOR(x)	(x>>SDEI_VERSION_VENDOR_SHIFT & SDEI_VERSION_VENDOR_MASK)
>> +
>> +/* SDEI return values */
>> +#define SDEI_SUCCESS		0
>> +#define SDEI_NOT_SUPPORTED	-1
>> +#define SDEI_INVALID_PARAMETERS	-2
>> +#define SDEI_DENIED		-3
>> +#define SDEI_PENDING		-5
>> +#define SDEI_OUT_OF_RESOURCE	-10
>> +
>> +/* EVENT_REGISTER flags */
>> +#define SDEI_EVENT_REGISTER_RM_ANY	0
>> +#define SDEI_EVENT_REGISTER_RM_PE	1
>> +
>> +/* EVENT_STATUS return value bits */
>> +#define SDEI_EVENT_STATUS_RUNNING	2
>> +#define SDEI_EVENT_STATUS_ENABLED	1
>> +#define SDEI_EVENT_STATUS_REGISTERED	0
>> +
>> +/* EVENT_COMPLETE status values */
>> +#define SDEI_EV_HANDLED	0
>> +#define SDEI_EV_FAILED	1
>> +
>> +/* GET_INFO values */
>> +#define SDEI_EVENT_INFO_EV_TYPE			0
>> +#define SDEI_EVENT_INFO_EV_SIGNALED		1
>> +#define SDEI_EVENT_INFO_EV_PRIORITY		2
>> +#define SDEI_EVENT_INFO_EV_ROUTING_MODE		3
>> +#define SDEI_EVENT_INFO_EV_ROUTING_AFF		4
>> +
>> +/* and their results */
>> +#define SDEI_EVENT_TYPE_PRIVATE			0
>> +#define SDEI_EVENT_TYPE_SHARED			1
>> +#define SDEI_EVENT_PRIORITY_NORMAL		0
>> +#define SDEI_EVENT_PRIORITY_CRITICAL		1
>> +
>> +#endif /* _UAPI_LINUX_ARM_SDEI_H */
>> -- 
>> 1.8.3.1
> .
>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
