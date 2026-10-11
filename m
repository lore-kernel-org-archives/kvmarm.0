Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8A4456DE6
	for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729439; cv=none; b=HshfUBGZW12hYECPAZVH8AGTxicjQdman7Jjp6W2Zi0d4VjgA4kYQEMkDNsw/D8Hz9uXTS3M7B7ZMaU2aafmeH8V/CJNCTY2Tt12FK7YqqznRog53TJI7U73ssZukM2UuMg9bj3A+ZJ7u1z7F8OVVCE600FNDqzDY5CpFBScyaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729439; c=relaxed/simple;
	bh=sXzD5OweRtbt4uiu9AwJiDOee0ALx9j8z+8yBBR+qWw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bBH0PcpSibVjrMcpweLLb2X9v1CsgIwroIhTGexUsT3Rixr7g2al582IoFcDSG5QMLA7rJWQCk8e8udhhky7VoT0rIvOimDZ4ZA7cmksdNmdH4mUuL21xnyIGRyaxaFWvE+PSBUoQ6PBTEJIurvkiwwoamNKD3m7GtWrlasqDpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZYz9clKn; arc=none smtp.client-ip=91.218.175.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZYz9clKn"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sXzD5OweRtbt4uiu9AwJiDOee0ALx9j8z+8yBBR+qWw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791729436; v=1; x=1792334236;
 b=ZYz9clKnNdWI/O5o2aGxh+/ZoVtKOw/ugM8zfFc5swbuzadQsfIu/a7k5vywGkpLxCcuKx32
 WwwdICmG1O2qvh6FZv0prANzB/ZP+W/Caz5K8/NRk9ILAzEoyMEsKN/iWbVkFM2dQv0IpZoBoC2
 kHnYapCql8DBYDDnE5GV7WxU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f4561a6c30307f5b;
	Sun, 11 Oct 2026 14:37:16 +0000
X-Mizu-Trace-ID: f4561a6c30307f5b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH v2 5/5] KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch
Date: Sun, 11 Oct 2026 15:36:48 +0100
Message-Id: <20261011143648.211337-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261011143648.211337-1-fuad.tabba@linux.dev>
References: <20261011143648.211337-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__hyp_vgic_save_state() and __hyp_vgic_restore_state() handle GICv5 as
well as GICv3, but their comments name VGICv3 only.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f36..6b9e20f6b31b3 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -110,7 +110,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
-/* Save VGICv3 state on non-VHE systems */
+/* Save vgic state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
@@ -125,7 +125,7 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-/* Restore VGICv3 state on non-VHE systems */
+/* Restore vgic state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
-- 
2.39.5

