Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAD7C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 17:11:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 110CE64F59
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 17:11:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 110CE64F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8790E4B6BF;
	Thu,  4 Mar 2021 12:11:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e1ok7KqPAPTW; Thu,  4 Mar 2021 12:11:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E3364B6B2;
	Thu,  4 Mar 2021 12:11:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3464B6AB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 12:11:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qca7jh8OVizS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 12:11:19 -0500 (EST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A92D54B388
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 12:11:19 -0500 (EST)
Received: by mail-wm1-f46.google.com with SMTP id w7so8729416wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 09:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xFBPptA1LX4xyld1RDDV7UcfKnkB6M3UWan7nS+Z21M=;
 b=tiAETIbaY5PD9LghmQ3hpAzU9/xT4+vZSyepR2JFaM6dHEk/nttduYLtMdNKlbr2F0
 2xGgwDcrWQicytfoFsHEZMFSB+tMZSqJXGirbIeyyBAC3+b+WR5V7b1uCEmu52HozAMb
 h8nRzWD3zCA7q7WSXN9wKLu7cnMPJZJZT+dApiQnAniTfYMWA0KTH7HBLWECDRgYYToV
 1/oSGc3jHjaz0ecfGCVuE8qn8ac/W6C4v44HP/uDzaCLEPs0kGrBaV2Y+WFlf7rYTJdL
 aSI7OWJff8UayvQr2V7rLdtbfuHyCjM7gUcKlBHvLg5uF8+ZjZed/hoZXH/Fff2EASul
 9Tfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xFBPptA1LX4xyld1RDDV7UcfKnkB6M3UWan7nS+Z21M=;
 b=UtYbxkltiIKde+f5J72nlt3ayadkb9DUD9rMDd0oQtb+3xnEWL6gJbF2oUJZD3eB97
 kO2I7on+gvNukYq1dcteKnonfOhL/lS1l9Bp8pFGDHR4R6kBcEvoMiEAVt+WTAu2mJ1N
 FZaWkMXl505Bs0/OknYI7vCnZvUbw+8tRCjq0gd3KciDnxoP2+kdCK4KI0vmVmG+b3HQ
 XxBrTY1t6txXK5YnKC+t5g6buRAVq+lQdPBWgHj/PEpkcGf2BH8Vbyk4bZ14W9lRmOJi
 WmE5wEnEsF5ihd4S5+1g+rLK8qquRbbijC0fxT6F+LbWtOwrVvomiFLnHwTtzky8MhnE
 sL6g==
X-Gm-Message-State: AOAM532OeleTjjl1KNeOcObqU1Hdv1MYbHr7EpLNPIjsMD9Nx/gpgaPk
 zgPYhJSQJuYSSspaySgd3ibx/g==
X-Google-Smtp-Source: ABdhPJxOntYhGbDUS7U/hw2vNYCli4kH7kDgdSmiVlbsTu2jHmpDOTkFqOg/YkOfklJtre/JYQMOtg==
X-Received: by 2002:a7b:c3cd:: with SMTP id t13mr4891812wmj.109.1614877878605; 
 Thu, 04 Mar 2021 09:11:18 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
 by smtp.gmail.com with ESMTPSA id b186sm58826wmc.44.2021.03.04.09.11.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Mar 2021 09:11:18 -0800 (PST)
Date: Thu, 4 Mar 2021 18:10:57 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [RFC PATCH 4/5] iommu/arm-smmu-v3: Use pinned VMID for NESTED
 stage with BTM
Message-ID: <YEEUocRn3IfIDpLj@myrica>
References: <20210222155338.26132-1-shameerali.kolothum.thodi@huawei.com>
 <20210222155338.26132-5-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210222155338.26132-5-shameerali.kolothum.thodi@huawei.com>
Cc: maz@kernel.org, alex.williamson@redhat.com, linuxarm@openeuler.org,
 iommu@lists.linux-foundation.org, prime.zeng@hisilicon.com,
 jonathan.cameron@huawei.com, zhangfei.gao@linaro.org,
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

Hi Shameer,

On Mon, Feb 22, 2021 at 03:53:37PM +0000, Shameer Kolothum wrote:
> If the SMMU supports BTM and the device belongs to NESTED domain
> with shared pasid table, we need to use the VMID allocated by the
> KVM for the s2 configuration. Hence, request a pinned VMID from KVM.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 49 ++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 26bf7da1bcd0..04f83f7c8319 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -28,6 +28,7 @@
>  #include <linux/pci.h>
>  #include <linux/pci-ats.h>
>  #include <linux/platform_device.h>
> +#include <linux/kvm_host.h>
>  
>  #include <linux/amba/bus.h>
>  
> @@ -2195,6 +2196,33 @@ static void arm_smmu_bitmap_free(unsigned long *map, int idx)
>  	clear_bit(idx, map);
>  }
>  
> +static int arm_smmu_pinned_vmid_get(struct arm_smmu_domain *smmu_domain)
> +{
> +	struct arm_smmu_master *master;
> +
> +	master = list_first_entry_or_null(&smmu_domain->devices,
> +					  struct arm_smmu_master, domain_head);

This probably needs to hold devices_lock while using master.

> +	if (!master)
> +		return -EINVAL;
> +
> +	return kvm_pinned_vmid_get(master->dev);
> +}
> +
> +static int arm_smmu_pinned_vmid_put(struct arm_smmu_domain *smmu_domain)
> +{
> +	struct arm_smmu_master *master;
> +
> +	master = list_first_entry_or_null(&smmu_domain->devices,
> +					  struct arm_smmu_master, domain_head);
> +	if (!master)
> +		return -EINVAL;
> +
> +	if (smmu_domain->s2_cfg.vmid)
> +		return kvm_pinned_vmid_put(master->dev);
> +
> +	return 0;
> +}
> +
>  static void arm_smmu_domain_free(struct iommu_domain *domain)
>  {
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> @@ -2215,8 +2243,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
>  		mutex_unlock(&arm_smmu_asid_lock);
>  	}
>  	if (s2_cfg->set) {
> -		if (s2_cfg->vmid)
> -			arm_smmu_bitmap_free(smmu->vmid_map, s2_cfg->vmid);
> +		if (s2_cfg->vmid) {
> +			if (!(smmu->features & ARM_SMMU_FEAT_BTM) &&
> +			    smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +				arm_smmu_bitmap_free(smmu->vmid_map, s2_cfg->vmid);
> +		}
>  	}
>  
>  	kfree(smmu_domain);
> @@ -3199,6 +3230,17 @@ static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
>  				!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB))
>  			goto out;
>  
> +		if (smmu->features & ARM_SMMU_FEAT_BTM) {
> +			ret = arm_smmu_pinned_vmid_get(smmu_domain);
> +			if (ret < 0)
> +				goto out;
> +
> +			if (smmu_domain->s2_cfg.vmid)
> +				arm_smmu_bitmap_free(smmu->vmid_map, smmu_domain->s2_cfg.vmid);
> +
> +			smmu_domain->s2_cfg.vmid = (u16)ret;

That will require a TLB invalidation on the old VMID, once the STE is
rewritten.

More generally I think this pinned VMID set conflicts with that of
stage-2-only domains (which is the default state until a guest attaches a
PASID table). Say you have one guest using DOMAIN_NESTED without PASID
table, just DMA to IPA using VMID 0x8000. Now another guest attaches a
PASID table and obtains the same VMID from KVM. The stage-2 translation
might use TLB entries from the other guest, no?  They'll both create
stage-2 TLB entries with {StreamWorld=NS-EL1, VMID=0x8000}

It's tempting to allocate all VMIDs through KVM instead, but that will
force a dependency on KVM to use VFIO_TYPE1_NESTING_IOMMU and might break
existing users of that extension (though I'm not sure there are any).
Instead we might need to restrict the SMMU VMID bitmap to match the
private VMID set in KVM.

Besides we probably want to restrict this feature to systems supporting
VMID16 on both SMMU and CPUs, or at least check that they are compatible.

> +		}
> +
>  		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
>  		smmu_domain->s1_cfg.s1cdmax = cfg->pasid_bits;
>  		smmu_domain->s1_cfg.s1fmt = cfg->vendor_data.smmuv3.s1fmt;
> @@ -3221,6 +3263,7 @@ static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
>  static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>  {
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = smmu_domain->smmu;
>  	struct arm_smmu_master *master;
>  	unsigned long flags;
>  
> @@ -3237,6 +3280,8 @@ static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>  		arm_smmu_install_ste_for_dev(master);
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  
> +	if (smmu->features & ARM_SMMU_FEAT_BTM)
> +		arm_smmu_pinned_vmid_put(smmu_domain);

Aliasing here as well: the VMID is still live but can be reallocated by
KVM and another domain might obtain it.

Thanks,
Jean

>  unlock:
>  	mutex_unlock(&smmu_domain->init_mutex);
>  }
> -- 
> 2.17.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
