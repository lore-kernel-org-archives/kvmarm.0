Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6350211CA0
	for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 00:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730247425; cv=none; b=B7DWPIRTH76lJTwasj1fcsbXInwCPhGuJROjPIIPO8KCTmbergC5z8fwlHMiWM5RUDG3Btgl9+iY4uvn72aEpRhBzUlTidNU8qE3CXqsYgpHzlkO9axRfR2ArUg90TDAC7lARRjQxYeG3kmQ57d27wZ6nu+X0SoRn6aG57AIeAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730247425; c=relaxed/simple;
	bh=kL+nSJs/k5eiTKkckVjqUhseoyaNVTxIYCNgVKz9HcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHezEeN7mvlyjbT+ldeOtJBX1GWo336SSX/4fF4DdePC4nTWldnw7ryMViI8GCEaHa6N+HdRKYBjlWu8r8ga84urfjwfWwXP6fL9F7wGq7MKCXvQh7xgjuascLaYgpbfz7wr3clvCsmfJmwQTOV/jlJ8IRXzgpbQ+WDOZhQ0Mko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yU1Z1RtU; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yU1Z1RtU"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4608dddaa35so81241cf.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 17:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730247422; x=1730852222; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCmWu47sjTGX3jar/Dwdhp+9K5zVvqpEnsEiRnQbuZ4=;
        b=yU1Z1RtUSgWmXwOqotCO3U2BJXLrj9BPhtung4NH5haZwR1oUXZyHS8U2HKNKQPEnX
         pxvl5Gw8CjSMKrTU6u+9sBntEh2nLJHJNa/Ax6ZqHFhPMkQtuCpEWu8lb5kTpEsMb5j2
         C+xMo7n4XjAG9tzF244BjL0KjNt6w82WJnnFoCFvBVl9nY72aSOMlZ2fd1fh1mbFhZpr
         /esdISDECoX7iFh0uIxypDwWGH5MaxcKw47P+mw16UMb4+H47Tg8utl9h8oB1Fbc/sqT
         iKBOkf3vVhcvdgdcVqHyjssvpn9hPEq5toMgpdpjXFS1JjPNQvvq2Ig6Ks/9iOp0whr4
         Yn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730247422; x=1730852222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCmWu47sjTGX3jar/Dwdhp+9K5zVvqpEnsEiRnQbuZ4=;
        b=vz1BDaQktmkdncvA0UrCRgYe4hmmn6fpzJ7TrZOm2DwgsqTGrhoRrz7pbos4sQUyLD
         k6XJlT2Gdw+0d83kI38dEja1onRKbR8zz2M9uxMkVoI9zZ8BUXwtqH3DGlT0dIR+6ffG
         ayp45hhQ3xqMzYwgmkBRAcYrZywdDsqxf+rnNc+0Z3A5hUzF912cBFbqOvBIIQ3uTaTY
         b89y2pEh9zZ16zDzTN76cv9C4hAsJCiio9w6Nss9jGFOPTOk1l29FmEVWgcSAcl2udbW
         t5arhsFbgIkBBaoUdiz7E1lrRIGT0XsiWRLstrqxRovZMvWE6+tjvXmQp0gTo/+isQw4
         vvLA==
X-Forwarded-Encrypted: i=1; AJvYcCVKbiWgEbW6ChhW2ugPyekuoLx70SKJLM5p65OmCQIZG/TsojPB3pcC8Jq9e021x7ZeztgBxF0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz95OZluxe3tRxS+j1p8N6cxfX0DaIQ0v5ZzUGunPMM0BqjnLoY
	3b4DeSXl5n7rrD+g0PL9854N9ZrGpgar+hZoRlbNzyZdxIt4gPjxFBWMjIp2wM6FWUYbXtIR4Rw
	/DON51rHo4mI6gtsAL0ZoI2tt3SrPlm44oxwA
X-Gm-Gg: ASbGnctzMOPtT67b/DnkkKCdQSpTOvTpZJvXEIKq/3nWAsnyyt3+fec+tAaWxe5z8qj
	+9AlbVvPbvgdd1EC2E6iqI7w+z6jMcskRXD2LFsrjvwyyZy2ZMkpD39Ne8AoxYq2H
X-Google-Smtp-Source: AGHT+IEaPibastFimQxIGHeancJlv6kb2dWI4ioRIOkCpZsX0edKkHwzu5czUo3lz8BTR5AsStAJ1WI8kMngUNb28NI=
X-Received: by 2002:ac8:5d91:0:b0:460:48f1:5a49 with SMTP id
 d75a77b69052e-46164f057c4mr6157321cf.14.1730247422165; Tue, 29 Oct 2024
 17:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241028234533.942542-1-rananta@google.com> <868qu63mdo.wl-maz@kernel.org>
 <CAJHc60x3sGdi2_mg_9uxecPYwZMBR11m1oEKPEH4RTYaF8eHdQ@mail.gmail.com> <865xpa3fwe.wl-maz@kernel.org>
In-Reply-To: <865xpa3fwe.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 29 Oct 2024 17:16:48 -0700
Message-ID: <CAJHc60xQNeTwSBuPhrKO_JBuikqZ7R=BM5rkWht3YwieVXwkHg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Get rid of userspace_irqchip_in_use
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 29 Oct 2024 17:06:09 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Tue, Oct 29, 2024 at 9:27=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Mon, 28 Oct 2024 23:45:33 +0000,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > Did you have a chance to check whether this had any negative impact o=
n
> > > actual workloads? Since the entry/exit code is a bit of a hot spot,
> > > I'd like to make sure we're not penalising the common case (I only
> > > wrote this patch while waiting in an airport, and didn't test it at
> > > all).
> > >
> > I ran the kvm selftests, kvm-unit-tests and booted a linux guest to
> > test the change and noticed no failures.
> > Any specific test you want to try out?
>
> My question is not about failures (I didn't expect any), but
> specifically about *performance*, and whether checking the flag
> without a static key can lead to any performance drop on the hot path.
>
> Can you please run an exit-heavy workload (such as hackbench, for
> example), and report any significant delta you could measure?

Oh, I see. I ran hackbench and micro-bench from kvm-unit-tests (which
also causes a lot of entry/exits), on Ampere Altra with kernel at
v6.12-rc1, and see no significant difference in perf.

hackbench:
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Ran on a guest with 64 vCPUs and backed by 8G of memory. The results
are an average of 3 runs:

Task groups | Baseline | Patch | Approx. entry/exits
----------------|------------|--------- |------------------------
100              | 0.154     | 0.164  | 150k
250              | 0.456     | 0.458  | 500k
500              | 0.851     | 0.826  | 920k
(Total tasks for each row =3D=3D task groups * 40)

kvm-unit-tests micro-bench
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The test causes ~530k entry/exits.

Baseline:

name                                    total ns                         av=
g ns
---------------------------------------------------------------------------=
-----------------
hvc                                  20095360.0                          30=
6.0
mmio_read_user           110350040.0                         1683.0
mmio_read_vgic              29572840.0                          451.0
eoi                                        964080.0
        14.0
ipi                                   126236640.0                         1=
926.0
lpi                                   142848920.0                         2=
179.0
timer_10ms                          231040.0                          902.0


Patch:

name                                    total ns                         av=
g ns
---------------------------------------------------------------------------=
-----------------
hvc                                  20067680.0                            =
306.0
mmio_read_user           109513800.0                         1671.0
mmio_read_vgic              29190080.0                           445.0
eoi                                       963400.0
        14.0
ipi                                  116481640.0                          1=
777.0
lpi                                  136556000.0                          2=
083.0
timer_10ms                         234120.0                            914.=
0

Thank you.
Raghavendra
