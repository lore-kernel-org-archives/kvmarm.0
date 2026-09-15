Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248064A5EA6
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 12:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475937; cv=none; b=bBCDG26J59ivSHJl/NVTPhRSYFrGIwPALHRyqZgGdinVlzytJ7mx8dqVbjadLqFd/YT12XOb1qG28DtYHfJgMXOxfzwI7FJoUVXmW3TXtBMPXEDkLCptWgjya3xtoY/hQV4Rt+zjaH1kOQNmSWU/ZA5jdYhMAs5aK5ONwG9pEwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475937; c=relaxed/simple;
	bh=OYn21/OL8lrH8NaEq6iDghNkvvHb7mfdPr+Xymc5Uv4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eOYktqhAhSioOnKSpwtK/Xocv3Szc2Puj7PW1S4upR2FFwBwBbWuVPl2xhgqRbrlnzbHrjkwy0l5Dyh5Q9zzCy8Cia7pGcfT/yhswa2qwSsE+iCXjlFaIIbjon53LML8c3n6ZwZ27gooyIW3p16IWdY4rkBqrspwtLLC9ciZ2po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sLGOpyzw; arc=none smtp.client-ip=91.218.175.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sLGOpyzw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OYn21/OL8lrH8NaEq6iDghNkvvHb7mfdPr+Xymc5Uv4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475932; v=1; x=1790080732;
 b=sLGOpyzwzs54A3Ahsz95fdgWWwkR5suF6AwRR5E7V8bnM5uZ28ZHrx4Kw48HOmSaRv06YUeU
 0ELla9oGYkEsAS0+MqXHzufqg10BAyYM9c7lUAAKUAt+OU8gh3p9Kg6FQ6GyWjLWFkuBNNCRpg+
 l87OkMPlYVzaLsyc/IFh9RvU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c54ddb4cd2b28d49;
	Tue, 15 Sep 2026 12:38:52 +0000
X-Mizu-Trace-ID: c54ddb4cd2b28d49
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
Subject: [PATCH 1/7] KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
Date: Tue, 15 Sep 2026 13:38:40 +0100
Message-Id: <20260915123846.2317931-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915123846.2317931-1-fuad.tabba@linux.dev>
References: <20260915123846.2317931-1-fuad.tabba@linux.dev>
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

