Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD0370AE2
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250198; cv=none; b=nKbHE7aZWTDDcNriJ4jQ1LwJbEla4/gLh1GMXTIBI75TKLcn16thLmlO85p9eGEvXCxPvFR4Bzs9TNR4DdynsTZplok0zhLf6ziJuGvRw5gM+z8aGzsF9yvR7KKEYfOowhgEWbbNycwgvpoLYtqBzlPYUtB4y/P3aUiTiXEpIBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250198; c=relaxed/simple;
	bh=A0xGjc8uUkIR1aNWLsp090YY0ObBLmm/+xhrG7yM1cY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j6f86Fr8w4Hs1xtzhUGyJlynlETasE7LjtqajTv/i4jTmOMVIPDdSBIULNER9sY+roIjRdy24MvMJaJQFPBv7m6rSswgX9SryR+lpmkMnZfLY0g45A4oesqwVB8AYDhxk69XljAB5br/k/Pihk9CmgyYrRt7T5+38DKX/+vZbEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CUMtEjpp; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CUMtEjpp"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a60a4f1ae2so858519a12.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250195; x=1788854995; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6DCOhBJDlEMaibcEAIvX0Fz7RikvCVl0uaVPevsNKhY=;
        b=CUMtEjppdF4lLef5i6IQX2T+aHQO8AhLriAt1wYAxMHLckwRCuvkLIWEZEuHjFkRng
         aM9nBZcrISSMTSii41iz3PcVfjhawhy78n1nX6gLLXfER3+ShpFsH1a9PzpghlexwUzy
         MVtAaas7T8b+Nc0c9oQqOT0TO/XNSgL2A3WU2dGK5qIrFByGn3KE3nYP1KI9PM7gYK4j
         8hvNt4JJzXRoYYPLRTKvuChmGq4hffP0KYTUafcYIYIz86shjMKfrb6mATrFHYyrEQgE
         8U2N+qewDZvi8JTj70R+kwe2IBi7lU6bO9oz7RjLU/8H24fIXXkr4r1FQdlFIE3AgGXJ
         MeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250195; x=1788854995;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6DCOhBJDlEMaibcEAIvX0Fz7RikvCVl0uaVPevsNKhY=;
        b=XGSGY5QadzgmPEI0kvr/FtOp/5C5vG5xx2ru4Xyf4j90xoohr7uIUYsJ6qeN8jUvQT
         e2eRHuoqT7kk85iAmrohQcGFwDR+DUM09ao5EAHr2XOENLh+nbGr4miY+c9fooyLrzQE
         k3L3StgWkcjPnOblhUZGb1XI2iEKXRgzWst46vGcK4Vlk9oh8ll7dfWLmI6s/RDbd8hb
         XetrC49GRxG8OfFfBxi1aYNhmB4iwVniZWuKJqhuBwWjOEBXJW8pm5MMIyAFt68sB3WE
         PemNeWzHt12ATB0Wrq1IC1UkpbWG5PqMv9qRloAfx4zKTpYnEqRgfheUn/5vFZLkez+4
         fNhw==
X-Forwarded-Encrypted: i=1; AKwUvBy0P5tL3/tdK7WMAFVp0d6zhRQ6dvrAdPQnZmh/Y/TqgVUPtXhOQAyShSfV1BrdXLw3yiVnH44=@lists.linux.dev
X-Gm-Message-State: AFuF++lJ08w7DRAbxcvoBO0OM6fj3P/cUZ3aNdM7+YRgDdfcM68rfk9x
	Wm4qs54CA86WtrHfEORHt5CNKaR70sis687v4I4UvLGQvaqE/Ha0HFE8WPlpEvTmjxmg8o0sQZe
	rEMNAulDw+lDn3n6u0vGcIA==
X-Received: from edqr22.prod.google.com ([2002:aa7:d596:0:b0:6a5:ed14:166b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4412:b0:6a3:f47c:969 with SMTP id 4fb4d7f45d1cf-6a60d3071a3mr19384977a12.3.1788250194778;
 Tue, 01 Sep 2026 01:09:54 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:28 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-6-vdonnefort@google.com>
Subject: [PATCH v5 05/18] KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Although currently limited to guest stage-2 page-table allocations,
struct kvm_hyp_memcache is a useful primitive for passing a list of
discontiguous pages between host and hypervisor.

Introduce init_hyp_memcache() to initialise a generic hyp memcache, and
init_hyp_stage2_memcache() for stage-2 specific memcaches. The generic
initialiser will be used to top up the upcoming pKVM heap allocator.

Note that the generic kvm_hyp_memcache does not account for the
allocated memory. This is expected: donations to the heap allocator are
shared and recycled, they cannot be accounted for a specific VM.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7..3ab41330c94f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -91,9 +91,22 @@ struct kvm_hyp_memcache {
 	struct pkvm_mapping *mapping; /* only used from EL1 */
 
 #define	HYP_MEMCACHE_ACCOUNT_STAGE2	BIT(1)
+#define	HYP_MEMCACHE_ACCOUNT_KMEMCG	BIT(2)
 	unsigned long flags;
 };
 
+static inline void init_hyp_memcache(struct kvm_hyp_memcache *mc)
+{
+	memset(mc, 0, sizeof(*mc));
+	mc->mapping = ZERO_SIZE_PTR; /* Prevent allocation, solely useful for stage2 memcache */
+}
+
+static inline void init_hyp_stage2_memcache(struct kvm_hyp_memcache *mc)
+{
+	memset(mc, 0, sizeof(*mc));
+	mc->flags = HYP_MEMCACHE_ACCOUNT_STAGE2 | HYP_MEMCACHE_ACCOUNT_KMEMCG;
+}
+
 static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
 				     phys_addr_t *p,
 				     phys_addr_t (*to_pa)(void *virt))
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..3163502cc7d2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1160,8 +1160,10 @@ static void *hyp_mc_alloc_fn(void *mc)
 {
 	struct kvm_hyp_memcache *memcache = mc;
 	void *addr;
+	gfp_t gfp;
 
-	addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	gfp = memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG ? GFP_KERNEL_ACCOUNT : GFP_KERNEL;
+	addr = (void *)__get_free_page(gfp);
 	if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
 		kvm_account_pgtable_pages(addr, 1);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec12..e5200731a45b 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -111,7 +111,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	void *hyp_vcpu;
 	int ret;
 
-	vcpu->arch.pkvm_memcache.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
 
 	hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
 	if (!hyp_vcpu)
@@ -172,7 +172,7 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 		goto free_vm;
 
 	kvm->arch.pkvm.is_created = true;
-	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
 	return 0;
-- 
2.55.0.897.gb25b4bd76c-goog

