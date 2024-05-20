Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B199513398E
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227897; cv=none; b=d3oyKl852jLLAOIICt+AJfdXe7BGlbq2fEfDsnzb4N9zDhGd48E3R3+m02SOv0lhQaKm0CaYBsor1G9xYf2lHsz47ribMhw6pfBje+DflsCLFK35uOYsHNiBAeozNlYzudZaazYPuS5dF29gbdIY8KQBN+vob+CnBVLADYxUUew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227897; c=relaxed/simple;
	bh=lXf/dWJ+CMX0EUHndgxb5X3EU5aeks7Q+ouxkiPyhgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ikZaGt7xCOE1uKbuQLYuCP9caxH1c4jnwVvwuFkhFKXFR1Egn1qnPiQFgvH4LKqZulIbfXV5uuS06AsYPQLonZ6RMYiNmVYL/WN/SMcpgaP94uaRC65kRVMI2eNQHGJmR10kPcYypYhzZR0nhPUiL0xrsD4/LCBz2P9otH/xYuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gRKONZQx; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gRKONZQx"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7f7809ae952so1207486241.0
        for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 10:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227894; x=1716832694; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXf/dWJ+CMX0EUHndgxb5X3EU5aeks7Q+ouxkiPyhgM=;
        b=gRKONZQxrgMuYwiWHVBrcMVpqfas9vER6HH1z+e+wmVJfNmhpTQZjiGkcOBq9nloX5
         OQQIGN8Br+kHDJ98/1Nm2aNJIbdyDeyZzRi8zbhQ3l+W9niNqp77iljg9FN2Vtd2ESZi
         X+6W1JCZyaI7sA0oADryP57NOGxMv/JP6CivlqbMj0541c6+y7VOwpEU2p2onZlMIDM5
         1hQNL3pAmfOon1G0NvZI4EMJCvqa27I6sbN+twBDIuwimxyA2Tq1nhn82uVajad3FxC2
         HaSVtOjksf4ul5y9t8DPFdu1ai8H5SgklMiGL3vxowTOlhjTQIhFkXe5DNTPOvAeFCY/
         MnDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227894; x=1716832694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXf/dWJ+CMX0EUHndgxb5X3EU5aeks7Q+ouxkiPyhgM=;
        b=oWut1ut7KjOi7P1LkIGYWeuAUNX35OrxA+SkEiQK9lkLI5jstlH+tHOJlUQm5C6j/L
         kVA/JfgZhlFubiM2F4wBu7Ov0Fz6yECGyM82guW7YqPMeJdfG4VY17dGWV47N5LSw69a
         Zg6/n8hrotWsmTaJq0I9g7t2frJyR0wio9A5+VJIHaAC7MTPYABMi9ngUsdkRPNrZCaF
         29C/FvxAaA1zaUShQzXN4UWDuqtMAlayr7/s2l9GORf4CCzeK4rUdI624X5Yu0IpQvKF
         4wlXHBLCT59wdB348lTe+u9kLLwMSYPZKGvAq31C+a1M1WSnUIRrUE3aJfVJ/s+lFoIX
         yoow==
X-Forwarded-Encrypted: i=1; AJvYcCXQP+DmU1uIXye3FdgLmNnSg/T/o8EeEZEA4hw9HLc5T3BJPNA2nW7GrqUeHVjLxCdr+EghqMcsyV6LABg12KKM85l5wPog
X-Gm-Message-State: AOJu0YxN0H4HJ3e85dxrBMAqcvrjhmxCydFvKVvirWX2Sz5g3OEqYXt2
	cg57VbMsbWRCgaaVV9M82UsQeGKSYsWADba5yfBPAwEL4CnQFJP4NaU6xR0mGTb7iy4TED5N/Hm
	VkdkrNEzhcjTbBEXLFAFtqtfh/IKdzQJ+UTQq
X-Google-Smtp-Source: AGHT+IFQ6Ihzyl5J5suduzJ1TUq7nmbaiCJrsCbjHjOys+yo4p4L64AqnrIBuCZtOQrDkwn6qECsL+Y10RTWhVSgrNs=
X-Received: by 2002:a05:6102:2909:b0:47c:2ff2:8643 with SMTP id
 ada2fe7eead31-48077e1cf87mr26930887137.16.1716227894257; Mon, 20 May 2024
 10:58:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com> <ZkeUTix0Ojn5eHKP@linux.dev>
 <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk> <CA+EHjTxJe8yjVkhc=2fENJoMZs+MTR=9AZLmYcxZ5HxNnUOaQw@mail.gmail.com>
 <87pltg3ntq.wl-maz@kernel.org> <ZkuKYA6-u-eZmBOO@linux.dev>
In-Reply-To: <ZkuKYA6-u-eZmBOO@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 May 2024 18:57:36 +0100
Message-ID: <CA+EHjTyvRU13+LL=vyRTOykj5pbycVPce7dstXK1rpTF98jKFA@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Mon, May 20, 2024 at 6:37=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, May 20, 2024 at 09:11:13AM +0100, Marc Zyngier wrote:
> > On Mon, 20 May 2024 08:35:47 +0100, Fuad Tabba <tabba@google.com> wrote=
:
> > > The reason for that is that in pKVM we want to avoid leaking any
> > > information about protected VM activity to the host, including whethe=
r
> > > the VM might have performed fpsimd/sve operations. Therefore, we need
> > > to ensure that the host SVE state looks the same after a protected
> > > guest has run as it did before a protected guest has run.
>
> Wouldn't it be equally valid to just zero the state that will not be
> preserved regardless of whether or not the guest used fpsimd/sve?

Yes it would. I think I did mention that as an option. However, that
would need to be done at every protected guest exit, whereas restoring
the host SVE state only needs to be done if the guest has used
fpsimd/sve.

I think the code for the latter (i.e., zeroing out), would be simpler.
I'm happy to do it that way if you and the others think it's better.

> > > It would be correct to only save/restore the host's fpsimd state
> > > (i.e., first 128 bits of the vector registers), which is what KVM doe=
s
> > > in other modes. However, unless we always zero out the rest of the
> > > state, regardless whether the protected guest has used fpsimd/sve,
> > > then the host would be able to find out that the guest has in fact
> > > performed fpsimd/sve operations.
> > >
> > > This isn't necessary for non-protected VMs, but Marc thought that for
> > > now it would be better to simplify things and have pKVM behave the
> > > same way for both protected and non-protected VMs. As a future
> > > optimization for non-protected VMs, we could have them behave as VMs
> > > in other modes.
> >
> > And I stand by what I said. Having a hybrid mode is a maintenance
> > burden, and it will absolutely lead to some sort of horrible bugs (it
> > just take a look at the mailing list to see that we have no shortage
> > of bugs related to lazy FP/SVE handling).
>
> Agree, but I don't think the suggestion is in any way incompatible with
> eager save/restore of FP/SVE state.
>
> From the looks of it, we're *still* adding protected-mode specialization
> to save/restore the host's SVE state, even though we decided in commit
> 8383741ab2e7 ("KVM: arm64: Get rid of host SVE tracking/saving") that
> this was completely unnecessary in non-protected configurations.
>
> What I'm instead suggesting is that we make it part of the __kvm_vcpu_run=
() API
> that the non-overlapping SVE state gets discarded by the callee, which
> would align with an expectation that the host kernel has already done
> this upon syscall entry.
>
> Then all of the FPSIMD/SVE save/restore logic we have in the hyp 'just
> works' so long as we 0 the SVE registers before loading in the host's
> FPSIMD state.

If Marc is happy with this approach, I could do it that way. Either
way, I'll hack on it and present it as an alternative in my respin.

Cheers,
/fuad

> --
> Thanks,
> Oliver
