Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5F528A1F7
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 19:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745437250; cv=none; b=NjnbCN+ybAgYLPKQgYxCPauG/Dg7mwhy2/3s6s9ZOlsl4AQKcemWRVIXkFJv/LbIyUrrT3eabHqEVNus0A4VIOCJtR4/DpO0aTX5tfNQSBs3NofdZ+keYWNVEwAmbHJJeE2Gf+aJH1Rpwrmm97yTZHIqNEaJ0A05tPG65iF664I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745437250; c=relaxed/simple;
	bh=aMRE5rhqUubTGLzmZ1zkM/Gk1z4kf8WuzNsoKArWtNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXggCA4QRPmXhrpRHV8jhLn+o7G1LShRj/iAlSCfpsUtgJZCJNX73Y/s7WwVFaKPr6NehFPlQJlVJ2yuEw8Dls0L6TcsoF4EP07llk9tDZQia2uCxkzzsoSYwPYOvBlMelXH2sXjM5+ra2Soyni8RK08+MhynOIQB7welVG17Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MhOCOq+k; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MhOCOq+k"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-223fb0f619dso2428315ad.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 12:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745437248; x=1746042048; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4TIb8/cGcT5YOO6jpwMUaKc5ramXtbgTdB6E61EUK4=;
        b=MhOCOq+kgjJ1w/B6VUTEvW2Eh0AT2PHmL3fjNVwRD2FDBijbTFmndOZCBy8bCW3vTX
         ev2Jhl6b/lP71VpkS45nzFvaQqisgwxQN5d3yONDVokscUEuFw2lc0TqNGv0T7qto7Kv
         pBAKmTeI3Kgygmc0hoxlGVPVJ84pr/NKt4NpilNWQEp3dTW1/rQxLzNzuaGiWfdnKnHv
         WlU58yjvzC/w08I1exKSB50tIIAkFD8uO7OxiHAwvts+ZxBeOK3hJEK9SgHJvf8HFsye
         RJPHaX9I6YhKXhBozGGc2sA6vzhAE+PbBtrtttNDK8MhI2L1JDznMLV/jC3+KBDglXdO
         5xTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745437248; x=1746042048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4TIb8/cGcT5YOO6jpwMUaKc5ramXtbgTdB6E61EUK4=;
        b=p/Din6a4YZjMg7HBPu/VenEWFXdF8qPBhtoAOexiMCw3jflc9MiwohE5bOa+2CLQIx
         bqUQ+qobJMqb1RTY6nCU6BvujqA0c8xzapvw8qBYLMVDMsYYRAuroaifZQcb1wKWGTmO
         8LgZpjUSNHHMfSyIsNjkWAq1aUgFlKr2KYUAAMLNXKu1T2h8IdFUdFR1p8FmDofcPjCE
         XyMQh4hytAZU/G6stpd44HddoL+6fb2VCnPkz+3czGgdaGwhcQAX9l41jn2rhFFY5HQC
         aPpYEGUnppUJqYCFLBV8I8j7Lwgz0LfPDE5/pZHHJle08azYoh2ljDRIKXzLHxRmL2j6
         4NXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZN5VXpdx9+y2dxaWuRUVUfBPOuobkTRYr4H0u3N2snMdtQ+FqMGS740yNyPUbqZQL7/qb18g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+L8rus2nIGZSUzLfK7NWOh0Dd6xCJTN/h4lcIwyBdYxCgE9An
	6ugOIRYNEBOweIYVi1Q/EuHrtDoFtPzvG4OywtSpLSlDXDBLPlhX
X-Gm-Gg: ASbGncsMOBzQT9VUe62eO5yptuL42xUnX+5QViudf74RX6xNlhSjn4jwtFJSGI7LbqM
	tHZQJR7A1UwJJYA7+B8Ka4ve1ajPC9vrxqfqf0GFYExEHLrZEw15YvDSu3lSXm5fGDwZ2Z4lFm9
	yusUOMyGT/gqHUSlqLG7RpNHf6ArSflz+ujNGJh+IxgUawr3uKGFEkWg8u5FVuE0VyJDITpQFOK
	Lfg8Zjv81K4zBhDegf28xCS0OPjjwuFupRLPgFHAgG4lOiD3Oyy3PQdv/1EMa2WLc/6x4eyEP+r
	txUSJQ0489eqpQms4BB/wdv+yuSEJ/ksETtPNUhn
X-Google-Smtp-Source: AGHT+IGJTj4t3YyBeTpu99dqNzdz4h1Gumsi9bbZoo/nwDcyxygthxC2epv2+Ql+pGJESwDyMuUhMw==
X-Received: by 2002:a17:902:d492:b0:224:1af1:87f4 with SMTP id d9443c01a7336-22db1aa28a4mr9176975ad.22.1745437248148;
        Wed, 23 Apr 2025 12:40:48 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50fe0976sm108905785ad.245.2025.04.23.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 12:40:47 -0700 (PDT)
Date: Wed, 23 Apr 2025 15:40:45 -0400
From: Yury Norov <yury.norov@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Marc Zyngier <maz@kernel.org>, Luo Jie <quic_luoj@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, andrew@lunn.ch, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 4/6] arm64: nvhe: Convert the opencoded field modify
Message-ID: <aAlCPZQtFjr4F-re@yury>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-4-6f7992aafcb7@quicinc.com>
 <86r01rjald.wl-maz@kernel.org>
 <aAJsaNdznnz-1qap@yury>
 <aAkn8lvzoa1grdkt@shell.armlinux.org.uk>
 <aAkw-tFctkk3xyS8@yury>
 <aAk7VqNOLujcyZS0@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAk7VqNOLujcyZS0@shell.armlinux.org.uk>

On Wed, Apr 23, 2025 at 08:11:18PM +0100, Russell King (Oracle) wrote:
> On Wed, Apr 23, 2025 at 02:27:06PM -0400, Yury Norov wrote:
> > On Wed, Apr 23, 2025 at 06:48:34PM +0100, Russell King (Oracle) wrote:
> > > On Fri, Apr 18, 2025 at 11:14:48AM -0400, Yury Norov wrote:
> > > > On Thu, Apr 17, 2025 at 12:23:10PM +0100, Marc Zyngier wrote:
> > > > > On Thu, 17 Apr 2025 11:47:11 +0100,
> > > > > Luo Jie <quic_luoj@quicinc.com> wrote:
> > > > > > 
> > > > > > Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> > > > > > - reg &= ~MASK;
> > > > > > - reg |= FIELD_PREP(MASK, val);
> > > > > > The semantic patch that makes this change is available
> > > > > > in scripts/coccinelle/misc/field_modify.cocci.
> > > > > > 
> > > > > > More information about semantic patching is available at
> > > > > > https://coccinelle.gitlabpages.inria.fr/website
> > > > > > 
> > > > > > Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
> > > > > > ---
> > > > > >  arch/arm64/kvm/hyp/include/nvhe/memory.h | 3 +--
> > > > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > > index 34233d586060..b2af748964d0 100644
> > > > > > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > > @@ -30,8 +30,7 @@ enum pkvm_page_state {
> > > > > >  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> > > > > >  						 enum pkvm_page_state state)
> > > > > >  {
> > > > > > -	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> > > > > > -	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> > > > > > +	FIELD_MODIFY(PKVM_PAGE_STATE_PROT_MASK, &prot, state);
> > > > > >  	return prot;
> > > > > >  }
> > > > > 
> > > > > Following up on my suggestion to *not* add anything new, this patch
> > > > > could be written as:
> > > > > 
> > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > index 34233d5860607..08cb6ba0e0716 100644
> > > > > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > @@ -30,9 +30,8 @@ enum pkvm_page_state {
> > > > >  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> > > > >  						 enum pkvm_page_state state)
> > > > >  {
> > > > > -	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> > > > > -	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> > > > > -	return prot;
> > > > > +	u64 p = prot;
> > > > > +	return u64_replace_bits(p, state, PKVM_PAGE_STATE_PROT_MASK);
> > > > >  }
> > > > 
> > > > This is a great example where u64_replace_bit() should NOT be used. 
> > > 
> > > Why not? Explain it. Don't leave people in the dark, because right
> > > now it looks like it's purely a religous fanaticism about what
> > > should and should not be used. Where's the technical reasoning?
> > 
> > Because enum is an integer, i.e. 32-bit type.
> 
> This statement is false, in this case.
> 
> The kernel currently uses -std=gnu11, and GNU tends to be more relaxed
> about things, and while the C standard may say that enums are ints,
> that isn't the case - gcc appears to follow C++ and allow enums that
> are wider than ints.
> 
> $ aarch64-linux-gnu-gcc -S -o - -std=gnu99 -x c -
> enum foo {
> A = 1L << 0,
> B = 1L << 53,
> };
> int main()
> { return sizeof(enum foo); }
> 
> Gives the following code:
> 
> main:
> .LFB0:
>         .cfi_startproc
>         mov     w0, 8
>         ret
>         .cfi_endproc
> 
> meaning that sizeof(enum foo) is 8 or 64-bit.
> 
> If B were 1L << 31, then sizeof(enum foo) is 4.
> 
> > Now, the snippet above
> > typecasts it to 64-bit fixed size type, passes to 64-bit fixed-type
> > function, and the returned value is typecasted back to 32-bit int.
> 
> In this case, the enum is defined using:
> 
>         KVM_PGTABLE_PROT_X                      = BIT(0),
>         KVM_PGTABLE_PROT_W                      = BIT(1),
>         KVM_PGTABLE_PROT_R                      = BIT(2),
> 
>         KVM_PGTABLE_PROT_DEVICE                 = BIT(3),
>         KVM_PGTABLE_PROT_NORMAL_NC              = BIT(4),
> 
>         KVM_PGTABLE_PROT_SW0                    = BIT(55),
>         KVM_PGTABLE_PROT_SW1                    = BIT(56),
>         KVM_PGTABLE_PROT_SW2                    = BIT(57),
>         KVM_PGTABLE_PROT_SW3                    = BIT(58),
> 
> As it contains bits beyond bit 31, and we use -std=gnu11 when building
> the kernel, this enum is represented using a 64-bit integer type. So,
> the casting to a u64 is not increasing the size of the enum, and the
> return value is not getting truncated down to 32-bits.
> 
> > Doesn't sound the most efficient solution, right? On 32-bit arch it
> > may double the function size, I guess.
> 
> Given that there's no inefficiency here, and that this is arm64 code
> which is a 64-bit arch, both those points you mention seem to be
> incorrect or not relevant.
> 
> > But the most important is that if we adopt this practice and spread it
> > around, it will be really easy to overflow the 32-bit storage. The
> > compiler will keep silence about that.
> 
> Given that in Marc's suggestion, "prot" is a 64-bit value, it's being
> assigned to a u64, which is then being operated on by the u64 variant
> of _replace_bits(), which returns the u64 result, which then gets
> returned as a 64-bit enum, there is no issue here as far as I can see.

Ah, OK. You're right. On the other hand, enum is a bad specifier here,
because this thing is not an enumeration. It's clearly a bit structure
that reflects attributes in the page table record.

This enum confused me (and probably others), and could better be an
u64. And because this is really the 64-bit storage that tightly coupled
to MMU layout, it should be a fixed-type, and should be handled with
u64_xx_bits() functions.

If it was a true enumeration, something like dma_data_direction or
ucount_type, or if it was a true native type like long, using this
u64_xx_bits() is not optimal.
