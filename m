Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AA18C3B
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 07:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716190587; cv=none; b=hFSIvVk/qiWkiZRyrCXfesMTc3Pm1SGz839SJ+/BgSePGXIBsud/jCtAEC11+gAgtba1OSe24tJdQcTFQqIp5ywh8nkEqGJIjGxw+buwAMBn+AZeAxVCJidRNtYSznF/UuDRES4Eu5THyGkRnq8BXY9nTf6uWxtAJmOOr0FE3/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716190587; c=relaxed/simple;
	bh=ZW6s2BcmlFsfKzWQboQkOCoRdoEFk4UamfsPGNZTvPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BpSLQqeTaaP4VBsC/QIKISTyHhdIlAhJkBxiWPwQkckIJnWECdKmkweGpFzglP/7ZOfX7dKbjTzRVzBMiHSjpMZ0VJvMBNKLQDGsiO9rm1NUAnkBUQT5h6oFJgp1UpTwMDvSzlG2PnJDyrgz6akDFSwJoMqRvpUh2Khj3JBbO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eWGRSWGW; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eWGRSWGW"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-47f0a45375aso315175137.1
        for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 00:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716190585; x=1716795385; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FrwkOJQ5tIWb/5jF1YSUpsrd8jskXTbSZGpN+A+2nbE=;
        b=eWGRSWGWk8a4oGMuda9Y9iNBeWS6rcqP22aPyC2yS27Cl8iDzEMCVs2T+xksx0hJ0r
         CiuxILNVSxyhCMcU5mZe+OmntZboLWVZ6rlIEQPzwv+p1jOqabKL3H7dYsi9RgITd548
         F2Pw6Mw3DgpDoGEjwZS1J6/AnrI7VjRuxElPwLCW2pj0w4qZ2D+M2rFlCuqWj8bGAwUT
         FCpeh5+0aQnBekkcc3SzMNkbVQohH24tJsPqpb8sclASbtGqR7AOJUrr5e+A9xR4Mt1S
         6Rs3iEiRCpssQyKjq86J3p4L3iaUrxWte2pSBli5QnwBdm+E4xVv9qfLK/TeaGxjMkXF
         0TbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716190585; x=1716795385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FrwkOJQ5tIWb/5jF1YSUpsrd8jskXTbSZGpN+A+2nbE=;
        b=nb2p5EO9nxH1c7qz+GaMKXRzHwOfI0QJPxcCC0wMLlNoUlNSNS8COwtnSUbhFXZJ8i
         JAw6nJyeXzMbqYvVnfSmJo5YPxnpBCULWuOu3aOFyONu1bGh0n0F4zdh0ptS286DxNfB
         AZKzOIkfS90DRHROmvOMJfssr3HKLjz1dKEjCD4Eoe0dfpjxA/jPGihPe1LSWZoJ2K6w
         jUDm2Fkw2kZ+jgFsjOUcZD5LygEjkm70F84JsqnsTG+gLRm3Sbm08gLVKEaFumAX2fls
         5uvTsvlvxPMh1AV/3JY6XIaeST8tNlp6ME2KbTSVzewsb6FAZNkeN1GeHNj2BAcKUarv
         gRpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfkHJfOEr+lopvmytp2CSsTKFWi4EUWL83Ecx0PI364jwdX+QHEubnaJICn5kmGCNPwdNE5SUhAgTZmWMa9e0bJ/W8uZX0
X-Gm-Message-State: AOJu0YwQ9eXFX/bMgrJKx+y1k/UZVx6a2SC5LKEQOg8fKYf7FxNqe8/x
	PkBWM4tqi7yQnADYtRR49RIYeRnL18bjkNfkXJ31E7KGOw3BApkPm6e8hYK8UhMdVfwWRUVKgWy
	5cp0FJPZ0mBNQ9B6Hik59pofOr3JDKmEHwclI
X-Google-Smtp-Source: AGHT+IFmjWx4jmE9L5glK9sxCuDhR9yuIwx4w1bWAtsEL2yAdxwoTMv6ywb6r+xUTNAM1biVj/QSEEfv+Y7+6rTzLFs=
X-Received: by 2002:a05:6102:1484:b0:480:758f:c7a4 with SMTP id
 ada2fe7eead31-48077eb1de5mr35225553137.34.1716190583535; Mon, 20 May 2024
 00:36:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com> <ZkeUTix0Ojn5eHKP@linux.dev>
 <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk>
In-Reply-To: <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 May 2024 08:35:47 +0100
Message-ID: <CA+EHjTxJe8yjVkhc=2fENJoMZs+MTR=9AZLmYcxZ5HxNnUOaQw@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
To: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, 
	rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver and Mark,

On Fri, May 17, 2024 at 7:19=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Fri, May 17, 2024 at 05:30:54PM +0000, Oliver Upton wrote:
>
> > Hmm... Is there any reason why we need to be concerned about preserving
> > host SVE state?
>
> > The syscall ABI has it that only the first 128 bits of the vector
> > registers are preserved by the kernel, and I see no reason why we
> > couldn't apply a similar restriction to KVM_RUN HVCs into EL2. We'd nee=
d
> > to eagerly flush the vector registers on entry to avoid disclosing gues=
t
> > usage of SVE.
>
> > What you have is certainly correct, I just wonder if we're going out of
> > our way to save/restore 0's for larger VLs.
>
> Not just larger VLs, there's also the P registers even for 128 bit SVE.
>
> I think it'd be sensible to discard.  A big part of why the host ABI is
> like that is that the AAPCS makes the SVE specific state caller
> preserved on function calls, with syscalls mirroring that.  This means
> that even if the kernel is using FP the HVC would need to be inline in a
> function using SVE in order to get any state that needs to be preserved
> in there, or there'd need to be some other non-AAPCS thing going on.  We
> already ensure that any EL0 state is saved prior to trying to run a VM,
> I've not checked the interaction with pKVM here but if there's any
> issues I'd hope it's not too difficult to close them.

The reason for that is that in pKVM we want to avoid leaking any
information about protected VM activity to the host, including whether
the VM might have performed fpsimd/sve operations. Therefore, we need
to ensure that the host SVE state looks the same after a protected
guest has run as it did before a protected guest has run.

It would be correct to only save/restore the host's fpsimd state
(i.e., first 128 bits of the vector registers), which is what KVM does
in other modes. However, unless we always zero out the rest of the
state, regardless whether the protected guest has used fpsimd/sve,
then the host would be able to find out that the guest has in fact
performed fpsimd/sve operations.

This isn't necessary for non-protected VMs, but Marc thought that for
now it would be better to simplify things and have pKVM behave the
same way for both protected and non-protected VMs. As a future
optimization for non-protected VMs, we could have them behave as VMs
in other modes.

Thanks,
/fuad
