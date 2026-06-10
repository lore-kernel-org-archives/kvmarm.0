Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D0340A46
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 16:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781109600; cv=none; b=Ngtwa4wtiNMJk5H0YpzEqSwlOyBhF0r7jcXBQttDfTCKMMWLI5s6DM6kPiLMmFMSrIVgFalTmkZ0A8iEpDrF5GBAKhh1ZQAECR0HZ8bs579sLlRcN5Bl2G5E/smqqHilBQNnpdZBCQENpEKwQdsBBV1T//aA/TD8A2Wrm3EZBJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781109600; c=relaxed/simple;
	bh=Z7vIw7KQP0N58o/IuszZIO+3/9P2eBf3Z6F8b/gnZGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rX51GLmUud2e9g5b3OGzIfxb6+TP73ht07QnokADh9lh7gUQ4NrVc/T8TYxpusgYLCP3Sy8RLoUyq/89gnDl0a8Ai+eO+u+mVDx5vBx5hPeykRsFrblYwAknZWPD652sbiUGdgfq/dergjdb+47BJRyVim9zktgz5bhyVaH5X6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OvMH6ICw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvMH6ICw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AA21F0089D
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781109599;
	bh=fY+/iwaOPYWuto/d+Egk+UNuK/OHewkC2tBLDoQLz7I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OvMH6ICwhQKkIUGA+edTgG0PKBmg5SlpfwOfYZ34l99VedDIaip3L+7MVDvXeCWtt
	 g6U+cI5bZoe9q0fCZEtjBzOHV3t6rRmH35PBUegQ8cs4IM6bmf/NfyuAm+3cWKMGmm
	 nOcq1MRjcvSMKNHpJbT4mB1RI3qUGDFgHOUrHN+1t4/pCHrzVOvsNhuMMPTrN4G8mg
	 XScp2AqXA3lTp3p8oqqznFl6pxZxsx4lgcFElF9zUsEHus5rI8M85UjZdrnfGPDIoe
	 GXcqfRFhmJ6xHRsH2Vjqpui/a8MKhZBlxv+QuJaIl86LZvyjneghsdu51/ZQ91+y03
	 iaXs6PqJQLhIQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-beb2a97cc9aso1154459866b.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 09:39:59 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw4kTBhyQPkVQNwbpAC58/w5lELHspfxFSRlPvR6xiDgOrT8cbq
	/RNP6HEEe83qoQVLtZX5iHwELW4iPHPAt3ZRANEnmXdtyaHL34z5Ktgw7aYNU44XcGD+m73tcMK
	m4z7B/zZ8BI9C8TfurxXdTndvsMZcdUQ=
X-Received: by 2002:a17:907:7fa8:b0:beb:4674:6a1d with SMTP id
 a640c23a62f3a-bf936bec9e4mr497683466b.11.1781109598524; Wed, 10 Jun 2026
 09:39:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260608081108.2244133-1-maz@kernel.org> <aicqzM4W4NN-GndT@google.com>
 <86ldcotbub.wl-maz@kernel.org> <CAO9r8zMpvxoVcDvWn3q0C0Dv=0Kknt_BqZ8KqddwuKa5bd44Dw@mail.gmail.com>
 <868q8mu0hr.wl-maz@kernel.org>
In-Reply-To: <868q8mu0hr.wl-maz@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 10 Jun 2026 09:39:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO8e9LCCevab2Rf9ArV9eHJ=L+n-hPWCGgkC47udEVARA@mail.gmail.com>
X-Gm-Features: AVVi8CcVcXwzy45XyjikMi6K7M6sV9Fac4tlWVWAJx-O0hPoeftmoxR-za9Ausc
Message-ID: <CAO9r8zO8e9LCCevab2Rf9ArV9eHJ=L+n-hPWCGgkC47udEVARA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Hold kvm->mmu_lock while initialising vcpu->arch.vncr_tlb
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 3:57=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Tue, 09 Jun 2026 18:57:26 +0100,
> Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > > > If yes, I think the code looks confusing, at least to a layman like
> > > > myself. It initially seems like the lock protects against concurren=
t
> > > > initializations, but then the NULL check is not done again under th=
e
> > > > lock. The goal of the lock is not clear without the original report=
.
> > > >
> > > > Mayeb it's clearer to explicitly use barriers if the goal is preven=
ting
> > > > reordering?
> > >
> > > This would require both the initialisation of vncr_tlb to use a store
> > > release, *and* all the other call sites to use a load acquire.
> > >
> > > I really don't think it is worth the churn, nor the (very small)
> > > burden on the readers.
> >
> > That's fair. I was mainly just pointing out my initial confusion and
> > that others may share it. Avoiding the churn on the readers' side is
> > understandable. Maybe a comment here would help explain why the lock
> > needs to be held?
>
> I have added this:
>
>         /*
>          * Taking the lock on assignment ensures that the TLB is
>          * seen as initialised when following the pointer (release
>          * semantics of the unlock), and avoids having acquires on
>          * each user which already take the lock.
>          */

Looks good, thank you!
