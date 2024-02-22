Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222376E602
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 20:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708635169; cv=none; b=HgxDNKka2SW7tuJLYwW5IfNzIbRfA4qvl7/HPYek/bRFSHwJ9cgbDcO47Mz4zM8Tx3pyXyMRS2iJdtTphiYUmtnzra3rH+nIu7WAMNOYYfL8gWEQyCi9rzdGceDZIvwLKsXIWnFOoK+9y4dYNpc3NWHMAaog5tH+kPht78u10xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708635169; c=relaxed/simple;
	bh=GhL7YM18DcEtfbq8lBqUnF8deaVqdKA2j+PviWMXDM0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i8EnpJcgA9OmZmGT9qqCjDYlJ5jnUKAeo4ijH/ctXT67620eZIKrY7jTbDuA26Z8dZoOVdSvip0cbxA1/lLbJoJnZK309hC6TtAhRonZT8b9dCkr+yiPHoJu56u8/wLesRK3Gkr4Jdn1XsvacrrR1QgbhJ2RKp6a0gqCvglMxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GhR6zujK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GhR6zujK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708635167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UcO6Jui6DKtatymkIK1WWSMn6J5ECJZL7QtFar2I6wY=;
	b=GhR6zujKSRfwQD9RsEWEf8/CqjuvTQHl8xpHUuXKUuJMVGP5aStkdH6FSsx2g56/LP+cr8
	hlYNqtpiPFjjbxhdMFbDDy4UJZWcrGsSRNRUPpzbhgK+nyz2PVYXAECCYknX5LIs5oLFcI
	D2QYVUm+NyoVI4z0l1sI1zDMTOYB4uA=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-NdmR1ftfP0y7Pir1-sSV-w-1; Thu, 22 Feb 2024 15:52:46 -0500
X-MC-Unique: NdmR1ftfP0y7Pir1-sSV-w-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3c032b61db5so173424b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 12:52:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708635165; x=1709239965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UcO6Jui6DKtatymkIK1WWSMn6J5ECJZL7QtFar2I6wY=;
        b=her3fy7otbGRoQhm11MD/4OJkYKMEFRr2UAhikDQiRYd7OCego7hufw/XzHpkz8oZp
         TOtmdVIQe3pBb4SaXKE6iiTLYDg777GhsFRHRO1pr4Pvwkg5lvdnQaN/INxQw3DTT/cq
         paFoSOsUDHIuEo2K39HupaXSymLKDyWItTJe5cTdBc9TylKWAdEfvXlnGyFUXsGe4WjU
         PNO4hn0QVJUGFjElY9lEzHJZr3Z8oZJ6ZfFOfyGLUBNWpWioQWwUWAIBkWaMTJcjcMOl
         UoKeHXKayZfSBz+2KXSXSfOMaFL9jsN772D/x2svYGBS/qlcECPzRMRTUx0RmW84JJTE
         C9Zw==
X-Forwarded-Encrypted: i=1; AJvYcCUddKymr1e3hsFkFZrGaQ7UpMqEMRkhszSJnyvcHYlLG/WKgy4CslqFI9XCvix2gKvGVcGh7JbT0Qno6YRnGU17POc/iqAa
X-Gm-Message-State: AOJu0Yxo+BvgVsEH+nx8Udb2iNph1/jUIjHOdImXgfZjtKq6Ccu5/l9k
	NPjqv4fuo10ZJqu6+YwJarQrZpwbOSENhYy1q0/8g9Vbr6XZ8opcKx3T/3BKBfz/3CVrYtJHIK1
	hildwe5fHp/S+N5HLPzWl/BoT1yMDbJqGOLGnZ8YRMcBPBz31NeqaZA==
X-Received: by 2002:a05:6808:316:b0:3be:b5f6:f355 with SMTP id i22-20020a056808031600b003beb5f6f355mr66188oie.15.1708635165263;
        Thu, 22 Feb 2024 12:52:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHphM2AEgwOFKuEkCG9cWu5dpOQyfI2E3tisVZLDiLPsoH3PowBIUeuTZNvzTCWg2+WwuAc+Q==
X-Received: by 2002:a05:6808:316:b0:3be:b5f6:f355 with SMTP id i22-20020a056808031600b003beb5f6f355mr66138oie.15.1708635164973;
        Thu, 22 Feb 2024 12:52:44 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id a14-20020a05680802ce00b003c15d61ec3fsm1461018oid.37.2024.02.22.12.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 12:52:44 -0800 (PST)
Date: Thu, 22 Feb 2024 13:52:40 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
 <james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
 <reinette.chatre@intel.com>, <surenb@google.com>, <stefanha@redhat.com>,
 <brauner@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <mark.rutland@arm.com>, <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
 <ardb@kernel.org>, <akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
 <wangjinchao@xfusion.com>, <gshan@redhat.com>, <shahuang@redhat.com>,
 <ricarkol@google.com>, <linux-mm@kvack.org>, <lpieralisi@kernel.org>,
 <rananta@google.com>, <ryan.roberts@arm.com>, <david@redhat.com>,
 <linus.walleij@linaro.org>, <bhe@redhat.com>, <aniketa@nvidia.com>,
 <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
 <vsethi@nvidia.com>, <acurrid@nvidia.com>, <apopple@nvidia.com>,
 <jhubbard@nvidia.com>, <danw@nvidia.com>, <kvmarm@lists.linux.dev>,
 <mochs@nvidia.com>, <zhiw@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Message-ID: <20240222135240.46682bed.alex.williamson@redhat.com>
In-Reply-To: <20240220072926.6466-5-ankita@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
	<20240220072926.6466-5-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 Feb 2024 12:59:26 +0530
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64,
> allowing KVM stage 2 device mapping attributes to use Normal-NC
> rather than DEVICE_nGnRE, which allows guest mappings
> supporting combining attributes (WC). ARM does not architecturally
> guarantee this is safe, and indeed some MMIO regions like the GICv2
> VCPU interface can trigger uncontained faults if Normal-NC is used.
> 
> To safely use VFIO in KVM the platform must guarantee full safety
> in the guest where no action taken against a MMIO mapping can
> trigger an uncontained failure. We belive that most VFIO PCI
> platforms support this for both mapping types, at least in common
> flows, based on some expectations of how PCI IP is integrated. So
> make vfio-pci set the VM_ALLOW_ANY_UNCACHED flag.
> 
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..c93bea18fc4b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1862,8 +1862,24 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	/*
>  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>  	 * change vm_flags within the fault handler.  Set them now.
> +	 *
> +	 * VM_ALLOW_ANY_UNCACHED: The VMA flag is implemented for ARM64,
> +	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
> +	 * rather than DEVICE_nGnRE, which allows guest mappings
> +	 * supporting combining attributes (WC). ARM does not
> +	 * architecturally guarantee this is safe, and indeed some MMIO
> +	 * regions like the GICv2 VCPU interface can trigger uncontained
> +	 * faults if Normal-NC is used.
> +	 *
> +	 * To safely use VFIO in KVM the platform must guarantee full
> +	 * safety in the guest where no action taken against a MMIO
> +	 * mapping can trigger an uncontained failure. We belive that
> +	 * most VFIO PCI platforms support this for both mapping types,
> +	 * at least in common flows, based on some expectations of how
> +	 * PCI IP is integrated. So set VM_ALLOW_ANY_UNCACHED in VMA flags.
>  	 */
> -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
> +			VM_DONTEXPAND | VM_DONTDUMP);
>  	vma->vm_ops = &vfio_pci_mmap_ops;
>  
>  	return 0;

Acked-by: Alex Williamson <alex.williamson@redhat.com>

