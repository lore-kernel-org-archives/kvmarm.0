Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE0D20E016
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371917; cv=none; b=pK6voq/+3KqJ4AXOm9MJQJA/pqIgRtvMjuijjDeXEJl1pE+lHfpo+huFspp2tTqasD0yTT75WXi4u5meSnFOdjd39AwXdXobtXs8hnBVTZnE9DlV/LsaBOs/+itchBpnv2fiWCLs6mn/pgm4qoF8JRpkox2qrEnrQU4CQj3LuQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371917; c=relaxed/simple;
	bh=OuhtjcErD0FcNX24WgQpNP6nBjfTyxTNub7mKvq3CIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iDeAAPzJ0wGB4AfQkv64I+gz24bTQowlD3BM9O03eWz33ACSNvbNlgXDrFmj1Hs5AG++xyCPu+hQHKuUK/8b8mboeoySiErnXYn0wl99Uur3lMPH5wbbP9z13EFcjnSa4/WrRK34KbovP4wBveQrGwB5z9fjfkUCJ0PfyyZdhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O+HwiPX9; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O+HwiPX9"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa69e84128aso377605466b.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371913; x=1734976713; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gDq9DwaPgsqNr2tHpW+bdhvyfIZgJqiuY6uN4axqGiQ=;
        b=O+HwiPX93Qdi9TEBkATCh3awV966UIhPqlh10aZZwGhEb4o7XqoPouRVHt9j+KHtE4
         C/pOaPz+qxlhQRwuyq7qxBeUKX9evvsp7iw3YHGLZlaByQa/AaN2NXLg8YIeZEnZirJY
         rpL5YsCc26Ov1/47TyZZezZaYkEMFQd8GaW5zqQYEb/jb8IEXZD3rwfGcEsJcdQ67ZOd
         yKaLHFGnE7+kPSatvicUBtovm4yPV3HX1O+YeD8BOUyqi7uucN711jO9S04xbcZdYBK5
         nPF5IZeHPX7kj64dg6NypfR5/eTq4gQVP7+JerQeiEEkyrwxYycSyk8RTwnROqGfMIxN
         1J+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371913; x=1734976713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gDq9DwaPgsqNr2tHpW+bdhvyfIZgJqiuY6uN4axqGiQ=;
        b=nyBjm7nK2zmGvMT1DhiCWvtznOUpZ6aQvZ3BLqUHVC5sdX/SBoCz/vTF7BOnCpJIjw
         OqQMIyYK59PPHmrjxN0jFxo+qCygzz/UUsmO3DJ0/R/Ah+XrFfGWB1Iu/AIlnYETLKJC
         /JTX9qC/NHhOYA87VAGphIpkH21GDb2D2kIVg20W8wIC3SstPbs7SUeqzKX6WG8WlXNL
         dkzjB3pEoWBC9PVLFmzcJg+yuofN9sC0fsOYW8cW6wBx9tj13HKPTenmo8h1Vyw6vzBi
         EkkXVDLB9eKODFbi8HXxsT1FZ0mVzGjIcjAin7pfkmN9FAtcZNkXCLB7t33tQYoOR2tT
         yGGw==
X-Forwarded-Encrypted: i=1; AJvYcCV61TnhJ8BZkOq6F4bhnMY44HGevbkGCvG+hhlQ98vJjs+LLrNQLZZ+jrQ+XPFZbG/WYtd+jUk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi9TIvtswakOj6LZ+9hIyFY60XXyyiT+JTXb5huyllxL76tlc5
	hH9bpp5DW/Vl03DC7ASrmUxlQPl1IGMqbQPVZErkAhUtgwHEjH7vbUFk04Y9t/lFbWf6Xs0aJhn
	wKaaHwQ==
X-Google-Smtp-Source: AGHT+IHI3UoYT3X+iYsCFbInDPhwRbeEU1+XXddDdVe8vSqsWTG70vyDHz/YcjLxXIwMarrVkYcdz5XXC6so
X-Received: from edaq23.prod.google.com ([2002:a05:6402:2497:b0:5d1:229d:1ee5])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:311a:b0:aab:70d3:af43
 with SMTP id a640c23a62f3a-aab779aae4cmr1377079866b.27.1734371912986; Mon, 16
 Dec 2024 09:58:32 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:58 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-14-qperret@google.com>
Subject: [PATCH v3 13/18] KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a new hypercall to remove the write permission from a
non-protected guest stage-2 mapping. This will be used for e.g. enabling
dirty logging.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 21 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 +++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 66ee8542dcc9..8663a588cf34 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -68,6 +68,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index a308dcd3b5b8..fc9fdd5b0a52 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -42,6 +42,7 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
+int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 287e4ee93ef2..98d317735107 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -283,6 +283,26 @@ static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ct
 	cpu_reg(host_ctxt, 1) = ret;
 }
 
+static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	struct pkvm_hyp_vm *hyp_vm;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	hyp_vm = get_np_pkvm_hyp_vm(handle);
+	if (!hyp_vm)
+		goto out;
+
+	ret = __pkvm_host_wrprotect_guest(gfn, hyp_vm);
+	put_pkvm_hyp_vm(hyp_vm);
+out:
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -495,6 +515,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
+	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index aa8e0408aebb..94e4251b5077 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1511,3 +1511,22 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 
 	return ret;
 }
+
+int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+{
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_shared_guest(vm, &phys, ipa);
+	if (!ret)
+		ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, PAGE_SIZE);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.1.613.gc27f4b7a9f-goog

