Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45AD1F6697
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440886; cv=none; b=lHlHa0xngsrGjyqtqcBBWTJH/+QCjHCwqsTwhsBskQYu9rmCynykndBOjNwh39/92cLwsccSpuyBwKZ7mkMlIjqYDe3BDFtZIHkhzW+KJTWhru9uH/DtDs9bsU1jyakxOJQx/zkz3ChG9zjV+c0Agc6QNYwQoeKfp2qggjpRzCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440886; c=relaxed/simple;
	bh=58eBS3P6Q99T+Ll2P7RPlryhCoPeOMuQvZcOjVzhwCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7yhTxVQjEmG4LNDNfuqOF6ks103W+HEV/ZBhlnkc5ymJIlJWYVRqlOzH5PxgJpuVTeAlfc3vnWb/6bXPu+FbwIjyf68iO6EnvpYCtkU/NrxsNt46mo5DuroFq+2sXzETlL47ezNMYe6TYNjvFKrd4L6eb4DXV2ulVhG8y9BCJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bcmRa6C8; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bcmRa6C8"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5cecbddb574so8893218a12.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 05:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734440882; x=1735045682; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SxP352xQrJECWy5yVL3g0J4iVO0b/TvCNJ0J8iinEAk=;
        b=bcmRa6C8fcqaDCe0XIIxvom/+zd5xER0WUPy/W6vMYWE8tK3fQzxb+Dkwmy1HQycCb
         dD0vONJ7/97NqFY5MWy+PFei1KoTb3HPvtUfofVnSAEPuZXzi4tUdP1dITfgoeNJwRJC
         JaFaMEko0ziLriSV9EJDpyEMlBI93JVAcnmWikK8DLXzs4a2zS0iFXejn27Nx97pXcM/
         Hb6o5dfH3zRsWglmKEzVkMaWaqUGmMlxzFpzwKO1EvpByJXBAxhLYNqdsCsAJZb0ttKV
         dFPBg2pufpyNoLe+r3H2Cf9TV84rGOR85Pf/HxbBADHDqABgZjR74hC8bSarNxo2yldt
         38eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734440882; x=1735045682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SxP352xQrJECWy5yVL3g0J4iVO0b/TvCNJ0J8iinEAk=;
        b=Icky/mLZRmTxlYybNpHMqWM/yAsh/M9NGw5g++kXWWpW+7g5CllYlySbZQinW5qH1F
         oZb0ty8mUukdxBWY5Qxw7hWsW4+OER3sXwZEFguh7+vGW56GQ83PHCb6hbQsiKeFP5Q/
         Th1kZON4DYN7VP+f3zqhEB7uk9kaJEaomuefi3vFCgXs6xNgUNc0yHWIFjFvoH/rZxEm
         bYzNjd3tD31dL2RGo7WS7YES7IGOZ/qLIm/cYRoJ7MTy5CIN1k7vFXSN2Z9THt7PGdyG
         HG8umKFEnpHsex2AGK5kD2mhKZVlYgnLwh5RSfpwcvjOlw4VTX2jhvMjbCKiHa/XQewh
         0abw==
X-Forwarded-Encrypted: i=1; AJvYcCWxgX4JXeT0fmPdtLmQEhslSuUBzlV22QLszJprRClbVVSRmU15xOWkdvW9EhGCWGhhl8XeloM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh9XuRgNN7Bk4n+xoekT6hu6DdYnDVgZ6udBAuL2U9hmYr9ru2
	CFRjLCmEWimrIED4J7PGXPZf2VWyynC+fKx0KsbyfrUNJcc3yTr0PVydNyeqmw==
X-Gm-Gg: ASbGncuaBHWByzUZ2gSW9PlwoE+9t3LDlMbcnPUUBNUz+NX9GATquhsseBTQiMp6k+/
	4lJ9hah3MvCtqcfR1ulmkDC1CP573OAkeUwBFp07z5UuPg/HO7bW7hcW0joj3ps2R0EvRvBS1oJ
	inbLkaYX53DUYGQiNQfa6Y1ikanl4uBuVAnRfmtKy7hAdigzBpNQZPg29gxGYKuElV4EKGL1qkx
	ZVw++pCnoOEFhgdNI4Du6ulCh0fNgMEUp1hhAf9YHAW5IuaQtKkDJcKt1PqrzhXsxlLeqisvlOf
	KOKom3+km76XVuw=
X-Google-Smtp-Source: AGHT+IHPCDUKwR/FGRi6mHLODl5BviSg7xFz4W1NW5gTkYq7HIYlXpzWI3patHH94VqPS2+uTzBEng==
X-Received: by 2002:a05:6402:4349:b0:5d2:60d9:a2a0 with SMTP id 4fb4d7f45d1cf-5d63c42d641mr15856567a12.33.1734440881906;
        Tue, 17 Dec 2024 05:08:01 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d652ae12a7sm4261850a12.50.2024.12.17.05.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 05:08:01 -0800 (PST)
Date: Tue, 17 Dec 2024 13:07:58 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/18] KVM: arm64: Change the layout of enum
 pkvm_page_state
Message-ID: <Z2F3rveiCEuPwxhN@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <20241216175803.2716565-2-qperret@google.com>
 <861py6sht3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861py6sht3.wl-maz@kernel.org>

On Tuesday 17 Dec 2024 at 10:52:08 (+0000), Marc Zyngier wrote:
> On Mon, 16 Dec 2024 17:57:46 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > The 'concrete' (a.k.a non-meta) page states are currently encoded using
> > software bits in PTEs. For performance reasons, the abstract
> > pkvm_page_state enum uses the same bits to encode these states as that
> > makes conversions from and to PTEs easy.
> > 
> > In order to prepare the ground for moving the 'concrete' state storage
> > to the hyp vmemmap, re-arrange the enum to use bits 0 and 1 for this
> > purpose.
> > 
> > No functional changes intended.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 0972faccc2af..8c30362af2b9 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -24,25 +24,27 @@
> >   */
> >  enum pkvm_page_state {
> >  	PKVM_PAGE_OWNED			= 0ULL,
> > -	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
> > -	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
> > -	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
> > -					  KVM_PGTABLE_PROT_SW1,
> > +	PKVM_PAGE_SHARED_OWNED		= BIT(0),
> > +	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
> > +	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
> >  
> >  	/* Meta-states which aren't encoded directly in the PTE's SW bits */
> > -	PKVM_NOPAGE,
> > +	PKVM_NOPAGE			= BIT(2),
> >  };
> > +#define PKVM_PAGE_META_STATES_MASK	(~(BIT(0) | BIT(1)))
> 
> Shouldn't that be ~__PKVM_PAGE_RESERVED, given that you just defined it?

Sure thing, I followed the same pattern as PKVM_PAGE_STATE_PROT_MASK
which was explicit in which bits it sets, but very happy to change.

> >  
> >  #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
> >  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> >  						 enum pkvm_page_state state)
> >  {
> > -	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
> > +	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> > +	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> > +	return prot;
> >  }
> >  
> >  static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
> >  {
> > -	return prot & PKVM_PAGE_STATE_PROT_MASK;
> > +	return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
> >  }
> >  
> >  struct host_mmu {
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
