Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015159;
	b=Kqivl8EDOhdGYc5VnvQ83zffw58pMXO9WlhdnKOK8d+wMzRWQD16+1GhgsJ7Nz0bQ39A
	 mr/Ki24X8NOXFUC+Ee54CkoVUnKoVVAp+d0b1jE0S/Smnj3MGJS5uM6Hm5h8agEkpUjaH
	 Ro7XOeZnH/lB64CRtfzLqVShHS/lqM//mBGdGaODKaARu4jdlMw3ba8B8uCZLT13nOyY7
	 0VPNPh7JfdsDI/752WG0phxknXtFeUPiwBsOpvQ2R+cfc+GIB59JKEbvZqNQLeApqiviP
	 3kr4L0NTxwEfK/3qxcGE+zx+SUZmBmvsxaj2u6TwxFwlyqacky5wCydo8uMZJ/5HlEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015159;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rPx810a2flH9Psi7MrOMCvXrfkjTeB2Yo61ogPCEmWE=;
	b=uvCCdMNoRivq3CTaX1vinGy0rZwq7od0aBp3XaYIUBvWX2bjOSH0eBxOpdX3TyeUJ837
	 rUBTcMcwT+MeAcRiz6/7WeaIBGMYalvDsEMN5B5SFytfGGs6SIQ0uKa/8ryac3YwhYWg8
	 K9T6nur+xpiZNKJ/NY1KVgBA0rmzk3zbQlx6l+p/7YZCt0huMIJ2ROAbHoJ61tiPkvN/Z
	 hH96VRjDb2ZYBa/i2cbf9V4JpuYO2qGP5tH8Nz0PUIrai7ABT3A+RX09ZK/4xLXvEvR4Q
	 cWtp1TddfeebgvJviN3vj/v0uScBMQCcKh5Du/xEeKElrmByFRFpFwn4OL73mL9mt4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qoGg7anD;
	arc=none smtp.remote-ip=91.218.175.15
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF79606A33B
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFF79606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qoGg7anD
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=BpvlpGxqweTjuX9nBiR22uqAp+CdbTtP+gfVwPifVjQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015156; v=1; x=1795619956;
 b=qoGg7anDJn0i4ZkY2V528MfAr3+o6UrEWwbaoq0wiDo2SNZO1jBLe3Ws9OUEIbfqKFiLKu01
 5h5IAOYmWKB/oktK4E4v8x72DjYwI9BKKRTCwOVrTzK2IcqItKjhJvE+sglZqqW1CJUmQmivRhC
 823q+5ATXLNzKVozAtq2oFfM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 86f4abf1d8cad364;
	Wed, 18 Nov 2026 15:19:15 +0000
X-Mizu-Trace-ID: 86f4abf1d8cad364
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
Subject: [PATCH v4 02/13] KVM: arm64: Take host-registered MMIO regions at pKVM finalisation
Date: Wed, 18 Nov 2026 15:18:53 +0000
Message-ID: <20261118151904.4099560-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118151904.4099560-1-fuad.tabba@linux.dev>
References: <20261118151904.4099560-1-fuad.tabba@linux.dev>
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

To emulate a device for the host, the hypervisor has to own the device's
registers, so that a host access to them takes a stage-2 abort rather
than reaching the device.

Allow the host to register MMIO regions before the hypervisor
initialises, and have __pkvm_init_finalise() donate each one and record
where it's mapped in the hypervisor's private range. The donation runs
before pkvm_check_host_ownership(), which then covers those mappings
too. A failed donation fails the hypervisor's initialisation before the
host stage 2 is installed, so the hypervisor doesn't have to give
anything back.

The host doesn't register a region yet.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
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

