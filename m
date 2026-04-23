Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB836F437
	for <kvmarm@lists.linux.dev>; Thu, 23 Apr 2026 09:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776936553; cv=none; b=YgoZoT/u+Ui0IwdhaZRsS6sjvhLamhKE7EgA4VQSiVzxmbkDK6bangj+kM+iUPhHGQukjNkFgLm472bl3+14GkssplhUCByoKZmaXRF/COAR2nua4Ke2ucUbkshfwAs7hvTvEml5EaBjpu9CRuJrcq+eWzB4kfhv2hF2+3ZOoB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776936553; c=relaxed/simple;
	bh=GEojIYOirnzY4XB4TS8FhRxgruQ0ZVW9LyRhvu+i+RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6f5HzVrEyeEeZVKiOYmdNGr2JeDUFNZSjgg59RojssrgiR67bY8uByYL7ZD1pDGRxEVRR2eTsJ1b38/gngRSJ7qrH4A/QRcSe2FySPYiXQ/8s4MVvtam5r6na7ivsqicvrww+yUJ6eYDVLW97T/nKaArlXlpb9HHnwmbRc1SYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fDgYj7/y; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fDgYj7/y"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-671f1a0d0c5so54322a12.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Apr 2026 02:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776936551; x=1777541351; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BKpJvW7DhMmQGBTcK6buF1FQEMkYscuj/n2ufvkVhMQ=;
        b=fDgYj7/yeWqM1ejqhch4wqus+D0+8LfSUbiQF2EWfn2x/NzPbU1P3Opd+gNA4voWsw
         SFe2NytzM2EfsPTA3/gg89pMlAxK4kH812EQoHdeu47VGcwt31Suuh+qDa2g0JSpFSNU
         Na5A5jbjCDRoAbZhIFCqMGcN0KtTbksbsMR8hOmqEz2jRJKeBqZ6nHZV7ehOSS2XjUDI
         y6ma0rD7/CXiH6jOZ7qvMkzNbm2ByCZe3zFpX2UiFMator84HFjt6LbW7hwzvp1GuWN3
         mnBtq+ax7Jpo9nxA4fvlmXF//7X3K7XtsxEHhokqiSO4fuvffk0CvXZXBwncuK8ehjvA
         gk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776936551; x=1777541351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BKpJvW7DhMmQGBTcK6buF1FQEMkYscuj/n2ufvkVhMQ=;
        b=Jt6XJ6PNfX4QOpWRnfElZK0ROOqdnPWlvDDfyOr5yYgQ+tADfSLl9QkCJTRGnaB3pB
         3YqLGTk1/k7VsHmNCukVSW00HPF5W3Zs8m1J5Uk46YGFeYA945fD3AxGPK9l7p30xoxr
         fY5AmHTV04Vuw1k9dZSxBeO53545TsQlfCnyvO7uk6L29ejrCrWE6NUfEEkW7J5c6iyA
         IEiWkOeBiH7yrzvK2KZUzlJBwEo1mKYHeQQCFNDktvcqyM0Csa+oaW3SwpmKNQI5EZDm
         jZ+CDeiu+83zVKDcapQlL2joi4/uMOR14VAnIWxVtnkM50RQqiotY/gajoXZebNF1Ixr
         LJDw==
X-Forwarded-Encrypted: i=1; AFNElJ+riTlbR3+9wAwgDUXzB5iRybWY7TtmWuTjI9X/Nn94ic+qWQC3WgXzf9EuouhTd7mjIB1IXnw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqHk4KcRZjJavd1YYIPiwh4i0GShycZr9moTkV1F4aZAlzkVbN
	fR/iJhnHh1nlrLbekSNHWkASyScBYLW9BCCkuXRzyOgU5kgf5VL1cV01t6iy9y+N4w==
X-Gm-Gg: AeBDietvY2OlnHooK6UtMUCxazacsAnw1aoI+xyDowcL6WNv8H5AZ0Hx2ajHve2MXxM
	DrUc2f4iU26dnhtAnpjPx+98+NWj229WCql8S+VFzMDeqNFjxkx3ZaBg5S/Y9mofFSb8i37Oc47
	XjjrfVD6prIJlvHgrgs42kHLWyw/CqxWRUgrp+YtV4Fl2jMtz0wZlNRgzBwM+6zQw/VSlkkF7/h
	Z09WgN8lNyp8JHzsl6luSplyna7WkQ8Ywc5vVo7SyVQUfNxsFeV9FJPduauE+21Qkz1+oisytd4
	z8VdOmAa00Vy5KGH0c5HB1qvrd5dCcd6XgKOGCVrfeMkI6DGwZgJyHZWdJ1CL7aj5pFF8wwgkQP
	tSEXrXEhhoXmh6L9fUM65zKOIt06UhUWhXs1i+nkG2oIYdW4g0S0hPsv/e8gQaNE5o3gAYffQQZ
	3EWSaGdFDpJW5mhtRXf0HteNZSO4FE2uqUsh8FgiH6VDeDk51s1RhkIwesdGTtEv7XQuOkcswUO
	olZ5mScSwmpTAMXxA4=
X-Received: by 2002:a05:6402:902:b0:670:7177:94df with SMTP id 4fb4d7f45d1cf-67440714a81mr250309a12.6.1776936550235;
        Thu, 23 Apr 2026 02:29:10 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-672c4d5babcsm3890524a12.23.2026.04.23.02.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 02:29:08 -0700 (PDT)
Date: Thu, 23 Apr 2026 09:29:04 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, will@kernel.org, ayrton@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor
 placement
Message-ID: <aenmYK3Y4XcqkmI4@google.com>
References: <20260422102540.1433704-1-sebastianene@google.com>
 <86bjfb18v1.wl-maz@kernel.org>
 <aejOu98q1lEZoFfW@google.com>
 <867bpy14kx.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867bpy14kx.wl-maz@kernel.org>

On Thu, Apr 23, 2026 at 09:08:46AM +0100, Marc Zyngier wrote:
> On Wed, 22 Apr 2026 14:35:55 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > On Wed, Apr 22, 2026 at 01:24:02PM +0100, Marc Zyngier wrote:
> > > On Wed, 22 Apr 2026 11:25:40 +0100,
> > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > 
> > > > Prevent the pKVM hypervisor from making assumptions that the
> > > > endpoint memory access descriptor (EMAD) comes right after the
> > > > FF-A memory region header and enforce a strict placement for it
> > > > when validating an FF-A memory lend/share transaction.
> > 
> > Hello Marc,
> > 
> > > 
> > > As I read this, you want to remove a bad assumption...
> > > 
> > > > 
> > > > Prior to FF-A version 1.1 the header of the memory region
> > > > didn't contain an offset to the endpoint memory access descriptor.
> > > > The layout of a memory transaction looks like this:
> > > > 
> > > >   Field name				| Offset
> > > > 					 -- 0
> > > > [ Header (ffa_mem_region)               |__ ep_mem_offset
> > > >   EMAD 1 (ffa_mem_region_attributes)	|
> > > > ]
> > > > 
> > > > Reject the host from specifying a memory access descriptor offset
> > > > that is different than the size of the memory region header.
> > > 
> > > And yet you decide that you want to enforce this assumption. I don't
> > > understand how you arrive to this conclusion.
> > > 
> > > Looking at the spec, it appears that the offset is *designed* to allow
> > > a gap between the header and the EMAD. Refusing to handle a it seems to be a
> > > violation of the spec.
> > > 
> > > What am I missing?
> > 
> > While the spec allows the gap to be variable (since version 1.1), the
> > arm ff-a driver places it at a fixed position in:
> > ffa_mem_region_additional_setup() 
> > https://elixir.bootlin.com/linux/v7.0/source/drivers/firmware/arm_ffa/driver.c#L671
> 
> That's an implementation detail, and you shouldn't rely on this.
> 
> > and makes use of the same assumption in: ffa_mem_desc_offset().
> > https://elixir.bootlin.com/linux/v7.0/source/include/linux/arm_ffa.h#L448
> > The later one seems wrong IMO. because we should compute the offset
> > based on the value stored in ep_mem_offset and not adding it up with
> > sizeof(struct ffa_mem_region).
> > 
> > Maybe this should be the fix instead and not the one in pKVM ? What do
> > you think ?
> 
> I think you should parse the buffers as the spec intends them, without
> assumptions or limitations.

Ack.

> 
> > 
> > The current implementation in pKVM makes use of the
> > ffa_mem_desc_offset() to validate the first EMAD. If a compromised host
> > places an EMAD at a different offset than sizeof(struct ffa_mem_region),
> > then pKVM will not validate that EMAD.
> 
> Why compromised? Isn't that a perfectly valid thing to do? What I
> understand is that the FFA 1.1 implementation in pKVM doesn't match
> the expectations of the spec. If that's indeed the case, pKVM should
> be fixed to accept these messages correctly, or stop using FFA 1.1.
> 
> 	M.

Sorry, what I meant is that a potentially malicious host could abuse
this limitation of the FF-A proxy validation which is looking at a fixed
offset to do the EMAD validation. Another EMAD can be placed at a
different offset and it will bypass the validation of the proxy
alltogether.

We have two choices: the simple one is what this patch does (enforce a
fixed offset) or the second one : patch `ffa_mem_desc_offset` to use
ep_mem_offset instead of `sizeof(struct ffa_mem_region)` and validate 
the ep_mem_offset. 

> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks,
Sebastian
