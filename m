Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1242A24F28
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:19:54 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id r9-20020a17090a2e8900b0021409b8020cso2513545pjd.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QZsBYUGDC2IkAwbx22iS+bX782/JjRlyYtWOGf9fm5w=;
        b=gOl3cNoBRYj8Qpc32NlIEZiSXsQpB/DCyQ/znrDYIZGa+s4IthUOkEHZQZ1ojKZDv7
         pTCluXhDLSbuLtIDsd06JUGzyqeVDBKsjduC6joRT5sGTNYRsVo9p/G6Hqiv2ugKa8LH
         rdr0QZPkDK278uG4dV/k1t11BIQxvRWGgZaRWsIg0DoysUSAp2Ijq63EEZdxc0KL4gix
         0HGUBH8kF/zweMHI/2v4mLjob8+u7zdHCmj600jDg7rYDwZddIyY/q/ZMJIgho4CGwiq
         Rf68OjR0Rg0ygAgFFNEea3lYykknrXRPiTB8JjAsW5m8iBtmAm27VPmRKJbUJVbPKnmY
         wuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZsBYUGDC2IkAwbx22iS+bX782/JjRlyYtWOGf9fm5w=;
        b=uMJY1iR6BcS/HUhpknHp0Z/6GCQi5zwmSpdz7DnqgFZTV+LK2GcloQB21y7cSJO4r1
         d19T5vwPK5cONbDAtefWqGsZqpZp0C+vTdkH0CVIeN110ajlNSISUbwYMfd4698fzClh
         rpCCmp0MFOxvMD7pkxmuEx/ADni7dVxizzrmC6nMfAVx0YPV3PwHHakH95yabDzmjriL
         LPUJE8MK4eyhvN9gHLVEPxfKQfQBo0cxZfQQbZtBCnVf1ENCBfI/a92LFS0reKKV/7RM
         PrLL7nlayR1oAFf1pW9o6ITAbcfvWRLWP/9UtcJf4mrfx7fcDsEuZ/B5zvvZAOmVs+fI
         VW0A==
X-Gm-Message-State: ACrzQf1QaENuntZ3t3YP84MeRY4ATffX2rB97mHaVZsb88hzW+akmmkj
	HRxXiQoKvE6a904j6L03TNQuCnNaF4E=
X-Google-Smtp-Source: AMsMyM4F5G3DDnuJC2f+gpo6muVhVlP37u9Rx2CD7FgkZCjySGE+h3yA4RelKa6dFXDwgnEtjORGLCa20Ec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:384a:b0:213:2907:a528 with SMTP id
 nl10-20020a17090b384a00b002132907a528mr27758885pjb.183.1667431193502; Wed, 02
 Nov 2022 16:19:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:18:50 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-24-seanjc@google.com>
Subject: [PATCH 23/44] KVM: RISC-V: Tag init functions and data with __init, __ro_after_init
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221102231850.7khnIXLi3k8xc-chHVS_1Zz0fJlilrvvHsPln9K80Sc@z>

Now that KVM setup is handled directly in riscv_kvm_init(), tag functions
and data that are used/set only during init with __init/__ro_after_init.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/include/asm/kvm_host.h |  6 +++---
 arch/riscv/kvm/mmu.c              | 12 ++++++------
 arch/riscv/kvm/vmid.c             |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 8c771fc4f5d2..778ff0f282b7 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -295,11 +295,11 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
-void kvm_riscv_gstage_mode_detect(void);
-unsigned long kvm_riscv_gstage_mode(void);
+void __init kvm_riscv_gstage_mode_detect(void);
+unsigned long __init kvm_riscv_gstage_mode(void);
 int kvm_riscv_gstage_gpa_bits(void);
 
-void kvm_riscv_gstage_vmid_detect(void);
+void __init kvm_riscv_gstage_vmid_detect(void);
 unsigned long kvm_riscv_gstage_vmid_bits(void);
 int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
 bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 3620ecac2fa1..f42a34c7879a 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -20,12 +20,12 @@
 #include <asm/pgtable.h>
 
 #ifdef CONFIG_64BIT
-static unsigned long gstage_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
-static unsigned long gstage_pgd_levels = 3;
+static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
+static unsigned long gstage_pgd_levels __ro_after_init = 3;
 #define gstage_index_bits	9
 #else
-static unsigned long gstage_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
-static unsigned long gstage_pgd_levels = 2;
+static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
+static unsigned long gstage_pgd_levels __ro_after_init = 2;
 #define gstage_index_bits	10
 #endif
 
@@ -760,7 +760,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
 		kvm_riscv_local_hfence_gvma_all();
 }
 
-void kvm_riscv_gstage_mode_detect(void)
+void __init kvm_riscv_gstage_mode_detect(void)
 {
 #ifdef CONFIG_64BIT
 	/* Try Sv57x4 G-stage mode */
@@ -784,7 +784,7 @@ void kvm_riscv_gstage_mode_detect(void)
 #endif
 }
 
-unsigned long kvm_riscv_gstage_mode(void)
+unsigned long __init kvm_riscv_gstage_mode(void)
 {
 	return gstage_mode >> HGATP_MODE_SHIFT;
 }
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 6cd93995fb65..5246da1c9167 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -17,10 +17,10 @@
 
 static unsigned long vmid_version = 1;
 static unsigned long vmid_next;
-static unsigned long vmid_bits;
+static unsigned long vmid_bits __ro_after_init;
 static DEFINE_SPINLOCK(vmid_lock);
 
-void kvm_riscv_gstage_vmid_detect(void)
+void __init kvm_riscv_gstage_vmid_detect(void)
 {
 	unsigned long old;
 
-- 
2.38.1.431.g37b22c650d-goog

