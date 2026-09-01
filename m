Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B9D3B4407
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273290; cv=none; b=jZPoXDWlX2eaViLNiCzrGJiu4F4IWQVIsPMVN/aFj8G3PjSLGlKUZxMmHheimTkaKM6HWHFUjVfFORdaI3HCGgOkMjSif1q7t0rrreIM+Ux8aHNO7JzdERTowibWBxNA+/Ze3FPe+l75hHIgnyo1h9UTp1LLb80nC2vnQ0V2tQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273290; c=relaxed/simple;
	bh=8yIR2l5kWTbTZXEBPaalfxQDjpL45I/SVC9tN3kaCb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJNEXAxsKAcH5d2skMbALs7XUuTltBVV0noajZxvAhEhJYNF/v/Ek7z9XueaY7REzWPKH8cmBPO/BMEZaYuty6Qyk8N9z2UzC+MwA1NxnfmA1Ns0A3s+JPFjdXecfJOHwYNeLH7rzRjL5cG22jqm+bVQoGdnYXSx20EXSRy2c6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IhXwtTmd; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IhXwtTmd"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5301db51586so12022971cf.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 07:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788273287; x=1788878087; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4Msi/TOmLhS+cZQhvH9ha0bUxCIzijPq3v5j1Cfzxv4=;
        b=IhXwtTmdHxzwQ9PGsA+UjB9J+Ix4KZvXqRgauqOXj3EzLRUm15wC9eGh0bJF4x1BuX
         GDd080U2vlTR9NfxjaUAEzd84AT1Qdk76A2nHcEYA0DTijYzj1uC4c/oJKA0FqNqUoqp
         7x9plcbd3FMZRSiA/dhy65PO94uyXhFs4MvyGNpVwQ5q8KlPCY/Lb8f4A9ZAcmgk9o8z
         FgVi42bEh5ozVCIBUut4+z24jkZqlLH/DJlG2KdhaunBLNPYw1dzRbuSUoaRjXMNuA6i
         NubVjRnAuwOOGS/FweVGbq5+v1ozajLnnRuIGp1/EsPYF4uLN+xmqLgJSluBAufHhCvs
         hlPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788273287; x=1788878087;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Msi/TOmLhS+cZQhvH9ha0bUxCIzijPq3v5j1Cfzxv4=;
        b=fS4n8EMMOUnBANH3t3IAVtA0P/syy4wZ0zDKHPbOTuoz0BjBOAk1mj6Wo2aT+ykBCk
         ycI0luVJ+vvrkbxwMCLRArQ+Lsze0zlLmP/A6YlRdJGvTQn+g8O4wgq6+5H9lxnm2ryV
         VvN/Fv0l1RdaICy/6mUyGM4Ll644395Siig843fl45uHsy7UbLLZPsHIoQPOoRzfuetP
         5kECo1gsox5fsFiFWpmxfr3U1DyFKdwPTt9KXiDJ0gSglkS/k5bWcXH/83AzbiOHyvmT
         ggJyC5wtWGo8qNxJ2vc7ntxpoPJvDuMJBYEponSbHp08Z1DN7orMxsc/9zBjDqJ26Eg9
         s/dg==
X-Forwarded-Encrypted: i=1; AHgh+RrfS1IFDm1U12Tu767+HEu0NlS+Q846qeKg8K5daA28ydhH9BAaJf4CYy4iNBnm+xstUc5w1tI=@lists.linux.dev
X-Gm-Message-State: AFuF++nH840UHyXbL5vAND4WaNa9/+u/Ti7h01RzuG20J2KQGALIWYPV
	580O6EBwllgmcGc1TPX3sN9YvdS1rntDIe/1UYwNgJVLhjR25jE+4EgACkHHUTnINko=
X-Gm-Gg: AR+sD12NNOJq3840qGAZHX1Iwl/BY5OVODUIfICPLishtGOA1cNX0yAt45kuz1HU57V
	iIIoa/cmiAgFl14hfXu9AcvEVfxsFPGB/nMlqslUzGk1nE0p3JQ+JcxZl50X6ggwWg4W8dobz5c
	pYi05pRuZi1NSzvmooYbdXFxSbzbn2tzUCIjurnj1jLluJEraCAkHrRlibntJWBSUViQvZnndzb
	aBXvzUK7Bdrk7uWMDNdfIJZ1Tki+Ta0K/FppS6VhSRe7fjP/1aWmqAu0qr6feWzmdSlKHXsks4s
	T3vEbpi5kcv9wZ9miKzD+Xxs9Qsdg9fGHJbVw1gar+uCO2g3CLOR9FdTCS6QJLWHyfipkNSW0tZ
	ZMT/7O6Dl0n0/LQOU7MmRiXMo4Pefq+OFq4/4dytDfWGolJJU1yuB/5bGAsW6REaFopc7rmz9wF
	awlcUogW3sCJfJyTN5S8NGdh8GVt2+foRdRbRs/eJCgSC23xVpgGTQHAV/ka1fxfw2pPVbo4T1G
	6G1KJGSiRi9sV/OnOrQMUzZjEHflRcDVRlBzrhy28b8zLI=
X-Received: by 2002:a05:622a:5913:b0:52f:f472:bad1 with SMTP id d75a77b69052e-52ff472c08bmr383344431cf.33.1788273287009;
        Tue, 01 Sep 2026 07:34:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe830222sm98165671cf.20.2026.09.01.07.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:34:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1PZV-0000000Bhy0-23ZI;
	Tue, 01 Sep 2026 11:34:45 -0300
Date: Tue, 1 Sep 2026 11:34:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260901143445.GC56830@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aecfdnv4i.fsf@kernel.org>

On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:

> @@ -463,14 +460,13 @@
>  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
>  
>  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
> +		if (arm_smmu_is_realm_viommu(viommu))
> +			return arm_realm_smmu_v3_init(viommu, user_data);
> +

I think the realm vsmmu is going to require a different info struct
than the normal psmmu case, isn't it?

If so it needs its own enum value.

It would be nice to see a draft patch showing how the real vsmmu works
on top of the RMM spec for it. If we are using a viommu object then
non-vsmmu case should be identical just with an option in the info
struct to not create the vsmmu object.

Jason
