Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F813C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 18:47:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8998E64E92
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 18:47:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8998E64E92
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051C74B2C3;
	Fri, 19 Feb 2021 13:47:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zDwUccAyPFEz; Fri, 19 Feb 2021 13:47:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C21F74B31E;
	Fri, 19 Feb 2021 13:47:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5924B1C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 13:33:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PaU-i9ufWojp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 13:33:07 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBDA34B1BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 13:33:07 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id cl8so4189727pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 10:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=apaYLCgpKww0D9oOCdL1/leTpd02z3P4w+UfyB0qUtE=;
 b=cNzmU6RwCi2M7zc1iN6kXALpuF4Dr3p9TUe2IZrVSxDRNZxj43w4OZN9GBVNUyVoGY
 H1RXDjVYIy/K8yNu7pM4zNUC+X8IPbISNDZkI7CMRH6NW31SInd7dD92i1llEAJIpNl9
 iWbI8rgOSf7uQmj0SebJ6NcX/Ooy0yvSHYo1XyOoSpU19UIDftAZr4ACUicBtUMeLzOs
 JxUyV+lfMm+gr31mLh9yWgpO+USuw7r8q/XR26xRmrLSWdm95R71UclAbHcjdoD9mUVg
 /RXbSkNXY3aLx0dVZoac6BkHs3HET/aQxjW2WzpvO3e5JjAUaXvXTBmMVyOyA+7Xdb05
 6Cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=apaYLCgpKww0D9oOCdL1/leTpd02z3P4w+UfyB0qUtE=;
 b=iGBWALMBGq9HTgMkqAsp0GAP012eY9jFb0oIJd6N3MZ3zYSRimSJDEPiIfwoZQgjl6
 D2LKIXLYJKe3COx2gNRDjMDyU/ak4TtnWFwISkdoNzy+myXYlUpKcxTftwkgDdrttzc6
 21zNNhZTBqn7dvwiNvIGznxnaGSSSnzUSMlbRTdtRWLuSz2tYPhNZaKDDOlOu/uciHdt
 5TSnxGc+NJL57aQiFU9qrmw8NVpiUlmTMWz77d5qYKWNcMlor3lYZYDmIFfiJoaPUf4i
 7tSiRFOtIwUu7zhGXa6HJ1m6IRa3Ry4mFkK9iG90JmtwzPYPMiAZaWSodPoVN0+DATjf
 SOHA==
X-Gm-Message-State: AOAM5312CZBkZ0DFxE1iJXr1/wa9tsiQGK/w3lFRenjqfD7SbPiQHCwY
 cb8X8LXUML9fzITN9+cVebrMUw==
X-Google-Smtp-Source: ABdhPJzGsluCsG7fkC2FvoTQGUbPeiWB8QuireUSeDuRRKhKexRWjsorjPjofN2X3s0CAIhvLZ+5ZQ==
X-Received: by 2002:a17:902:9894:b029:e3:7aa3:a499 with SMTP id
 s20-20020a1709029894b02900e37aa3a499mr3088340plp.11.1613759586653; 
 Fri, 19 Feb 2021 10:33:06 -0800 (PST)
Received: from google.com ([2620:15c:f:10:fc4d:e9c3:d7d:9cb3])
 by smtp.gmail.com with ESMTPSA id 3sm9467713pjk.26.2021.02.19.10.33.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Feb 2021 10:33:06 -0800 (PST)
Date: Fri, 19 Feb 2021 10:32:58 -0800
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 16/26] KVM: arm64: Prepare Hyp memory protection
Message-ID: <YDAEWu7RkG1OBFed@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-17-qperret@google.com>
 <20210203143709.GA18907@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203143709.GA18907@willie-the-truck>
X-Mailman-Approved-At: Fri, 19 Feb 2021 13:47:17 -0500
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Feb 03, 2021, Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:14PM +0000, Quentin Perret wrote:

...

> > +static inline unsigned long hyp_s1_pgtable_size(void)
> > +{

...

> > +		res += nr_pages << PAGE_SHIFT;
> > +	}
> > +
> > +	/* Allow 1 GiB for private mappings */
> > +	nr_pages = (1 << 30) >> PAGE_SHIFT;
> 
> SZ_1G >> PAGE_SHIFT

Where does the 1gb magic number come from?  IIUC, this is calculating the number
of pages needed for the hypervisor's Stage-1 page tables.  The amount of memory
needed for those page tables should be easily calculated, and assuming huge
pages can be used, should be far less the 1gb.
 
> > +	nr_pages = __hyp_pgtable_max_pages(nr_pages);
> > +	res += nr_pages << PAGE_SHIFT;
> > +
> > +	return res;

...

> > +void __init kvm_hyp_reserve(void)
> > +{
> > +	u64 nr_pages, prev;
> > +
> > +	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
> > +		return;
> > +
> > +	if (kvm_get_mode() != KVM_MODE_PROTECTED)
> > +		return;
> > +
> > +	if (kvm_nvhe_sym(hyp_memblock_nr) < 0) {
> > +		kvm_err("Failed to register hyp memblocks\n");
> > +		return;
> > +	}
> > +
> > +	sort_memblock_regions();
> > +
> > +	/*
> > +	 * We don't know the number of possible CPUs yet, so allocate for the
> > +	 * worst case.
> > +	 */
> > +	hyp_mem_size += NR_CPUS << PAGE_SHIFT;

Is this for per-cpu stack?

If so, what guarantees a single page is sufficient?  Mostly a curiosity question,
since it looks like this is an existing assumption by init_hyp_mode().  Shouldn't
the required stack size be defined in bytes and converted to pages, or is there a
guarantee that 64kb pages will be used?

> There was a recent patch bumping NR_CPUs to 512, so this would be 32MB
> with 64k pages. Is it possible to return memory to the host later on once
> we have a better handle on the number of CPUs in the system?

Does kvm_hyp_reserve() really need to be called during bootmem_init()?  What
prevents doing the reservation during init_hyp_mode()?  If the problem is that
pKVM needs a single contiguous chunk of memory, then it might be worth solving
_that_ problem, e.g. letting the host donate memory in N-byte chunks instead of
requiring a single huge blob of memory.
 
> > +	hyp_mem_size += hyp_s1_pgtable_size();
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
