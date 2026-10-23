Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788978;
	b=HB+UCempYbXhmBSSCkZBq5LH5iE+RadJM5WvvxqpS66w8hgpVEXPIkyNbO6Vbcqlxt30
	 s6HrR0T+8PZ9NlMx/clMbJi8ixdg5mF/ehrindEgRUV1+3oaDKLHmyM3gybuhDxOnV+Pc
	 F+QhPM6mVvNLXnL7LVQyQMdxQzO6LfNPwAzHtB5xz+pyzyulgkTOztxU21wDd3gcZjGNW
	 DyQpZYk3iu+Rs06zvA/f3/nztW/TTZyqoygMBJ3/9XPmoq/HVId1NDi0ZaqgdZtIvSb+8
	 PP8QyvYFVG4IDBCNLTbatXTAC9e4Vt77hkITxvW3EE9yl2f4vYM+gtYAO/aLw2m1tXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TfFuk389oDa+4G1qiYQIxVpmB7GwWaHgVjbd0hnDq2c=;
	b=Op4jP3980DuLj4Sg+az770YBC92VZG+Dju/xZ+ZQIMjXft9X4nMl8NtElgW/6hhvFQbm
	 YcFm4qFs+m8r6r9EF4QZV24X7oo4KOygNhvnV86CJLaRJnlBMQAmTnJGBLamWWGS0t7o/
	 eaFWqB9qcdKnQOBjm5711u5RbUXHeeqR6dTuDbNdj9Z1PGzSouWqI0p+qOvjZA3n8Qhxe
	 7ZJkzz90bCx1e/hJ386Fd1SoBm6TylVrDZl6qB2Q1xyAzB/eXHboVr1nj3oEq5XSwutnj
	 0ZiuUz5sbasDilXdK9SV7wOd81wvF2EvDYcKwU75FQsm+/mAwfaTburyAGipv10X7Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dOZ6nXrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CE2606A325
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dOZ6nXrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E20A1F031E9;
	Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788977;
	bh=TfFuk389oDa+4G1qiYQIxVpmB7GwWaHgVjbd0hnDq2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOZ6nXrLEj37JuCFGVttwxugNGz2TxDTUaGOx+2Jo3FzrE1eNm+3LiYjDy8DR9aOA
	 oMG24suPyN6MAxFKmECxXYL6ecRzkNl4leLC5kkWASdTm6XPd61XM+rE7lX/oNbtqO
	 I/wC/Ucp1r5e15DjOmbTZeXpq7Iy/XiEq36f1X3mHS40UnCamMAi7eCAJqm+Hzv25+
	 U5LiwbKxt+rQs5UytNrYC8u+HoGPOrUyqeJdtOAH5PEkTSzK7yyi059AJPwWmMkIzQ
	 VqKaMp5VgGCPpHTqJtJrKvdPEIt/NkTHSpyto+ap2ejM/5OLXvT+zWif7tQ/g/7r+S
	 9nXxngR/ojNBg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 08/28] KVM: arm64: nv: Treat DBM as writable at stage-2
Date: Fri, 23 Oct 2026 13:55:50 -0700
Message-ID: <20261023205610.1044532-9-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using direct permissions, the DBM bit has the effect of granting
the write permission. And, depending on the access, it could grant write
permission without a dirty state update.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kvm/nested.c              | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index edfae3a6f362..23e93f14af7b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -102,6 +102,7 @@ typedef u64 kvm_pte_t;
 #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 1d581d3bd557..e388cefad9e5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -328,6 +328,17 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
 		break;
 	}
 
+	/*
+	 * Descriptors with the DBM bit set while hardware dirty state are
+	 * considered writable, even though certain accesses (like AT instructions)
+	 * don't actually update the dirty state.
+	 *
+	 * Assume that walk_nestd_s2_pgd() made the necessary descriptor updates
+	 * for the access and just treat DBM as writable here.
+	 */
+	if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
+		s2ap |= BIT(1);
+
 	trans->readable = s2ap & BIT(0);
 	trans->writable = s2ap & BIT(1);
 
-- 
2.47.3

