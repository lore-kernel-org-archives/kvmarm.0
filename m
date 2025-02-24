Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C8725A65E;
	Mon, 24 Feb 2025 18:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420011; cv=none; b=NiB1mnbf9XBZYnXBuwZKsImGi7tb4120O4PXCZYk5nid41E4Qb4PaRK2nTmSNrVsDW4cMQvn6JpHMqDmlbiWIkkCqm3/WaLFyhJB7L1EfQilcLwyIpb5J3Qb0I1NWk6JMgUaKd8tpP2VK2t6N6hKa+AVsxMzgIC26tT8vdjtu0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420011; c=relaxed/simple;
	bh=tA4pjJKyXz0WIXl6n/u+RZCAIV+PamQtXiL3sbzu3TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKzOTgzBGH7ArmQ+fpeRtZ+UuejlKd/LlCASZ26kgvZkb7lK6y92o/LjWydFOCkuj4KpKSJntqwFQEO/AeWAHhu7fkbQDAUmsQWT7zjR5ajB09tn6NBv4sszTiY+fugQ4K/OJkVw/eX3n2Uj6hbwCKfFirTOfQsKGfoNe0RGyXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C54EC4CED6;
	Mon, 24 Feb 2025 18:00:08 +0000 (UTC)
Date: Mon, 24 Feb 2025 18:00:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: Drop mte_allowed check during memslot
 creation
Message-ID: <Z7yzpeIKcYiw6q5a@arm.com>
References: <20250224093938.3934386-1-aneesh.kumar@kernel.org>
 <Z7xSfVME4z2ComUm@arm.com>
 <86ldtvr0nl.wl-maz@kernel.org>
 <Z7yElHKrJGn8XuPS@arm.com>
 <86jz9fqtbk.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jz9fqtbk.wl-maz@kernel.org>

On Mon, Feb 24, 2025 at 03:02:39PM +0000, Marc Zyngier wrote:
> On Mon, 24 Feb 2025 14:39:16 +0000,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > This patch still prevents such MMIO+MTE mappings but moves the decision
> > to user_mem_abort() and it's slightly more relaxed - only rejecting it
> > if !VM_MTE_ALLOWED _and_ the Stage 2 is cacheable. The side-effect is
> > that it allows device assignment into the guest since Stage 2 is not
> > Normal Cacheable (at least for now, we have some patches Ankit but they
> > handle the MTE case).
> 
> The other side effect is that it also allows non-tagged cacheable
> memory to be given to the MTE-enabled guest, and the guest has no way
> to distinguish between what is tagged and what's not.

It can distinguish in the same way as the host does it, e.g. based on
the firmware tables it gets - only assume the standard RAM can be
tagged. Any device in its IPA space does not support tagging and, if
mapped incorrectly, can trigger external aborts etc. But it's the
responsibility of the VMM to set up the memory slots correctly. If those
non-MTE slots are only used for device assignment, we'd not get any
-EFAULT returns.

Having the requirement that all address ranges assigned to a guest
support MTE makes MTE and device assignment exclusive. FEAT_MTE_PERM
doesn't help either, it only allows cacheable MMIO into guests safely
(from an SError/random accesses perspective).

Anyway, I think I get what you mean. For those memory slots potentially
mapped as cacheable at Stage 2 (e.g. a file mmap()), you'd rather block
them upfront than confusing a potentially buggy VMM later with the
-EFAULT (or some other error).

Do we have another way to tell in kvm_arch_prepare_memory_region()
whether the memory is going to be mapped as Device/NC at Stage 2 or
whether later we'll have FEAT_MTE_PERM set for it? We don't have any
physical address at this point. However, we have vma->vm_page_prot but I
was a big fan of this. Ankit's series for Cacheable VFIO is relying on
this IIRC.

For VFIO specifically, we could do something like below. It won't
trigger any -EFAULT exists. I think it's safe for VM_PFNMAP as well
since these would not be mapped as Cacheable at Stage 2 AFAICT but we
could add some additional checks.

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..c48382567f2f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2184,7 +2184,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
+		/*
+		 * VM_ALLOW_ANY_UNCACHED vmas will be mapped as Normal
+		 * NonCacheable at Stage 2 and safe with MTE in guests.
+		 */
+		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma) &&
+		    !(vma->vm_flags & VM_ALLOW_ANY_UNCACHED)) {
 			ret = -EINVAL;
 			break;
 		}

-- 
Catalin
