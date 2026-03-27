Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5F221264
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620126; cv=none; b=cH7QltmwvmuT9sXwaHik5vs3MK24LEIK+eTBSwullRZIzfCCAWbhEHWD3AgelEjjJN6k7fpdMFAI+gPsawqyOTHRxjqNPGvL/E6tkYPbkVAJUlYJn1XDe4auu1rTawUotugKbaKRbB1Ely7vVS9g1KzaG+LD8QAxi/WQtBVizic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620126; c=relaxed/simple;
	bh=SDMGafRUVGGCgrJPxBIvZuvVZsCaeXEC2Q2rHPwapCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cmp3TU79m0CBMR7/pNGRM8fPi5b85OabjLfaSa7NxDKiLmdjjYAl4rkYX7Bm9HP54jJj/lEBsPFO+u/lnSctZmIVomF5ajG12uYTOkrWVp2O6bfHaXKcCLwLq1cK7Ao5bJDGkZi3XAJWMkHd/KMI2DB3Z0lSz01ssan74yxtpo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lb3b3cl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lb3b3cl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3704C19423;
	Fri, 27 Mar 2026 14:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620126;
	bh=SDMGafRUVGGCgrJPxBIvZuvVZsCaeXEC2Q2rHPwapCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lb3b3cl/R9xTQP4n1HtBB9/qX8rGUhsOZ38btyRqV+5HFIiLVgerrSp2LL2UsFguT
	 vvXeMx46dVt0gLj77sKK4V2hFvwG5HyTCKP2T5GL2Z5WeI9lWe6OsrVvVIL1c9ARlg
	 nBv3rOSqP6T09pV+RWZoHdZFS4FCp08Z18NIWZnvcejNwY5ZLjkDrFI16B7w89Dkgh
	 89A5419BA4zTZNORybyLZfNk8WqJVOnkAYWTn0CNL0NOdJGZfAhQFI/keIyxc7i3J8
	 KpzlPXNC/2PWhkcwkX+5n3AcPm3VkWX7r8qUcwVuZt8kQXO4QyfbMFJd/f6k7w9/uk
	 GJodAnjVd5dYg==
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
Subject: [PATCH v4 23/38] KVM: arm64: Change 'pkvm_handle_t' to u16
Date: Fri, 27 Mar 2026 14:00:22 +0000
Message-ID: <20260327140039.21228-24-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 31b9454bb74d..0c5e7ce5f187 100644
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
2.53.0.1018.g2bb0e51243-goog

