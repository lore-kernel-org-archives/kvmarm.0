Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501923212
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 13:13:47 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so13150409wmb.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 05:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UreL9/hMSi7qNUg97ylr9ven1fAXpLCqPo8E33WeL0c=;
        b=ZZTHjNbU5QhGIqSmv8W5sQAh1s8Y2kip8mttzaRz7d+S6y8Iw4FZBUFU7SwtGKm7TZ
         +wESoBLX+TbYsv7vm2ZChuev2ln+oSTVoVF4q7PN8qWjU96f6eWUfWjCv7ZWYliRc3V4
         JJ+UYfNsWTMO33mWim3ULewa5nXvt8dScquO8A0f3WFiM1yAzJrvyMyPWgKGrFi0Hrdf
         CSpG3pmxx5zQsJr6RSuufpdA02MjPrMA8P1TS6x4d+x7ouiuMwFG9fptp+DeUuQvV3tJ
         4FpErCestiO7hdKvk5x9xYn3xSXhVCtT6RIZoisnlC4JAg/PFasjxYy5w3rqoSj+Iy1F
         nGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UreL9/hMSi7qNUg97ylr9ven1fAXpLCqPo8E33WeL0c=;
        b=vwJHbdvw9htx9XT/oDCNfwoMTLIEp8GG1LVV395lDnmbHH4riDLuWn3TCHQyuL2YOQ
         3oO36CvMLcgLrbuNEeDSH4kVeKdwbZFeOcaLj4wA/O/mm8MBCswjecMJ8DUZ6lzRQpm2
         0Q6NXrBLsq/NjEVOUQLFo84ojv7aNkvezXC412fccusjW/NJywWqNK+x3p2jZqVlVHlh
         p+w3hDm+RO4ThZcCRxMc8dJfxNa0de0JhV/YAIpzG6SkUJIDvbjs/ohiy+RlPzPAQXVw
         MEQo7pG0JwAMAF31bwCaPNY2T/T0ttwGstJ11rlBnJFt2ZVIM5EjaJx2IsOYpql2gtix
         ilLQ==
X-Gm-Message-State: AO0yUKXu4LOGHsSl3N05gez/vrw0IhJGZ/sJH722HYF5NjebYd36Mu4u
	b+oVyCfXik5h0v4o0ZD0Xyrv4QBbm9T5iezcDOLz/w==
X-Google-Smtp-Source: AK7set9hugKc9q9wJqpgPDvqd2hbrrMkcWUAdDx1uxLRk8OirJVQiCKv0446v+bAgzdXWwRpxbfpHA==
X-Received: by 2002:a05:600c:3c88:b0:3dd:c896:d2b1 with SMTP id bg8-20020a05600c3c8800b003ddc896d2b1mr168442wmb.0.1675775625548;
        Tue, 07 Feb 2023 05:13:45 -0800 (PST)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c3b8900b003d9aa76dc6asm20249421wms.0.2023.02.07.05.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:13:45 -0800 (PST)
Date: Tue, 7 Feb 2023 13:13:40 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
Message-ID: <Y+JOhEfi8mu1RuOt@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-20-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201125328.2186498-20-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:53:03PM +0000, Jean-Philippe Brucker wrote:
> The IOMMU domain abstraction allows to share the same page tables
> between multiple devices. That may be necessary due to hardware
> constraints, if multiple devices cannot be isolated by the IOMMU
> (conventional PCI bus for example). It may also help with optimizing
> resource or TLB use. For pKVM in particular, it may be useful to reduce
> the amount of memory required for page tables. All devices owned by the
> host kernel could be attached to the same domain (though that requires
> host changes).
> 
> Each IOMMU device holds an array of domains, and the host allocates
> domain IDs that index this array. The alloc() operation initializes the
> domain and prepares the page tables. The attach() operation initializes
> the device table that holds the PGD and its configuration.

I was wondering about the need for pre-allocation of the domain array.

An alternative way I see:
- We don’t pre-allocate any domain.

- When the EL1 driver has a request to domain_alloc, it will allocate
both kernel(iommu_domain) and hypervisor domains(kvm_hyp_iommu_domain).

- In __pkvm_host_iommu_alloc_domain, it will take over the hyp struct
from the kernel (via donation).

- In all other hypercalls, the kernel address of kvm_hyp_iommu_domain will
be used as domain ID, which guarantees uniqueness and O(1) access.

- The hypervisor would just need to transform the address(kern_hyp_va)
to get the domain pointer.

I believe that would save some memory as we allocate domains when needed.

Please let me know what you think about this?

Thanks,
Mostafa
