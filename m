Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CC8C433ED
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 09:54:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA6EC61482
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 09:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA6EC61482
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CE394B3EE;
	Fri, 30 Apr 2021 05:54:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ErQHcd91T7Qq; Fri, 30 Apr 2021 05:54:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 462734B412;
	Fri, 30 Apr 2021 05:54:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5B7D4B3EE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 05:54:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TDNH07ndPxcJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 05:54:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CD704B3B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 05:54:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C087031B;
 Fri, 30 Apr 2021 02:54:24 -0700 (PDT)
Received: from lpieralisi (e121166-lin.cambridge.arm.com [10.1.196.255])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01C143F73B;
 Fri, 30 Apr 2021 02:54:22 -0700 (PDT)
Date: Fri, 30 Apr 2021 10:54:17 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Shanker Donthineni <sdonthineni@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210430095417.GA13686@lpieralisi>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210429162906.32742-2-sdonthineni@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: benh@kernel.crashing.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Vikram Sethi <vsethi@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>,
 jgg@nvidia.com, Catalin Marinas <catalin.marinas@arm.com>,
 Jason Sequeira <jsequeira@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

[+Jason, Ben]

On Thu, Apr 29, 2021 at 11:29:05AM -0500, Shanker Donthineni wrote:
> For pass-through device assignment, the ARM64 KVM hypervisor retrieves
> the memory region properties physical address, size, and whether a
> region backed with struct page or not from VMA. The prefetchable
> attribute of a BAR region isn't visible to KVM to make an optimal
> decision for stage2 attributes.
> 
> This patch updates vma->vm_page_prot and maps with write-combine
> attribute if the associated BAR is prefetchable. For ARM64
> pgprot_writecombine() is mapped to memory-type MT_NORMAL_NC which
> has no side effects on reads and multiple writes can be combined.
> 
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

A bit of background information that may be useful:

https://lore.kernel.org/linux-pci/2b539df4c9ec703458e46da2fc879ee3b310b31c.camel@kernel.crashing.org

Lorenzo

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5023e23db3bc..1b734fe1dd51 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1703,7 +1703,11 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
>  	}
>  
>  	vma->vm_private_data = vdev;
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	if (IS_ENABLED(CONFIG_ARM64) &&
> +	    (pci_resource_flags(pdev, index) & IORESOURCE_PREFETCH))
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +	else
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
>  
>  	/*
> -- 
> 2.17.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
