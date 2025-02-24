Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786C42586D1;
	Mon, 24 Feb 2025 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740395138; cv=none; b=rEF19az24OjawYTVHDK6yQbiBe8/UREGk3467blb7L3lCzjjEJrD9iR/gy0IJys6AczvmMq735CSSjdVnM4yjksh0eFjLO+8yXL4zopN5aKlWxV9gnFK6QHhBwYaeDGJ7wV5ptox2bQV7+b8BExravTffEkNeVNhpo7u3QynlmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740395138; c=relaxed/simple;
	bh=Psyn/KQl59WzsnG7eUbev1bYnOJ/uewhEhWQ4K6vZMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKoiAgPyBmk05queSN4piBY7wvS3wzuaeUYUU3kjc+xo73ZJC3fQYP6TAA7xQvDnoUUp4gTKTyqMOSXxMePK7OGloA/wTZXTnvMRkDIqmL8aaXEMLyvMUKVKztk7c4Eh7jP7ATZg1tOj0zXzpIV8mOYMA+sVQsoa2WNr7V6+sbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551EBC4CEE6;
	Mon, 24 Feb 2025 11:05:36 +0000 (UTC)
Date: Mon, 24 Feb 2025 11:05:33 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: Drop mte_allowed check during memslot
 creation
Message-ID: <Z7xSfVME4z2ComUm@arm.com>
References: <20250224093938.3934386-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224093938.3934386-1-aneesh.kumar@kernel.org>

On Mon, Feb 24, 2025 at 03:09:38PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Before commit d89585fbb308 ("KVM: arm64: unify the tests for VMAs in
> memslots when MTE is enabled"), kvm_arch_prepare_memory_region() only
> rejected a memory slot if VM_SHARED was set. This commit unified the
> checking with user_mem_abort(), with slots being rejected if either
> VM_MTE_ALLOWED is not set or VM_SHARED set. A subsequent commit
> c911f0d46879 ("KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE
> enabled") dropped the VM_SHARED check, so we ended up with memory slots
> being rejected if VM_MTE_ALLOWED is not set. This wasn't the case before
> the commit d89585fbb308. The rejection of the memory slot with VM_SHARED
> set was done to avoid a race condition with the test/set of the
> PG_mte_tagged flag. Before Commit d77e59a8fccd ("arm64: mte: Lock a page
> for MTE tag initialization") the kernel avoided allowing MTE with shared
> pages, thereby preventing two tasks sharing a page from setting up the
> PG_mte_tagged flag racily.
> 
> Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
> initialization") further updated the locking so that the kernel
> allows VM_SHARED mapping with MTE. With this commit, we can enable
> memslot creation with VM_SHARED VMA mapping.
> 
> This patch results in a minor tweak to the ABI. We now allow creating
> memslots that don't have the VM_MTE_ALLOWED flag set.

As I commented here:

https://lore.kernel.org/r/Z4e04P1bQlFBDHo7@arm.com

I'm fine with the change, we basically go back to the original ABI prior
to relaxing this for VM_SHARED.

> If the guest uses
> such a memslot with Allocation Tags, the kernel will generate -EFAULT.
> ie, instead of failing early, we now fail later during KVM_RUN.

Nit: more like the kernel "will return -EFAULT" to the VMM rather than
"generate".

> This change is needed because, without it, users are not able to use MTE
> with VFIO passthrough (currently the mapping is either Device or
> NonCacheable for which tag access check is not applied.), as shown
> below (kvmtool VMM).

Another nit: "users are not able to user VFIO passthrough when MTE is
enabled". At a first read, the above sounded to me like one wants to
enable MTE for VFIO passthrough mappings.

> [  617.921030] vfio-pci 0000:01:00.0: resetting
> [  618.024719] vfio-pci 0000:01:00.0: reset done
>   Error: 0000:01:00.0: failed to register region with KVM
>   Warning: [0abc:aced] Error activating emulation for BAR 0
>   Error: 0000:01:00.0: failed to configure regions
>   Warning: Failed init: vfio__init
> 
>   Fatal: Initialisation failed
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ef53af6df6de..1f1b5aa43d2d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2178,11 +2178,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		if (!vma)
>  			break;
>  
> -		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> -			ret = -EINVAL;
> -			break;
> -		}
> -
>  		if (vma->vm_flags & VM_PFNMAP) {
>  			/* IO region dirty page logging not allowed */
>  			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
