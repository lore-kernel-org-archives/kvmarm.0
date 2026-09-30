Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D190E4D7D20
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 12:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771719; cv=none; b=iIgjKrxtHdU1qDrZ2Zyqdlxou5l3wSU1V7QaWaKHp6BOeEb4SeFGt4hfYDw1Z1GjnmA68XNTj2zbwlS5jdQGuBVWVMIVWvSf5SCJ0IEqYAUPBCxAbS8y3ZWdmrI2B1AJ8Eonqm0Dy/+/r6kLwOeLcs847lA3wmk5cxl9vsip0W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771719; c=relaxed/simple;
	bh=5jJpaYHmzwnaHuefeCeSgSHSsu0Ck7lHvt0zzvmE6Jk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=edsb1HwTwsr2hrLtOzo+IJlv+Y7vsRbywjHXQ1rEiuqse1F4TT+CruGU09IszCcrBkwRqFJWfdXtAlYcRU5P5QyhAQKLAUQi0a5Hrvvvt6IJ9akCgYNfo6bNxZHGftYlAVZAEbAEyuti9PaPcSuAssxYJ4L4TRhYZW/3MTUHRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cZ0omPbH; arc=none smtp.client-ip=91.218.175.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cZ0omPbH"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5jJpaYHmzwnaHuefeCeSgSHSsu0Ck7lHvt0zzvmE6Jk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790771714; v=1; x=1791376514;
 b=cZ0omPbHlpq92s1zLPZNjNXOXK4Z3KLC4IzVooMwUS5qBvFEUGN4ER1VayEJ0rj2iSbF66RV
 xAXXm6hI6gKk62A2hTqdYvUybfstmjrW8tnckQwCr8Nt7D1cmc+HRRigCm6Frj230/Er/oCmtRi
 qVyIMC5BTDINjIbuSlGYly80=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a15bae808514dceb;
	Wed, 30 Sep 2026 12:35:13 +0000
X-Mizu-Trace-ID: a15bae808514dceb
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b8f42bb8a9so529e87.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 05:35:09 -0700 (PDT)
X-Gm-Message-State: AFq9FYJs+/0Ez7VxBtoKTAjSnqI3KLfaAWkS350Y0ROyDgVTwPm6Sduz
	1tAczqnhXB/5JrF7fCMX0ahmVjOaOdZCMYH69DwoPf+dhNaXUeKXWtn9SiUKc8/p43smc3DdeRa
	YOqjsAG/WhaRTzuKcVRhIu+5OZ5o1dS9/p+U0JiiB
X-Received: by 2002:ac2:4e14:0:b0:5b5:e890:1953 with SMTP id
 2adb3069b0e04-5ba3d1a32bdmr110742e87.12.1790771708519; Wed, 30 Sep 2026
 05:35:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929093548.3598547-1-maz@kernel.org> <cover.1790708299.git.fuad.tabba@linux.dev>
 <e6bf4bc51a311df19866a0ee3e27970846257b70.1790708299.git.fuad.tabba@linux.dev>
 <861pab3p5s.wl-maz@kernel.org>
In-Reply-To: <861pab3p5s.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 30 Sep 2026 13:34:32 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzP01b4J+ppK9fq-=5Kh-kEfynk0YfDmg57H7NekWHD=Q@mail.gmail.com>
X-Gm-Features: AclHuK-qXXX5RGymd7eG9Ryi-Ik6oairQlvSl5zFzxSRfF9xO6C1aISVYLK76aY
Message-ID: <CA+EHjTzP01b4J+ppK9fq-=5Kh-kEfynk0YfDmg57H7NekWHD=Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: selftests: Add an ITS MOVALL test
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Yuchao Zhang <ndaugoing@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 30 Sept 2026 at 13:21, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 29 Sep 2026 20:04:52 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > Map LPI A to vCPU0's collection and LPI B to vCPU1's, remap vCPU0's
> > collection to vCPU2 and MOVALL vCPU0's LPIs there, then inject both. A
> > must be taken on vCPU2 and B on vCPU1. KVM's MAPC handling already moves
> > A to vCPU2, so only MOVALL handling can move B: without "KVM: arm64:
> > vgic-its: Fix MOVALL handling of source redistributor", it moves B to
> > vCPU2 as well.
>
> MOVALL is about moving the pending bits (see 5.3.13 in the IHI0069H.b
> spec).  Doing MOVALL first and only then injecting the interrupts
> doesn't quite check the MOVALL requirement. That doesn't impact KVM
> itself (we don't use pending tables at all), but you probably don't
> want to hardcode implementation specific behaviours here.

Ack.

[...]
>
> There seem to be a lot of commonality with the existing
> vgic_lpi_stress test.  I'd rather we make this test the container for
> most ITS-related tests, instead of coming up with new individual
> tests.

If you think this test is worth having, I'll respin v2 that way.

Cheers,
/fuad

> Thanks,
>
>         N,
>
> --
> Without deviation from the norm, progress is not possible.
