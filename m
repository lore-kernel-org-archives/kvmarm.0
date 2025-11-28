Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E441F9F47
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764324620; cv=none; b=m0YYVUMeoqXIoKlp8z+A3H0GH6fu8AE9/0+9UvtdGGg2c4tvkT8Roj5NKUJl12Lf3g7rNVPpu1ZbUUjw2IGbvivbQBdM0nHCsYmGT9n626TgR5kUrmQYCck2jP7ff8Tu862RqookaSW0+UBInN1IZyhzwf+AyFzMHwGrn0KQoLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764324620; c=relaxed/simple;
	bh=+PKLjzdmS9KpNw71eDpujIITT14FvKsuhl+GuBnRLVQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKV5C8MlaonjiPc1P6rzZEPEDsk4cvlWdcyZWJkzYwP5IXXa5ZbuLtUEMK7Rn3tVCCzvb2dt+ArKAtKK5Q0YWPde98isCvTw+SkKfobqj3x7OnfRk20O8oEdfCDaNAw1BCPgktOOKXwIOG6P1RpxIAemflMVScWvPkO6u1OFF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26809176A;
	Fri, 28 Nov 2025 02:10:11 -0800 (PST)
Received: from e140010.arm.com (unknown [10.57.90.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1181A3F73B;
	Fri, 28 Nov 2025 02:10:10 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 1/4] KVM: arm64: Document KVM_PGTABLE_PROT_{UX,PX}
Date: Fri, 28 Nov 2025 10:09:43 +0000
Message-ID: <20251128100946.74210-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251128100946.74210-1-alexandru.elisei@arm.com>
References: <20251128100946.74210-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 2608563b466b ("KVM: arm64: Add support for FEAT_XNX stage-2
permissions") added the KVM_PGTABLE_PROX_{UX,PX} permissions to stage 2 and
to EL2 translation regimes, but left them undocumented. Let's fix that.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d57c12f074a4..fc02de43c68d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -240,7 +240,9 @@ enum kvm_pgtable_stage2_flags {
 
 /**
  * enum kvm_pgtable_prot - Page-table permissions and attributes.
- * @KVM_PGTABLE_PROT_X:		Execute permission.
+ * @KVM_PGTABLE_PROT_UX:	Unprivileged execute permission.
+ * @KVM_PGTABLE_PROT_PX:	Privileged execute permission.
+ * @KVM_PGTABLE_PROT_X:		Privileged and unprivileged execute permission.
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
-- 
2.43.0

