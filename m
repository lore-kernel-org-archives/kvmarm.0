Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBBF155CAC;
	Mon, 10 Jun 2024 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718027037; cv=none; b=UYcYOd7GOqoZljHQPlHJ8gew18sU1bK2VSwx7EXZiSvkrjxXRityPmKN3kH920fcvuXRUAfGSEqpQkLs5LllbUYA9jHBrl19wEWWKhwRNXruwY20t5NDDkefFeuqrqSZJ51468MS/G9ZvxaL09UD0JcJWf4xBQo//9NsnuU00+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718027037; c=relaxed/simple;
	bh=JakuwZyfWuRj+LSBmL8JujU2hcmbalbe1ijSmNNhEVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mqa4waJMujhMS/Zyz8KZZ9LNI/GHCbTGZkDKgpwnJQTkJ9vV2raQuYrIdpVDmlcsjuQc0tXfWU/Emu0Zv9jsS3U+sk01hk/ZqwDVUJ7QBmflucdQJmEgGxuHnT0pzycmBfBY+JrEYCBJvQM2EmHWlqb8hfoU865VzbpJ8nLLhQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19E5F169C;
	Mon, 10 Jun 2024 06:44:20 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0BCE3F58B;
	Mon, 10 Jun 2024 06:43:52 -0700 (PDT)
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
	Steven Price <steven.price@arm.com>
Subject: [PATCH v3 29/43] arm64: rme: Allow checking SVE on VM instance
Date: Mon, 10 Jun 2024 14:41:48 +0100
Message-Id: <20240610134202.54893-30-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
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
---
 arch/arm64/include/asm/kvm_rme.h | 2 ++
 arch/arm64/kvm/arm.c             | 5 ++++-
 arch/arm64/kvm/rme.c             | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 5492e60aa8de..80c7db964079 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -89,6 +89,8 @@ struct realm_rec {
 void kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
 
+bool kvm_rme_supports_sve(void);
+
 int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int kvm_init_realm_vm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f78e92dfaa72..f3743ba8b006 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -442,7 +442,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = get_kvm_ipa_limit();
 		break;
 	case KVM_CAP_ARM_SVE:
-		r = system_supports_sve();
+		if (kvm && kvm_is_realm(kvm))
+			r = kvm_rme_supports_sve();
+		else
+			r = system_supports_sve();
 		break;
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 45d49d12a34c..999bd4bf2d73 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -20,6 +20,11 @@ static bool rme_supports(unsigned long feature)
 	return !!u64_get_bits(rmm_feat_reg0, feature);
 }
 
+bool kvm_rme_supports_sve(void)
+{
+	return rme_supports(RMI_FEATURE_REGISTER_0_SVE_EN);
+}
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
-- 
2.34.1

