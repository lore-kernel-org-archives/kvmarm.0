Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9DB438481
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783332026; cv=none; b=FATpObf3Vh8z4PzWhFJwcVVE1LnN0UxnQJA3r/qkKBxTRokqUsnhIrxHJMyY9URncVdI5y8em6VXuAlhUzDLWAyjdRRlPS4hQmKVAq6Y5kvp9LYeTpV2raarng0makfstReeJnMLOOKnRPQ3Gf9gN8VtOFDOTr4yc/kesy8QGjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783332026; c=relaxed/simple;
	bh=fZBm9U49NriW6i5YLhn3zhSRCOjztPWLyDa0JgPgYNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IrRUi1okSn8TPWQ2rL2kSyZC9Ono9uaDadmebZJua+/EQY+kpjgevELsBp/3VJ6EUy1qtKq8LT0tNa31v6nd/EJltWPz1TQ4YMzTWtx/ThSYDeqU2gsOuhUE6HKxEHLzIh+9wmAKNjq4+sj/qrjq768NEmi3mPAWAacNH0OQRxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S9UjUBek; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S9UjUBek"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783332022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPa4aylWgI5AC08JpsSdo1aaI++VFHxt+8yeLWVTzSI=;
	b=S9UjUBekcHpV00inOo3Kdl1t9RCdLzbsoSjkdFKRI8Vvp7m5/6HIZXro1u2uDVj7RgCngk
	dJ2AW2OVaucF241sVsWnpJpPXSvc6d3Ve7jTOfxp76W7p7jjjA8K4PBYUKoCUCsyv/STlt
	9E+IKcgsyKNqB46yEvKgUbzdL3qXpnc=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v4 7/8] KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
Date: Mon,  6 Jul 2026 10:59:26 +0100
Message-Id: <20260706095927.560795-8-fuad.tabba@linux.dev>
In-Reply-To: <20260706095927.560795-1-fuad.tabba@linux.dev>
References: <20260706095927.560795-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

pKVM performs its own world switch for protected VMs but has no
primitives to move the per-vCPU VGIC state between the host and
hypervisor vCPU contexts.

Add flush_hyp_vgic_state() and sync_hyp_vgic_state(). Flush copies
vgic_hcr, the in-use list registers and used_lrs from the host into the
hyp vCPU and pins vgic_sre to a fixed value; sync copies vgic_hcr,
vgic_vmcr and the in-use list registers back. The active priority
registers are handled separately by the save/restore-aprs path.

Bound used_lrs by hyp_gicv3_nr_lr, the cached implemented-LR count,
instead of reading ICH_VTR_EL2 on each entry. That clamps the
host-supplied value and avoids a per-entry sysreg read that is costly
under NV.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 55 ++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f3233ee343a39..2db56146ec493 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -104,6 +104,45 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 }
 
+static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
+	unsigned int used_lrs, i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	hyp_cpu_if	= &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+
+	used_lrs	= host_cpu_if->used_lrs;
+	used_lrs	= min(used_lrs, hyp_gicv3_nr_lr);
+
+	hyp_cpu_if->vgic_hcr	= host_cpu_if->vgic_hcr;
+	/* Should be a one-off */
+	hyp_cpu_if->vgic_sre	= (ICC_SRE_EL1_DIB |
+				   ICC_SRE_EL1_DFB |
+				   ICC_SRE_EL1_SRE);
+	hyp_cpu_if->used_lrs	= used_lrs;
+
+	for (i = 0; i < used_lrs; i++)
+		hyp_cpu_if->vgic_lr[i] = host_cpu_if->vgic_lr[i];
+}
+
+static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
+	unsigned int i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	hyp_cpu_if	= &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+
+	host_cpu_if->vgic_hcr = hyp_cpu_if->vgic_hcr;
+	host_cpu_if->vgic_vmcr = hyp_cpu_if->vgic_vmcr;
+
+	for (i = 0; i < hyp_cpu_if->used_lrs; i++)
+		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
+}
+
 static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
@@ -152,13 +191,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
-	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
-
-	/* Bound used_lrs by the number of implemented list registers. */
-	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
-		min_t(unsigned int,
-		      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
-		      hyp_gicv3_nr_lr);
+	flush_hyp_vgic_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }
@@ -166,9 +199,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
-	struct vgic_v3_cpu_if *hyp_cpu_if = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
-	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
-	unsigned int i;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
@@ -181,10 +211,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
 
-	host_cpu_if->vgic_hcr		= hyp_cpu_if->vgic_hcr;
-	host_cpu_if->vgic_vmcr		= hyp_cpu_if->vgic_vmcr;
-	for (i = 0; i < hyp_cpu_if->used_lrs; ++i)
-		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
+	sync_hyp_vgic_state(hyp_vcpu);
 }
 
 static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
-- 
2.39.5

