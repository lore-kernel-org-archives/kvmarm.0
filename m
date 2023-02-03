Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E5D23C4
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 11:23:49 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id r2so4339425wrv.7
        for <kvmarm@lists.linux.dev>; Fri, 03 Feb 2023 03:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vIOzPmIQfpfrIHgLdmsoioJq9/vt9AQ9/SWmvcYBZ+k=;
        b=XgBs6o3VgmVG855AY/KN5Trje6g0K3PRcPCbi8e+tcssh4EReUkCjvG4PCS9REBE+f
         LewSppzIQS//FvZIyhJ7tg6ZBp8BEiykp+SqvS9PHKBHQTZk5ZKLUbYvnQdhqcwDArW2
         rm7+FlJJnPEb6Q3jgQyap3t2gJiPAsBx1ZmwIfO6xLpFMugKpof8B4DuRq9c4r/MzWBd
         xByyHCXxYrGOPI+jjQlHJwUdo+sBlulT0I2nClF3j8oJrne++GqZ04v1ha1OrXwNiUQD
         zXZ9CzjHbEZ9BnoKKASLijiWsxkibxhtXjyEujEt2hfx38wUqQb4F6UjOq5dp2Zq2yOe
         1BXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vIOzPmIQfpfrIHgLdmsoioJq9/vt9AQ9/SWmvcYBZ+k=;
        b=TJyw50lZpOzcAddOWxJlppQALFT1cuYayxllOorhNQlvngsKUTYfMUB2Ojv2T+8Ol/
         LKbyqYbq6HOyLsuSOvMyeLoxnNQhnK+5YF9p480sMELJvs97JjvIr7FjXUsZPq2X/2JZ
         jfuS9cKAnZk+hKV2+SbpgMBC0OAqVHadwoWsbFgO65QI86Sk2jbbkxaLr+7JUdbYtj0q
         HC15H0jbyNWjOhrYBzPXcMgYcHe98hylRBqbBj/uF0ymiQmyURxXnshdRrdYvI5U9wMG
         f4hUctnDqESQWpHLm7g8zzi9Mm6BiwBqGVmdHmQVdiXxxjHGeeRowJjMTWzBeHkUDYPu
         i5cA==
X-Gm-Message-State: AO0yUKXH8kVsreyXHLiZ44W8gVDJLVQ7ZhFn8n1sGxsNBxHa/g4kdGr+
	KLpF4UClydKd9Du2BFKkOrf9nA==
X-Google-Smtp-Source: AK7set+6jtSiyNHjXsgEaaspWYCwXu/8Ri4A0WklUPwSPWMYVHRHYUrA9ECa3vmacpA++lUMmvcNug==
X-Received: by 2002:a5d:64e6:0:b0:2bf:b33b:fb7a with SMTP id g6-20020a5d64e6000000b002bfb33bfb7amr10444689wri.25.1675423427711;
        Fri, 03 Feb 2023 03:23:47 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id e23-20020a5d5957000000b002366e3f1497sm1794207wri.6.2023.02.03.03.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 03:23:47 -0800 (PST)
Date: Fri, 3 Feb 2023 11:23:43 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: "Chen, Jason CJ" <jason.cj.chen@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "maz@kernel.org" <maz@kernel.org>,
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
	"Zhang, Tina" <tina.zhang@intel.com>
Subject: Re: [RFC PATCH 00/45] KVM: Arm SMMUv3 driver for pKVM
Message-ID: <Y9zuv6OnBEow/gf0@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <BN9PR11MB527660209BD0599235F2BFD68CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y9uK4t1iAsmnuyyi@myrica>
 <BN9PR11MB52768726DEB06010E51027C78CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <SA1PR11MB5923FE1EFFA389E80E403C3FBFD79@SA1PR11MB5923.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR11MB5923FE1EFFA389E80E403C3FBFD79@SA1PR11MB5923.namprd11.prod.outlook.com>

Hi Jason,

On Fri, Feb 03, 2023 at 08:39:41AM +0000, Chen, Jason CJ wrote:
> > > > btw some of my colleagues are porting pKVM to Intel platform. I
> > > > believe they will post their work shortly and there might require
> > > > some common framework in pKVM hypervisor like iommu domain,
> > > > hypercalls, etc. like what we have in the host iommu subsystem. CC
> > > > them in case of any early thought they want to throw in. 😊
> > >
> > > Cool! The hypervisor part contains iommu/iommu.c which deals with
> > > hypercalls and domains and doesn't contain anything specific to Arm
> > > (it's only in arch/arm64 because that's where pkvm currently sits). It
> > > does rely on io-pgtable at the moment which is not used by VT-d but
> > > that can be abstracted as well. It's possible however that on Intel an
> > > entirely different set of hypercalls will be needed, if a simpler
> > > solution such as sharing page tables fits better because VT-d
> > > implementations are more homogeneous.
> > >
> > 
> > yes depending on the choice on VT-d there could be different degree of the
> > sharing possibility. I'll let Jason/Tina comment on their design choice.
> 
> Thanks Kevin bring us here. Current our POC solution for VT-d is based on nested
> translation, as there are two level io-pgtable, we keep first-level page table full 
> controlled by host VM (IOVA -> host_GPA) and second-level page table is managed 
> by pKVM (host_GPA -> HPA). This solution is simple straight-forward, but pKVM 
> still need to provide vIOMMU emulation for host (e.g., shadowing root/context/
> pasid tables,  emulating IOTLB flush etc.). 

I dismissed emulating the SMMU early on because it feels too complex
compared to an abstracted hypercall interface, but again that may be due
to the high variation of configurations of the SMMU. For nesting, you
could use some of the interface that Yi Liu and Jacob Pan have been
working on [1]. It should be possible with a couple of attach-table and
tlb-invalidate hypercalls to avoid emulating the low-level registers and
queues.
 
> As I know, SMMU also support nested translation mode, may I know what's the 
> mode used for pKVM?

It doesn't use nested translation because it is optional in the SMMU, and
this series tries to support any possible implementation. Since pKVM on
arm64 is being used on mobile platforms I suspect that, to save space,
some SMMUs might not implement first-level or second-level page tables.
Besides, supporting nesting for Arm would still require hypercalls for
pinning DMA pages (solution 2).

This series populates the second-level tables with the complete IOVA -> PA
translation (similarly to how VFIO works at the moment). If an
implementation only supports first-level tables, then the hypervisor would
own it and put the IOVA -> PA translation in there.

Thanks,
Jean

[1] https://lore.kernel.org/linux-iommu/1570045363-24856-2-git-send-email-jacob.jun.pan@linux.intel.com/
    (It's being reworked but I couldn't find a recent link)

> 
> We met similar solution choices whether to share second-level io-pgtable with CPU
> pgtable,  and finally we also decided to introduce a new pgtable, this increase the
> complexity of page state management - as io-pgtable & cpu-pgtable need to align
> the page ownership.
> 
> Now our solution is based on vIOMMU emulation in pKVM, enlighten method should
> also be an alternative solution.
> 
> Thanks
> Jason CJ Chen

