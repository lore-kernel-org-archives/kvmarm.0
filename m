Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2C4328263
	for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 10:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765881087; cv=none; b=oOo8gHWOCrSLVAaD8Z16sKFiJpYKgpiTSjClUuAnRwKSphKQDBRIdeWQ02JmQsJubcsSv88p61QWNEqq4xIJN4sZxlxh2HNrSp83dAT2u9AaM/ydg2Ty2ldiQDEbfUEXjngbJv9oQuopW3Z7Kw2ZyEBk5FgbVuwREsMr1j5Ka20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765881087; c=relaxed/simple;
	bh=bADH7KIkeovYH01IIXp92f6g3OOihQqh71HTDRVVyhI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKGK6IB1wXhvUHPUXaV0O7emSIzflCsFnl7BZHfU6Q04ddUy8BAx8lJ7ALse3/ydF5OVBingL5/d+4BayYH+2aKZd4L0/4sza/ooIhOxY5d1ACr+c8CxRcOHCzrIqtD0ycOSMTL+3fpw02OwT/kxZBIE+P+wdEFnzdNdfywcjTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EF3B1655;
	Tue, 16 Dec 2025 02:31:18 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FEEC3F694;
	Tue, 16 Dec 2025 02:31:23 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v3 4/4] KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()
Date: Tue, 16 Dec 2025 10:30:53 +0000
Message-ID: <20251216103053.47224-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216103053.47224-1-alexandru.elisei@arm.com>
References: <20251216103053.47224-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

synchronize_vcpu_pstate() doesn't make use of the reference to exit_code,
remove the parameter.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c5d5e5b86eaf..afecbdd3c1e9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -854,7 +854,7 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code,
 	return false;
 }
 
-static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Check for the conditions of Cortex-A510's #2077057. When these occur
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d3b9ec8a7c28..779089e42681 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -211,7 +211,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	const exit_handler_fn *handlers = kvm_get_exit_handler_array(vcpu);
 
-	synchronize_vcpu_pstate(vcpu, exit_code);
+	synchronize_vcpu_pstate(vcpu);
 
 	/*
 	 * Some guests (e.g., protected VMs) are not be allowed to run in
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9984c492305a..9db3f11a4754 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -536,7 +536,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	synchronize_vcpu_pstate(vcpu, exit_code);
+	synchronize_vcpu_pstate(vcpu);
 
 	/*
 	 * If we were in HYP context on entry, adjust the PSTATE view
-- 
2.52.0

