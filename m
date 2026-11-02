Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648759;
	b=UNQvnlYPBxUoksCfAobcQEWAQMQNlngTduB67Z8CwVViN4ok/cwleMib5W1S6a6DILrb
	 mHYKuiYvXy/mE8IDKR6wg8aBjTpD7cZ5N408gjZ5TSQCtxrsop1MD1RIqG/GrRmk6FYX5
	 VRg/+Q0zP2oyoEvDau5XR0dQNXGBZOWJOB+OxHA/m28Ibc27hUeOcjtSQs9p4jxdmPNr7
	 VB+oMVXLR94fPT1YqH+tj1rReeKadze5FWRZZs0Me+QZi7WlE5EK454KX/tlbLcSKMWMe
	 zYe1m7El7K+l8Y/H+nFv0jsSf1qHP2ALYKPv9U+YObmLofRijAjUPpq9+rWG5VCBePw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648759;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qOuOVg5igJk0l0cKpe3kS4IpkfdD/nQc+zjADTMQUTc=;
	b=QP0hi96YX2eTfVq7LTaALwaI4vZbOkejE83PTpSuJiWEMWb+hzhlrw1sPSiEfqcsZ9im
	 sDRg9a6D/DnPnTlAMCJtm3Kgag0pvGEdzDU/a8QLTDtSSjOFXy2ea7zQGkZKFtC4n8vqR
	 5etvASwdacraIzM0ji38h8IfsRtOGWaZlfso5zJTLSExjwpaPxZfYhtTBMNWkOh+G9074
	 cDzpYbn5gTv3PXC8i7y5eBU4JktKdP+INaB/qm/NKFQ2QSG727rG+70wLGB2X/UP1IeUM
	 71KjPMzBzJnN4E5G5heCS3OYXaMZK4GR3XvklhJ3UheWSe1QYn44n75pCzgoA80NBKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VtqsPKOw;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD717606D806
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD717606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VtqsPKOw
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34A1916A3;
	Mon,  2 Nov 2026 11:45:55 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 814353F673;
	Mon,  2 Nov 2026 11:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648758; bh=HbkceO9Jvi1pHg5NAr4YKMfv9wLgqv8TlP3wf/5vuxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtqsPKOwSt4TavoWbGOlCx2M0NxIoA7KEoGpw0KmCODkVDtvjA+oz3/nswa/vPsGS
	 5U8ua0b8GGDeZYBhFO4law6qSXds+xbtZnAEQdWM+uTYcGFVQCkGWZH1BjjPj4J+kT
	 W3O7iUJa1GtKGJeOEgY5OSrbjXwjg1G04t47w8W4=
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
Subject: [PATCH v2 12/16] KVM: arm64: vgic: Move direct MSI support helper to common MMIO code
Date: Mon,  2 Nov 2026 19:44:50 +0000
Message-Id: <20261102194454.4086911-13-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102194454.4086911-1-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
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

Move vgic_supports_direct_msis() from the GICv3 MMIO code to the
common VGIC MMIO file without changing its behavior. GICv5 will extend
this helper when irq forwarding support is added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 13 -------------
 arch/arm64/kvm/vgic/vgic-mmio.c    | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5c7be55ba95d6..b9b0531954f52 100644
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
index 5371d0b8bd0c6..3c0c858608752 100644
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

