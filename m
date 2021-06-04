Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C86C4708F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 14:41:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8547D613FF
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 14:41:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8547D613FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E1834B09F;
	Fri,  4 Jun 2021 10:41:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EbWCqu9tZWX3; Fri,  4 Jun 2021 10:41:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A6224B0B8;
	Fri,  4 Jun 2021 10:41:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A7D24B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 10:41:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K2-xN2GX51IZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 10:41:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 548DA4B09F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 10:41:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A53472B;
 Fri,  4 Jun 2021 07:41:16 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.6.137])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6DFA3F774;
 Fri,  4 Jun 2021 07:41:12 -0700 (PDT)
Date: Fri, 4 Jun 2021 15:41:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 4/4] KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM
Message-ID: <20210604144110.GD69333@C02TD0UTHF1T.local>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-5-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210603183347.1695-5-will@kernel.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 03, 2021 at 07:33:47PM +0100, Will Deacon wrote:
> Introduce a new VM capability, KVM_CAP_ARM_PROTECTED_VM, which can be
> used to isolate guest memory from the host. For now, the EL2 portion is
> missing, so this documents and exposes the user ABI for the host.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  Documentation/virt/kvm/api.rst    |  69 ++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h |  10 +++
>  arch/arm64/include/uapi/asm/kvm.h |   9 +++
>  arch/arm64/kvm/arm.c              |  18 +++---
>  arch/arm64/kvm/mmu.c              |   3 +
>  arch/arm64/kvm/pkvm.c             | 104 ++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |   1 +
>  7 files changed, 205 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7fcb2fd38f42..dfbaf905c435 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6362,6 +6362,75 @@ default.
>  
>  See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
>  
> +7.26 KVM_CAP_ARM_PROTECTED_VM
> +-----------------------------
> +
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: flags is a single KVM_CAP_ARM_PROTECTED_VM_FLAGS_* value
> +
> +The presence of this capability indicates that KVM supports running in a
> +configuration where the host Linux kernel does not have access to guest memory.
> +On such a system, a small hypervisor layer at EL2 can configure the stage-2
> +page tables for both the CPU and any DMA-capable devices to protect guest
> +memory pages so that they are inaccessible to the host unless access is granted
> +explicitly by the guest.
> +
> +The 'flags' parameter is defined as follows:
> +
> +7.26.1 KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE
> +--------------------------------------------
> +
> +:Capability: 'flag' parameter to KVM_CAP_ARM_PROTECTED_VM
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: args[0] contains memory slot ID to hold guest firmware
> +:Returns: 0 on success; negative error code on failure
> +
> +Enabling this capability causes all memory slots of the specified VM to be
> +unmapped from the host system and put into a state where they are no longer
> +configurable. The memory slot corresponding to the ID passed in args[0] is
> +populated with the guest firmware image provided by the host firmware.

As on the prior patch, I don't quite follow the rationale for the guest
fw coming from the host fw, and it seems to go against the usual design
for VM contents, so I fear it could be a problem in future (even if not
in android's specific model for usage).

> +The first vCPU to enter the guest is defined to be the primary vCPU. All other
> +vCPUs belonging to the VM are secondary vCPUs.
> +
> +All vCPUs belonging to a VM with this capability enabled are initialised to a
> +pre-determined reset state

What is that "pre-determined reset state"? e.g. is that just what KVM
does today, or is there something more specific (e.g. that might change
with the "Boot protocol version" below)?

> irrespective of any prior configuration according to
> +the KVM_ARM_VCPU_INIT ioctl, with the following exceptions for the primary
> +vCPU:
> +
> +	===========	===========
> +	Register(s)	Reset value
> +	===========	===========
> +	X0-X14:		Preserved (see KVM_SET_ONE_REG)
> +	X15:		Boot protocol version (0)

What's the "Boot protocol" in this context? Is that just referring to
this handover state, or is that something more involved?

> +	X16-X30:	Reserved (0)
> +	PC:		IPA base of firmware memory slot
> +	SP:		IPA end of firmware memory slot
> +	===========	===========
> +
> +Secondary vCPUs belonging to a VM with this capability enabled will return
> +-EPERM in response to a KVM_RUN ioctl() if the vCPU was not initialised with
> +the KVM_ARM_VCPU_POWER_OFF feature.

I assume this means that protected VMs always get a trusted PSCI
implementation? It might be worth mentioning so (and worth consdiering
if that should always have the SMCCC bits too).

> +
> +There is no support for AArch32 at any exception level.

Is this only going to run on CPUs without AArch32 EL0? ... or does this
mean behaviour will be erratic if someone tries to run AArch32 EL0?

> +
> +It is an error to enable this capability on a VM after issuing a KVM_RUN
> +ioctl() on one of its vCPUs.
> +
> +7.26.2 KVM_CAP_ARM_PROTECTED_VM_FLAGS_INFO
> +------------------------------------------
> +
> +:Capability: 'flag' parameter to KVM_CAP_ARM_PROTECTED_VM
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: args[0] contains pointer to 'struct kvm_protected_vm_info'
> +:Returns: 0 on success; negative error code on failure
> +
> +Populates the 'struct kvm_protected_vm_info' pointed to by args[0] with
> +information about the protected environment for the VM.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..5645af2a1431 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -100,6 +100,11 @@ struct kvm_s2_mmu {
>  struct kvm_arch_memory_slot {
>  };
>  
> +struct kvm_protected_vm {
> +	bool enabled;
> +	struct kvm_memory_slot *firmware_slot;
> +};
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -132,6 +137,8 @@ struct kvm_arch {
>  
>  	u8 pfr0_csv2;
>  	u8 pfr0_csv3;
> +
> +	struct kvm_protected_vm pkvm;
>  };
>  
>  struct kvm_vcpu_fault_info {
> @@ -763,6 +770,9 @@ void kvm_arch_free_vm(struct kvm *kvm);
>  
>  int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
>  
> +int kvm_arm_vm_ioctl_pkvm(struct kvm *kvm, struct kvm_enable_cap *cap);
> +#define kvm_vm_is_protected(kvm) (kvm->arch.pkvm.enabled)
> +
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 24223adae150..cdb3298ba8ae 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -402,6 +402,15 @@ struct kvm_vcpu_events {
>  #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
>  #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
>  
> +/* Protected KVM */
> +#define KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE	0
> +#define KVM_CAP_ARM_PROTECTED_VM_FLAGS_INFO	1
> +
> +struct kvm_protected_vm_info {
> +	__u64 firmware_size;
> +	__u64 __reserved[7];
> +};

Do you have anything in mind for those 7 fields, or was this just a
number that sounded big enough?

I wonder if it's worth adding an size field, and having a size argument
to the ioctl, so that you can discover the full size if we need to grow
this, but you can always get a truncated copy if you just need the early
fields.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
