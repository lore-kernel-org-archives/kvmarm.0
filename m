Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0693F8476
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D166CC433F0;
	Thu, 12 Jan 2023 19:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673551383;
	bh=FY/CTl93oI7Y4b4CRPWO9gINsT9bDraMRZs64OpjRgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HN3IoHb0UzmBViwGCFYpoiFyUj1XJ9KJa2Lp4xNH2GDJ2ONBuDQZLbsXcqMzF5yIh
	 pNq1EQjnQCfKfX4ZpRbuTeNn2F2vzETUYF+nK9AhcgQqGWdf+NagcCH3JV3hWm8zvp
	 r2iuk3zkrvGrZ73BDRcFiNhn8e/m1rk633d1FrRUVg6Sk2XOLpVr78YPDlcxdcHEfU
	 pvT/3cpStjHHD4hCFrGBIewDUwIFhuB4vDdlZZT6ToU3kdVmmGx/AeD8TRIoPsV9jN
	 H9jbJ9wHYrjZkK/jYVehH9ffDOQQ7Mzk4Hyy0A1kc9hgUHDZmC6cKDIZewuPXlT5ts
	 bTD2TrxIOEL/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pG37Q-001IWu-VU;
	Thu, 12 Jan 2023 19:20:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 53/68] KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
Date: Thu, 12 Jan 2023 19:19:12 +0000
Message-Id: <20230112191927.1814989-54-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we're (almost) feature complete, let's allow userspace to
request KVM_ARM_VCPU_NESTED_VIRT by bumping the KVM_VCPU_MAX_FEATURES
up. We also now advertise the feature to userspace with a new capability.

It's going to be great...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/arm.c              | 3 +++
 include/uapi/linux/kvm.h          | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 619a9e98051a..4a71cb1442dd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -37,7 +37,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 8
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 23f783d654c5..7f143e69d893 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -279,6 +279,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_const_cap(ARM64_HAS_32BIT_EL1);
 		break;
+	case KVM_CAP_ARM_EL2:
+		r = cpus_have_const_cap(ARM64_HAS_NESTED_VIRT);
+		break;
 	case KVM_CAP_GUEST_DEBUG_HW_BPS:
 		r = get_num_brps();
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..573fa03bb002 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_ARM_EL2 226
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1

