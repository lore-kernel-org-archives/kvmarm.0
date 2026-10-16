Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD3F7404E
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166387; cv=none; b=muOyhsg2pDxyiggIq10cIsbGEcUHRoMUU1Kg5OYKR9Dd77rJan9mOpoXtfw0KGwX/1l4mwobhWltY2eLqwqeZJTbhP+HB4NdKDlMrQ92sz3t4jOgPEHdlBGdASZyTpVMRX0cNGQvtO4swVczXB8htGV1VMWYkvRs2oPmUuLyS04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166387; c=relaxed/simple;
	bh=1azRP57indFClCcwxXjFmZrHm+gz1WUDbaiw0k9ncPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qccHXgXJAWkHoCY02D1hOzLzGpTTElyKiaTSA4x6EUsWJh5wNdHqSeRKdCcZ5x9CzECxvogcd/Z7owOeuE8NH8/yTQgKHuo8BwWwXoYqKgj1me1Crq6JdAdpxOC4dfTNx1ppr1YkrOmvBT/4hP6kKFFFHatvn6w5/ATIowgAQOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=U9x3Gfvn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="U9x3Gfvn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9E501516;
	Fri, 16 Oct 2026 08:59:42 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 049663F673;
	Fri, 16 Oct 2026 08:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166385; bh=1azRP57indFClCcwxXjFmZrHm+gz1WUDbaiw0k9ncPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9x3GfvnJCiIP7VskhZFbK3EILwU1ab/cafP/crdTOiJtLjwiNXtGr9HV5eKxCQI9
	 aWBxLGca6TgMeaTACFswdqjX5tnWP6c5qUrQ3QnDukzoLymbsSHJh7jGTecs+/o3Ve
	 tWIHF1+NTSVW7MvjqSMEdTsQVXKZr6XESdla9Lvo=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH 12/16] KVM: arm64: vgic: Move direct MSI support helper to common MMIO code
Date: Fri, 16 Oct 2026 16:57:37 +0100
Message-Id: <20261016155741.979985-13-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move vgic_supports_direct_msis() from the GICv3 MMIO code to the
common VGIC MMIO file without changing its behavior. GICv5 will extend
this helper when irq forwarding support is added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 13 -------------
 arch/arm64/kvm/vgic/vgic-mmio.c    | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index f5e6c1fe52431..9f16e19c25a23 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -38,19 +38,6 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
 	return reg | ((u64)val << lower);
 }
 
-bool vgic_supports_direct_msis(struct kvm *kvm)
-{
-	/*
-	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
-	 * indirectly allowing userspace to control whether or not vPEs are
-	 * allocated for the VM.
-	 */
-	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
-		return false;
-
-	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
-}
-
 bool system_supports_direct_sgis(void)
 {
 	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 755bc2d74c352..44f4a7f33fa3e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1142,6 +1142,19 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 				       len, &io_device->dev);
 }
 
+bool vgic_supports_direct_msis(struct kvm *kvm)
+{
+	/*
+	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
+	 * indirectly allowing userspace to control whether or not vPEs are
+	 * allocated for the VM.
+	 */
+	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
+		return false;
+
+	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+}
+
 bool vgic_has_its(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
-- 
2.34.1

