Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6633D669C
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444600; cv=none; b=Kif5tisrg9delZ6r1LJoHpdHV/veBthgq+huXu9iYwCJT4TQjEmurCIlRS5uVDDvpgSzjxdAh4V1LawGYpitcFbhTgpQWGXCqHXQJqA+rH+ndEqtij5mP+AurAZCzP2BI5Se865HPtA0PmFJPKIZOAYJ4Ri1DsFxvF4ugn8X0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444600; c=relaxed/simple;
	bh=IJMUxVzOuu6ay4m9+ykWmSS4mUrDrWUCW8I6VkAhR7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN94/h6E0HGcR2x8WWLEfbkYakBuX7HL91+lqHJ2oNIsIbigQp7cYhCSQ69EH7Llp2r1M+g1rVZIaAAzMV65Ldd7yQUPb4powNifGPgGUUQLcRrew7rPoSVUN807PEvnpcrAH0pdqylmDolYYR0wgGkukqfJi24anyNVyK1B9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NmN/ZHRK; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NmN/ZHRK"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486fb990b9eso79895e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 06:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774444597; x=1775049397; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dEAJKbeH8TFmmP9M//aSv092zDua7ieyLEIFGIIxFO4=;
        b=NmN/ZHRKiVLw4EiO1VMyYtYAvD1vzH0MJGmqCB5c+PorL7sTrw+C2KIlX/xE0z8CJc
         g97BHH+NZhJfvHruqZsMptq9tw8ewVU3UFFCy+KRTmLGbu/FhKlb+Ej47Z7Bnl9j+6Oc
         dKqP9UB++Nvb2HRveCRgjU/jugS+vmAZfG3MQ0zL9d0kCZBE25tR5s6sc7juUOo6c2BI
         YDcpq4ueDBv4BD3/L1era26ptpMwSAiYyff3BUCwJMZC1nXz9nx0uf6LuRgvMDcy011P
         3+aV/xNl/Ld5rU/MSE1g//tMjOD1l+R5Y/F2WEHoOeJBbsL0zRrTbi1O4rZ01qqdCeIS
         ucvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444597; x=1775049397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dEAJKbeH8TFmmP9M//aSv092zDua7ieyLEIFGIIxFO4=;
        b=WTqY1/bWIfnXL5O3o17FRYZmYbPyUHv8MkTn1VZxyY1z7LJZ2RMvhtEC4429qVn+M6
         KWcfENiVvqoGYLmp8oAhW7ktTT0q6fHfvduvZ5uBfnLPnvvgO5G14PzUSgprfXLGJa6R
         sCN+YNSAPb4GOxgX1i8UpUVxXRYnNVDbhVOHmbJY58RlyK3D863hYLSESuv/pVZr+b5q
         etKHNfNkT92HPGSrV5/iQT97U0KHXAt1NDIQU9Zyqx3QrIHJIq4O2TGuJe8vsWx8lKm0
         refioYJujAMI0nn9DRWFDl13IGMJ1mjsW1mFsgrQRSDtbSeJehyDNcyNquH+pLP1aJlK
         yVWA==
X-Forwarded-Encrypted: i=1; AJvYcCUcmFilbtsjhncwYzVWEi8c5LU6Bc2+FsBoK03u9eCg35joAuoi0KJSDtbr7M0yRYDD8pUzL7s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZ2JfNq0lPeCO9xP3RfyFLZxV8cPOD4zD5f5XBUB/YPbq+2smr
	Rqi44pbnxafl1lQ58akchXccCspZ8mAPK1CGQcTAPY9wbBAM4BahfEAwFAhO/wa1sA==
X-Gm-Gg: ATEYQzzKVnqnMTY0OUcwe5pG+5ciQHRoSXy20WC3L+B3URCsIlnC8iwW8im+oFq/0Hc
	Mp8fZAtIkTP/Tn7qrY6pqEuPAJKlORy9RpYrnEVp8W4vEdHe1ImFcM36TUCFwyWo/Fotji7+4Q/
	joqL3b8Ih8geIKyD+KLPxO8Tc9niEtaoTzNbSLQyiJYk9awQmQdWLgCFLizK4vIeB+0qveVXuOw
	Ru59c+fGMSImJQf0epbWROHLwPB5ZB6YnzkC4amRXwIwttDq7SIgBKqnbTwVvGq6XowheGho93E
	h9Kj25vqR+yENxtpOaD1xMAVjv1L5Qho138GjTTtEwFJuJko+ClctMzwJGWHaUbreftJy/EkDYl
	lq/+9dp4sp/qRd5BacgPRATlfOPsu+N14quXP2MMxdlWQWJCsc65h1Ko4avh8cNDVf5w1vTCYF+
	pwEzY9N83k5ILyrmUHg95JflokJrc6xzj8UyAoNr8z6ksQols8LyOcDN3RGdwvU9sh/5c=
X-Received: by 2002:a05:600c:2d55:b0:47d:1e65:e841 with SMTP id 5b1f17b1804b1-48717896acamr410875e9.9.1774444596300;
        Wed, 25 Mar 2026 06:16:36 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b87f80976sm9851996f8f.4.2026.03.25.06.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:16:35 -0700 (PDT)
Date: Wed, 25 Mar 2026 13:16:32 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acPgMCuBX52LfnAH@google.com>
References: <20260325113138.4171430-1-sebastianene@google.com>
 <acPIdoA8oc7T8wKX@google.com>
 <acPJ3Z9hDKc0Sm2t@google.com>
 <CA+EHjTzeRiUvhDwAExpscWJfPNoRujeRAJ5dEDV4SMpOJK1K6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzeRiUvhDwAExpscWJfPNoRujeRAJ5dEDV4SMpOJK1K6A@mail.gmail.com>

On Wed, Mar 25, 2026 at 12:16:17PM +0000, Fuad Tabba wrote:
> On Wed, 25 Mar 2026 at 11:41, Sebastian Ene <sebastianene@google.com> wrote:
> >
> > On Wed, Mar 25, 2026 at 11:35:18AM +0000, Vincent Donnefort wrote:
> > > On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> > > > The ARM Service Calling Convention (SMCCC) specifies that the function
> > > > identifier and parameters should be passed in registers, leaving the
> > > > 16-bit immediate field of the SMC instruction un-handled.
> > > > Currently, our pKVM handler ignores the immediate value, which could lead
> > > > to non-compliant software relying on implementation-defined behavior.
> > > > Enforce the host kernel running under pKVM to use an immediate value
> > > > of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> > > > error code back to the caller.
> > > >
> > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > ---
> > > > v1 -> v2:
> > > >
> > > >  - Dropped injecting an UNDEF and return an error instead
> > > >    (SMCCC_RET_NOT_SUPPORTED)
> > > >  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
> > > >  - Updated the title of the commit message from:
> > > >    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
> > > >     smc with imm16 != 0
> > >
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > index e7790097db93..4ffe30fd8707 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
> > > >             handle_host_hcall(host_ctxt);
> > > >             break;
> > > >     case ESR_ELx_EC_SMC64:
> > > > +           if (ESR_ELx_xVC_IMM_MASK & esr) {
> > > > +                   cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> > > > +                   kvm_skip_host_instr();
> > > > +                   break;
> > > > +           }
> > > > +
> > >
> > > I wonder if it isn't better to move that into handle_host_smc() as this is part
> > > of how we handle the SMC after all? (and it calls that kvm_skip_host_instr()
> > > already)
> > >
> >
> > I was thinking of doing that as well but I prefer this since we don't
> > have to look again at the esr in the callee.
> 
> This is a non-trivial amount of code to have in a switch. Can you
> please put it in a helper?


Hey Fuad,

I will move it as part of the handle_host_smc(..) as suggested by other
comment.

> 
> Thanks,
> /fuad
> 

Thanks,
Sebastian

> >
> > > >             handle_host_smc(host_ctxt);
> > > >             break;
> > > >     case ESR_ELx_EC_IABT_LOW:
> > > > --
> > > > 2.53.0.1018.g2bb0e51243-goog
> > > >
