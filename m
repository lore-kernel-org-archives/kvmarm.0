Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0EF28C12
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 23:44:50 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-babb7aaa605so2784173276.3
        for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 16:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144689; x=1687736689;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bguo3hUZaLYxse9v+ik+MX3ufqUdHR10jXNpIhPD3cE=;
        b=Y62V38pt3Kf7P9M2YivEC5661SUHDQjGPJeLNpi65nB4y+p3TsqoRR0z/9AOIr1Kjf
         gl3yg0EBv9UJcyGGhkoV+eP5nxHHEckaVjNM+WV0ph8y6N8NKNrOoxejQzf6xVLF0GNF
         CMPzW7iyFKrk0I+YLOBH1dB2cwpR8z8XT9p+1tlyni+H85cDXJGB/ZGkaiDpbVC82/o/
         GKwW1qcFloQI+vCY/C+X0I8xbKAWwMlWN0KpQsh6osmLARaX2g1tNlgMEbkEwKadQaPu
         8s3poXNR7qoLyRgjp4108zRCziAP6oNak8GIUn6lV7gRCswVoQjlt0PKr+oTkaiyWyY0
         Ciug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144689; x=1687736689;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bguo3hUZaLYxse9v+ik+MX3ufqUdHR10jXNpIhPD3cE=;
        b=U+aDz1Qnv0++0gxAs+K3iMcR/bUpe7GT5E6uzz0y4E+eOLiDrEPe9qyl5zjE0xlC0n
         ug2WKGuvpuIeh6YDR9LfkpytL0WHVWjBRU+kB9wZLxzF/Qg61wmqYQJYmpAp4ROWcLlP
         bg3bY9IiExA78A24MtXQzkq/V0snZ3T9OpNS+YBFUGlvcfHujlB/6S3zGSLZ3xPRkf7q
         560QMFNjoabvo0HVrKhGeela9tSjuk1aWk7QNVkhd9t+bm7ia0Hsox3GZZ7cQHPFtaR8
         3+EXpjzJvBfuBVkkV9tns1i7SHdDxH5z1CBw+KyAamuI5ffNYQ4joAZbaxy7oAHDsaxR
         72aw==
X-Gm-Message-State: AC+VfDx4DonVAqFgE+Ct1UTK/u4lEo240riB0H3QaTit4J+VzruTuFRx
	6SJXccjBKmiFzTCDYvASG2l/w7H19qQ=
X-Google-Smtp-Source: ACHHUZ72Yke0umLVJsAYBjLDCmB2C1ZbHNslgBIJrMfaEGzX80HaCkEwKhsoBR2khvT0ady9wDj4p4x/v3M=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:910f:8a15:592b:2087])
 (user=yuzhao job=sendgmr) by 2002:a25:3cb:0:b0:ba8:337a:d8a3 with SMTP id
 194-20020a2503cb000000b00ba8337ad8a3mr1807757ybd.11.1685144689141; Fri, 26
 May 2023 16:44:49 -0700 (PDT)
Date: Fri, 26 May 2023 17:44:31 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230526234435.662652-7-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH mm-unstable v2 06/10] kvm/powerpc: make radix page tables RCU safe
From: Yu Zhao <yuzhao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Ben Gardon <bgardon@google.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, 
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michael Larabel <michael@michaellarabel.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paul Mackerras <paulus@ozlabs.org>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM page tables are currently not RCU safe against remapping, i.e.,
kvmppc_unmap_free_pmd_entry_table() et al. The previous
mmu_notifier_ops members rely on kvm->mmu_lock to synchronize with
that operation.

However, the new mmu_notifier_ops member test_clear_young() provides
a fast path that does not take kvm->mmu_lock. To implement
kvm_arch_test_clear_young() for that path, orphan page tables need to
be freed by RCU.

Unmapping, specifically kvm_unmap_radix(), does not free page tables,
hence not a concern.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 461307b89c3a..3b65b3b11041 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1469,13 +1469,15 @@ int kvmppc_radix_init(void)
 {
 	unsigned long size = sizeof(void *) << RADIX_PTE_INDEX_SIZE;
 
-	kvm_pte_cache = kmem_cache_create("kvm-pte", size, size, 0, pte_ctor);
+	kvm_pte_cache = kmem_cache_create("kvm-pte", size, size,
+					  SLAB_TYPESAFE_BY_RCU, pte_ctor);
 	if (!kvm_pte_cache)
 		return -ENOMEM;
 
 	size = sizeof(void *) << RADIX_PMD_INDEX_SIZE;
 
-	kvm_pmd_cache = kmem_cache_create("kvm-pmd", size, size, 0, pmd_ctor);
+	kvm_pmd_cache = kmem_cache_create("kvm-pmd", size, size,
+					  SLAB_TYPESAFE_BY_RCU, pmd_ctor);
 	if (!kvm_pmd_cache) {
 		kmem_cache_destroy(kvm_pte_cache);
 		return -ENOMEM;
-- 
2.41.0.rc0.172.g3f132b7071-goog

