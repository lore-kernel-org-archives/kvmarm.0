Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F721C8CE
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 08:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754382728; cv=none; b=gjKCTuz0nxGFzneEZ9eXTFp58FrN/kEFJwbFJOaZyGtj+ZKkoCjUGug3bNThzciuQGAY1etLFqJ3OmR4ys3ECLNfuMcbkP5lVguLI/VGI0X/wtK+/I8QJNPd2XZ3gBvFkYOMMuydpCnOvN5xSEA5iCGoKOPMqt5QRhjH3JIsucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754382728; c=relaxed/simple;
	bh=fHmpaIOPjkyexmjJ3+L8AA+pWZ8k+h7xPPc0/QhT1+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IT4dpUhrHhg4a5nk3nb6Ix7gpuUs3UlXoQ0/I2IeggFPIoIxzJpOz7NsRZ5Zsz53INj1Vo2j2t5cVaBT3dBDH35MfVUkI4utn6WL6i7a+eeFvhPTDpjZtrWdGkAw9yre/k2K8O1kI62jMZGAFjkZ7P+/Zxb59Ik/2oO51GaUlmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pMrF8ezL; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pMrF8ezL"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-458bf57a4e7so63975e9.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 01:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754382725; x=1754987525; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7BWA0STOcqIUzpFQVaS5UHy7SE6OJhVfIhAfBgcIup8=;
        b=pMrF8ezLCsb8pGVBs1H31L/p+ni8oTNXzuLwS1jXr9qIKAxJHNzgM5Uuq3VqQpbq4F
         vKRiW1xPF8Ybwb988KoxIWSnqLftDznj1N7u874E8L2FZGzidW0s95ACdXQatulEmiJZ
         LpxRm6Q7aALEjdae/ql3PokN+3HTk1LbwtE/Xc3PuWkuKcns267bIcIMmeaOISbM9u2G
         MrzBT4NhjCMfGTyWqHa2kX3qUfwrqGUL6KVVvTIuaVdidk5gRX+Y3D734M/BzPx9qhOP
         pxVwjjVgiMp0VYxyXBCom9McDCHWVOvY8VoxfAOu7zgNic+n7U6xeEYfM0j9xxQ+MoDc
         WxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754382725; x=1754987525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BWA0STOcqIUzpFQVaS5UHy7SE6OJhVfIhAfBgcIup8=;
        b=N/y5t06JthyqfnM8acO3IdzSs353m7e0aRCX+ZhVEoe9un6AAZz1Vyv2aejyWDWpxR
         SrKAPXX/u/smLkqj4BqG+4MEwe3jDDMa/NaY1MMaUCH4MS0WEVxTp3WlwjnDs5BJJ4UL
         phGA0q0YDEFHwdXuIn7QtumSotZ3xnGy75SvDvrW+qwpvQif1ijtzpPR+SXVvNspQd2l
         b1C4Gzsm9/Ztp6fASwFVanN33SDaZF0DBYDHAIoXeqbSvFIPAZ3I7wBjc6Gwq2rexZ8C
         8B0Rp5BAx0jW1qWcrNYzGN+cRXUWxkYKpWbe47FLCMJs30vpGPFkof0viGeN3Uq8eDbo
         jLiw==
X-Forwarded-Encrypted: i=1; AJvYcCU0GtueID2uOZOKVgk9UwIigKoOuyz6eH+QPT7xnGkZ9e6Id/WMPh1aR/xYrqJoZhXwUCgNgYU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzadzwGzrJZQyZl10NXBFU3mB5U8G6L0sw298KIdRetSLzdly1T
	LDZfdJdKHuRB7Ze4/haetkGrzBJ2pgFisBZz5zrBwj4+k+xRVBP3xMGD+2XbxD5XmA==
X-Gm-Gg: ASbGncto3lgcikFEWFk0HSgrWi0UDj1KlX+afhMkWZpl8/AcryKclPr1gIOYX4/Shm+
	994ixA4P2VybflsjSXjO3SOtNM9Hi59SSVyLB9rKjUl1iXBPgLCz12XTFjW+R3OY3h0jw4Czm/+
	FwUIX6/o0QWLtVvwHHLHfB5i6I3bfDGj/kDljduxwvjzjNB+yjp1VxL2EF2jOEJxkmVfiv1OJHB
	j8NVmLMOAAkKGE/P2dHWDjMFde5Lo9Q4p1CmxuqAyKaUkwtuB73LIhP35uD/qQyy7PZ/gnrxjTn
	icOJvP8PyIewyISolCWffvSKEOaX0s2+XEs8iVEGCH0cw6SVCm0N+gKpSwx1zux+cn99fnkEgNE
	EBqDKrbjwDxk5vtEhcQ5ECPrNCbajlL5FjfKIQ1GoqVd9Sj7Ebojwz9cSH3mTjxY=
X-Google-Smtp-Source: AGHT+IFKztsRYhYKwdwIDsCDgAVK6+r35a5h3+OYoOMO7aVdiPkoVmjrLzpy/fS3Hiy5FOXrT7eLpw==
X-Received: by 2002:a05:600c:888a:b0:439:8f59:2c56 with SMTP id 5b1f17b1804b1-459e269dbbamr469945e9.2.1754382724391;
        Tue, 05 Aug 2025 01:32:04 -0700 (PDT)
Received: from google.com (72.47.233.35.bc.googleusercontent.com. [35.233.47.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e075047fsm18416515e9.1.2025.08.05.01.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 01:32:03 -0700 (PDT)
Date: Tue, 5 Aug 2025 08:31:59 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: ptdump: Fix exec attribute printing
Message-ID: <aJHBf4KCUPpWbyU5@google.com>
References: <20250802104021.3076621-1-r09922117@csie.ntu.edu.tw>
 <d72b7928-8646-4616-a8f0-96b9d9bbaf09@arm.com>
 <z2hmwwmtgbrio2wv3sj2pc4zhxdjioorlhnm45o2arcsjahjni@xod435q26jqq>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z2hmwwmtgbrio2wv3sj2pc4zhxdjioorlhnm45o2arcsjahjni@xod435q26jqq>

On Mon, Aug 04, 2025 at 08:41:35PM +0800, Wei-Lin Chang wrote:

Hi Wei-Lin,

> Hi Anshuman,
> 
> On Sun, Aug 03, 2025 at 07:33:04PM +0530, Anshuman Khandual wrote:
> > 
> > 
> > On 02/08/25 4:10 PM, Wei-Lin Chang wrote:
> > > Currently the guest stage-2 page table dump has the executable attribute
> > > printed in reverse, showing "X" for a non-executable region and showing
> > > " " for an executable one. This is caused by misjudgement of which
> > > string gets printed for the executable and non-executable case. Fix it
> > > by swapping the two strings.
> > > 
> > > Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> > > ---
> > >  arch/arm64/kvm/ptdump.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > index 098416d7e5c25..99fc13f1c11fb 100644
> > > --- a/arch/arm64/kvm/ptdump.c
> > > +++ b/arch/arm64/kvm/ptdump.c
> > > @@ -44,8 +44,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
> > >  	}, {
> > >  		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > >  		.val	= PTE_VALID,
> > > -		.set	= " ",
> > > -		.clear	= "X",
> > > +		.set	= "X",
> > > +		.clear	= " ",
> > >  	}, {
> > >  		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > >  		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > 
> > Is not KVM_PTE_LEAF_ATTR_HI_S2_XN already in the reverse semantics aka
> > XN (Execute Never). Hence when KVM_PTE_LEAF_ATTR_HI_S2_XN macro is set
> > that means the entry is not executable and vice versa.
> 
> Yes you are correct. However in dump_prot() we have:
> 
> if ((st->current_prot & bits->mask) == bits->val)
> 	s = bits->set;
> else
> 	s = bits->clear;
> 
> Analysis:
> 
> 1. region is executable:
>     - st->current_prot == PTE_VALID (ignore other bits)
>     - st->current_prot & bits->mask gets PTE_VALID
>     - if condition is true (.val is PTE_VALID)
>     - prints bits->set
> 
> 2. region is not executable:
>     - st->current_prot == KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID
>     - st->current_prot & bits->mask gets (KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID)
>     - if condition is false
>     - prints bits->clear
> 
> Therefore we want .set = "X", and .clear = " ".


This seems correct but it will produce a different output than the
stage-1 ptdump. What if we drop the PTE_VALID from the mask & value as
Mark and Anshuman are suggesting and print NX when the bit is set and x
otherwise as the stage-1 ptdump does ?

> 
> Thanks,
> Wei-Lin Chang

Thanks,
Sebastian
