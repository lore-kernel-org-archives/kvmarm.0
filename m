Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B438148B368
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282975; cv=none; b=Tdvnp1mbq7AcMj3WuQ7sIk4Wee879iOeAUsqV6h1clo/ccAXlr8/GfriASws2DYAlz610nKL9g3J4wzVFkBX+zBKKMoSUrxUyhtPe3lvd9ph0CouECnzqqYSg7CPJFQdpu3ngHM6EthNChSXdzIV+WdCKefj4aibiXgi7G3w+8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282975; c=relaxed/simple;
	bh=xHPxvRUZ+WgjAT7cIxsez9QFHBw7/cnqGtqr1gFdEFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2BeRkWrlk+RvSj/jwR1IYqsPGCONBrRWfx9k3/3N6HuAtL2PhXgNY1MOZTT2x7XMTi9jKezwvGGCqlZ65huC23VR3KOC/geH2UFyhRn3qXK7n3L28U1SMpTIgGeL+WTCTsnDz3L4Q4X6biyN2euS8haYfSxr9Bsh/nYWCT0tIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=avpHPUaw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="avpHPUaw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6893F1756;
	Tue,  1 Sep 2026 10:16:09 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CA563F7D8;
	Tue,  1 Sep 2026 10:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788282973; bh=xHPxvRUZ+WgjAT7cIxsez9QFHBw7/cnqGtqr1gFdEFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avpHPUawEvIy+sjjbEKnOY/hZjj8JDCtZFbHdPe0LrsVzAxThZRqt9TwPpoocuO7B
	 ce/wL7F/mIQIfaQIbqYOoesaX03FGn2TTY9i90TeC1Lwsp/0/m1ZqzY5rqdPXOrqAa
	 GeD6emuHuERG7trk/+9ySHWUi+Kto67cqMGylIiY=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
Date: Tue,  1 Sep 2026 18:15:55 +0100
Message-ID: <20260901171558.2674031-5-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901171558.2674031-1-leo.bras@arm.com>
References: <20260901171558.2674031-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2471; i=leo.bras@arm.com; h=from:subject; bh=xHPxvRUZ+WgjAT7cIxsez9QFHBw7/cnqGtqr1gFdEFs=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKms81rLTxzPFn9uwlPFJfEYf1pFw7Zip9VPPj7mbHxr Ck/DhRt6yhlYRDjYpAVU2SRfTR/Fc/3KRlHrvxYADOHlQlkCAMXpwBM5G4qw//Mw89LmMwSwl+8 cix5IPL2uHOF6+LtRlsc+c3mTD205gc7wz+zqTk8ftFcZ4LqisRjjE4uPl5+ge+qWvzJXZmHgi9 8UOcEAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Add a vcpu request to exit guest, reload Stage2, and then come back to
guest.

This will be used on future patches that enable S2 HAFDBS and HDBSS, as
they may need to change VTCR bits for enabling/disabling the feature when
the vcpus are still running.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/arm.c              | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7..00fe169f239f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -48,20 +48,22 @@
 #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4		KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU		KVM_ARCH_REQ(5)
 #define KVM_REQ_SUSPEND			KVM_ARCH_REQ(6)
 #define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
 #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
+#define KVM_REQ_RELOAD_STAGE2 \
+	KVM_ARCH_REQ_FLAGS(12, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
 
 #define KVM_HAVE_MMU_RWLOCK
 
 /*
  * Mode of operation configurable with kvm-arm.mode early param.
  * See Documentation/admin-guide/kernel-parameters.txt for more information.
  */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..1e528d53d093 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1164,20 +1164,28 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
 			kvm_vcpu_pmu_restore_guest(vcpu);
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
 
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
 
+		if (kvm_check_request(KVM_REQ_RELOAD_STAGE2, vcpu)) {
+			unsigned long flags;
+
+			local_irq_save(flags);
+			__load_stage2(vcpu->arch.hw_mmu);
+			local_irq_restore(flags);
+		}
+
 		check_nested_vcpu_requests(vcpu);
 	}
 
 	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 {
 	if (likely(!vcpu_mode_is_32bit(vcpu)))
 		return false;
-- 
2.55.0

