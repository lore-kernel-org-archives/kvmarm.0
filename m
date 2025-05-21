Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8426F475
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 12:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831878; cv=none; b=Y4iV4C8hqv2Ec8lW8BeYo7lGHcUvr07ShifVdR/Pf1GMYmAzfPcxg40+DYsluLYprTnpC1nuqT9sfd9a6rIEqrCUKwOn/KuUNvN72X19G7gnDUdB3NG1BOvyQYGtH/oG8FYqud1cTAEIiR5cLwG6P0tSTpXHJYM1LU9pRb19QEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831878; c=relaxed/simple;
	bh=Q1Lc4SelnIqqZ8x5yzeOZdivf0g9ssVJJqMqyBh+gKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r4l3ni7xzrL8wrdaq8yvCUYpQfOu2drsJn8qEyXNiwFMi5xF8Ozhr/9JGWjV8JCz5wKhbSoXkzundW5yMWJJcm95ZL5G4ummlpLkXTKz6gbfHM9U3Ts6raH9xksluG7CtJE91buATPiq4PhLXwyLBlsaawd3kIfGPJao7ATr4hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M6/P9+I8; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M6/P9+I8"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-39ee4b91d1cso3683867f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747831875; x=1748436675; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h7Oq5jwZK0pb08xH59h8gdjNoJEBEnOv69ZeonvXBfg=;
        b=M6/P9+I8Y/JUAqvVRQDLm5MDBaaVNDV6P9jVjwehTYaxp7n7eU/fCcrWHK9MkL5qbg
         gzAMdSl4To3tCRIgAOj8EmXRlTnje5geKAz4Qr9Or94zBZxDtrNCUkaio5HzCCmnkaDk
         IyeWCQHt06vJzOIf4XwMiLqMS9rNYpnF8Ldi1fvg2/Fl+KuyU14UX3ZjfHjRNZBfzGLC
         GQtSCoxo/bt8ntc1QPjlnCInghT9PF0nMTSXX2luEar9vfD/vFs3Vp07FcuDnJsQ4Jas
         x1yHtYriEemIrdPiaryUgTxPt6ZaNHSx7U5Mpx0ak28zH4ELLvs430uVFQo9DE6BGcpw
         fNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831875; x=1748436675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7Oq5jwZK0pb08xH59h8gdjNoJEBEnOv69ZeonvXBfg=;
        b=uce66sI3FeuSssM7vQucGwO6NsTUq7b+1VccToYBfeEShxeFVDEqOAVOV3ha32t1SQ
         F3wfMwUSwlrutIcZhTUKEjRmoBsM0NvfonR00yys4mdstaOV2Yew4bHe0MdOSdN/AXGd
         MJ49rf4wrVgI0EjNmGSRfPBx8QtOLGP/QBewR7ZSMbj3OrUKm6FKwlGDImzov+bnKtBx
         y5CUBNU5mhN+aoFI+Oc8moQ/ZL6NrUUKdWQrbB11wR7POWnCmbgxjIQOg7Mc8VPdklmG
         OMO3DWiT6PpnAtq2vv372IwHw7DMIGN8kdszUihM0XMv5wKWvoJYXJBmuA6R4Sueq9b8
         uLIg==
X-Forwarded-Encrypted: i=1; AJvYcCUdv3EUYNfh048oJwJopajoD2e6SKoHD0wYQXtUEvZZTitpMr3BlRrSaPtTiMRgbFt0hGN9rsA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgoDbTBkEElEtLuaNn7t+Q3pZi7XSqPSyhQS5bTRMi6RhMxPEB
	S8rfSuqFrvAdkrzmNW/jmYg9dIdNZ5GhKaANqebSIp5xpd86OdYFiiwMHi/tnSie7juzUPruOQp
	mczkEDb3JXgCIB5vEFDUKjQ==
X-Google-Smtp-Source: AGHT+IG2h60jELokLEU/h5uhC0DSsHsKCsOBofWotQOOeFuSTUQx51WyDXB/rj32MRC8kvwd+rTI6s1Fodm9S1qj
X-Received: from wmbhj14.prod.google.com ([2002:a05:600c:528e:b0:442:f9ef:e460])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2582:b0:3a3:6915:33a6 with SMTP id ffacd0b85a97d-3a369153515mr12239550f8f.23.1747831874642;
 Wed, 21 May 2025 05:51:14 -0700 (PDT)
Date: Wed, 21 May 2025 13:48:30 +0100
In-Reply-To: <20250521124834.1070650-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250521124834.1070650-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250521124834.1070650-7-vdonnefort@google.com>
Subject: [PATCH v6 06/10] KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for np-guest. Add a
nr_pages argument to the __pkvm_host_test_clear_young_guest hypercall.
This range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is
512 on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 64d4f3bf6269..5f9d56754e39 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -43,8 +43,8 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
-int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index fa7e2421d359..8e8848de4d47 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -331,7 +331,8 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(bool, mkold, host_ctxt, 3);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
+	DECLARE_REG(bool, mkold, host_ctxt, 4);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -342,7 +343,7 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
+	ret = __pkvm_host_test_clear_young_guest(gfn, nr_pages, mkold, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) = ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 569adeaa0869..e08c735206e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1111,17 +1111,21 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 	return ret;
 }
 
-int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm)
+int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm)
 {
-	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 size, ipa = hyp_pfn_to_phys(gfn);
 	int ret;
 
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
+	assert_host_shared_guest(vm, ipa, size);
 	guest_lock_component(vm);
-	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
+	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, size, mkold);
 	guest_unlock_component(vm);
 
 	return ret;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index daab4a00790a..057874bbe3e1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -420,7 +420,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   mkold);
+					   1, mkold);
 
 	return young;
 }
-- 
2.49.0.1112.g889b7c5bd8-goog

