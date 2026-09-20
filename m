Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04210400995
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 11:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789903047; cv=none; b=hN/A7Q+SZYPGpw0xQ7TRe66o/O5tWF14JIBKzaH4CVrJbV9665CgHVK7b27k7Py/wj09ZHRDpofjMCj5aa0lh8M1A+bcsQQdSs6p3iIZ6EAEA4fi8Daeul57ClUn9q/QOrVDDo4pztEmCkWfMY/D/s1S2I1Sx0tMzx1ItL4kT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789903047; c=relaxed/simple;
	bh=ZwHCND4TvpKjwaPcx6aqpVFdzyPHWHl27WcGIFnygC4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FreBRjLdeeSpmF4pOuf4FdSWdVNRwqirXo1fRin2oGttTP/Bs2PdDzCiTYVTADEi76NlRmo7jXrnkZDG7odomrnnnBae9dLKcXJ5RgfSfHa1LZnbPVXn9dse4fa3DtXw8Y++8NNVEDxHQH2KzsuOt0KrLtfgzUcQxgQrYPQNW+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=v+YAKWhf; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="v+YAKWhf"
Received: from [192.168.10.153] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68KBG36P088236
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 20 Sep 2026 20:16:08 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=iyM9QAloEsP9dHXX9S9zolMEUPTEvUttQXAYPXDanF8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789902969; v=1;
        b=v+YAKWhfBB78+5AU9ZHlXoG3gxkYyh6DL1SgC6gfBMXlZNow03UMiA/sNIwqc7Oc
         Sfcd2egNf1+9fSzZBu681vnt97fEd2XLEAWU72bi50UkAHQCDuEbSP046N8EuV1p
         FYhZAj2b5xjBxNs3uPLl05FdzwbH9z7r1zaIwSaaOYhY90jC94id9ExOQF0yrdoT
         6pCsCuJSiX3r2PB1c7P11UHB2OMsLBmYxGLZOINOD8zvqcM8MeNQ8t0h79XR3ohp
         f2JQYTYiDlQcb9u5g4cR9d65hVwWN1AnhQ0FeRbXVU2e4Dqvz+zc7EEZRpz+q1EV
         mFwfm1fvkjTHZ9OIDqFl6g==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sun, 20 Sep 2026 20:15:43 +0900
Subject: [PATCH v11 02/21] KVM: arm64: PMU: Stop updating MDCR_EL2.HPMN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-hybrid-v11-2-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>,
        Andrew Jones <andrew.jones@oss.qualcomm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2373;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=ZwHCND4TvpKjwaPcx6aqpVFdzyPHWHl27WcGIFnygC4=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9b6Aym2Riq1U5xdzYqWRnS9laxp2HBDj//Fqd8dFy5Pu
 5U180VbRykLgxgXg6yYIktK0W5ujejaT4UJ8S0wc1iZQIYwcHEKwETaNRn+SufGvOjd3+tY9Ffz
 57ooEYFNNU829QTzdK99XHJbLdf/HCPDs1trD/1VVCp6dvBf/GpXbfb2BiHfl4ZTzpZobbgS9eo
 nDwA=
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5b1af7e2176f..832dd145af2a 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1035,30 +1035,12 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
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
@@ -1136,7 +1118,7 @@ static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 	if (n > kvm_arm_pmu_get_max_counters(kvm))
 		return -EINVAL;
 
-	kvm_arm_set_nr_counters(kvm, n);
+	kvm->arch.nr_pmu_counters = n;
 	return 0;
 }
 

-- 
2.55.0

