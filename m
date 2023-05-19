Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EF0385
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 00:52:39 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba83fed50e1so652497276.1
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 17:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457559; x=1687049559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eI3+o1vQveSU3bkuomrpolxp+t8dV7nu1enlALoGo84=;
        b=a993HPTO+g13j6obSzomXT8KISL/8mFSfYyDK/WG+ODvYVrzRo67FTVKRPNz4OtgR8
         wbVvJI1UMWLNfzwvZ6Pc+IJB58PSbJkfDiM7qjnlf7+dulbrrXb1G2a556mStetHAB6X
         JhHn1bNc4gU6kdv2mB7svIf9qBYfY7+waIVlwadN4raN8L/2tiFCRgVB+TPiKZLB7r/M
         5U85nJno9Reys1JZsaXHeJhYDz/wgCGwk4E2MFHocZEBRMlHKx4oBrY4LsUH0GALzyEz
         5Yv9sRc5Gbx9MggBYHqKoqG75yo3yYxMGrKKLnLWjFd6xpGajIigzjT6XfGU/JHAF/8O
         qoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457559; x=1687049559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eI3+o1vQveSU3bkuomrpolxp+t8dV7nu1enlALoGo84=;
        b=FmmiZ//E8lgEFIdgX65xkac0SSjFB5M58o66DvY1afFZgNTVUKF+W+6WNZYzS8A0IW
         tdVdIo121FsNUmtMKoWrt11BMvBzSTV4s2th4U+ifdb4wN+1RzqfydbezWIUyJbFatGz
         3u0MnfLEFr13HH2rFSf6nZD5XrRJTHQXiUlX6nl7VPR45eXNhS1G27cqwnPkv4HmA6En
         0Oxp1bd3Ixd2NDiHEZxzn/cQUvxIVgsOro37v6BTFS24c5kjrL+ptviGZMl2qvbRFcgl
         v8iUM4fn8oLrhZPWZSaRnkGqh7iWjGRm85AWzofKmbSRw0IWtgoC+1yhSS51of0AW4Un
         whbw==
X-Gm-Message-State: AC+VfDx2RBkcDp92GCPcvzqdWL1ZevIEqSV/Q9UnWze3MfxuXrwrLase
	vMqwG1y8HI5UZpxnbIiEz96ECQM87LYQ
X-Google-Smtp-Source: ACHHUZ7MGOicfXqOEIRYhYQir8c9VFNkG60dMuEYJ6FiAi22aFdneLwrpZOUgMMNGFimpKhr++I/T6Q/ojCK
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6902:1343:b0:ba8:4d1c:dd04 with SMTP
 id g3-20020a056902134300b00ba84d1cdd04mr94689ybu.1.1684457558794; Thu, 18 May
 2023 17:52:38 -0700 (PDT)
Date: Fri, 19 May 2023 00:52:28 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-4-rananta@google.com>
Subject: [PATCH v4 3/6] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Ricardo Koller <ricarkol@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_flush_remote_tlbs_range() for arm64
to invalidate the given range in the TLB.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/tlb.c     |  4 +---
 arch/arm64/kvm/mmu.c              | 11 +++++++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 81ab41b84f436..343fb530eea9c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d4ea549c4b5c4..d2c7c1bc6d441 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -150,10 +150,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 		return;
 	}
 
-	dsb(ishst);
-
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	__tlb_switch_to_guest(mmu, &cxt, false);
 
 	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d0a0d3dca9316..e3673b4c10292 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -92,6 +92,17 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	phys_addr_t start, end;
+
+	start = start_gfn << PAGE_SHIFT;
+	end = (start_gfn + pages) << PAGE_SHIFT;
+
+	kvm_call_hyp(__kvm_tlb_flush_vmid_range, &kvm->arch.mmu, start, end);
+	return 0;
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
-- 
2.40.1.698.g37aff9b760-goog

