Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D7239281F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240130; cv=none; b=nMPbse+a/Y/nERpQTcyvpdiHXAeN4bkJGfWbT6kbEsDZfeIMkp45aadOb29/Y5OQQZdsrSUmL15HQP9PsUEcrbBVo6hISslIu+Dr3RFTJmbvEQWEgmZcU6R+9z0CzbIcANAsCth/5g+1gv7GWQrijrT+TIyfwRAOZOe7C9dK72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240130; c=relaxed/simple;
	bh=e2L+LG5bVm5BMhgBEo9+ZR2hnjDDMTB8Xs9RrB6HaYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAfhDdRJnzAN8Ju5XS7QuYWq1Sk9ymJPhd/BxmgTvzgUcvjkGuy5x2aPTGWVx/1nPPKtHLnDVQjzik6v8LxA0dvAGFBxqxKq3UDO9S3mZJzVTp2TtMWwkh0AHQFE8rr4zeW9ywmBT9TW2wUHhdQP9LXyEVLD0zNShFeldEDjz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbKEL/Rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbKEL/Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403DF1F00ACA;
	Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240129;
	bh=RU+U+c/xAjoXTSSG4HxM6LGU6HM7xwVw9oXQ4PSem3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbKEL/Rhmiqm7xMR4Eh9HeId6FJW71JZrXQxWz5unqZJwJvno4yaezThsYpsH9EN0
	 r8PEMzYZ7NWjdQFvzJ4CCHsTDqrNfvxHmYuF0CCyhk+fLKjw/bvfnRMPreiPzF2eRr
	 31j8RBTh6wnOGiB+Fs0+klT2kQhGeL/aMNK1PTPy5gtqWKrF0+kZQ+p8z2/9vwN6na
	 qJhBKIYcgxqYKHua741dgI7DHFgnk2B6rGXJBphe5pw1v3xJ6d+NrTyGOztrBSUJp7
	 G0+xWyCY+4Rj8fSjd7y4mAwkoiajF7DFUYwhdo20WxU43vIBgv9XFGOaWBrQF/82Gi
	 iXNBy+4PEHhdw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 19/22] KVM: arm64: nv: Expose FEAT_HAFT
Date: Tue, 23 Jun 2026 11:41:58 -0700
Message-ID: <20260623184201.1518871-20-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both stages of translation now support the access flag on table
descriptors, advertise the feature.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6f540d3481d5..dc2a8b6483c2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1799,7 +1799,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
 			val &= ~ID_AA64MMFR1_EL1_VH;
 
-		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, HAFT);
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
-- 
2.47.3

