Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887A34746AB
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121026; cv=none; b=tiQO6SSet00YTx0ML+tgr3br9OPyHPK3QQZEsmOmP3EO9u6JnMWWv1Q2hIVyj/xbBh9cUxDt5TlEejFpLW/JHYrMUCubJZTym2MdtUKqXZ3X3v6Ug+1F+5CQ2jTSlAVn3p78Bmjyn6taaf492xj9bKh+ukJAOMh1mvnpuItqMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121026; c=relaxed/simple;
	bh=/+oBPRPor12nAw5j501NP9Ed7vddxDnJfcm2D2u6JbQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GpfxZpavWSr7nrcHdxpOfSS2naGlpdSOIjUtXiyO7FSU5xpebWUXv+QFH7pJnHxz+HVQbo/0pR3yZlL3HyDkGJOyrQkP1/eJIfxweNcwO1Vf0xSGWn8pv82+osYlDaX66tZl18ZyL4g1M528kMFBzA1VoGNcyod7/pkNY5xckxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dg2Pwv7c; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dg2Pwv7c"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49561facb1dso21895325e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121023; x=1786725823; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DRnRzIglH4bre6fymvnhTQIWpGXgBbzyHJfeoNchwKg=;
        b=dg2Pwv7c/2xXzpG8hdtqxwGa4tLImLESimkbBGXr1g8MqhP1gvMqfNOLvJT6Vzl90q
         a27yaLhI/IW7cWk0yB/pTjLSBHhhcHz0G/dVL+tt4Okc9BhBPspLF7G6u8woEyf8Qeb8
         pY+K1PaajcgH5/zvqoOuZbJCKYsLDrsMWMgEcBeQXfAVvS4GMWLsnbbIwN2XrokKBcEh
         xjlxfb5xmfi8eopIgBXiCVyONhaMN54TH31hIl7ZWF7FUKEjswD9rPVLdhg65npTq88u
         PktJfvETrsTKZyLOOwVkvURa2fhBrvUy1GN75PBkWbwY+DIw2GwF6Hdr4EEXesfj698F
         BDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121023; x=1786725823;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DRnRzIglH4bre6fymvnhTQIWpGXgBbzyHJfeoNchwKg=;
        b=f55pzjN/98OFqBBXrmc1Md+FD8YzwZJkAHVVlFI+Rl/cYg6oWjXmEo4wKoU3hn2adD
         1AE9F9sycMC6PSdPOWan93OX45VyI/duMFybptUfSjgm5It08ix2MLP1PZeKXDdo5Shk
         BoKeOkaVTsI/bGFSEh2bthxPO3C5AbJXVKKhCT5Td2yeSyhvv/RAOR4qcokc5XoAIWR9
         sKF4Q7kgyDolMQGvDmic4YYMOVPflKmSVxT+HY/dMxtYra0NtzyhmKx/IFCHg5l8NZEW
         YWaFEFL5JZz1h1DIJAl+0T6z4XtaYNyv+ZFTDXhJlAUJXaSuzVGBg7mDJgTZK7CaNjMb
         qUow==
X-Gm-Message-State: AOJu0YwM0BMq4/If7wDsxEPZZfgByW97scaTnLGxgwDEKepP0ikX3gPc
	nGofrxcYTMndTIRz7RPCtRYPABD1k5fkJX4jeTfrKiENNFFUUani3agFDfxZA/E0SMeEzqsDt6S
	JjOKyVXQaidvfZvT9btsC2tbxjGSqNQ==
X-Received: from wmbhu19.prod.google.com ([2002:a05:600c:a293:b0:493:f83f:e304])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c297:b0:494:596e:e8c4 with SMTP id 5b1f17b1804b1-4994e7d3395mr238197545e9.17.1786121022494;
 Fri, 07 Aug 2026 09:43:42 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:13 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-5-sebastianene@google.com>
Subject: [PATCH v2 03/13] KVM: arm64: Support host MMIO trap handlers for
 unmapped devices
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hook a handler to the host mem abort so that the hypervisor can
intercept host accesses to unmapped memory regions.
When a Stage-2 fault occurs on a registered device region, the
hypervisor will look if there is any registered function that
can handle the access. On the back of this, mediate host accesses
to devices and emulate them in pKVM.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Bart=C5=82omiej Grzesik <bgrzesik@google.com>
---
 arch/arm64/include/asm/kvm_arm.h      |  2 ++
 arch/arm64/include/asm/kvm_pkvm.h     |  4 +++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 49 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c       |  3 ++
 4 files changed, 58 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_=
arm.h
index 3f9233b5a130..6360c90f9855 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -304,6 +304,8 @@
=20
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
+#define FAR_MASK	GENMASK_ULL(11, 0)
+
 /*
  * We have
  *	PAR	[PA_Shift - 1	: 12] =3D PA	[PA_Shift - 1 : 12]
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm=
_pkvm.h
index ab26bec079d6..0a471564be00 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -20,9 +20,13 @@
 /* The maximum number of hypervisor protected regions from the host */
 #define PKVM_PROTECTED_REGS_NUM	8
=20
+struct pkvm_protected_reg;
+typedef void(pkvm_emulate_handler)(struct pkvm_protected_reg *region, u64 =
offset,
+				   bool write, u64 *reg, u8 reg_size);
 struct pkvm_protected_reg {
 	u64 pfn;
 	u64 nr_pages;
+	pkvm_emulate_handler *cb;
 };
=20
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvh=
e/mem_protect.c
index 500c18c2fd48..7e978e0c44b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -14,6 +14,7 @@
 #include <asm/stage2_pgtable.h>
=20
 #include <hyp/fault.h>
+#include <hyp/adjust_pc.h>
=20
 #include <nvhe/arm-smccc.h>
 #include <nvhe/gfp.h>
@@ -752,6 +753,50 @@ static void host_inject_mem_abort(struct kvm_cpu_conte=
xt *host_ctxt)
 	inject_host_exception(esr);
 }
=20
+static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64 e=
sr, u64 addr)
+{
+	u64 offset, reg_value =3D 0, start, end;
+	u8 reg_size, reg_index;
+	bool write;
+	int i;
+
+	for (i =3D 0; i < num_protected_reg; i++) {
+		if (!pkvm_protected_regs[i].pfn || !pkvm_protected_regs[i].nr_pages ||
+		    !pkvm_protected_regs[i].cb)
+			continue;
+
+		start =3D PFN_PHYS(pkvm_protected_regs[i].pfn);
+		end =3D start + PFN_PHYS(pkvm_protected_regs[i].nr_pages);
+		reg_size =3D BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
+
+		if (start > addr || addr + reg_size > end)
+			continue;
+
+		reg_index =3D (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
+		write =3D (esr & ESR_ELx_WNR) =3D=3D ESR_ELx_WNR;
+		offset =3D addr - start;
+
+		if (write && reg_index !=3D 31)
+			reg_value =3D host_ctxt->regs.regs[reg_index];
+
+		pkvm_protected_regs[i].cb(&pkvm_protected_regs[i], offset, write,
+					  &reg_value, reg_size);
+
+		if (!write && reg_index !=3D 31)
+			host_ctxt->regs.regs[reg_index] =3D reg_value;
+
+		kvm_skip_host_instr();
+		return true;
+	}
+
+	return false;
+}
+
+static bool is_dabt(u64 esr)
+{
+	return (ESR_ELx_EC(esr) =3D=3D ESR_ELx_EC_DABT_LOW) && (esr & ESR_ELx_ISV=
);
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -774,6 +819,10 @@ void handle_host_mem_abort(struct kvm_cpu_context *hos=
t_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr =3D FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
=20
+	if (is_dabt(esr) && !addr_is_memory(addr) &&
+	    handle_host_mmio_trap(host_ctxt, esr, addr | (fault.far_el2 & FAR_MAS=
K)))
+		return;
+
 	switch (host_stage2_idmap(addr)) {
 	case -EPERM:
 		host_inject_mem_abort(host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index 64c0290da888..4395595b7f7e 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -294,6 +294,9 @@ static int donate_protected_mmio_regions(void)
 						  pkvm_protected_regs[i].nr_pages << PAGE_SHIFT);
 		if (ret)
 			goto err_setup;
+
+		if (pkvm_protected_regs[i].cb)
+			pkvm_protected_regs[i].cb =3D kern_hyp_va(pkvm_protected_regs[i].cb);
 	}
=20
 	return 0;
--=20
2.55.0.654.g21b8a5bc05-goog

