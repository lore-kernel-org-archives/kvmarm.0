Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656AA145324
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894943; cv=none; b=gH3YekUU69HpwBreTevcJbUao+hqcIFnzFfh73ih5KjZ1jLNqTZvmHGz/Q9yz8ZUnKrVT1D7hVAvimaSnI9dyTmSpl//7JewNg2NFwhd4MoF4PfrhPHK481tQH7RDKv8DXxEFE+GySSFBq04lsExNVnsGVN0sLgDW7wFrR+NX44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894943; c=relaxed/simple;
	bh=clFJXG/nYTPPgVD+SsUho7vYYXaWljnTXZDJA1iCVPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RyZRT/EFzvJO/jHgjLPudrits4iis4Eyv0js4rHi8HytwBxD14B0yuYPbR/5CKdWTHUqDoW4zf9hdigrnkqV5VjcVunNJlV+VioWNDZ/8fxYYgulYRgZTw/kD+ao5f8/6Suf8o8rhy8y3IOM2N+wFRq4NzTcq0dciRzD474HVRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vur1JCf4; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vur1JCf4"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5cfd2978f95so3371149a12.0
        for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 07:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732894940; x=1733499740; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UhwMp6LZ6FzsyEphdvEGwu2rBtsdacgIuy/U+/WBjQg=;
        b=vur1JCf4nIC9dn7mi9b1VTs+Tmvx03882SDXOIi5BxSTnyUfQcc9wGOI2KL3VR8Rmi
         VvLT8MfgLtGmapaPZo5nhodJT2q8oJbmXtI4zG2jLDYQ4Rtbl7v4DVBF8/ubrmM3dkLB
         x+ldH5WxhKbEME6dzltiG63kAmD4Y+lWu134YlElXQ113PolgfmkW6MhEDBqRUqzaIIy
         RA/N2XX6uvtvN/XFbfjh9nrt3/6jzf9D2miwXTNCt8ig29Zie6ztzwuXpKb1Auyf0LNz
         /u/a0DvWqRlw9skqHDiwOwbdq1Hd2YaUHNnXozS2IyJWo38u1iLJTd8eZvsd75HTaWuu
         DMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732894940; x=1733499740;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UhwMp6LZ6FzsyEphdvEGwu2rBtsdacgIuy/U+/WBjQg=;
        b=R8GADIhpPVPmpAHTP22BHIzd/RghbKeE83C1UakYDKyRdBxygf7nXnOknIeeqshA95
         qGahgWGfBK/LAjBxbXWkjsx8/Ei5hSfXcdWDxzsgNn2dDdsvqFCZgmC//9c9v/OG+6K6
         lu0+UwrGr6kD3cCsmXUMTHMe0BdyC0uSZXYWIlXAEfzWnbu0UabRyS4iltJmpMaNR1hh
         udmV4XpP+XB1M2kwZjK6uFPo7G/KtnB/Vq5bWuSwGQUwc9yGvbX5ODUiS05dHhMVQEWi
         pkel0qUE8jgB5aupusj37H7NQye8NAvvzr4oHYAoG7+mR68YmZPqNoL0HCKsaXpSuH1S
         WGGw==
X-Forwarded-Encrypted: i=1; AJvYcCXlzbYsKQMvtkmvTp65LiyuM5Lvp7pzninAALWROQamheYhGogBMTrfd5wC0kcds6iBTkY/MGU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQ2wd9Vs/7iJD5vGFZSTrA1A8U0ho4DpFwkrW5S6iqhwxYt1s3
	0rB2vGtpOmXQZuYCHjWA/2d0E7QAXLfygtXY208labkVvpQE6zGGxiXimyDjfLfVwbMMFGrObmk
	MOPD3ANTbjtXOKCQOn9Z6nZSB+dVLhkoWiYgL5g==
X-Gm-Gg: ASbGncuwofyg5yC5n8OIC7wID4xptBlr77OGakJ8mzYzTLthZMD4grv3jZRqcJ9rqKe
	MU37bAyokWUyzfJPrOSbUFogBXxg1o2Ir
X-Google-Smtp-Source: AGHT+IGLUvSKDH+4UWkxaWi8YnuLMe/vbJeTiNyrWy7eOGtt6PR+y7mTJNIziLOVYADYe6pHiOAUq59zWmrBSrZaB04=
X-Received: by 2002:a05:6402:13ce:b0:5cf:ab23:1f07 with SMTP id
 4fb4d7f45d1cf-5d080bdb609mr14641790a12.15.1732894939616; Fri, 29 Nov 2024
 07:42:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com> <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com> <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
 <Zx-9WxXkmkMuGIlQ@redhat.com> <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
 <Zx_EGxj2aqc_2-kY@redhat.com> <63c232c2-a325-48d6-8ed4-753a7c6e3b4e@redhat.com>
 <87ikstn8sc.fsf@redhat.com> <87frnwmn2v.fsf@redhat.com> <b7f25d3b-6ba7-4924-9383-74c1169dfe86@redhat.com>
 <87ldx2krdp.fsf@redhat.com>
In-Reply-To: <87ldx2krdp.fsf@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 29 Nov 2024 15:42:08 +0000
Message-ID: <CAFEAcA-Pi4GRXyY3Lf-rCYk0CDZ5cT22orHT6JDxK14k9JMkng@mail.gmail.com>
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger@redhat.com, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, richard.henderson@linaro.org, alex.bennee@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, sebott@redhat.com, 
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, abologna@redhat.com, 
	jdenemar@redhat.com, shahuang@redhat.com, mark.rutland@arm.com, 
	philmd@linaro.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Nov 2024 at 15:10, Cornelia Huck <cohuck@redhat.com> wrote:
> The good news is that in many cases we only have differences in bits
> that map to a feature (and are actually writable in current KVM.) The
> bad news is that we have a number of exceptions.
>
> Comparison #1:
>
> ID_AA64DFR0
> f010307009      #of breakpoints:7
> f010305009      #of breakpoints:5
>
> BRPs does not match to any feature (but has a different meaning when we
> have FEAT_Debugv8p9 and 16+ breakpoints)
> [this is a whole can of worms in general]
>
> ID_AA64MMFR0
> 2100022200101026        FEAT_ECV, FEAT_FGT, 4PB
> 0000022200101125        mixed endian, 256TB
>
> FEAT_ECV -> may be 1 or 2 in ECV, with different capabilities (I guess
> we would need to allow something like FEAT_ECV=2 to expess this?)

This one was an unfortunate oversight; I expect that there
will be a separate feature name for the =2 case in some future
spec release. But as you note for FEAT_BBM below, not
every different ID field value always has its own FEAT_ name.
(FEAT_HAFDBS is another -- it allows ID_AA64MMFR1_EL1.HAFDBS to
be 1 or 2.)

> support for mixed endian -> indicated in BigEnd, no feature (how
> relevant is this in practice?)

ID_AA64MMFR0_EL1.BigEnd == 1 is FEAT_MixedEnd. Relevant if your
guest or its userspace wants to use big-endian, which is probably
approximately nobody in a KVM context but is theoretically possible.

> PARange (52 bits/4PB vs 48 bits/256TB) -> no feature, but some values
> depend on other features -- we care about this when creating a cpu, but
> migrating to another system with a mismatched range would be
> problematic, unless configuration outside of the cpu model would take
> care of it
>
> Comparison #2:
>
> ID_AA64PFR0
> 1101011021111111        FEAT_AMUv1, GIC v3.0/4.0
> 1101001020111111
>
> GIC == 1 indicates GIC CPU sysreg interface for 3.0/4.0, but no feature
> (I'm not quite sure how we handle this in QEMU)

We basically defer GIC emulation almost entirely to the
kernel (which will set the GIC bit in the ID registers
according to whether userspace asked it for a GIC or not).

> ID_AA64MMFR1
> 1000000010312122        FEAT_ECBHB, !FEAT_ETS2, FEAT_PAN3, FEAT_HPDS2, FEAT_HAFDBS
> 0000001010211120        !FEAT_ETS2, FEAT_PAN2, FEAT_HPDS
>
> both ETS == 0 and ETS == 1 indicate that FEAT_ETS2 is not implememented
> (ETS == 2 would indicate FEAT_ETS2) -- I guess we would want to
> standardize on ETS == 0
> FEAT_PAN3 implies FEAT_PAN2, and FEAT_HPDS2 implies FEAT_HPDS2, so
> probably fine

Yes, in general if the number in the field gets bigger
this should be a backwards-compatible improvement in
the feature.

thanks
-- PMM
