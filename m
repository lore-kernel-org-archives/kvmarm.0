Return-Path: <SRS0=4dlz=WB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6A3C0650F
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 13:14:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81FD02173B
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 13:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81FD02173B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0260E4A4FB;
	Mon,  5 Aug 2019 09:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dBLS0Ji1-Eqt; Mon,  5 Aug 2019 09:14:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D15444A51F;
	Mon,  5 Aug 2019 09:14:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4974A4FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 09:14:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VXEOgBD+z6d8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Aug 2019 09:14:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8584A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 09:14:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B021D337;
 Mon,  5 Aug 2019 06:14:11 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA2003F706;
 Mon,  5 Aug 2019 06:14:09 -0700 (PDT)
Subject: Re: [PATCH 3/9] KVM: arm64: Implement PV_FEATURES call
To: Marc Zyngier <maz@kernel.org>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-4-steven.price@arm.com> <20190803122124.7700f700@why>
From: Steven Price <steven.price@arm.com>
Message-ID: <1e0a03b4-1fb6-cbe2-fb7a-8ed39341a187@arm.com>
Date: Mon, 5 Aug 2019 14:14:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803122124.7700f700@why>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 03/08/2019 12:21, Marc Zyngier wrote:
> On Fri,  2 Aug 2019 15:50:11 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
>> This provides a mechanism for querying which paravirtualized features
>> are available in this hypervisor.
>>
>> Also add the header file which defines the ABI for the paravirtualized
>> clock features we're about to add.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/pvclock-abi.h | 20 ++++++++++++++++++++
>>  include/linux/arm-smccc.h            | 14 ++++++++++++++
>>  virt/kvm/arm/hypercalls.c            |  9 +++++++++
>>  3 files changed, 43 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/pvclock-abi.h
>>
>> diff --git a/arch/arm64/include/asm/pvclock-abi.h b/arch/arm64/include/asm/pvclock-abi.h
>> new file mode 100644
>> index 000000000000..1f7cdc102691
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pvclock-abi.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright (C) 2019 Arm Ltd. */
>> +
>> +#ifndef __ASM_PVCLOCK_ABI_H
>> +#define __ASM_PVCLOCK_ABI_H
>> +
>> +/* The below structures and constants are defined in ARM DEN0057A */
>> +
>> +struct pvclock_vcpu_stolen_time_info {
>> +	__le32 revision;
>> +	__le32 attributes;
>> +	__le64 stolen_time;
>> +	/* Structure must be 64 byte aligned, pad to that size */
>> +	u8 padding[48];
>> +} __packed;
>> +
>> +#define PV_VM_TIME_NOT_SUPPORTED	-1
> 
> Isn't the intent for this to be the same value as
> SMCCC_RET_NOT_SUPPORTED?

Yes it is, I guess there's not much point defining it again.

>> +#define PV_VM_TIME_INVALID_PARAMETERS	-2
> 
> It overlaps with SMCCC_RET_NOT_REQUIRED. Is that a problem? Should we
> consider a spec change for this?

Actually INVALID_PARAMETERS is only for Live Physical Time, since we're
not implementing it here, this can go as well.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
