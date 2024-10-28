Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00F7189B91
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132208; cv=none; b=cpKggnBXFBzE2zcHS8/Fu4nkDejGmxBZ0d4Yg7ksNnZzl+Pf+f6EK55tZJv3SuzR5Tmhc908mfSvjNFAC0gn5C7h2RtQEIW6R6OsWY7Z0y1pERU1H/WWkV1kgToi90udV5AyQuI+48lmRbIVCMfG/rl88C9Y0U7mOUl4Euppe7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132208; c=relaxed/simple;
	bh=MCuj36U2xT0FvuYrK3fCtE4ZGf8SH2uMTrCXoXdPD7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QPDpdTm/m8Hzq0HZZi/r80z8kz4ZdcVNuwSOkGZJv1fkKvLPjqF1J8G7HHZRQ4gSJrEvsR4Ld4BxmsxZeJlt2kQ5WQC4sE8qcWMGt8bGTK1OtVhlKByU1Dy56jSNLdXWYTlndNO20SQtE3Lclju2W5nLehuFTgF3Pctu+Z6FIb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zsmXQP1G; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zsmXQP1G"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c9362c26d8so9808111a12.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 09:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730132204; x=1730737004; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wqc0Mytncd4ocb+4kmZP30a/3t9yuKUeJQBreLTvPE=;
        b=zsmXQP1GnT6DX4zifGIAPI8NKVu0qfkXDBNtIIQH9lvsPZsuux2/VxhyWgXJt9qe99
         ru02+fZTHDkousLRpWSKuQWHJClb8vbh0uxUwH+ZzCS8vRK2vuXOoHQD98NxI4ZN5kMF
         EENpK0q7wYjRMC28VV6nDil8oFnXRJJqj3USh+Ch3k+33WUnfNv5XoB0BO+lZl2TUKjM
         aHYszXapjFm469N0NLsSp2eFj7j2ws1bIdBEFLLtJ1YQXsJBm/p4cymTwxSGeLwEceQS
         /zfrhUuT+XBEyJP0/YnOMAhbT/CcDtaAZji61H+FegtLIezSq8NEqeUKajRbRAzWsi2g
         GOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730132204; x=1730737004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wqc0Mytncd4ocb+4kmZP30a/3t9yuKUeJQBreLTvPE=;
        b=hrdc1cMVPjf7mXYzugYs6q5aNkNvuftwSQYZXnT3gbdtuGai0tN3EfORSemO7uGA09
         e/ZJZG6FnbPAwVeXhcgg7fPOewyRYe3UMN1y4BrBdtDR13A5iNcV7Al+Xbg7AczCuXCd
         2ltnpOvHfQZHTK+B62g3h8BncuZF5NNJZmdwj96M0SUnFYpTeac2IZzBZLaYzwzUavNS
         hFMGl+ukkawPiGEsV6MZBUbTwF52Ce39iX0W7PkyLHnEiR7lCY8RRFt+0qBjAXLT0Ft2
         K0Eti1nJGxFZWKhZjZgN+P7N7VWN0mfEyl8SA4xYgecObA0JHZ5S4pswwc6ot7xgjTCs
         3N0A==
X-Forwarded-Encrypted: i=1; AJvYcCWO8k5lah6M4RQKzAG+BEj5kbiJEkcgEmdo+r2uP0TviZ316VtTd3wnNG7eCDxWoEjxyi2Gu84=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSyuiU38kv9XM2AMX3ZyOB+0ylOYohMk5hiaVjwHyijLIU5/eN
	jLl2UmQm8j5D8res7iodhJ7xzvWmjMejugIl5dLeWp0Sw7CRufQWJ0utdb1f5yFEpfzpVOwtRuH
	6n9NwhWsliVQhqhFfHfqqfKz6OqjimtE0cFvceA==
X-Google-Smtp-Source: AGHT+IFSr9SWfgXnn1VX0OvmWu0cAtcZmGcuumJXCuQuyg7HC2Kje6V2twZXQfCfvpGcOd/Llmg2R9DBtIU36NHY3sQ=
X-Received: by 2002:a05:6402:d08:b0:5cb:77d1:fd7f with SMTP id
 4fb4d7f45d1cf-5cc196360f8mr133123a12.7.1730132203869; Mon, 28 Oct 2024
 09:16:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com> <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com> <Zxub7ol4p8P_sWF8@redhat.com>
In-Reply-To: <Zxub7ol4p8P_sWF8@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 28 Oct 2024 16:16:31 +0000
Message-ID: <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, cohuck@redhat.com, 
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev, 
	richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
	oliver.upton@linux.dev, sebott@redhat.com, 
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, abologna@redhat.com, 
	jdenemar@redhat.com, shahuang@redhat.com, mark.rutland@arm.com, 
	philmd@linaro.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Oct 2024 at 14:24, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
> On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
> > On 10/25/24 15:06, Daniel P. Berrang=C3=A9 wrote:
> > > Also, is this naming convention really the same one that users
> > > will see when they look at /proc/cpuinfo to view features ? It
> > No it is not. I do agree that the custom cpu model is very low level. I=
t
> > is very well suited to test all series turning ID regs as writable but
> > this would require an extra layer that adapts /proc/cpuinfo feature
> > level to this regid/field abstraction.
> >
> > In /cpu/proc you will see somethink like:
> >  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp
> > asimdhp cpuid asimdrdm lrcpc dcpop asimddp
>
> Right, IMHO, this is the terminology that QEMU must use in user
> facing APIs.

/proc/cpuinfo's naming is rather weird for historical
reasons (for instance there is only one FEAT_FP16 feature
but cpuinfo lists "fphp" and "asimdhp" separately).
Currently QEMU only has to care about cpuinfo name tags
in linux-user/elfload.c where there's a bunch of data
structures for "what hwcaps do we need to advertise
given what the CPU has?". I would definitely prefer it if
we could use architectural feature names...

On other architectures do we do anything to forbid
invalid combinations? For Arm there are architectural
rules about feature X requiring features Y and Z.
Are we going to just let the user create a CPU that
the guest OS will barf on if they want to? (The
user-experience for that is potentially not very nice,
because something like "-cpu cortex-a57,+sve" seems like
something you might want to do but isn't actually valid;
even listing the direct required dependency of FEAT_SVE
like "-cpu cortex-a57,+sve,+fp16" isn't sufficient
because SVE is optional-from-v8.2 and so a guest could
in theory assume the presence of anything mandatory in
v8.1 and v8.2. But even merely diagnosing invalid
combinations is a huge pain, and automagically pulling
in every mandatory implicit or explicit dependency
seems like it might be surprising to users, as well as
being annoying to implement. Currently we sidestep
all of these problems by (a) only allowing the command
line to disable a feature, not to enable it where it
didn't previously exist and (b) mostly not providing
command line flags for individual features...)

thanks
-- PMM
