Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32BEE43990D;
	Mon,  3 Aug 2026 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764828; cv=none; b=l2UruXuxwQMs1TkYBnTJDgZeSJ3HwMnBkLm+nurE3KjbO/ONg8clX9rI5CDVAZKWz5qpfptiojRP54q5un5Y2ivAcjAHfVM2RPdWkkB9bGewUiDw7K1EZ/p3Pz6psAhER+xVn7mKtBu74joA836AZm1R9ggYI5PjVJpk4baaT5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764828; c=relaxed/simple;
	bh=f5XF4TndoxoVxH50VEJOC2RYRGtrrvhd8+1pRFIhR/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMCIODAQu1/clUMS9WgQ5TqKCMVI9pJ+GOe1MZVy3hoWqlWp1hqesnchuiK1ew+/NEOAjWK4zfST0P4cZAMr4biMY3p0rC/4tn5snfvaLCUnS7ihlFQ3p9KJ7dj+x9Bkrd0zKmpyk0drFANLukkbyHYMRrG77d7cvF/nx21mmX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fJKmpKXh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fJKmpKXh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0C2F1476;
	Mon,  3 Aug 2026 06:47:02 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42F073F66F;
	Mon,  3 Aug 2026 06:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764826; bh=f5XF4TndoxoVxH50VEJOC2RYRGtrrvhd8+1pRFIhR/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJKmpKXhuohGrp+3530yeKrJT8csfLjS8y+WM81FheaAhbBObS+HTTmpyOPHsyN/Q
	 lxjnqi59afiuuWgqyqp8XMuWOTxf8nVkgBF7I31tYQNp5KgYNh1VqpduBnXt8VlHOu
	 OrhjHSsvfZbniqZnMDiulGx9pVTcoAk23iHUyph8=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v16 36/45] KVM: arm64: CCA: Allow checking SVE on VM instance
Date: Mon,  3 Aug 2026 14:43:52 +0100
Message-ID: <20260803134403.80630-37-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Given we have different types of VMs supported, check the
support for SVE for the given instance of the VM to accurately
report the status.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
Changes since v10:
 * RME->RMI renaming.
 * Adapt to move CAP check to kvm_realm_ext_allowed().
---
 arch/arm64/include/asm/kvm_rmi.h | 2 ++
 arch/arm64/kvm/arm.c             | 2 ++
 arch/arm64/kvm/rmi.c             | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 0fb685004d5c..13933f0e555d 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -98,6 +98,8 @@ struct realm_rec {
 void kvm_init_rmi(void);
 u32 kvm_rmm_ipa_limit(void);
 
+bool kvm_rmi_supports_sve(void);
+
 int kvm_init_realm(struct kvm *kvm);
 int kvm_activate_realm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 96e536d2dda8..3242108be7c5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -151,6 +151,8 @@ static bool kvm_realm_ext_allowed(long ext)
 	case KVM_CAP_ARM_RMI:
 	case KVM_CAP_SYNC_MMU:
 		return true;
+	case KVM_CAP_ARM_SVE:
+		return kvm_rmi_supports_sve();
 	}
 	return false;
 }
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 904df7c7245d..0d46768022df 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -26,6 +26,11 @@ static bool rmi_has_feature(int reg, unsigned long feature)
 	return !!u64_get_bits(rmi_feat_reg(reg), feature);
 }
 
+bool kvm_rmi_supports_sve(void)
+{
+	return rmi_has_feature(0, RMI_FEATURE_REGISTER_0_SVE);
+}
+
 u32 kvm_rmm_ipa_limit(void)
 {
 	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
-- 
2.43.0

