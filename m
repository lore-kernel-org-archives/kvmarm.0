Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D03278146
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747665247; cv=none; b=qXne6S7sOCCET2ol8bOTA70pNpCPDnDC/XT7d9WTUmtQuzrthZCMn/IY8VcJ3SA/4d2jWvEReEcZSC1QIGly/jkZOOljxcIbno37chakjOob1fmaV9YH+gBg30wEydvJogNnVgOzQKHb5jbXMN1sIaCyhSqFRxqX/yE0a94jXaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747665247; c=relaxed/simple;
	bh=I9lzMgSvH1LyOBPTWN5xRM8c411OK22ElmVpA1UPYeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVIxl3Qjf03QMSRjD8iMXG2q8LScCdyftC9HkNv5Dc5ZGe/4gvd/FXL+izICYbUEJMjbZn093I0oYfG+WoUnvXqhtzzflzDuBZeReJo9F+mSTNt1Ji0CUGo70uVhCJijB0E/Hp6DL1KNvVJbFSWWJYKamomoQIBbc6yAQtOJKyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a9ffwmuq; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a9ffwmuq"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad574992fcaso164106466b.1
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 07:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747665244; x=1748270044; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmGAnLS/NEWC0m080CBn1UiyJaS/KFlnJ1TZ/Bc5c1s=;
        b=a9ffwmuqCAVtaGZ7S0lTDShhurQH/3Z0oky+9GEm/kRFvG+Z60fgSlL/HkkvGGf/yH
         dAl+LkeFvvr3e2dQSgxg+lthAwuH5rBwC5pvD05/HM28cHwg2t72haXO8gdpGWJ7kAKY
         ndyVu+4u2JIjTIChYwuhUdGPFA71knVciNOuCdRmhCrUsGUkUc24ERON17WWdyWoadFL
         AMKYSpz8BG7eWghOqvcwLYMjmBb5x52FJu/7EQcJXTBWYZ554w/9U7kbHOqcTibVhZci
         fHslono35TNnECGM1K2XHOHft4M+31pjmyGBFjWoOUdcAYhYc1UPNz6NfB+uHLaob5Hk
         zG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747665244; x=1748270044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmGAnLS/NEWC0m080CBn1UiyJaS/KFlnJ1TZ/Bc5c1s=;
        b=j/nSxCT0l8TwcXPIgnpv2Cg1YjOtj3nM2Qf+kIeIvl4XBeNRohJfhHctkwXd9TlRtN
         vRE7HaPCUGnCdOpCzZSbFNcO12cJv3YEv+S6RnT151Zs+Gwk5B4I7hviX3DII1Gnhc02
         HHkVqaqfDhRywzEzHo9vZOQh0xaW3xmJqCdlxcoEX/tbVBcTzT2mgEJZxtdXWk48QHfZ
         3gH+gpGMHAKihOYk6JWzL+vu+a2b5z+VfwxJSq2vAhLWwQYCxfiVQ+QbbbtMGo3xVRA1
         u7lA+xEI5zgJGOSuogEVE0uxIf/W4VKPPagyFNtvAf2lYxSnmqMf/e6Oj/j/xDcyNzJ5
         Slqw==
X-Forwarded-Encrypted: i=1; AJvYcCV44nsiSs9qtHh9zawwyZWofVgpe/Y73yKlnE7T4v/njUN8PumM5/rxqWBtpsXYhxQB/xrEnYs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyzsbe6836ArdF4NGkO1bIKB2EB4ciAVrtfVlGZ+/eeXammPuO/
	aD7Z/1X4hQybJZm2LMdGgcH2+pBKo1zYgj1cRR7+VHT93Ft/INXzUwBZdHuCGgPw7A==
X-Gm-Gg: ASbGncuoP7fdBzwJKzG3bnda08SVtkijyoXrnWnDpi06YKW5M53TYfRotzXPCCzsKWf
	qXix/c8Qr7eyuASsbfrpeLABkiW/8MddEaGVvep1jJznX5ZCdPls47yBMeIGJwVZa8ACm6i2r3h
	H7OFcLAXSRAQmACRMJbdSdUCcPkJdZ/+UZPtkIdVEhBkNJdaizZBFMf+ClrrHXD5I5PIuRWyGci
	efbYAtn7u4E+Mnn+uQW6QJvMxCLq3MIa/Go0LJykyA64qKCTYV4wPuBSVjKo30lf96OW+W+xUyJ
	oYuaxCalxSGJFxRxPtrMnp/5l5At7556xSiUSAIX2A3aKVagrgQdhM/xYHtKcXd1xGnKdih5JOI
	EHQmBuyIa5A==
X-Google-Smtp-Source: AGHT+IFE+1r+T6jz9dM4N+qGxperYjlRM0Iv/bL9K0RKQrkNyUXEkMkSDlbXHKfSpRXLx2HecBekhg==
X-Received: by 2002:a17:906:dc95:b0:ad5:5447:6ec2 with SMTP id a640c23a62f3a-ad55447bff9mr850796666b.53.1747665244323;
        Mon, 19 May 2025 07:34:04 -0700 (PDT)
Received: from google.com (68.57.204.35.bc.googleusercontent.com. [35.204.57.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d43840esm594158466b.87.2025.05.19.07.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 07:34:03 -0700 (PDT)
Date: Mon, 19 May 2025 14:34:00 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v4 09/10] KVM: arm64: Stage-2 huge mappings for np-guests
Message-ID: <aCtBWPe9Vjy04Srg@google.com>
References: <20250509131706.2336138-1-vdonnefort@google.com>
 <20250509131706.2336138-10-vdonnefort@google.com>
 <865xi0fzwk.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xi0fzwk.wl-maz@kernel.org>

On Friday 16 May 2025 at 14:28:27 (+0100), Marc Zyngier wrote:
> On Fri, 09 May 2025 14:17:05 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > Now np-guests hypercalls with range are supported, we can let the
> > hypervisor to install block mappings whenever the Stage-1 allows it,
> > that is when backed by either Hugetlbfs or THPs. The size of those block
> > mappings is limited to PMD_SIZE.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 78fb9cea2034..97e0fea9db4e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -167,7 +167,7 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
> >  static bool guest_stage2_force_pte_cb(u64 addr, u64 end,
> >  				      enum kvm_pgtable_prot prot)
> >  {
> > -	return true;
> > +	return false;
> >  }
> 
> Can we get rid of this callback now? And of the .force_pte_cb field in
> the kvm_pgtable struct?

I think it is still needed for the host side -- see the comment in
host_stage2_force_pte_cb(). In short, it is not safe to put down a
RO block mapping for the host. Re-mapping one page RW in the middle of
the block for example would cause us to 'lose' the RO permission for
the 511 other pages (assuming 4K pages obv) when we zap the block and
we have no way to reconstruct that lazily as we do for guests.

One way to solve this is to teach pgtable.c to inherit the block
permission/attributes/sw bits/ ... for all the PTEs in the newly
installed table when we zap a block. That is actually quite cheap
and easy to do in particular for KVM_PGTABLE_S2_IDMAP page-tables
(a.k.a the host) -- Android does that downstream FWIW.

Thanks,
Quentin
