Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584073D3BF
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 16:23:57 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-52fa364f276so18958a12.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 09:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695227035; x=1695831835; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t9qw2qbqk4hWDHnzX6lU1ZgKj9HAsXbGOz7eoiWYgp4=;
        b=dBA4ROw4R66a74aqIIzP+M0FkkO9XSanT6a1fZV0YUjmU9WESZvrKLxtJvzeDA4eTP
         /mxv+aZtXdSUcct4+TXqno2Zb8Y8drz+bVkHV4g2nidlVHi9tFhuSJk3G086sRgzlf+r
         Y28Lg9UrebUNaTfRTZYU8nsIvtf5q5QnEHP8o05aEjVKCb4zSR2RcpdLRtmpZr21O4lR
         FNj0sAUt6bPPdyWK9dufCMtjGrixTty8/I0str+FcS0p7+zbzOPCYutDA0iRc9Rt6mPi
         IXvZn/RUZewEIrxvqHhrLrS+nuzxNhfZd0YQFeucwLmwA7rGUyivEFz7jduOGHq/ym6j
         suDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695227035; x=1695831835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9qw2qbqk4hWDHnzX6lU1ZgKj9HAsXbGOz7eoiWYgp4=;
        b=oJscizNhzgwsuj8kcmnNAP1W9oGNsYDvFocvcK+0wchMJGHpf4BmclyNzcyZx7+Af0
         AiB5npfgqmh4xFEuoeDJv8eassXG1N0cagMcmw85fHIabuVf5SZHFy+T+1WsnXrGgBUd
         1XziNeK1mS+59uWDi6D7grJjlPcgHMzu7uHvi064qrn0EKYOWxLfIy8AeSYxq3MUypxX
         mBZWhx+yuHYIIEypgsfyuMIIsU8ysXPWCEtEMcxO85OGhk4ZIcrc0nmLNf2w0E8z8U+Z
         CezdTQOKUgLtC1k1yDx77StRsm3/mr6QCxooSphQJ03nHLMeAGhdhQ17IrPSS3MFQxBw
         pYMg==
X-Gm-Message-State: AOJu0YxEojDeWsuaiVQde1VS+3E4ZNpbE+aV59o61kRWavNQXgJPBvzG
	lgbpPtrXOAOLtBh0dVW/BNOx0Q==
X-Google-Smtp-Source: AGHT+IFFlWrNoHXSvSVb6xkx8oK4kVT0Q6yusqBR5qmVON/HAoAk/lEM3JeEK3FptmnzGh8vBJ8+PA==
X-Received: by 2002:a50:8751:0:b0:525:573c:6444 with SMTP id 17-20020a508751000000b00525573c6444mr126469edv.1.1695227035439;
        Wed, 20 Sep 2023 09:23:55 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id q5-20020a5d6585000000b0031f5f0d0be0sm19144889wru.31.2023.09.20.09.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 09:23:54 -0700 (PDT)
Date: Wed, 20 Sep 2023 16:23:49 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 20/45] KVM: arm64: iommu: Add map() and unmap()
 operations
Message-ID: <ZQscldu3ZjHSutdz@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-21-jean-philippe@linaro.org>
 <ZCXRbF0dP7oHT+hl@google.com>
 <20230404160046.GA305012@myrica>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404160046.GA305012@myrica>

Hi Jean,

On Tue, Apr 04, 2023 at 05:00:46PM +0100, Jean-Philippe Brucker wrote:
> Hi Mostafa,
> 
> On Thu, Mar 30, 2023 at 06:14:04PM +0000, Mostafa Saleh wrote:
> > > +err_unmap:
> > > +	__kvm_iommu_unmap_pages(&iopt, iova_orig, pgsize, pgcount_orig - pgcount);
> > On error here, this unmaps (and unshares) only pages that has been
> > mapped.
> > But all pages where shared with IOMMU before (via
> > __pkvm_host_share_dma) and this corrupts the other pages state as
> > they are marked as shared while they are not.
> 
> Right, I'll fix this
> 
> > I see we can add a "bool unshare" arg to __kvm_iommu_unmap_pages which
> > will be called with false on error from here after calling
> > __pkvm_host_unshare_dma for the whole range.
> 
> I think it's simpler to call iopt_unmap_pages() directly here, followed by
> __pkvm_host_unshare_dma(). It even saves us a few lines
> 

I have been doing some testing based on the latest updates in
https://jpbrucker.net/git/linux/log/?h=pkvm/smmu

I think the unmap here is not enough as it assumes the whole range
can be unmapped in one call, so we would need something like this
instead (patch might no directly apply though):
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 7ebda87a1c61..32e145b9240f 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -432,6 +432,7 @@ int kvm_iommu_map_pages(pkvm_handle_t domain_id,
 	unsigned long iova_orig = iova;
 	struct kvm_hyp_iommu_domain *domain;
 	struct pkvm_hyp_vcpu *ctxt = pkvm_get_loaded_hyp_vcpu();
+	size_t unmapped;
 
 	if (!kvm_iommu_ops)
 		return -ENODEV;
@@ -489,8 +490,13 @@ int kvm_iommu_map_pages(pkvm_handle_t domain_id,
 
 err_unmap:
 	pgcount = pgcount_orig - pgcount;
-	if (pgcount)
-		iopt_unmap_pages(&iopt, iova_orig, pgsize, pgcount, NULL);
+	while (pgcount) {
+		unmapped = iopt_unmap_pages(&iopt, iova_orig, pgsize, pgcount, NULL);
+		iova_orig += unmapped;
+		pgcount -= unmapped/pgsize;
+		if (!unmapped)
+			break;
+	}
 	__pkvm_unshare_dma(paddr_orig, size);
 err_domain_put:
 	domain_put(domain);
-- 


Thanks,
Mostafa
