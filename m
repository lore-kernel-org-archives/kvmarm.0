Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DBB2FD681
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882207; cv=none; b=GA2uvbskckKQYWIgdbti21ykNxxGkdaBKRdY6Joh7FELMadLQcvOZjVvqPXlaZhsL4FA+aPZ0o/VrDgF8+yUbNvexGw5zJnzjDOleThpYBHmRjxwt3Aq6Rt3f1EaiMaofOdAu9+MSWmZOG7Rkd30dfQR/Fsdzb+ZK53OfOBEs7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882207; c=relaxed/simple;
	bh=tDDm+SzKUoz2fWZ2GjfXbiq4GHf2/6hOrZ04uxz3XhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUiwSk7Nr7NUD7K9tFKkshMFe5cJBeaewWAVOwk5GmYMi3MlOn+GBDzBXhKypjqyAzrDp3JOMRDVhkQwv3cSZ6BbK+eosowfb6DL23GGFlVte3+vpDQ69qR0eSUAivNP7mcQl2qVUK2G127fLjl+jrD71n1wcUyf3+UEGUCrZpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsvYUlqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsvYUlqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8031AC2BCB1;
	Mon, 30 Mar 2026 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882207;
	bh=tDDm+SzKUoz2fWZ2GjfXbiq4GHf2/6hOrZ04uxz3XhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsvYUlqAvj+AisWxnslnzQtbakQylr2jrh9m9Uu4pDiFlP/E40DpvEeAFJCWCN/Ys
	 ObKuSJvCoboGHby/Da/IGEryRrhyyW6fDnvieas6eScCWCitfEPPOQr4/LPD1m3waQ
	 QXMNFN8UJw4+p4LPJVfgHFx/hBL/vw1aQJ6mSq5+ep9G38gFh6GEVxgWVr7IBwsouw
	 RVstaJDkKP54Lb1aLqQRpZuf7GUeesvSECKWCZ/yanFU4A9PLGmPTHLFL4UV6O59d5
	 9y1q4k5CeyTxkks0QkHDxCqzyP9tpNPHOwiAnT9+YKyFC8PkrlrLcL+1B3C9ulx33n
	 7+aHtv0J/exDQ==
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
Subject: [PATCH v5 23/38] KVM: arm64: Change 'pkvm_handle_t' to u16
Date: Mon, 30 Mar 2026 15:48:24 +0100
Message-ID: <20260330144841.26181-24-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
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
index 092e9d0e55ac..0ba6423cd0d5 100644
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

