Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624512;
	b=LHlVN8AIa5E5uwrB9CFbMRXEXQf0L743LjUSCTkJqo2iycC2A6vL9Gt+cKcyGL2ppiAs
	 JdWtbivz/sy6PPJQnPBA2VjYYgE7dG0usgVXpBqiUaqiD9ESIS7Ka0sd7XJOTEIzacjbY
	 zsUJj6FKbipvHbTihQ94eeCC7nkrgl4wm7zC2BK7+v32il3hC2n3QfB/+/jdkRzCQtDHQ
	 G4/bVxNpO4zdnTs1CTroPXMoFiiYrxRyyn8CCYR/pT4UyqwCc2Rsf9chrbjd+7ZutVmOd
	 7O4VkdehqooxNMAjXHb7AhMUlqXLHMescwujj5jWfKSKgJxE1xNLxfDkEmLwuh7LHvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624512;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vzUCBfEqZA71dS3jLvdXgp0iBiHaOT4PnmGdXf9hgiI=;
	b=UlF6DlpwUSXQTHaa9ABic5TvQL2E0zV2NVEy81L16O83sJWGvDCnu+h6wLXb75bKbHZt
	 ef4f0N8x3JyQPePjpvrq3Jdrj7L1CQ+ztLvjF0MF4oXwANYU4p4Y+lTHPNpHWqXQILx90
	 Nrjprcn0RF77dKHCZ01ywb8DxGCmjRh1Bh/1X3P0x/wJvUZywwRAmsCisklK2eArWU5QB
	 uhhmC13d+WByU5BdNiQ00rcjR8xRc/kYE0dhjbIIZC6EzCJVTI+XRgtvc36pxbgjWI0j/
	 kRbf7hBarIcIFfm4hVcjtjd04khR1/FKsHf+tqkVvOBgqZFlIyMk/TNnaEAwdCJTecQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aX23+1+G;
	arc=none smtp.remote-ip=95.215.58.178
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A301B606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A301B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aX23+1+G
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ic6nIPaRt569Q39hvXzAm3CJLBkg+LPeh9WqbciieLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624509; v=1; x=1794229309;
 b=aX23+1+GSfAb4heSxPGHbC4itt2et46sZoOAiZzTKmW840sXVuY9VVvs7iuP2g0p6XIr4ZtB
 D70KVPSkJD85JQLfPLdZcrEAm/ntdwQoCe2F1k8fZRvY0Wzus5SWWTxj6k9dgaqFT6+cqpUEkwW
 RNZwAVKLeVYlw7/Un/lEOopg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a1dd30557d3ae716;
	Mon, 02 Nov 2026 13:01:49 +0000
X-Mizu-Trace-ID: a1dd30557d3ae716
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/13] KVM: arm64: Take host-registered MMIO regions at pKVM finalisation
Date: Mon,  2 Nov 2026 13:01:22 +0000
Message-ID: <20261102130133.3684226-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
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

From: Sebastian Ene <sebastianene@google.com>

To mediate a device, the protected KVM hypervisor has to own its
registers, so that a host access to them takes a stage-2 abort rather
than reaching the device.

Let the host register MMIO regions before the hypervisor initialises,
and have __pkvm_init_finalise() donate each one and record where it's
mapped in the hypervisor's private range. The donation runs before
pkvm_check_host_ownership(), which then covers those mappings too. A
failed donation fails the hypervisor's initialisation before the host
stage 2 is installed, so nothing is given back.

Nothing registers a region yet.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v2 (v2 patches 02 and 03, merged):
    - The trap handling moved to patch 9, which calls the ITS emulation
      directly (was a per-region callback)
    - Each region records its hypervisor VA
    - A failed donation is no longer unwound

 arch/arm64/include/asm/kvm_pkvm.h     | 12 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 +++
 arch/arm64/kvm/hyp/nvhe/setup.c       | 22 ++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fd042d2b54624..4695c35b31e1a 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,6 +17,18 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+/* MMIO regions the host registers for the hypervisor to take at finalisation. */
+#define PKVM_PROTECTED_REGS_NUM	8
+
+struct pkvm_protected_reg {
+	u64			pfn;
+	u64			nr_pages;
+	void __iomem		*hyp_va;
+};
+
+extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
+extern unsigned int kvm_nvhe_sym(num_protected_reg);
+
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a6dacaca77610..8d45f45d30e6a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -28,6 +28,9 @@ struct host_mmu host_mmu;
 
 static struct hyp_pool host_s2_pool;
 
+unsigned int num_protected_reg;
+struct pkvm_protected_reg pkvm_protected_regs[PKVM_PROTECTED_REGS_NUM];
+
 static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
 #define current_vm (*this_cpu_ptr(&__current_vm))
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 7bbc26b28faa5..18f348d1331a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -295,6 +295,24 @@ static int fix_hyp_pgtable_refcnt(void)
 				&walker);
 }
 
+static int donate_protected_mmio_regions(void)
+{
+	struct pkvm_protected_reg *region;
+	unsigned long haddr;
+	int ret, i;
+
+	for (i = 0; i < num_protected_reg; i++) {
+		region = &pkvm_protected_regs[i];
+		ret = __pkvm_host_donate_hyp_mmio(region->pfn, region->nr_pages, &haddr);
+		if (ret)
+			return ret;
+
+		region->hyp_va = (void __iomem *)haddr;
+	}
+
+	return 0;
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
@@ -335,6 +353,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = donate_protected_mmio_regions();
+	if (ret)
+		goto out;
+
 	ret = pkvm_check_host_ownership();
 	if (ret)
 		goto out;
-- 
2.47.3

