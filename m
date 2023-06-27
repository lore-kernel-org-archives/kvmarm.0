Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A445182D5
	for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 14:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6ECC433C0;
	Tue, 27 Jun 2023 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687874772;
	bh=gdCzgZa5ZO1KjKZiWh8H9VlbmneP5crniKuqd9ftXpA=;
	h=From:To:Cc:Subject:Date:From;
	b=JqLTHeB9AMvnOWFw5aeGpHjDGpwjIdN0SoZoj1GjiIQt4WcSML2TQuki3WZ84FCuv
	 GoPtFRULJguonwIqOZ5TQL7kl8EvNrSAaqUouy64vBc/lYwBV2tZJv/JN3lpwe/71s
	 8azeJiy+YP0VG4ukxI4RcIS4/8aEWPxVu2UknWjEQ8GGzIafxMvFMPh5vgyJAOGkcs
	 PB6YakR+Nu+a8mTMKdGOL6APGVKbgMXtG6FGIewhGtoMQsj+PLoqQNDamTdreGlWNE
	 HPQiGtpWKFSp6G49Yz9LM9wcn5REaOF1LtQJtD2nj5q3YGCeG8dsD3fvygj5Iak4H0
	 mJ/b+/zCgBttA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qE9Kc-008oTQ-Ju;
	Tue, 27 Jun 2023 15:06:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
Date: Tue, 27 Jun 2023 15:05:57 +0100
Message-Id: <20230627140557.544885-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It recently appeared that, whien running VHE, there is a notable
difference between using CNTKCTL_EL1 and CNTHCTL_EL2, despite what
the architecture documents:

- When accessed from EL2, bits [19:18] and [16:10] same bits have
  the same assignment as CNTHCTL_EL2
- When accessed from EL1, bits [19:18] and [16:10] are RES0

It is all OK, until you factor in NV, where the EL2 guest runs at EL1.
In this configuration, CNTKCTL_EL11 doesn't trap, nor ends up in
the VNCR page. This means that any write from the guest affecting
CNTHCTL_EL2 using CNTKCTL_EL1 ends up losing some state. Not good.

The fix it obvious: don't use CNTKCTL_EL1 if you want to change bits
that are not part of the EL1 definition of CNTKCTL_EL1, and use
CNTHCTL_EL2 instead. This doesn't change anything for a bare-metal OS,
and fixes it when running under NV. The NV hypervisor will itself
have to work harder to merge the two accessors.

Note that there is a pending update to the architecture to address
this issue by making the affected bits UNKNOWN when CNTKCTL_EL1 is
user from EL2 with VHE enabled.

Fixes: c605ee245097 ("KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # v6.4
---
 arch/arm64/kvm/arch_timer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 0696732fa38c..6dcdae4d38cb 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -827,8 +827,8 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
 	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
 
-	/* This only happens on VHE, so use the CNTKCTL_EL1 accessor */
-	sysreg_clear_set(cntkctl_el1, clr, set);
+	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
+	sysreg_clear_set(cnthctl_el2, clr, set);
 }
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
@@ -1563,7 +1563,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 void kvm_timer_init_vhe(void)
 {
 	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
-		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
+		sysreg_clear_set(cnthctl_el2, 0, CNTHCTL_ECV);
 }
 
 int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-- 
2.34.1

