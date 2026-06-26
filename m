Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199193E3D89
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782460132; cv=none; b=W2T5u33vakOdkiVacerMGxRyItVFHYDEuTY/U7mbRMjJ/cCy5KydzturJaO2oUulC4mFA9CcU0uTcm39Ln5Ykf3cDZo1IZlukJV+eqrYZ4ikZ8jazi/oRLDnOtNOpAqXbwnbCwJaDS5DPs+B+ryHP4BA2RABW5UTL7UYPzrIcDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782460132; c=relaxed/simple;
	bh=+eNgUr5YUqNfYwGiirS2Nnl3zVmfu1/bLUCX16l3Okg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qp/Wcrsiv1L78IS+mjyaE3u3xisnFgUR+WMUEGOelY4vJWcWybNfbDNZEufucuVtTQrFzgLCB7rAHWyaFXlZJjvyaj9+8AFhVOyjuhT28TRKauXE9MRk2Ef0SRqWkdy2V154UNqRerWs3fgvvHMnqzfi5P69t1SQAq+ka86ypbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FxS4BbI1; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FxS4BbI1"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4926e5803e5so4265e9.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782460129; x=1783064929; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sviuXWEudL4Lc2OsPUzpYG5n9t6uIjHNaWvGJZaU1Ew=;
        b=FxS4BbI1N/MBEs5LyGUOibALGkxR661Smu+TAHotGHI2pTSpqaOpxOWCT66k2JlVj2
         AGNuCxX8+Zb7gkqXiJRTr3UwApS5jMjWYSH/xVWUNan4rfJMSJBtVqbgetkbFtcNOsom
         3rV9fHmiMy96KO3zcv20bIcmVStjbjfnMF6WMC6VsmcEG2RfGLSW8C4UkG+em3NWlYyH
         mLBYjypxY+GcK0T0SKpDc7CYpyS/lrTQVU9c0rgKe4wm8vG40/CygcVB+Y59FPjKvzcC
         MPvrszPneNqVqeIVN3zhwYV+l6ZR4TsNPLT5b61KplSDGLyug+HDCaT0SVm4HfFex3xO
         Sv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782460129; x=1783064929;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sviuXWEudL4Lc2OsPUzpYG5n9t6uIjHNaWvGJZaU1Ew=;
        b=ghUj6pysC2ubLLPY5eU/JUO4ympyyASoldRcA+8J+MbSjxUHpb/EjU9OMnObpEG8TE
         bClxJvl7dCmdgvCCPjdMCA81L8gzZupgYaPVcbKxxLmbfyeqSJl0lQOtAllMR/5K/SN4
         /rfnb+b0/VJIn60wL52NNwHomHi9nkl0MMg5K8w9QE4GHHzIDBt6alOPo8Fr/uM5wN0P
         1LPuEc06Z+Yf4O3jI5zZEOeRIquWHquhHbEenCBpBcPYFLTZsVj/ChC+s6bu3l7IYuKT
         2//0qCzAQPeAtgXVZqKXhXKsvSH6jRkfft8bsczFIqYjosEG5kzaM/Ls0DHtD2fF7ZDs
         7qow==
X-Forwarded-Encrypted: i=1; AFNElJ+OPfkmw2nxL3I2JhjEZ+XabAmUxU2fn9JowOM1w9sB7ydAD1yxURwI7zDfRKh0vCkMae+5Z3U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxiieWyyLkBSzpbR8awpuLJcVg5rEJy+kfzySJK8m8d8SxchnLt
	DoCk71x91zJpRdA2xT9fWq7vXhn9R4wTDnMAe7wt3kRzV7xCv6xnMUJ4I7PxhIdWiw==
X-Gm-Gg: AfdE7ck5wrseOyiR34Mh7d7xttiXMFP/ei3MrzdFsZXCPA3bGvRyih7g7P+E5LNE2Rf
	TWORroSQO1wHzt5JTgY/PEIC70mTMaK0+DlsOOxAzl5pj5DV98JU49rNrifPXGTZnS9g/kepbXK
	dIyNEcGDQVLctPbO1mfbEaWPvSchV5jKc0niz8yuosqJAEBBeF5yN3MMNKlLcBnZFMG7LRN/gZG
	w8TeymlMMVIeByZHyU9X36zBYzifZo38zUsernTFdWi+aMH3rEeIu9Ql5rexDKN18Fphmf6i79z
	mdgKCE2EvuhDBP7/Brt7P3T6YQY+v+FW1AnvPcNc6dIpHfM/AKyUbHd2cyzq4syq0Jj6dG+uaUu
	fOTVNeTrwxXXbEjI4KTpqCqzm59zAVc2mpLrLm5y73Kq2sx2cXYx31lQSXJWmgdkKDEd6QODjwd
	C14hspI+0980brEsW4jAaW1PKjtdlwlB2DAiFfEBIayvwbvQtrMZBW8issaes=
X-Received: by 2002:a7b:ce17:0:b0:492:43a3:2fd7 with SMTP id 5b1f17b1804b1-49269ed6ba1mr786145e9.0.1782460129056;
        Fri, 26 Jun 2026 00:48:49 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49268ff9f40sm57920045e9.6.2026.06.26.00.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 00:48:48 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:48:44 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v5 1/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <aj4u3L2RrUDJpmjp@google.com>
References: <20260623115354.632361-1-sebastianene@google.com>
 <20260623115354.632361-2-sebastianene@google.com>
 <aj0qOFO3pRA-U_mL@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj0qOFO3pRA-U_mL@willie-the-truck>

On Thu, Jun 25, 2026 at 02:16:40PM +0100, Will Deacon wrote:
> Hi all,
> 
> On Tue, Jun 23, 2026 at 11:53:48AM +0000, Sebastian Ene wrote:
> > Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> > arguments checking when the hypervisor acts as a relayer between the
> > host and Trustzone.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 54 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 54 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1af722771178..78bb043b33ee 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -71,6 +71,20 @@ static u32 hyp_ffa_version;
> >  static bool has_version_negotiated;
> >  static hyp_spinlock_t version_lock;
> >  
> > +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> > +{
> > +	DECLARE_REG(u32, func_id, ctxt, 0);
> > +	int reg, end_reg;
> > +
> > +	end_reg = ARM_SMCCC_IS_64(func_id) ? 17 : 7;
> > +	for (reg = first_reg; reg <= end_reg; reg++) {
> > +		if (cpu_reg(ctxt, reg))
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}

Hello Will,

> 
> Seb and I tried taking this for a spin on some Android devices and, sadly,
> it leads to fireworks. The reason is that the FF-A spec quietly changed
> the list of unused parameter registers for 64-bit SMCs from v1.1 to v1.2
> of the spec so that pre-existing calls were affected.
> 
> For example, in v1.1 a 64-bit RXTX_MAP only has x4-x7 as MBZ, whereas in
> v1.2 the same call has x4-x17 as SBZ.
> 
> We can follow the spec by predicating the additional check on the FF-A
> version being >= 1.2, but I'm not hopeful that existing drivers are
> compliant. I also suggest moving this patch to the end of the series in
> case we need to revert it.

I spinned up a new series (v6) which moves the check at the end of the
series and I made it so that it takes the ff-a version into account.

https://lore.kernel.org/all/20260626074545.433234-1-sebastianene@google.com/

> 
> Cheers,
> 
> Will

Thanks
Sebastian
