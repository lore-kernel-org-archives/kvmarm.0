Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D314EA93E
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 17:36:15 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id f8-20020a170902ce8800b00190c6518e21so1745130plg.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 09:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3hAJU+LzPVf19y36Q9+8Vrf4nbiTPQzZyGa0NnmG2s0=;
        b=LncMkMbkcAIyGue9Im85wp+qazsdtyG2pD4++o+icy0IPMJV8lI9tX9+PjLo1kQmni
         Wo+qI4Pu/FDbulB075D7Bj5uVWpVwH11jl25Huz5SLadFPRwmt96/0kohdgBj2mHfVzm
         6vWEUZ5pdB/9lln0z/nXIlf+Ecwo1NSULAcY5mtcAXKtSLUjsKYxOpKOfvtpVDpwT+73
         zOyEADFpuPCZGJcbFi84wZfVws4tYTcDGmGejoC0EpWJU3GE4xj88gsVLKDwHZ+ih/U9
         mQJa2/FrlPiG/iljAp6TojZYVq7sxazNWHXO0HAp4VvA9tA2c11CBVsQchii7nqhnOA5
         kToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hAJU+LzPVf19y36Q9+8Vrf4nbiTPQzZyGa0NnmG2s0=;
        b=u8qPDolzqGtw/SUbz+B0W+JjYMQOJjZjz51JksfwjUTHuVa6/Ff446oxzruTtOQpo0
         tRi+K5V12+eGanQWOM/rm/vA055yxKxckIDeDJVytg4fK6Y7B0OLzIYz03HeUqGaKlNR
         Avt+vE4GwCsC9m7B0zuZtlyaAXYSue6qUAh/ql5Cz4on7XiB9Fi3CHxJaoezSBpR60tl
         3abysmkIpfH+kFL/X82oK14iKrLbYisUTQ7P3AVC0EIbGSI8nnjbrji+Hv+ZdeOwyuNg
         NiaMvehsQuRmYDYRacAZ+lB9snnEESmu6e6q11b0aS+/Mqd8Vh5dqRFbiymzfcRZJgZg
         dfpA==
X-Gm-Message-State: AFqh2kpedrPc8FcQ9q4CGhRyTSzhE1DEq5n156K4TA2ep8Em7bl0nKqW
	ZPieKg0lMbAC1oc9STkkmKaAoxmVw+XoHw==
X-Google-Smtp-Source: AMrXdXu2MvoeQqs801JuzBUZypqlRJrB9v2DrqnXy2L/ej84ncugCrPjhb3Yc6QUXlCd6vDUHuGhT1biHplZRQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a63:2f04:0:b0:479:1797:4893 with SMTP id
 v4-20020a632f04000000b0047917974893mr1012500pgv.86.1674149775261; Thu, 19 Jan
 2023 09:36:15 -0800 (PST)
Date: Thu, 19 Jan 2023 09:35:55 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-4-dmatlack@google.com>
Subject: [PATCH 3/7] KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()
 together
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Collapse kvm_flush_remote_tlbs_with_range() and
kvm_flush_remote_tlbs_with_address() into a single function. This
eliminates some lines of code and a useless NULL check on the range
struct.

Opportunistically switch from ENOTSUPP to EOPNOTSUPP to make checkpatch
happy.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aeb240b339f5..7740ca52dab4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -246,27 +246,20 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range)
-{
-	int ret = -ENOTSUPP;
-
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
-		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
-
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
-}
-
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 		u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
+	int ret = -EOPNOTSUPP;
 
 	range.start_gfn = start_gfn;
 	range.pages = pages;
 
-	kvm_flush_remote_tlbs_with_range(kvm, &range);
+	if (kvm_x86_ops.tlb_remote_flush_with_range)
+		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, &range);
+
+	if (ret)
+		kvm_flush_remote_tlbs(kvm);
 }
 
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
-- 
2.39.0.246.g2a6d74b583-goog

