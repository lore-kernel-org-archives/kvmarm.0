Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E4A15EFCF
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 08:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328094; cv=none; b=kRY7rsO9I48OFJ3CLIYZgKAtR/ZDy60KI0RFQvbIVX7Bfv1/tvm10HlwBuP6tLt8XPx9qzOsUaeTRy8smtGbwjMo0N7bGSk8t6DCCQcQUDXrlkBVp/rrS0aNM9+JnKAVSPWGBadQerCZoa8MVGiFvjNr9IY8UcDcVdob6WodLBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328094; c=relaxed/simple;
	bh=J0ppvsYJDn/uBiK+Dx2Nj+HR1dAZmER5G+X+2sc/jDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+iruVib57nOTGkOMmlAPnMQTzR4rxJvOOq5N9RT+pFpUS2jB/3nnbR3ALbv31pV5yrdLEzUdmqNHdxrR8ba4zVyaRdbm+Z2eaq2rmpSxyQoO+wMEsxtZUh6g0bVRoYFjiA6FOVHsaQGEHGzXrUC5D2yM35xWVr07H+TyLC7HdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h0ZWoSyx; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h0ZWoSyx"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-7efcdc89872so493174241.3
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 01:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715328091; x=1715932891; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXaIaz96FC9x/DufjSq4j0JpImiTXmTueC/Vf88hP6o=;
        b=h0ZWoSyxptcuLE1chOar/HglKiYyN29mUy1H1eGywaskD4wr8WtD47TNygLgldUH7P
         +ctPkmm5hnfT3tICiii1zVZxLRL9BYYRX05W8EQsvOCQkFMfMYJuODvRkdXAWzkxoet9
         xPkWCsda/WfOJQkrJdRnQMwgYOjKMYHKq0VFWqZec29BKCzLFOusY5LjsD6mS3Vh697G
         8h8ah/oo5atP/tQLUHDZLQ/0ZOTxsKN9lNdWqCcSkYSSY7DHkKdfhBEaaV8Lxsdjis+K
         m9CUIrxMMCxurv1t7xSPz13OkSu4J8n904KDR2oGUKX7S3VALCKWCQwez9was93anBuh
         ffdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715328091; x=1715932891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXaIaz96FC9x/DufjSq4j0JpImiTXmTueC/Vf88hP6o=;
        b=KpSozjUuP+k2Tur42QYN6H4WLarhkKl7iVMn52Zh3APnufuP1f+W2s+lJsXJtNud4r
         GIqqAUjHwb3NFcS0xBs4HA1rxKHM2RVufNMKdRpIfDhpzp9SSt3I3lWeX61/mRivcpja
         huv3woCczq6MxK9V1ty3SBfe/nM5knKbbi2aKNQ/CxRfxxYR2cvB63cQt8w5uBDBeSux
         4lnxw2oI4HEsFkNZ7xnSy5bYe11xuRPUkHV3zq01Qt/eiVaPm0USL2BYlMDgdKqQTrHQ
         zcdhX3L5QZ3bkp6Rx6hqtbKAot2pr3ZgZIYqpblF85/k1Jj92QlCZgsAw8Wx+VtzDg2q
         FJlg==
X-Forwarded-Encrypted: i=1; AJvYcCU4VqTTbVuWlrOajIreK802TYNMMxuAzg4Fv356wODepbN2b4/8VpqvwrZAjy5kHwt10BE+oiJllC2hO8Jw9YYbuS6HZqBY
X-Gm-Message-State: AOJu0Ywa8hfmwikNlD9XHS77Qqov5f7b3UfMN+VdNa+0Gq1s+yaU+kyz
	kFIMyd1YxXIMH71cnrX9cWtLe6VofUmpdckd7ttrf+Einy+mOzK5PpvupvF1WQojNv6F/tj9f8Z
	AVKa1r9HV3WzxtI6o5zSx50e8HUuEcP1jHlmT
X-Google-Smtp-Source: AGHT+IFvSt/TAOCi0ksI/ua0J25vtTtSJOf6W+IJDzj19qcByDDQ9BDw2jsSxcUEYbr0gkX1PKOOve+vYLHUhJyC4mY=
X-Received: by 2002:a05:6102:570d:b0:47c:23b7:f50d with SMTP id
 ada2fe7eead31-48077e5d79cmr1813317137.35.1715328091517; Fri, 10 May 2024
 01:01:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com> <20240423150538.2103045-2-tabba@google.com>
 <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com> <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
 <d1435598-9a4d-1fc0-3355-9db78e6a7e27@huawei.com> <CA+EHjTzoD4wXhiG-uQ2xzrZkw5fLqjdOsiE87EdY5Z1qfvF7_g@mail.gmail.com>
 <86ttj6p062.wl-maz@kernel.org>
In-Reply-To: <86ttj6p062.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 10 May 2024 09:00:54 +0100
Message-ID: <CA+EHjTyFanD2R2QXy005RujcXeT3GTPRw+e4yfS77KfWbxTVRg@mail.gmail.com>
Subject: Re: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, 
	broonie@kernel.org, joey.gouly@arm.com, rananta@google.com, 
	smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Fri, May 10, 2024 at 8:59=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 10 May 2024 07:44:42 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi,
> >
> > On Fri, May 10, 2024 at 3:40=E2=80=AFAM Zenghui Yu <yuzenghui@huawei.co=
m> wrote:
> > >
> > > I asked that in protected mode, how do we save the host state? It loo=
ks
> > > to me that we only save it into EL2's private
> > > kvm_host_data->host_ctxt.fp_regs which the host kernel isn't aware of=
.
> > > How can host kernel restore the state for the current task later (e.g=
.,
> > > for host userspace accesses)? What am I missing?
> >
> > What I'm going to say applies only to protected VMs in protected mode,
> > i.e., non-protected VM's in protected mode use the mechanism above
> > (kvm_arch_vcpu_load_fp()).
> >
> > Also, the upstream code for pKVM isn't complete yet as we're still
> > upstreaming it, so you not being able to find something is our fault
> > not yours :) You can find my branch of pKVM, based on the latest
> > kvmarm/next here [1].
> >
> > For protected VMs, we don't want to lazily save/restore the host's
> > fpsimd state, because that could leak information to the host that the
> > protected guest is using fpsimd. Therefore, for protected VMs, the
> > host fpsimd state is maintained (saved/restored) in hyp (at EL2),
> > without the host needing to know or do anything about it.
>
> But I think that's a regression from the current status. It looks like
> now that the state is really private to EL2, nothing will restore the
> FP context on exit, while this was the case before we reworked this.
>
> It'd be good to plug this in 6.10, as this is a regression.

You're right. I'll send a patch to fix this.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
