Return-Path: <SRS0=UWlR=26=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9B9C282DD
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 14:53:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD9532067D
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 14:53:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD9532067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E5A44B1D5;
	Thu,  9 Jan 2020 09:53:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YbeIQUG4zoN7; Thu,  9 Jan 2020 09:53:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B246B4B261;
	Thu,  9 Jan 2020 09:53:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 315504B1C8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 09:53:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fp0yNZCYZYfQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jan 2020 09:53:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 990454A524
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 09:53:11 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2267C1FB;
 Thu,  9 Jan 2020 06:53:11 -0800 (PST)
Received: from [10.1.27.38] (e122027.cambridge.arm.com [10.1.27.38])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 120D93F534;
 Thu,  9 Jan 2020 06:53:08 -0800 (PST)
Subject: Re: [PATCH v2 1/6] KVM: arm64: Document PV-lock interface
To: Zengruan Ye <yezengruan@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 virtualization@lists.linux-foundation.org
References: <20191226135833.1052-1-yezengruan@huawei.com>
 <20191226135833.1052-2-yezengruan@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <c26ebc8d-6a10-6bc4-0af8-cd4883addbf0@arm.com>
Date: Thu, 9 Jan 2020 14:53:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191226135833.1052-2-yezengruan@huawei.com>
Content-Language: en-GB
Cc: catalin.marinas@arm.com, daniel.lezcano@linaro.org, linux@armlinux.org.uk,
 maz@kernel.org, will@kernel.org
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

On 26/12/2019 13:58, Zengruan Ye wrote:
> Introduce a paravirtualization interface for KVM/arm64 to obtain the VCPU
> is currently running or not.
> 
> The PV lock structure of the guest is allocated by user space.
> 
> A hypercall interface is provided for the guest to interrogate the
> hypervisor's support for this interface and the location of the shared
> memory structures.
> 
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> ---
>   Documentation/virt/kvm/arm/pvlock.rst   | 63 +++++++++++++++++++++++++
>   Documentation/virt/kvm/devices/vcpu.txt | 14 ++++++
>   2 files changed, 77 insertions(+)
>   create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
> 
> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
> new file mode 100644
> index 000000000000..58b3b8ee7537
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> @@ -0,0 +1,63 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Paravirtualized lock support for arm64
> +======================================
> +
> +KVM/arm64 provides some hypervisor service calls to support a paravirtualized
> +guest obtaining the VCPU is currently running or not.
NIT:              ^ whether

> +
> +Two new SMCCC compatible hypercalls are defined:
> +
> +* PV_LOCK_FEATURES:   0xC6000020
> +* PV_LOCK_PREEMPTED:  0xC6000021
> +
> +The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
> +ARCH_FEATURES mechanism before calling it.

Since these are within the "vendor specific" SMCCC region ideally you should also check that you are talking to KVM. (Other hypervisors could allocate SMCCC IDs differently within this block). Will has a patch on a branch which gives an example of how this could work [1]

[1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/commit/?h=kvm/hvc&id=464f5a1741e5959c3e4d2be1966ae0093b4dce06

> +
> +PV_LOCK_FEATURES
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0xC6000020
> +    PV_call_id:   (uint32)    The function to query for support.
> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> +                              PV-lock feature is supported by the hypervisor.
> +    ============= ========    ==========
> +
> +PV_LOCK_PREEMPTED
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0xC6000021
> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the IPA of
> +                              this VCPU's pv data structure is configured by
> +                              the hypervisor.
> +    ============= ========    ==========

PV_LOCK_PREEMPTED also needs to return the address of this data structure. Either by returning this in another register, or by e.g. treating a positive return as an address and a negative value as an error.

> +
> +The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
> +memory with inner and outer write back caching attributes, in the inner
> +shareable domain.
> +
> +PV_LOCK_PREEMPTED returns the structure for the calling VCPU.
> +
> +PV lock state
> +-------------
> +
> +The structure pointed to by the PV_LOCK_PREEMPTED hypercall is as follows:
> +
> ++-----------+-------------+-------------+---------------------------------+
> +| Field     | Byte Length | Byte Offset | Description                     |
> ++===========+=============+=============+=================================+
> +| preempted |      8      |      0      | Indicate the VCPU who owns this |

NIT: s/Indicate/Indicates that/. Also more common English would be "the VCPU *that* owns"

> +|           |             |             | struct is running or not.       |
> +|           |             |             | Non-zero values mean the VCPU   |
> +|           |             |             | has been preempted. Zero means  |
> +|           |             |             | the VCPU is not preempted.      |
> ++-----------+-------------+-------------+---------------------------------+
> +
> +The preempted field will be updated to 1 by the hypervisor prior to scheduling
> +a VCPU. When the VCPU is scheduled out, the preempted field will be updated
> +to 0 by the hypervisor.
> +
> +The structure will be present within a reserved region of the normal memory
> +given to the guest. The guest should not attempt to write into this memory.
> +There is a structure per VCPU of the guest.

I think it would be worth mentioning in this document that the structure is guaranteed to be 64-byte aligned.

Steve

> +
> +For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
> +section "4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL".
> diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
> index 6f3bd64a05b0..c10a5945075b 100644
> --- a/Documentation/virt/kvm/devices/vcpu.txt
> +++ b/Documentation/virt/kvm/devices/vcpu.txt
> @@ -74,3 +74,17 @@ Specifies the base address of the stolen time structure for this VCPU. The
>   base address must be 64 byte aligned and exist within a valid guest memory
>   region. See Documentation/virt/kvm/arm/pvtime.txt for more information
>   including the layout of the stolen time structure.
> +
> +4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL
> +Architectures: ARM64
> +
> +4.1 ATTRIBUTE: KVM_ARM_VCPU_PVLOCK_IPA
> +Parameters: 64-bit base address
> +Returns: -ENXIO:  PV lock not implemented
> +         -EEXIST: Base address already set for this VCPU
> +         -EINVAL: Base address not 64 byte aligned
> +
> +Specifies the base address of the PV lock structure for this VCPU. The
> +base address must be 64 byte aligned and exist within a valid guest memory
> +region. See Documentation/virt/kvm/arm/pvlock.rst for more information
> +including the layout of the pv lock structure.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
