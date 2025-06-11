Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6D628C855
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648821; cv=none; b=VUun+f+ghmuWcGgutGvYoz3yuOXnBjS9V2315gG90K61ChFDarTg9MQzD7FHgpMa+5hPEDpzCLf36kRzTYXu0XVcOShviGjK4Rtm7daL3spxtvooBL6pfOp6933cPfjWDHBMgGX62pJagbKV4hYkCGKZ96IcfGvDb9n7bAlt3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648821; c=relaxed/simple;
	bh=faFCvBYSj9gBXBNoTy5EuNw2T4lUK6cJCWCJbMCsyCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RjGQ/8pndTdmqHjcrIxdA8dOGytYSWJPrYlqcHMJXoG2+qbd2pahfKK2J0MuJbNpIQsh87Jgw6hf5xjy7qbKtc6Sy6fXmr50o07sn1kgSeNIL5Flj4F92iQ//5GdwhXL9EbtPLK+RIYbJ4rdEct4ZlZSBRfbSkmkXVGcfq/RCWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V0wekGAm; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V0wekGAm"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450d9f96f61so44893025e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648818; x=1750253618; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fHcIggQKHNaNFRvYnQpfDqUVZ6zXXYhJE0EKjE2JRfM=;
        b=V0wekGAmMPUbR7hmf3TL0nmQdGc762jyZVl17BCdOA+Dtl97+PMtEYc/7kBJ3TpQJw
         eaE70vVXI7Tk3yEfHh8vbAV3vKVBcgAgbxWCu4wmFl8sbAyIKhAlr6475iH1kzL5ZNR5
         wK0nr+O2arcIPGhoe280NK3Mb2ECDvzixHvYy08d9QQ/zKUHe9OfHQkR5NhVGkvWkPH+
         FGP3WxSwF5BM8a4kCkEYgSN/fSVMwRDjj9IhP2JNuBfpsU5AOJRtyIWzfwdFLSYYR7UT
         UajZgmn0TZBp0JNgJIJo1rKEoDosU32Bsy7nnqtw4pDRp/kp4jZb/B2ztNqAmnZirGSf
         h4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648818; x=1750253618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHcIggQKHNaNFRvYnQpfDqUVZ6zXXYhJE0EKjE2JRfM=;
        b=sgmZ5ixx3ER3B8IBw52nrOcQI8boMOjH+ObFRyLlCiuG/czY8BqqDwMcMSmkTwEnUI
         4Ni1HMocazTWrLtfV0RRa6GM+jtMYxYMapsqDjjGZvBnrYxpVvSWnMJTyebOuBNXuPsV
         ldP51IGIStSoooPGI+0MaSMa2Xp4Zcc9HGGAIwRc8PNE9GweN3Bp8ztWR8iMcPUu4bb9
         ANs8cWO0P0qC+qAj+WxGEp5e/NkUog2yY+IH2w2zGg+vQJncIepw/22uNOKt9xgMxhu2
         dy76Z9/NUa9qc6livJISqeH3MYhXXjc/BGMnpqn8oag1vSnkcxnQz0YV6X1V3rqRyUkm
         n+RA==
X-Forwarded-Encrypted: i=1; AJvYcCXalDrQFrDfhsLXkdLXTNzOmRLD+TiTXaYofR+J4mIxeBeZpmDRL2flCi5TEX8Lix6G175L0Zs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrydXt67gdp++sD5lRdx0NHf7Dc8V0ncyKqah/UXQ5B4wzc5Ap
	cHSh1HddEYiZ9EbwmZRRjk7DP4lDQUz3eAfmsdZLzFMSrtiZrtrMfzh2qdZ/tZG8uNUcpNOImrr
	4Yg==
X-Google-Smtp-Source: AGHT+IEwaeObMhoAiffFZ/OlywAGjOG/+SlRjtCaGK4Sd746Ko0J37CRQTmNG+E33wWinMPOCq5CLsDQ2Q==
X-Received: from wmsr16.prod.google.com ([2002:a05:600c:8b10:b0:451:deba:e06f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c4b8:b0:450:b240:aaab
 with SMTP id 5b1f17b1804b1-4532487b00cmr28102425e9.8.1749648818124; Wed, 11
 Jun 2025 06:33:38 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:15 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-4-tabba@google.com>
Subject: [PATCH v12 03/18] KVM: Rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The function kvm_arch_has_private_mem() indicates whether an architecture
supports guest_memfd. Until now, this support implied the memory was
strictly private.

To decouple guest_memfd support from memory privacy, rename this
function to kvm_arch_supports_gmem().

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 include/linux/kvm_host.h        | 6 +++---
 virt/kvm/kvm_main.c             | 6 +++---
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e0bbf4c2202..3d69da6d2d9e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2270,9 +2270,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 
 #ifdef CONFIG_KVM_GMEM
-#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
 #else
-#define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_supports_gmem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
@@ -2325,8 +2325,8 @@ enum {
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
 # define KVM_MAX_NR_ADDRESS_SPACES	2
-/* SMM is currently unsupported for guests with private memory. */
-# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
+/* SMM is currently unsupported for guests with guest_memfd (esp private) memory. */
+# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 : 2)
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 #else
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..e7ecf089780a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4910,7 +4910,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	if (kvm_arch_has_private_mem(vcpu->kvm) &&
+	if (kvm_arch_supports_gmem(vcpu->kvm) &&
 	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
 		error_code |= PFERR_PRIVATE_ACCESS;
 
@@ -7707,7 +7707,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
 	 * a hugepage can be used for affected ranges.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
 		return false;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
@@ -7786,7 +7786,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	 * a range that has PRIVATE GFNs, and conversely converting a range to
 	 * SHARED may now allow hugepages.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
 		return false;
 
 	/*
@@ -7842,7 +7842,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 {
 	int level;
 
-	if (!kvm_arch_has_private_mem(kvm))
+	if (!kvm_arch_supports_gmem(kvm))
 		return;
 
 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7700efc06e35..a0e661aa3f8a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -719,11 +719,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 #endif
 
 /*
- * Arch code must define kvm_arch_has_private_mem if support for private memory
+ * Arch code must define kvm_arch_supports_gmem if support for guest_memfd
  * is enabled.
  */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
+static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 {
 	return false;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 898c3d5a7ba8..6efbea208fa6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (kvm_arch_supports_gmem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -2419,7 +2419,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
-	if (!kvm || kvm_arch_has_private_mem(kvm))
+	if (!kvm || kvm_arch_supports_gmem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 
 	return 0;
@@ -4912,7 +4912,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return !kvm || kvm_arch_supports_gmem(kvm);
 #endif
 	default:
 		break;
-- 
2.50.0.rc0.642.g800a2b2222-goog

