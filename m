Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795116400;
	b=RFV1KzbtVsYKNPDTuxEnKFEQFZX1cHZVuMIcxIpZmYfAn2zuGTcrc1iQR6D1BWLkkh+F
	 G2IkVXHYuzBuILhNGv2ZVkqJN/vgJzfpNG2dUA9ekd5U8ceJuRKJ23dXM+NCtOM4kYCzp
	 ih6Yo8H0IXwOIYToxgULxOgfzutbhb6WZVg3Ia3/qDpu6neQikTvkcoDggnXCYDqnBUkN
	 ZL1gGEbvYADZHtrEW+6Cxr1AM4KjK4XdUOc77khBw6r5/YOlBAlhEp2YG+a/Kxs06o6Ut
	 Wn5KlwmwMnGnGmtr6BMS95JfolM2oCP3gF5ZH0oqgY97qse0JU7on2mIG7/Prq+Hs4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795116400;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bGM09ejDI5kGHlif/2JC4UNWlr5V6vigz3EsNtX81Lc=;
	b=dROKmyaCxwA4TwyepTPb+H229Zb6uRbky/N94jvzXoz+uoZL4CkxPMLR1nXncqWef2NC
	 iN8lk3yzN4x4zhCy12r5WFsTCZzYOo2bOvoCw+sZdsf9gGBkWwmZi7hVdsNLdb51062qg
	 XUovDXw0F5IqlxY36i/3vnfWrixibsJ56Cd0vgxbtDNtZhfXDk0pTncrrKZqeN1Loczv0
	 jTpiYk4D5KHczgiKraPykXWTC5yacKKKg3ygsN+wBofS67hM8+VmgJB+MdZLFW2SaFEeB
	 4pVkQ4WOg4KUe0SKPBVHMziggWiY7/3e/hHf1NibemXUguOfyRo6Kt6XlSwViDFxE5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHY4oZiz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C0A606A331;
	Thu, 19 Nov 2026 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHY4oZiz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6CB1F000C6;
	Thu, 19 Nov 2026 19:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795116400;
	bh=bGM09ejDI5kGHlif/2JC4UNWlr5V6vigz3EsNtX81Lc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LHY4oZiz2Qdqur9bcmXsQwZPWuhhGPQn7JBmPD2C+7yXjb+UYeUfveGn3O0K1zNnR
	 BvNTbPD9IfYeYtcjLz0MzBTUCXrGhiLa+2V6ohSpYsEBpHi8zaegFXRwsJgANF5UqA
	 3hA963mL4a3vObpG+dhJM6oY3tZgG2YkySubUXWJ3AMMLwY1E/c1wMEK5ZfgH2okl9
	 a6j9HmKIsEeiNPOM98SZ7K2E2U7vXUOcNGRyxoT4YU0mlNYzzSs7d+YOvx766pWYVz
	 1Hhjni+F3Om94zyjOfsNgfB9ejZnWQo7qA9C2a8Kw3LoINRqXM1DVP2D0vPZdCJVdP
	 knm61M6aPaz5Q==
Message-ID: <sashiko-outbox-223880@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 27/33] KVM: arm64: Emulate mismatched LP and HLP
 overflow widths for sub-partitioned L1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261119185215.632334-28-coltonlewis@google.com>
References: <20261119185215.632334-1-coltonlewis@google.com>
 <20261119185215.632334-28-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 19:26:39 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: broken PMU counter chaining for ovf32_mask
  counters
--

commit 210ea84a824c63596df96f6f9ef557724dabffcb
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Emulate mismatched LP and HLP overflow widths for sub-partition=
ed L1

This commit emulates mismatched 32-bit and 64-bit counter overflow widths
(vPMCR_EL0.LP !=3D vMDCR_EL2.HLP) when an L1 guest sub-partitions a
Partitioned PMU by forcing physical PMCR_EL0.LP to 1, biasing the 32-bit
counter sub-range by 2^32 events below 64-bit overflow, and trapping
PMEVCNTR<n>_EL0 accesses to translate counter values.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 725b5fc17533e..b7bec06b36b0a 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
[ ... ]
> @@ -123,12 +160,109 @@ static void kvm_pmu_part_sync_hw_enables(struct kv=
m_vcpu *vcpu)
>  	pmcr &=3D pmcr_mask;
>  	if (mdcr & MDCR_EL2_HPME)
>  		pmcr |=3D ARMV8_PMU_PMCR_E;
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5)) {
> +		if (ev_mask && !(ev_mask & ~hyp_mask)) {
> +			if (mdcr & MDCR_EL2_HLP)
> +				pmcr |=3D ARMV8_PMU_PMCR_LP;
> +			else
> +				pmcr &=3D ~ARMV8_PMU_PMCR_LP;
> +		} else if (vcpu->arch.pmu.ovf32_mask) {
> +			pmcr |=3D ARMV8_PMU_PMCR_LP;
> +		}
> +	}

[Severity: Medium]
Does forcing physical PMCR_EL0.LP to 1 break counter chaining for counters
in ovf32_mask?

Counters in ovf32_mask are architecturally configured for 32-bit overflow,
where an even counter overflowing at 32 bits increments an adjacent odd
counter programmed with ARMV8_PMUV3_PERFCTR_CHAIN (compare
kvm_pmu_counter_can_chain() in arch/arm64/kvm/pmu-emul.c).  Because all
guest counters sit below physical MDCR_EL2.HPMN, setting physical
PMCR_EL0.LP to 1 puts the 32-bit sub-range into 64-bit overflow mode in
hardware, which disables hardware chaining, and
kvm_pmu_part_rebias_single() does not propagate the 32-bit overflow to a
chained odd counter in software.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119185215.6323=
34-1-coltonlewis@google.com?part=3D27
