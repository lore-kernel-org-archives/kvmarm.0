Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8441F5675
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 10:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157C1C4166B;
	Thu,  7 Sep 2023 10:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694081396;
	bh=VnRY7EVjDxQnjy59aA3/M9OwNwE3hcD6p0d+NJE1MBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ja+wdiYX5Cm2NHtNJaFjsOTVDpel+AtB0+1I9yi7O7+X1oSO5eGH/Z63zGCev3q4x
	 lwZjgaUYabPnHiDbNViaTGaYvfaXrRY4/+1cWIxxocpMELrRlbDNoIO3NvcLnH/ywy
	 +GUTNU2oJ8FQym5JC7Qq8CH/+S/OGGkQJC8/kdq/TN27lU51siTZn0zF6Ifku3aqD1
	 HRkfyfKHrUKe1LauO7YC7ypGaYD1xFgSNv9EXHntfy8v7LNIi58ppreld26tTFsayo
	 JXUbuIIoRy43GykaPZaElrw/c9SxY1qj2dyB32NCVc3n9Z8qVFSIZe4U5bB5fUC24c
	 56MnEEyob/cbw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qeBxS-00B37Y-1w;
	Thu, 07 Sep 2023 11:09:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>
Subject: [PATCH 3/5] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
Date: Thu,  7 Sep 2023 11:09:29 +0100
Message-Id: <20230907100931.1186690-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230907100931.1186690-1-maz@kernel.org>
References: <20230907100931.1186690-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, zhaoxu.35@bytedance.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If our fancy little table is present when calling kvm_mpidr_to_vcpu(),
use it to recover the corresponding vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 30ce394c09d4..5b75b2db12be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2395,6 +2395,18 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
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

