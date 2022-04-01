Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3CEC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 16:24:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8BFD40B91;
	Fri,  1 Apr 2022 12:24:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ziepe.ca
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N7pE5rm3ybCw; Fri,  1 Apr 2022 12:24:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5FB4B1F2;
	Fri,  1 Apr 2022 12:24:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9EE49EE3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:19:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uSaz+m+1TUsj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 10:19:53 -0400 (EDT)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
 [209.85.222.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E144F49EC0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:19:53 -0400 (EDT)
Received: by mail-qk1-f182.google.com with SMTP id q200so2188908qke.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 07:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ziepe.ca; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ACCW8/bZraS0ZT4HrvKJE4Pim6an9ErxJI12ETZ6D8I=;
 b=etQwil6Hu1/NkwZEZI+ruAJC/+UQAuF2gjvBW+a4Ih820ydCI9emF5h5zgBE+pBPJV
 cuMaeIl8o+BQ30fEKqE0/wlfYBp+snjQpdzrj5JN4TG+yiRvP/oPCU3+kp6Cf01O5tJo
 KJcVxHHO3W1AuJK9ejBbe5awuERLWJNVwHF8oktiI38J+1x67GYhGWNV1N5WXpQ3C5Kh
 GR7suSkXiXE8inO+YigNntJAtBSWcDWuAzQkZl0vPVu0Og95P59hGBr8dfBPbAow2QFE
 cWslkhRfXsp/OPJK7IxYXWnENGPOs5PXsiHNQyXdEMHd+IDjV2DdPQ8IqIh9RCHDfOOC
 RCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ACCW8/bZraS0ZT4HrvKJE4Pim6an9ErxJI12ETZ6D8I=;
 b=vgT2Ufe0R4QJUQ/QIfGVelSXjdF6ANTUBHXPtQCiBWlYjn2rOAq84cSpiVSqxuGmga
 xpmc4ZW7+Z1hXwpzaFbtgZ2r57fSyUrJdvVi4zWQObnNAOpZ8HYzk6Q0SmTKj9sTxxLd
 bcWu80I2PaRCjTjh9X9mfPMfC73gErJPc3PmB+F3YsuRhYyaE76F0nbY76jifro05AHN
 UR+CQKil9/pBmconDePyTNQgoynODwTLHLXLcgidBEFAnHQxBjXY+pcEgkTUHYmp1ckm
 VrybFaNjhLwpI+4RUaA2hjLLmc5d3ALajism6WQHSF+3pDJxFi3DqNNcj5KObCrd/kdR
 EySQ==
X-Gm-Message-State: AOAM530QD6+Av43oXkdQgEK0PML8jFG9KdX4Fjfd8xvXC4HnKkYbcRD7
 WbeXfGD0NsV0tl0To6jXO2T4uQ==
X-Google-Smtp-Source: ABdhPJwUx/m0xIPLwWyjukTkeRO9Ht5F0EMHxDa8njMh8pspLckalcH4xcSuiH46I/amIZ6JQPChYA==
X-Received: by 2002:a05:620a:4486:b0:67e:ccd4:990c with SMTP id
 x6-20020a05620a448600b0067eccd4990cmr6785363qkp.643.1648822793423; 
 Fri, 01 Apr 2022 07:19:53 -0700 (PDT)
Received: from ziepe.ca
 (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net.
 [142.162.113.129]) by smtp.gmail.com with ESMTPSA id
 y11-20020ac85f4b000000b002e1e038a8fdsm1843780qta.13.2022.04.01.07.19.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Apr 2022 07:19:52 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94) (envelope-from <jgg@ziepe.ca>)
 id 1naI7z-00ATnc-C8; Fri, 01 Apr 2022 11:19:51 -0300
Date: Fri, 1 Apr 2022 11:19:51 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: xieming <xieming@kylinos.cn>
Subject: Re: [PATCH v2] kvm/arm64: fixed passthrough gpu into vm on arm64
Message-ID: <20220401141951.GP64706@ziepe.ca>
References: <20220401090828.614167-1-xieming@kylinos.cn>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220401090828.614167-1-xieming@kylinos.cn>
X-Mailman-Approved-At: Fri, 01 Apr 2022 12:24:11 -0400
Cc: sashal@kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com,
 will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
 alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Apr 01, 2022 at 05:08:28PM +0800, xieming wrote:
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 51b791c750f1..6f66efb71743 100644
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1452,7 +1452,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
>  	}
>  
>  	vma->vm_private_data = vdev;
> +#ifdef CONFIG_ARM64
> +	if (vfio_pci_is_vga(pdev))
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +	else
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +#else
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +#endif

This is a user visible change if VFIO starts making things write
combining then userspace has to have different barriers around MMIO.

Also this problem is bigger than just GPUs, lots of devices use write
combining memory for their BARs and will do so inside VMs as well - so
testing for 'pci_is_vga' is also not right.

I think you need to solve this by having userspace somehow request the
cachability type for the mmap (though I'm not sure how KVM will know
what to do with that), or by having kvm always force write combining
for all ioremaps..

> +/**
> + * is_vma_write_combine - check if VMA is mapped with writecombine or not
> + * Return true if VMA mapped with MT_NORMAL_NC otherwise fasle
> + */
> +static inline bool is_vma_write_combine(struct vm_area_struct *vma)
> +{
> +	pteval_t pteval = pgprot_val(vma->vm_page_prot);
> +
> +	return ((pteval & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL_NC));
> +}

Shouldn't KVM be copying the exact pgprot bits from the VMA to the
KVM PTEs when it is mirroring them? eg the difference between
pgprot_device and pgprot_noncached() seems relevant to preserve as well.

> @@ -1209,7 +1221,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  	pfn = __phys_to_pfn(pa);
>  
>  	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
> -		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
> +		pte_t pte = pfn_pte(pfn, writecombine ? PAGE_S2_NC : PAGE_S2_DEVICE);

Please don't send patches to the mailing list that are against such
old kernels, this code was deleted in 2020.

Jason
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
