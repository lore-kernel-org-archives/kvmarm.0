Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1B03F0ABF
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290846; cv=none; b=OrLBQO1goLqdjtBDkGAx/rt/wl8W1z1lds3w3IvIVDspCzKyL2tfQfX/V74JgRLBEEOW8DxuIR7I6nP4I8WukTmDECy0n2oe0XFrgCH06pz6g2xY06QPds7lb8u3m6C8DxUBv0PnqgQUF8EES7KyZ7LFJwXNtO6bPOqfktzHBIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290846; c=relaxed/simple;
	bh=xoVJPH8PVxaIxrxMRA1qZYaU0t3FIGMWDLzI9Ky8gII=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UA+4gyPMW7JG/MSUU3pwinjrqotHVRsvBHTaVzrnYUgsqQct06UBbUULO7tI17LqtuzgIkWp9oUhslcO2IGBED+xc5p9zsO7mOxs8Nq7u9CKCnqusXwzdZ2Nb+NjimoSnr6GGobAS36JbKYm2aC1CEIJeoJJ3/myt7qJ58OaJBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=og79jKbW; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="og79jKbW"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44a71109b94so3751814f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290844; x=1779895644; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2dP/J1DbhtLVImQPHdjjhVild5BKkbbGQM9cLmZs/I0=;
        b=og79jKbWZ24peRoXlsLvX6ZJhZSuDfa8C1QYGEiRMoILl5XGNnXuqO93mnehihjhBx
         /JALYILkpfdS4morItednNZpy9EuuCC2lvWv8cgyeZaLrL8Hhr2WQEIfVFe/ndaKqKS+
         QeGMt72/kLGzys1C+K9TUFku87Ob00tCD/rGtkhv4uhkE9WueAZ7D+t+MsdQfo9oMjEE
         4qQaJOaKAqT/JFi1XsC/8CMvbnfsyrm3wGiZVCbbUtetKhOQ3WwjfHvShBy4VvUc8TUM
         j0ItjFYG/VlCw9qJvdpdngRrOOaUa6i7+ErK9NALhxnz15QrCx0sISYsgIOxQptrrX8J
         wcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290844; x=1779895644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2dP/J1DbhtLVImQPHdjjhVild5BKkbbGQM9cLmZs/I0=;
        b=nQjW8h9HSjO8SlhHJsm0TpRp4yTDDzPULYRjVjtLbM6ETD2DUDRRt4Py2JZziqGgq3
         36CnVNEnZAlCSXE2/kgD3+B2+upGKUl2YCdClBafaN1pS3XD8R7YYonuV1dqdcQ5rv+K
         ECkrEnRIEmHr6gfd90Fvzdatdg8/u42qZyPkdz0gRSk7GUurWeK56iQBr8TYlwfsQBVb
         Bag8uvghBERZGKehqjebtD87SQ6/Q2fvznYhXGJ+rRglbcawmVFn6xrOcpCPa10hZFd9
         tFAdC4NRqW+xn9npDZAs/OgnCjD2WxBOO0xOYknD+NiNKiIy8Rvtwn4WWbDAq9xF6/vA
         sKkQ==
X-Forwarded-Encrypted: i=1; AFNElJ9O/cEgZwt3a4asA6p/KoHFvqBk90HcJI33MZR9X7ouCb7699JpGmaKrXVUt+n+Kex2AV4zDFI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNPIYI1/GPkhTRpdm0Y6CsSVn169x9uiIyWFcx8cbONJcyHE6o
	joHXJ0XdXKbWXoMbDew/yVt49Ik9zc6TJmqcHVBXlmW7fj1ssxLn8lDur2l+q96GvHe/0JiTwPq
	Cd+XmMUwccOWYzYBdilAsBw==
X-Received: from wmbdt12.prod.google.com ([2002:a05:600c:630c:b0:488:b96e:9939])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b26:b0:490:261d:7dfe with SMTP id 5b1f17b1804b1-490261d7e2bmr80484455e9.6.1779290843643;
 Wed, 20 May 2026 08:27:23 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:42 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-10-vdonnefort@google.com>
Subject: [PATCH 09/17] KVM: arm64: Add reclaim interface for the pKVM heap alloc
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a host interface to reclaim donated memory from the pKVM heap
allocator back to the host.

It specifically provides two helpers that will make it easier to
create a shrinker for pKVM:

  pkvm_hyp_reclaimable()
  pkvm_hyp_relaim()

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 681b7bf8ac08..b427ef790b15 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -115,6 +115,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index bf43235e62d3..ca3b5fc5f28f 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -21,6 +21,9 @@ enum pkvm_topup_id {
 	PKVM_TOPUP_HYP_ALLOC,
 };
 
+unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target);
+unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id);
+
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 38ce834ca840..20be0343abd4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -638,6 +638,42 @@ static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
 }
 
+static void handle___pkvm_hyp_reclaim(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
+	DECLARE_REG(unsigned long, target, host_ctxt, 2);
+	struct kvm_hyp_memcache host_mc = {};
+	int ret = 0;
+
+	switch (id) {
+	case PKVM_TOPUP_HYP_ALLOC:
+		hyp_alloc_reclaim(&host_mc, target);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	cpu_reg(host_ctxt, 1) = ret;
+	cpu_reg(host_ctxt, 2) = host_mc.head;
+	cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
+}
+
+static void handle___pkvm_hyp_reclaimable(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
+	unsigned long reclaimable = 0;
+
+	switch (id) {
+	case PKVM_TOPUP_HYP_ALLOC:
+		reclaimable = hyp_alloc_reclaimable();
+		break;
+	default:
+		reclaimable = 0;
+	}
+
+	cpu_reg(host_ctxt, 1) = reclaimable;
+}
+
 static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
@@ -769,6 +805,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 	HANDLE_FUNC(__pkvm_hyp_topup),
+	HANDLE_FUNC(__pkvm_hyp_reclaim),
+	HANDLE_FUNC(__pkvm_hyp_reclaimable),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index f5288a350069..f29134a1cc73 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -111,6 +111,30 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
 	return res.a1;
 }
 
+unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
+{
+	struct kvm_hyp_memcache mc;
+	struct arm_smccc_res res;
+	unsigned long reclaimed;
+
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__pkvm_hyp_reclaim), id, target, &res);
+	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
+	if (WARN_ON_ONCE(res.a1))
+		return 0;
+
+	init_hyp_memcache(&mc);
+	mc.head = res.a2;
+	mc.nr_pages = reclaimed = res.a3;
+	free_hyp_memcache(&mc);
+
+	return reclaimed;
+}
+
+unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
+{
+	return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
+}
+
 static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
 {
 	int ret = -EINVAL;
-- 
2.54.0.631.ge1b05301d1-goog

