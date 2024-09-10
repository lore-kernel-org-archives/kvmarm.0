Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6281917DC
	for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 12:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725972624; cv=none; b=cSrkXVXdMz4p4A2ZkFLKFYnDQip2jq7nGoW+8rm9TUk4t0R1t+oDLkxsPbnPyLfANUp8VWnoUztdNXIoGTadnu/okEJ+RE1UTpQk6dn1bPPFYrc1wEsoY1+rwHS56O1TQXjnz609pp/wWL9qb0cl8GK5A1m7uwSr82oLw8sBcX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725972624; c=relaxed/simple;
	bh=4K9jCqd61FstY+tiOK7u1b0OMQE/jpRZDOsKqZzoF5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X3u4tfAHVsnd6sQJHin1rPB/zX7qxWi6YnkdW9j3N7yFS8l/8Zo2cOF74LosWj2cjEii+FGY1cZai/VnI6GDP7fStQbaBhxbC7liRiGVb5LQ8odYfgi3qPcc8j2JDFXKbeD21t+AY6oLRLA2cNSBRfqHOLAe9Wi1SBFSFx22lw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HhwYvQy0; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HhwYvQy0"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4581cec6079so271101cf.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 05:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725972622; x=1726577422; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FcouFsU8rhSkcvo6yfFdu/m5DEEbh8yoSVzU5RM1bvE=;
        b=HhwYvQy0GwK1xFM3P1pXr9OUT7i+LHC1y0m2k5JO5aZsb9utCQr4j67vQAincqcGAk
         HMD1fdHb7dqVnO4eY0mAYY7qpGPQDCMklIq4PPQJvAlDE5s47WwXj8ynzDY7J4rIpINk
         XormTQVrJBrNhp9J19cQrF1wTfelnBThVihGDUQAOgd186aAZkKtWnnHGTdDnp+Ty7Rj
         vHsuXppg7fFaA1OjVkzP/NIna5OPVzb3U4EvxIsjpffevfhBXtfQ1q99POz8ipK2DfWn
         ASAilC3CXieTQB9j+FB4Mj+D/3gespwjMjpC5zVTY5dcxbVEeQIXep/WtD6T/+Mj5LYr
         JMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725972622; x=1726577422;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcouFsU8rhSkcvo6yfFdu/m5DEEbh8yoSVzU5RM1bvE=;
        b=s2s1uaLF17ZGe8h55Nn6AlH18NpQgfmmzz+gXQ1PlH9Mm9yUTZY9E3ci/IBEmtq3du
         nunYlMtDDP3AOrudlxt+TUIowcQqIukZprkl+k6/T29Bk0u3g/0C0egF04RckfHtzPi1
         3q9abNqmdaUDmlbFB6uDOiBlJy+b+f9YXZnZdUosldGD6zw16YvHfAKs9SLGGDglhd9B
         n23IrzzTxHUYo/vQLp+1ePKaJRSM9S0fbzsOIKDj8J8SAEPveDGWeFAuewr8kltfwg+K
         h5ocUhr2RxEpj48g7PlhcXs3JSMZYgWK/2Pjg5fgM8ogxDJFhCU/GDObI7TMSGDAwROl
         5tuA==
X-Forwarded-Encrypted: i=1; AJvYcCWe48TEKtDBf4H6lKLzt5NIaPAMJE46eNmGBQtAdHbDAKwejsaCHIc88bKjEip0AcekKws/eSk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxiai4vfp/TTJk1WuarWLS9c+7/NwPOw1/NEO5R1o/8UQqq2Nw+
	lnlrz4jXFc0QcQQGDN3kxe5DloofQGeEfNEqCiES9gswmT8ARjI8HwhpmagOiTUBryy+s1U1wSD
	iN3zWmmjsRxdf0GZaZUAs1jyELDCBXijw0WQZ
X-Google-Smtp-Source: AGHT+IENT1A6LP3VdAe45m2x00YvXLDNfLd7ukdNuDsDHX8OwJG2Dq0uzGT1TgSVD8vzbOyWJgJ+dM+GukNyHJ2/vr0=
X-Received: by 2002:a05:622a:413:b0:447:e847:486 with SMTP id
 d75a77b69052e-4583ede608emr2382871cf.3.1725972622040; Tue, 10 Sep 2024
 05:50:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org> <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com> <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
 <CA+EHjTyCvG2KL=LPhbAf+Wo66QoC_EMk1xn+R9X-yKunHQ-JhA@mail.gmail.com>
 <Ztspjf0SHx7nz2lV@finisterre.sirena.org.uk> <CA+EHjTyjVMw5CtEiLoZzvnnano94UGx_URhFBd7BRYm89K+XmQ@mail.gmail.com>
 <ZttDmNTX0vuddRrZ@finisterre.sirena.org.uk>
In-Reply-To: <ZttDmNTX0vuddRrZ@finisterre.sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Sep 2024 13:49:37 +0100
Message-ID: <CA+EHjTww9OjB3OH85x_2Hs_yiaFxQwYXLZKn7o5MqUALkFyKMg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for SVE state
To: Mark Brown <broonie@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

On Fri, 6 Sept 2024 at 19:03, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Sep 06, 2024 at 05:14:09PM +0100, Fuad Tabba wrote:
> > On Fri, 6 Sept 2024 at 17:10, Mark Brown <broonie@kernel.org> wrote:
> > > On Fri, Sep 06, 2024 at 04:35:29PM +0100, Fuad Tabba wrote:
>
> > > > Yes, but that's not really the issue here, unless I'm missing
> > > > something else. The issue is that pKVM needs to store the host's SVE
> > > > state too, to be able to restore it. So hiding non-symmetrically
> > > > supported VLs for the guests shouldn't be relevant.
>
> > > If the host kernel is also running at EL1 and it's only the hypervisor
> > > running at EL2 then the hypervisor can control the VLs that the host
> > > kernel is able to access?
>
> > Yes it can. But do we want to impose limits on host VLs when running
> > pKVM that might not exist without pKVM?
>
> I mean, at the minute the host kernel will just not configure any
> non-shared VLs so pKVM isn't making a difference anyway.  Even when we
> add kernel mode SVE usage kernel mode FP is preemptable and schedulable
> so we'd not likely want to use non-shared VLs there either.  If someone
> ever felt moved to add support for using any non-shared VLs the most
> likely usage would be for userspace and we'd constrain any tasks using
> SVE to the cores that support their VLs similar to how we handle CPUs
> with no 32 bit support.  Hopefully the scheduler would cope well with
> that.
>
> > Although AFAIK, such hardware doesn't exist in practice, the reason we
> > went down this rabbit hole from the beginning was to ensure that we
> > wouldn't run into problems if it were to happen.
>
> Yes, it's not an issue with any presently known hardware - the issue is
> leaving nasty surprises should someone build it rather than anything
> immediately practical.  Ideally they won't.
>
> My general feeling is that it would have been perfectly fine for pKVM to
> enforce what the host kernel wants to do anyway, if we ever do add
> support for using asymmetric VLs and care about doing so on a system
> running pKVM then dealing with pKVM imposed limits at that time seems
> more than reasonable.  It probably wouldn't be the largest part of the
> work.  Equally we now have the code so we may as well use it?  It's not
> imposing huge overheads.

From pKVM, this would work and other than the potential for future
support for using asymmetric VLs, I don't really see a problem. Much
of the complexity was an attempt not to make pKVM more restrictive
than other modes.

Cheers,
/fuad
