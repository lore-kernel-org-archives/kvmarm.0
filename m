Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B1B134411
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713290896; cv=none; b=YVVNo38TPwqTUUaC/Fe/sK+1b2b6yLRpRuRqDda5/Pwo+8ZEUnNr+UDOEhzVV3gSLNI+mL/2iuJK+d9iS4BHKPd8tEwRQ4NNcYI8DVBDG56r0msFca/KFI/lHFeeUQ3plB0gyA+B35gFrS6uNw6wbgatlEQ7VEhD0z90vzH84oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713290896; c=relaxed/simple;
	bh=eLZku9ho/r6YA7LQobjqEu89SkBOQ/60FBs/qY6DRkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jjwWvvwNqVJtVz20smqKuhODvCREfKwdDz4mirIPL70AImvUAtCmhSn285x8pfHilzwzGxVzjkJ53vvNITUt4hfIJ2q7mvAT2UzltVhZfjW0N+CYRzYODUFRPwpLmOamEJ7Gssobfuj1jRVgPjN2ef+MSGr2Fll751vkW3aAw5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vE6lY8FQ; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vE6lY8FQ"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7e8a4947785so1143241.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 11:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713290894; x=1713895694; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8C6jaa9Z9YHDY0LjQWFAlEoPmRqCkbMzUsNQ+YCsJHI=;
        b=vE6lY8FQ96hpkNExckglpy1KfZNrtoKWsfL4EkdqoLrOBWQjfJ41+NukhxkiMX8fb7
         6BoBPmXnL0xUThmqcsTnW8Jbus8NI+TortqgJ9VPsPk04ZExV1RzaPkEuCN1v/puJZTj
         73Wip7uCorgLRJ/gsTaUO7rw4cifI4SqbqH6ZH/YpHc/ivVBUnjiNgS69mKX3m7sG3wN
         LDs2ywQxPVXSQMFNdZJZoWbhSgOyiy4aPKdFM7MsGqPyKHlQqBKn5q7Rg4AQulXG35ii
         63pVDrDQ2i24P3sX7yz9lVYx6V++vnUm61C1xxLdg4dsq05lc899GXbdlDJ7Tb4/C0H6
         u9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713290894; x=1713895694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8C6jaa9Z9YHDY0LjQWFAlEoPmRqCkbMzUsNQ+YCsJHI=;
        b=IZ3ESXn7ROLv2U5wuEPqLyJyTzB0FV8zSkbTBYDJ638wCMsRxf+jkZuD/qcKsN67Fd
         rWFKPpWbppn8aHozY+qF7UUIVY4rCi22tJmPm1XuBzAenJ+D7p+b28wPiMS6OnuDqSS9
         qDiD272BouHAC7yTPsAB2hVKCxwFheJuP3F2zoUmW+6lUz9f3peYC8vDbB9AqSUq5WgR
         QnNlNVWhq0p/mdpoRRQWtdv2CEmidkE3I5o6cLlh+TlFxJ2/FVArHEZ0DpS05RQIx1fE
         VZQcCDWCBH02+Ucgfxu3f+J9LUJfMlwb19nzZc6S9HWNJHzsAFRwfcEMHCPF762rsziJ
         h5QA==
X-Gm-Message-State: AOJu0YyD+Li6y/a+oKMfwsBzbmIIgKLlChGGQ8fp9MS/BJk7OkpzGmTz
	ERxQoIHRF6Fb0cAW8FBQm1l4AnmVwxTYX8kGt3WVWA2WSZA5PirkNkyZTcFgafwHNASXF4e2UAe
	rxLEzbuUNFYUJ4suchgDOPXtD98VkMs2sizKc
X-Google-Smtp-Source: AGHT+IF8yJA+w1Ra8Fs7UIW87TYblwVLLI/Ii+VjYBNBNqvP16t1INcQkLmgIjkv3h/Iv5PqvzrDlJrrKjLOqOsaHrA=
X-Received: by 2002:a05:6102:4414:b0:47b:9456:c8f4 with SMTP id
 df20-20020a056102441400b0047b9456c8f4mr283616vsb.10.1713290892918; Tue, 16
 Apr 2024 11:08:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com> <20240416095638.3620345-14-tabba@google.com>
 <Zh6y9osWthu-gPtN@linux.dev>
In-Reply-To: <Zh6y9osWthu-gPtN@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 16 Apr 2024 19:07:36 +0100
Message-ID: <CA+EHjTx5A7Kcyv6U1b-rpz7xyKDmObnLVBQfZmCNKgcsTVVQfw@mail.gmail.com>
Subject: Re: [PATCH v2 13/47] KVM: arm64: Introduce predicates to check for
 protected state
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 16, 2024 at 6:18=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Tue, Apr 16, 2024 at 10:56:04AM +0100, Fuad Tabba wrote:
> > -static inline bool kvm_vm_is_protected(struct kvm *kvm)
> > -{
> > -     return false;
> > -}
> > +#define kvm_vm_is_protected(kvm)     ((kvm)->arch.pkvm.enabled)
>
> Shouldn't this predicate check the static key (i.e.
> is_protected_kvm_enabled()) first? In fact, you could hoist that check
> here and just have vcpu_is_protected() call this. Unless I've missed
> something obvious...

This check is for whether this particular VM is protected, not whether
we're running in protected mode.

Cheers,
/fuad

>
> --
> Thanks,
> Oliver
