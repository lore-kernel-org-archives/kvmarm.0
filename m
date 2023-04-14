Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7FD63A6
	for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 17:29:29 +0000 (UTC)
Received: by mail-il1-f202.google.com with SMTP id d20-20020a056e020c1400b003261821bf26so4933180ile.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 10:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681493369; x=1684085369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xod2ygDVduTwUHImrHGaOn1Ey3T4FHeje26KGvtdzFY=;
        b=urihsx8BJ4/z847iQ0af0/ABhs7C6WBtcCWjGJXbhxr/VPQvARnb7XaJ7A5oFQiHCD
         90urhiaRyXF7oVdI+4/fu/OPC5OJvxewZGz9QxN5hZ5yTVEjUtFiVeYjgKwW9nNFK1ru
         ce1L+PFnnDRNFsRRRIrGtENwVQTm3GxN0xCbR3syOuv9KLkEd+6jW5XLxUGt1ZHmyXnR
         HgnKGTeToQwFaAXYXVQwBhn++Abwiz3alwNHfKA9Vz6CpdqXz9JFA+VXvh7qQ0Qk8Eho
         hnqoSXzs/4uE8yim0YCcb5e3OEyL4Tz/6RTOh3sL0WbaHGriWM3BXETHdZiXgWQWsmI6
         Kx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493369; x=1684085369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xod2ygDVduTwUHImrHGaOn1Ey3T4FHeje26KGvtdzFY=;
        b=HZr1djERiwCqjSEK+0XAShEXr+hh9ZAMrwdP8MuqMWjbZiSuvgtGVsKwxGcdZYHRin
         oN822EVE7LxOAt5Lx2BOABvgWKDta7+2p9XFIb1QIVczglQFXH6lIFT6IPRhmylw8qNC
         seMIbxLmS9GHxkCXwbFhJHeVA4j19mUqw2v7gHs8yB+kzCiXyxgUB989sjW1HaPky9CZ
         VmoYzm//ErvVSxvkAzYkbT9VqItGV8bVFQf0L4Gple4zpjJ/gXA1Q2RJkPQhiDhU79vN
         5ObYj9QnGbfes6N4cdrhE1it7CntW/x34dOPr5HGBbinu8qcJay9+b3QB3SkN92CpsKd
         4x9g==
X-Gm-Message-State: AAQBX9e5mmHWStq/Rl9Cf0xUrTp0bSu0rXyTcV9N6wD6XvCMSimKlcKM
	J/hhnuotmwwIEu4YiJBdLpGP5nxbBzbm
X-Google-Smtp-Source: AKy350aPSA8VnmqDZpOyrrIV/qNFr7vvNcijupLw4tbGJajccFhHKKFJcef90ZPOEeNPVI0c8hECYDUjbfor
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:b19d:0:b0:40f:787a:852f with SMTP id
 t29-20020a02b19d000000b0040f787a852fmr1494204jah.6.1681493369209; Fri, 14 Apr
 2023 10:29:29 -0700 (PDT)
Date: Fri, 14 Apr 2023 17:29:18 +0000
In-Reply-To: <20230414172922.812640-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230414172922.812640-4-rananta@google.com>
Subject: [PATCH v3 3/7] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
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
 arch/arm64/kvm/mmu.c              | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 17c215a2df7d7..075d3e6482e53 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1044,6 +1044,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
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
2.40.0.634.g4ca3ef3211-goog

