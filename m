Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960504D9575
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 13:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774803; cv=none; b=JRSZ5wBXlyZ/4CE9QYCqGuctF38fo1e7Foj0Yz2CSMzjbKbt0v4HHGAw0Ze+tQmvLKp8eFEpQ6oqnJ60fe0XuPJ7T0qSzyDWhtg0S6ORPxn6xRmG29DEk81ePJzp5VcthaCULmo0U8uPkieW1ZiWzDOqD7Vxr+zFdevs2n6GTUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774803; c=relaxed/simple;
	bh=lxx1cBwC6h3Ltn5Ta3Dy4dQZzezMDhmC3HIMM3DY5eA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dckXU4ahgYVEHHH4IFDxUuPqZ78/BrtdPSnoS5iGdZz/ZmWQeo9ohRAEM8Fm7oYNa8/zzdFEizhcAf3ZaYU/SU0UfpANVAPM0ABc4pkqwxrzqmWEs6RNWRIcZO6J088tDhjDqpRPQx5Qy3BiITAUTL8+iZP0DmsMoz42igI26rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eNhRDTHv; arc=none smtp.client-ip=91.218.175.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eNhRDTHv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=lxx1cBwC6h3Ltn5Ta3Dy4dQZzezMDhmC3HIMM3DY5eA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790774786; v=1; x=1791379586;
 b=eNhRDTHv+FJ4ECTeEXiv0zavlKvsP2ZQ11JCqLVvMW3ULImJPnvU0mvQ20q4mujnykeTzpZ7
 Pnp79qvFlallyyEJwi0u4dyUOV4YlT3BlUuT7wOdcd/WbPgU6srumyDsBl6+eF+o2fULqHZ4EiG
 EDiWSn6S0/VBT/zTyFOrrmqA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 202c3d1405de6b66;
	Wed, 30 Sep 2026 13:26:26 +0000
X-Mizu-Trace-ID: 202c3d1405de6b66
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5ba4065fa07so973e87.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 06:26:26 -0700 (PDT)
X-Gm-Message-State: AFq9FYKhPH7UG/cTwCi+fQD529tsPXr0nIwjV11f9Snm+uRp25DWYs3m
	hFEkwoQwfwR1hUmHkWSJAxT/wEVF/39mRy5L9VCvLvxdoNYAqkMTz9vqlgUOpq6EpXuQ7N+q7ML
	i8ujtKy66eI96ZmUZ7Me6tbMV5mZ3I7DV4z1Gg8qc
X-Received: by 2002:a05:6512:1195:b0:5b8:b502:9a76 with SMTP id
 2adb3069b0e04-5ba3f6f3408mr83956e87.13.1790774785500; Wed, 30 Sep 2026
 06:26:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929212925.31775-1-oupton@kernel.org>
In-Reply-To: <20260929212925.31775-1-oupton@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 30 Sep 2026 14:25:48 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxzhjEhOWGG6MgaOLE=SnUf3ehs+0H6x9ivX8DOWWNYWQ@mail.gmail.com>
X-Gm-Features: AclHuK_ZEx3tjeWUeBLg9d5fuRBugRA_iNCzZwXyqsEympPqUw62klsbc4nEo7w
Message-ID: <CA+EHjTxzhjEhOWGG6MgaOLE=SnUf3ehs+0H6x9ivX8DOWWNYWQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: arm64: vgic: Stop migrating IRQ from vgic_prune_ap_list()
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Steffen Eiden <seiden@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 29 Sept 2026 at 22:29, Oliver Upton <oupton@kernel.org> wrote:
[...]
> Marc, this series applies on top of your own for LPI malice [1]. You'll
> note that I've taken some of it for 7.3 while leaving the rest for you
> to take in 7.4, I'm perfectly happy with Patch 3 and 4 getting squashed
> into the corresponding bits of your own series if you prefer.

My Tested-by on the applied patches went out with a stray space in the
address, so they didn't get applied.

Sorry about that.

Cheers,
/fuad



> Tested semi-rigorously on an Altra machine and the Orion board, using
> both real guests and an LLM-generated selftest specific for migrating
> pending LPIs. The latter was way too big to make sense of, I'll try and
> post a test if I can it into something tidy.
>
> [1]: https://lore.kernel.org/kvmarm/20260929093548.3598547-1-maz@kernel.org/
>
> Oliver Upton (4):
>   KVM: arm64: Add helpers to halt a vCPU
>   KVM: arm64: vgic: Move IRQ migrations out of vgic_prune_ap_list()
>   KVM: arm64: vgic-v3: Only pause the targeted vCPU when disabling LPIs
>   KVM: arm64: vgic-v3: Pause the source vCPU when processing MOVALL cmd
>
>  arch/arm64/include/asm/kvm_host.h  |   2 +
>  arch/arm64/kvm/arm.c               |  18 ++-
>  arch/arm64/kvm/vgic/vgic-its.c     |  19 ++-
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c |  11 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  18 ++-
>  arch/arm64/kvm/vgic/vgic.c         | 184 +++++++++++++++++------------
>  arch/arm64/kvm/vgic/vgic.h         |  24 ++++
>  include/kvm/arm_vgic.h             |   1 +
>  8 files changed, 164 insertions(+), 113 deletions(-)
>
>
> base-commit: cfaf3b76669d386912a91103671691692f81c316
> --
> 2.47.3
>
