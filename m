Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3D423A9B
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 09:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781603871; cv=none; b=OuQZsyi7GOLHlkBdXLYKOfMssfQSoULZ0o1TUP3jxp+PldJYnTsQJY9keZyP5yKc093gdNBoIzpydMJy5PgUoThvEb28caXG1HxY0itdh+1487kcOWFNOtUAKIV29e/5fSBQ0qxUw70poBMCX0yChVUJuGx36AAPqJE7k2LuksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781603871; c=relaxed/simple;
	bh=PUb63S1DsjSv+XYUHC6kSPrVcco/9GIxqf0EmzY9fHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2QT0yY0aTKwSYv3ffRSa+/C3pyUeNkw5mXbzOmxlmC2cyMRbNg/RcqQzM0ec52XEa0psGd2TuxgTqzHIwlO14dqDdkY50Ofgv5f1SJ/GW+FZBWuu4m0YLkdkQbCrU3lvzC7S/i4DpTDcB2mK3Ekryh4u1F58yPLjFqXJVvMfmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K2ETvDnD; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K2ETvDnD"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490bb5ad3bdso36635e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 02:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781603869; x=1782208669; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ku/eYwMs4k9RlMYyzo8Mity0phIggrCvFlztJoPxNag=;
        b=K2ETvDnDxh1Asmb8/YOkJXfiR3Y0zLzwfz/jvTI28QPpsFQVQ5gWbHbmV6kHB9L544
         4EuXQ4W44SzwXFFU1BI7K3NkLBp9jLjg9ufVYI9EY8VaWKnB3rP200Yk6JMV7ZnK4akD
         QAPQTrYuI9PVlUtDWYC5noPyy2RTakFfp4X8tbZ7uksclJixr8tpq6dlq4v8vbSvcKTM
         LqQwdsFxST/VTDzU0oIZiN22R/381YfnEPQepqU1ArI1GfiBBOfM4CfxlOsfjQW65qyG
         bFnJ6JlffPoRoqjgNqpDqs1RvKel/UXsBpboXt7MMhGn2MBJOVH4AlQu46EPLDP9Spww
         ODwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781603869; x=1782208669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ku/eYwMs4k9RlMYyzo8Mity0phIggrCvFlztJoPxNag=;
        b=WZBPZyi/COA+3Lu8+QFytZEVh3cRPzZNlKvjyeJ/UJFi5dyaxTKR00dv3pOfLHepk4
         0VoKIBaDmr3w5Bw474dTE8Av20KH+HOpF61GaE8+PFe+dhtcuMWNXUAwUuuC9DiNs74w
         T5SrFUEe5qHtf28s+F0E45t6zFaqL8ROxsVDWrtMIYqsfbYCpf10YZoj3n9cVtYXu0yV
         jRYrR5Rlr9DuN2kdQopGBYCM8gK4mpfcDcXI3MHO8u0z9KCG02B78Eu53UzANDrUxLLe
         xSIrU9cp+Z0FbXBYSoUJkGmsE8YKt0nUNBQbR/3zU3wEdOTcfsVVBTohzcGB3Uh/Wk4h
         XT8g==
X-Forwarded-Encrypted: i=1; AFNElJ/REPSq3H1EELq2H/uXFanw+sbiNHdpw2m3QrmWo5OOznEPfDne3vYTDzL6Ls+7Sy54K1Z92ec=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPxcRnnVHbCtyrpSHbh13pXsHddqunDCenDpTOrZ8Qw0Uqt3dc
	Ufiz4gIz5ynh8iBVASk9Hc0hsoLcijVfGyRz3GNTwIivIiTBRRd6NhaD69VRWNvRAA==
X-Gm-Gg: Acq92OGuXi2RTbHan1FCnuqVnJ02QxAqY5BBWEm1MeKUaZZhlyh5KKR4QnHsqucI94c
	+JkxvnJxU/2qFulXBw6iik4nKaTVn69jpnQZXdpLfY62xmtSHyso+2esnEkYC3Uc7+2GG09bo/Z
	w/xfHcZaF+J5SR8mugcQc8kxjft6xekigI8IYDBSWRk/0By+DrWSimi7yOAu0Uw+l6OihKxM1du
	3JIjb8c5MFTmrJTaIdgy8Ubdah6M6wRrZQ/4G9B+Vm6ADEih50zx1VzMFIdz2culXfhiBE6OXpP
	tdFtXSlI/AReEegBDEGxEafoudbT4BkP2Zo0XdK5iOmqJTm43lNTwBXR83VyBVhhC0DlkoUqYo+
	JCmu6tMGJk7LKMx7aZuOr1SRsKAuYqIvo7Iiz0AsqWdqqm+5sKTLj6Jj/wCXdHoT0RviybhQey0
	Re+2OftrT5VvSpgJANfrLuFpkPKvm7TVvNnO0AGldoK+ugRsGhKlqhFGo224j/FaqCJ5PMfw==
X-Received: by 2002:a05:600c:68d9:b0:48f:d634:b18d with SMTP id 5b1f17b1804b1-4922ffc8997mr784545e9.8.1781603868080;
        Tue, 16 Jun 2026 02:57:48 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c473bsm47034584f8f.28.2026.06.16.02.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 02:57:47 -0700 (PDT)
Date: Tue, 16 Jun 2026 09:57:43 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ajEeFxNilwaC9hQg@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
 <aik5MtvOlnQDmzjr@willie-the-truck>
 <ailVcN-bxY30-XBF@google.com>
 <ailXKA1VG8vyKNfV@willie-the-truck>
 <ailtCAcEaJIgZ5Ap@google.com>
 <ai50fgNHGUqz0muP@willie-the-truck>
 <ai-tO-sSNGp7mjAU@google.com>
 <ai_KQTJj4n1dZS6F@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai_KQTJj4n1dZS6F@willie-the-truck>

On Mon, Jun 15, 2026 at 10:47:45AM +0100, Will Deacon wrote:
> On Mon, Jun 15, 2026 at 07:43:55AM +0000, Sebastian Ene wrote:
> > On Sun, Jun 14, 2026 at 10:29:34AM +0100, Will Deacon wrote:
> > > Yes, that part now seems to be missing.
> > 
> > I am a bit worried to apply for all of them the check from the relayer
> > (ffa_check_unused_args_sbz) because of how it's written in the spec in
> > (11.2 Reserved parameter convention). To be more specific, there is no
> > mention of what the relayer is expected to do here (which is what hyp
> > does). It says 2 things:
> > 1. the caller (in this case the host driver) is expected to zero out
> > unused args
> > 2. the callee (Trustzone) ignores the values in these registers.
> > 
> > If we enforce SBZ in the relayer but (1) doesn't comply with it, we will
> > introduce a regression. I left it on purpose without enforcing
> > ffa_check_unused_args_sbz for the others.
> 
> I think that's ok -- if the caller isn't passing zeroes when it should,
> then it's already on borrowed (no pun intended!) time and it will need
> to be fixed.

Ok, thanks for the confirmation. Will include this and then spin a new
version of the patches.

> 
> Will

Thanks,
Sebastian
