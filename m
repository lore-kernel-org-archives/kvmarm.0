Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A2D2FCFCB
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769659; cv=none; b=YTqKs9X6Rz/YKA9CnLJCm0oM0NHN0Wg4YKrh5gMSWqdgWj7/Or9st2ILrrcy/83VEiJPmm1GjCxJ9ZoiXWG341ORpE3iIKQWKdD9Pu0CP+lOntafi/lyVmfH5PKzPQOJKQ4QcoCkzwBebQIFKZE0MCAKpsoyGw8gXi8iWmDizBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769659; c=relaxed/simple;
	bh=CZbQqGKfq7lnOE8Dq04mQVdronOZ1uU380z2iWzGtbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FVxcnndKWx0VhD79apd6o45XdB4xTrbXgDK9BL5n8h8MdmhHPHp1gncNd7Q9zVMN61oy8GOuSu+yaRTNLbOyOyqD6xr+Y/lGBnJo6ipnC/jmWDIqVmphY+jWUbWEMnmawUVwujzr2kemyZwxjwt2X75d3u80LGn03RIgC6U2qCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pUyxyAaG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pUyxyAaG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4560b81ff9eso6958365e9.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769655; x=1753374455; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JGm4OrF5AH9M0Efkqrqd3zCKs3Rhrec+30Q520+k5eI=;
        b=pUyxyAaGNY7P0e4YNqUNen5EuZh3s8xWTKOriTMypNDIO4bQhZMLmYQQ2XUK0BXo7K
         OTLZ4F8pEeWQhw3o4Mql3P6DRcCabe1rURscMraqRSeiYC/1u+BEof50olGqKsVJjUml
         xFWnCgWNHFt/dl7U+Gp4OfaXVPmyBLt+gpcKfMa3F0RY46V3UDe1NYX0J2PJM3gdQ26N
         CDvvEaKR0MgoJUw0IGwvjF/KBsPqnsVN/vko6EJbNXGSPhoXpDbpABBnO6Wx8G2F61PU
         AhYI2DtO4WWTP1aReixgf7wivWnml4wKkY1PQ/wxqMySW7eTxsd5av74dVy/cgnPekPK
         gGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769655; x=1753374455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JGm4OrF5AH9M0Efkqrqd3zCKs3Rhrec+30Q520+k5eI=;
        b=t2dJdGxSjyavSAjfy/9rYWlXkUQLTmHyLii0eWh8QBb1zV6tpKKQXuooxFkVgsHc+1
         J8F0NCXV1NtDmNLUTkveUsnbHAVQf/7CltrpoHRdb/fS2OW0A6npxihYv/Ub0bQUhLS2
         9n+xPbOuwwA6GV2c89mDfStBVb01dW/GiXo0vSotc32j1zhoccUU9AAatGycqooSfDh8
         Sr6SwIevatZEtLtKaxmh+hDLeRwPa1ttUgKZ3RUi2nJNNoUw5AQPm7f5yk3kl9bBI6i1
         KMXtjqB5PJM3pMxLoRp5B5+6mO8SgCPvxre4Y1IZLVDyzV1PzarFNQ1lATT3N6tfihr/
         NnFg==
X-Forwarded-Encrypted: i=1; AJvYcCWEzI15em+ebUn9zt2DKHEVifRQBCF+J6t1Xl99eoHEaZm7YR6e4WqDyn8ow6D/XC2taGW21So=@lists.linux.dev
X-Gm-Message-State: AOJu0YywYa3URXlA1wYhYWuUislx++todouUhbaqpOIgX8M6gQtajkvq
	buVDIQkmy+atvILIv7W3+RIbntHdLxhVt52griIgllJyyhdhvb+PcIWCpTosqHF81w4XSvULW27
	AXw==
X-Google-Smtp-Source: AGHT+IEysdP5DZqcnWuiBAUxwVt36pWakwMvarJj9IwwM8dKd2la2qqCW09A1R4Y5Id/zn0DFltlJZPS4w==
X-Received: from wmbek10.prod.google.com ([2002:a05:600c:3eca:b0:451:4d6b:5b7e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c16d:b0:442:dc75:5625
 with SMTP id 5b1f17b1804b1-456352d0b70mr31903115e9.5.1752769655271; Thu, 17
 Jul 2025 09:27:35 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:13 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-4-tabba@google.com>
Subject: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
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

