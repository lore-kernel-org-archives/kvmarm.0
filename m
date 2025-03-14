Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE291FFC50
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741961627; cv=none; b=AybGVnBby1J9pHB/ZhysuOvvVhNcnY1pOFiOEglK1OsF4QzuxC0g2zEJ9Vi2onQkc9oJcsCd48aLm+ls2U8rW/3q2grwBiEfPSgdXpcQbhqkjlodLfcOtt/DLrLpJyL8mRT895alOgsXbK0MBSR8PobUeKDOue7pflp+T4WOzqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741961627; c=relaxed/simple;
	bh=JUsDXgouHhGyx7cEbegPi10ShS3Z3geQcMmJBEeY2eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CD5nJBpRCGT4xpl2tNPjAu8OI//od7UV2qthb+7vkaNSHa9WeravAvBbQsfHunNLBXCkqupjhiQ9F+V+3NIpLDevI4Hy5gsqdd5TKRqugUWv++d7uVyIEcmgvrirMdbApWvRcnYlvLgLv630zfw5vX33tl4Tv80Zt9A+qu1zqjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YRB5abKq; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YRB5abKq"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac2a089fbbdso392591866b.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 07:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741961623; x=1742566423; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4e8bQc3GvargUcdnmcUpU13zlbK5uT7tC5qOX+GAjSg=;
        b=YRB5abKqSmWCJMrxzAlEqOiR794ijqBqCcYGMZiyuHJI/5Y6qZRuAjyBzxQ8urKV2F
         CUZYquzTpL6P1R5Z/j4XpqhDiOlWuTI8Vxo1Bb6FNq3BPPawn5ggMUAP85dTATxXlKdE
         iQ2IEMEHrVZeYsXxNA41m+XrHjvZWmpDPxGeUKeabVbqt0s2Qs8tsVNh9E8lT1eNJG6q
         8Yv1/9M4kIiec7Tf25+TGuep1ARPlU2v8QPRCim0w09tT6rS4TVLcsum+xH2aHilMCmO
         NET/j4hWHGb/pZGlSjPdUsd53oHdiv5trLnBhHFZFm08ZQQDukMcW3SbXhxb2+jEZG4n
         P83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741961623; x=1742566423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4e8bQc3GvargUcdnmcUpU13zlbK5uT7tC5qOX+GAjSg=;
        b=gYiVhLM/W4YRIaSmXGBSWnzR1NJzVRebpnWXw3ReIvzY531cimOCrXiYeorWHQvqj8
         BYBzBeq35ClmXXa4OP9iopdVijqGUGiXIqFB/9F2JA6zXr5BzZqLE/RCJ9er7570e2j1
         IAFcFuIF8uZmeVXz10mX3vtyrCu/urvqy4gLSDR0ujvVMOrnvn5QZZyuM8tCdgFuTkmo
         6PQK5vRQcoOGQ3LE23z2el4CtZkgFr4UQhZpe//ggm95Pb4FKBqmJ+UryqCCF07sZfbH
         eqiudOEuyDAWG1Jwc0J5i1tKS1FeMBNMiAw2R5+53k+tom9o4SpEyFWb58LnUd+0EV1h
         zMkA==
X-Forwarded-Encrypted: i=1; AJvYcCWh2WSADjoVIX+aJiAMwpuZ3NYjqf8iBUKTHLg1ekOSBjkRNFPAe/JZz4jiCADMJv5ntUINVf0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCGDAD0AQqA/4vrjSYroi9CrmU7phFvWltQZEXxviaj1M01WHI
	uL4bMHM8aeYs221qcISf2HauztZ9fZPtWnHNhtWcjaqLzHK4jhlD7DU868e7FA==
X-Gm-Gg: ASbGncsEj3asYZYiYOhql087Rjspnu55LYDr0X20GYIBksKF5a4trsyW8+KYGSIWZJH
	49S6rdMpwXmjkRAaJSWxaI2Mjn8OKKagOD79miKfZLd1SF8dvt1MBWkI7+rEKShKtmvZFnjfkcE
	bAGNniWGmHRszrT5PAB9Bha+VRum/u+pDziGzGbDDnp8lrwMFDpsdbGd0/4WOAD+3gZ1BCniS6n
	4YIbaIWHYGk0KcPiwkzuoaTc0i5+oOX07iUoOIswXW+xEPPBKInirm6HxGw+e/pwhau73k/7RTC
	v3E99l5yb8nd+lLnW/jqp0vK9PelaC8Tm2/qzCUA5s+oA3htRBaB/7SGL7FJFVi2psME21bdJ0R
	EEYw=
X-Google-Smtp-Source: AGHT+IGXahv+MsWEwcBurmP9OU88In++x9q7BRsugIE07NqITWt221lmP5KM9LJmHcGfmeGrdzPtkw==
X-Received: by 2002:a17:907:7d93:b0:ac2:d1c6:4269 with SMTP id a640c23a62f3a-ac3314f4395mr235627766b.22.1741961623363;
        Fri, 14 Mar 2025 07:13:43 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3147e9bc6sm226415566b.49.2025.03.14.07.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 07:13:42 -0700 (PDT)
Date: Fri, 14 Mar 2025 14:13:39 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
Message-ID: <Z9Q5k5C50Meeog9q@google.com>
References: <20250227003310.367350-1-qperret@google.com>
 <20250227003310.367350-3-qperret@google.com>
 <86cyejooq2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cyejooq2.wl-maz@kernel.org>

On Friday 14 Mar 2025 at 11:07:01 (+0000), Marc Zyngier wrote:
> On Thu, 27 Feb 2025 00:33:06 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > The page ownership state encoded as 0b11 is currently considered
> > reserved for future use, and PKVM_NOPAGE uses bit 2. In order to
> > simplify the relocation of the hyp ownership state into the
> > vmemmap in later patches, let's use the 'reserved' encoding for
> > the PKVM_NOPAGE state. The struct hyp_page layout isn't guaranteed
> > stable at all, so there is no real reason to have 'reserved' encodings.
> > 
> > No functional changes intended.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > index 34233d586060..642b5e05fe77 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > @@ -13,18 +13,15 @@
> >   *   01: The page is owned by the page-table owner, but is shared
> >   *       with another entity.
> >   *   10: The page is shared with, but not owned by the page-table owner.
> > - *   11: Reserved for future use (lending).
> >   */
> >  enum pkvm_page_state {
> >  	PKVM_PAGE_OWNED			= 0ULL,
> >  	PKVM_PAGE_SHARED_OWNED		= BIT(0),
> >  	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
> > -	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
> >  
> >  	/* Meta-states which aren't encoded directly in the PTE's SW bits */
> > -	PKVM_NOPAGE			= BIT(2),
> > +	PKVM_NOPAGE			= BIT(0) | BIT(1),
> 
> Isn't this comment stale now?

I believe it still applies to guest stage-2 page-tables as the three
other states above are still stored into PTE SW bits (well, sort of,
only SHARED_BORROWED is at the moment as we don't supported protected
VMs, but OWNED and SHARED_OWNED will be a thing for protected). NOPAGE
is still the only one that is a bit different and doesn't go there.

With that said, the comment could be made more explicit about that and
explain this is now guest s2 only. Happy to spin another version of the
series with that changed if that helps.

Thanks!
Quentin
