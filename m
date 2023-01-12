Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C679C9
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 15:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598CBC433D2;
	Thu, 12 Jan 2023 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673538525;
	bh=tT7XB6M2BGozhIHF+kdI15sy1eTDsUnElWCzbvSqSKw=;
	h=From:To:Cc:Subject:Date:From;
	b=lwOJfrDnjY+HLzvqKiM8JuOBTB0I4BYes+DnYBgGJY0KaBOONGlbqjT++jQKiz0AU
	 UPtz+18QPFwIhgvlYuBaFdz+QfsjUVSEAbXgzGryq5KvzRSKcSgvW60cnn2/VBKvpQ
	 FwZmPteauog/aaZ7llOK4YOGBxdj8HCfJddECeK/AfNdaJH2pqodQXn+ajtzHVR8Ny
	 gEVk7mSe+YLQzLkpAQjhMHGW44XCZG2FS+CdQWDr6+3cupzQbBbJLBbkA1g6tmW1b/
	 wolpgMx7QUp5RhQIgnOKs4LkHgDYfjHlz8BoFoOU+KdbKcgedNBOegQiBM66lGalWX
	 oIzRCvkNOnwrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pFzop-001Ecv-4p;
	Thu, 12 Jan 2023 15:48:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH] KVM: arm64: vgic-v3: Limit IPI-ing when accessing GICR_{C,S}ACTIVER0
Date: Thu, 12 Jan 2023 15:48:40 +0000
Message-Id: <20230112154840.1808595-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When a vcpu is accessing *its own* redistributor's SGIs/PPIs, there
is no point in doing a stop-the-world operation. Instead, we can
just let the access occur as we do with GICv2.

This is a very minor optimisation for a non-nesting guest, but
a potentially major one for a nesting L1 hypervisor which is
likely to access the emulated registers pretty often (on each
vcpu switch, at the very least).

Reported-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index b32d434c1d4a..e67b3b2c8044 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -473,9 +473,10 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
  * active state can be overwritten when the VCPU's state is synced coming back
  * from the guest.
  *
- * For shared interrupts as well as GICv3 private interrupts, we have to
- * stop all the VCPUs because interrupts can be migrated while we don't hold
- * the IRQ locks and we don't want to be chasing moving targets.
+ * For shared interrupts as well as GICv3 private interrupts accessed from the
+ * non-owning CPU, we have to stop all the VCPUs because interrupts can be
+ * migrated while we don't hold the IRQ locks and we don't want to be chasing
+ * moving targets.
  *
  * For GICv2 private interrupts we don't have to do anything because
  * userspace accesses to the VGIC state already require all VCPUs to be
@@ -484,7 +485,8 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
  */
 static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
+	     vcpu != kvm_get_running_vcpu()) ||
 	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_halt_guest(vcpu->kvm);
 }
@@ -492,7 +494,8 @@ static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 /* See vgic_access_active_prepare */
 static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 {
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
+	     vcpu != kvm_get_running_vcpu()) ||
 	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
-- 
2.34.1

