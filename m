Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0F014EC42
	for <kvmarm@lists.linux.dev>; Fri, 12 Apr 2024 18:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712947542; cv=none; b=je/uhCsQB9O92z3+xMAI+9lzIsVcd2UIhw0/okywdBXHnWJGE3PuWQe22e7tuCCMpWq2ubXMtzxEQoepgE2HZzOIN2vay0Mjz/Izsj5veCElqPiNXKDDDVEjROtpA2BTvIFbsIBLO2UijCbwCaaSoO1SMfw9cStTxP5uft8+YxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712947542; c=relaxed/simple;
	bh=Mxmh9m8cG1SINwjvCiVceMBEadI/CDBdioZFxVCsP84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oe435J8hsXYn96V+lewhTUv+lXPdp7bEXRRt35wuFOEEnn/jm7/lD8l0upSekNaMFLwy4X43CHrNqfK4zQwh0mjZII+4veXtk8SAf+AqKqlbVEX0rUTDCfWzGAcWgeeE3rBjh9OgVkHLPrrWuf+MdAc7cT2BeRZ0wMcXgV5q0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hzEPjdZo; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hzEPjdZo"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2a68a2b3747so817053a91.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Apr 2024 11:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712947539; x=1713552339; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ISLMFGOGyzbAhcth9c+vgcaA14m4ctbEbkD9TmYI1+8=;
        b=hzEPjdZo0PIfkt0NQIo8XoxaQCHuTKD8j23vQ08guxDdpiDGLJL6VyEykT7N/5rR7j
         4TzeZ4Nj1HSYKww0HtLoaetjx9rRd43tHGzeXvPwsLs+YEVrJHzBPfivXaKVV+0u3CTk
         fDfB7SIrUL8aSAsIQBxxZMwwcDdOzqjz04nleBsu/F98jPCu4BLywA9MKy8pIiUuswuP
         1ET+QRoiDrIVqdGe3DlXRbvMJPS9SHJia+dIvlCzjhmjhuPWzFek7E98B0sGLiEB2+Dw
         wxNGb7yZ1LBhL3s6OcjTdphbXhnVco0/XVStVrjklnalNq2RvBko4ICVmCTCuFFnb2uu
         9tsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712947539; x=1713552339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ISLMFGOGyzbAhcth9c+vgcaA14m4ctbEbkD9TmYI1+8=;
        b=vr/reUmkgLPCdnXm1etl0jKoicWyP0oPBhL6HMohx67OwiB3qOQ/mqgThyu8qjxNmm
         oStwwXU07KG7nDM2O2JJblhLQDUL0s3VZlOrYr8vDbxHXsvemH+oEjH+q/mPet2CbBM0
         sahwsH40D6B6KB4QfbfcWaGXfCX73z7n98gMjIOkQJtY5CppIPBNekLNZbkHOkhd+om8
         7cT4SmfDUFmc/KPiAhjU/mV6ar2O2hrWj03lzNdp759t8LkfwIf7fLTJayb1j57vrorn
         WAHN+tWtzCpi6vOwWLKwlJP0DzUxMeI/rFmUrxHjes8F9FkQT5vUMINX+fwY9RqWzsDS
         jquw==
X-Forwarded-Encrypted: i=1; AJvYcCV5DKmJlq6Ym29TLE/86CAjxHCibQtVDBk5vqrqg4jbTX8o02hTVl+nVQIgsaFWPD81JnpZ8bZX0CabaCsOtvKGlgVwmM01
X-Gm-Message-State: AOJu0Yz/doTTr80eKmPMqhU43pPB01S563ZGYmbztGD9liMfdxDuUJg2
	PgOYSmrDjhN6V6/2WuoiLq4oQMEzgk5UO02mo94t4Y7XFZTa5pZVFxoDY/ZbJA==
X-Google-Smtp-Source: AGHT+IErdx6N/Za0LUKOOdr+VzWwjNC6bZuRp56Svh5aVZ0iXA0UlC0kIs2SDcy0//cfbrlbvHooqg==
X-Received: by 2002:a17:90a:9af:b0:2a5:3e4e:29a0 with SMTP id 44-20020a17090a09af00b002a53e4e29a0mr3344779pjo.6.1712947538843;
        Fri, 12 Apr 2024 11:45:38 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id i20-20020a632214000000b005cd835182c5sm3009589pgi.79.2024.04.12.11.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 11:45:38 -0700 (PDT)
Date: Fri, 12 Apr 2024 11:45:33 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] mm: Add a bitmap into
 mmu_notifier_{clear,test}_young
Message-ID: <ZhmBTUIhypg-Kxbx@google.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401232946.1837665-2-jthoughton@google.com>

On 2024-04-01 11:29 PM, James Houghton wrote:
> The bitmap is provided for secondary MMUs to use if they support it. For
> test_young(), after it returns, the bitmap represents the pages that
> were young in the interval [start, end). For clear_young, it represents
> the pages that we wish the secondary MMU to clear the accessed/young bit
> for.
> 
> If a bitmap is not provided, the mmu_notifier_{test,clear}_young() API
> should be unchanged except that if young PTEs are found and the
> architecture supports passing in a bitmap, instead of returning 1,
> MMU_NOTIFIER_YOUNG_FAST is returned.
> 
> This allows MGLRU's look-around logic to work faster, resulting in a 4%
> improvement in real workloads[1]. Also introduce MMU_NOTIFIER_YOUNG_FAST
> to indicate to main mm that doing look-around is likely to be
> beneficial.
> 
> If the secondary MMU doesn't support the bitmap, it must return
> an int that contains MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.
> 
> [1]: https://lore.kernel.org/all/20230609005935.42390-1-yuzhao@google.com/
> 
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  include/linux/mmu_notifier.h | 93 +++++++++++++++++++++++++++++++++---
>  include/trace/events/kvm.h   | 13 +++--
>  mm/mmu_notifier.c            | 20 +++++---
>  virt/kvm/kvm_main.c          | 19 ++++++--
>  4 files changed, 123 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index f349e08a9dfe..daaa9db625d3 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -61,6 +61,10 @@ enum mmu_notifier_event {
>  
>  #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
>  
> +#define MMU_NOTIFIER_YOUNG			(1 << 0)
> +#define MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE	(1 << 1)

MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE appears to be unused by all callers
of test/clear_young(). I would vote to remove it.

> +#define MMU_NOTIFIER_YOUNG_FAST			(1 << 2)

Instead of MMU_NOTIFIER_YOUNG_FAST, how about
MMU_NOTIFIER_YOUNG_LOOK_AROUND? i.e. The secondary MMU is returning
saying it recommends doing a look-around and passing in a bitmap?

That would avoid the whole "what does FAST really mean" confusion.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fb49c2a60200..ca4b1ef9dfc2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -917,10 +917,15 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
>  static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
>  					struct mm_struct *mm,
>  					unsigned long start,
> -					unsigned long end)
> +					unsigned long end,
> +					unsigned long *bitmap)
>  {
>  	trace_kvm_age_hva(start, end);
>  
> +	/* We don't support bitmaps. Don't test or clear anything. */
> +	if (bitmap)
> +		return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;

Wouldn't it be a bug to get a bitmap here? The main MM is only suppost
to pass in a bitmap if the secondary MMU returns
MMU_NOTIFIER_YOUNG_FAST, which KVM does not do at this point.

Put another way, this check seems unneccessary.

> +
>  	/*
>  	 * Even though we do not flush TLB, this will still adversely
>  	 * affect performance on pre-Haswell Intel EPT, where there is
> @@ -939,11 +944,17 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
>  
>  static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
>  				       struct mm_struct *mm,
> -				       unsigned long address)
> +				       unsigned long start,
> +				       unsigned long end,
> +				       unsigned long *bitmap)
>  {
> -	trace_kvm_test_age_hva(address);
> +	trace_kvm_test_age_hva(start, end);
> +
> +	/* We don't support bitmaps. Don't test or clear anything. */
> +	if (bitmap)
> +		return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;

Same thing here.
