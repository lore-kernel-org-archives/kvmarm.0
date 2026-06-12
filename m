Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46AC371072
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 08:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781253725; cv=none; b=gy9nKiuOU5bVfI+3kL4KCdlB9g8qGUHDNx9RVcMlpuVoaYPWrzDZzqIv/ucVcUlEAnhKfmXzYpj08+898bKUW9E3eDr4DWffeugTvjnLNK2iFWseQHVtP3mDxsfiffhu0HgF5wUD5XiQRHm3LWH0536yLAQg/rGrrtdcp7A8Jqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781253725; c=relaxed/simple;
	bh=8t+oQ/MAeRgM9WAvXcEp1Dd4GJpKy0GTEo0AaN2ZQrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJIjZefmAky3l8vEF4j0rWC676gNGS3x2vHYLCftSwwEea/LKf/WmkAIvlzKhdQk+UiLf8zhCIVwc3Hhcc7GSDj+c7AebSsEfHzGOAV0gGYPIiV4j71QwHFL1lG4TsakUKRK2PajvhXcBcDEes335DzVq/flqNBlP+1QA1pGZ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dZ5DhSMy; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dZ5DhSMy"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso54775e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 01:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781253721; x=1781858521; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h8kiyJfpS4AJieM5GN1HD0Jnn9d/pspH0taYDU8KwA8=;
        b=dZ5DhSMyftaY0KgciUHdWWfVwB/ADGeCOkd8/BI10KA5+1Wt0cBR6IAAzgVXsltxge
         U5TTBOjzg1vqTe/2eiaPLEWz1V6S/akl0jI3EYfcKG/7wmvbwTC9raE21OSOwAZY/KwT
         mcuLj95h0/CZJcMWzBPYpiybMyZN79Hktq4z7pjFyXvTgAQpgWZPPqaNAgVBGJ2ttto0
         06zUXyZhBN32FHT8+LvYoExvIklMvKM081vkd43vgigyiw/VlhOtur9cwSICloOOXjQU
         ez1KKVcznGEPdqHCYqIf6KTXN+SNEzBTGEG3RzoTF2t7d6JKpV9YGqMoAemBB9W5aa8+
         Q/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781253721; x=1781858521;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h8kiyJfpS4AJieM5GN1HD0Jnn9d/pspH0taYDU8KwA8=;
        b=HQjF9LA9JFZS1Vrw5SMrABVlN0ioSNBP+0i+YiL7vjrC/Wi6j/pvPFAh+JG8c5MOuN
         v0XwM5fEjv6yKojLITE+U10du4K9XilvNnD6RbzHzNpJPG8uTbrhtfcFpVLwVjhAxpH+
         PofKYkmenrXbHtt1cWu+qQLu6jUsY2iPxvskHZYsLsviUmoejoLn7BHRTEgdRbFvmBQV
         Sc+/2iZrSQEdvXKyPocBF3qQfp0pG+vjclmr67YUDrt8BBZ1gVPF5NCM5PVznpo2ONbh
         KrAPYWwU2zdQfEWsQCeZEvC2Z7hZQve96z7VUc6xMUWa4ddkzB5NUEJ4iX7rV8IF0WCB
         xRrw==
X-Forwarded-Encrypted: i=1; AFNElJ9u1bXiYn4GJGneEBx4oyG1bA6m1Js//y/3cARZH38iPiMHE13xvhy0+5BZrg1qTQErZdkdZZc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzKZLO5N0U1Ci/EWI/wO3xgFkA/5JqRnpe/6hGJfRYt2Rrpl4c
	4IMMQ6bwyTmFBOD+AiwQAY1kDcOgD4gMe1D1+Y8xKGWQOrfLn1zFcv5p5uj1DJ9DgA==
X-Gm-Gg: Acq92OFSORf9mtXgVtXn1CwAc4PMIFZZTWNAf0YlowI4AZN4IoMB0aN5sKwNNqFjWDX
	Jd14UBdDQSYH1+sfY7S1F3dfKCjOV4aYuGRD22rIx+KtYAdmQyvoaPL76LFpuOhcH0X2T3tDXkO
	207fAPQ5lkMjrJSLu49gaar5Z3OoLdV6bwc7kmggtP9mE/6ggsWip0zCkTpOKxQD2exDWYXWDVw
	FkmMALZQaG9VDa8l8OncLROxVEjS8y1jZbLuA1bitZeWbMIHas+G4dBxk2Vq8ap9Fer2k4spKUR
	woB8zUMl3V10ap0gfTNGgeZdwVdq+CPMxL4xP9HPEJcoZbqDgmnUaFI8E4gY/PnrFRRtf/g/N2K
	mLceNh04q9iOHtsD1fZTGJjS7eeAKjhmwrWvGylqQDc4wM/+nUgId0GehYth/Ua/HITgl5MM7my
	VzwuGQ3ibVAfGLRdAx/vfZkp6Y/Ow7PkAtTbA8BUx8Bk2o1TJFpdXDuMpoHXE9bkb351LHzFq2
X-Received: by 2002:a05:600d:4452:20b0:490:b2ae:44e1 with SMTP id 5b1f17b1804b1-490eabf94bcmr544755e9.5.1781253721001;
        Fri, 12 Jun 2026 01:42:01 -0700 (PDT)
Received: from google.com (140.240.76.34.bc.googleusercontent.com. [34.76.240.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2cf5537sm158942595e9.9.2026.06.12.01.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 01:42:00 -0700 (PDT)
Date: Fri, 12 Jun 2026 08:41:55 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Sebastian Ene <sebastianene@google.com>,
	op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, catalin.marinas@arm.com,
	sumit.garg@kernel.org, vdonnefort@google.com,
	sudeep.holla@kernel.org
Subject: Re: [PATCH v5 1/6] optee: ffa: Add NULL check in
 optee_ffa_lend_protmem
Message-ID: <aivGUzU-xxiR-egQ@google.com>
References: <20260526151934.3783707-1-smostafa@google.com>
 <20260526151934.3783707-2-smostafa@google.com>
 <aiK6lgW5YFWSMTxf@google.com>
 <CAHUa44FO02DKqqNeFuRfx8bQjwcNRfPMF2=8MdjMUFp6vYUpNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHUa44FO02DKqqNeFuRfx8bQjwcNRfPMF2=8MdjMUFp6vYUpNw@mail.gmail.com>

On Mon, Jun 08, 2026 at 03:16:49PM +0200, Jens Wiklander wrote:
> On Fri, Jun 5, 2026 at 2:01 PM Sebastian Ene <sebastianene@google.com> wrote:
> >
> > On Tue, May 26, 2026 at 03:19:29PM +0000, Mostafa Saleh wrote:
> > > Sashiko (locally) reports a possible null dereference under memory
> > > pressure due to the lack of validation of the allocated pointer.
> > >
> > > Fix that by adding the missing check.
> > >
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  drivers/tee/optee/ffa_abi.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> > > index b4372fa268d0..633715b98625 100644
> > > --- a/drivers/tee/optee/ffa_abi.c
> > > +++ b/drivers/tee/optee/ffa_abi.c
> > > @@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee, struct tee_shm *protmem,
> > >       int rc;
> > >
> > >       mem_attr = kzalloc_objs(*mem_attr, ma_count);
> > > +     if (!mem_attr)
> > > +             return -ENOMEM;
> > > +
> > >       for (n = 0; n < ma_count; n++) {
> > >               mem_attr[n].receiver = mem_attrs[n] & U16_MAX;
> > >               mem_attr[n].attrs = mem_attrs[n] >> 16;
> > > --
> > > 2.54.0.746.g67dd491aae-goog
> > >
> >
> > Thanks for fixing this and for including my other patches in the series
> > Reviewed-by: Sebastian Ene <sebastianene@google.com>
> 
> Please add a Fixes: tag. This patch is independent of the others in
> the patch set, so if you send it alone with the Fixes: tag I'll pick
> it up.

I posted a v6 for this patch with the Fixes tag [1]

[1] https://lore.kernel.org/all/20260527150236.1978655-2-smostafa@google.com/

Thanks,
Mostafa

> 
> Cheers,
> Jens
