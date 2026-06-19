Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AAB3750CF
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781874301; cv=none; b=ZDJ01U4YAs8XHwJvcILpecmNTq3nPQ9q4KaST+uZfQLcPPaJG+5z1beiJMxGqonIdnz8bv575CnmnyjKSRFluJQevpE1nVnKD+IaVBH+sWts0u+iagwJc751VKl4D4ARz562mQel8KIXcnKOOKuaRdhiws+oUhGJQFimQ4FkVjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781874301; c=relaxed/simple;
	bh=ici1LF63GDXSYFCSToUOrQfp47UqSNRyItTIEoyv/MM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZNRmjZxlfgXUpmsAwaAf3tQHCNFyDCPuGbcffusN0MOaOiWjP/QmxfoxEb0OQjux3YO8JuLSIdrTrk6y+7HZYHivFbq3mZEYdfUvWcarCwSTiw42L4IPoqrCMM265mluMdgnKlAw3/Hi1SjpmQFwNshtGV7k6GDooBK40OD0ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FbLVvisI; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FbLVvisI"
X-Forwarded-Encrypted: i=1; AFNElJ/X4NHR0Kg4q5BnMUMVVrmgGT/MKXECPYP+32w1z4L8VMY/PoqJgaOfukIWNq/ZFjiuwSN9cLc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781874296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8eUJpWCn5MJf55/QS+SBCOG38tqnqArz1EhXl+TSuU4=;
	b=FbLVvisIZwdod4JHZzfW+soX9HjAKkCaAhgwrCug7vwqSJR3ooMUsrWgBVbniXn5Ua/o7B
	HN5G4KSefm2qEGdEp+NWUfJg1j/T7nwWo+ilxXHuXzbGiohgRpX7s6UXwweCi7J3MCgL0c
	hk+bSiZq3YFpmPKnCz2hw+rpHI/7e8c=
X-Gm-Message-State: AOJu0Yx/AGpQbH/W7c3JlqpUEovXq1m0iacmjlLb30SVozgS5qWQvdry
	oKhgFToiEzYw3ohLJRD8Wqun43tI6aoxMHk/LJR9i2RwpfuzyaFd8YdbjYEkXl2EwFtN8dC42RW
	EqyO9iGT2lfrPR04StBfDmKIjj0/XxncYB2DA07fp
X-Received: by 2002:a05:622a:1492:b0:516:d25f:f038 with SMTP id
 d75a77b69052e-519e48866d4mr8409241cf.10.1781874293681; Fri, 19 Jun 2026
 06:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619115415.5475-1-will@kernel.org>
In-Reply-To: <20260619115415.5475-1-will@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 19 Jun 2026 14:04:17 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwzgapVvdf3qub5yruoPgVxKEo7Ghqn_a4P+Xu6t2O0Mg@mail.gmail.com>
X-Gm-Features: AVVi8CdtT6iWYhzS2QfrYKi0SSlD1aMfZs-XAIfL0QrxQh6c3aj9vGPKgTYHh_8
Message-ID: <CA+EHjTwzgapVvdf3qub5yruoPgVxKEo7Ghqn_a4P+Xu6t2O0Mg@mail.gmail.com>
Subject: Re: [PATCH kvmtool 0/4] Add support for running protected VMs on arm64
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Will,

On Fri, 19 Jun 2026 at 12:54, Will Deacon <will@kernel.org> wrote:
>
> Hi folks,
>
> With a v7.1 host kernel, it is now possible to run protected VMs on
> arm64 with pKVM enabled (kvm-arm.mode=protected). Although the pKVM
> support is not yet feature complete, having kvmtool support is handy
> for development and testing. So here it is.
>
> The patches are also available here if you want to pull them directly:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm
>

I tested this on qemu, using the Android 17 kernel
(ack/android17-6.18) and the upstream 7.1 to boot a protected (and
while I'm at it) non-protected guest.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> Cheers,
>
> Will
>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Marc Zyngier <maz@kernel.org>
>
> --->8
>
>  arm64/fdt.c                         | 37 ++++++++++++++++++--
>  arm64/include/asm/kvm.h             |  1 +
>  arm64/include/kvm/fdt-arch.h        | 10 +++++-
>  arm64/include/kvm/kvm-arch.h        |  2 ++
>  arm64/include/kvm/kvm-config-arch.h |  5 ++-
>  arm64/kvm.c                         | 20 ++++++++++-
>  arm64/pci.c                         |  2 ++
>  include/kvm/virtio.h                |  2 ++
>  include/linux/kvm.h                 | 53 +++++++++++++++++++++++++----
>  include/linux/virtio_ring.h         |  5 +--
>  riscv/include/asm/kvm.h             | 11 +++---
>  virtio/core.c                       | 12 +++++++
>  virtio/mmio-modern.c                |  2 +-
>  virtio/pci-modern.c                 |  2 +-
>  x86/include/asm/kvm.h               | 21 +++++++-----
>  15 files changed, 156 insertions(+), 29 deletions(-)
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>
