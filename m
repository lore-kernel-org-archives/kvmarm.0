Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26384E1CA
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728064816; cv=none; b=llAeZDEjIOaOxL4LO0VM4DsAPds940tz5OHd+M8j3zHEXs0Ja9dm2AxzBFyFasdHVxxM7wnZhr8+lgak3gBx25KOErJboGRAU0We6i6IVAgDmces7i7VNQuQAPlSFO3LVpeo3lZ+Xu7IqUacGjd4KlHSKz2SEqdovX2Qm2Ord+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728064816; c=relaxed/simple;
	bh=PMOM/qjJaiv5NGfVvQQtJMlId91TctdxelpJsDxocLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JM49T9h+TRDQwSP+JP5xTmIb/SdR1Yr3KsTV+kcsY+3TESkuPtMLpEEf06mhViRktHmGF/ndMlFjWA+FA6LtljFFWpRfeJ/ocIZORT+AuZ6dGwOdT3w2TBO3vzdcjn3uyzp4IgUwcz9igPl6shO9MEyuY4/D2ygXVqBbCiiOJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=oQKG7Czy; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oQKG7Czy"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-287212be9aeso99516fac.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Oct 2024 11:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1728064814; x=1728669614; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmLcbw3dTY3w/Owkai0ppDRQaaYIubHSutnZXhKguwE=;
        b=oQKG7CzyNBTjBLtElck0H1f8n0klaE2BOGe48w6Hd0m7wrR3XlfugIU5z0wxOF0ci5
         lLr0Lg+DZrvUGCneWIc2p8Yc1BTbku9Jr8DiIM/NZBDyWBcZUiTVUL6pfB2h0d9wYmc3
         hgMR0LtzwLoDfZOEx5d79TSK9AZx3ERxFKg8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728064814; x=1728669614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmLcbw3dTY3w/Owkai0ppDRQaaYIubHSutnZXhKguwE=;
        b=R2ZMMq5oO9LhL6zcK4BwR3oIrgEMVx8CRk83WS/2UseGdZ516BOBSVaO+BEmNk2CDH
         F1O5R4p1RFsp4ERHc20UqgJQLv42o1/ycLaFA+mDO0bX+xxcpQo3G+OpqHIhrq855ynX
         6UfGaizZR9nC8heeDgJ9PTPZN1w2RdwuBRVwA/I5oLcbMoq02069DXCoclQ0huOAqOaR
         REgLcPT5jJy4EjmoYwPh81BClhcD6XLABn8+ZhIkpj6p7Wr6N85l//S96961LkJKhNSy
         W5Q1QKIXI4OWu+0G4fS26+3FFjcUIe8HpJ3MWMmndOtcl8YCKIda48fPm/udb38WRnsn
         W0mw==
X-Forwarded-Encrypted: i=1; AJvYcCVM1Bt/s4XxosaEiU+VSb53fx7uc+rDb61hmhoyfJEDOtxn1pXnWG3GHI2EaGLZY84U6tmySaI=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywdjizwx3DQuUjQpP2lwkiSiv1eeOQ2N87BU+dV2WMBw2cBLHM2
	vLojweWH11kfv6Y4e/yW+NhWPeJLS6iysdocDGl98KqU1cklM4fXHZxcmhlRdw3/j8WX4o1lfTq
	lvStALSGYAj0D5Y+k04C3UL8InF/kRFgiK4j2
X-Google-Smtp-Source: AGHT+IG1zOkPi9cSpKoSowBdUikBePmdVz5SvwucHk6LYufziJDiV0GIln1NM20ppD8iWK+zVkJ9Tq1c8Kj3vOZeY5g=
X-Received: by 2002:a05:6870:89a3:b0:286:f523:4d76 with SMTP id
 586e51a60fabf-287c1e16b7dmr727983fac.6.1728064813669; Fri, 04 Oct 2024
 11:00:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <zghnfw2vvrvlxenzx3oi55hzznxbx2nhcuwfk5zpe42bm4dxzv@zknjtfa2fu7n> <20240925152509.87152-1-faresx@amazon.de>
In-Reply-To: <20240925152509.87152-1-faresx@amazon.de>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 4 Oct 2024 11:00:00 -0700
Message-ID: <CABi2SkWrQOdxdai7YLoYKKc6GAwxue=jc+bH1=CgE-bKRO-GhA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/7] mseal: expose interface to seal / unseal user
 memory ranges
To: Fares Mehanna <faresx@amazon.de>, Kees Cook <keescook@chromium.org>
Cc: liam.howlett@oracle.com, akpm@linux-foundation.org, ardb@kernel.org, 
	arnd@arndb.de, bhelgaas@google.com, broonie@kernel.org, 
	catalin.marinas@arm.com, david@redhat.com, james.morse@arm.com, 
	javierm@redhat.com, jean-philippe@linaro.org, joey.gouly@arm.com, 
	kristina.martsenko@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mark.rutland@arm.com, maz@kernel.org, 
	nh-open-source@amazon.com, oliver.upton@linux.dev, ptosi@google.com, 
	rdunlap@infradead.org, rkagan@amazon.de, rppt@kernel.org, 
	shikemeng@huaweicloud.com, suzuki.poulose@arm.com, tabba@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Fares,

Please add me to this series and I'm interested in everything related
to mseal :-)

I also added Kees, since mseal is a security feature, and kees is CCed
on security matters.

On Wed, Sep 25, 2024 at 8:25=E2=80=AFAM Fares Mehanna <faresx@amazon.de> wr=
ote:
>
> Hi,
>
> Thanks for taking a look and apologies for my delayed response.
>
> > It is not clear from the change log above or the cover letter as to why
> > you need to go this route instead of using the mmap lock.
>
> In the current form of the patches I use memfd_secret() to allocate the p=
ages
> and remove them from kernel linear address. [1]
>
> This allocate pages, map them in user virtual addresses and track them in=
 a VMA.
>
> Before flipping the permissions on those pages to be used by the kernel, =
I need
> to make sure that those virtual addresses and this VMA is off-limits to t=
he
> owning process.
>
> memfd_secret() pages are locked by default, so they won't swap out. I nee=
d to
> seal the VMA to make sure the owner process can't unmap/remap/... or chan=
ge the
> protection of this VMA.
>
> So before changing the permissions on the secret pages, I make sure the p=
ages
> are faulted in, locked and sealed. So userspace can't influence this mapp=
ing.
>
> > We can't use the mseal feature for this; it is supposed to be a one way
> > transition.
>
> For this approach, I need the unseal operation when releasing the memory =
range.
>
> The kernel can be done with the secret pages in one of two scenarios:
> 1. During lifecycle of the process.
> 2. When the process terminates.
>
> For the first case, I need to unmap the VMA so it can be reused by the ow=
ning
> process later, so I need the unseal operation. For the second case howeve=
r we
> don't need that since the process mm is already destructed or just about =
to be
> destructed anyway, regardless of sealed/unsealed VMAs. [1]
>
> I didn't expose the unseal operation to userspace.
>
In general, we should avoid having do_unseal, even though the
operation is restricted to the kernel itself.

However, from what you have described, without looking at your code,
the case is closer to mseal, except that you need to unmap it within
the kernel code.

For this, there might be two options that I can think of now, post
here for discussion:

1> Add a new flag in vm_flags, to allow unmap while sealed. However,
this will not prevent user space from unmap the area.

2> pass a flag in do_vmi_align_munmap() to skip sealing checks for
your particular call. The do_vmi_align_munmap() already has a flag
such as unlock.

will the above work for your case ? or I  miss-understood the requirement.

Thanks
-Jeff



> [1] https://lore.kernel.org/linux-arm-kernel/20240911143421.85612-3-fares=
x@amazon.de/
>
> Thanks!
> Fares.
>
>
>
> Amazon Web Services Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
>
>
