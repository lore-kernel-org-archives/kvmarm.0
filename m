Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4078036DA0C
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780419546; cv=none; b=ifqEsD9PS2sCf7v+sU0tuMN5IapC6mbF+QxSSKYhFOk+2cW5NZaoq0UbLDFd7h0iImxVLhsmlWfdNWmxDkUgjsugP3vdDOU7b9P0nJd7rC9rrMUX7u+89bAfkjXxauqqLfv/ohR3awp0YNoEQS7IKfxy3MJ10R+pkNGDaN+sRLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780419546; c=relaxed/simple;
	bh=JxgPyUqP22zW0yC9D7ObNUxHPlqdL6ppT/UF/khGIuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+iuGz5dWrq+WQPu0uoet6b4+VvUcUZW3Aw1WFaPZMsGfJ2BDPZ9WpF7odQsIsvKGx1ek1pdmaXSfsN7RG0cw0pjxr35kGv+uaBpiPKbsqQv41mraYdMg5Zzfk93YLkcAblvNwBkPmf/EG8F5cSH5K/tsumOj7LRy9EEt7IWSkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCZglWBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCZglWBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070331F0089A;
	Tue,  2 Jun 2026 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780419545;
	bh=w7b4Vk49+/WrCOzgWGLUwhqQNueS4QbkOGfpkwpx1Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCZglWBHe23jqS8vcKnRMuPtkV7l8QcdKWS2NsUA5YGTMON/KCoI/L1pJF5QSFi7y
	 +oa5geF52kMN0LCVF3knLtI35wyMKB8BH13tykdO9mBBJcuaHN6JbMDBfS86W5s8i3
	 4dtBQmUa7n0LSRFmY+s/QkyHLg+W3FlC7p8DmrJs7HTKXcCwo0amazmQ+ItUmsoZKx
	 3wk2iKBEwG1FGWI10HZgbKPZDgwToXu0lY3b9B2pzoqcQh/OJT8qB7YmO6kShtRVaN
	 HCDdtdtz0bWyiUEiyU3zscPENY6iImffeSYTFvmp85nLnUrylwm/F0nB7+iNcQe98m
	 XimlcpnJNOGvQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 2/2] KVM: arm64: Correctly identify executable PTEs at stage-2
Date: Tue,  2 Jun 2026 09:59:01 -0700
Message-ID: <20260602165901.52800-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602165901.52800-1-oupton@kernel.org>
References: <20260602165901.52800-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM invalidates the I-cache before installing an executable PTE on
implementations without DIC. Unfortunately, support for FEAT_XNX
broke this check as KVM_PTE_LEAF_ATTR_HI_S2_XN was expanded to a
bitfield.

Fix it by reusing kvm_pgtable_stage2_pte_prot() and testing the abstract
permission bits instead.

Fixes: 2608563b466b ("KVM: arm64: Add support for FEAT_XNX stage-2 permissions")
Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0c1defa5fb0f..91a7dfad6686 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -925,7 +925,9 @@ static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
 
 static bool stage2_pte_executable(kvm_pte_t pte)
 {
-	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
+	enum kvm_pgtable_prot prot = kvm_pgtable_stage2_pte_prot(pte);
+
+	return prot & (KVM_PGTABLE_PROT_UX | KVM_PGTABLE_PROT_PX);
 }
 
 static u64 stage2_map_walker_phys_addr(const struct kvm_pgtable_visit_ctx *ctx,
-- 
2.47.3

