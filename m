Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A4E4411FB8;
	Mon,  3 Aug 2026 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764868; cv=none; b=oBb910zwZ/xpmqKuAZCbIeSnlsaWmNz+fn+a47RfrgSXFuu6vSMHLKy9+SvadkyoKrZnHg7HqNzTatjaj2lCnVUodCy47sE6vA5Nij97kZtxtVLovHw508AX0l8nFn/5mcnJvfyD+5xGxwLQkD8n9BMYMt1eOuHqSgQxND0zoZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764868; c=relaxed/simple;
	bh=hU5/Y8gLAYSgHVaaIBAsTIEwnwJD0RpetBq00JLKOGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Owq2nJjq89b1WvcY2A6p8ubsAWE+uXi/Ytl0jT+MWBwLlvEPZJ55q5N8yfLWDfIcRWbpMaFe5GVzTllM3AM98EPv7x8Y4TNNwi8IaZQMm6cGDPzwhJri/zXESfhKY2VcqjErTnIXXvRFgbVFJLfbZNx+15UY+5kpC/w5TI9LFBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EqPEZkcE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EqPEZkcE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 656931476;
	Mon,  3 Aug 2026 06:47:42 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B81D03F66F;
	Mon,  3 Aug 2026 06:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764866; bh=hU5/Y8gLAYSgHVaaIBAsTIEwnwJD0RpetBq00JLKOGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqPEZkcECjXMW/VhDiaE+juIi+dG8W9nNkF9DspL9f2NlLZ43EJqeEQim6ialXL4w
	 FlZ1572dutPCpiphYSWqn+cTBE5ZA8q66IxT8CVQCvY+uOj/OyA6HspeF9UpttJ+CB
	 RwogHDCHvHnoka54u8OW8QPpszwgy5yfxCARZVd4=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 44/45] KVM: arm64: CCA: Require ICH_HCR_EL2.TDIR for realms
Date: Mon,  3 Aug 2026 14:44:00 +0100
Message-ID: <20260803134403.80630-45-steven.price@arm.com>
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

KVM advertises realm support when the RMM is available, and allows
userspace to create a VM with KVM_VM_TYPE_ARM_REALM on that basis.

On CPUs that lack ICH_HCR_EL2.TDIR, KVM uses ICH_HCR_EL2.TC for
normal guests so that ICC_DIR_EL1 is still trapped via the common GICv3
CPU interface trap. Realms cannot rely on the normal hyp-side trap
handling for that fallback, so advertising RMI support on such systems
lets userspace create a realm that cannot safely run.

Require the finalized ARM64_HAS_ICH_HCR_EL2_TDIR capability when
reporting KVM_CAP_ARM_RMI and when accepting KVM_VM_TYPE_ARM_REALM.
This leaves normal VM creation unchanged on systems that need the TC
workaround.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v16
---
 arch/arm64/kvm/arm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fd4e13ff17cf..7edc572dd8ab 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -125,6 +125,12 @@ static bool vgic_present, kvm_arm_initialised;
 
 static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
 
+static bool kvm_arm_rmi_supported(void)
+{
+	return static_key_enabled(&kvm_rmi_is_available) &&
+	       cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);
+}
+
 bool is_kvm_arm_initialised(void)
 {
 	return kvm_arm_initialised;
@@ -256,7 +262,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	if (type & KVM_VM_TYPE_ARM_REALM) {
-		if (!static_branch_unlikely(&kvm_rmi_is_available))
+		if (!kvm_arm_rmi_supported())
 			return -EINVAL;
 		kvm_set_realm_state(kvm, REALM_STATE_NONE);
 		kvm->arch.is_realm = true;
@@ -537,7 +543,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = kvm_supports_cacheable_pfnmap();
 		break;
 	case KVM_CAP_ARM_RMI:
-		r = static_key_enabled(&kvm_rmi_is_available);
+		r = kvm_arm_rmi_supported();
 		break;
 
 	default:
-- 
2.43.0

