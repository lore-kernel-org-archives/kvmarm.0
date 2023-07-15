Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18917EBB
	for <kvmarm@lists.linux.dev>; Sat, 15 Jul 2023 00:54:19 +0000 (UTC)
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-5666dcb7d74so3319282eaf.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 17:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689382459; x=1689987259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E8/SKuTbF1S2hgzgftCz+xbv+GwRa24E0ShAGUklW+4=;
        b=hrja88/7wxXiKsBqU4+BG+pM3MGM1S9DOyuubBS6zRCvIJ5eqNbAcqAnTdgYLBUU+G
         Xw+Q5KoogRXe6+j6MLR2KwqS39EPOItOND2hac4t/iid35aWJyaibOjPEAQmdMwYmjfh
         VzbdHI6TI0GOlWQpr7ND4xoMQoOV3vp6+LinZ0mxaFOfj8s73O11srFhZJK0pIAlsFoL
         P4nRJGXix8N2JZo0MJURuNa3SeLrZLgRbyyEKe5e1sT6jjEyyH20skLSiG1kT2BH+lWW
         M2jwktjB/uvksSymt5eF0yyQ/JrIKi5z5nYd8WpKGE+ItYKnNyJygjYrNRNPHTh4T2bz
         A4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689382459; x=1689987259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8/SKuTbF1S2hgzgftCz+xbv+GwRa24E0ShAGUklW+4=;
        b=EFc4LYSsf3T049nju17ZMlO1V6hL0frXfBgGGIUUEvktOYHfDsqV0dxWvbdTpkk8+e
         yqOoJfcWagpCobAzTaHbUjJq05qTsWHioQqwPohGaXVUBFqJ+I1bbmHQTSdQ58oQRXM5
         iYGNYPUZ2tFyNStfoNZkKOur6HEJ6LVA7XzJYT+6xerFFs1OIPPCznxmpaNT+cay7KxV
         Z4V1k2j/RccLVyaNh726hUcbbWVSSyuT4xwPPRWtNKyNbSiHJKimN7ARJAvwqJi2FYer
         k7T4J16DwHsDculBHJrmlQmnZuqHGxUoSBQ+SbuuuypkQtuWW71SYVVih2RhLpFIcovO
         xzWg==
X-Gm-Message-State: ABy/qLYkACQ2grb2CB6Ni5hcQfkXR+2VjS/cFb7XM51wGiNO0GkyANrv
	EbDLM4uEkVSGr95YupAxetHgKfFCnAER
X-Google-Smtp-Source: APBJJlGuVOPdQOdSPn66tc6hZHiX5voXQ8Bd1Pq3KdWw9uZBWmzdkmlscTzl3Cyfs81jovCUQVWibJUVXGKq
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a4a:5213:0:b0:55e:38ef:109b with SMTP id
 d19-20020a4a5213000000b0055e38ef109bmr445620oob.1.1689382459192; Fri, 14 Jul
 2023 17:54:19 -0700 (PDT)
Date: Sat, 15 Jul 2023 00:54:02 +0000
In-Reply-To: <20230715005405.3689586-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.455.g037347b96a-goog
Message-ID: <20230715005405.3689586-9-rananta@google.com>
Subject: [PATCH v6 08/11] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, David Matlack <dmatlack@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/mmu.c              | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7281222f24ef..52d3ed918893 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1114,6 +1114,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0ac721fa27f1..387f2215fde7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -172,6 +172,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+				start_gfn << PAGE_SHIFT, pages << PAGE_SHIFT);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.41.0.455.g037347b96a-goog

