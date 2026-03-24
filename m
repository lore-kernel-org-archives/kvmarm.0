Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFB14035B4
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364680; cv=none; b=W9hMzbZJlSQF3fLrIx8ca+wAii/WdM9hTfXrksFmZgHs0AxnBVSEjz8Q3ccZvEod8HcyVoM+VPxQlcI+1SDMlSNevJ+uyh5IcCTFxEjXpnl9wJU+rNo/7OED5By+JpBDVxVmO+QA684ZOoJA8w8J/ea5hv3BVG+sDB1ikFXIkLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364680; c=relaxed/simple;
	bh=hUPt1yzHQIdBr/atCihsNh26aSwnSxYLRego8dNIzJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqJkVAjYUxxez5lQIPi9uDzUdQd0kntLKhkhjemehq5DhoR9yGoOnT+ah5pVISVzYZtQmI5t8583PcUCGvCoJA8tpHIJOSVy6PxM468yYmLSMytzg/y+ktF/uaD8vCqBOpNOs12U8Gd3xAxahZ2j6ZBdRyyCkA6SWhcYi4uiwlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nOvpSQY0; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nOvpSQY0"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48569636800so77965e9.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 08:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774364675; x=1774969475; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x8Ez8KE3X9ncxAR8sxSpYM0vX0MuKytP0Jw8nmLk1y4=;
        b=nOvpSQY0mnPhHhdPyTNuvuFzgdNmuT4geRWkfunzjB+6cYHksxPcPZqTzRKukF6rVV
         dGy142M45z6SmRaSVpZPCWzdJZBRplkP4AVaijALFYTvopThwv7CAuEOuWx8YF7GyqJJ
         2BaOTQXAF/Pi4U7ksMtkWOaQX1yw+HxrJjfaKUkDaJO1NcFMlaN021/7aJn+hGt7S490
         liluhIoXIjWLnRSre7LtfWue7OEW78bpo0EytdmPYkKe3zyhji8dnyNPVXDNKKz1KJdn
         Ku7Tfjxi3VWyilfuT5uU9OJnvqscYY69Cd7XBGAh+PZJ+KlQnqF/8vVymQ4zVV7LfYFb
         TtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774364675; x=1774969475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8Ez8KE3X9ncxAR8sxSpYM0vX0MuKytP0Jw8nmLk1y4=;
        b=rn3EKF8FMTBtuaKNTFAwCdtGUQxMlDefMqWNtqHMQ9MHiRLkqgZBd8zqRoKb8UwdTa
         9e2r7FcDcFVljzwg5lp9SBl2WGpaIqFgUlpwyhlMCmt92J5Q5Hxehcmk5hjE7/A7u/lM
         rik7AcjwcrpG1BHB8f+t2/458Tmrp+t4CZyJWGhsCi9+HcFiAYizq5hGhOE1JrMqwOzJ
         YLs0LJGJwsgkRs6dNmV/kVbKCawDLazEZmuvNBZas8Q4T1pJuhjxQPoC40aep6A0Hm+/
         yYOQkePg4WHshY2ELfqiEWmHfBsiNoXlpLBrxK6zpkCzdVu+eiywcmTg98DnN8Nisk9X
         /GOw==
X-Gm-Message-State: AOJu0YxoninE1ultYLek+HuQHZQffAkbYIEM6mt0Z0QcXvUdzUmkWFHr
	ryfxAl9KJdiYc9R/HJDZvHz1sP0f22aP+9HwbybwTGhayVD01LT3uy4GN2m+BNU/Cg==
X-Gm-Gg: ATEYQzw5p7ksC9bEZPasMaS6/QF8KpFq2fNqESHc46GmDQ9TXJB0bWRmE4ljBCHI4nW
	U4HMkCQgx5FJKApvatU9khlkgCmC8rjforf0wpARGhmllhlgZrm8EhzqIRDFM/Yyh1feUm9/uZd
	q5D+tfEZyz2XBn+AJqSg1vgvIGUUn2Sqdm02c1B0cHuy4+jzeDuAOitar5sUaNi594jOLIGfjsZ
	k3BJo9yU0Lpp2FuyHJNTAexuk/VhMyf13qHf2JauQTMkhyNgYUW96wlX3r4KkE5trO7dZGPOA71
	H0WaecuNrX/HnaDEhdT2jYN6hCJVj/bsg9U0Tg/lsc8Ezq4ncYrsgF2x0nvKTVlgYk6oUhRw0ln
	GzbVmRlMhUDsvPzHOtn8PQN5XSw/bkacU2uNb/Whh4DgJ2gPe1QbqMnhUpqPawJZHd/urtfr1ZI
	Kol4/Of0+4/emkH9OCMYKA/E66117/bZEXcK21FPaHVyofbM+fScBspOu0ZnpnlQ/kLyE=
X-Received: by 2002:a05:600c:6388:b0:486:fd5a:18db with SMTP id 5b1f17b1804b1-48710f55c35mr1233335e9.11.1774364674685;
        Tue, 24 Mar 2026 08:04:34 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48710fd2c4esm38080035e9.4.2026.03.24.08.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 08:04:33 -0700 (PDT)
Date: Tue, 24 Mar 2026 15:04:29 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	oupton@kernel.org, suzuki.poulose@arm.com, tabba@google.com,
	vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
Message-ID: <acKn_ct-tmwxEwRB@google.com>
References: <20260324135728.3532400-1-sebastianene@google.com>
 <86tsu547ao.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tsu547ao.wl-maz@kernel.org>

On Tue, Mar 24, 2026 at 02:43:27PM +0000, Marc Zyngier wrote:
> On Tue, 24 Mar 2026 13:57:28 +0000,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > The ARM Service Calling Convention (SMCCC) specifies that the function
> > identifier and parameters should be passed in registers, leaving the
> > 16-bit immediate field of the SMC instruction un-handled.
> > Currently, our pKVM handler ignores the immediate value, which could lead
> > to non-compliant software relying on implementation-defined behavior.
> > Enforce the host kernel running under pKVM to use an immediate value
> > of 0 by decoding the ISS from the ESR_EL2 and inject an undefined
> > instruction exception back to the caller.

Hi Marc,

> 
> No, that's completely wrong. SMC never UNDEFs, unless EL3 isn't
> implemented. You can't just decide to generate an UNDEF because you
> don't like the immediate.
> 
> All you are allowed to do is to return an error code.

Thanks for letting me know, I will update the patch to do this.

> 
> Thanks,
> 
> 	M.
> 

Cheers,
Sebastian

> -- 
> Without deviation from the norm, progress is not possible.
