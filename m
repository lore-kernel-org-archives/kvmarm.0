Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929872798F5
	for <kvmarm@lists.linux.dev>; Thu,  8 May 2025 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719119; cv=none; b=UDFLuzY6P3IRf9kOW5nF0xAcoRNGpymducgeclVwtdU2oCojrrPOISZ0BmTIQTISsHfCIxTf+/ZMSAUHhFaAOtaTKWPOrThOSk8sdxkq7MxIS0n0/uAjLSzt+U9EmtQ5ECPIzuRfFTFVx2C5CejvK2r7wy+Bt+4lemNrZMR2ShY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719119; c=relaxed/simple;
	bh=MuUjO0lVy+uE19DvVWBJLTPKJIu/iOqDmi/K4/QirxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KyOBRwz41ris5Ck7m3zXTZS/zUU3bu/XH3BX4YU6gHDXC96hxHUBoG9L4x+zp/bS3dPMLTrs1T2HjyAaxZJj35yHtcMsFFF8/nVqkFKZloWF1Qi0ioIR47X5ah1GXHPBK+EbsBI38xgsrP9UkS6XcaEERLM8M9whg1ivQNWHa10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=android.com; spf=pass smtp.mailfrom=android.com; dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b=KYakj4yM; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=android.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=android.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=android.com header.i=@android.com header.b="KYakj4yM"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6f53c42cea6so11091026d6.0
        for <kvmarm@lists.linux.dev>; Thu, 08 May 2025 08:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20230601; t=1746719115; x=1747323915; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NM4QjkPCoOZz7ahD1Rov7Pc15g+3o4zNeRGOhW1N2W4=;
        b=KYakj4yM3d1QWYDvK+IHc1Uo8sAZuy2uU+TZne4AiXgFvn0kBPf9D6xbibjdHkqOxK
         0Bn8whL2Ng04o4rI8LqI1PIHpoPAoq1P8P5s4Iqz+/Q4ehfPugrERJ5mwNZntjC9wx5P
         edQrCzOe6g4j10TI30IkQY8WEkUwWKduoP1mltUEUjB7PYaP0THr32QUzf/K/TE2BCE2
         J2h6cdjTbvtJ2dkD7fd80GfNVY4kC/cRo+symIm2/MZS3i/0VKrWWvzp7b1XGDzMbSzJ
         Qq0T575FKWb1AWJUXwWZ+wp6grqrnYPWY1XafXsjdWnT+qBk/nc1zH5oxg4j/uXvKu4b
         J/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746719115; x=1747323915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NM4QjkPCoOZz7ahD1Rov7Pc15g+3o4zNeRGOhW1N2W4=;
        b=lJ7ATukBTCQ9pFybRPL7zrIfSgQQ8+iddM7Y7czg5ggFIYS1RvwPUdj0bAHS38/aXd
         7nMlWI4XH/wDI6f3yRgkEiLbrLYNb/GcWnOHdvgeHBqM75bkFgqMpN2oerN9IrCcmWGF
         v2kWKy7LzCP+uRHTUrtj04TC7vSTaUesShVoTsL6X+vlq1Cr9JxaWX+nYuWVbKuQIWv3
         xIunGDbkBwKkjIbMQUYq/Cl+uD4Zjr32d0TdZV2CI+8s54jCCJGhhWcXwQryPbC/XIVl
         SMmt+ysvWblJnsZ4uiOLEaerE641FvX/5adTKa38+z6JuOiPbI5WHAZBpcFS2+z4m4NC
         508Q==
X-Forwarded-Encrypted: i=1; AJvYcCVAnYFp8MiCVEAkBqUEb+jQw89J+VZBm1/jKA5OxWWCHMlvR1mPyIMIQhlYv54vJovL3/27Lzg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQZeSkA1qPLHi5t5KniFxgWcXkY2S97IURn20l21Y49bDSYXj5
	RtxP5refmMZIvoaFz52r0zqNjViXkSiCjXWMjOtRMk+GwUvY/nfvLR79Sv4cXNhCaM3DPmZsseR
	gVRc/a6AinHyJ3PhlQvA62HJKt1/+eXNdjHL8
X-Gm-Gg: ASbGncui8PSX/DJoAXMc/ICjlqaswYO9UIsL7rJE4D7WLCaO1cGdnx6eXrjMVc1faOK
	hl5wOF3w3uZPrapUUuGrge+nkJF/pPlSvN+IpbdIbh82BGWWF55HQCmzG5PRo1Cby5B1pmr1fkt
	eWv6THiqV4wjGKxwEFb7/L+F8mOW2NqpyGCnrV18/BskxZHrNx9oEh8lc=
X-Google-Smtp-Source: AGHT+IHc5QpsocWh4+JhJxyePGK+eK7xc3hc4CKN9/ujajSYCJIlTH83nwZ4fer3bYFp280RvLfeG7NtLclp+yhwbtI=
X-Received: by 2002:a05:6214:20ef:b0:6f5:374d:3cec with SMTP id
 6a1803df08f44-6f542adfef8mr152122036d6.38.1746719112652; Thu, 08 May 2025
 08:45:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+AY4XcaJa1_U3qXQUBj4wZJYc9hKmRX8FTNeDvV2auEnC_WrA@mail.gmail.com>
 <86r017h00e.wl-maz@kernel.org> <aBnNXyJn818ZEKOS@google.com>
 <8634dfh47q.wl-maz@kernel.org> <20250508-spectral-sage-whippet-4f7ac2@sudeepholla>
In-Reply-To: <20250508-spectral-sage-whippet-4f7ac2@sudeepholla>
From: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Date: Thu, 8 May 2025 08:45:01 -0700
X-Gm-Features: ATxdqUHLxJTSxwoqFpk9lA8TVBYoTMM9oR5V-VvKoxrBxJB4bep25PWQBicEw1s
Message-ID: <CAMP5XgcCg+kB7tPwSYUcjfZqR_734cGEs_KX4st9SQOVLBV-Yw@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Restrict FF-A host version renegotiation
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Per Larsen <perl@immunant.com>, armellel@google.com, 
	catalin.marinas@arm.com, kernel-team@android.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	qperret@google.com, sebastianene@google.com, will@kernel.org, 
	yuzenghui@huawei.com, Per Larsen <perlarsen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 2:27=E2=80=AFAM Sudeep Holla <sudeep.holla@arm.com> =
wrote:
>
> (just adding some additional info not particularly impacting the $subject
>  change implementation)
>
> On Thu, May 08, 2025 at 09:55:05AM +0100, Marc Zyngier wrote:
> > On Tue, 06 May 2025 10:29:41 +0100,
> > Per Larsen <perl@immunant.com> wrote:
> > >
>
> [...]
>
> > > Asssuming we drop this patch from the series and apply the rest, the
> > > hypervisor and host can negotiate FF-A 1.2. If the host then calls
> > > FFA_VERSION a second time to request FF-A 1.1, the hypervisor would
> > > return version 1.2 (without this patch).
> >
> > Why would it do that? Once a particular version has been negotiated, I
> > expect to be immutable.
> >
>
> Not suggesting that we need to support this, but it is technically possib=
le
> today by loading FF-A as a module=E2=80=94first inserting and removing a =
module with
> v1.2 support, then loading one with v1.1 support. It can ever throw error
> as not supported to keep it simple.
>

I'm not sure how what you are suggesting here is different from what
this patch does. This patch does not alter what versions the host can
negotiate. The hypervisor already disallows negotiating a different
version once has_version_negotiated is set, the return code just
doesn't always reflect this. If you try to load the 1.0 driver in the
host after unloading the 1.1 driver similar to what you describe
above, then this CL will let the 1.0 driver know that the hypervisor
does not support 1.0 (I use 1.1 to 1.0 as the example here since this
is an issue even without the next CL in this patch series that bumps
the hypervisor supported version to 1.2). Without this CL, the 1.0
driver will now proceed making other ffa calls using 1.0 data
structures that the hypervisor will incorrectly interpret as 1.1 data
structures.

With this CL, loading a 1.2 driver after the initial 1.1 driver will
work as it did before by returning version 1.1 to the 1.2 driver to
let it know that _it_ needs to downgrade to 1.1. if it wants to
proceed. Loading the 1.0 driver after 1.1 will now fail at the version
negotiation stage however. This will be clearer, and more correct,
than getting FFA_RET_INVALID_PARAMETERS return codes from other ffa
calls when passing valid 1.0 parameters to those calls.

--
Arve Hj=C3=B8nnev=C3=A5g
