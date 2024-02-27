Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498EF7BAE7
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 09:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709026704; cv=none; b=qHYMFWl1A0Vw+L0FUh1pMWq7RAHt/V+rCxZq4OsvpSpV6t2hH9REfccouRGwZxvf7dSnfs3E/mcxpoA3kZJrvkxBUDJgVedS+qZAs9hgbSzgZYGmlGQ3GL1kRVityjpvAUn9DDJf2Ls/UPJxW91B6IjHA9+JdLbs+rPlpxd0aEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709026704; c=relaxed/simple;
	bh=lITNheftSYMR04YfLtv3K2IE6PAf+peApENOiHb/BYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMnVzYPlHP0+I1tLG55A839aqN6nWDI4eJk4ahMplrcwFYLFkL/PP81bezTn80RE7gwBZInAURzORvIqaGKfYvVTpPdxJvv9ySN3nZA4hsqZ4kke/oHr1ToItCpLsNecHSU3aY9JEY8mdpVzSk8WVaeZMtLvF4xAFo8jbGVnjEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IH6jVQ0g; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IH6jVQ0g"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-47253bce437so156646137.2
        for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 01:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709026702; x=1709631502; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lITNheftSYMR04YfLtv3K2IE6PAf+peApENOiHb/BYE=;
        b=IH6jVQ0gFgswKClUOpdiYOQxa36xGLqrbugYwKUocRkej3dL9rlNFloUo77Q6rbUMo
         YinU+gbUTbN4mCqtD7JTHTYJAwC+0Gp/cG1Wt5mSMLUwkaP6BTD3NQl3aq5m73ciWTUX
         +Ot5Yfxp6nsc+uaVCj8wzXpp7vIZ0+EnXHyBxpAYf6pcx6DUOBaRu0m2XlCoIaNg/u2E
         LsNtPQh3hhwNVx6hZgpN4IpVur5z+gV6zT2ex/yWT4ONOkJJ5xVPC5J/ewRtFSKXoyu1
         maxsGmkNxEFAIt5raIXgnMwKTv1NeTvS3Ia8Apo1SUjPhuqJoakx1YTZ8XxmryJ/eb0M
         L7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709026702; x=1709631502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lITNheftSYMR04YfLtv3K2IE6PAf+peApENOiHb/BYE=;
        b=TrotGrU9lrs0hFow8pCIENLo+1p1nyu0QRds5/lDkDjRwiZeqOeA8qy+RffqWm0j+R
         JlXefDk8fzSvl7DPT7E1Jjx8buN9x/3WCyRaWTs3r2vBt2D1eYlQqzeW1S5UXcpCCUMJ
         n3C8GHHw7vcN1jViwiZQzITihSkeVabX3QSKdOcWZiDa3+IBfWE2SBmdNkpGjWPDf59a
         RtZRavmY3EsZhb5+BQyUiZtZUaXz2xnCflYMPlHul6eqy6FPx8QSbkPvoM2rW+y9LjiB
         F3Huc082LhYtsqGzjHV+pdnT/kUJ12JtWo8X4dHLTDGDumpUx91z/jWMro+GpJJrl6ud
         4tcA==
X-Forwarded-Encrypted: i=1; AJvYcCWmyRb6dGQyr2+EemC2Ubf4hDVm9894DfX5Y4W4gKtogHW3genBjbchWe0ePVvsuFd64rGKQXjTNRV6yg8nTjXbItUufaT/
X-Gm-Message-State: AOJu0Yyg5a1V/Od6aREobVxZLnzSsgaxhyht9zSps2w19Bf6vHthBAe7
	YEcJmyWmJC0PjXUQakhIC4ChftJ0Un5TWJvqP9CDGpIKpvNHNzGYrjUVpt/m6Jo4ZBVHVEe//gs
	YHr7xM+aBu2xfOzSFPYRMHYzBNnr2nOvdusK4
X-Google-Smtp-Source: AGHT+IGtUSpwVCXklISxbQaZarJMI7q14JSgkprPOp6y3p4Ot6amI6BiQXX96hlj61rZiLNkfUPjDqMpwEnxXQpNCPo=
X-Received: by 2002:a67:ed57:0:b0:471:e15d:71bf with SMTP id
 m23-20020a67ed57000000b00471e15d71bfmr4819795vsp.30.1709026702061; Tue, 27
 Feb 2024 01:38:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
In-Reply-To: <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Feb 2024 09:37:44 +0000
Message-ID: <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Mon, Feb 26, 2024 at 9:47=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 22.02.24 17:10, Fuad Tabba wrote:
> > This series adds restricted mmap() support to guest_memfd [1], as
> > well as support guest_memfd on pKVM/arm64.
> >
> > This series is based on Linux 6.8-rc4 + our pKVM core series [2].
> > The KVM core patches apply to Linux 6.8-rc4 (patches 1-6), but
> > the remainder (patches 7-26) require the pKVM core series. A git
> > repo with this series applied can be found here [3]. We have a
> > (WIP) kvmtool port capable of running the code in this series
> > [4]. For a technical deep dive into pKVM, please refer to Quentin
> > Perret's KVM Forum Presentation [5, 6].
> >
> > I've covered some of the issues presented here in my LPC 2023
> > presentation [7].
> >
> > We haven't started using this in Android yet, but we aim to move
> > away from anonymous memory to guest_memfd once we have the
> > necessary support merged upstream. Others (e.g., Gunyah [8]) are
> > also looking into guest_memfd for similar reasons as us.
> >
> > By design, guest_memfd cannot be mapped, read, or written by the
> > host userspace. In pKVM, memory shared between a protected guest
> > and the host is shared in-place, unlike the other confidential
> > computing solutions that guest_memfd was originally envisaged for
> > (e.g, TDX).
>
> Can you elaborate (or point to a summary) why pKVM has to be special
> here? Why can't you use guest_memfd only for private memory and another
> (ordinary) memfd for shared memory, like the other confidential
> computing technologies are planning to?

Because the same memory location can switch back and forth between
being shared and private in-place. The host/vmm doesn't know
beforehand which parts of the guest's private memory might be shared
with it later, therefore, it cannot use guest_memfd() for the private
memory and anonymous memory for the shared memory without resorting to
copying. Even if it did know beforehand, it wouldn't help much since
that memory can change back to being private later on. Other
confidential computing proposals like TDX and Arm CCA don't share in
place, and need to copy shared data between private and shared memory.

If you're interested, there was also a more detailed discussion about
this in an earlier guest_memfd() thread [1]

> What's the main reason for that decision and can it be avoided?
> (s390x also shares in-place, but doesn't need any special-casing like
> guest_memfd provides)

In our current implementation of pKVM, we use anonymous memory with a
long-term gup, and the host ends up with valid mappings. This isn't
just a problem for pKVM, but also for TDX and Gunyah [2, 3]. In TDX,
accessing guest private memory can be fatal to the host and the system
as a whole since it could result in a machine check. In arm64 it's not
necessarily fatal to the system as a whole if a userspace process were
to attempt the access. However, a userspace process could trick the
host kernel to try to access the protected guest memory, e.g., by
having a process A strace a malicious process B which passes protected
guest memory as argument to a syscall.

What makes pKVM and Gunyah special is that both can easily share
memory (and its contents) in place, since it's not encrypted, and
convert memory locations between shared/unshared. I'm not familiar
with how s390x handles sharing in place, or how it handles memory
donated to the guest. I assume it's by donating anonymous memory. I
would be also interested to know how it handles and recovers from
similar situations, i.e., host (userspace or kernel) trying to access
guest protected memory.

Thank you,
/fuad

[1] https://lore.kernel.org/all/YkcTTY4YjQs5BRhE@google.com/

[2] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.com/

[3] https://lore.kernel.org/all/20240222-gunyah-v17-0-1e9da6763d38@quicinc.=
com/



>
> --
> Cheers,
>
> David / dhildenb
>
