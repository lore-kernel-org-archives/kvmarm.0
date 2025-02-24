Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B5C211A24
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441360; cv=none; b=gGtkmORC8+a1ozyREY+IMROLvkvmmoiRMIHI0/e3MOTnUOEqhByRJIXBRINJZJbceuY/l7x1A98wiHl2egPQvBK0wM5vnUP7RLPeMTv1VS3gv0HrAwL90aWb9JI2j/I4Zl2AN8NWleeTWT7Q/8QRRYThWuZRAJe6N/Ozlm8Or3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441360; c=relaxed/simple;
	bh=FzPHzxKck26ULHcvqQmiQmgEbS2iBAXavvGHTfk/ScE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cZUUlHUaLr8EgOU5C63Wvvxw3e00a4MpTmwJUrUNSMZMSmw86Wj9plbGCfY5ytfeJah6/ZL5Ml+WWpsjpYbUGG+ABrX7pOl5aAjSoop3OUrOa5eY900p2qYh8wHnOY0PJdYb0B9sjxSfEioSVfgVIWoL8/MEpqNVUxzuw+ZyUQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RTyRs+Oc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RTyRs+Oc"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso16612147a91.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 15:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441357; x=1741046157; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N18ZDDRfnjFxKJiD7qnA09wciuUkX/DOLJoxqyHk2n8=;
        b=RTyRs+Oc/xx0akHbjUFIxW9vXET1pCdqW0y2oRQZ9x3WY2921Ae8rmZNOXTr4dhvhj
         NsUdyn6AP8z+rvMcqptn8UrKKLSezSIVq35kiw0yXIA62E70WCimbA3FNvMMU3nBYajn
         klNZu5s6mAYmZlXw2Sud1jigSDTuxil8VHrSYbvCMjlfpn9fijijeetmi1Ri2DZY3hT+
         WGzMvWP5TLAKhEUcON1Mu2C3JsxL7tfgafsdQoZHIXjb4ONfpHEYBp9ROTQ1JdbRdOBA
         27jIF7iBDXB3iKz8gMgjVH62EbwEtxaHvVUgz/Gr1HE9p/Bf2glu9dbIGmrwGUJ2jdgw
         i7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441357; x=1741046157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N18ZDDRfnjFxKJiD7qnA09wciuUkX/DOLJoxqyHk2n8=;
        b=e0AzH/D+AOhZ8mtQ65+LZKhuRMo3DNyAoM43iM8idIOrsfqX9LvsPm+VgbA9qTrTJ7
         53xAoj++c8AUmTBIlRc2ZCsQkog3LGH8sLnW5bcHeHffeLIdXT2RFX15bVKlkzKfBcqT
         g/RhUHIm8ihDFs2Cn2SlNWyqqYotHHPMbzBGP9amr73zHcWvgn/zdVdS4BCxRgeidRYi
         rcDDMeBIqbuPS8rHqu8+2avOOpINDq6t0CwVwIuJB4PnH0CQc/nQX9+y7hur0JMk2Ee6
         OABkRQRZLDXPTxml0WBuXcpwRrCohB3NJ8oUDXV+k4PKal9CZVPpoDjthRynx16kZzvs
         HuyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUstP7LeZWoJEzQWgFAlwM/lLK1srqy3OE+1gkNw9/3s20akE1XVXwAwqD3lGqq6jsNamKIj5A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIrpQygg1MTNjyU1/AnUKyr+2rCuv99KIMlqX6Ckvd149ZwKLr
	/tZ6savEdOdO51LjsaXpcKoN0GOAsExfrLzxn4duSiS4uOCvzbaYAmQUqy0ia43YbLUAdLHuw8V
	bBg==
X-Google-Smtp-Source: AGHT+IFBRvTh2AoRMsZzInrrN+gn6icsuEOKduQCozj1AYhvRpYSpNqeaxExZSkYlXTQzmgl2LLloh+gErw=
X-Received: from pjbpb10.prod.google.com ([2002:a17:90b:3c0a:b0:2fc:11a0:c54d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ec6:b0:2ee:70cb:a500
 with SMTP id 98e67ed59e1d1-2fce77a00c5mr23270511a91.1.1740441357604; Mon, 24
 Feb 2025 15:55:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:42 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-8-seanjc@google.com>
Subject: [PATCH 7/7] KVM: Drop kvm_arch_sync_events() now that all
 implementations are nops
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Remove kvm_arch_sync_events() now that x86 no longer uses it (no other
arch has ever used it).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h     | 2 --
 arch/loongarch/include/asm/kvm_host.h | 1 -
 arch/mips/include/asm/kvm_host.h      | 1 -
 arch/powerpc/include/asm/kvm_host.h   | 1 -
 arch/riscv/include/asm/kvm_host.h     | 2 --
 arch/s390/include/asm/kvm_host.h      | 1 -
 arch/x86/kvm/x86.c                    | 5 -----
 include/linux/kvm_host.h              | 1 -
 virt/kvm/kvm_main.c                   | 1 -
 9 files changed, 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..40897bd2b4a3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1346,8 +1346,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 	return cpus_have_final_cap(ARM64_SPECTRE_V3A);
 }
 
-static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-
 void kvm_init_host_debug_data(void);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 590982cd986e..ab5b7001e2ff 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -320,7 +320,6 @@ static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
 
 /* Misc */
 static inline void kvm_arch_hardware_unsetup(void) {}
-static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index f7222eb594ea..c14b10821817 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -886,7 +886,6 @@ extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
 extern int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 			     struct kvm_mips_interrupt *irq);
 
-static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 6e1108f8fce6..2d139c807577 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -902,7 +902,6 @@ struct kvm_vcpu_arch {
 #define __KVM_HAVE_ARCH_WQP
 #define __KVM_HAVE_CREATE_DEVICE
 
-static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index cc33e35cd628..0e9c2fab6378 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -301,8 +301,6 @@ static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
 	return IS_ENABLED(CONFIG_GUEST_PERF_EVENTS) && !!vcpu;
 }
 
-static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-
 #define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
 
 void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9a367866cab0..424f899d8163 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1056,7 +1056,6 @@ bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu);
 extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
-static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea445e6579f1..454fd6b8f3db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12770,11 +12770,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-void kvm_arch_sync_events(struct kvm *kvm)
-{
-
-}
-
 /**
  * __x86_set_memory_region: Setup KVM internal memory slot
  *
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c28a6aa1f2ed..5438a1b446a6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1747,7 +1747,6 @@ static inline void kvm_unregister_perf_callbacks(void) {}
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
-void kvm_arch_sync_events(struct kvm *kvm);
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 991e8111e88b..55153494ac70 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1271,7 +1271,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_destroy_pm_notifier(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
-	kvm_arch_sync_events(kvm);
 	mutex_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	mutex_unlock(&kvm_lock);
-- 
2.48.1.658.g4767266eb4-goog

