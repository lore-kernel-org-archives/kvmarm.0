Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F581BB45
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 23:13:36 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5897d05e878so12311927b3.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 16:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536416; x=1692141216;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=72O4JjoYZq3iLcv3bAZ3OmpFstwA2kMJRyaM4BuQEBE=;
        b=R5I5Z7dKsQM2VswHYUX2hskpPb2N83EoKFoKuLJn/BC4sXMaBnhcj99WCsAp5QKKyy
         7u+T5Ec3pR/25gv1e/zbEjRKzrqzDDJBAemw6R3xQC7KrPp7aJZJM4G22QpoAC0zp5kH
         UMXBmcZb9hsdnj+lbnSFw34hakifAJ7K53PQunN9SGCFq6Ui1dwSKqTlD9zEHfhXeHeP
         0bj76PocHyecHuyM+Ns81rvZC/L72J5BAdxXht2Ch/UnatoKkEOwofuDLlnsgpQl5qOl
         rYtHj2q1IH0XKliwZJi6cxMJX+B5xoJtpcJNKcE7br9I1vSodIwSHZA3qcZXR3rrOTTD
         QFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536416; x=1692141216;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=72O4JjoYZq3iLcv3bAZ3OmpFstwA2kMJRyaM4BuQEBE=;
        b=ELn1pZyneMMGmI8ib1QCvVrwlBDRY22letAu9rm7vzKT4zKLdItBlzqwdM3LwK8H2b
         1nLKixJM1XEBB05hg29joT8qJ7V1eLmG2oTu3A95RXP2tESOlD4iHuXW5SPcuGpvWhOI
         jkWxYmVZ3Wqu9m+BNgATbk485T9wxElpq72ix4INagNDVBgCUx+r3ZZ2l4+BL2sCFOZb
         nEyXbWB8l0VMzF1g3tn6SxyBz/CdmOwCbXwbih9VR8lmz9PRxuYghpSbF2+T/I27V5Xj
         jFBjSM7AkclGgWxVlCEMgib38V1F/dEyCUZ+gyuDhRkURBViLFH6pchJ1tP5BhjNgqgM
         y1ew==
X-Gm-Message-State: AOJu0Yy+K6Smma0n/Ew9DD//m9uS09NXDbstmS+QNEu18aGaov7Ko/Yq
	eekJlpOGt66TF0j6LjYn2ffBNadr/cL4
X-Google-Smtp-Source: AGHT+IE7fclKfZoTRFj3+JRtM/8w0lKPDLMergkPyAZ7GDrfovjgxJMs9LxY7VD7kflVGqJRYcLb7SZ/s4nQ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:b94:0:b0:d4e:e2ae:e0c8 with SMTP id
 142-20020a250b94000000b00d4ee2aee0c8mr21899ybl.1.1691536416062; Tue, 08 Aug
 2023 16:13:36 -0700 (PDT)
Date: Tue,  8 Aug 2023 23:13:17 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-2-rananta@google.com>
Subject: [PATCH v8 01/14] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Matlack <dmatlack@google.com>

Rename kvm_arch_flush_remote_tlb() and the associated macro
__KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
__KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.

Making the name plural matches kvm_flush_remote_tlbs() and makes it more
clear that this function can affect more than one remote TLB.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 arch/mips/kvm/mips.c             | 2 +-
 arch/x86/include/asm/kvm_host.h  | 4 ++--
 include/linux/kvm_host.h         | 4 ++--
 virt/kvm/kvm_main.c              | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_h=
ost.h
index 04cedf9f88115..9b0ad8f3bf327 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *v=
cpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
=20
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-int kvm_arch_flush_remote_tlb(struct kvm *kvm);
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
=20
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index aa5583a7b05be..4b7bc39a41736 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -981,7 +981,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kv=
m_memory_slot *memslot)
=20
 }
=20
-int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	kvm_mips_callbacks->prepare_flush_shadow(kvm);
 	return 1;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 28bd38303d704..a2d3cfc2eb75c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1794,8 +1794,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
=20
-#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	if (kvm_x86_ops.flush_remote_tlbs &&
 	    !static_call(kvm_x86_flush_remote_tlbs)(kvm))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9f..e3f968b38ae97 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1479,8 +1479,8 @@ static inline void kvm_arch_free_vm(struct kvm *kvm)
 }
 #endif
=20
-#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
-static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
+static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
 	return -ENOTSUPP;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfbaafbe3a009..70e5479797ac3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -361,7 +361,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
 	 * barrier here.
 	 */
-	if (!kvm_arch_flush_remote_tlb(kvm)
+	if (!kvm_arch_flush_remote_tlbs(kvm)
 	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.generic.remote_tlb_flush;
 }
--=20
2.41.0.640.ga95def55d0-goog

