Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FA0417BE8
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784550649; cv=none; b=qkbLiAp1z105Me7pZd9BKZ7o6QAuJdWyqn4yZYGS9m89M8KwBMWVf/AZWql4rUieJ6/eXXJGUcP7UePcshcO9CK5HJI75FD+mCexiE2Q28znXJejwcwuJ6LUAcJii9RmksR0YGx0KGpEfPbZ3Zf3XTf3HNBO6vV4bdAtiq86bHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784550649; c=relaxed/simple;
	bh=VqZ4lCrqHHA072sXqMDHVl1zrj0Kqp+/o8ekNF34vmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e77L8mh2JpHjFnc1zlR/oWMMsLHKurWoSxzYLhiIKCargywsM5NwtSPGX7KNXtH1IUE9fJdkHI+H9XxTNVBq9HJaEAeQn/Nb8XxGwCJBWpVbbcSUANqfuMn/lq7+kmP0qJa44V2cQ8dVTkIrLUZfD2MsG/z3JAkSV0m7GJMsCRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RirE4fSk; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RirE4fSk"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f59f25ec4so1062746f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784550646; x=1785155446; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WkMzrjoUx6ZJyd3KWX/rbJeUctcg1WNARwpXb82Kers=;
        b=RirE4fSkpdXbeLzFzoppRxcF91ElyPNqnhrpV18qqhZ8wMJsayUN706W7OklhK/CHp
         B2XHL5/Fg47hd06XLtZx94la8XGOoZGscLsSTuPycM5b+jpoCMxD/lkzDmVnUeEMx/rt
         65UAqZCkd/DtsGhShECJddk8G5mTIH4xhnvy9UHA1pXce0jnlg8fy2LYjpvLZIVyHgZK
         1HIJ8mpoFmEGZaCHadXJ/AeEp+WD4evM+MJXtPJeKnDX1UpSRPxNEEbpFR81vn3cfhdT
         VRY0cooTn6Ut4Kdpx2uCSsnadefGZG+y8FERgM+YNFmTSOMI79M2P0ozqgKrfedHrdUp
         WApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784550646; x=1785155446;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WkMzrjoUx6ZJyd3KWX/rbJeUctcg1WNARwpXb82Kers=;
        b=IBzB6xEBfUveWBIJ4pVNfYaHbSZzkjayNGl9vUNRIdB3fGQXCvRSjSykPc/0zqSlpW
         CxC+T9z98a3hTmw9XXOjfw52IgSFO8tmifLJgbtiMhfHqrj/JmfcYdlM71vip2k/DqVr
         U8+IrNd/BNgES/71qlsNupCocz8KFg7dDm/OrJuC+WQUlqk9kznTQg1V8TwT2NV+N7tc
         IumtqqCncQX4kDnjo5L6O8Qnbx0NjRPJw+GsoCIlhLOAyonhQXpJSm2A4d2ZuXnbXnMv
         IuxhJ7KHorRun1AKAs+cs5dQcaWCTzoTJfK8l7sDl0ezwNMi3uR5rcZCqBalI8UTh+Pd
         7Jqg==
X-Forwarded-Encrypted: i=1; AHgh+Rq5wDMfLyG/jX4kdTMwo3XZAC5+8Oq3kV6nNEENtPbZsKx8XO/vNGStZhPBe/QWtMQ38ILEofU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxewEIvx9Qkmw3TwRPnrhr3tZpoTNFVt8FxqbCaU/ZTy2iutK8D
	HRh/QwFEEMH8QuVgfF2Z1KMA+D+xAZT18fIHF6isL+xa9OjR4LKwv8j8DRodI4liQA==
X-Gm-Gg: AR+sD10weP0jgcAsuPzCFlPA46QwrmBRNHVDl2hWtDHHerTAp/kC2P2j/wTZD1hG2uO
	chaD/SOkBz9wag+jQvrvlHr8n1kqNxxhq7xX9alNODAXIOsdlW2vSnDnh1Yf35rdc9xW2hF6VEh
	f3e4/3BOseiVkwMBwWmEpPJj4dd6PYEc8D6t63HfH4ACaLcVtXnsW0y0kwwWpICkemWZ6A1YLMI
	zINdsT312PkWi9aPWrUNybEnDCbG4RmmxbCddF48BCPrNMspK0SYB+9HD/UG4741XGBT9xE4xTE
	Bfjbne/6W6edfxeN4E/qxUZb3EvnmIA86u5gMWA14ypobv+OR8b06VHDwyVsRKZJ7n7PQYTrrYp
	82wZra82sm9X/HJ28cH9jRy7QrvX7Nmux3ZU0CiQRXlS3jGvalh2LqaVdpx2pMq5NkcUpIOSkae
	UG5iLqGkvT06kfJO8VMmmzgq7wKerwjLwcIrW+xZgTmTap+QzjEjA=
X-Received: by 2002:a05:6000:228a:b0:46f:f12b:e45a with SMTP id ffacd0b85a97d-47f622fe81bmr16676873f8f.23.1784550644845;
        Mon, 20 Jul 2026 05:30:44 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ec7c69sm31567542f8f.17.2026.07.20.05.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 05:30:43 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:30:39 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com
Subject: Re: [PATCH v2 04/18] KVM: arm64: Add a heap allocator for the pKVM
 hyp
Message-ID: <al4U7xB4ySWVAQT_@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-5-vdonnefort@google.com>
 <CA+EHjTzbQukkKpNfdTHKS5aAPCn4hnCxu+EHnm6OWpW=mTS+Gw@mail.gmail.com>
 <CA+EHjTwSupmgbjbeUap4EEwy8DP7y8euZRHd2tXc=FSDGzrghA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwSupmgbjbeUap4EEwy8DP7y8euZRHd2tXc=FSDGzrghA@mail.gmail.com>

On Wed, Jul 15, 2026 at 11:59:26AM +0100, Fuad Tabba wrote:
> On Tue, 14 Jul 2026 at 19:35, Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > ...
> >
> > > +static u32 chunk_hash_compute(const struct chunk_hdr *chunk)
> > > +{
> > > +       u32 hash = 0;
> > > +
> > > +       BUILD_BUG_ON(sizeof(*chunk) != 16);
> > > +
> > > +       hash ^= hash_64(*(const u64 *)chunk, 32);
> > > +       hash ^= hash_32(chunk->__unmapped, 32);
> >
> > Could you state the threat model in the commit msg? The VA range is
> > hyp-private and the hash is unkeyed (anything that can write EL2
> > memory recomputes it), so this only catches _accidental_ corruption,
> > i.e. a debug aid.
> >
> > Since that's the goal, should it be gated on CONFIG_NVHE_EL2_DEBUG
> > like the other checks here? As written it's O(n) hashing per
> > hyp_alloc(), in production, for a check that only fires on a hyp bug.
> > And a plain XOR/additive checksum would be cheaper and just as good
> > for accidental corruption.
> 
> Thinking about it, I was wrong to say that it would be just as good,
> slightly cheaper, but it would detect things like swaps.
> 
> Still, I think this should be gated.

After a longer offline discussion, we concluded this doesn't cost anything while
the weak protection can still be effective against attackers who may not always
control the entire bit-width.

I'll add some details in the commit message.

> 
> Cheers,
> /fuad
> 
> >
> > > +       return hash;
> > > +}
> > > +
> >
> > ...
> >
> >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > > index 75b00c323310..1c10cf78c869 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > > @@ -10,6 +10,7 @@
> > >  #include <asm/kvm_pgtable.h>
> > >  #include <asm/kvm_pkvm.h>
> > >
> > > +#include <nvhe/alloc.h>
> > >  #include <nvhe/early_alloc.h>
> > >  #include <nvhe/ffa.h>
> > >  #include <nvhe/gfp.h>
> > > @@ -363,6 +364,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
> > >         if (ret)
> > >                 return ret;
> > >
> > > +       ret = hyp_alloc_init(SZ_128M);
> >
> > Where does 128M come from? A comment would help.

This is arbitrary, big enough to allow us to allocate plenty of VMs with tracing
enable. But I will add something.

> >
> > Cheers,
> > /fuad
> >
> >
> >
> > > +       if (ret)
> > > +               return ret;
> > > +
> > >         update_nvhe_init_params();
> > >
> > >         /* Jump in the idmap page to switch to the new page-tables */
> > > --
> > > 2.55.0.rc2.803.g1fd1e6609c-goog
> > >
