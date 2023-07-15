Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF40EA6
	for <kvmarm@lists.linux.dev>; Sat, 15 Jul 2023 00:54:21 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bd69bb4507eso2085664276.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 17:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689382460; x=1689987260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NQY+Dtk1XWrNNGuHSHxbkYrauldxXbZA83USiWOTL6o=;
        b=TCgWEy2z8oOGQwvnSBHn0AkAkVSlT9c37MgvWUaNlBXCNKNpJR/vOwVyuvEfVCFhZH
         75Djs6cT8vsl01b8fPqnk9tIFBiF7zvqtCVYGWLZuWsMETu/RPDzgHfQJ0N6NM5C6vOx
         hB+mAtMX3eXFTzff5OpvcbDHdQLWnoerWsIudu0SL4c3QoXFOjZqkSdjyoCJtPVXGr6W
         //LvcxbEku4U7vC3//3dhn54WTCVJcS92mQ6c7NC+uGD3MBXy3sOfSBG1WMjwOX4vcYi
         XoUh9543oJXJngnlcI/Jw0nJMM49HqIHNGb/O4YAGu77Z/SnUdDFBBfexEdSrvLeIvbz
         Ltlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689382460; x=1689987260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NQY+Dtk1XWrNNGuHSHxbkYrauldxXbZA83USiWOTL6o=;
        b=cN33IdiKxMFnXp4nHepjbaAANAjU97heVQKfr+pLGYZ/9QKR87rdxKy12XuSXLDdWo
         lU3HF44mPW2M4nKk/ytFReReB4EO7nvqnS5EVvHmvmfCXKVhc48f5krswylymoGNdE3V
         LP7KPfzON1iJ5Yr0uySFLVBITtwP2dJ5XviKqVdYJtzWBwNI5WHMjJF7uRWGLnzFknlf
         qfZSHUM1MCj2JA8L3T49WQ+cmEJc7fRk73+Ze4tnmkHRrhKm9ukuelKYVfqpMF9eRZ5D
         3tDgw+Y9M3q34Qt7hsMjv4zShJINWlCqRLDMFTX7sejCVxFaVhYN8f/SkAlPRVMSQ9z7
         KNBA==
X-Gm-Message-State: ABy/qLbgYEHEWug1MIRvVeWPm3Npri29xY3uelYoSLqMBOuSeCuR5p7k
	mZuqRgaB+rTu48MYsn1K7QoDpb/ZwQUX
X-Google-Smtp-Source: APBJJlG5n3Bft6SS+LPAWDb1hmMGpZKEdbwJGhCcCMWgOINPk2C5Y/61Tx4AtYFAIRblEEw/+bRH7gfv6I55
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:ab81:0:b0:c5f:85f5:a0e5 with SMTP id
 v1-20020a25ab81000000b00c5f85f5a0e5mr14207ybi.5.1689382460190; Fri, 14 Jul
 2023 17:54:20 -0700 (PDT)
Date: Sat, 15 Jul 2023 00:54:03 +0000
In-Reply-To: <20230715005405.3689586-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.455.g037347b96a-goog
Message-ID: <20230715005405.3689586-10-rananta@google.com>
Subject: [PATCH v6 09/11] KVM: arm64: Flush only the memslot after write-protect
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

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
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
2.41.0.455.g037347b96a-goog

