Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6919942049
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738161517; cv=none; b=f2Naxyb43bUEqVoZTEixlVQbmgX07fDL69QFIDSaOKfk0Vt8SDtB8rM/Lut9mGKh0tfyX/VjKuT17n3G2DSzeCZWuUjR/D0lVWTxcnUvXgLj7QOuTWEMZFVL4An8OUSPChU/suK0VsrEUqX/NMiRWNCF06mBjAv4xX6LI9ebkIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738161517; c=relaxed/simple;
	bh=rgcxe3XeW8ddbkhI84c1LD7JgtLAHn9DCzwhqidf6bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BiM5ejD9UHVjdcW0d3l3Cib0fjdtrnJX5Y9pwVB6C1nNQoYi/EgIQ8BP5qlTpBXeEPEj/2ZmmRIDmFTxYmkSKI4H5CvjwEUb+P27kPDI165hrUXfHeD1l9CvcnLK/9JrhM5A0KLWW1nkhW9C5XtyxU1qgPKMlzImPYtY9bXpDeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6F2C497;
	Wed, 29 Jan 2025 06:38:59 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C94503F694;
	Wed, 29 Jan 2025 06:38:31 -0800 (PST)
Date: Wed, 29 Jan 2025 14:38:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
Message-ID: <Z5o9ZVLHYZRvVPIe@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org>
 <Z4Fk58k8YptDkVgm@arm.com>
 <yq5amsfxtrlw.fsf@kernel.org>
 <Z4Vk5gTnd8o7VKWL@arm.com>
 <CAMn1gO4huP4D_1mFdC8FsmvHkaQn+hC02ULcfBuS30VDM9=9gA@mail.gmail.com>
 <Z4e04P1bQlFBDHo7@arm.com>
 <yq5afrl3cjrd.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5afrl3cjrd.fsf@kernel.org>

On Tue, Jan 28, 2025 at 04:01:18PM +0530, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > So if you don't remember any strong reason for this change, I think we
> > should go back to the original behaviour of deferring the VM_MTE_ALLOWED
> > check to user_mem_abort() (and still permitting VM_SHARED).
> 
> Something as below?
> 
> From 466237a6f0a165152c157ab4a73f34c400cffe34 Mon Sep 17 00:00:00 2001
> From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
> Date: Tue, 28 Jan 2025 14:21:52 +0530
> Subject: [PATCH] KVM: arm64: Drop mte_allowed check during memslot creation
> 
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
> memslots that don't have the VM_MTE_ALLOWED flag set. If the guest uses
> such a memslot with Allocation Tags, the kernel will generate -EFAULT.
> ie, instead of failing early, we now fail later during KVM_RUN.
> 
> This change is needed because, without it, users are not able to use MTE
> with VFIO passthrough, as shown below (kvmtool VMM).

You might want to clearly state it that the VFIO passthrough is Device
or NonCacheable (for the time being, parallel series from Ankit on
allowing cacheable).

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
> index 007dda958eab..610becd8574e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2146,11 +2146,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		if (!vma)
>  			break;
>  
> -		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> -			ret = -EINVAL;
> -			break;
> -		}

Works for me. It's up to the KVM maintainers whether they are ok with
this ABI change.

-- 
Catalin
