Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973777;
	b=sODKXiSlfZZcBmWuExsrf7+GYQecFqlkpmdFjAeKazAosnGz7NVxFyR2/vRhHFLyoIvt
	 ihoTNVpFKLDvXV8opkQVfls2dB/rrgYwrODWAqI7tTXIu+6bz5Ce/ObI6cuTNteHZOBtd
	 mOdeJA4nOa4IEORLE79Kr/GmDy137WtV8L9K0kCYWqUY372DKGdgXC4QfNHiNJLpArbk0
	 Z8eBKeq1oC5iXDV3gNm367xSc4ii8P5PJa4Uyk6nGA+rSpx0hGN+VUN86gYhE1V8HpWdp
	 Q2dDJ0/Hr+5y5ubYnX7dxNGlWjnLsc9GFHgF5x5IsCf+6hCt9vsj9V/QmsZJcvINeUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=mEgL0gkNdxC67fiPUJ6BbKjfka4sqNTfVjccvIe0kTw=;
	b=g9bhyLw6hCWanS7xl3MtSINI4sinbj8iZYEC6TsOmIiZaFwPl+hwZQdtOBdApQ8B30Er
	 ek86m8QKB6j4bH58KUHvnuyK6a3O+CWjio65uFtbffrtg/tH6SSS2wJ4DIyESlTjof19E
	 ccCLQ+Wcae/cJnFupOj/a23nIT+6mTPo10PvssmD+FZx2SyB+c5A0FFh3PXonB65V2t3k
	 gNCwNV/jicUeJZJR/40Yg0V0wPX8vBBGI6nca3K7cHP2WTJcBe96vYzrrWl8Hc12QInOX
	 j0s2mf+jiPvHscG+BJdFw0/HFvjkcs37xX4xj5Gg+Jw2SUuGNNGCYYOHj/Yj2jXatVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gc8RW9Oy;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD95606A32E
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 14:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BD95606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gc8RW9Oy
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso34865e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 06:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793973776; x=1794578576; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mEgL0gkNdxC67fiPUJ6BbKjfka4sqNTfVjccvIe0kTw=;
        b=Gc8RW9OyajQuiTOWBh3NACtrzH46A0ZJlkjoJ+kPYkrjWY7zZvjz1qzff3y3dX0udg
         JjF1zhuTCJOpg1KB4r3/Fg1oRGDu3MZRlXfn/ENgjALnhvFLpJkD4oyZ5P0wCgJkmanb
         5YrksqZr9BKJo98VylwvxugsHrnHvSihsj5+SIwYeRh8VTDEjZztG15SE3fKubf9adAd
         P6FxVqhwb9DN74n3Ku1bs/+PvrOzyEQx03fPlRTjFvpraVq0lXlYu7m9P37/nTYv5ev/
         Hb9aQGdgx72KTb1Py9HL9UTpwcvACU3pYutaTFMai8qCa3lAJXB9tcJ1XfMKYhBACPR2
         iYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793973776; x=1794578576;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mEgL0gkNdxC67fiPUJ6BbKjfka4sqNTfVjccvIe0kTw=;
        b=DQi9wCwoCgvJhQFkaIMTlGEl3xSzkDme9hityIG7LuVMFW1ulAq27CFQ4aIvK3j02Q
         G7Lobl6M759e4P3jG2Z4fG8qdDakjQt7L4dfCA00WU2pBorCASwW8tn//zsCXfgyycF/
         CzEJ1BbCBPanFv+Hc1jNjboxzEwgonF8PjZP1RjqgPH1VroHD/GL+lzLDekmyPHZHgUk
         dqzLhqWeXXcIRXbLF3Lge+kjc9t1mYs2G2MKRuMATGgLzgaC1n1taEF9abyCA9NiI5G2
         NPw0zSJKSr0/2UsYst4JQiKk5JTrL5JFAgdjZKhED56DhKggFw+jWKva2oszInlM4eI6
         dTSQ==
X-Forwarded-Encrypted: i=1; AKwUvBydMuOitBIEFQfOW3KB+XYIFDxyqqhQmyNDnzpa8C42E0mUVtOHNl5Qj5+m9O12u4LXY9xHQZM=@lists.linux.dev
X-Gm-Message-State: APuU4Z8+rPDC3OYDzMWjTSQMiSCBBJ+nTDe7ync1YhT1Q21v5ZWqa7Qf
	dOE1BoCTm7FO8AYfr13NrRL3MaFSXRNL9ON6qktcxLKVfbcgYWg3Ojj2VlMouFEmrw==
X-Gm-Gg: AYBFou1m0DsFjYICVUblH91CVJrb1MTdXsbADNpeAMY74eh1Tb7/7WNJsPcOovdoBtU
	vHtZ59g+U6mFn3Ctw3qkwS1lyzQUX5GfnJqKPC9wL/zuQkRMzQzMmc1siFYDS9UHmhKfai3cACR
	OuW3Xdl+NcNneNOntfy/IUC47ZiOc1qD9//NQB7kzMvlWqUQgv+FfMevM0pAS37yyw/xh5P+Y9P
	LHBs2X8FRXG1LE1u6K8HDI8sgIOOqBKKLA4zSEAegFPbBya0YWFcGpujL6wQHAKszdD1dRcR9rw
	d0s7UlByLzbWIqceYf2uJ8P+RmZ6bKf/b5qvKc5IAPfY2sylOsltAvu/G+VXeAiIeOUca/vHvkK
	SX4IepbQLQLTQtO5EeBte0XwbFoK/oJwkFLfJEl27IEUijnhabxGqnUQKmsuqrNheyoiTGCU7mg
	zoZZSe/miXhVDQTKzd+6No74qr9s3fY2XDGlsvuuLIPKHxDGbhlb+3Am4qsjqv+Mt94PgzQSJut
	OlKAfjYq3c3ajmSr4TUsPf+ZOzOGv0P/V2huJ1fNGZUx4yfI3QrAUtIy8tw7xPLxF1AswhGVBn2
	unM906odBcnqzHFEZZPM05CZLbZVz4dxtPeD0EH9UOeuBF4=
X-Received: by 2002:a05:600c:8a17:10b0:4aa:7270:60f with SMTP id 5b1f17b1804b1-4b743f9f46fmr464815e9.1.1793973775119;
        Fri, 06 Nov 2026 06:02:55 -0800 (PST)
Received: from google.com ([35.189.193.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d3d609b1sm3724515f8f.8.2026.11.06.06.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:02:54 -0800 (PST)
Date: Fri, 6 Nov 2026 14:02:40 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: xuheng@cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: arm64: Compute hyp early-allocation and pool
 sizes in 64 bits
Message-ID: <au3eALuLVKZ1WXhp@google.com>
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v2-1-44a6ca90190b@cs.columbia.edu>
 <CA+EHjTxXpA6sCrSmwRJBA=YKGfNP4zs-THhheRHTaq2BfYY-Lw@mail.gmail.com>
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
In-Reply-To: <CA+EHjTxXpA6sCrSmwRJBA=YKGfNP4zs-THhheRHTaq2BfYY-Lw@mail.gmail.com>

On Fri, Nov 06, 2026 at 11:31:57AM +0000, Fuad Tabba wrote:
> Hi Xuheng,
> 
> On Thu, 05 Nov 2026 22:59:48 +0000, Xuheng Li <xuheng@cs.columbia.edu> wrote:
> > hyp_early_alloc_contig() and hyp_pool_init() both take a page count as
> > an unsigned int and compute the size in bytes as nr_pages << PAGE_SHIFT
> > in 32 bits.  For 4 GiB or more (nr_pages >= 2^20 with 4 KiB pages) the
> > shift overflows.
> 
> Mostafa (Cc'd) posted a fix for the same truncation in July [1],
> widening the parameters to unsigned long instead. Would you be OK
> picking up his patch for v3, keeping him as the author and your
> description and tags?
> 

I was preparing v3 anyway, I can post it today.

Thanks,
Mostafa

> > Two of the regions that pKVM carves out at boot are sized from the
> > amount of memory: hyp_s1_pgtable_pages() for the hyp page tables (hpool)
> > and host_s2_pgtable_pages() for the host stage-2 pool both provision
> > page-granular tables for all of memory, about one page per 2 MiB of
> > RAM, so they reach 4 GiB on a machine with about 2 TiB of RAM.  Arm
> > systems of that size exist, for example AWS Graviton4 x8g.metal-48xl
> > instances (3 TiB) and Ampere Altra Max servers (up to 4 TiB per
> > socket).
> 
> Could you also list the hyp vmemmap here? It's sized the same way and
> overflows at 2 TiB too.
> 
> > On such a machine, divide_memory_pool() gets a truncated hyp page-table
> > region from hyp_early_alloc_contig(), so the host stage-2 region and the
> > FF-A proxy pages that follow it start inside the range that hpool will
> > own.  hyp_pool_init() then attaches all nr_pages pages of each pool to
> > its free lists, so hpool and host_s2_pool share pages and the same page
> > can be handed out twice, for example as a hyp stage-1 table and as a
> > host stage-2 table.  hyp_pool_init() also derives range_end and
> > max_order from the truncated size, so most of each pool is treated as
> > external order-0 pages; on a host whose IPA size makes the host stage-2
> > PGD a multi-page allocation (for example a 42-bit PARange), that
> > allocation fails and host_s2_zalloc_pages_exact() uses the NULL result.
> 
> Could you describe here what actually happens? I think pKVM init fails
> before any page is handed out twice. Just below 2 TiB, hyp_pool_init()
> for host_s2_pool hits the BUG_ON() in hyp_set_page_refcounted() on
> hpool's page-table pages, and from 2 TiB up hyp_back_vmemmap() zeroes
> the new hyp page tables while they're being built.
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20260715150125.2798116-1-smostafa@google.com/
