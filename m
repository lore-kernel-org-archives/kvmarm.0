Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB353D34BB;
	Mon,  8 Jun 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929818; cv=none; b=Kv/MS7jbU7mREq15r8FWi/PrSm1QZmHxKu/sZP7Oi0eN0SAQd1LhnodHAGEH9fs7zX4FgVgZ7gT09eBzEhMYFMyzltv8G3OXwy9HwFVELR9izMXwmkQnZZmXpYYC0F2zTyTgr80G90vvey7tz0sgAk7vshtLl6bhyQOLWYBMzEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929818; c=relaxed/simple;
	bh=pjWIZxGpi+7ygieb0/BdE6iP0hrjjNMMO9svLfl+2Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riw9JnsbEmxx0RocTiqVA3cY+65Xtw2f91Xd+hkOHMcnN4/OMAG+1oW+5cTl+dr27wSKRh2GF2aqsn7mStMu0OBcFFGp0caBeNHpPTR5M00sNcN8JUF9wgBaiI3oHVlEU484okF/m7ugZWw/KWH1vZkitLSIgL/HMR/KD1+U8aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id EF1012028D1;
	Mon,  8 Jun 2026 16:43:14 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com
Subject: [PATCH 46/60] kvm: x86: Share MTRR state across planes
Date: Mon,  8 Jun 2026 16:42:38 +0200
Message-ID: <20260608144252.351443-47-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <joerg.roedel@amd.com>

Share the MTRR state across all planes of a given VCPU index.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/mtrr.c             | 12 +++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b0d040528f9d..f30173093c44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -817,6 +817,8 @@ struct kvm_vcpu_arch_common {
 	 */
 	u32 cpu_caps[NR_KVM_CPU_CAPS];
 
+	/* Cache configuration state */
+	struct kvm_mtrr mtrr_state;
 };
 
 int kvm_arch_vcpu_common_init(struct kvm_vcpu_common *common);
@@ -994,7 +996,6 @@ struct kvm_vcpu_arch {
 	bool smi_pending;    /* SMI queued after currently running handler */
 	u8 handling_intr_from_guest;
 
-	struct kvm_mtrr mtrr_state;
 	u64 pat;
 
 	unsigned switch_db_regs;
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 6f74e2b27c1e..610ff975e022 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -23,18 +23,20 @@
 
 static u64 *find_mtrr(struct kvm_vcpu *vcpu, unsigned int msr)
 {
+	struct kvm_vcpu_common *common = vcpu->common;
+
 	int index;
 
 	switch (msr) {
 	case MTRRphysBase_MSR(0) ... MTRRphysMask_MSR(KVM_NR_VAR_MTRR - 1):
 		index = msr - MTRRphysBase_MSR(0);
-		return &vcpu->arch.mtrr_state.var[index];
+		return &common->arch.mtrr_state.var[index];
 	case MSR_MTRRfix64K_00000:
-		return &vcpu->arch.mtrr_state.fixed_64k;
+		return &common->arch.mtrr_state.fixed_64k;
 	case MSR_MTRRfix16K_80000:
 	case MSR_MTRRfix16K_A0000:
 		index = msr - MSR_MTRRfix16K_80000;
-		return &vcpu->arch.mtrr_state.fixed_16k[index];
+		return &common->arch.mtrr_state.fixed_16k[index];
 	case MSR_MTRRfix4K_C0000:
 	case MSR_MTRRfix4K_C8000:
 	case MSR_MTRRfix4K_D0000:
@@ -44,9 +46,9 @@ static u64 *find_mtrr(struct kvm_vcpu *vcpu, unsigned int msr)
 	case MSR_MTRRfix4K_F0000:
 	case MSR_MTRRfix4K_F8000:
 		index = msr - MSR_MTRRfix4K_C0000;
-		return &vcpu->arch.mtrr_state.fixed_4k[index];
+		return &common->arch.mtrr_state.fixed_4k[index];
 	case MSR_MTRRdefType:
-		return &vcpu->arch.mtrr_state.deftype;
+		return &common->arch.mtrr_state.deftype;
 	default:
 		break;
 	}
-- 
2.53.0

