Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D5C51DAEA;
	Tue, 29 Sep 2026 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790679061; cv=none; b=EfSHtsXls9ErHUi5juOWDW/UMAMhYjyUTUgQZ3buw3I7Q6LB/v5KGUpePTA0W4V2+Qd5jK0GrUDlZSGdb7LGWvi2mOf19OeJk//D+BbyDka04OGCZiHEQQLNHjBY1THuD7tOv6WrlFHU3sid3eiGWQZYHQJmFmdgMiI7HEX+5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790679061; c=relaxed/simple;
	bh=USJ6sjNKDRu6tG4ZlA5fL23mzLtJ3UbJoLwk/ctppnk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tilHHUssgEGUI9rreGBV744LDRWbDVJ0pIegMX1JUdfl+ccKaj5TPUZeD+XKR+g9E63yoUU80Y51Fj6PnKMbCfGns9IS3U37cEN5X+9FcCuKE1ULaKy8zroGRHNsaqir8m4bqmHRRK/nzfmbXEWcXxSiOW8QypGBMFu1x3A50kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+ayOBlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+ayOBlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3781F000FF;
	Tue, 29 Sep 2026 10:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790679039;
	bh=ppQtqrkFicTanaRvuvwAvso1XMMqQRvA2bty9+a5yes=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a+ayOBlTnFys61HZg2TKPnlnnRhdAkQMrGZma6D40PHqkZfQlTcrVwXl++sXRzmO7
	 6ahDYzpC8mwdWgkTtk1UbrImf6GmbXlO+/bU4ejCDOuCKN6hnyk33kEUEyZ5bT2qyv
	 5n1o8AvO0c0vZ58GDYkbj1zJBHPmDCJMr3c8LKqtY2SyQlGPobP/Dz/U0+71xmnABO
	 4U5G1JogXTbB51J+lfzx6BsO7b/R8UE+S0eg3oLO1rb/npDWWOjeUhrymbCASYF8dU
	 SkS9qCw3woLa2dUtPpCQScpQ3Icr93AwegNpMy0YthPLdVNSzqINmVf3+/G2lZtoWQ
	 7g4lZCRHxQZuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/15] KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260929103655.85107-5-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-5-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 10:50:38 +0000
Message-Id: <20260929105038.ED3781F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] kvm: arm64: host panic on nVHE due to EL1 access of EL2 sysreg=
s in __load_stage2
--

commit 982e8feb07630370c5da59ed6e47706db5188e18
Author: Leonardo Bras <leo.bras@arm.com>
Subject: KVM: arm64: Add KVM_REQ_RELOAD_STAGE2

This commit adds a vcpu request to exit the guest, reload stage-2, and come
back to the guest, anticipating subsequent patches for S2 HAFDBS and HDBSS.

Link: https://lore.kernel.org/all/20260901171558.2674031-5-leo.bras@arm.com/

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 0576c2022ef57..d9ad765943d9e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

[ ... ]

> @@ -1175,6 +1175,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vc=
pu)
>  		if (kvm_dirty_ring_check_request(vcpu))
>  			return 0;
> =20
> +		if (kvm_check_request(KVM_REQ_RELOAD_STAGE2, vcpu)) {
> +			unsigned long flags;
> +
> +			local_irq_save(flags);
> +			__load_stage2(vcpu->arch.hw_mmu);

[Severity: Critical]
Could this trigger a host kernel panic on systems running in nVHE or
pKVM mode?

In nVHE or pKVM mode, the host kernel runs at EL1. The check_vcpu_requests()
function executes from the host context. If a KVM_REQ_RELOAD_STAGE2 request
is processed here, it calls __load_stage2(), which performs the following:

arch/arm64/include/asm/kvm_mmu.h:__load_stage2() {
    write_sysreg(mmu->vtcr, vtcr_el2);
    write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
    ...
}

Because vtcr_el2 and vttbr_el2 are EL2 system registers, writing to them
from EL1 will cause an UNDEFINED instruction exception. This causes the CPU
to trap to the hypervisor, which will intentionally panic upon receiving an
unexpected sysreg trap from the host, crashing the system.

Since any unprivileged user with access to /dev/kvm could potentially trigg=
er
a memory region update that sets KVM_REQ_RELOAD_STAGE2, it seems this might
provide a trivial path to trigger a host Denial of Service.

Would it be possible to add a has_vhe() guard here or handle the reload via
a hypercall for non-VHE systems?

> +			local_irq_restore(flags);
> +		}
> +
>  		check_nested_vcpu_requests(vcpu);
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929103655.8510=
7-1-zhengtian10@huawei.com?part=3D4
