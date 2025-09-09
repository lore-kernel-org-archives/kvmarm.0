Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54B4335BDA
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 13:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757423451; cv=none; b=BaFuDxr4bSXTJ1zq87rwsR5EvIswSZxZ62aartxdFeucHbZV2as5HFVf8CyEHzLPEbfT0vZ/5w3exWgGBQsQcb3w7R0Xgz0dD36KHAN6u47gJ9UXjU6JYl9afgIk+LmsOkR7I1LzlDxVJuSVdATGDPbEUhpSC3hktSyPmIk1zmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757423451; c=relaxed/simple;
	bh=bbl4DyFXk0UG+eC+k504rCf9NHkV4gzzBz1QQDB5SeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZD3KcQcFWkwR7iuJ6XCSVPyWVY5LEpF0MNQYigA8vHS+Y1YCdqABZPPjZvj0orikhjqC2RKk98msIxKztHmvjk0N5LjvBdPjGVclz3BDfapUFUmSxfMoCXLIiCQDjUHlwV/7IvKfuQO2ctS9jsuTfYzwm0OMEUgm6wxGY5IIyyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T4uCGy5H; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T4uCGy5H"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45de2856648so168265e9.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 06:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757423448; x=1758028248; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6mSkBMDtmSXT+SD6Rqrl6ORDllRpYLgcACmxMG0DYZs=;
        b=T4uCGy5H8eb/Evjj5CKF6y/Op05euYypVtRPVx8qNyUtzcj8kEd8sgwm4R52P5fdKt
         2LzilhUKeYhSEeGT+QmWhiHYmM1svFwvXj9vemv81we6TEDSQv7dqJnT0TQJ7iegOuT3
         grSHldapVa9jugbooYvSgUBzPAnY2YEGaM5acqGOCzjOWo8o8V5VSxY/eeL49cP0RAnQ
         1gAWcRJlU2tdBvPaFve5mtAu4OJGX3vLfTJ0uyON8xaHbaCrQx70dK1cgNJ1WeNdlos3
         FqZ9xIA1I4kQ0wPmhloBMlntNz5NLicl23UAblbq2hSG8EX7vPtotjdLGugdGTT51SPs
         8P9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757423448; x=1758028248;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6mSkBMDtmSXT+SD6Rqrl6ORDllRpYLgcACmxMG0DYZs=;
        b=inXwTMPr68vHSVdaiRfIzg44evHaFuPSGj1+osGbICdJBooxDGmXmt1nkY8EreJiAs
         9fFItlMmCNCqOiSPY915IWqAu/V0KCzTQIf1IkgifknId8739Kl+/OuheKJe7Sx2KlbX
         /MXwH+5jWp+jdEqhF3sJbYZw7h/lrK9sQQE/FWa1IYonC65h5FXlwYIB+KB3LLPdSuH1
         jp/DyaDG8hxLpLm59q9tW+ck4ix6jEQOGgMFnms8n+3N9IVQw0MUtSL28kny/vBELTO1
         hJYozAR6t0+fNowQiI8xI348oXNNuZENM0aI9lbZOwRatOgqKRdJYqrn0iXJDc36BiiB
         aAJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1WQOEVkgLAqMKuZjjpD/XCmpxnmfez6+p5l+aO9cprXhyTXKKYnfkaQTgmx6VW1DuukNkyEM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDQMi+TqinfafwRRC3Jg5Tx4I6FCqQVFBZ3BU5R6UkS928XZ3R
	+vcPjBPP6B2mCR4IMgxpQ88N/AWnDx/elPvXwcEYWxpHF8SHeBaTHQaVxNOHVCraew==
X-Gm-Gg: ASbGncu0fpybWbl1eogMzci7szVNtAFnGqUGTy0iXpanu7F71RBEjrYwdUUZ3XhjYrG
	mR3p+EswIm7ZrCoIkOsI2IwtZ0wXJ5BLZH1xUR2eR1YJd4VhO6s9lmaO8arTeX15l7yljecmam0
	Qlm/2pMXyKuQwnsK0aTO/NjDVe/hGZtxZ+4NW1DjswyqAUcugOK/sggD0zP5QjjHTUWzHKoRk2p
	E9LpaIVTdzBBJQlCdKQnUh4goFENJYrpd+6Fz56aJ0Epe/beWCmVpDcCUajJkdHYfE6jtZHU4wq
	pm6RFS5EZqnypG2gtxvAahS+W4J07ZHLTmIHpbo4VBAgiODAEOWr/ASg6YVNNcMagwBU8CKYbhx
	PAh+3Ry3fhMv+EYRGa1iKIdE4Ovn5a75wQKUGW5mwUju704VTZhanBrV5JzMVcZvw8qY=
X-Google-Smtp-Source: AGHT+IH+u0DJgHIFy6cMKe7xSpOobqzObKFJnY4/liHGfEZfRkJ/HR3MdmvlukXa1RXp5MtkjRU4Cw==
X-Received: by 2002:a05:600c:1c81:b0:45b:9bcb:205 with SMTP id 5b1f17b1804b1-45dde17da47mr5535315e9.5.1757423447377;
        Tue, 09 Sep 2025 06:10:47 -0700 (PDT)
Received: from google.com (26.38.155.104.bc.googleusercontent.com. [104.155.38.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dda2021dfsm178871185e9.24.2025.09.09.06.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 06:10:46 -0700 (PDT)
Date: Tue, 9 Sep 2025 13:10:43 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 1/2] KVM: arm64: Dump instruction on hyp panic
Message-ID: <aMAnU9ddUZPvjZIJ@google.com>
References: <20250717234744.2254371-1-smostafa@google.com>
 <20250717234744.2254371-2-smostafa@google.com>
 <aL7JLbljvX1JATP3@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aL7JLbljvX1JATP3@willie-the-truck>

On Mon, Sep 08, 2025 at 01:16:45PM +0100, Will Deacon wrote:
> On Thu, Jul 17, 2025 at 11:47:43PM +0000, Mostafa Saleh wrote:
> > Similar to the kernel panic, where the instruction code is printed,
> > we can do the same for hypervisor panics.
> > 
> > This patch does that only in case of “CONFIG_NVHE_EL2_DEBUG” or nvhe.
> > 
> > The next patch adds support for pKVM.
> > 
> > Also, remove the hardcoded argument dump_kernel_instr().
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/include/asm/traps.h |  1 +
> >  arch/arm64/kernel/traps.c      | 20 +++++++++++++-------
> >  arch/arm64/kvm/handle_exit.c   |  5 +++++
> >  3 files changed, 19 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
> > index 82cf1f879c61..0d7e86a95d62 100644
> > --- a/arch/arm64/include/asm/traps.h
> > +++ b/arch/arm64/include/asm/traps.h
> > @@ -30,6 +30,7 @@ void arm64_force_sig_mceerr(int code, unsigned long far, short lsb, const char *
> >  void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far, const char *str);
> >  
> >  int early_brk64(unsigned long addr, unsigned long esr, struct pt_regs *regs);
> > +void dump_instr(unsigned long addr);
> >  
> >  /*
> >   * Move regs->pc to next instruction and do necessary setup before it
> > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > index 9bfa5c944379..d692c05e3686 100644
> > --- a/arch/arm64/kernel/traps.c
> > +++ b/arch/arm64/kernel/traps.c
> > @@ -149,15 +149,11 @@ pstate_check_t * const aarch32_opcode_cond_checks[16] = {
> >  
> >  int show_unhandled_signals = 0;
> >  
> > -static void dump_kernel_instr(const char *lvl, struct pt_regs *regs)
> > +void dump_instr(unsigned long addr)
> >  {
> > -	unsigned long addr = instruction_pointer(regs);
> >  	char str[sizeof("00000000 ") * 5 + 2 + 1], *p = str;
> >  	int i;
> >  
> > -	if (user_mode(regs))
> > -		return;
> > -
> >  	for (i = -4; i < 1; i++) {
> >  		unsigned int val, bad;
> 
> I'm a little worried that this function might be used to try and dump
> instructions from userspace now that it just takes an address.
> 
> Maybe we could:
> 
>   - Keep the name unchanged, e.g. void dump_kernel_instr(unsigned long kaddr)
>   - Inline the user_mode(regs) and instruction_pointer(regs) calls into
>     __die()
>   - Check is_ttbr1_addr(kaddr) in dump_kernel_instr()
> 
> WDYT?

Makes sense, I will do that and respin v2.

Thanks,
Mostafa

> 
> Will
