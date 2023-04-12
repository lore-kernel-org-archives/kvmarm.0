Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853A2A93A
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:32 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id h206-20020a2521d7000000b00b8f3681db1eso3993772ybh.11
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335332; x=1683927332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fW2lVHfchp9UgxlQ0eqx0Qnt2L2yZQNT4SVI95DvpSs=;
        b=RbgkvGcRLIPqOOdYTNLhCUUYpP5u2hdsGoV9tBjd/zi1IjMKBqiqA4sTOeL9bmoW81
         3H6Qawu5hfjaOHdrZKYJjjAR5wQ054U3LXNw8S1hT7BxcGUsYoBb3c/5ycAOlZhoOdIt
         dgXzaicpEJwGYoy9qsWynR9W7h9/m4Ym8cnWfYm6bzs75oxhyzRFVeyTI27Ln42QTX+R
         ETbJEewsFQeSLQ5tUo7roL1hW8q9eBwsa+gSY8ErXEcwEVuBQJ6YFyvwi3NQ8sUBj7jR
         AoxcJZMbiDGNw5e335EAnuUNdSYzaovS6U4EKDLMkQBvIw6z8nn7Dxs2OReIS8YFbH7v
         2ODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335332; x=1683927332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fW2lVHfchp9UgxlQ0eqx0Qnt2L2yZQNT4SVI95DvpSs=;
        b=Pp/uUi1NIGYcBmhDgKklutzdY2RVc6mzOS6z+Y4ZbGdxbTFXBp3AmA04eJ7PPqV2Oz
         RnMKJ7i+clnopUYYeOynulbsSu+HeFAApfC4EFivTYZPXUVs4szzveTlQqPM1IZBNAWG
         PZU7Ht2zyOUnj9ZKzGZw4R3E+XxR9JRfCRzBqc0LQSPj+KiRP7VqYY3KhJXutU5CKwuB
         oAC9D1Kc1U9PCVGugtKFiL0SEO1lW5HtMsHpPFEcwf6FlA5uxGGgzfsHjSyH86lC4eE9
         o38McWqnloiSDIlnWnw72ovcGe7YzHvdTlYpd89dsRWdClzOwDnFxOBaR1pOnBdJMLH8
         djRQ==
X-Gm-Message-State: AAQBX9frI4hDez3f5AxThTWgDVvyxa/dfMn7hy3Gah5uk/Ih56LsK7+U
	kRJJtplH7aV/zjcJCDVAgECl6Vu4HWqpqQ==
X-Google-Smtp-Source: AKy350YH5KZy2ouOBNOYXjh55lIcz9SLFEFUhOyUV8JCny7/1ROofC6xXNHF+9m2d578/vmRjDjHN/WG7mo03Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:30c2:0:b0:b8f:553a:ddfd with SMTP id
 w185-20020a2530c2000000b00b8f553addfdmr2164ybw.5.1681335332195; Wed, 12 Apr
 2023 14:35:32 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:35:07 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-20-amoorthy@google.com>
Subject: [PATCH v3 19/22] KVM: arm64: Annotate (some) -EFAULTs from user_mem_abort()
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Implement KVM_CAP_MEMORY_FAULT_INFO for at least some -EFAULTs returned
by user_mem_abort(). Other EFAULTs returned by this function come from
before the guest physical address of the fault is calculated: leave
those unannotated.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ffe..d5ae636c26d62 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1307,8 +1307,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_populate_efault_info(vcpu, round_down(gfn * PAGE_SIZE, vma_pagesize),
+				vma_pagesize);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
@@ -1357,6 +1360,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (kvm_vma_mte_allowed(vma)) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
+			kvm_populate_efault_info(vcpu,
+					round_down(gfn * PAGE_SIZE, vma_pagesize), vma_pagesize);
 			ret = -EFAULT;
 			goto out_unlock;
 		}
-- 
2.40.0.577.gac1e443424-goog

