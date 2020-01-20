Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83A3C33CA1
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 16:20:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4850F21D7E
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 16:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4850F21D7E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0A8E4A500;
	Mon, 20 Jan 2020 11:20:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xhm87Gkns14K; Mon, 20 Jan 2020 11:20:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F31AF4AF2E;
	Mon, 20 Jan 2020 11:20:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F39D84AF25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 11:20:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0UiFLJyed1zG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 11:20:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 053154A500
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 11:20:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EF6831B;
 Mon, 20 Jan 2020 08:20:26 -0800 (PST)
Received: from [10.1.194.52] (e112269-lin.cambridge.arm.com [10.1.194.52])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25ECF3F6C4;
 Mon, 20 Jan 2020 08:20:24 -0800 (PST)
Subject: Re: [PATCH v3 1/8] KVM: arm64: Document PV-lock interface
To: Zengruan Ye <yezengruan@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 virtualization@lists.linux-foundation.org
References: <20200116124626.1155-1-yezengruan@huawei.com>
 <20200116124626.1155-2-yezengruan@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <35fea56c-b501-2163-2c95-62f918738167@arm.com>
Date: Mon, 20 Jan 2020 16:20:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200116124626.1155-2-yezengruan@huawei.com>
Content-Language: en-US
Cc: peterz@infradead.org, catalin.marinas@arm.com, daniel.lezcano@linaro.org,
 linux@armlinux.org.uk, longman@redhat.com, maz@kernel.org, will@kernel.org
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

Hi Zengruan,

Given Marc and Will's thread[1] about a possible alternative way of
handling this I won't do a thorough review as this might not be the best
way of handling the underlying problem, but there's some comments below
for you to consider.

[1] http://lkml.kernel.org/r/b1d23a82d6a7caa79a99597fb83472be%40kernel.org

On 16/01/2020 12:46, Zengruan Ye wrote:
> Introduce a paravirtualization interface for KVM/arm64 to obtain the vCPU
> that is currently running or not.
> 
> The PV lock structure of the guest is allocated by user space.
> 
> A hypercall interface is provided for the guest to interrogate the
> hypervisor's support for this interface and the location of the shared
> memory structures.
> 
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> ---
>  Documentation/virt/kvm/arm/pvlock.rst   | 68 +++++++++++++++++++++++++
>  Documentation/virt/kvm/devices/vcpu.txt | 14 +++++
>  2 files changed, 82 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
> 
> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
> new file mode 100644
> index 000000000000..11776273c0a4
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> @@ -0,0 +1,68 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Paravirtualized lock support for arm64
> +======================================
> +
> +KVM/arm64 provides some hypervisor service calls to support a paravirtualized
> +guest obtaining whether the vCPU is currently running or not.
> +
> +Two new SMCCC compatible hypercalls are defined:

NIT: As defined this is now only a single (multiplexed) hypercall.

> +* ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID:  0x86000001

You appear to have changed the SMC32/SMC64 bit on the ID, so this is now
a 32-bit SMC, but the calling convention below (returning an int64)
seems to rely on the guest being 64-bit. Any reason for this change?
Given the implementation doesn't accept 32-bit clients and the calling
convention requires returning a 64-bit value for 64-bit guests this
seems wrong to me.

> +  - KVM_PV_LOCK_FEATURES   0
> +  - KVM_PV_LOCK_PREEMPTED  1
> +
> +The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
> +ARCH_FEATURES mechanism and the hypervisor should be KVM before calling it.
> +
> +KVM_PV_LOCK_FEATURES
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0x86000001
> +    PV_call_id:   (uint32)    0
> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> +                              PV-lock feature is supported by the hypervisor.
> +    ============= ========    ==========

Because you are now multiplexing the two functions you've lost the
parameter which previously was for "The function to query for support".
Which makes this _FEATURES operation fairly pointless (you might as well
just call KVM_PV_LOCK_PREEMPTED and handle the NOT_SUPPORTED error return).

Steve

> +
> +KVM_PV_LOCK_PREEMPTED
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0x86000001
> +    PV_call_id:   (uint32)    1
> +    Return value: (int64)     IPA of the PV-lock data structure for this vCPU.
> +                              On failure:
> +                              NOT_SUPPORTED (-1)
> +    ============= ========    ==========
> +
> +The IPA returned by KVM_PV_LOCK_PREEMPTED should be mapped by the guest as
> +normal memory with inner and outer write back caching attributes, in the inner
> +shareable domain.
> +
> +KVM_PV_LOCK_PREEMPTED returns the structure for the calling vCPU.
> +
> +PV lock state
> +-------------
> +
> +The structure pointed to by the KVM_PV_LOCK_PREEMPTED hypercall is as follows:
> +
> ++-----------+-------------+-------------+-----------------------------------+
> +| Field     | Byte Length | Byte Offset | Description                       |
> ++===========+=============+=============+===================================+
> +| preempted |      8      |      0      | Indicates that the vCPU that owns |
> +|           |             |             | this struct is running or not.    |
> +|           |             |             | Non-zero values mean the vCPU has |
> +|           |             |             | been preempted. Zero means the    |
> +|           |             |             | vCPU is not preempted.            |
> ++-----------+-------------+-------------+-----------------------------------+
> +
> +The preempted field will be updated to 1 by the hypervisor prior to scheduling
> +a vCPU. When the vCPU is scheduled out, the preempted field will be updated
> +to 0 by the hypervisor.
> +
> +The structure will be present within a reserved region of the normal memory
> +given to the guest. The guest should not attempt to write into this memory.
> +There is a structure per vCPU of the guest.
> +
> +It is advisable that one or more 64k pages are set aside for the purpose of
> +these structures and not used for other purposes, this enables the guest to map
> +the region using 64k pages and avoids conflicting attributes with other memory.
> +
> +For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
> +section "4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL".
> diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
> index 6f3bd64a05b0..2c68d9a0f644 100644
> --- a/Documentation/virt/kvm/devices/vcpu.txt
> +++ b/Documentation/virt/kvm/devices/vcpu.txt
> @@ -74,3 +74,17 @@ Specifies the base address of the stolen time structure for this VCPU. The
>  base address must be 64 byte aligned and exist within a valid guest memory
>  region. See Documentation/virt/kvm/arm/pvtime.txt for more information
>  including the layout of the stolen time structure.
> +
> +4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL
> +Architectures: ARM64
> +
> +4.1 ATTRIBUTE: KVM_ARM_VCPU_PVLOCK_IPA
> +Parameters: 64-bit base address
> +Returns: -ENXIO:  PV lock not implemented
> +         -EEXIST: Base address already set for this vCPU
> +         -EINVAL: Base address not 64 byte aligned
> +
> +Specifies the base address of the PV lock structure for this vCPU. The
> +base address must be 64 byte aligned and exist within a valid guest memory
> +region. See Documentation/virt/kvm/arm/pvlock.rst for more information
> +including the layout of the pv lock structure.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
