Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D720642E41B;
	Mon,  5 Oct 2026 09:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191310; cv=none; b=Qed/vpf9Z1PbGcIp9WArAqXaBwp4Ff4pXbscTCbUEO3Pqju25AH9o4psg8uCBM9UG9vupk1D4vRM6VEfscWIcMjmImof1+4y8IrdlkBZeQ0tK5jzVZ41nbVMjb05oNtRjcRepo++eRkCSLZCYZAmxZt91I80bx21jrUR+p6+3sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191310; c=relaxed/simple;
	bh=z2LIrMIFE7EZF/TVEdQSDUxiMgdKOJBaWzN/bjwGxjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoFX/XQIOtrptNPGbFLn6fN5Dv+PWtoJCXDqQWm3KXkCHybkfsBYMV8/YYiUyEkIAXdSwLCY3DrEAOj2nT4DXMsnEBP6NYx+wirU4ns02892QIX6OulJ5nxVmXR6dxhKIIWQ8FXSixyO0094Qbmd4tUGO+hquD0dBzCSD+0hD3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SwvMORJZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SwvMORJZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 312581684;
	Mon,  5 Oct 2026 02:08:23 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 910723F66F;
	Mon,  5 Oct 2026 02:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191306; bh=z2LIrMIFE7EZF/TVEdQSDUxiMgdKOJBaWzN/bjwGxjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwvMORJZlIlOgBlqZh4x7TdaL3H8J1hDi1q1+aJtu9rqzeKo/rcNdeMIazfX5Ef1p
	 FdVprzlhucKg4BGW0SNTxJAyrdvea6bmwDvgmGCFhfC+vqKh7YhEdtHlALsy4ozVrf
	 zPNQ0HTqLmrYktBSX946vASixC312jIvMqzAS1Ig=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v22 06/23] KVM: arm64: Don't call vcpu_set_pauth_traps for pKVM host
Date: Mon,  5 Oct 2026 10:07:37 +0100
Message-ID: <20261005090754.2140522-7-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vcpu_set_pauth_traps() bails out and does nothing for pKVM hosts.
Clean this up by moving the is_protected_kvm_enabled() check to the
caller, in preparation for adding VM specific vcpu load/put callbacks.

While at it, do an early return if the vcpu doesn't have ptrauth.

No functional changes

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v19:
 - New patch, since addition of this to the Refactoring patch makes it a bit
   more bigger and harder to review
---
 arch/arm64/kvm/arm.c | 52 +++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bcec14c587119..50b84065ead1a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -631,33 +631,34 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_ptrauth(vcpu) && !is_protected_kvm_enabled()) {
-		/*
-		 * Either we're running an L2 guest, and the API/APK bits come
-		 * from L1's HCR_EL2, or API/APK are both set.
-		 */
-		if (unlikely(is_nested_ctxt(vcpu))) {
-			u64 val;
+	if (!vcpu_has_ptrauth(vcpu))
+		return;
 
-			val = __vcpu_sys_reg(vcpu, HCR_EL2);
-			val &= (HCR_API | HCR_APK);
-			vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
-			vcpu->arch.hcr_el2 |= val;
-		} else {
-			vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
-		}
+	/*
+	 * Either we're running an L2 guest, and the API/APK bits come
+	 * from L1's HCR_EL2, or API/APK are both set.
+	 */
+	if (unlikely(is_nested_ctxt(vcpu))) {
+		u64 val;
 
-		/*
-		 * Save the host keys if there is any chance for the guest
-		 * to use pauth, as the entry code will reload the guest
-		 * keys in that case.
-		 */
-		if (vcpu->arch.hcr_el2 & (HCR_API | HCR_APK)) {
-			struct kvm_cpu_context *ctxt;
+		val = __vcpu_sys_reg(vcpu, HCR_EL2);
+		val &= (HCR_API | HCR_APK);
+		vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
+		vcpu->arch.hcr_el2 |= val;
+	} else {
+		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+	}
 
-			ctxt = this_cpu_ptr_hyp_sym(kvm_hyp_ctxt);
-			ptrauth_save_keys(ctxt);
-		}
+	/*
+	 * Save the host keys if there is any chance for the guest
+	 * to use pauth, as the entry code will reload the guest
+	 * keys in that case.
+	 */
+	if (vcpu->arch.hcr_el2 & (HCR_API | HCR_APK)) {
+		struct kvm_cpu_context *ctxt;
+
+		ctxt = this_cpu_ptr_hyp_sym(kvm_hyp_ctxt);
+		ptrauth_save_keys(ctxt);
 	}
 }
 
@@ -749,7 +750,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu->arch.hcr_el2 |= HCR_TWI;
 
-	vcpu_set_pauth_traps(vcpu);
+	if (!is_protected_kvm_enabled())
+		vcpu_set_pauth_traps(vcpu);
 
 	if (is_protected_kvm_enabled()) {
 		kvm_call_hyp_nvhe(__pkvm_vcpu_load,
-- 
2.43.0

