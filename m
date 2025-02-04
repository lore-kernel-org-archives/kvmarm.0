Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD59D20AF8B
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 10:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738666212; cv=none; b=qAFuHOEvNNi/P4dlfX2qNnnDo52Mfq5AZEZUmQxvyLZIq/IkoIuv1XjmQ3GwLgkFN4J6w0JryDBDUUWN0J24x4MH26N7O7GgsuQncEp/nVDcjKrIT9xtEZViKnrwqF0L/JGhuxZuT1mqE8chnIfvF/mwJL2knpclOmGNvdcOYjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738666212; c=relaxed/simple;
	bh=sdNOn9c370t6t7WULQLWO/ig5ZWYbLZyvgIVcEGynrk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BWR2hfQluEVFeJHtXTossmAprHPuNZbRJsjl7/J4DFZCtivg0v9VFcltZRvORjrjaefPINczoj8001KYZoApEfVsHHqzGS3d40XY3VvovBSb9l0zhytdYozgr4xtt44SKFsDciyrDiIySA1GQygmVRBasEx8cy72doWxACP81jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qK610cwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qK610cwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5871BC4CEDF;
	Tue,  4 Feb 2025 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738666211;
	bh=sdNOn9c370t6t7WULQLWO/ig5ZWYbLZyvgIVcEGynrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qK610cwaAJw6W9OwjyRK4Q9H7vzrdmx3frGOBhDmoC4SI1rEkoiTFXOPIP+CgDYLb
	 QZPUV9yZvb+6pb5QFkVRct0tAGgv0SVb5PpjCz13BHInnOnUj27LMyakeF+NG49Zyj
	 xrj5i936FqtSgp6h7zamu3eIrg3a9SwU7JSwpitsAlvJASywrPCzu5yG2WrbN6sEPj
	 mFNJPFZdyoXAR6AjbbVD8V+FeqS600Rwkww2IMGCmpyzbJOvbG3RvSTioVhZAGHTj/
	 DC5OcjUafE+92jDQLoHkOgcdQnLhCyfFpIWHtpqQkHafRofiIjhCk2DWYYUpDodBW3
	 D6vb1y494L1Ug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfGVM-000ON3-T2;
	Tue, 04 Feb 2025 10:50:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fail protected mode init if no vgic hardware is present
Date: Tue,  4 Feb 2025 10:50:03 +0000
Message-Id: <173866618961.149894.15564173843761301653.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250203231543.233511-1-oliver.upton@linux.dev>
References: <20250203231543.233511-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 03 Feb 2025 15:15:43 -0800, Oliver Upton wrote:
> Protected mode assumes that at minimum vgic-v3 is present, however KVM
> fails to actually enforce this at the time of initialization. As such,
> when running protected mode in a half-baked state on GICv2 hardware we
> see the hyp go belly up at vcpu_load() when it tries to restore the
> vgic-v3 cpuif:
> 
>   $ ./arch_timer_edge_cases
>   [  130.599140] kvm [4518]: nVHE hyp panic at: [<ffff800081102b58>] __kvm_nvhe___vgic_v3_restore_vmcr_aprs+0x8/0x84!
>   [  130.603685] kvm [4518]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
>   [  130.611962] kvm [4518]: Hyp Offset: 0xfffeca95ed000000
>   [  130.617053] Kernel panic - not syncing: HYP panic:
>   [  130.617053] PS:800003c9 PC:0000b56a94102b58 ESR:0000000002000000
>   [  130.617053] FAR:ffff00007b98d4d0 HPFAR:00000000007b98d0 PAR:0000000000000000
>   [  130.617053] VCPU:0000000000000000
>   [  130.638013] CPU: 0 UID: 0 PID: 4518 Comm: arch_timer_edge Tainted: G         C         6.13.0-rc3-00009-gf7d03fcbf1f4 #1
>   [  130.648790] Tainted: [C]=CRAP
>   [  130.651721] Hardware name: Libre Computer AML-S905X-CC (DT)
>   [  130.657242] Call trace:
>   [  130.659656]  show_stack+0x18/0x24 (C)
>   [  130.663279]  dump_stack_lvl+0x38/0x90
>   [  130.666900]  dump_stack+0x18/0x24
>   [  130.670178]  panic+0x388/0x3e8
>   [  130.673196]  nvhe_hyp_panic_handler+0x104/0x208
>   [  130.677681]  kvm_arch_vcpu_load+0x290/0x548
>   [  130.681821]  vcpu_load+0x50/0x80
>   [  130.685013]  kvm_arch_vcpu_ioctl_run+0x30/0x868
>   [  130.689498]  kvm_vcpu_ioctl+0x2e0/0x974
>   [  130.693293]  __arm64_sys_ioctl+0xb4/0xec
>   [  130.697174]  invoke_syscall+0x48/0x110
>   [  130.700883]  el0_svc_common.constprop.0+0x40/0xe0
>   [  130.705540]  do_el0_svc+0x1c/0x28
>   [  130.708818]  el0_svc+0x30/0xd0
>   [  130.711837]  el0t_64_sync_handler+0x10c/0x138
>   [  130.716149]  el0t_64_sync+0x198/0x19c
>   [  130.719774] SMP: stopping secondary CPUs
>   [  130.723660] Kernel Offset: disabled
>   [  130.727103] CPU features: 0x000,00000800,02800000,0200421b
>   [  130.732537] Memory Limit: none
>   [  130.735561] ---[ end Kernel panic - not syncing: HYP panic:
>   [  130.735561] PS:800003c9 PC:0000b56a94102b58 ESR:0000000002000000
>   [  130.735561] FAR:ffff00007b98d4d0 HPFAR:00000000007b98d0 PAR:0000000000000000
>   [  130.735561] VCPU:0000000000000000 ]---
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fail protected mode init if no vgic hardware is present
      commit: 32392e04cb50d87bb7a6a7d9213f44a1a0961820

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


