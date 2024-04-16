Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE39136E0A
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291192; cv=none; b=FA5ofNsFX6EG3jA8Hj7mtY5j2ACH3smoncb9yQ+u3NzgwfsozQ5Z0f/QGHpjV4TBJAun5wXOi4ZzxuolYFNb1dsR4w28MOUpEeWddy5cxzDf40fzKIlAxwxgLtqJzav5pOEPRgEaiLmJQezuUlZqsQ+x7jjRO5jDWf0oIVNw3Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291192; c=relaxed/simple;
	bh=B4JIi6DEW2RK1Pq8QnQP6E8XYhKhqTYmZAoiuMZXnHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pM/g5pM1opyIpMSLOHvd/srntwgJFrYcMzPV5hpe3l6vc4Jp/TbhJEm0aiKZYT0ys7zUcFZTtGaRXIsulBl0qTJNfM01jDGDenFzdhNWxhfIqT8VQgad1X5ULEDI8Q+jgL1y+0x7oWfefv1Fi+c9XoEZP5irPAWVRfwrdjmRHVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZfY8exAS; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZfY8exAS"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5a49261093cso2536225eaf.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 11:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713291190; x=1713895990; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6mwCmlcE07mUb4qpIqNoKeDxA/8pmq38lvHubSfde8=;
        b=ZfY8exASDCd/8fS6RhmKFxGgNUCQkFOXI1ZVRb9gCQWMoKqrSLDDLDqcD7MAanVzpB
         cDbKE2dG8bfc2045yz9/b60HFoArGJxcBBd9ggXSKcwrn8KDcRFPHCD9HW3vza33dCJH
         8/OGVeUj2BvC9H5bkabb45rylp10irCSYbYnATMjz5n1qpf3FtFSOC7I2wX97mWPRd6c
         HNbWH2B+fi78Ju8iEl6F4PLp4pI/Of0sQ736VW8nAdrsQCzUde9jOeZseF0Nh5BE6JFL
         7IZwyAzGTQ3oMLKJhwNVNZVXvNi5KzSajBWlqWEGU3Si4p99lpQatHXEDQK8HRFsh62D
         ZwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713291190; x=1713895990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V6mwCmlcE07mUb4qpIqNoKeDxA/8pmq38lvHubSfde8=;
        b=Drb1mY6AsBskQ8UXEDjxfe8ZLHRd6rMoyT5bAhJMgFNA7je+TlR1VbrJsYzcAaI3Ym
         yZ4AFOWi8kjqfszQUO7gR/ji8CF/3mHbrWOHjTp1YmRAmR3hPP6d7rqPkQI2ecfeivdR
         8Jt8+tyxWR/g9VGVufSSszrSJVLBr+1x6tm94ESU7f4bHaq3Z5pji4Vrer7B97BQRvoD
         Zv2fBulc5RJ4aERCFQyuIGdm9K8QGt8UsoOYl/1/iBp8H+9PntnnHfN3btk+gKvxlWBS
         r+dGkJ1N3NUHs1m5ugfuppYrpUmOpW6RvP0JuJmpErInzsOtGrapdZbo97Ff7fMlDNMX
         FMqw==
X-Gm-Message-State: AOJu0Yy8LKMqISTg2Kefriy66Jr7gk+Wg/yIGhCgfGgRhjdJXDEXZ6YM
	px4sYQilmy66KMj0MrdrTYnewwOYHqJCoJD1mHoDBG8oFAnpf6jlOJhEQNxLU7fDSqv1Ugqy5jn
	9LAh0anHSi/jHX1ni8xlAYEjlHNk81ENXlVYf
X-Google-Smtp-Source: AGHT+IEkyXKM+OQCsukBQMOZia3Gr7DTHf2+svFLCb0h9MQQVdo0+QlH/bDmmbsEgOkwxPN4Uv111Z/tpcWUfauxpDY=
X-Received: by 2002:a05:6359:504c:b0:187:1a77:f1c1 with SMTP id
 om12-20020a056359504c00b001871a77f1c1mr6192236rwb.28.1713291189690; Tue, 16
 Apr 2024 11:13:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com> <20240416095638.3620345-14-tabba@google.com>
 <Zh6y9osWthu-gPtN@linux.dev> <CA+EHjTx5A7Kcyv6U1b-rpz7xyKDmObnLVBQfZmCNKgcsTVVQfw@mail.gmail.com>
 <Zh6_MoLeS4goC9xx@linux.dev>
In-Reply-To: <Zh6_MoLeS4goC9xx@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 16 Apr 2024 19:12:33 +0100
Message-ID: <CA+EHjTxLbX=oh87Aio6-evneBBez6iya4Typ7B5dkjL030JLxg@mail.gmail.com>
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

On Tue, Apr 16, 2024 at 7:11=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Tue, Apr 16, 2024 at 07:07:36PM +0100, Fuad Tabba wrote:
> > Hi,
> >
> > On Tue, Apr 16, 2024 at 6:18=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Tue, Apr 16, 2024 at 10:56:04AM +0100, Fuad Tabba wrote:
> > > > -static inline bool kvm_vm_is_protected(struct kvm *kvm)
> > > > -{
> > > > -     return false;
> > > > -}
> > > > +#define kvm_vm_is_protected(kvm)     ((kvm)->arch.pkvm.enabled)
> > >
> > > Shouldn't this predicate check the static key (i.e.
> > > is_protected_kvm_enabled()) first? In fact, you could hoist that chec=
k
> > > here and just have vcpu_is_protected() call this. Unless I've missed
> > > something obvious...
> >
> > This check is for whether this particular VM is protected, not whether
> > we're running in protected mode.
>
> I get that, but pVMs don't exist outside of protected mode.
>
> What I'm suggesting is:
>
> #define kvm_vm_is_protected(kvm) (is_protected_kvm_enabled() && (kvm)->ar=
ch.pkvm.enabled)

Sorry, I just realized that I misunderstood your comment as you were
replying. Having vcpu_is_protected() call this make sense, and I think
I even have that in a future patch that I should bring forward to this
series.

And I will apply your suggestion on the respin.

Cheers,
/fuad

> --
> Thanks,
> Oliver
