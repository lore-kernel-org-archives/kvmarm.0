Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27762D63E8
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572042; cv=none; b=eKOzkE/Ig5xGbLFEkcjL4/ic0x5IbhKgqFHRaKNKO8nivt7QT7tzhoAhgd4xzK1JR8BkLyh+bd6lxVYY+cgs++gtc46AMj84GUVpjyFtCR1sG9iSD4CI077jMuvYRrQ5l2sPgSlJdgO9gR6zWX4JYb+ibMpc4iKU6+bFsC13kB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572042; c=relaxed/simple;
	bh=IZ5AHKXw15eeD5dW7wpbeUhThV1vd/U26y5B6eznwi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejrDtcTZHqDAGJtspP7ASWevtEVRzeZQd8zjjNkoSLaxx79dwDKGr4QO1/OdD7J9iDEs49oT3WkoYlHLv7sg+u7ZTMT8Cn+RTMdM/ctSextTP0t7HvkN8L/lDA8Fg37M8VudnA+IzxGP2JRy0BdMt8B/HSAwQtNdftfJ+N6QbI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txEGEYMk; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txEGEYMk"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-606f507ede7so5684350a12.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572038; x=1753176838; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yc2PxbUB6sWoXqmBD+SX5wgz6y1jaRto2Doaa4ZyIEE=;
        b=txEGEYMkPmUF/lu3aoG+6qg/L54T92DxIFoBsS4RyaBG8VokVrcMylIEejPHqeF0Eo
         rxDbvbx8F3EFnnKk12cCxYFnp3I+ks6BbDGlHAQPYQu9PjHsJBiMxjsI5arL4kDAiRyv
         KTnxs9U11DjANW7YBmZmeD7gl7ukaWI+4yRbTBLs+Vyd9be5XJW9jQN075XqEBJN4HlJ
         Ptw3Gei00aZgozkdC2lPZYj5POYtW888pumx7/ByHe5IIWJwQJBFFrzQCWDNvIhPEGX6
         97QXgb1EVDryGSdkXj48RH+8uaCKQz5x34UmjJV+XjyKm5pxXgyrtfzBUmV5AvwyeKSp
         NslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572038; x=1753176838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yc2PxbUB6sWoXqmBD+SX5wgz6y1jaRto2Doaa4ZyIEE=;
        b=EBi1rfltAmW8MrKOj3fhiAFjiJ8o3bbRmz5H4mC1txRbB5GcRDrS0w7MtDCMi/8DhE
         O9t9SNVtgNEG2IaIS8RxKUHhG3lbj2PE5yjrorYNsZ7jDqmQ+Hdu84qBrCJgsyg8gCc+
         huhfN6PCNFIX4jiQOW9P1NTm+1g4bpjHE91gd27C450+eSKcdGKbAHAG6lFP6q5jD7pM
         FX0+lEzFon+wOiRuNbvsjq76ag4AZbhmirOeIJdXu1USABLZqysmbVRsTaYVkSCaN9Sm
         d6S7CMYmRxZJpOUgSF+LTnaqBqTuOsAKlmXEQV/nirF+qIKssjPkv5lY6Topr00q9sDT
         1MtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQOH3GQF21BhEdWql/VgCkt3K3oYAvN07qKcU6rSmZd2mIiBUgGVaqInVbrDzLWm4nUpRtIDY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+kuHxEqCH7LSjSAv4XW4o5Yl0oZegEyxT9oODU+lUl6c240Yq
	/a02+f4qjatmp+TzYjvdkhhbIJc6zdYu7j9xsxD7TWI9vFUBo1gyXEtfw52sqKyNKG1ZVTYRSW0
	nUg==
X-Google-Smtp-Source: AGHT+IEXYs7T9kwp4zt9Q6duZzuD37c0z/m16xiUI6ublpH8MZEPzSJPqggoJ+YdDeQOgE64Wo1Xc33Ecg==
X-Received: from edip15.prod.google.com ([2002:a50:cd8f:0:b0:60c:7ccc:867c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4308:b0:606:dee2:42df
 with SMTP id 4fb4d7f45d1cf-611e8490658mr14145606a12.17.1752572038209; Tue, 15
 Jul 2025 02:33:58 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:32 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-4-tabba@google.com>
Subject: [PATCH v14 03/21] KVM: Introduce kvm_arch_supports_gmem()
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

Introduce kvm_arch_supports_gmem() to explicitly indicate whether an
architecture supports guest_memfd.

Previously, kvm_arch_has_private_mem() was used to check for guest_memfd
support. However, this conflated guest_memfd with "private" memory,
implying that guest_memfd was exclusively for CoCo VMs or other private
memory use cases.

With the expansion of guest_memfd to support non-private memory, such as
shared host mappings, it is necessary to decouple these concepts. The
new kvm_arch_supports_gmem() function provides a clear way to check for
guest_memfd support.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++-
 include/linux/kvm_host.h        | 11 +++++++++++
 virt/kvm/kvm_main.c             |  4 ++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index acb25f935d84..bde811b2d303 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2277,8 +2277,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
 #else
 #define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_supports_gmem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
@@ -2331,7 +2333,7 @@ enum {
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
 # define KVM_MAX_NR_ADDRESS_SPACES	2
-/* SMM is currently unsupported for guests with private memory. */
+/* SMM is currently unsupported for guests with guest_memfd private memory. */
 # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 359baaae5e9f..ab1bde048034 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -729,6 +729,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Arch code must define kvm_arch_supports_gmem if support for guest_memfd is
+ * enabled.
+ */
+#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
+static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d5f0ec2d321f..162e2a69cc49 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (kvm_arch_supports_gmem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -4915,7 +4915,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return !kvm || kvm_arch_supports_gmem(kvm);
 #endif
 	default:
 		break;
-- 
2.50.0.727.gbf7dc18ff4-goog

