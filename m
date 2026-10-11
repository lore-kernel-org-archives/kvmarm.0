Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41EB448CE6
	for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729415; cv=none; b=X61Ta4dgUEx2BdEaMOnk1XUeQGIWKnz8QVkCN9N2CC+MXUyAhCo/s3Nm2PiGl5dTV59QPuOVEbGGt4c84HuOMDyNoMxuZsHgd3n7EAIqWMTAND4rzmh5V3bYmI1NWHb9SJATeRDNPJEhHWqJCAoi9Wg4+GlAIaFDg1clc4ukrp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729415; c=relaxed/simple;
	bh=OYn21/OL8lrH8NaEq6iDghNkvvHb7mfdPr+Xymc5Uv4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B0gXjKqqjdwG3OkDLGOzp+aGp3y2aY5Qg1iwWfgznhDRlAY7S46G5PHegk2MViSOXqh6HOPoJAV41BV3olQGRHvt/tLY9rcupyH9atEm1q9fQEbAw5ECVY65lGnnFzRNMzhNGVjPyXFiCTIox7q/N4MjO4a835GP1mH9u6lSnRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pagB3q/F; arc=none smtp.client-ip=91.218.175.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pagB3q/F"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OYn21/OL8lrH8NaEq6iDghNkvvHb7mfdPr+Xymc5Uv4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791729410; v=1; x=1792334210;
 b=pagB3q/FkgcGgbi/SX8/Y4X6grPtD6gyyVgB3lIw4yE2QjFrRLWAgs8Fpw0XZ3iyJjHH+ChN
 RawBGI6CSXQFaCT8w0MD6NzJr+7rPFZeKbFdHt8H92kD4P9hgPu/d3ypsU6RiKwOgcsONCRnVCH
 F45f1cl0XPiD9ISsHct75XaY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c296a38619e6afa6;
	Sun, 11 Oct 2026 14:36:50 +0000
X-Mizu-Trace-ID: c296a38619e6afa6
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
Subject: [PATCH v2 1/5] KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
Date: Sun, 11 Oct 2026 15:36:44 +0100
Message-Id: <20261011143648.211337-2-fuad.tabba@linux.dev>
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

__vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
once pKVM has finalised. pKVM never registers a GICv5 vgic, so neither
has a valid caller in protected mode, and on a GICv3 machine both reach
a register that is UNDEFINED at EL2 and panic the hypervisor.

Move both into the band the dispatcher rejects once pKVM has finalised.

Fixes: af325e87af5da ("KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_asm.h   | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69e..ea319c496bb26 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,6 +62,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MIN_PKVM),
 
@@ -87,8 +89,6 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
-	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
-	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626adb..7c939baf9c1ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -911,6 +911,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_enable_ssbs),
 	HANDLE_FUNC(__vgic_v3_init_lrs),
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
+	HANDLE_FUNC(__vgic_v5_save_apr),
+	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
 	HANDLE_FUNC(__kvm_adjust_pc),
@@ -932,8 +934,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__tracing_write_event),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
-	HANDLE_FUNC(__vgic_v5_save_apr),
-	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
-- 
2.39.5

