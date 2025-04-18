Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793F2214A9B
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744996580; cv=none; b=aE1YkKfnXphHuGLRAbsEjk4es+R4kgiaS3OFX9IpTT/PX8tqcBtMKTQ7mSu9FVsucsHkw+Hzs39pJ3xnGoE4y4n287a7JNpjDaeTDXZhTonhQsk83AER3t84Un2rudlfF1gSJvG/Gn5TNFsfkfDUU1aT8FkSo78zGBJ4PZ5O/uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744996580; c=relaxed/simple;
	bh=yvX4/0VvcBz/REbiKuc8IYjAOGSq/fCAEfgqHjMuwNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rPC4npC9lJlVJXUWLXvq7QoVY1ChmlgLSSIZytd6qvW9rnF0VQIYjqKXbAhrmatxGiwMwRd4RpycqJ9+gz6BHjcFPetUu/8zF/Lj2JpjQqYXrw47kCBlKezEwY453Td2LKhFx+6Uv4oEN49cVxeuWJmdAEPNXx7+nvFiOOgkwA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f194U2Cx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f194U2Cx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744996576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sDbt2DYYkNyWT5oGemZdan3esNskCyLssS6aV6nsjxA=;
	b=f194U2Cxb7g/z5QNJyC6uSE+QDdk9Q9/d2SB29NjlM7TQhp218YY3RXj6QxrC3lg3LLvQ5
	RlNyrleqbvRFhZgBGNomS7D6S2h0fh0JuqVjAls75rwN37PbTBe3mOl/t1sFXO9hseIrwM
	MM9np2HnXkhqPv4cXfIDSpoDmcFn7BY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-nEOZX5jSMYG0rXM3YFpAlQ-1; Fri,
 18 Apr 2025 13:16:12 -0400
X-MC-Unique: nEOZX5jSMYG0rXM3YFpAlQ-1
X-Mimecast-MFC-AGG-ID: nEOZX5jSMYG0rXM3YFpAlQ_1744996571
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E8CB19560AA;
	Fri, 18 Apr 2025 17:16:11 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 049BD1800965;
	Fri, 18 Apr 2025 17:16:09 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] KVM: arm64, x86: make kvm_arch_has_irq_bypass() inline
Date: Fri, 18 Apr 2025 13:16:09 -0400
Message-ID: <20250418171609.231588-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

kvm_arch_has_irq_bypass() is a small function and even though it does
not appear in any *really* hot paths, it's also not entirely rare.
Make it inline---it also works out nicely in preparation for using it in
kvm-intel.ko and kvm-amd.ko, since the function is not currently exported.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h   | 5 +++++
 arch/arm64/kvm/arm.c                | 5 -----
 arch/powerpc/include/asm/kvm_host.h | 2 ++
 arch/x86/include/asm/kvm_host.h     | 6 ++++++
 arch/x86/kvm/x86.c                  | 5 -----
 include/linux/kvm_host.h            | 1 -
 6 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e98cfe7855a6..08ba91e6fb03 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1588,4 +1588,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+static inline bool kvm_arch_has_irq_bypass(void)
+{
+	return true;
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68fec8c95fee..19ca57def629 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2743,11 +2743,6 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
 	return irqchip_in_kernel(kvm);
 }
 
-bool kvm_arch_has_irq_bypass(void)
-{
-	return true;
-}
-
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 2d139c807577..6f761b77b813 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -907,4 +907,6 @@ static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
+bool kvm_arch_has_irq_bypass(void);
+
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bdae454a959..7bc174a1f1cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -35,6 +35,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
 #include <asm/asm.h>
+#include <asm/irq_remapping.h>
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/reboot.h>
@@ -2423,4 +2424,9 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+static inline bool kvm_arch_has_irq_bypass(void)
+{
+	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3712dde0bf9d..c1fdd527044c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13556,11 +13556,6 @@ bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
 
-bool kvm_arch_has_irq_bypass(void)
-{
-	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
-}
-
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 291d49b9bf05..82f044e4b3f5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2383,7 +2383,6 @@ struct kvm_vcpu *kvm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
-bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
-- 
2.43.5

