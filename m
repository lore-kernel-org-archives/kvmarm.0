Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29072135C5
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775585791; cv=pass; b=SFH1s8AF2PjnWZJ6FwVk4NJYB84bIjeMQ0B6CoR+jQYtvG08nNN8L6TuV2Uoz4PU6p/lwNPGv64v2kkXPWCknEX1fkRZ1Gr7fV1yMhZrdj+8WF/53UJZk1tDXpRtilA9QEL4bObBKy1fp1h4+dHGecSeretaFbYZ5h3izsYp2p0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775585791; c=relaxed/simple;
	bh=W6jscBzEMJbJO/XmLXghl25PWfvdo5CVM/yBumOnlxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SMU/HoxPF/iXTKH4Pz8t4m5FEv4bPg/55mI/28O6nEaw0Q1BNXEFWZ2Yk10XwXuSkhexJ8gZt3c+3VLIsDqrElC3awUm6IYPS23PnDNgkTLvYqC7Hs7xNveaCULhMLx4lJR7gX+sEKcSxp6iiSffPfG6a+OFf6y/CoJdsUEILTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TQd0cysx; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TQd0cysx"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a283c44478so5969470e87.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Apr 2026 11:16:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775585787; cv=none;
        d=google.com; s=arc-20240605;
        b=lSEdO7Vj2iBd2a78nDyVnsxcLExxa7qYKNWihGrAsp3+CCk4yE3zULMskq/rIwx/Xv
         q1/gxOaWSzn87Rkw0XDUuKMmC+F1LvC2i72tQUO04ullbiQHTXS9AUo1/rCGdlg+oVM0
         2DyyOy5BGANxyf/U+IumkzCr3wHpztlbXEPkUAqzvQVb+n/bUgCi0N27V9dq4NcRlRPe
         /0MA8lpUQW6jBs5KkFQ5cmjOMLapCZdhr3VSDRxoN1mUKXlsL8jVg05fjw8A5Nyw33cP
         uFDMTQ6c8nm4JCfH70Ya0tqtk5+aYG/TZQEqMyEgaCyjG4eEoSwLi/AP9QzfjONdFCW1
         tU7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yRsBgBmzp23y8ZAP8I/cBBmEnn+NnIzhpJUPzQOsQ6E=;
        fh=TXYRTW2AdI1rI5ZVepnZ8Id4ihiEULDSnll39uXzYi8=;
        b=GYfvvbbB2ggLudb3QrfUtPHr9b3BYUX5Oma+iUtTA7m7BzDs5uoL1XyHilBMG625WE
         CGk+cStkclCyGNo9ViKU8aSxci7Z430yo2gcNNR2I5JHgGweXb70KlE4c2WpMtua5+GY
         OTH3sEN4rbIEc/AFxaxA01EElvmQFpLGp7zKMdd/LB9Py9dvNWwytR8shB46/TWvn1wb
         Meb+lYAMNZeKXXqnR9FdW8w5vfZ9x4925qhJatvDUnqIZpWmKwAHQy57otptAvHXh4aX
         MYz02C4VIdblqJYe8tA4Gj3twUqfHdC1XY+5mq2ECE/wJYV5Ska9pBFhfgusrkaKyYOp
         +T6A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775585787; x=1776190587; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRsBgBmzp23y8ZAP8I/cBBmEnn+NnIzhpJUPzQOsQ6E=;
        b=TQd0cysxWUwRaO5hZTw+tlFYt1uwMiCf53ASPQdygWD+S1N38Ugya4uhb56pO6VYpr
         L+AVoXNLMQLKLavS4xd0s3Rapb58l5vOast10cZ6lJ6WcQCPxBP9mcfddeLY4+sSMQ5W
         1+0CmxcXLa8o//mKWvVoUN9ALea7Qkf3Op7N1JkVq/f41g5nxj+IZLmXe+L/2TMPPhWQ
         fypUxI2g9MhNUL+hLmaMBTmHCwX3F6TL5ka70jhaFyfqkOZQb7nsHZjwklr2gdvjvUh+
         VkCQthcWl5cvduzLdqm2VSQ5oMHt1hJKHktk8YYKtkJzYPXbDMZ7XMGnJjFqwcKCquc9
         8kUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775585787; x=1776190587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yRsBgBmzp23y8ZAP8I/cBBmEnn+NnIzhpJUPzQOsQ6E=;
        b=Y7F7jehbOLSwKk2aoPnpel2gKgrgYJo77n3ESMqsHJT+y4V40haKUmyrt7ArZcb/X9
         Vg3Pdxl6hM1rUa7CF1qZeyE9t4C6r2EHuKsPq7uCdcn+yfoCBOn2FnGNax5RNxlpMCFp
         IGDbUBmhOvsBW55FBYJkRrsuLtA1E9pNjDqZDVet2OQuPndi+n2SGhvUU1ooaPMWRl9V
         VvyBmJqSrRqD5n2kPAG/w/QlALhkGwkFqebr62JN75sjh/afqdP4yNvcjFOv3Kk9F5Da
         XCRcoAG+qNeod+AWAVwooi26/Ri9WeHrc63yxWfHB0Prp2QQIaKulj6kQsY/nW81+a8V
         FW3w==
X-Forwarded-Encrypted: i=1; AJvYcCV0qemHaJelduZ8eOrx9VhjE0fhuRdg5GLl/lVPdL0rUTfq2WvxIdJ+WOuJpKV+UY/eAnrvMtU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwHJq7izYfewfKlBTO5ZK5lhSXai1aq7UIAKOz3MyCZ71vYWNW
	LTzAICnY9TmrFXFKkG68cSbJJYk09annvNRahTPI/Hx0EjiYd5MDbvZln3t21tOqkExIGCsAmCT
	8Tmf9cB+eWODLHyGSh3dA7ljUD5mIGfWs6svqYJd3
X-Gm-Gg: AeBDieuz424Q3GoS9Jw8bQNt12ih2ydhTom36LtsvlW6QlpnFiNdSSUzklAxNL1g4Kn
	OUAplgi6kiYj9aXxSu1mDdodQ+jHI//FRg2uq6AP46mvgdblSL7zKkkZpsq3kTKUUbg8/5dAfdR
	TPSagB63YR9WN9mQnVojbXpDVgPGDH1dI/a/UZmLXj+mxnSpJSn46sAbXKMp1XKg0S6HmNs8RXM
	jv6F71oZ1qtnMbbarcsFLQyJ46m1di7F/Ez2SmZuRlIv0pPotxmDu16yru+HW/OhqlIPWIzu8Ag
	DJq7WdPGSu/UbC8km6jzARhr/KXdZba9QK76h3i9
X-Received: by 2002:a05:6512:110d:b0:5a1:2e0c:86f0 with SMTP id
 2adb3069b0e04-5a33758f31emr4771796e87.37.1775585786712; Tue, 07 Apr 2026
 11:16:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316224349.2360482-1-jingzhangos@google.com> <20260324114312.GA438107@e124191.cambridge.arm.com>
In-Reply-To: <20260324114312.GA438107@e124191.cambridge.arm.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 7 Apr 2026 11:16:15 -0700
X-Gm-Features: AQROBzDArVOPc6ncoqbb__YZYRwX1sNbl8uVFaZ9pSAZu9OJrkYhbAp3gMqUG8o
Message-ID: <CAAdAUtjeYJ5sOQVB-t7U=KJ9JuCCmO9b2dwJsas7mkzNLu8WqA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] arm64: Add Stage-2 MMU and Nested
 Guest Framework
To: Joey Gouly <joey.gouly@arm.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 4:43=E2=80=AFAM Joey Gouly <joey.gouly@arm.com> wro=
te:
>
> On Mon, Mar 16, 2026 at 03:43:46PM -0700, Jing Zhang wrote:
> > This patch series introduces a lightweight infrastructure for managing =
ARM64
> > Stage-2 translation tables and executing nested guests. These component=
s are
> > essential for testing advanced virtualization features such as nested
> > virtualization (NV) and GICv4 direct interrupt injection.
> >
> > The series provides a generic Stage-2 MMU library supporting multiple
> > translation granules (4K, 16K, 64K) and dynamic page table management.
> > Building on this, it adds a guest execution framework that handles gues=
t
> > lifecycle management, context switching and guest exit routing. A new t=
est
> > case for Stage-2 MMU demand paging to verify fault handling.
> >
> > Please note that this is a very preliminary implementation intended as =
a
> > startup baseline for future work in virtualization testing. Users shoul=
d be
> > aware that because this is an early-stage baseline, some portions of th=
e code
> > may just happen to work in its current state. There might be critical
> > architectural elements or edge-case handling missing that will need to =
be
> > addressed as the framework matures.
> >
>
> Hi,
>
> I'm interested in this, I had a much more barebones (aka no stage2) guest
> framework thing that I sent out [1], but it seems more useful to try get =
this
> series merged.
>
> I will try get my tests working with this new framework, one thing missin=
g for
> me is support for executing at EL0.
>
> Thanks,
> Joey
>
> [1] https://lore.kernel.org/kvmarm/20260306142656.2775185-1-joey.gouly@ar=
m.com/#t
>

Hi Joey,

Will you add support for executing at EL0?

Thanks,
Jing

> > ---
> >
> > Jing Zhang (3):
> >   lib: arm64: Add stage2 page table management library
> >   lib: arm64: Add bare-metal guest execution framework
> >   arm64: Add Stage-2 MMU demand paging test
> >
> >  arm/Makefile.arm64         |   4 +
> >  arm/stage2-mmu-test.c      | 100 +++++++++
> >  lib/arm64/asm/guest.h      | 156 ++++++++++++++
> >  lib/arm64/asm/stage2_mmu.h |  74 +++++++
> >  lib/arm64/guest.c          | 197 ++++++++++++++++++
> >  lib/arm64/guest_arch.S     | 263 ++++++++++++++++++++++++
> >  lib/arm64/stage2_mmu.c     | 402 +++++++++++++++++++++++++++++++++++++
> >  7 files changed, 1196 insertions(+)
> >  create mode 100644 arm/stage2-mmu-test.c
> >  create mode 100644 lib/arm64/asm/guest.h
> >  create mode 100644 lib/arm64/asm/stage2_mmu.h
> >  create mode 100644 lib/arm64/guest.c
> >  create mode 100644 lib/arm64/guest_arch.S
> >  create mode 100644 lib/arm64/stage2_mmu.c
> >
> >
> > base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
> > --
> > 2.53.0.851.ga537e3e6e9-goog
> >
