Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4293A3AB298
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525952; cv=none; b=KLVvdiGkJp52ROfvb5euoPszyWoWGpI29KtO43xkWNExvqFeGanBylLGbG/zw8DjWhER54SdGHZnZ49R52LLYe6Ig9SYtYXTvYTLco2meKx41EwQLfoTgb+tEiBfnHkfgCn0H9QowDawAsLjF7e9tsi3gbJeriChKEejLDxmD4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525952; c=relaxed/simple;
	bh=nVWYQRDoBQAI06C2RUbthgzk2Kfs5Hf1NWsam/Gw8DY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=APfpEqCWpVRKdebibpYcLRsEJuebB21mpn2HhB2PC1LosJCbDmn10IiTsLfMhGMu4BFyu2uiVXGIfqtfP1B4dmV0qEx9xBx5qlIevOFgViFF2zzenyHOuGLb0uFJwkq8pXxHSvxtmjSms0s8nqsLuJUHsVzLSxH6iKD9R5RhGlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=lqHHtZvp reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="lqHHtZvp"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7ok075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:25 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=A8hJg+9Z0Ujtup1LyIFYnUgGhYCp0lA0bXWDMbXVkPA=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525905; v=1;
        b=lqHHtZvpwpzjGPVXsETS1NfB8Yz6VbPoC9T+/FFTIlYdISuJZkd86DqgilI8qaUa
         98hprXWolDHkj3Yet5sa5QJpiINnObNtrm1XYYRxkLsgnEIfl7c5tDR/vIBc290U
         e5Wbnz1606G64rgqyTzhWkB7oS9iHNWxojRvGMrhSOWpAUaWuVZZhb6C0dY9RadY
         mxOLS3ZyyfQGrzv7kErs3pCJ5IK7W02X00Xa6iHyVwUa4zBz8R7eTwA30ok3vhqa
         /PUbC20EXZn7VCm7eY+mBydK2GHh2FJ0uRxubLeuexdWWdcGmCWGIQ7SXkD11IbU
         DWIAOm9FQSv2lhPvMdxtpg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:37:56 +0900
Subject: [PATCH v9 02/16] KVM: arm64: PMU: Stop updating MDCR_EL2.HPMN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-2-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=2325;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=nVWYQRDoBQAI06C2RUbthgzk2Kfs5Hf1NWsam/Gw8DY=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFudQpsA3e2S5L8fGzL82y/BM2/I5P7azdp4qm2u2Y
 o5P9NmbHaUsDGJcDLJiiiwpRbu5NaJrPxUmxLfAzGFlAhnCwMUpABNhPsHIsPJaxOwbkW94q7Ob
 jMSD7b9z9ZT/YVQ9+F+kwrWf5Ux2OcMfPl0/E4ZFrXV80SYTxXN+blskU3TzY8rtphWHPRtOr+3
 jAwA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

KVM allows userspace to write any value to MDCR_EL2.HPMN. However,
kvm_arm_set_nr_counters() rewrites HPMN for every vCPU whenever
userspace changes the PMU or its counter count. This can discard a
value previously restored with KVM_SET_ONE_REG.

The architecture only defines HPMN's value on warm reset. Stop
rewriting it after vCPU initialization and update nr_pmu_counters
directly instead. reset_mdcr() continues to initialize HPMN from the
counter count current at KVM_ARM_VCPU_INIT.

Fixes: c8823e51b534 ("KVM: arm64: Fix MDCR_EL2.HPMN reset value")
Closes: https://sashiko.dev/#/patchset/20260706-hybrid-v8-0-de459617b59d%40rsg.ci.i.u-tokyo.ac.jp?part=6
Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 98305bbfc095..b5df6843dbcd 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1022,30 +1022,12 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
 }
 
-static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
-{
-	kvm->arch.nr_pmu_counters = nr;
-
-	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
-	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
-		struct kvm_vcpu *vcpu;
-		unsigned long i;
-
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
-			val &= ~MDCR_EL2_HPMN;
-			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
-			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
-		}
-	}
-}
-
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	kvm->arch.arm_pmu = arm_pmu;
-	kvm_arm_set_nr_counters(kvm, kvm_arm_pmu_get_max_counters(kvm));
+	kvm->arch.nr_pmu_counters = kvm_arm_pmu_get_max_counters(kvm);
 }
 
 /**
@@ -1111,7 +1093,7 @@ static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 	if (n > kvm_arm_pmu_get_max_counters(kvm))
 		return -EINVAL;
 
-	kvm_arm_set_nr_counters(kvm, n);
+	kvm->arch.nr_pmu_counters = n;
 	return 0;
 }
 

-- 
2.55.0

