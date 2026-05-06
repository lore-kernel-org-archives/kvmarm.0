Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF4C3FB061
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778061409; cv=none; b=fDIDhzfHJlXhCdceA7XC4UJnt66e3A5wVImCot/V5JyLJsKQlOnLVoV0Wk9x+8MY+WSUAGEbakCXRry997rXTtHT+oCoTzCfTFkRqm+5mFLVy0Mc3fZiKhc9cBr0SupybqCqKrJBEleAVZ5TN1+XFGLDVPtwPc5jFm0uX73pDJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778061409; c=relaxed/simple;
	bh=hatrkSn5Z6/BHN4SB6+bdCIaRWu9LOqpRgkzA91XysA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DC0WQfGtiZAFEarG/HLjROdefQ7QMA+VMoVXft8JgUGZMPSLrlHS6V+iGxAnoUWBZyfCZ5ho9Wt9EwM30mh6Zvx4ZzQzS5PLswANadwTwgrfkXN+DXt7oUWdnO8U8l1WCZkJdOL4CHNUqiYn+R4XTZAd+re1CyrR5+AvNA6iq9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=U8Xy/iwK; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="U8Xy/iwK"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d7645adbdso3769977f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 06 May 2026 02:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778061393; x=1778666193; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GCpEK+1e4PN546tNNVMgEraFuXI3jgId2T+tlphvHrE=;
        b=U8Xy/iwKQshQx0Zc1ZYTbMR1JJRVSr9FLnryl/7i7tYaXAW6bfYcm02iFf5gbUnhka
         ODR9JWmsx6E7veFP8NHLivJAdcBGiOJB4p2RY2nwyUtqPL0N9ipeS98nnFhKq87feExm
         fhlBPJLeZfCYPyeGucUFGdrhu+DzCykW6VtUWE2QHTdp435jjW6lJmcIoxEx9RROrmnH
         oSAM0inlfsNV5GWtt55zk6eQoIbHCmD7YHNUCRqVx8f4JYJy9T54Kx+icYLJ1heuGrwZ
         yN/iaUrnYB3fn/EiOzc0uWMBZnnDxtf5yh+Fdj68AC2SQyE5ur5iiUK4I8Cp6USUrhh1
         j/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778061393; x=1778666193;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GCpEK+1e4PN546tNNVMgEraFuXI3jgId2T+tlphvHrE=;
        b=Us0MtjLvCsDG1NZp4QQ21+3C0cZe/+w7ypwN4nLEv9kCC1g/Zzh3ZwOgKwD0fdWjHa
         0J8DjEtCUd5REOQ8xOxcBQzkzozlkkOlACQF4hi/BAYC1p55h/UqjFDcYk+gf7Jn8rTl
         PYm9P/Sy/2BiYwKNpjnir4iuAcyXIAZoPAgbHQPnJOsOF7mVj3T9pZIsJpwI7m/T1eBy
         fVIwf6rxtKWXMTyQl7FZqCqAitefqHQ7XHRKK0hL7gRdVuHFpdkvgZvXzkOYbPRdwOwI
         HlB7FcBED5xtisG+ChqCbvWyExehr4s8g2GgIy44VImBoyGv/Eqy6+IckCShqE9NhrC6
         fx4g==
X-Forwarded-Encrypted: i=1; AFNElJ8UfiUCFEint6L02Cjs4vg62qJwBxjobKhM8bxgmKfwRWc7imuBlSygnsRZcg3+XB4ZgVWnvMY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaHzM1S9kS5XmEIULhXTcS6vQ7iyLUmn6Ttv+WhxJ0dnvMFyOd
	vAL5pfxx+3UWUtHht+X/IeYz4GfBIqi/Qg15FIYZEH/cxLm3kmgs0ZJe2SpExiTN1XA=
X-Gm-Gg: AeBDieuC42iV1T6Uk4YJKg2Daz6TD107uWOHKAdYITiKHaB6eI4oJr/6LRkFhSQ9QP+
	zEsIbNoTgsgQpcZ1BbSZ1F08lgO5mdVkUVbk9LvEfHw3Vtu2puGT23uKSSNbkoqohyNwWu4BZgW
	gsS8XJw9zfl71dJWRUJwy7jwWoRSg5RsnI2WWiGSm4jeKTEU4VI5MAZd6AIHo64ombz4tH/2Mlm
	acRCY1Dxj3il50/Q5Y/qlxPMOxf5azenjAAuU18Z5qeKZX2PihubyAPToXItscm0qEegE1YYPW6
	DYrKLKUpOwBYqu7PrDxb+Qd4M789gyfetr2mZ+yRkkDoPn+bhKFUqyLSgGjMh7+VsPdtQ12/yUW
	QPtOALnWKS8gxv6j1lREyF+os0ibGCCfFFUv0czC9HuAExMGcXONDibdpAs4CR3HI4/KtFQptVB
	WfguCijgQ=
X-Received: by 2002:a05:6000:2088:b0:43d:75ec:26e7 with SMTP id ffacd0b85a97d-4515d5c6c7bmr4597539f8f.33.1778061393031;
        Wed, 06 May 2026 02:56:33 -0700 (PDT)
Received: from ziepe.ca ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45055960811sm11821992f8f.27.2026.05.06.02.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 02:56:32 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1wKYzX-0001qR-KO;
	Wed, 06 May 2026 06:56:31 -0300
Date: Wed, 6 May 2026 06:56:31 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <afsQTwO3eW+Ks2fe@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-6-smostafa@google.com>
 <20260501124716.GD6912@ziepe.ca>
 <afiODW2sVMeOj3Ag@google.com>
 <afoagb/wVBJD1IX+@ziepe.ca>
 <afofSPQbepd_fpom@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afofSPQbepd_fpom@google.com>

On Tue, May 05, 2026 at 04:48:08PM +0000, Mostafa Saleh wrote:
> On Tue, May 05, 2026 at 01:27:45PM -0300, Jason Gunthorpe wrote:
> > On Mon, May 04, 2026 at 12:16:13PM +0000, Mostafa Saleh wrote:
> > > On Fri, May 01, 2026 at 09:47:16AM -0300, Jason Gunthorpe wrote:
> > > > On Fri, May 01, 2026 at 11:19:07AM +0000, Mostafa Saleh wrote:
> > > > > Move parsing of IDRs to functions so that it can be re-used
> > > > > +unsigned long smmu_idr5_to_pgsize(u32 reg)
> > > > > +{
> > > > > +	unsigned long pgsize_bitmap = 0;
> > > > > +
> > > > > +	if (reg & IDR5_GRAN64K)
> > > > > +		pgsize_bitmap |= SZ_64K | SZ_512M;
> > > > > +	if (reg & IDR5_GRAN16K)
> > > > > +		pgsize_bitmap |= SZ_16K | SZ_32M;
> > > > > +	if (reg & IDR5_GRAN4K)
> > > > > +		pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
> > > > > +	return pgsize_bitmap;
> > > > > +}
> > > > 
> > > > I think this should include:
> > > > 
> > > > > +	smmu->oas = smmu_idr5_to_oas(reg);
> > > > > +	if (smmu->oas == 52)
> > > > >  		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
> > > > > -		break;
> > > > 
> > > > ie it should return the supported page sizes by inspecting all the
> > > > idrs and don't leave this tricky bit to be open coded..
> > > 
> > > This way was easier as each function only returns one thing, otherwise
> > > we have to pass stuff by address as we can’t pass the smmu struct as it
> > > is not shared between the drivers.
> > > But no strong opinion, I can change that.
> > 
> > Could you share the struct? With multi-compilation you do get two
> > structs with the same name and different layout, it is OK?
> > 
> > That would give a cleaner setup too because you can just shove all
> > this into a function and have it setup the same struct which is more a
> > copy and paste than break up into little functions?
> 
> Yes, that’s possible, but I didn't want to contaminate the main struct,
> also we can’t compile the main one for KVM because of things such as
> “struct device, struct mutex...”
> May we can do:
> - struct arm_smmu_device_common: Basic stuff (ioaddress, features,
>   oas...)
> - arm_smmu_device: For the main driver which inherits arm_smmu_device_common
> - arm_smmu_nested_device for KVM which also inherits arm_smmu_device_common

Less keen on this, it would need more usages to justify it
 
> What do you think?

I was thinking more like

#define arm_smmu arm_pkvm_smmu

Before the pkvm compile of the shared code. 

How does pkvm compilation work anyhow? Is it all rolled into a unique
link, or do you have to worry about symbol conflicts with the main
kernel?

Jason
