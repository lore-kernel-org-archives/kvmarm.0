Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2A5111B
	for <kvmarm@lists.linux.dev>; Thu,  2 Feb 2023 10:05:28 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso920966wmq.5
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 02:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=//FGsavWGq7T3Rr30An+rU9ir1tcyiUHbK5lp+YEfbI=;
        b=BZZULLBl0kGh3VFc2wse3O+99pkqDuhwdixhuEcU5czRIGW7hx+T9jnMpkAwP2wJFc
         167d7InIG09+4fCSeEZ82uxXS+lsutAENcw6/0k0FC9CFQWLAno8O4r4cwTYaeGElYRv
         MoWcq0HldC40ljDfBLau7/anN1rpYKBaQAsdJ7IE7068gIbjO0828VMU/Ujns+DWa8Cc
         6TNXfAyvGMS+pWmBumpxSFR/R2kCpdKCNBRc4WWunbKbukxx0vogiE8CMqwwvCxjuGpR
         aFhwm3dkxyc/8sR8TkZ5Xc2B1Jefh1BYqUPLy65KgJp+QtRVHe9h1wN4w9ITz04LpZJ+
         ewug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//FGsavWGq7T3Rr30An+rU9ir1tcyiUHbK5lp+YEfbI=;
        b=6co4nwGpoNZJoNAnbpV5KcVzikSOoQfDMqCx671xPX8Qm3IU8Kjsrwz2B1U6BdIGId
         87azitqHc+O6KoQOhssANZlto25USIwxbEM38wIA1cbd22bryxExdRv1Xp//M8+oGui3
         CA+62xKvYpHYSoAwpzkrxNRNrYp5HlOc7iYTRrzc5nvKkT3pup9LP+H0/UU/xmg/M8z9
         BeQqX5oO1oogBCQDUNk6Y5S4N6dJ8j9HfrQf5658sVFhEiQq2hTy2/uljbvr3cAg/BI8
         Kmf3e4QCfCCfFAR6oO9EF8H/kp2eQddAu5gOLZA8fFdVebXg3UV003ym3yivfPhpx1n9
         dhGQ==
X-Gm-Message-State: AO0yUKU6LZ5Yn5OuBje4n6L90h+ZaYRINbANNFmbYJEV47/KeN3tBnVD
	hTZAM/4cCqrrPQbRwsH0aMrH3w==
X-Google-Smtp-Source: AK7set9o9lUlSUCSbmSEE4a5cgm2BnJoKtnZQXI83oGKvNCQcsNp6lAJvxlkrOmiL9ELrc7eKFXsrA==
X-Received: by 2002:a7b:ce11:0:b0:3dd:393c:20b5 with SMTP id m17-20020a7bce11000000b003dd393c20b5mr5414944wmc.35.1675332327049;
        Thu, 02 Feb 2023 02:05:27 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id i40-20020a05600c4b2800b003dc42d48defsm4004276wmp.6.2023.02.02.02.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:05:26 -0800 (PST)
Date: Thu, 2 Feb 2023 10:05:22 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "maz@kernel.org" <maz@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"smostafa@google.com" <smostafa@google.com>,
	"dbrazdil@google.com" <dbrazdil@google.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Chen, Jason CJ" <jason.cj.chen@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>
Subject: Re: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Message-ID: <Y9uK4t1iAsmnuyyi@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>

On Thu, Feb 02, 2023 at 07:07:55AM +0000, Tian, Kevin wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Sent: Wednesday, February 1, 2023 8:53 PM
> > 
> > 3. Private I/O page tables
> > 
> > A flexible alternative uses private page tables in the SMMU, entirely
> > disconnected from the CPU page tables. With this the SMMU can implement
> > a
> > reduced set of features, even shed a stage of translation. This also
> > provides a virtual I/O address space to the host, which allows more
> > efficient memory allocation for large buffers, and for devices with
> > limited addressing abilities.
> > 
> > This is the solution implemented in this series. The host creates
> > IOVA->HPA mappings with two hypercalls map_pages() and unmap_pages(),
> > and
> > the hypervisor populates the page tables. Page tables are abstracted into
> > IOMMU domains, which allow multiple devices to share the same address
> > space. Another four hypercalls, alloc_domain(), attach_dev(), detach_dev()
> > and free_domain(), manage the domains.
> > 
> 
> Out of curiosity. Does virtio-iommu fit in this usage?

I don't think so, because you still need a driver for the physical IOMMU
in the hypervisor. virtio-iommu would only replace the hypercall interface
with queues, and I don't think that buys us anything.

Maybe virtio on the guest side could be advantageous, because that
interface has to be stable and virtio comes with stable APIs for several
classes of devices. But implementing virtio in pkvm means a lot of extra
code so it needs to be considered carefully.

> If yes then there is
> no need to add specific enlightenment in existing iommu drivers. If no 
> probably because as mentioned in the start a full-fledged iommu driver 
> doesn't fit nVHE so lots of smmu driver logic has to be kept in the host?

To minimize the attack surface of the hypervisor, we don't want to load
any superfluous code, so the hypervisor part of the SMMUv3 driver only
contains code to populate tables and send commands (which is still too
much for my taste but seems unavoidable to isolate host DMA). Left in the
host are things like ACPI/DT parser, interrupts, possibly the event queue
(which informs of DMA errors), extra features and complex optimizations.
The host also has to implement IOMMU ops to liaise between the DMA API and
the hypervisor.

> anyway just want to check your thoughts on the possibility.
> 
> btw some of my colleagues are porting pKVM to Intel platform. I believe
> they will post their work shortly and there might require some common
> framework in pKVM hypervisor like iommu domain, hypercalls, etc. like 
> what we have in the host iommu subsystem. CC them in case of any early
> thought they want to throw in. 😊

Cool! The hypervisor part contains iommu/iommu.c which deals with
hypercalls and domains and doesn't contain anything specific to Arm (it's
only in arch/arm64 because that's where pkvm currently sits). It does rely
on io-pgtable at the moment which is not used by VT-d but that can be
abstracted as well. It's possible however that on Intel an entirely
different set of hypercalls will be needed, if a simpler solution such as
sharing page tables fits better because VT-d implementations are more
homogeneous.

Thanks,
Jean
