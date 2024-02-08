Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188117CF25
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707408451; cv=none; b=m5qgcaoXECozgyebnLV10vy/dNy740VcJY8GqjfpbyBnzbCtC2i6bQVJ8hXxux2dQNIvZeWTeUz0Xek1L9HOhNRBjp3kFBRATukQvUQNk8SOE/azVHuzcr/NtuSE3IjQ+BLTkQszUi3oFc/LkJywRgkA2L0wiaMFRnf5WqCneGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707408451; c=relaxed/simple;
	bh=g6TG9tOauKZ8BpiDJn7CSG4iNbEKj1ciS146rzGvjU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMx3cteeQ6MdZzeQBQUgAZJRzJOE/8g/Us+stYdFWSAq6OZyRm3XqltpI9rvGAIO0AHdq7fHtt4BX5OpvXdOVS3/TPXHVVLZztEu7ViqkAyxktkZ5M5ZNv0pOBTWkW7oEKiIB1Xgz/t1hRdGtDzhXNR6Z3YqZGSUHNUtsWMpEOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=H7BmAxBc; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="H7BmAxBc"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-59cf563e8c6so566661eaf.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 08:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1707408449; x=1708013249; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=efRxNeADBIxIA9tcHLUK3qQ/MulYKJQHDKvL8EF8Vn0=;
        b=H7BmAxBcbY6ynnXPcDw1+cK7gBXKxpx73GLE6Uoo2zEebgBAxofIn8X28tjfcPp6nQ
         E260G7Ky5FPdgvLfTmFi/yZt0sEXHgQoIb65WAMr9pWP8V2f7RQ/lGbBouhM3oT+7+wt
         nlOvu5WwDfQtiSAb8YVqkWBmoYITWWWW8bUJLlpa47Vs/BC5+5IdmvNcSVFtzi/pbWFF
         N1Gv6JCGHCV09qW7VmSReeW+/BJkOaifChx7c9QpRTh1BcIJw/ccbZ/IumkPrd/XqeT7
         n53RPojUQHfKNqPtSPslD0U5ZDywPuQakK3j9aUE5bvjG1iD1ee+fzXcO8G1kffBhN8B
         OM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707408449; x=1708013249;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=efRxNeADBIxIA9tcHLUK3qQ/MulYKJQHDKvL8EF8Vn0=;
        b=guhb2xhfuVPYQjS9n7voaq9ov+LdmBie7B7IxEo+7luCZp9+ajcsHLg+GeSARiyyyE
         j6WIBz3sheokJ2svpP4rns2tSFoVgTeg0xlt/4dbEbBxdtwXBY1TGeRUje9mC8Uuv41T
         ve/yysCO7kItdHj3qBxsKAAuHeYKXA7JICGL9O3lMbmcSoecIVMTHQRH/wgXgbBFsW85
         +nmIbE5Zmpn9mDi9N1C13d+Rcrjb4aHQwlOoKiolyTtpE/Rr6pFhj327p40boygnoght
         H1g65T0EC5roEDck+Vg8R3/o0jmb+RR7vnaaECFLXsfVAnM7Z0ik+8r/Bjq6ULRRk0CD
         0fZA==
X-Gm-Message-State: AOJu0YzjDklw6+bT3duWueRUT84zzb3V4FDgldXhJf7wp+xpQVKd59Fj
	dApGBnM5nBFAmzAVC8qbfC4LXwaGOUD6EJUFZDy2djf2PcBI6B/KIaqD5usR0/E=
X-Google-Smtp-Source: AGHT+IEXKYsO42nxhmzaN7rxdYD+Mb102jIrs8Ywh1fTKgu3Paga7tcZZUObDYHcPgIKVZSm9jhMXw==
X-Received: by 2002:a4a:9217:0:b0:59c:b57a:5746 with SMTP id f23-20020a4a9217000000b0059cb57a5746mr10164403ooh.4.1707408449174;
        Thu, 08 Feb 2024 08:07:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVvgoXVG3seSA31s1LZwK8Xhs7X2vtJDLemU5iaTtTg3NLGxY1j/WZI497ShONFfzst1cao6S9XwlYEfXeGM5CkwkjWz+Fjt2/rhCsyHcd/P10lkWcUy6wQp9xhmNWSBjQlitIy2tluo+67PPiChWYvuZOFZSLqvqWbpMD4WCRBFN1ND0OsCpK9ZKxyjefxBS9W1O5KPv4MTGbAcdZEfjVfDnrxp7fPySX4kY3WqSl8rp4JUjtCfID8Ryc50ZYF1slaVKGPGynMcH56RocCzfOZikm7aBVp+wKAlaQ+5Go0vLTjp2lXXbihu+VOjba3cn8AIJJY8cgLKq+THAQyYWxbjmDaQUQyCGaBobjKPQmciTvKepTyP+e4TWc1ljnsS/ECu0Q=
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id y13-20020a4ae7cd000000b0059d1cdc150esm69257oov.37.2024.02.08.08.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 08:07:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rY6vv-00EzEy-Nb;
	Thu, 08 Feb 2024 12:07:27 -0400
Date: Thu, 8 Feb 2024 12:07:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for
 stage 2
Message-ID: <20240208160727.GS31743@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208153532.GO31743@ziepe.ca>
 <416d8150d3ce4a67901a3ff7a596e4e8@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <416d8150d3ce4a67901a3ff7a596e4e8@huawei.com>

On Thu, Feb 08, 2024 at 03:49:20PM +0000, Shameerali Kolothum Thodi wrote:
> > On Thu, Feb 08, 2024 at 03:18:30PM +0000, Shameer Kolothum wrote:
> > > Hi,
> > >
> > > On an ARM64 system with a SMMUv3 implementation that fully supports
> > > Broadcast TLB Maintenance(BTM) feature as part of the Distributed
> > > Virtual Memory(DVM) protocol, the CPU TLB invalidate instructions are
> > > received by SMMUv3. This is very useful when the SMMUv3 shares the
> > > page tables with the CPU(eg: Guest SVA use case). For this to work,
> > > the SMMUv3 must use the same VMID that is allocated by KVM to configure
> > > the nested stage 2(S2) translations.
> > 
> > Ah so you are going all the way and looking to enable BTM within a
> > vSVA environment too?
> 
> Yes, eager to get the vSVA support 😊 Its been ages and tired of rebasing for our
> private git for the vSVA cases!.
> 
> Also for Host SVA, since we are using S1 now, I don’t think this matters that much.
> 
> (I do have some questions on the iommufd based vSVA , but I will come back to it,
> once I cleanup my Qemu branch for that.)

Oh, I think I left a comment someplace that you also need to signal to the
VMM that the kernel supports vBTM, probably via new flag in the
iommu_hw_info_arm_smmuv3

+ *
+ * Note that these values reflect the raw HW capability, without any insight if
+ * any required kernel driver support is present. Bits may be set indicating the
+ * HW has functionality that is lacking kernel software support, such as BTM. If
+ * a VMM is using this information to construct emulated copies of these
+ * registers it should only forward bits that it knows it can support.
+ *
+ * In future, presence of required kernel support will be indicated in flags.
+ */

> > If someone is using it I wonder if we need to get a more solid answer
> > on the races with invalidation an ASID reassign.. I added some notes
> > in comments in part 2 after I audited all of it.
> 
> I saw that one. The main point here is, if we guarantee that BTM is only used
> for a nested S2 case and there will be a pinned KVM VMID for that, I am 
> not sure we need to worry about any S2 related conflicts in TLBIs.

Sure for the S2, aside my other note, but my remark here was about the
S1 ASID reassign logic. I was sort of OK to leave it as it was under
the idea that BTM support wasn't turned on.

I'm concerned it is another iommufd triggerable security problem..

Jason
