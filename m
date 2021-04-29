Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C397C43460
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 18:28:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15714613ED
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 18:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15714613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C4364B399;
	Thu, 29 Apr 2021 14:28:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WyIACOEV5Gtp; Thu, 29 Apr 2021 14:28:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671B64B389;
	Thu, 29 Apr 2021 14:28:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 993934B33E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 14:28:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IDdhu1mLWGyb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 14:28:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A41284B32A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 14:28:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619720927;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ahhdjeTzVRBlGxvftGs550exL2vN9CqbDTNttH8KlQg=;
 b=VBA3mzvs/a2K6hRg9GNLH5TMUmV1ZqvodPxFAiwttBBNsLZgOXHNnn2bBLV63TRTA71MAo
 Rgpks0gyIzcFk2GpGOFRtj0ddxVdEbUnuKTr9Ock3gXMW1mw4GU/Gej2QM7oAi8oAnH36t
 r2k4sstUQEvNfmwFNd875fZ+JYH+q+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-vDUQF24aPjCkdRuuxwsczA-1; Thu, 29 Apr 2021 14:28:43 -0400
X-MC-Unique: vDUQF24aPjCkdRuuxwsczA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7D1D1922966;
 Thu, 29 Apr 2021 18:28:41 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E40B75D6DC;
 Thu, 29 Apr 2021 18:28:40 +0000 (UTC)
Date: Thu, 29 Apr 2021 12:28:40 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Shanker Donthineni <sdonthineni@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210429122840.4f98f78e@redhat.com>
In-Reply-To: <20210429162906.32742-2-sdonthineni@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Vikram Sethi <vsethi@nvidia.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
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

On Thu, 29 Apr 2021 11:29:05 -0500
Shanker Donthineni <sdonthineni@nvidia.com> wrote:

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
> 
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

If this were a valid thing to do, it should be done for all
architectures, not just ARM64.  However, a prefetchable range only
necessarily allows merged writes, which seems like a subset of the
semantics implied by a WC attribute, therefore this doesn't seem
universally valid.

I'm also a bit confused by your problem statement that indicates that
without WC you're seeing unaligned accesses, does this suggest that
your driver is actually relying on WC semantics to perform merging to
achieve alignment?  That seems rather like a driver bug, I'd expect UC
vs WC is largely a difference in performance, not a means to enforce
proper driver access patterns.  Per the PCI spec, the bridge itself can
merge writes to prefetchable areas, presumably regardless of this
processor attribute, perhaps that's the feature your driver is relying
on that might be missing here.  Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
