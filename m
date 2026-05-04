Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774A12BE65B
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 12:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777897186; cv=none; b=KyAz13Y5psX3WLw7gaWyjIh3U0uT+iXKPcYxGmRcXlgGOOLcF+gWIBK51QRmItP21Fh1tq+3Ic7vpsdxNcTJN5AoxtYpYs2TedJ6aJ0PY0RYPqfdxnOfBa8T0rXm8b+0tl/2IkobSyoP5qc01GHwq5AVyY3mcPjitHGOinJwWQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777897186; c=relaxed/simple;
	bh=9ePXNcpJXNpBucWE7Um02jeLVCQaYHO77fP8l6NTbXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TPqPM58elojIFCetCgpIfas2YLl0yr0tWlUWYqUAYacasN18+AxbDRtvMqeoAR1Cuthr763AKVfQQ3JD1s7KrpiA3o/iSSoqurdgxLaR3e5J5dUyfA+370HIW1Gxc4u8K3kegvw2gjNgglSeJIgeUebtE0X8yCtFmfLhW1VvSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U94ZfjFB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U94ZfjFB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so170835e9.1
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 05:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777897183; x=1778501983; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PZFwKQCzFDeKBEEx0s8dTkXKr01dndAPiIRslPFEQHw=;
        b=U94ZfjFBnY7AO3uOUXtDwORfczZ0YWYIl+hDFef1JvXoztd8eJYoeFNOYi/X4fC6fO
         hIG9vkMSIfLnxEB8Yzrt1/nA7zig9RGEwTuWiLwIR+3q4LhyM8oX3SunVL5eVnaOqUQW
         BzuFYbgtXlJHrKjwvB2JDEBmlbmWa5cN2U54k/MjyyXWv9s8HQOvotX7PmeIdF/2fwZg
         EqJ8Zg6VDVyO8qaXkdBniiCBcpVSOzjtx+MZb65w9cSNpQLP649raKW+YWQwaaHXmULS
         Eeap3+JWL16OKdziceZmA75SVLtDVD8ItQSeeAwxyJCR22AtIOyKBcm2U/gU9FCyWlbd
         ly+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777897183; x=1778501983;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PZFwKQCzFDeKBEEx0s8dTkXKr01dndAPiIRslPFEQHw=;
        b=HfY6wCdxYbcRO9g/xlCfj9gM5fewvrPNHFlbEZGuT8ayTlnn10N7RMZZigyjgd/iaV
         cf/gZh/gQHbzjaCNjwshNtnhwxV0/8+n4zLOr1Xdaz1Fd3bAJGgr8dT4TEPRdTAq6PuY
         Lt9BsS/gOCFqaXG5MJFg/VJXz+UlEZTXBpUItsXeQSCQ5WDhkgO3XPDs3U8JKncImask
         a9AF9gTzlMNUBtUzWrNqQnjXkenbdpd09Oazv05SVp/Q+CHYAIDrY3tPJOL9d6GLmEst
         m3Kj5zwmju9SB6N2Y7T6ACVgFKnlquLPczvDSmjAxuMCIDq4D9KdP0nF+U+wkUcsDI/g
         +vOg==
X-Forwarded-Encrypted: i=1; AFNElJ92yeiUTAjkaginaASIHx96wT9ugtCk2V5No4vvftvjsMqn6v9jxGwqUpg5o4TSrTaAEIgdG1g=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywflbg33tKOtIfdVeFukreF5I14pS1o3cdq0VmhMWn/28n/ZvC9
	o/mz5W1/l2vIaeM38Cxnlhp5RxbZD8+qgxe3qnBZK7SF9eB5zAZqGtU0wPXQOKwN5g==
X-Gm-Gg: AeBDievbDTvCiX9t4VYeCPtzYdWYDjSuxgFhSPm31yEBi6KOHeRvZlN2HPk5VsUdi8E
	hXMUppG4QI9IAHHzRR2EpWIHfZgXNmc8wfhs97bmxjxELh4+5so32g5UolIQupmPDsV6UguIKAP
	WybQOHKr4L0n6ZDACoI5Qr8Nw1gJa/iNYcpgitPIhG2IinTPDUdxNmHuw6ECq2bVYxilt1wa08d
	nEcux967ryo2i4iK6q1QxObL3qdBJZWEC+P3tyruU+zzG4y06giTGp/bXuJ9mImLNr+Gyw17f0x
	y+8am57p9NthmYu0K6UYJmJqeDahC6sZ+AXqPWQNOAaDaHDqZzbq1Mqd4pIxw0y7WSkhv6S9pDS
	cW863GIvVFTxCSa/Z3+nNXGxPIe1WPjH13XX0PpT6hA+gGj1fvwT9x+w8tXL3dib9HFhvf+2tNk
	Dacn5jidYpDf1TUya6jYcMa9KV9T8PAWvIhhDDwsZUC8C+y7wsnkGaXOgL90qANaJqvOoY6HNuN
	n5lDw==
X-Received: by 2002:a05:600c:6089:b0:488:960f:60b8 with SMTP id 5b1f17b1804b1-48a9852d054mr1083545e9.6.1777897182533;
        Mon, 04 May 2026 05:19:42 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fea7de6sm78783785e9.12.2026.05.04.05.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 05:19:41 -0700 (PDT)
Date: Mon, 4 May 2026 12:19:37 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 06/25] iommu/io-pgtable-arm: Rework to use the
 iommu-pages API
Message-ID: <afiO2WL4ILGfmUui@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-7-smostafa@google.com>
 <20260501122424.GA6912@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501122424.GA6912@ziepe.ca>

On Fri, May 01, 2026 at 09:24:24AM -0300, Jason Gunthorpe wrote:
> On Fri, May 01, 2026 at 11:19:08AM +0000, Mostafa Saleh wrote:
> > To prepare for supporting io-pgtable-arm in the pKVM hypervisor,
> > we need to abstract away standard kernel allocations, frees, virt/phys
> > conversions, and DMA API mapping.
> > 
> > This patch introduces a set of generic wrappers in iommu-pages.h:
> > - iommu_alloc_data
> > - iommu_free_data
> > - iommu_virt_to_phys
> > - iommu_phys_to_virt
> > - iommu_pages_dma_map
> > - iommu_pages_dma_mapping_error
> > - iommu_pages_dma_unmap
> 
> Wah? This has nothing to do with iommu pages? This just leaking
> everything iommu pages abstracted out :(
> 
> When I said to use iommu-pages, I meant to use the existing API, not a
> completely different one.
> 
> From an iommu-pages perspective the issue is this code open codes
> dma_map_single()/etc instead of using the API surface
> iommu_pages_start_incoherent()
> 
> This is annoying to fix beacuse the external allocator messes it up,
> but I think with some #ifdef you can probably fix it up.
> 
> So.. I suggest you update it to use the iommu_pages API, #ifdef out
> the allocator so the pkvm pkvm doesn't need to deal with it. Then
> compile a special iommu-pages for the pkvm side presenting the same
> API.

I see, we still need to leave the DMA-API calls for the custom config,
as I am not sure if it can use pages not backed by the vmemmap, I
pushed that into a separate function so it’s easily compiled out.

Without this patch, now it looks like:

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 0208e5897c29..1583b9916b09 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -248,26 +248,15 @@ static dma_addr_t __arm_lpae_dma_addr(void *pages)
 	return (dma_addr_t)virt_to_phys(pages);
 }

-static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
-				    struct io_pgtable_cfg *cfg,
-				    void *cookie)
+static void *__arm_lpae_cfg_alloc(size_t size, gfp_t gfp,
+				  struct io_pgtable_cfg *cfg,
+				  void *cookie)
 {
 	struct device *dev = cfg->iommu_dev;
-	size_t alloc_size;
 	dma_addr_t dma;
 	void *pages;

-	/*
-	 * For very small starting-level translation tables the HW requires a
-	 * minimum alignment of at least 64 to cover all cases.
-	 */
-	alloc_size = max(size, 64);
-	if (cfg->alloc)
-		pages = cfg->alloc(cookie, alloc_size, gfp);
-	else
-		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
-						  alloc_size);
-
+	pages = cfg->alloc(cookie, size, gfp);
 	if (!pages)
 		return NULL;

@@ -289,26 +278,67 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 out_unmap:
 	dev_err(dev, "Cannot accommodate DMA translation for IOMMU page tables\n");
 	dma_unmap_single(dev, dma, size, DMA_TO_DEVICE);
-
 out_free:
-	if (cfg->free)
-		cfg->free(cookie, pages, size);
-	else
-		iommu_free_pages(pages);
-
+	cfg->free(cookie, pages, size);
 	return NULL;
 }

-static void __arm_lpae_free_pages(void *pages, size_t size,
-				  struct io_pgtable_cfg *cfg,
-				  void *cookie)
+static void __arm_lpae_cfg_free(void *pages, size_t size,
+				struct io_pgtable_cfg *cfg,
+				void *cookie)
 {
 	if (!cfg->coherent_walk)
 		dma_unmap_single(cfg->iommu_dev, __arm_lpae_dma_addr(pages),
 				 size, DMA_TO_DEVICE);

-	if (cfg->free)
-		cfg->free(cookie, pages, size);
+	cfg->free(cookie, pages, size);
+}
+
+static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
+				    struct io_pgtable_cfg *cfg,
+				    void *cookie)
+{
+	struct device *dev = cfg->iommu_dev;
+	size_t alloc_size;
+	void *pages;
+
+	/*
+	 * For very small starting-level translation tables the HW requires a
+	 * minimum alignment of at least 64 to cover all cases.
+	 */
+	alloc_size = max(size, 64);
+	if (cfg->alloc)
+		return __arm_lpae_cfg_alloc(alloc_size, gfp, cfg, cookie);
+
+	pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp, alloc_size);
+	if (!pages)
+		return NULL;
+
+	if (!cfg->coherent_walk) {
+		int ret = iommu_pages_start_incoherent(pages, dev);
+
+		if (ret) {
+			if (ret == -EOPNOTSUPP)
+				dev_err(dev, "Cannot accommodate DMA translation for IOMMU page tables\n");
+			iommu_free_pages(pages);
+			return NULL;
+		}
+	}
+
+	return pages;
+}
+
+static void __arm_lpae_free_pages(void *pages, size_t size,
+				  struct io_pgtable_cfg *cfg,
+				  void *cookie)
+{
+	if (cfg->free) {
+		__arm_lpae_cfg_free(pages, size, cfg, cookie);
+		return;
+	}
+
+	if (!cfg->coherent_walk)
+		iommu_pages_free_incoherent(pages, cfg->iommu_dev);
 	else
 		iommu_free_pages(pages);
 }


Thanks,
Mostafa

> 
> You should have a pkvm shim header that provides
> kmalloc/kfree/virt_to_phys in the normal way and just #include that in
> io-pgtable when doing a pkvm build instead of hacking up all the code.

Ok, I can do that in another change, but I believe it's better to
change the usage in this file to arm_lpae_*(virt_to_phys...) so it's
clear which parts are intended for that.

Thanks,
Mostafa

> 
> Jason
