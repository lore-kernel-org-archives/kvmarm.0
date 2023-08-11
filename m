Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA8410F1
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 04:51:48 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-569e7aec37bso19868687b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 21:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729508; x=1692334308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6qPiqYiGdEy+ALMWmUClgOJtf7MJwHf5G0engyYFuk=;
        b=qrcaMEcSpq+ULmZt9JgV/iXS5+x9ZwEslbJLOWWZHpe9tEaJ28kJ0dsZTFh+wHaZVY
         z/+PWbhe4kPyyucCymXKpbVkBUvDdebb4moSiMcKue6hrkGuTyTFlQ2SS1ZDAmF+7o2K
         JIqhRUzm+nxJK7sCky9lN7UwOaQ9GwOZduGzIbm/TwSEScjePA4FFoYCus4bBKN6ke8D
         wf+zv3/75Th+zNlJ44hzGeBSVubCWPJjE5lDfkpmjoMYIWdYXie5RHK61lA9sT3xtR4j
         o2HtqwDGpSxcDAOl6CF9D9EeEbTPBni26ZJIeebSWG7wMNG4nNsXFqjiD04Lfm8rlpNh
         SVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729508; x=1692334308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6qPiqYiGdEy+ALMWmUClgOJtf7MJwHf5G0engyYFuk=;
        b=Sie3JQFK0HpG09gUgnvG7NIaTjDjeSxVUd+U17L9rCQvy4AaQNe26MZ5gLwJNovD7V
         m7b7z3ued7s7sUezZDg0ixIKkcpsGMlAFzdXGJoNQNEnWCAh/Luq4zDNqFWdlZPNdcdC
         X8xjiFIwrkrLC3RwWr8PXJB0Mnsoj3QlTKBOKn5sWePVWFehN/22IcufBnQsLRZ3WN7z
         jseyBuHa4xXdxNCd9kSkp0X1o+DAFlR2yrNKyz0M32Jbs6BEOmDVAiE1pNU4Nj+rNso1
         cvL6TtLopn1Fb4lGg5XdHTorBKMX+DJZaflkJcWNUOFCfm2Ve2VLcoUQtErZtMxWPTrk
         VVbQ==
X-Gm-Message-State: AOJu0YxZ4OaA4CQ2NskrrFvQTxv05yJE9yb2umim0enFrr4htDeRSab8
	xbM/2LJeMqUGjA0/5NV5k8fL/Zj35at2
X-Google-Smtp-Source: AGHT+IGXV3TrUe7VdEmoyRMybbrBwXMmeig9Hy139aV3xPrm/bppO8Uhrj80L5wM2TEVNSyoFL3mzf/IgjNd
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:b71b:0:b0:589:bfc5:d80b with SMTP id
 v27-20020a81b71b000000b00589bfc5d80bmr14055ywh.2.1691729508012; Thu, 10 Aug
 2023 21:51:48 -0700 (PDT)
Date: Fri, 11 Aug 2023 04:51:25 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-13-rananta@google.com>
Subject: [PATCH v9 12/14] KVM: arm64: Flush only the memslot after write-protect
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
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 702f8715f9fe7..6f44896936b47 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1083,7 +1083,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.41.0.640.ga95def55d0-goog

