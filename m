Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621218;
	b=SJqfHKhJrsEgPainIyMWRGCgXhCrA6jzzHWr8qeCB8TeGxk/Pfp0uAoWznv7qPC/oFtU
	 QDp/5bRnbMiLzT4dU7g1Whp1jMfNaxBJFQVOB1soVSi8amHi0XjvSuraqTyfUWzuUeB9Y
	 vzl4QfvDRYaH8+ShcGukAz/mtbL1D1Hz5d+BpqQCEgjPUW628BG35IOiwscFYAYLJkPf2
	 lcRah2D8D1HG2RgPcPe4vMzV+8obM6E2Us+awkIsEtAUnZo0KnivN8JLSZpooDZMN62l/
	 tLDN/APbRBbxOsjFZ5dIdqmmh9ZOTVA8wRFih0ZnhYsAgbOyPq9WlF4ePflpODw+pew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621218;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qbr0ToIRukyd9N1ATmvPfXzS3NsxYVjmc9OXslO5iLU=;
	b=wucrc7CGPhZVOZschsARcmtEvN8q+gFwL/leygXx0D1Wn/D3depR7Epdy+AhEccaXLiK
	 WeAnMsLDnsWEID52PWTnlIi6qaDh6v7rNuI9IpJnhnu8yMxulrpC5m2tbhKETLoAFo7/A
	 yiU05AXBfa5NmAbS1ZHVdw3hiZ44tQj6sLeOBTCeqYhIDeDNiNmCgZwp4pbP4smPaBcWk
	 d+hS+4hrFAx5ZlqGAglsQD6AhPgWOklvkPF2Z7iYifkxUDR9kPC/nN3PXSEVUU8hELQeF
	 pgBJOjM3o86XZfliY/pby4tkO7yUlbjcqB442zl5MIw4xH3nsXaT6y1wxix4KNs/fiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="s7u//9+Y";
	arc=none smtp.remote-ip=95.215.58.128
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADF760A261F
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ADF760A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s7u//9+Y
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=85zZ4ygCard9cwsSRJu3jtuVcm5hyiXKIN9OY76t33s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621215; v=1; x=1796226015;
 b=s7u//9+YM69pFG2VB1eWaUYi7DG9DErPPzty8kwaM+koz37LDntBGVGLNKi3JDdJwDewyiBE
 hojNjChU6mgk9nTNoX5T0Yqa/o1pgS0X2AYlFgNwAqJbyYKGKwG/UCOCvZtmA2QLg0q7jJED1rC
 n1nmYIushGPXzbTlbOt2H754=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8e70405d302e2335;
	Wed, 25 Nov 2026 15:40:15 +0000
X-Mizu-Trace-ID: 8e70405d302e2335
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/20] KVM: arm64: Compute a protected vCPU's fine-grained traps at EL2
Date: Wed, 25 Nov 2026 15:39:02 +0000
Message-ID: <20261125153911.106793-12-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
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

pKVM sets a protected vCPU's HCR_EL2, MDCR_EL2 and HCRX_EL2 at EL2 from
the VM's ID registers, but never computes its fine-grained traps, which
stay 0. That traps every register with a negative-polarity trap bit, so
a feature such as S1PIE can't be advertised to a protected VM.

Link config.c into nVHE hyp and compute the VM's FGU masks and the
vCPU's fine-grained traps there, under vm_table_lock, once the ID
registers are set. Build hyp without the latent_entropy plugin, which
adds a reference to config.c's __init functions that hyp can't resolve.

This also restores the AmpereOne AC03_CPU_38 masking of a protected
vCPU's TCR_EL1 writes, which was lost when the erratum's trap moved
into the per-vCPU fine-grained traps.

Fixes: fb10ddf35c1cc ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 4 +++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c   | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 56a7e2c05f73a..2980f1af90166 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -12,7 +12,8 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
 ccflags-y += -fno-stack-protector	\
 	     -DDISABLE_BRANCH_PROFILING	\
-	     $(DISABLE_KSTACK_ERASE)
+	     $(DISABLE_KSTACK_ERASE)	\
+	     $(DISABLE_LATENT_ENTROPY_PLUGIN)
 
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
@@ -27,6 +28,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
+hyp-obj-y += ../../config.o
 hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
 hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fba8dfe6389d6..465d963d6ff57 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -206,6 +206,8 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 	pvm_init_traps_hcr(vcpu);
 	pvm_init_traps_mdcr(vcpu);
 	vcpu_set_hcrx(vcpu);
+	kvm_init_fgu(vcpu->kvm);
+	kvm_vcpu_load_fgt(vcpu);
 
 	return 0;
 }
-- 
2.47.3

