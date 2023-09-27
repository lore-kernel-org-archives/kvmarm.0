Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639D1208C3
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D10C433C8;
	Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695805760;
	bh=v9+KEyVmL3Rbtezk0wEMGxYSOO0hSxuVwlPLKtF01uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiM/R4s+zfsdAtSNUPTVLifroK77J5ahCZ/K/BeQX0GtwbFapEFC5yu0NYQzV9Jd7
	 lP4jR1DCJVohzQEvV3ck8oRJq3QHLgCJDbyQXJ8nazFj3R9DpKhiJe+FaPrEsKbOZf
	 CbHTghi6WnGoB974I5qrO2ZQf4GHyT/zOn4Qr6SZkRTuQj8SE6QVSLTNeR/vLHK5s+
	 cMK6wME8WnxJ1wu6Eg2U9CC9TPZvgFF9n5QHbSaBair5nPrkXXc73Edpb+K4EYYR6z
	 uYusCYgFfpgybqxkfbbCb0RR+sxOSkUpFizlk8pLDlpGV4T4YFJIyQLqIHkM7yuZFF
	 XYZC1fhu9OBhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qlQXm-00GaLb-9d;
	Wed, 27 Sep 2023 10:09:18 +0100
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
Subject: [PATCH v3 09/11] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
Date: Wed, 27 Sep 2023 10:09:09 +0100
Message-Id: <20230927090911.3355209-10-maz@kernel.org>
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

If our fancy little table is present when calling kvm_mpidr_to_vcpu(),
use it to recover the corresponding vcpu.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b02e28f76083..e3d667feecaf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2388,6 +2388,18 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	unsigned long i;
 
 	mpidr &= MPIDR_HWID_BITMASK;
+
+	if (kvm->arch.mpidr_data) {
+		u16 idx = kvm_mpidr_index(kvm->arch.mpidr_data, mpidr);
+
+		vcpu = kvm_get_vcpu(kvm,
+				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
+		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
+			vcpu = NULL;
+
+		return vcpu;
+	}
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
 			return vcpu;
-- 
2.34.1

