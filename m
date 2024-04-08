Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F4C7CF29
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583315; cv=none; b=GVtOYOSDmz6jpckJUpTei+hC3tRjigW2TpQq0s1pnkUMiUbP6gEBVAq1zRA4K2ENWoWA6xhITzdBNc73F6w2YWoMY6v+6ksI/jkIqgArZJRAeSLUvlwyDbDnJ3fbxBOnfgDjIUJOrjLZOxPNk3QAEn32inzrovWw2LN6guFT5Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583315; c=relaxed/simple;
	bh=yFPasHodDJn9VywVYDYQiUftBnshjWWHb3x1gD66QWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtT7fTvugRP7IVJsBS1YCFyk6sX9O+yqDzmIL6UhybsccCF5a0wI9PQnFH6gJf6rF4E2DQJ+cLO+rH1jREhs+dfdU3jOD5VbivCLqjcswVv/iLoCyMDjSzBBLSUwabpDqcJYOmPB03G8nQHudvmKtmYRaTZCTNIwMH6yCZqwj/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KAlAtvr3; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KAlAtvr3"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-479dcaaf2b1so1040671137.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Apr 2024 06:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712583313; x=1713188113; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3toePxJIQpiOLzml90ltOIqsJ3tqlikvaEZ3XzBhV8c=;
        b=KAlAtvr3J0c4CT2SVlTTIKzvY8Cw6LZukyRkDHnZDa4pugBQ9k74qlrtqCzvoaXFl7
         Ug3oWTDq/0IJ6GEtmmORigND0O9c8Ei/sKVPeuHALnelEXcjFe1spZkB+9c1iR2eWoSU
         vonivDZwR9v659BtfZCOvue3hcoW3u5ZAzwYBaQ5u05s1qNpE4yp7DFZny3accVVi8xr
         fYCI8CTX7AqYwivpv//JY8q13M00wdNa9ZEAPonqlYPfeiHk9aeTGXElAYEQcM0nSqiY
         EwmJKvfF6ClZvqBqjDgwiAGqQmJ7jNKsvkYoNnwQ6bN5fPOWaNQjde//e++MmaJpDIXN
         jXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712583313; x=1713188113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3toePxJIQpiOLzml90ltOIqsJ3tqlikvaEZ3XzBhV8c=;
        b=tOvNUEzj+J6D4MjMlY1m8xB91f4Retlbw1z5nn1c/jzyzkjPbv+iacQ11G3lie+xm9
         EXhNLJSciopHfxA31BaNMqAefebIoVHUypEHsfgwyYHAX0JY5b2wJDfFMSmZUZlJWJ58
         sJ/e0Ib40RraIHSrq/waBXf6mTAJAk3zvetGvhNH6VgkZHCopur08jbWTk66faRM4SiA
         zOEAmvv0RdDpp2ZVoPGEpd02gRLMnXDQXZ3EhMGN9WKG66MJMFB20mr87E+QuXwa2yxZ
         b1XzXBf6ryexn0yEhRpJOFKrJWL9v6spCZeGA27G6XK2km1GH5KKEAMYmiwzUwyjCHCb
         hrcg==
X-Gm-Message-State: AOJu0YzvexEDALwXMuu9xtp2QCoBkHCCsEODSCxztCijdeCuoL3blXia
	2lPr54NVu7PvWYwN/VUryihVcoLjkh3a0NI+VlhnhaRSSsqwkgmFR68NLHCoQd9oqNeiHM7WJeZ
	Hi+oHsqjSXLeoW+YJZ3Pq3Lzhy53gQCiKbq0E
X-Google-Smtp-Source: AGHT+IGrXSKxqCA0KFPsO+1O5MrEj+HqLcjp20QvswZRSjUnD4LekIVE7CyHZj1+4qDKEGdk12kRGoJ9MDfeW+9ey+4=
X-Received: by 2002:a05:6122:c96:b0:4d4:17c5:8605 with SMTP id
 ba22-20020a0561220c9600b004d417c58605mr6623718vkb.7.1712583312182; Mon, 08
 Apr 2024 06:35:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-14-tabba@google.com>
 <8de8e62d-b7fa-482d-adde-7f90467d8a51@sirena.org.uk>
In-Reply-To: <8de8e62d-b7fa-482d-adde-7f90467d8a51@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 8 Apr 2024 14:34:35 +0100
Message-ID: <CA+EHjTxjuKtVNaCn4Kr9qkZTTSaOrSF5-o7_8zbMLHFZLKPYqA@mail.gmail.com>
Subject: Re: [PATCH v1 13/44] KVM: arm64: Clarify rationale for ZCR_EL1 value
 restored on guest exit
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

Thanks for your reviews and sorry for the delay. I was traveling with
limited internet connectivity.

On Thu, Mar 28, 2024 at 6:53=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Wed, Mar 27, 2024 at 05:35:00PM +0000, Fuad Tabba wrote:
>
> > Expand comment clarifying why the host value representing SVE
> > vector length being restored for ZCR_EL1 on guest exit isn't the
> > same as it was on guest entry.
>
> > -                     /* Restore the VL that was saved when bound to th=
e CPU */
> > +                     /*
> > +                      * Restore the VL that was saved when bound to th=
e CPU,
> > +                      * which is the maximum VL for the guest. Because
> > +                      * the layout of the data when saving the sve sta=
te
> > +                      * depends on the VL, we need to use a consistent=
 VL.
> > +                      * Note that this means that at guest exit ZCR_EL=
1 is
> > +                      * not necessarily the same as on guest entry.
>
> I don't know if a reference to the ZCR_EL1 fulfilling the role of
> ZCR_EL2 when doing the save from EL2 in VHE mode, that's potentially a
> bit more architecture to know but explains why we only need this for
> nVHE.

Ack.

> > +                      * Flushing the cpu state sets the TIF_FOREIGN_FP=
STATE
> > +                      * bit for the context, which lets the kernel res=
tore
> > +                      * the sve state, including ZCR_EL1 later.
> > +                      */
>
> The bit about flushing probably wants to be commented on the flush
> itself which is done unconditionally rather than only in the nVHE case,
> put something in there about how we need to save and invalidate the
> state so that if the host tries to use floating point it's not using
> stale data from the guest.

Will do.

Cheers,
/fuad

> >                       if (!has_vhe())
> >                               sve_cond_update_zcr_vq(vcpu_sve_max_vq(vc=
pu) - 1,
> >                                                      SYS_ZCR_EL1);
> > --
> > 2.44.0.478.gd926399ef9-goog
> >
