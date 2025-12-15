Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2C0332EB9
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 11:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765799074; cv=none; b=oWOOCQXscX3R7jsEHP1/DX4sABS4IzG30WPjTGIKAIuU2TDprs1znj5dbUmwrKc3nDTeJVJKkQjRNDco4qcgGyQl7bJKyhjkeSX/eCAtHLcCNjFuimvNMTay5ryv/Bf4IllhjCNr6Q8FsfLF/vdp4zxq3q/8tDALZrzFo+CK34g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765799074; c=relaxed/simple;
	bh=461ZYATZk4XQx+AvkRUBc5nL/FvwAMWMPAtuT14Ff9M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgM6u197qKQxnagIDMc+2rhQQ90Lnk4Lk9y7Umq/JPmPpOGa+tXx+AfoSl7qUMrwy5xdIlMR1KmXlLiEHAOKa4GCBYpIuKCI9Xd6azAAVHpBYr4MTUCe2WucFHS1kjU2ITQhhdwdyiOr8Ss4CrzNsjfnjMVhZfnyd4FEk+rO4co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBB621684;
	Mon, 15 Dec 2025 03:44:25 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46D2F3F73B;
	Mon, 15 Dec 2025 03:44:31 -0800 (PST)
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
Subject: [PATCH v2 4/4] KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()
Date: Mon, 15 Dec 2025 11:44:09 +0000
Message-ID: <20251215114409.212512-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215114409.212512-1-alexandru.elisei@arm.com>
References: <20251215114409.212512-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

synchronize_vcpu_pstate() doesn't make use of the reference to exit_code,
remove the parameter.

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

