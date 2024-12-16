Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD45A20E339
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371922; cv=none; b=X6BeZgrWteYGUW3XEmyrtH+kcisUcyOhsVIS3yNoR6PHm5qbDZC6CnsLX6YIgChKmg8Fi3E9qEypHhRDs3/XtrXU4dB3nK3ouVV8vUCe9fF23ZhAfUbdxk3mUsb9NjZ4ejxFZwt5+0BXSbUF27xlnP8i8RKvKI8OGdhuyfMXTbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371922; c=relaxed/simple;
	bh=S5C7PA49mbBbYP0VC8WHfs83VKenKobir8rsTzZpXTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kPij2P5WuBLsgQVmKIPl+AtpQVbOZGlk0ve8+q6BZdehf06IqKB+1qZmaZMMrwSst+tlZKOMt/0yAtf5sj3F5guQjmYzmNY+B6PKfW0uTQJ4y9gUbsZp4N/TlUarG6upuEXpeu/WQekS30sTEqoOY7GH+3Dkrw9rVjjW7w8HBYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tP5J7/nP; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tP5J7/nP"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d3e77fd3b3so5297692a12.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371919; x=1734976719; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vLkxU7WF3J5Qh0Edw4/qg3eGiYkLZ2iXz4JSY5pi8io=;
        b=tP5J7/nPsCGEEnbIZSWhO3xGOvX0XJcU8H6Or3OcRoXlztT4ToREcUe18Y6IeOL86c
         kYarArFOodEg33XOqa8PKKR7SSBAbm/hXNN6xfkdw0xq9piYep+2vvJPk2A16qu3b5Jy
         dxRa0UMQl3YZBXOidRvkNTwOfKwg5ajIMfpYdx6tv5TBFUEm74cp3KYvA6SymnsB4rLG
         09x+wciftFhdvAqwpjjrvmnhxzteuIWRTXY+j2h9FkWMA0etU7+YRPTU5i+cvwg7l7YA
         xgDE9vvIiAqrdZ2PMvIBcvJOR4ULIa9he6WkAK3xzixTwF0fmFBp3otO/JiOpv+25e+6
         liog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371919; x=1734976719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vLkxU7WF3J5Qh0Edw4/qg3eGiYkLZ2iXz4JSY5pi8io=;
        b=OoEcIODep5wOS0QWEjNF/qGcvOM3o8QT7W3CWRctvEmpspPAHAKD+RIWwiC2C42rOU
         7/rGHVxp58L5EltRj59NIPFN2/z/h8VC8AU6vQQ5w2NIhw6BkNZ8IeJROJmxAOZ1RkdN
         QKxqKmDuH5kjBA7VbrvwdFJxqEIBW5HfQbs4IUXIEr80qSUZutWzg8pz9QFviYDFFL2+
         ua8sUVMCoGd6ZDQI5p7WX/uerhOdlVK8A+p272zZLgZ86AarloC0N4sUANHhMK0OIfrU
         ShDd4ORRazI1By0HfmWjbYgHLhZBtmOPF7AxfC+FZaXhZqQMrhQrjsYfV7ocSJpSP1Zs
         2s6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWaMcjadjjW694G/WWiiwTto0dT50quuAxK2cJLqtJ/sLUYVTHtO+nGz8IO071lstMwA+LeVTw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVbqOENuMsS4tv6HMD49mXJSpPHPrfvgQsHVaa/BtvBADNHLEJ
	1LPZQQstNXqPInANTBrxMMNPJdma4NWepiFYDoYTFcMaqh5BMq4a7lYuoMNXupvYVk6uUQ2qMz1
	L2eE87Q==
X-Google-Smtp-Source: AGHT+IGbIEoG5vbn6iQy08UEUu36i7r1jxdCnom039llyQo30KhKhUU2a+YhuuCdj1YaRdinsIVQTfjkxghQ
X-Received: from edvu14.prod.google.com ([2002:a05:6402:110e:b0:5cf:ca3f:365])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2807:b0:5d0:d610:caa2
 with SMTP id 4fb4d7f45d1cf-5d63c3ad29cmr12773175a12.26.1734371919408; Mon, 16
 Dec 2024 09:58:39 -0800 (PST)
Date: Mon, 16 Dec 2024 17:58:01 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-17-qperret@google.com>
Subject: [PATCH v3 16/18] KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a new hypercall to flush the TLBs of non-protected guests. The
host kernel will be responsible for issuing this hypercall after changing
stage-2 permissions using the __pkvm_host_relax_guest_perms() or
__pkvm_host_wrprotect_guest() paths. This is left under the host's
responsibility for performance reasons.

Note however that the TLB maintenance for all *unmap* operations still
remains entirely under the hypervisor's responsibility for security
reasons -- an unmapped page may be donated to another entity, so a stale
TLB entry could be used to leak private data.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a3b07db2776c..002088c6e297 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
+	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 32c4627b5b5b..130f5f23bcb5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -389,6 +389,22 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
+static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	struct pkvm_hyp_vm *hyp_vm;
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	hyp_vm = get_np_pkvm_hyp_vm(handle);
+	if (!hyp_vm)
+		return;
+
+	__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
+	put_pkvm_hyp_vm(hyp_vm);
+}
+
 static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -573,6 +589,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
+	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
-- 
2.47.1.613.gc27f4b7a9f-goog

