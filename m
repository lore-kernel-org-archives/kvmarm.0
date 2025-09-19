Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E3C30DD2E
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 13:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287711; cv=none; b=JQ7c3fMGlnDZoSBMQXHAAhTgLL+TmEHSNlO9p1yzUooo9VHF8Bpr3zSbb6S9H2LuZa+ADtwVEleoFmTyvldTK/ODAe5l4ZPHaZm9tVF7ZyjSrYKn1fjM4WfD04cWz1VJWs6HuYVsK3OjI5n1Wk7v1HO2rArywNe0nzcmKOeCWJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287711; c=relaxed/simple;
	bh=Cmxn3fZATVDtlwX0ps6wKhNYpLOvAlnoFm75vvlWuI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sagMN3+aR669JEtxt7Rs8vbG/yLUJ22bn0w1Sn3kYbDsuYPEoP1dsw5Rq8HzW72VaXvBHtZef/cEqPOUDP7tI2eNlL8L/Q3SGkOoBKqUMlNFZDNB1GwE3kYsYmAgUyQ5ZKIhn2L5y65MICaq09pLe2AioVq2PIik6ReYTrfC2TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQ9M/SjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQ9M/SjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9595AC4CEF5;
	Fri, 19 Sep 2025 13:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758287710;
	bh=Cmxn3fZATVDtlwX0ps6wKhNYpLOvAlnoFm75vvlWuI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ9M/SjTFizAJohHgPCjKHLfelcw3VeSF7tfXhYf90LTCSdR6/LunaP4aTyr7jnXD
	 16GJ+o3uJ9sYCdwz1df70kylmLwl247SJzcStBA2mX/jNwBIA1GK5cjhHO+MGcQ9ul
	 /0ULYfUvOxjgG8bWaACqeAc4ngfgCk/wsIpyYVzla7MhV6rPhjsWA4PaJcOd1zRev5
	 ezjnBdgpys8weFY6R/88R57029I9GRpan/f/lNlRpGdplRFDxhnACBYBxmeZJRhBeA
	 TXoV/C7M41g5eG+bmO7PkqHB55jzl1pSnND9by0yL0ruK4zInI+NeQGFX5XZxmbhL9
	 IasXQoAv0QyOg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzaxA-00000007mgb-1XEv;
	Fri, 19 Sep 2025 13:15:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: Re: [PATCH v2 00/10] KVM: arm64: Handle effective RES0 behaviour of undefined registers
Date: Fri, 19 Sep 2025 14:15:05 +0100
Message-ID: <175828769331.1762384.11349194735754864168.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250918151402.1665315-1-maz@kernel.org>
References: <20250918151402.1665315-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, yangjinqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 18 Sep 2025 16:13:52 +0100, Marc Zyngier wrote:
> [After yesterday's blunder, I'm reposting this, with proper commit
>  messages, and having taken Oliver's feedback into account.]
> 
> When a feature is removed from a guest, we ensure that the trap and
> control bits for that particular feature are made RES0.
> 
> For example, SCTLR2_EL2 contains a large number of bits. For any
> feature FEAT_FOO that is controlled by a bit FOO in SCTLR2_EL2, we
> make sure that SCTLR2_EL2.FOO is RES0 if FEAT_FOO is not visible to
> the guest.
> 
> [...]

Applied to next, thanks!

[01/10] KVM: arm64: Remove duplicate FEAT_{SYSREG128,MTE2} descriptions
        commit: c3b3bbd160d2014a638d40bda17909a0afd85d09
[02/10] KVM: arm64: Add reg_feat_map_desc to describe full register dependency
        commit: 559442afea8812814135ec6fa33bc62c9d09f5c4
[03/10] KVM: arm64: Enforce absence of FEAT_FGT on FGT registers
        commit: 7d3a4d048925d52e5511d82e479cbdcf7354aa7c
[04/10] KVM: arm64: Enforce absence of FEAT_FGT2 on FGT2 registers
        commit: 338a41e83c3dab81573ac33bc30f0f36bd29cd78
[05/10] KVM: arm64: Enforce absence of FEAT_HCX on HCRX_EL2
        commit: c99d62771f63116ffe54636980414fc74ab3471c
[06/10] KVM: arm64: Convert HCR_EL2 RES0 handling to compute_reg_res0_bits()
        commit: efe5406c55fb3203028507555c7da2bb417a397c
[07/10] KVM: arm64: Enforce absence of FEAT_SCTLR2 on SCTLR2_EL{1,2}
        commit: f89763efe86cc05f8465c7eea85a76183f218c56
[08/10] KVM: arm64: Enforce absence of FEAT_TCR2 on TCR2_EL2
        commit: 4870a8c1d18897681b6f6a50288d0b6dd5e21e24
[09/10] KVM: arm64: Convert SCTLR_EL1 RES0 handling to compute_reg_res0_bits()
        commit: d2a1d78ce5962b01500d09b15e2a854768552d44
[10/10] KVM: arm64: Convert MDCR_EL2 RES0 handling to compute_reg_res0_bits()
        commit: ac53365990a19e808fde2758074ee31be65d1015

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


