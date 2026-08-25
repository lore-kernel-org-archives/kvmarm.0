Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF3385D7A
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 07:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787641596; cv=none; b=ulo3cTjrASyw9vGo58of3ne51RI0H5dgFqrjG4xM3jgaFXl4QhnIOWPmRFS71UpD8ARwilHa1sXk7hCP52k933wNH/bI1mt+pikCXO0HCggpY4tEIJu5Y4CrQgYGHHf/O6LjlqzL/870Aj0QIJn8AcYdrHEcRIQBO5UJtvNgtgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787641596; c=relaxed/simple;
	bh=Q/8gSOHAJgd2SRYbzG1DwwWvl7MRYBB6FR/wRRWch5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utKiwfyLzKEYUvqtWYWQT+MjMKnLznXcWEudH0z0yRIyu9+D2+E3MmjgHXJcqcHTNOunf/olVM38bQP1bcdH58EbcfJE1Q3OuVFLa7IKVSvol6Rxk3m+mpARChWStH7tXlqv0KHP+LFdBbhuHH3m0BoRFrVq1FnJQ0b+4dFM7Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3ELGRVo; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3ELGRVo"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a378f90555so6850225a12.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 00:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787641593; x=1788246393; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s3xyRM/wAlBwrs4J1zBbo6tL/K6FbpaVSr4RYy/4QHY=;
        b=N3ELGRVoQWVOlkaJPNCMTJ2MHzaaAPBDOPFkfGJMCnVHbKn9Zoe+s7kFeIhA08X29p
         yRqy82etE+UYsckW4scdil1dGkOkp1rKEErLrIJuv1d8Aq6+mwgTkF3/FGB3L/qJVKMb
         xbeYpcdp972OXX8gLJVH5mAOWy0EZvblM0CsoOfmgbIrHOekWvrUY8hpzYG0SWKykTUL
         j8HulSTwLEK7zmWVmt37Ri5yGdIxXjXdPkcK8n1L32CdC+KQzj5zJDeazpvsvmFnOvDt
         m14kxtjbrakAdioy3bZdoRTvZfHIaUCmdtmCH4icSl7qzwH94X/j5sEoRzvckMtX//Ls
         8gIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787641593; x=1788246393;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s3xyRM/wAlBwrs4J1zBbo6tL/K6FbpaVSr4RYy/4QHY=;
        b=hOciu3/MWrMVZYmOc/DtN7Y1iXsHu+ER2R75C0kc3b7LgDxiJOAIsfh45hMnQyEohG
         R71Y/mYp3PmA99X2gXzSaFyo93FHSz3FadINAuDIfRY9UAiqxufRQxZ9p5Bmmne+k/Y1
         vwKuKlbxR3LkRLLzvlBJ4UK+7dnnGMiMTCGZb2uoeqgvR2kcFXLTSpQONjtgobSsoJ4T
         2d9FDH0eoKrqYZ+E5oCqMf3BYlRq3AdL8cWZxLcmEH7u50nbtJuv20yNp9Qw6UVnFeck
         B3B8btTlj4ZeJNpRCEmSxkiO89mSFLe69+Ld9fJusXAMO+3yxTfeA4c6j3ud0HZBdvff
         31cg==
X-Forwarded-Encrypted: i=1; AHgh+Rqsns/r6kZAcmNxdrlaU3iquQEcoEoVVqUzI23MebrM84FgD5Emz3OhO5pkTFuGIMApuBrKHBY=@lists.linux.dev
X-Gm-Message-State: AFuF++kHms/lIUsLslokyE2plS1qkAVgL/0dUUhwKAdK1+tcy/Y2gyMF
	VFVj2vZhQvBlTzb193YHveu1ETf6PB3YZLLTlussAGKBnn0vpNuiRVuT
X-Gm-Gg: AR+sD131Vge9k9UYf4RLXKJH8yaycoucF0qVFdb5iTr/ONUl5mzUE2CaF4iJtKgoiEp
	w5wbknalZ7/LDiA7NIE6QYo1wcUUqfCIH+kmClhOlyP+TzgW8He6fr/f6JGTviKq4qrcVDzXaSE
	eOx+SR+d5Eo/+TM0skTEVyEqD6dzab6k/jZRPV+49LbEl5y7m4GYR8zQVHshvBOUKKACIoRR4hx
	Hb2v6WxP4+AVaZFE/5EaBb68Dpar1KN0nSNUcMOm6B9z14Eca5CXjD9aiIA9bme4D3srnc3aeyo
	h9/d4Hhhr5KbrrE4503G0JN8V0TNUWCrUIEYTDyHqoi8IKRcAIyCxMhxGGkAPV+N8Ir0T/mj8mi
	M8149nccwQiIGGuSZI+LbxCnVWMSED1iKPSTDz+Ml6l2NsVFf2iTM3WLOhX8vJZJcdRrv0tmK54
	pAbKEtGWdpg7bDGDxfvin+perPBv4F9MmRoVZjMbsTEZTDCDK+bBnMLgIOM4xQgRoVE9enhHQI3
	vH7NGGSZNbWVd+K1tR23NcY3eBtUJ0DTC8nrgN4EVBeO2QgpcdvVn3Fa8yq/i4QNOPfijDcfEbz
	rbq147m21cnoDvMHDPQPYcf13DQhRgLGcPY=
X-Received: by 2002:a17:906:a353:10b0:c1c:5c90:1bb0 with SMTP id a640c23a62f3a-c246a353d2emr2513381166b.8.1787641592969;
        Tue, 25 Aug 2026 00:06:32 -0700 (PDT)
Received: from franzs-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch. [83.173.201.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2496295627sm1565087966b.15.2026.08.25.00.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 00:06:32 -0700 (PDT)
Date: Tue, 25 Aug 2026 09:06:31 +0200
From: Franz Schnyder <fra.schnyder@gmail.com>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, "Ivan T. Ivanov" <iivanov@suse.de>, 
	Francesco Dolcini <francesco@dolcini.it>, Frank Li <frank.li@nxp.com>, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, imx@lists.linux.dev, Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <f5nfbi2lmc73wtxxmzs4damrjtd67p4eb4p2zy5ssqrc3wohne@cjcxqua5dps6>
References: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>

On Mon, Aug 24, 2026 at 12:02:04PM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
> suffers from a cache coherency issue (ERR050104). The upper bits, above
> bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
> have been incorrectly connected. This causes some TLBI and IC
> maintenance operations exchanged between the A53 and A72 core clusters
> to be corrupted.
> 
> The workaround requires:
> 
>   - Downgrading targeted TLBI operations to broadcast-all variants.
>     Instead of patching the low-level __TLBI_1 macro (which interferes
>     with the REPEAT_TLBI workaround and causes excessive over-
>     invalidation), redirect high-level TLB flush functions
>     (flush_tlb_mm, __do_flush_tlb_range, flush_tlb_kernel_range,
>     __flush_tlb_kernel_pgtable) to use VMALLE1IS via static key checks.
> 
>   - Upgrading IC IVAU to IC IALLUIS for both kernel (via ALTERNATIVE in
>     invalidate_icache_by_line) and EL0 userspace (via trap-and-upgrade
>     in user_cache_maint_handler with SCTLR_EL1.UCI=0).
> 
>   - Disabling KVM since correct TLB maintenance cannot be guaranteed
>     for guests.
> 
>   - No need to touch SMMU Broadcast TLB Maintenance (BTM) since i.MX8QM
>     does not support broadcast TLB.
> 
> SoC detection uses devicetree compatible string "fsl,imx8qm" or
> "fsl,imx8qp" since the boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0)
> are not unique to this SoC.
> 
> [1] https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf

Hi Peng,

I tested this on our HW and the random crashes that occured when both
the A72 and A53 clusters were enabled no longer happen.

Tested-by: Franz Schnyder <franz.schnyder@toradex.com> # Toradex Apalis iMX8QM

Thanks

Franz
