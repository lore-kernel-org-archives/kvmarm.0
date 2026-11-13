Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594399;
	b=V4EW6khhMLAF6vnjsaEYkkGJEyFdGPHD0kDAScwplDjaK5SZ9ypHPLvkDKMtXo+fkvka
	 gE34071ET6dmpqQdGiv3ox8oykE9eg+R4KY0tCAuHYiSneaL14umI05klnQYHemP3dZUL
	 c2FXSMsjmoeSp41lQyjmMgg7vpAYDR04jc4OG8lRmemuoAZ6/VSYE4pP9CwiBtxralEXR
	 AtNxAG5yAeBEiBajC8egzlTPbr7mJwixHJS8KacrE2ZNyUSAarVvwlbLOJxxlpAMwxy0o
	 1452PDy0x1UssLVyfdymZajIOZKDaeKwxbDtALiJTflw8JYuA4Z6EyHNXqg6u9SkTFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594399;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=nsZl3tFZmRcUaiRHX00B61/eCfNM8JCwY3bqxS7ggUE=;
	b=08GlrCfFNQm43NS1kNTNd8RYwqHAr1byMhjuIfzVVuUDlu61jxO+fx4JMocTKuWy5fwK
	 1R5LdaTPx343IDRkwLeYXJbAXpNgiikEBfVWMrfIZhqJa7JX7q761XTY0upyOvD3LYize
	 mwwJ4EMs1efqiVLd1H94LQTD/tiIxI8RWmkxE+EqlJ3usR6C9A1oQAzhc1/v7HKUBMlMr
	 FZpYRU0GCjBuASdqO9Vd2+l0Mp4CALfZAJxA0v9cRUFKm7lpV47dPaXMp8Rw3ZWF6nwOX
	 wt4wddoG8iU+sEthQUnhzGSSW4fgMW+5jMle/zlHePmINgt5p6+FNt79Z8JzLX8AfrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=duVHnfjj;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB62606C147;
	Fri, 13 Nov 2026 18:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EB62606C147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=duVHnfjj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nsZl3tFZmRcUaiRHX00B61/eCfNM8JCwY3bqxS7ggUE=; b=duVHnfjjfs7oZIGcTSBEDN7BNU
	+cYQZ68uDPNzEHtoy0wTiqM12shQl3WiudyVcXLMZ5JfrLLc/zcuwzr1DSGCcMz5EYFJCQB/W0QR5
	feZ+OM4FK9lA1tFv4a7xkrtJcyGngKC6uF8pkuNN1ru+ELeg0U+f69g5faSG1/9yUiftmZ2MRn0MP
	1QJ4iZLPmTpEjGjOjeswUs7vsZ9WG5g2SqN6tymcJiyS1/rZGnng23j1AIMCL8nNITcujDAKFdTaL
	bxTtvvd/LyjSdqkmtXUKrLYTHHqU0v1oYx0TxelJmv7ug3Ys96UW0Lc9+/TEtHD1LoqvOw4+P6USi
	wGdBArpw==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyU-0000000BeOX-16Ec;
	Fri, 13 Nov 2026 18:26:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LXr-1c4N;
	Fri, 13 Nov 2026 18:26:07 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com,
	Mushahid Hussain <hmushi@amazon.co.uk>,
	Sriram Nambakam <snambakam@linux.microsoft.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC PATCH 01/13] KVM: x86: Let userspace opt in to multiple planes with KVM_CAP_PLANES
Date: Fri, 13 Nov 2026 11:25:55 -0700
Message-ID: <20261113182607.82813-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261113182607.82813-1-dwmw2@infradead.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20261113182607.82813-1-dwmw2@infradead.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

A VMM implementing a software privilege model such as Hyper-V VSM
needs more than one plane, but kvm_arch_max_planes() returns the
vendor ceiling, which is 1 everywhere except SEV-SNP (where VMPLs are
guest-architectural), so KVM_CREATE_PLANE rejects every id above zero.

Make KVM_CAP_PLANES a VM enable capability taking the number of planes
userspace is going to manage, up to KVM_MAX_USER_PLANES (4), which the
system fd now reports. It must be set before any vCPU or extra plane
exists, so nothing is sized against the old limit, and cannot be changed
once set. It also needs a split irqchip, which kvm_arch_max_planes()
already requires before it reports more than one plane, so enabling it
without one fails instead of silently granting a single plane, and
KVM_CREATE_IRQCHIP is refused afterwards. Non-default VM types are
rejected: SEV-SNP keeps deriving its count from the supported VMPLs,
and protected-state VM types need their own audit first. So is more
than one plane without TDP: with shadow paging every plane would
write-track the guest page tables, and the per-gfn write-track count
is only 16 bits wide. The same count is why the opt-in stops at four
planes even with TDP: nested guests still have write-tracked shadow
pages, each plane can add its own for a gfn, and four planes is the
most that keeps the count below 2^16. KVM_MAX_PLANES stays 16, the
bound for plane ids. A VM that does not enable the capability keeps
reporting a single plane.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst  | 36 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 55 +++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h        | 12 +++++++
 virt/kvm/kvm_main.c             | 11 ++++---
 5 files changed, 108 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9aa09d8a39dc..25ce35d5361a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6834,6 +6834,12 @@ See also: :ref:`KVM_SET_MEMORY_ATTRIBUTES`.
 
 Creates a new *plane*, i.e. a separate privilege level for the virtual machine.
 
+The range of valid plane ids is [0, N) where N is the value returned by
+KVM_CHECK_EXTENSION(KVM_CAP_PLANES) on the VM file descriptor.  Plane 0 is
+the VM itself; for VM types where the plane count is not guest-architectural,
+ids above 0 only become valid after userspace enables KVM_CAP_PLANES with
+the number of planes it is going to manage (see :ref:`KVM_CAP_PLANES`).
+
 Each plane has a numeric id that is used when communicating with KVM.  While
 KVM is currently agnostic to whether low ids are more or less privileged, it is
 expected that this will not always be the case in the future.  For example KVM
@@ -9234,6 +9240,36 @@ enabled, cmma can't be enabled anymore and pfmfi and the storage key
 interpretation are disabled. If cmma has already been enabled or the
 hpage_2g module parameter is not set to 1, -EINVAL is returned.
 
+.. _KVM_CAP_PLANES:
+
+7.48 KVM_CAP_PLANES
+-------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] contains the number of planes to make available
+
+Opts the VM in to using multiple planes, raising the limit on plane ids
+that KVM_CREATE_PLANE accepts to args[0], which must be between 1 and the
+value KVM_CHECK_EXTENSION(KVM_CAP_PLANES) returns on the system fd.  That
+ceiling is currently 4: on x86 every plane can add its own shadow pages for
+a gfn, and the per-gfn write-tracking count is only 16 bits wide.
+
+Planes other than plane 0 only exist when userspace manages them, so by
+default a VM reports and accepts a single plane.  VM types whose plane
+count is guest-architectural (such as SEV-SNP, where it reflects the
+supported VMPLs) report that count without this capability, and enabling
+it on them fails with -EINVAL.  Multiple planes also require two-dimensional
+paging: without TDP, enabling more than one plane fails with -EINVAL.
+
+Planes require a split irqchip.  Enable KVM_CAP_SPLIT_IRQCHIP first;
+otherwise enabling this capability fails with -EINVAL.  Once it is
+enabled, KVM_CREATE_IRQCHIP fails as well.
+
+This capability must be enabled before any vCPU or extra plane has been
+created, and the chosen count cannot be changed afterwards; otherwise
+-EEXIST is returned.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a4912735ad3d..d4628ab99197 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1193,6 +1193,7 @@ struct kvm_arch {
 	bool has_protected_eoi;
 	bool has_protected_pmu;
 	bool pre_fault_allowed;
+	unsigned int user_max_planes;
 	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
 	struct kvm_possible_nx_huge_pages possible_nx_huge_pages[KVM_NR_MMU_TYPES];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 29beb5791c15..79ea075eceec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -320,11 +320,29 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_default_max_planes);
 
 unsigned kvm_arch_max_planes(struct kvm *kvm)
 {
+	unsigned int vendor_planes;
+
 	/* For now, planes are only supported with irqchip=split */
 	if (!irqchip_split(kvm))
 		return 1;
 
-	return kvm_x86_call(max_planes)(kvm);
+	vendor_planes = kvm_x86_call(max_planes)(kvm);
+
+	/*
+	 * When the plane count is guest-architectural (SEV-SNP VMPLs),
+	 * the vendor module owns it.  Otherwise planes are a software
+	 * construct and only exist when userspace has opted in to the
+	 * number of planes it is going to manage, via KVM_CAP_PLANES.
+	 */
+	if (vendor_planes > 1)
+		return vendor_planes;
+
+	/*
+	 * Lockless readers (KVM_CHECK_EXTENSION) race the KVM_ENABLE_CAP
+	 * store; the value is set once, so a torn-free read is all that
+	 * is needed.
+	 */
+	return READ_ONCE(kvm->arch.user_max_planes) ? : 1;
 }
 
 struct kvm_plane *x86_alloc_plane(void)
@@ -4146,6 +4164,38 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	}
+	case KVM_CAP_PLANES: {
+		mutex_lock(&kvm->lock);
+		r = -EINVAL;
+		if (cap->args[0] < 1 || cap->args[0] > KVM_MAX_USER_PLANES)
+			goto planes_unlock;
+		/* Planes are only supported with a split irqchip. */
+		if (!irqchip_split(kvm))
+			goto planes_unlock;
+		/*
+		 * Only ordinary VMs for now.  SEV-SNP VMs get their plane
+		 * count from the architectural VMPL support, and VM types
+		 * with protected state need per-plane audits first.
+		 */
+		if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
+			goto planes_unlock;
+		/*
+		 * Every plane builds its own MMU roots.  With shadow paging
+		 * each one would also write-track the guest page tables, and
+		 * the per-gfn write-track count is only 16 bits wide.
+		 */
+		if (cap->args[0] > 1 && !tdp_enabled)
+			goto planes_unlock;
+		r = -EEXIST;
+		if (kvm->created_vcpus || kvm->has_planes ||
+		    kvm->arch.user_max_planes)
+			goto planes_unlock;
+		WRITE_ONCE(kvm->arch.user_max_planes, cap->args[0]);
+		r = 0;
+planes_unlock:
+		mutex_unlock(&kvm->lock);
+		break;
+	}
 	case KVM_CAP_X2APIC_API:
 		r = -EINVAL;
 		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
@@ -4594,7 +4644,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			goto create_irqchip_unlock;
 
 		r = -EINVAL;
-		if (kvm->created_vcpus || kvm->has_planes)
+		if (kvm->created_vcpus || kvm->has_planes ||
+		    kvm->arch.user_max_planes)
 			goto create_irqchip_unlock;
 
 		r = kvm_pic_init(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6922e3063ad8..562489ab444d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1195,6 +1195,18 @@ void kvm_unlock_all_vcpus(struct kvm *kvm);
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
+/*
+ * The most planes userspace may enable with KVM_ENABLE_CAP(KVM_CAP_PLANES).
+ * KVM_MAX_PLANES (16, the Hyper-V VTL limit) stays the bound for plane ids
+ * and per-plane arrays.  The opt-in is lower because on x86 each plane can
+ * shadow a gfn with its own upper-level shadow pages: the per-gfn count of
+ * those is a bit less than 2^14 per plane (see union kvm_mmu_page_role),
+ * and the per-gfn write-track count is 16 bits wide, so four planes is the
+ * most that keeps it from overflowing.  The architecture defines 4 SEV-SNP
+ * VMPLs, so 4 is also the most planes any x86 VM can have.
+ */
+#define KVM_MAX_USER_PLANES	4
+
 unsigned kvm_arch_max_planes(struct kvm *kvm);
 struct kvm_plane *kvm_alloc_plane(void);
 void kvm_free_plane(struct kvm_plane *plane);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 62d33f24dd7f..75ceab2d4838 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5438,10 +5438,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		if (kvm)
 			return kvm_arch_max_planes(kvm);
 		/*
-		 * The system fd reports the ceiling a VM may be given; a VM
-		 * fd reports what the VM actually has.
+		 * The system fd reports the ceiling a VM may opt in to via
+		 * KVM_ENABLE_CAP(KVM_CAP_PLANES); a VM fd reports what the
+		 * VM actually has.
 		 */
-		return KVM_MAX_PLANES;
+		return KVM_MAX_USER_PLANES;
 	default:
 		break;
 	}
@@ -5656,8 +5657,8 @@ static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
 	guard(mutex)(&kvm->lock);
 
 	/*
-	 * Check the limit under kvm->lock, which KVM_CAP_SPLIT_IRQCHIP (and
-	 * later the KVM_CAP_PLANES opt-in) take when they raise the limit.
+	 * Check the limit under kvm->lock, which KVM_CAP_SPLIT_IRQCHIP and
+	 * the KVM_CAP_PLANES opt-in take when they raise the limit.
 	 */
 	if (id >= kvm_arch_max_planes(kvm) ||
 	    WARN_ON_ONCE(id >= KVM_MAX_PLANES))
-- 
2.50.1

