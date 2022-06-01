Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34064C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 13:40:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0ADA4B350;
	Wed,  1 Jun 2022 09:40:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eu84B5FKkYxB; Wed,  1 Jun 2022 09:40:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 624C84B166;
	Wed,  1 Jun 2022 09:40:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05A2E40386
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:40:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lZikCfRir9cX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 09:40:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7BC40712
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:40:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D1CCED1;
 Wed,  1 Jun 2022 06:40:40 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B38273F73D;
 Wed,  1 Jun 2022 06:40:38 -0700 (PDT)
Date: Wed, 1 Jun 2022 14:20:11 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 kvmtool 11/13] arm/arm64: Consolidate RAM
 initialization in kvm__init_ram()
Message-ID: <20220601142011.46e1f80a@donnerap.cambridge.arm.com>
In-Reply-To: <20220525112345.121321-12-alexandru.elisei@arm.com>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
 <20220525112345.121321-12-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: julien@xen.org, maz@kernel.org, Julien Grall <julien.grall@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, 25 May 2022 12:23:43 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> From: Julien Grall <julien.grall@arm.com>
> 
> RAM initialization is unnecessarily split between kvm__init_ram() and
> kvm__arch_init(). Move all code related to RAM initialization to
> kvm__init_ram(), making the code easier to follow and to modify.
> 
> One thing to note is that the initialization order is slightly altered:
> kvm__arch_enable_mte() and gic__create() are now called before mmap'ing the
> guest RAM. That is perfectly fine, as they don't use the host's mapping of
> the guest memory.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

I can confirm that this is just a code move, also MTE and GIC init do not
seem to rely on RAM in any way.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/kvm.c | 52 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/arm/kvm.c b/arm/kvm.c
> index bd44aa350796..abcccfabf59e 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -26,9 +26,34 @@ bool kvm__arch_cpu_supports_vm(void)
>  
>  void kvm__init_ram(struct kvm *kvm)
>  {
> -	int err;
>  	u64 phys_start, phys_size;
>  	void *host_mem;
> +	int err;
> +
> +	/*
> +	 * Allocate guest memory. We must align our buffer to 64K to
> +	 * correlate with the maximum guest page size for virtio-mmio.
> +	 * If using THP, then our minimal alignment becomes 2M.
> +	 * 2M trumps 64K, so let's go with that.
> +	 */
> +	kvm->ram_size = kvm->cfg.ram_size;
> +	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
> +	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
> +						kvm->cfg.hugetlbfs_path,
> +						kvm->arch.ram_alloc_size);
> +
> +	if (kvm->arch.ram_alloc_start == MAP_FAILED)
> +		die("Failed to map %lld bytes for guest memory (%d)",
> +		    kvm->arch.ram_alloc_size, errno);
> +
> +	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
> +					SZ_2M);
> +
> +	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> +		MADV_MERGEABLE);
> +
> +	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> +		MADV_HUGEPAGE);
>  
>  	phys_start	= ARM_MEMORY_AREA;
>  	phys_size	= kvm->ram_size;
> @@ -59,31 +84,6 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
>  
>  void kvm__arch_init(struct kvm *kvm)
>  {
> -	/*
> -	 * Allocate guest memory. We must align our buffer to 64K to
> -	 * correlate with the maximum guest page size for virtio-mmio.
> -	 * If using THP, then our minimal alignment becomes 2M.
> -	 * 2M trumps 64K, so let's go with that.
> -	 */
> -	kvm->ram_size = kvm->cfg.ram_size;
> -	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
> -	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
> -						kvm->cfg.hugetlbfs_path,
> -						kvm->arch.ram_alloc_size);
> -
> -	if (kvm->arch.ram_alloc_start == MAP_FAILED)
> -		die("Failed to map %lld bytes for guest memory (%d)",
> -		    kvm->arch.ram_alloc_size, errno);
> -
> -	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
> -					SZ_2M);
> -
> -	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> -		MADV_MERGEABLE);
> -
> -	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> -		MADV_HUGEPAGE);
> -
>  	/* Create the virtual GIC. */
>  	if (gic__create(kvm, kvm->cfg.arch.irqchip))
>  		die("Failed to create virtual GIC");

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
