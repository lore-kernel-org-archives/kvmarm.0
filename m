Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97238224890
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742491590; cv=none; b=Kk1Dkb/s9nwhAOwKtH4oHj8yTs3aYQlKpX3+yE0X3hu8wyKc5xXx3yp5e6f0UR4nuBrzVEY/xp3ozfy+J2N2bmDF/V0y5qEd8BRurdy4VRGIsmuC8eVOf8CGW6cpkJyf2ikLTlthiMvg60QUFEll46zbfTJ/GeCk6Zu39vR6D8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742491590; c=relaxed/simple;
	bh=dbLH2bKRPbpvhbDhyJijYnxIQOvnm4I3EdH+g7kA1QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Av4tsa5/gvnWmhDjDkuyYsrK7AGBiYmg0jVvCjvmgi8z8LBpZXUFg18iMwz/Zm683zgXssb/oX8rJp0RheqL8yYor1ODwju4wEKwEv4D9Gaqkn16B7BbrWmtknZyQMzLvmX5R3hoKMJ+J/aTXvLmpNnQmahSNz5CFY9K4HLQeKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fClB0avD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fClB0avD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742491587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUFR6AsD7gUx8Px4BvBzkVDxZQ1SsnbGA0GFylA0Z7k=;
	b=fClB0avD+gYHlJ30KEEgApwflVV22jf0Y1T+NN/GdEDUP1TSYBUuMt2k5CZkYM1lWt0e+4
	W8hgN4ZFDMJTmkFLG8akuSe06qtzLRRJ69jxs7/N2FCGkZumzrKwiuuOPdW/GSrisf2Tdm
	B+tNxFVysT59FvN48sD2LXgBe8zYmL4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-fNhtvDUlPKqyVzbrltI73Q-1; Thu, 20 Mar 2025 13:23:35 -0400
X-MC-Unique: fNhtvDUlPKqyVzbrltI73Q-1
X-Mimecast-MFC-AGG-ID: fNhtvDUlPKqyVzbrltI73Q_1742491414
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39131851046so470851f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 10:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742491414; x=1743096214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUFR6AsD7gUx8Px4BvBzkVDxZQ1SsnbGA0GFylA0Z7k=;
        b=EWXk51IeFjJzrsRaOX6ka7P/IO4kCz/mtLTkWngsuJLzxs6jWSgU/feORBWXBbspex
         9t+M0BRHviFS8aNHyG2V8olIBnhuAlHrDdLVOH2T9xjLv0ZDGStrdqXyVRAG4CY4ZiAm
         slDiPEN2wBX/rtPoFJysseXabBKg0Klw95V5KUkB5supBQLxrxIOIC8FxxZsBEr03jLq
         xn2vtHG3YSyvrVPjb0q74mcieyd7TisAndd/FyUveMhGArLKhCQnuUMdEwzaqBFLOFjE
         0TOZDMKfxKaZe1MxpOSS7g/IRk7bmk52uVKn+hgSOdYRs+AwJCzUBh7ba1PxyBD2KQzL
         UXmg==
X-Forwarded-Encrypted: i=1; AJvYcCXQEmrwNOUSlAIydvgtI4LUONPicAshSrET7fyiuNmKqRU05I2Zk33RknyyG+G/Iot/0wjMLd0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyr8yHouveYgvSH5GSWGdMCFvneW9fBbF3DQUED2nkGVD4ESwyg
	9urs3aFWu93L23//pTbMoUnKD0XOKPRdVQIr9cmsNCNMJnxyjpQ0z66InhCreQodIiSktx/89cq
	4PxsUW5D+QT7/mR56B2Hg4yiZMtEGW/6fwzH67SyWDUJFkfltFRC4oUNUz4OmRRWqgt2wdbwbjc
	lltYvUw81mPGnbxM/d3OD+9pRBDuec
X-Gm-Gg: ASbGncs166EZU2cVCQFxhJGjy8wE1O5EqzG5PLBC/NF2oiRoF/v1EVcfMWpfNSB2eXQ
	/vfW0fLwnnRzw35Jmwiia1i+UusaSmyz8noOkFZjdYvbRSSnswd4/b4nXgqgYH85yHf/JWXTGRQ
	==
X-Received: by 2002:a5d:6c61:0:b0:38f:2856:7d96 with SMTP id ffacd0b85a97d-3997f8f605cmr421252f8f.1.1742491414235;
        Thu, 20 Mar 2025 10:23:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0Iy3+ELXSOcGKqjjNcijqtjRKyZWH2Uy/EbnYOYdMFiTRlvTKJiFQxtAtj3dChuBu4/j+YNjTHeSa0Li9mH4=
X-Received: by 2002:a5d:6c61:0:b0:38f:2856:7d96 with SMTP id
 ffacd0b85a97d-3997f8f605cmr421220f8f.1.1742491413842; Thu, 20 Mar 2025
 10:23:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z9uZpZKfqWP8ZwH8@linux.dev> <86ecyrn9hf.wl-maz@kernel.org> <Z9wZ8EuChPyJ6PiK@linux.dev>
In-Reply-To: <Z9wZ8EuChPyJ6PiK@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 20 Mar 2025 18:23:22 +0100
X-Gm-Features: AQ5f1Jro3DCd-dTgCxYhklGF6-TcO4Lalc6LpGkXTh7aC2K02ARegu6zlLFUsOI
Message-ID: <CABgObfbHz1iyrH69JiF19RC4SSiYVbRN1P2+KRkFWSEg_2mjbQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.15
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Will Deacon <will@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ott <sebott@redhat.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Fuad Tabba <tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tEnTeiY82ciIVgKdx2zNMcKsyq0uMHKTswxM4BGWqn4_1742491414
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 2:37=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hey,
>
> On Thu, Mar 20, 2025 at 12:59:40PM +0000, Marc Zyngier wrote:
> > Paolo,
> >
> > On Thu, 20 Mar 2025 04:29:25 +0000,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > Hi Paolo,
> > >
> > > Here's the latest pile o' patches for 6.15. The pull is based on a la=
ter
> > > -rc than I usually aim for to handle some conflicts with fixes that w=
ent
> > > in 6.14, but all of these patches have had exposure in -next for a go=
od
> > > while.
> > >
> > > There was a small conflict with the arm perf tree, which was addresse=
d
> > > by Will pulling a prefix of the M1 PMU branch:
> > >
> > >   https://lore.kernel.org/linux-next/20250312201853.0d75d9fe@canb.auu=
g.org.au/
> >
> > When you merge this, please also apply the patch below to address a
> > mismerge issue caught by Stephen, which causes a build breakage.
>
> The kvmarm-6.15 tag is fine, I caught this immediately when I was doing
> testing for the pull request but forgot to push the fix to /next in
> addition to the tag.

Great, pulled now. Thanks!

Paolo

> Fixing that right now.
>
> Thanks,
> Oliver
>

