Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214BA208AE
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD11C43391;
	Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695805760;
	bh=e79+/EAHtMsV+a8mcXU8ZVifInguWMi+6TWA76xpJlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHd/igxwSimZUGt4Xr4/oyS1TZkatemT9pp66wOV0Y5xSOAVT9hvU/vzdCJxkbxf9
	 n16Js+V42T37Cd/GFsM7gB1cq7cB0DuPZ69gXSpTM9DAKXRBNI3A0cbb/oUxRmmoJ6
	 rNd1Xy6mWWtBU5hUIZN42BtcR2e5MJrJif9RU3kExXVEsiPFhua8qaZdgEfP0aMkRU
	 OgISdcB98I5vuYCPiVxF/tTZX+IAcyNjLtBS2HDx/QlJi+0FKJRUKDOCQGnqqNJpIG
	 lr6XGoox+jVrKlvwH75UyApVOUh6Xiic8+JtGC3i/jYfDebpzXu8VT0dNxzhBH7yJm
	 QQNPM6oKfJEcA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qlQXl-00GaLb-SB;
	Wed, 27 Sep 2023 10:09:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 07/11] KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
Date: Wed, 27 Sep 2023 10:09:07 +0100
Message-Id: <20230927090911.3355209-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

By definition, MPIDR_EL1 cannot be modified by the guest. This
means it is pointless to check whether this is loaded on the CPU.

Simplify the kvm_vcpu_get_mpidr_aff() helper to directly access
the in-memory value.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3d6725ff0bf6..b66ef77cf49e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -465,7 +465,7 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
-	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
+	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
-- 
2.34.1

