Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7EF25744D
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754311146; cv=none; b=qfcNGSCtmDiu8b0ZZbov0g+F53r4jU/QPCKCEJ7wveg9hGu+wVUMXqufctBT+4vHoNPMPkX80U21Nm9DIVp4Jn4nj7FRjILyoIG8s+PUO3+7OhR85WnDBLgodNoOCh6x+NWjHRR+f7nyzlhlDIQIhwxlsY00XWwi/+PfLE37w5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754311146; c=relaxed/simple;
	bh=EBa3LJDotoq7e64FNgS2F6Sc5LW3ILO1eZ5TiKEqHeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbI4faubqO5AzLT5GagNBktw+wS/fXZxikezfME+AbhyOMMjq2qS5gvXKtHulCz8sIfD5jeiSipbxw0bhV2e4alYwQC+KNiTAwzyddKYdIY3AXr29SxWpGdLllY8A3m1yiA/G1f+cpHidtQCi94U2dcvnH1f1lxFrN+NTor9B/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=FacFwWKZ; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="FacFwWKZ"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b26f7d2c1f1so3913565a12.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Aug 2025 05:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1754311143; x=1754915943; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YKCj6FOnfKnqynF1p18ufhjCbVSDwmBzNnZjJrqA/Zs=;
        b=FacFwWKZKPVys1ieD3Knqcozis6kyWaXwNNe1dBkioto6Az1BMVQhp7bvRuTC/PD6p
         lv5TqIi+VZ3VvaJ92ryX35eRZZodD4Jh6W/xKgXXb/U13sJxb7y9iWO6GMa0rtH0lwcw
         ogTvPQz7udWbY7q84VsInJ+gCWvy6TuF/sOCX92oJDh3cq/Q8k190ZL1lgJ95Pdpk03F
         rN/YNZfFaAX12ka5wU78uXn3EwjyS7QyQzOhJFvQPsg7cnkB8YfHkzkRyMJ61Il1Os6D
         8q719+9sELiI3oemJezhmpM+IT+mh4nzOPYsDtdla3APCUwvmWXwUy1hGSrTfpwuQKvU
         Lw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754311143; x=1754915943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKCj6FOnfKnqynF1p18ufhjCbVSDwmBzNnZjJrqA/Zs=;
        b=h1MDdxIDQUNHjjcEGDBoV3HdjMBlgYuVyaKLKmh7udYCcZ5bUk4ZnhSDgJXjtpbava
         WyZCDbepRxWKf/MYnC7f5fMs+TKFBdRrNIKdVEGjvHXPmBqwaMsCWU5zZbnf7QwgYoD4
         FD0julkvUBAdheMA+x0JkGhlJkWew9CuGScDe5mzQ4jdHdqBjeU8wnH7PfUA05BAWk4a
         3aWX8gZJl5OYD0ZXi+nHDy/7WL6PdPYXsgpXS9afBbFI/HZJXHUeiWPWm71h/sZ2AE8c
         UmbgrAZH6FBKok/Bpn02KJdjM3C0CpTGPYa0ytH1AQ+XnX7DCsW+XnaM3HlF3/ELA/KR
         ik3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUMCG6M4uk+AUh9sebMxxzV55RELUV35sHQpmTHQ+AObyy9rGKGDO5FEa/JoUWmdHWnNu6qhlw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/AzlpjJ5AphF8MaRevu9hjmSNTDkh2tmsEtDKSk05CS6SqffA
	CRDZ1uUEc18VgWsYKnYo/HUV0z3gd3IBbH4L79Xtkx8vREbT8gIi7xktyW7zW+xRyBbMxleBQqH
	9/hLwztEawm4gBbEVkkUle7E/gRYBijiACXK73HAv7+JcS4UssgI=
X-Gm-Gg: ASbGncsS7RJJvZ3ywha0ymd1gGiFD18+d7l294Zb23Le4m/KLGQb3EGkSTLC8kG+FEK
	VfJfjgqZ3hUgkajEu9wG6m8rEWu9awF/tWU87JKKyRJUpIkOdmsaS7P/NrcFRXJaxokXpiiJwGa
	rQGTEOO1Eko0hX5BmxviGid8Ai71WZPRdr0UQ4FVs7CG8/eUYScbswzw1EEd4oE7wW+jed9qJFu
	D1T3FKbUMnqQsjIOkYKZQJpW+rpjdknVhNIAKO9d+vGPw1wDy3gDjAo8eMsHM3pAI0dqtyH4sSe
	vcr4zg506w2IeCScSj7trW2GkYhXGqkSsayw+hQElkG/LWyOLpjDJGnFFgzo2eLIETZ5hDPbaw1
	gvMBPGjddwhXBHJvMIZrXgWCUxafEq4XfcojJXE7zYDxg/xiPgnzHDLgdm4ctsuSHs2oQJHs=
X-Google-Smtp-Source: AGHT+IFzfwXuQNe+jvCRtHRgBNrc6qR/ahRDyVponjDa59epA2QL+D64gAB3pXkW9DcRv6GRw24e4g==
X-Received: by 2002:a17:90b:1d8a:b0:313:1e60:584e with SMTP id 98e67ed59e1d1-321161ec88fmr13406605a91.9.1754311143029;
        Mon, 04 Aug 2025 05:39:03 -0700 (PDT)
Received: from zenbook (1-162-100-196.dynamic-ip.hinet.net. [1.162.100.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63ee49e0sm14418422a91.24.2025.08.04.05.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:39:02 -0700 (PDT)
Date: Mon, 4 Aug 2025 20:41:35 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: ptdump: Fix exec attribute printing
Message-ID: <z2hmwwmtgbrio2wv3sj2pc4zhxdjioorlhnm45o2arcsjahjni@xod435q26jqq>
References: <20250802104021.3076621-1-r09922117@csie.ntu.edu.tw>
 <d72b7928-8646-4616-a8f0-96b9d9bbaf09@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d72b7928-8646-4616-a8f0-96b9d9bbaf09@arm.com>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Anshuman,

On Sun, Aug 03, 2025 at 07:33:04PM +0530, Anshuman Khandual wrote:
> 
> 
> On 02/08/25 4:10 PM, Wei-Lin Chang wrote:
> > Currently the guest stage-2 page table dump has the executable attribute
> > printed in reverse, showing "X" for a non-executable region and showing
> > " " for an executable one. This is caused by misjudgement of which
> > string gets printed for the executable and non-executable case. Fix it
> > by swapping the two strings.
> > 
> > Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> > ---
> >  arch/arm64/kvm/ptdump.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index 098416d7e5c25..99fc13f1c11fb 100644
> > --- a/arch/arm64/kvm/ptdump.c
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -44,8 +44,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
> >  	}, {
> >  		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> >  		.val	= PTE_VALID,
> > -		.set	= " ",
> > -		.clear	= "X",
> > +		.set	= "X",
> > +		.clear	= " ",
> >  	}, {
> >  		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> >  		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> 
> Is not KVM_PTE_LEAF_ATTR_HI_S2_XN already in the reverse semantics aka
> XN (Execute Never). Hence when KVM_PTE_LEAF_ATTR_HI_S2_XN macro is set
> that means the entry is not executable and vice versa.

Yes you are correct. However in dump_prot() we have:

if ((st->current_prot & bits->mask) == bits->val)
	s = bits->set;
else
	s = bits->clear;

Analysis:

1. region is executable:
    - st->current_prot == PTE_VALID (ignore other bits)
    - st->current_prot & bits->mask gets PTE_VALID
    - if condition is true (.val is PTE_VALID)
    - prints bits->set

2. region is not executable:
    - st->current_prot == KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID
    - st->current_prot & bits->mask gets (KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID)
    - if condition is false
    - prints bits->clear

Therefore we want .set = "X", and .clear = " ".

Thanks,
Wei-Lin Chang
