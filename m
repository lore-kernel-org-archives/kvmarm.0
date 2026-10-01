Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655D651C324
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864958; cv=none; b=hNk7J36+zhO1IH9XZcUeNURt41ofVbhujyquNLiNjlzb/oRzIsmQ1DNh17v1gwfJD4q39ZuTsr8QNvd2mENmBE+UHmb8LtODIl0CfFGPT/XhGsp5oOpGReJuMqlYywYaHljZjpLHDq+OuPlaJCApz7969r1HsL7/Wd1KESS5DYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864958; c=relaxed/simple;
	bh=/xdbnp78RS4Y/eDKj2X06SRu8SdQjHCPIQMZQy61yWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kkxEsHYHS0zd2oN6ItbytPLCZuB347+u6mMIJ9ROeQlVOfEp1tOLYh7K2ZsUPkzNLviv6Seo7eYQEsjV9k8CUVD1MX42PBUCvGtzBEWmKelwYj43mm8snGiAhi85ZdBO2yXAWxtZedaZL1oI1WevaPR4UM6aBRBZ9aMwjiW2Hc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iFHLLtfB; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iFHLLtfB"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a01eb045feso10659425e9.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864947; x=1791469747; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4T99T3TB8dvRshTDEDVSJZNJ9yGL6DvbnmzYOdgUiRk=;
        b=iFHLLtfBmvFx+tzPJvYl4zTmfCp/1gspmSg3gmTwQNaNB9NUWA+p7F1nxKCfbJ7I8x
         IYqVCo6zsTqsBBtQf7E9kbYvLcoJrsAYWFl5WaTSfrpTE1q1x0b6hUPXcPHsc++wpVse
         MPu/Ka/PVgolXfehwRKSy47jXxa2s/g8D6V0ipgcB3Gil4z1Z/7hGMlNpO+foSFs1eJA
         tbgtq7p32W7YOZjpV1CnEemJuaP6Js6gj52w6oVvTMG0jrnVZFRcpb1s4lsPtOy9bQX6
         yPj5m62H4fjR4J1ezGAgugImSUeybCj6pdmMVg9h/i93eVHXUcH+rPvrosEfhn9TpS/N
         X2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864947; x=1791469747;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4T99T3TB8dvRshTDEDVSJZNJ9yGL6DvbnmzYOdgUiRk=;
        b=Gfr+czDn7v71ZtRiXAEw2iv66laQeRAQkXwoSO4Wh6nvZC0J2zexh6fv7mEss8Qikx
         RJjU5PzL+IEgQDRQKy+l6qulhjT/SJE7hDw5w72vkc+deKrvFbI50n3PpiIEO2eA5E41
         znhxhjD7OtcgRvB03YzqK8jsfKy+Q7B8dRLJ/AMHhAUdRmpYvSlYVYyysEEfV6bO1Fr4
         S0cNNql73gtUTltQfm5253uwn2zycOTYMIWAFs+ETQ0vPgQL+IMnTDxK2rKNbngPYuTK
         iL+NWQ54CPArMfHP6Z6oL2ZCMo7tiC7tU4D3TL0sYkQvrGixYUPC0aACC9cUyxqe1cns
         aOxA==
X-Forwarded-Encrypted: i=1; AKwUvBzKXPXkcGo+fJvK9V6mwE28OJoNCDyizR24HxizKLvy2OwNwSQJMYX514ZfPYFhZFs6LvrQ324=@lists.linux.dev
X-Gm-Message-State: AFuF++nOY9TJNuKngCagqLHiwUH7sZveYcEXnUInCa8E9+um1Qod6dAn
	qgFBLeJjqjn3Uqr9enJXAfZOHX6JuDVtHiyMNJWKXdDx10oZWNeYGbdvcU0dlB2YL7dvbS95O0U
	2qSWVL2y72ckRr69ZvwSERQ==
X-Received: from wmer17.prod.google.com ([2002:a05:600c:4351:b0:4a0:1efb:4825])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6405:20b0:4a0:1b14:d00c with SMTP id 5b1f17b1804b1-4a01b14d05dmr62965735e9.3.1790864946825;
 Thu, 01 Oct 2026 07:29:06 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:39 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-9-vdonnefort@google.com>
Subject: [PATCH v6 08/18] KVM: arm64: Add reclaim interface for the pKVM heap alloc
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a host interface to reclaim donated memory from the pKVM heap
allocator back to the host.

It specifically provides two helpers that will make it easier to
create a shrinker for pKVM:

  pkvm_hyp_reclaimable()
  pkvm_hyp_relaim()

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hcall.h |  4 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 34 +++++++++++++++++++++++
 arch/arm64/kvm/pkvm.c              | 44 ++++++++++++++++++++++++++++++
 4 files changed, 84 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index de59e89318fa..fc3c52b03154 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -90,6 +90,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 6d6f12400e94..bce6eb8b20e0 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -199,6 +199,10 @@ DECLARE_KVM_HOST_HCALL(void, __vgic_v5_restore_vmcr_apr,
 	struct vgic_v5_cpu_if __kern *, cpu_if)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_hyp_topup,
 	enum pkvm_topup_id, id, phys_addr_t, head, unsigned long, nr_pages)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_hyp_reclaim,
+	enum pkvm_topup_id, id, unsigned long, target)
+DECLARE_KVM_HOST_HCALL(ulong, __pkvm_hyp_reclaimable,
+	enum pkvm_topup_id, id)
 
 /* Hypercalls that are available only when pKVM has finalised. */
 DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2b89eb274482..fdc39f064718 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -824,6 +824,38 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_hyp_topup,
 	return ret;
 }
 
+DEFINE_KVM_HOST_HCALL(int, __pkvm_hyp_reclaim,
+	enum pkvm_topup_id, id, unsigned long, target)
+{
+	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
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
+	cpu_reg(host_ctxt, 2) = host_mc.head;
+	cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
+
+	return ret;
+}
+
+DEFINE_KVM_HOST_HCALL(ulong, __pkvm_hyp_reclaimable,
+	enum pkvm_topup_id, id)
+{
+	switch (id) {
+	case PKVM_TOPUP_HYP_ALLOC:
+		return hyp_alloc_reclaimable();
+	default:
+		return 0;
+	}
+}
+
 DEFINE_KVM_HOST_HCALL(int, __tracing_load,
 	void __kern *, desc_hva, size_t, desc_size)
 {
@@ -919,6 +951,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
 	HANDLE_FUNC(__pkvm_hyp_topup),
+	HANDLE_FUNC(__pkvm_hyp_reclaim),
+	HANDLE_FUNC(__pkvm_hyp_reclaimable),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 9cd23978481c..fec819a9dc78 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -115,6 +115,50 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
 	return ret;
 }
 
+static unsigned long __pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
+{
+	struct kvm_hyp_memcache mc;
+	struct arm_smccc_res res;
+	unsigned long reclaimed;
+
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__pkvm_hyp_reclaim), id, target, &res);
+	if (WARN_ON_ONCE(res.a0 != SMCCC_RET_SUCCESS) || WARN_ON_ONCE(res.a1))
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
+static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
+{
+	unsigned long reclaimed = 0;
+
+	while (reclaimed < target) {
+		/* Arbitrary limit to avoid blocking in EL2 for too long */
+		unsigned long r = __pkvm_hyp_reclaim(id, min(target - reclaimed, 16));
+
+		if (!r)
+			break;
+
+		reclaimed += r;
+		if (reclaimed >= target)
+			break;
+
+		cond_resched();
+	}
+
+	return reclaimed;
+}
+
+static __maybe_unused unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
+{
+	return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
+}
+
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

