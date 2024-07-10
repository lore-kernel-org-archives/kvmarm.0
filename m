Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6027819247B
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626714; cv=none; b=cjUhe9gTrgK600aflZE9xhpyxf1n350qqHhGtRYUybc38GGLfo6AJDktSrreB9EOS+uBFemuxk+DKZe2uKjjUm/RXEtQoIvCv5ulUEz8x+xUZ/lNkj26id40lvVs+hb2r/otcZPwONOlfB3aXXPnNng4gSxQ9//LCwDNSnnaHws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626714; c=relaxed/simple;
	bh=Yd7wN4MEwb/4Ych5ZfYI8ZDswiwmmeax1EQOB34ZhJk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OV6NMkMByKFIPNVh782CbD/9pkAG6o1Eji9yibVCkSNyc/cT0+7iObukijC+U44XRvhvzzBRruiA6ftwbeHWXGqAonLHNrBeZHnJos9O/tE06OqVaaaiRDfYe9wpOJLfuZ5hBh+r2KehSIDuiTIPrSbelcmtvQiSo6lPX++yVTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nrY2OV1f; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nrY2OV1f"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fb05b9e222so40944555ad.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 08:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720626713; x=1721231513; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2S/Ws8T8aRzTnaLMwEZxjsu7iN6mSUkQ05y/iw/B/rc=;
        b=nrY2OV1f4B1QrhCC4yfz+AAoyCQbsGoMdvUysaL/4eSab2vMnj0mWIwljviUfsHxao
         4L4+oYe58RODhfjxnV6AxmNHASreVc9dlLG5N7r7ZTHg8XbzKU7z1L+CpsnvKAcjKjYT
         SmCcTRReyX7j452THMaOjDIyXebivsKBbTTjYlgj4Zf/HNTrR+AfG7AdRy7Sq9xUyoZA
         ES3rTh2KlfG6sx22HxfZlDtWP2iNZLs8LTdcXkLGAqU2Q0ShTlVSsTkWKhyeN9MCLqUl
         BTwWA54vDwldv1jBuQl722i0fdx5BZWDQRzTpFpO/2uUuYkAhTu3OkbqrjAZWHExr5t9
         Z7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720626713; x=1721231513;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2S/Ws8T8aRzTnaLMwEZxjsu7iN6mSUkQ05y/iw/B/rc=;
        b=QtRYwmfE+J1pxbf7vAMylcW8qPkGPRBljwIJV8IcpgYTiaSvnmWnwWw7LWLCBdW88Q
         Z6NbgotxKaXJSnnwTj/V3YFMq0F9/qz3gzMNt+j92XFXBUtGSeoeodZDnib9w5y9ygo1
         E4ab4Y2vP9R+M4E6L6zokEX0vQ1zSle4jMnv6Y+62WfRtjEHTqlxRyUMS4mg4tcXRXYt
         MFMJR1SKclV39L9OPcquf+GzwSzhL7pIeddkqQbWj7BPVSLe8Hd5dspeCyLX/bL7rbWJ
         4LmAAoTJ9qaF9bzCjUTEBbw+Ev0u0qCd+0jPMNB5KC++brHmpfnL34ljEX4A5xl0+j57
         JegQ==
X-Forwarded-Encrypted: i=1; AJvYcCWombaN8/5vnemzQSyDbM3tCYrY9CCSoKahc+x7YFvibfvbn0lUwxDOvQ18IGMQxqKqKed0ECKKggzls2ZjUX/YGdVW905y
X-Gm-Message-State: AOJu0YzR2Q5Wp4E8GU8ZHthEKCi3nz8ESQg0Dnj6vAseudc0+unKm7M5
	f2PLTjG3exhoC8+Rwa3ADGLaHWggmBTBxgknlh5wOQfJixRIe1jQ+Wa8tVX04AXJPJ1GcG3Dind
	T1A==
X-Google-Smtp-Source: AGHT+IGFDWyL4oVIv+kd3eR4ozKAgHx5u/arXUHJsTVnFMVwi1+9LesGIr7Enb4S0IMxOwQQwYsx6SyO0KU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dad2:b0:1f7:175a:69ab with SMTP id
 d9443c01a7336-1fbb6ce3e7dmr4023085ad.4.1720626712651; Wed, 10 Jul 2024
 08:51:52 -0700 (PDT)
Date: Wed, 10 Jul 2024 08:51:51 -0700
In-Reply-To: <CALzav=cwu3M2nLHwZLCTF=eGWx2Nq+=TuHMuGTfZCNa27mLs1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240503181734.1467938-1-dmatlack@google.com> <171874683295.1901599.10170158200177384059.b4-ty@google.com>
 <CALzav=cwu3M2nLHwZLCTF=eGWx2Nq+=TuHMuGTfZCNa27mLs1A@mail.gmail.com>
Message-ID: <Zo6uFz187FBYnQiY@google.com>
Subject: Re: [PATCH v3 0/3] KVM: Set vcpu->preempted/ready iff scheduled out
 while running
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 01, 2024, David Matlack wrote:
> On Tue, Jun 18, 2024 at 2:41=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, 03 May 2024 11:17:31 -0700, David Matlack wrote:
> > > This series changes KVM to mark a vCPU as preempted/ready if-and-only=
-if
> > > it's scheduled out while running. i.e. Do not mark a vCPU
> > > preempted/ready if it's scheduled out during a non-KVM_RUN ioctl() or
> > > when userspace is doing KVM_RUN with immediate_exit=3Dtrue.
> > >
> > > This is a logical extension of commit 54aa83c90198 ("KVM: x86: do not
> > > set st->preempted when going back to user space"), which  stopped
> > > marking a vCPU as preempted when returning to userspace. But if users=
pace
> > > invokes a KVM vCPU ioctl() that gets preempted, the vCPU will be mark=
ed
> > > preempted/ready. This is arguably incorrect behavior since the vCPU w=
as
> > > not actually preempted while the guest was running, it was preempted
> > > while doing something on behalf of userspace.
> > >
> > > [...]
> >
> > Applied to kvm-x86 generic, with minor changelog tweaks (me thinks you'=
ve been
> > away from upstream too long ;-) ).  Thanks!
>=20
> Thanks for the cleanups. Looks like you replaced "[Tt]his commit"
> throughout. Anything else (so I can avoid the same mistakes in the
> future)?

I don't think so?  The "This commit" stuff is the only thing that I remembe=
r, so
any other tweaks can't be that important :-)
