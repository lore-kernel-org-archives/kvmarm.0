Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CD56AA2
	for <kvmarm@lists.linux.dev>; Sat, 22 Jul 2023 02:23:05 +0000 (UTC)
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-569c44b61aeso1133578eaf.2
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 19:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992584; x=1690597384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hJ4NFtSWgiMEwLg284CgQ5sPMcVW/iV/DNVpISC4B6I=;
        b=GFxwOMS7lRvlirAPbgAXoia3hbfdBq/xXx+dPhEh60FkKxGu7B/WsAv4yltvyZMVho
         ayvOW6s1YcZiNyAeIXC+jpj/2vCxd3q82OtgQJz+XpyvXHucFODQlnCPQmqcuGPZ5W5R
         zuUSN6iaEJpeVh0U45tQgiZHk6Waq7ZcGgZZneJmGA0M0l4nRWgk3qM8M5TeVUwIjAEY
         2bZ60w8i8oirvpfuPwCQIf5Q33UzWX1OmgiUg42nriPrsftxK5Dz/ynTGl93S8KOsCz7
         pj9VukTC7HRns0kEBNO/TDdV3GuxkNlEOZWCoEn4gJwYrxWQ+HnXAJAvWFI7DGXjcMBb
         WhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992584; x=1690597384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJ4NFtSWgiMEwLg284CgQ5sPMcVW/iV/DNVpISC4B6I=;
        b=Au+Ny+ko4iLs57FH5K2DqL2+jZlmSr32a3pVBwGqaGrGgZFpiK9qCxktLeheHF9hbr
         fHbox9rpKkBoHqnXDRJ91rTxSD+yN6ASMyWBeQO1eeAxqrV1WtqxK/WuT0dUPR0bGK5u
         Ufp02K5VITM8Frrg0DFW2gJXsXoL23N4FMzqR7UFLKu+vuq7pCEX8QD65Td1cUze/hsn
         +zI3itmjRJRJLF+/xK2d28jEhAMBjuZTNc1Lal45d0CYukjdrvnF1LstZJuzby6YdLpG
         WlLl5z2hnjnhVvsFAuYtFbKUe1fjZTYKx/YjfL/+DhByl7Jadbb4fMbM37yE2PWBM3//
         x+KA==
X-Gm-Message-State: ABy/qLZUa2pKugLvwUOzYivgZMlbnOh87c7b9SV4hYNQiFczT8TgRDSE
	IxPaIQNMYYNtLL1eIl8gpROwbLz8uUd5
X-Google-Smtp-Source: APBJJlGAW+6/JrIYJI2JdLwtGX1LjNoUSmksaPTMtdqVT4U713h6cuykvY/ueRKWB3kJQ1QCRmdAmt+/OBPn
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6808:15a1:b0:3a1:e58d:aae0 with SMTP
 id t33-20020a05680815a100b003a1e58daae0mr8380023oiw.3.1689992584760; Fri, 21
 Jul 2023 19:23:04 -0700 (PDT)
Date: Sat, 22 Jul 2023 02:22:49 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-11-rananta@google.com>
Subject: [PATCH v7 10/12] KVM: arm64: Flush only the memslot after write-protect
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
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
index 387f2215fde7..985f605e2abc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1082,7 +1082,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.41.0.487.g6d72f3e995-goog

