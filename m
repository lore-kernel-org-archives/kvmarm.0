Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794828523;
	b=XS1uHyMWtLMu1SjA1RGSp5Gq6gAb+b3EdTSm18tbXSOJpSgcRHCr1MyqYxzh2bZxwPhS
	 1ev5qaGAkyl5rf180fP1W8o04nbNrkxnCV1Z4N0tc+cRdkmr5dJohYUgefDj7DV8yluI+
	 H1wf7G09ZzVw+RRzSEfxG8Gh9L72p6Gwr0VS7JEWsp7PzN7hGiShyJkzQ0CK5zw8XQkwr
	 ANou4jy0s+3Ix23f0WGSBsBmkLc6FmayY2bLyTFxRJgUiS19EMYGF1pxlvWCEiJEiVrrQ
	 VMQWO63lI8EUmc0PAv3PeT3vKZfuDC+s9JUB9dJ38UIV8u1QfdVlU38pOsUaGiZzwNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=g73PX0PTBDOigD/y1VmqsLoo3oXmbxRQK+YkYSvt5eM=;
	b=SGvP/pg0RL4FDcqfgdwmureuWJFLz5Od2rcQpDI7YLnm2PGSMgD4jvMqect8dGRYAh7A
	 esHR7qSG32/lHCFez8N+VkaBeh+OJgCRfuP/1cfbjDhZNaI6vyimvFkeQD0Q2w9e+/lOl
	 qiW8eZ2TOAan2s8YlsfpfuF4R1LZz8QEjp+S8lT64dcIyzWtVLyUcdl2eiwoMW9HOdr9+
	 KVxSKKuYRMiVHscZSn+E39V/n/tBQcmUtY/jVlUzRIma4TwxnLI/adCdy9mMIIJmHDsBh
	 rMTdIm5rq7n2Yh9zrsBYBwDo6u2u6QMzb7wquSeq0jVOrwUVZf3rQ2DBORoKOOw41eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UAobX7Mt;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2831606A885
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 11:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2831606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UAobX7Mt
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso10963275e9.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 03:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794828521; x=1795433321; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g73PX0PTBDOigD/y1VmqsLoo3oXmbxRQK+YkYSvt5eM=;
        b=UAobX7MtLBSWJNQSWfJHrPtw/vEAtb/4yRpGMnIlET89ui6wuKNG34K8AYAzLR5umj
         VJs/xLIg+xDw6fsgLP1i4xofg88c4rP2qTQzLhabCiXIy9/M/bTI07XDb1LM9uriFJ1z
         6XOm2+EhXFbpXGUAZbTOoBE/65kIF2xa0fM121JG1SbERd+ggif9S0T7C/0G6hJE3eWw
         7gZf3DWJAcLncAEXWdKxbEo7PMZZakTFv+44Y/v18nMWNSJ9FCBOoDP6yfTNF/FKWe7U
         zd11YNYi8fipe0r1ZHo/vRS1lfvcHKi0m5FyI5t10GzN1tWe6Irh2XU2PNezpNfnNnE3
         O2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794828521; x=1795433321;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g73PX0PTBDOigD/y1VmqsLoo3oXmbxRQK+YkYSvt5eM=;
        b=OT3RtchdgVomJAT7MZDnf8cpZ2BTr03fACnbGH9H+G5pXfZh9ULXDhE2D891n7k6wt
         AlrMo94kyf/1hinN04cmDR/6FjlGfZZ9ZAdmNuHg0TirQGv6odKpVtNip42n1H8/U4Sc
         pXpVvbnFcEFBCGl7hwCLxVZUDSwUakrkBXt1etW5GUD4E2Pkb/NG4sigdJHfRmi1Um3x
         /JYF2sdYtHZhMpibQ4wVSOmOyEMHtqzNbXo1FGimWQvHefwJQh2QdWk5At7O8zqbF/HJ
         rrSlRvXeXYxVpdmBihEtXRp/xk/eHkOSqnmp1dVpydL6ZdfLscOcXAQmYiPdwhn/hWk9
         eQqA==
X-Forwarded-Encrypted: i=1; AL+hErHU9U6yo2yQOd+E2ajeWloBgd9mTsnOVspvAr42UuVgEBE8RzQvopgLtVfo4sv85gWscQRfABc=@lists.linux.dev
X-Gm-Message-State: APuU4Z+Ix4SiCcaxbsXA3U4eSjw2534GO1gUTnI8yJxBKBYHhTss4X4q
	h0X/8lv/H6XmPP7i9F9TZcjBM8HMGwO23BlrpR1ddYi/v/hfEaIALXufE+D2/R/c3A==
X-Gm-Gg: AYBFou1VRUW6b9WcqhvQIoXs2aQOIDWDAlwhioo7FgS/RBK+mbh6s6gPdh/47ofSNKf
	ukeCXHV8goF6Jzd8xMQffY+OoJ53rXP20boE/ObbjxZGcNts7JA+oKYjFPW1FSLkOURnO2QS/rV
	XY5wMZpkYS07vVD2hTRNSeu39zM5ncesPnSOsuzRcP390maPVH7babzZS7S3NSKNkY3iN3DqT3U
	CSh6VlXstkivQE4o5Mby7k2ZrhBqj14+qMdTt+4P3FAsBMby2X6cDBr9JfyIfI84fhwVUixBRX5
	aKVIdhv15LAY7iEab2yg5+d9IKUIbJKaN0ZnqSfJOKvcdMjt2ChaYUUj2CwT/JPI1hK5wtj8dFt
	DD9r7mjc8VGmD3a2QgLkVbaKLYQCP+/suvq6e9V/UrtnXwp8bmzbVjxeq0DNnoxX7BYq3eY6znJ
	mYqGmv0TNMUCP98B3bW96lueXgogG0IIzC4uzkPYLzCGpXLmfhaCAt1SZuppoLjXgwmBcogpQ7n
	8sAjPpU306Ga2aNL4R5cmny+gTPrJoeSbB5zF9+CMgtLs9JPlFPt1on9xLGIdBnGdyRkX8Q/LsM
	9skCihkb87SQ/B1f/j+TVVVGw5bfBzTLOHggLZgUocqXWw5V+gQSyJIrhr4IFLAsDA==
X-Received: by 2002:a05:600c:5903:b0:4bb:60b3:7ea9 with SMTP id 5b1f17b1804b1-4bb60b38023mr126053495e9.0.1794828520786;
        Mon, 16 Nov 2026 03:28:40 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c604ee47dsm21324022f8f.38.2026.11.16.03.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:28:39 -0800 (PST)
Date: Mon, 16 Nov 2026 11:28:35 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drivers/virt: pkvm: Zero and clean memory before sharing
 it with the host
Message-ID: <avro44jUWOARFzul@google.com>
References: <20261116110549.1863653-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116110549.1863653-1-fuad.tabba@linux.dev>

On Mon, Nov 16, 2026 at 11:05:49AM +0000, Fuad Tabba wrote:
> From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
> 
> On pKVM, set_memory_decrypted() shares pages with the host in place and
> without cache maintenance. The atomic pool, dma-direct and dynamic
> SWIOTLB pools zero their memory only after sharing it, so unless the
> page allocator has zeroed it, the host can read whatever the guest last
> left in it. Zeroing first isn't enough on its own, as the zeroes may not
> have been written back to memory, and a host that maps the pages
> Non-cacheable then reads the old contents.
> 
> Zero the range and clean it to the PoC before sharing it, so that no
> caller can hand the host stale data.
> 
> Fixes: ebc59b120c588 ("drivers/virt: pkvm: Hook up mem_encrypt API using pKVM hypercalls")
> Fixes: e62decaf98e7c ("arm64/coco: Add pKVM as a CC platform")
> Link: https://lore.kernel.org/r/20261116091137.94252-3-aneesh.kumar@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> [fuad: take the pKVM hunk of v10 patch 2 as a standalone fix, add the clean to the PoC]
> Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> 
> Notes:
>     This is the pKVM hunk of patch 2 of Aneesh's v10 [1] plus a clean to
>     the PoC, taken on its own because it fixes a bug that has exposed
>     guest memory to the host since v6.12.
>     
>     Based on Linux 7.4-rc3 (aebb727447640).
>     
>     [1] https://lore.kernel.org/r/20261116091137.94252-3-aneesh.kumar@kernel.org
> 
>  drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
> index 26fe9c3f22e36..81d1cd24a2eff 100644
> --- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
> +++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
> @@ -9,10 +9,12 @@
>  
>  #include <linux/arm-smccc.h>
>  #include <linux/array_size.h>
> +#include <linux/cacheflush.h>
>  #include <linux/io.h>
>  #include <linux/mem_encrypt.h>
>  #include <linux/mm.h>
>  #include <linux/pgtable.h>
> +#include <linux/string.h>
>  
>  #include <asm/hypervisor.h>
>  
> @@ -61,6 +63,15 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
>  
>  static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
>  {
> +	size_t size = numpages * PAGE_SIZE;
> +
> +	/*
> +	 * The host can read the pages as soon as they are shared, possibly
> +	 * through a Non-cacheable mapping. No caller relies on their contents.
> +	 */
> +	memset((void *)addr, 0, size);

Are we sure we want that? The guest may want to setup memory and then share it.
I am not sure about modifying this API. 

> +	dcache_clean_poc(addr, addr + size);

I believe the hypervisor is already doing the cache maintainance when the page
is mapped back into the host. (see stage2_map_walker_try_leaf())

-- 
Vincent

> +
>  	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
>  				  addr, numpages);
>  }
> 
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
> -- 
> 2.47.3
> 
