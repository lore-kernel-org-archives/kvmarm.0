Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637561C9E4
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 23:13:48 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58473c4f629so74014177b3.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 16:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536427; x=1692141227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DdFQXc9QjMOj4pMVD7mddwddfJwM0E/FVNI1wIxPkhk=;
        b=GGya4r79Fypy7MpijHUr6lRrKbN2KwgnqmepmFHyoEm6JOw0RI4BnR26D52ypMST14
         qMrhS6uMP+X/P+04iY+CFJYP/yfNgW/oQiRxmX4L8KUMTb9SHE2leuL53nL+lEy8UfWN
         H6Gme/iQnweVgHOIz203N5vFFXqVCtC2ViqgYkIHf1XrsCct05bcsmV1KcRfn0mKeymj
         ESMAAwstxX9ujJZpbixig2EzSNSrlwlq3HWLXEyApK1JC0D3VIjPeG/oYEmpo68kYHS8
         /95jhR/N+ADW8Wt9ABI0Q1X51ZWQY4WgE96INI5uDk8QgBXuW/N36eA7E8a9TtSBew8R
         8+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536427; x=1692141227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DdFQXc9QjMOj4pMVD7mddwddfJwM0E/FVNI1wIxPkhk=;
        b=UCk/r8HTZcpsenCHnP1A988Oe0Hd6d35mNnc0k5KMYvmOVlR/enpsc5EWfN4CWgdGz
         UfVokRPQyUE30JgJF6eGlaEJEyS7Vh8OxLmkUrSLvg/Es6TCq+/A04dDdj/5FksAhWy4
         Wjp8AD3oE2Fd8X1IMnq2GAsqZm+2LJ3NIUxrNqU1mK6zbtmG7J4GW546MuiDfeBsRIM8
         RvABVW27wVci6shZjfwJQkcmGlxZqwpg9tiKcMRewI6jq1ATOEIEU6rbK1HVMa2VutWy
         em2JJ6cTzGJoTMxef1eAYn5ywJmSDzA4hEhgQSlYN+LpoxtEviU94Fmyx0PCtOg9nMFu
         ItUA==
X-Gm-Message-State: AOJu0YydkgSsauxOkEb/myDpzhOlF8NFGpcBDxvcthxCu63iUD3WFV/e
	iSLCLtloEM3TgrMzqB4bFfYwfW4Pj1nj
X-Google-Smtp-Source: AGHT+IHtVpA0B67cdmlCLqrTRdBRqOLFjvFy7tyIxoiuO5XwsAt9fDPTNialdcxuGgrd+oEKUp81U6/MqqgQ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:ac09:0:b0:d0c:1f08:5fef with SMTP id
 w9-20020a25ac09000000b00d0c1f085fefmr19514ybi.12.1691536427532; Tue, 08 Aug
 2023 16:13:47 -0700 (PDT)
Date: Tue,  8 Aug 2023 23:13:28 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-13-rananta@google.com>
Subject: [PATCH v8 12/14] KVM: arm64: Flush only the memslot after write-protect
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
index 294078ce16349..95ca2b86aa2cd 100644
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

