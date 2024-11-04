Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476DE1BD03B
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727159; cv=none; b=GYWKOcNGP+z+tOzhnN1+huJuaEuL4s5+WlU2V/oHivk6YfA4/c9AcOGmy3ENzg6BMHN3e1Ay+1kM9RX76v7VOp2s8JVFpRQnd1mTqlGJms9mty9s+H03LQk69NxiSr7Tl86CJvd7+D/WzEySUDnbg0bsbtFInC6yI8V/U3JQSKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727159; c=relaxed/simple;
	bh=a+wZqkAlnXsib+Y/xL1c1/aKhBYEAk7cOc2pYkFKbPE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f92z5av30EjnPRRX71lyDXfRowhXRLKyiTCAKzl3KAbidXVZ0pCZEM9whA3IasTFngHMfgIpuXIYT5x9TSgeybXLBBxGlHeFY/BaS84ZXvh63QmcyEoJne+GUulwnq0TJikqPhaV6NsFg870/0tOLEo2kaidPBuAyi4bQsB0N04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mFjxU8ct; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mFjxU8ct"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e330f65bcd9so3386274276.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727157; x=1731331957; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZKgkOXED2gTnPKJGzc+iVeFIN1NowIl4QRyN7m6aZA=;
        b=mFjxU8ctTARjCGfbg+rKcDWs13GmI89QmkuI/aP020UZO9diI1VEP9zOa3HmWUwG+S
         bbs7BtTJNdoxWwBHU0/M7xnUOi0RbiNXIgB8gkCoB7FZcJIuP9gOofDXrg6vRdkPtdZG
         yu3ENfsnEACFvqBEQeWeiW7b6Br8zLtDxxQDh7bgANyDOoeZ0xT7U2kskEBP0NCSMQZ7
         DgvTHGmxAuXO3vAMKPDtSs3iSJo1TcXoRhatVkLbNU+AK43zVUVA3hfHjBIFZZovKadW
         ofdrY0rxSxqT78B5KUkS/bw4rgRl0ItiPxiRQM0dpVma/ETkAuwfT3WEDU6eGsFhe5BO
         VB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727157; x=1731331957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZKgkOXED2gTnPKJGzc+iVeFIN1NowIl4QRyN7m6aZA=;
        b=lPTJ3QnNtRbneJXGED3MzdTTHVjdJIMaKXwC0zQlI4mzVvtw7a/FZI0auIIcVt4p5g
         G/OfxwtcvUM5qvlSrMjKaYFqzQu0HND4MhtCfsY2kCmBiF2z2Ube6pVoSLWUb5lt4rp4
         bvvqO9awO9qE/erEEpAoLhH2sHCr1gJcXFYnBPzAwM+v4EH99WNlkZiIjsLxy7zJlMwX
         b4M2PBjhYr+Q9AX/izNLmH/PnLMpXxewaWAIV3qBhxzM/2Z80cC3kxImcO9SunoD+zl0
         YylIT88n23qvG49n7iaTdL8I0ygbbTABvQkkpy5GhZZkBQLOlMQIJ9WCdbXH3FTT5N19
         XGmg==
X-Forwarded-Encrypted: i=1; AJvYcCVHhvbUI0mavqjZiXkbZXFMFVtmtopFBCaiU9N7W0w3jxfm1ikodEpNXYFZ4ZwWgn9iaarFEag=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWsVpdi23fys/lNdxnmVmmCUN12ctsOti+yncCy8glRhMWm+sK
	FoxiDAKjRaZ5+dPmh+SahKOaxQm0hU8zS4i20hbjilzEaKHv94twVvNXYE2T6NSBHKRVshoGUQQ
	B0y53hg==
X-Google-Smtp-Source: AGHT+IEdndu9c8L5M9LMgNH5yUWxnOXjnairdpcGEJ+HkfnHM8iJ67/17rm/DHBApYmZlQ7LHV+rdMkopkCC
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:6902:1801:b0:e30:b89f:e3d with SMTP id
 3f1490d57ef6-e3328a15f4emr19583276.1.1730727157377; Mon, 04 Nov 2024 05:32:37
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:58 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-13-qperret@google.com>
Subject: [PATCH 12/18] KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a new hypercall allowing the host to relax the stage-2
permissions of mappings in a non-protected guest page-table. It will be
used later once we start allowing RO memslots and dirty logging.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 20 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 25 +++++++++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e67efee936b6..f528656e8359 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -67,6 +67,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index e528a42ed60e..db0dd83c2457 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -41,6 +41,7 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 68bbef69d99a..d3210719e247 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -265,6 +265,25 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static void handle___pkvm_host_relax_guest_perms(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, gfn, host_ctxt, 1);
+	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 2);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		goto out;
+
+	ret = __pkvm_host_relax_guest_perms(gfn, prot, hyp_vcpu);
+out:
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -483,6 +502,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
+	HANDLE_FUNC(__pkvm_host_relax_guest_perms),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index f7476a29e1a9..fc6050dcf904 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1491,3 +1491,28 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm)
 
 	return ret;
 }
+
+int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 phys;
+	int ret;
+
+	if ((prot & KVM_PGTABLE_PROT_RWX) != prot)
+		return -EPERM;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_unshare_guest(vm, &phys, ipa);
+	if (ret)
+		goto unlock;
+
+	ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.0.163.g1226f6d8fa-goog

