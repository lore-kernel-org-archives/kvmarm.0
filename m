Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0C043901B;
	Tue, 10 Mar 2026 08:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773132895; cv=none; b=ggR+niw12J5HLc0qJbmoXsClQDwQc/Xe3odXudbPlqjzM1iUZTN73IL9+JKpoNeHiObFX5tR6tS9PrElTdZZ2pOb26vszHn8BJ9LsylI1t6+i+DCBvnzCGmeHcp28LKNzS0cxztu7DDuIuclIWiKAW3fVapIVdZLmny64XT/ms0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773132895; c=relaxed/simple;
	bh=+IGCKgqPFHDe5JXoy8PHXf111KpMuolV8jtRpNeWfQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jNl0eM9qnLCHN0QA6AEzbS+g8ah2lf8gCpzqejybve3DQWGeF2oDazXwKqOjupsFeAUDQNcRY2kg6vPsJfcdpCCySVKoehSJ9xIQVcArhsiuJtfS4c3EDv7ecI0B/JXNw1YjYwry6THOLp6VQ3fGXpWd6+KyVVYhXxdChGerWvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mq5rd7+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mq5rd7+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F34AC19423;
	Tue, 10 Mar 2026 08:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773132895;
	bh=+IGCKgqPFHDe5JXoy8PHXf111KpMuolV8jtRpNeWfQc=;
	h=From:To:Cc:Subject:Date:From;
	b=mq5rd7+EfhMEwbrTHQdfWHOa2RLs8tXbtHUagjVTbtXoOgVpV3WjiGSW2n+lEcX4f
	 GwAvCwrN4vS9TZTb9kgPLKwa5b1LZLnWS2GjrOx8mB44opLBfGLEShHjKHKnvF6vCl
	 SjuI2+pDexe4RKaHNEYfOzmYb17/74RiK5GolGGK5OKZrpHzU6BhkC9QA3fl/1uXG2
	 NVHGHyPm7MqRLPuGE/UlXZb5W+D0PMpRWWgjx1luKpnaa2F+ganVR+DvuqSlOmgtEd
	 3CrVdtcsdo85M8IjOA+Pefx++wCMEvX+Tyu/TIuoj7yCbplA+gL3+QPOaV5RsH0I6s
	 aSCZWUa6qGFkg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vzsrd-00000000Lpv-0ITl;
	Tue, 10 Mar 2026 08:54:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug
Date: Tue, 10 Mar 2026 08:54:33 +0000
Message-ID: <20260310085433.3936742-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, qperret@google.com, tabba@google.com, vdonnefort@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hotplugging a CPU off and back on fails with pKVM, as we try to
probe for ICH_VTR_EL2.TDS. In a non-VHE setup, this is achieved
by using an EL2 stub helper. However, the stubs are out of reach
once pKVM has deprivileged the kernel. The CPU never boots.

Since pKVM doesn't allow late onlining of CPUs, we can detect
that protected mode is enforced early on, and return the current
state of the capability.

Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping")
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kernel/cpufeature.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c31f8e17732a3..947ff71b3b66b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2345,6 +2345,9 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
 	    !is_midr_in_range_list(has_vgic_v3))
 		return false;
 
+	if (system_capabilities_finalized() && is_protected_kvm_enabled())
+		return cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);
+
 	if (is_kernel_in_hyp_mode())
 		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
 	else
-- 
2.47.3

