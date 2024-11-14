Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4FD41C65
	for <kvmarm@lists.linux.dev>; Thu, 14 Nov 2024 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731599096; cv=none; b=OGOt5MCkzJ/Xy9ZBpTaAGGTUcp7UPT++K91LJgfJ5j1SnsHvMcczi7VCjS60j8w+FOlLGVo5+KoEPbsXefcX9GlWthoOWXxOtfrw7kvXnyLINqVVhZBx/RX5lOJDYDSyxr0Q0T/hXjOEPBt10s2X4J+K+syNWyUv1zLhqko57bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731599096; c=relaxed/simple;
	bh=GkhNWkpl50ktEuRk+CafywAeOJJnevTAjIQ40ac28BU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pj2wClf1l03vrfBYDg9V6N8J8kcz8u1S6XmV14nCjelOn+hI5L1wMBUe44ge8G9EOcB+yd6yNk/jPgx7jgg24pyNEcizTe0tWfT2wCTQl2/l8sEcFk1X9X3AUdWmEAZxsY6wftEWgn4g+2Zsi89GAugHf707kZs9gQVFN5rDLio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ClLrluld; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ClLrluld"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb561f273eso7764961fa.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Nov 2024 07:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731599093; x=1732203893; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GkhNWkpl50ktEuRk+CafywAeOJJnevTAjIQ40ac28BU=;
        b=ClLrluldDsqoqUFkzGxQb3v6h/H9mdkSV87Me7FemPjx+pYaMMp9KojCQ8CSiLP7pX
         9G7Uf6vPlg3rFcYYbXnIrJumDwVG1SbYOokSER5bMTvzfYzSQP2dxUht/R9o7DnDJ/8r
         hmVyMc/BUuICUgK7dM5X+gYBMkAsfWkC2IQnmwiRh+UpmQH4a/c8WnSz4QnxxIVExQuu
         wqjPLIH0nkoiifz4O7a28ejctA4J2/GOFdRo1x4Hc93xx4WOTbbmJpkKE/GhKwNLUKDc
         HoPbG1QkmtLpJH+2mU9Pe7h97i/pfoVuByHF9lSb+/yTze7l/IrR1fvHl8DqeDvBUKYe
         NqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731599093; x=1732203893;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GkhNWkpl50ktEuRk+CafywAeOJJnevTAjIQ40ac28BU=;
        b=rb5FwMStaMZ2CTqORom/fJ0S3SpDzW31BYz+zDUkJrpf3ZL24ykJDvht3dgAXYvtT6
         klvluvkNg3PmRBulfzeFv7XHvfTcTuHCHDYkqrPJnlFRU2Db6GvpTkxsboO/81ykVo9B
         PLhUqWAk5KXMso8mCNof79KG+8NVX1lng3b/0TPbFHiaqB8M9JwjGmOWHNiVKqNJLqQW
         4DSCr/fqn86mnJzAsp2Q7yzinVSWIexA8JZYuvPf1baiV9pfHPdm7m3PS5WkTHSe97g1
         VjwfAi3Z7FR+PLRNeMV1DIjYWKWipu+P1BVV5lL3oX7hVU2b8ZxETvXzoSxcMhSiXJTO
         MtyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFxvOWEHiIeISXYesq3SCdOMATQhN59I91ISMqFBQTRnLQEB2vsksfyyvYj/W5IH/+3C9Z8do=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYIr9yRMLJdgx04RM0UrtlgH6cS34JlHnYZYzlT674GIAVgU2W
	fvsFxEwf6oE1oIaYi/1QH2TJ3QwpqJM+qfZlPyEYCij8ZACOJJdBGn25LGRZXuILf0Rnisg6PR4
	OkkvjadarozKsJkmHvE1WwhcoBLxJhHN7qLmV4g==
X-Google-Smtp-Source: AGHT+IGWg38u++Iun/youHmT7OXtuhqQzvkqvbeU3yLkWOtsRw903njcHqvRRNFmz/mD0O4qwB83QRZpX2F1leaRUbc=
X-Received: by 2002:a2e:a912:0:b0:2ff:191d:f077 with SMTP id
 38308e7fff4ca-2ff425b142amr64742961fa.0.1731599093108; Thu, 14 Nov 2024
 07:44:53 -0800 (PST)
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
 <87ikstn8sc.fsf@redhat.com>
In-Reply-To: <87ikstn8sc.fsf@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 14 Nov 2024 15:44:42 +0000
Message-ID: <CAFEAcA_RGWq_ydkKCZGZ8Cn6g3_KSXu_K9bBC2u5g8=uBaJUUg@mail.gmail.com>
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

On Mon, 11 Nov 2024 at 14:29, Cornelia Huck <cohuck@redhat.com> wrote:
> That leaves some headscratchers (at least for me.) E.g. FEAT_UINJ, which
> is optional from v9.5, and mandatory from v9.6, but where I'm unsure how
> we'd discover it, especially as we do not have a way to discover the
> architecture extensions.

I think that's just an accidental omission from the FEAT_UINJ
documentation. There's a UINJ field in ID_AA64PFR2_EL1 which
tells you whether FEAT_UINJ is implemented:

https://developer.arm.com/documentation/109697/2024_09/Feature-descriptions/The-Armv9-6-architecture-extension

> I'm also not sure if I understand FEAT_CHK, which is listed as
> optional from v8.0 and mandatory from v9.4, but every aarch64 cpu is
> supposed to be compliant, because CHKFEAT might be a NOP (and this is
> only supposed to check for FEAT_GCS? Yes, I'm confused.)

CHKFEAT is there for cases where software (especially EL0 software)
might need a fast cross-OS-portable way to detect whether a feature
is present and enabled -- for instance if you want the compiler
to emit a function prologue sequence that includes "do XYZ if
GCS is on". CHKFEAT is in the hint area of the encoding space,
so for any CPU that pre-dates FEAT_CHK it will do nothing (which is
how "no features detectable with CHKFEAT are present" is indicated:
if you look at what CHKFEAT actually does it has a definition that
isn't how you'd naturally implement a feature-detect unless you
needed to make NOP mean no-features-present.)

Currently FEAT_GCS is the only feature where it has been deemed
necessary to provide this kind of is-it-enabled detection, but some
future features might also use the CHKFEAT mechanism.

If you're a piece of system software wanting to see if FEAT_GCS
is present you would use ID_AA64PFR1_EL1.GCS. (In particular, if
you're an OS then until you have enabled GCS for yourself via
GCSCR_EL1, CHKFEAT will tell you "not enabled", so you first need
to look at the ID register to see if the GCSCR_EL1 register is
there at all...)

thanks
-- PMM
