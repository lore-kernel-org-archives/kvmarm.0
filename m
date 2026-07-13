Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF4C3AD52B
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783930296; cv=none; b=X8Rdp+xfdQucBqZdQIPTmDpueeklL4RLOxTshW/ctgx5aGRGCHK5m4dHqu+F9vBTBxs9oLdNa64wXe2RcVULK3jPV2mJi5HB7MOVte6SaouILuhRo2lOWqfg51NpoJFuaxcuSJsLjLQkwS7rzdY0qGc1oTnor9W1CmNccv7/k7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783930296; c=relaxed/simple;
	bh=7fGvB6bzcOTWAqweHpDYYnksgwceMbol98TCrcOi5NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JvLfJZGXAq9B03kNPnJeBJ4FFPKEx9t67s/EiPwGytnXwwJOVWzopdR4ECjQRzEA7oIRkkUFX4bsFyNJkpOoM5oaWnXJxD1j8exlehqrX2XF58adM7EI0D9f0ZUWTInzBfGkkZpHi0yzWOQClRxPmvDN2MdbNk1IQ/NSZYcYjQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LPRv4EVu; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPRv4EVu"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493ba701891so26668805e9.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783930293; x=1784535093; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aajWRHDOthkA/KlC0AepuzgzDYNF7pkxm830mYVcHJI=;
        b=LPRv4EVur9FjwlPv/g5VRs/j48xqZYo83xSSDJapgTQoMxvEKWJCHUwrKdRx52FJ/g
         u13hghpfBjkkNDKEvt2jnmzplPXCTw7qJcLYr4q/6mQeUZXp8O/UDK9YGpbT4UGMFPhg
         puu1YUMUrK9qPYMkSD2rsUtAmUAAJVd0cLWPAiBCF2lWX3xGIaPlOxfPpA6zCoQRiMbr
         EGxRSK34anKlpyntI8ErtaKP53D5OSRMSUj2RTeK16ZqzwVNhZ6W74n65DcSt1RBb9UW
         62thUwZal6TUkcSLQG0QaW3HXPKtj64lKquuS1fSqVuIBM2V/O8XhnLLQJMJxZ+gSKPc
         Ai9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783930293; x=1784535093;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aajWRHDOthkA/KlC0AepuzgzDYNF7pkxm830mYVcHJI=;
        b=G6rJncPOm1P2Tf2Rq+6R3I733v8K0lGk0+DO1ZHocTfBDVchedKlczbhBv5BWgIWLw
         lNVoQggBA45Uq9NlRhwwggYub1lJaad8R+ZYPoZgWvLULK4hh8tK5HIdE1BlF8YkqXX2
         PxLYPtmu+2gpXiznxegHfbvxlLhBx81aWDE40ATpz6gtblK4sNRqftowrNGo79Y7rlqw
         hxzO2N50cPU9NlsTnizsOH7+Qfz6FlCrORel0f4X3324kGaS2zlh2pCyTYntVNh9eAB4
         DpfabVR/b4e4tFRXUkRsgM/xwA7vUL2fi/PmBcobuoOuKgiOa46CcuDVBsesXnicosEi
         GRAA==
X-Forwarded-Encrypted: i=1; AHgh+RpSWpeG9ISnagTVqh0kQe3XKo+zzvpaUy9ZFM3pbszrqH/tQyXlv/J+rmAcLUIshYfJ32qk0Zk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzV8tLf53x5uMh0hC9VO6wSnG9d71fTyBvo8B1LA3gw6QcloVfq
	TPQdCVk7YPTDOi19LI4eY32k+Eq4Yx0xq43S3BGX81khV6b+fzuriUNZn1shKQXaOA==
X-Gm-Gg: AfdE7cloMUxGYUXaLYGoLKzZh+sKsq9PXV4cJ0VbHAvU864MnOY9Y8AWBWdjNwlQGXj
	tFslcNgg7tHm4RAiFc+o6SMWsiGH/pV2kkUudraAEf7n2C94UseHSnzfPCxLDdmawagIh2Gkyp3
	LdJQMfwr9aRyr+Mbr5YSiTcOujmZOugcaxE3Ez0Cl5uVLC4fAisKXHbCtxLXndGi5q/Mu+TX7tQ
	SoiVRCb5iMErh5t4J5sIbzE5AgN/LyzYPCh/XJjnVbzYt19EM+m9pbgSUrBw12Yw16ilmnKDRpc
	rUi1cQX/GrMqJBIA91Ofo0azgV5LlpDxY8yCqhNHEa1Y7HRwVlSXSBFr07UAc+mXaE+S4279A7J
	vpI8YkEXu7RstPm+GI0WEJ2KMrqK0HGQlr5cGOeY3b7YdYzsZ2MzdVMU8v/F2viuYljBrGBhrq3
	b+A8znXyJQ3juhNYpL6oR6epr/4r8hmWXRDk3P7gUbk9rzHE9Z0HikUcXvT3gXKA==
X-Received: by 2002:a05:600c:6387:b0:492:3e69:a86f with SMTP id 5b1f17b1804b1-493f87d89d2mr74807055e9.1.1783930292492;
        Mon, 13 Jul 2026 01:11:32 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2c8de2asm255552645e9.1.2026.07.13.01.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:11:31 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:11:27 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Mostafa Saleh <smostafa@google.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alSdr9wNyyPiHmbt@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
 <alPox2BDk4Il0s9t@google.com>
 <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>

[...]

> >
> > > > I did not add Fixes tag as this is currently dormant and not breaking
> > > > anything.
> > > > ---
> > > >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
> > > >  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
> > > >  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
> > > >  3 files changed, 8 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > index 9f429f5c0664..c2ccd0e8bf22 100644
> > > > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > @@ -6,11 +6,11 @@
> > > >  #include <asm/kvm_hyp.h>
> > > >
> > > >  #ifdef CONFIG_NVHE_EL2_TRACING
> > > > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > -u64 trace_clock(void);
> > > > +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > +u64 hyp_trace_clock(void);
> > >
> > > hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
> > > already has a struct hyp_trace_clock and static helpers
> > > hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
> > > of the same clock. No actual collision, so this is only a readability
> > > point, but a reader grepping hyp_trace_clock now gets two unrelated
> > > things. Maybe you'd want to consider a different name, but naming is
> > > hard :)

If we were to rename: the clock is a "hyp_clock" so probably trace_hyp_clock()
is the right thing here.

while the "hyp_trace_" is the prefix for hyp_trace.c file content.

Although I would like to see why we pull trace_clock() from the kernel into EL2.
That bit sounds wrong and if we have a way around perhaps that's better?

> >
> > Yes, that shouldn't be a problem,  I just added hyp_ prefix, but I
> > am ok with any suggestions!
> 
> Didn't I say naming is hard? :) How about, el2_? Not really happy with
> that either tbh... but can't think of a better one...
> 
> /fuad
> 
> >
> > Thanks,
> > Mostafa
> >
> > >
> > > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
> > >
> > > Test: builds fine with the different config enables.
> > >
> > > Cheers,
> > > /fuad
