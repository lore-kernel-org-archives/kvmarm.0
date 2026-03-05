Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAF5244667
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721927; cv=none; b=XGIFP1AlpJ2n62JjowMVsOeK2JXeREm1Ldt2rLzxvn3njbk97k/MGvM+kV9Q2gk82aW1jBqICcx1kHxCkpG+ZhMMy9HgacJBN5BM5/mBEYw/9NCNRuGj+NmHyNJz4h5yp8xINt7chQzzWd+3LxrXWwjr0thUBhlQwCjmkfMEO1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721927; c=relaxed/simple;
	bh=TXBLAESaWwmhTrLdTHIjZB5tcCyfd2YEw+VxiDwVIKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKL3xg82mn1WK9iJ4PeimtB8IbkEmHA6ulEC139cJ2v5SfUurf6nmqF8fffSP9c5XZw9kaigiuM+AfyhtHekrg+bnRk5HhiRkc9HShZNdbaPL9hSDKrztkown8tfKwyKSFZwbomO+j5E+J0eUJMN1jNXzDZ4QP21p+USyQjBbyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZths6EG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZths6EG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B68C2BC9E;
	Thu,  5 Mar 2026 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721927;
	bh=TXBLAESaWwmhTrLdTHIjZB5tcCyfd2YEw+VxiDwVIKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZths6EGU1LNdBGAuEdyAub1a1jES/+bU/DWBKUD7pt5ftLPDIOL9jGK/Mex5ZfpN
	 WP1CXZmhFNB3/2bzuX69M3NVOm7jf1CDQL/gRj8+CHQQvihZb+YzKVkr1PyTS5FJF4
	 4u141Szo5RncVjUWW95Bs0Q6EPbqNzAb0vcNpUcOKHB5P73eQLsovicMtGceF1nAmm
	 wmCtLKOhO/XzR7Ih7uS/0Pe6JIEZ4hkjEbQ6wmS33fpU+NcOJhe+V7zzLQJFQQa/Hx
	 KEusQI/DMQnW02JJHMHWfoia6gbkMLmcIuv7/huBk8tqvSNEwHLE0Ek6HLx52kR8Kv
	 rDLZZH+tRUAxQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 22/36] KVM: arm64: Change 'pkvm_handle_t' to u16
Date: Thu,  5 Mar 2026 14:43:35 +0000
Message-ID: <20260305144351.17071-23-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'pkvm_handle_t' doesn't need to be a 32-bit type and subsequent patches
will rely on it being no more than 16 bits so that it can be encoded
into a pte annotation.

Change 'pkvm_handle_t' to a u16 and add a compile-type check that the
maximum handle fits into the reduced type.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 911819e6e757..13fe4bd1fe0b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -247,7 +247,7 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap_2; /* Function numbers 64-127 */
 };
 
-typedef unsigned int pkvm_handle_t;
+typedef u16 pkvm_handle_t;
 
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a2d45f4b0cf6..a7253a884163 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -222,6 +222,7 @@ static struct pkvm_hyp_vm **vm_table;
 
 void pkvm_hyp_vm_table_init(void *tbl)
 {
+	BUILD_BUG_ON((u64)HANDLE_OFFSET + KVM_MAX_PVMS > (pkvm_handle_t)-1);
 	WARN_ON(vm_table);
 	vm_table = tbl;
 }
-- 
2.53.0.473.g4a7958ca14-goog

