Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816CE1448DE
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516092; cv=none; b=aNxn0fy826kXduKO48rkbOldG3rrp3obgJS4655ZHaCL7AMq++SnJswfQARHnLYRD8idqZANY5PhOxwZGIlIQUM/LTjs3RwFS/r6hNUd9bY5bGGGAROuvdv4fbeLQWeEj88OzccgA66bM8e+j7XqZesGkK9mfRuflQGyAMUJWFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516092; c=relaxed/simple;
	bh=9jijODcLLa4zmqRhqLOhK+fqQf2gqdWVamK0zwZspgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOJNjjKTJZ6UNECZFQY7X/FJn44I0vtZnVQCYABjWnyfu1W8nHmguVy0dHCN49zvwmWy31jHMVbHV70T4I3MyLZfj+y9HDo1/y93MHM9wKD7m1zl3EZ1Jwd0aG7uHPJd7k7Od5yKqcLVxEMSBcR/r3sCxCLCxRhvOT3dZQxmSgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPFRkgwR; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPFRkgwR"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57a68b0a229so2396881a12.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Jun 2024 08:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717516088; x=1718120888; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VI9QUYhV/KkiBFZad3q1F1Q6NWjZ0fGxKdlSAnXosBY=;
        b=EPFRkgwRa0suqmdTTQtG+VRYGPsydOnfe1ymcXV4IpD1ljimd8GJ//bvomGI53b0r4
         kI5aCfhRTzBzA6/xnsBFl8AlLpWDaBc31X1X9mdeyNLIgBox6UkKuIPIPgoG0xxLBJa9
         JBRvRPzWUM5GM32LgAtH5xVsmiyzlRVysu97dPJA4uj0qhVvf7F6STlW5NlMA1M2Aokz
         g9jl+VKzCbV3UamyjlAp9mQ15fPI5/sYcC+PMxowt3puoasvulow6QkA3u/9R92lu3qw
         gxGfGxDz7GkKtF5yDLXDDx9iw9ZTDBiQoVNOIg9Hu1DUwAOJstMha2gS69Nh80/y3bmP
         7eRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516088; x=1718120888;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VI9QUYhV/KkiBFZad3q1F1Q6NWjZ0fGxKdlSAnXosBY=;
        b=NmBDtkVUr3IfcKGtgpGPiziJKNft31tcMgEa9TpSt1quL8K9yXM7YoxA14/Z+mV4nb
         zeB958CF9XeCzZtdjQVfId/jcHPBdvSXtw8+T4sAwfqcWPyxd47jys7E6QXwelhS4ARj
         oayIDov91kRu2By8BCLoXhLe5gO0lSPfXPcrm78LenPhRVspegsE19G0iJO2WFRRiBCW
         dwmEMiQkHWxcQzqoYLsxpSdmn/CIhrF2tE4MsaatK9V0mhc8c0D1Pe1w4/Pql/Gyafeh
         uj6O0Zo6I2NpnnK+rdSbDh0V82eNGMvSJGRmis5Ee+6mAl7A1v9wJC7GAODe1pbDcNgU
         CmlA==
X-Gm-Message-State: AOJu0Yy3Em87/N2V+6RGRjQj+KT2xPFCmY9j2nd+2atyy3StB1VTwEEL
	c/zBKfW8xYtjICSJSKX2kN+JStgPP//yBPoPwbPQUjvrvYCS+MPh60A8jbO4e0C5Ym+ymP5U07Q
	CWzZn
X-Google-Smtp-Source: AGHT+IFcdEOYIUvsNwOkrvSmA4o8vKrkPn2u1Z8aKrnP0GmKz+XZvtUMn7cgz/gxbmln8PCFDViBGA==
X-Received: by 2002:a50:a455:0:b0:578:6c3e:3b8f with SMTP id 4fb4d7f45d1cf-57a8b67c37fmr23084a12.2.1717516087560;
        Tue, 04 Jun 2024 08:48:07 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31be52b5sm7673564a12.49.2024.06.04.08.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:48:06 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:48:02 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 03/13] KVM: arm64: nVHE: Simplify __guest_exit_panic
 path
Message-ID: <qob5gnca2nte4ggkrnn4uil5mfbkz3p55lmk3egpxstnumixfr@lq7xomrhf6za>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-4-ptosi@google.com>
 <20240603143030.GD19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603143030.GD19151@willie-the-truck>

Hi Will,

Thanks for the review; I will make sure to Cc you on v5, with your Acked-by.

On Mon, Jun 03, 2024 at 03:30:30PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:09PM +0100, Pierre-Clément Tosi wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index 135cfb294ee5..71fb311b4c0e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -197,18 +197,13 @@ SYM_FUNC_END(__host_hvc)
> >  	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
> >  	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
> >  
> > -	/* If a guest is loaded, panic out of it. */
> > -	stp	x0, x1, [sp, #-16]!
> > -	get_loaded_vcpu x0, x1
> > -	cbnz	x0, __guest_exit_panic
> > -	add	sp, sp, #16
> 
> I think this is actually dead code and we should just remove it. AFAICT,
> invalid_host_el2_vect is only used for the host vectors and the loaded
> vCPU will always be NULL, so this is pointless. set_loaded_vcpu() is
> only called by the low-level guest entry/exit code and with the guest
> EL2 vectors installed.

This is correct.

> > -
> >  	/*
> >  	 * The panic may not be clean if the exception is taken before the host
> >  	 * context has been saved by __host_exit or after the hyp context has
> >  	 * been partially clobbered by __host_enter.
> >  	 */
> > -	b	hyp_panic
> > +	stp	x0, x1, [sp, #-16]!
> > +	b	__guest_exit_panic
> 
> In which case, this should just be:
> 
> 	add	sp, sp, #16
> 	b	hyp_panic
> 
> Did I miss something?

Jumping to hyp_panic directly makes sense.

However, this patch keeps jumping to __guest_exit_panic() to prepare for the
kCFI changes as having a single point where all handlers (from various vectors)
panicking from assembly end up before branching to C turns out to be very
convenient for hooking in the kCFI handler (e.g.  when saving the registers, to
be parsed from C). I also didn't want to modify the same code twice in the
series and found it easier to limit the scope of this commit to a minimum by
following the existing code and keeping the same branch target.

With this in mind, please confirm if you still prefer this fix to jump to
hyp_panic directly (knowing the branch will be modified again in the series).

Also, I don't get why the 'add sp, sp, #16' is needed; what is it undoing?

Thanks,

Pierre
