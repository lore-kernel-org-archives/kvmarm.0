Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE431C758
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:32 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-564fb1018bcso33918587b3.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722172; x=1688314172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fngtlIXFBOk5ojPhoCZKxdftJsl/PCjzcivfHulUfxM=;
        b=KTqFTUl8/O/otunDnIcW8NMT9NoZpURoL+fT5x3jr7xLTtmqLTsOpMHELHqceBBNBQ
         AmDayYQtgKFH5Z55J+qEEznt7CMzcfBLKa9rXdwkcbaxYdDyFrpWK5tIf+OgM6RdtGyq
         GQdHIK3QOQ2drYG/ZFFk+kHjBy+s90SO6eGGqGaoiIn9r7XkEBIEo/mXJtp3GumBEOA+
         p4STDDMfVtsOTK10O8PNGuXazkAWxMkEfK3iCnrl9MiWc43AYLln6h9/+ty9OxynFFMd
         DAYdFz0PuZJQnqyg+7O9VnZBBnLY/2RVdSpDM0DZZNDzkFP0BkvcK+wZMlJvwm1mfdaV
         VyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722172; x=1688314172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fngtlIXFBOk5ojPhoCZKxdftJsl/PCjzcivfHulUfxM=;
        b=YEIXs2zmuOLkiFcbUPJ94WSLGtVZngUgBAmkc9rFGXCLK8qhnYtd/bdjBxpAMCGLUx
         eSfZ+na6WPfgmqUBaSTlU4dcC8TGDeusEJVsWsxNpkYb5OZnpudcDy2kzpmohSeEuBNR
         jex2JqV0+keLnBkUTEfRUlWlJp54g/RlBLr8KUiH4wIPlZfBRkXdGb5zXlmt+XuU+gQq
         n54Imr839/X8VSbVRxHRLgOPtDWitCCh/3oHOqvOc651etAJf0LmQUOhNla26pecmbVP
         Q7MuhTgje3s6hD69Rlvt+kl51lWTwFiwphQ2nzE2u0697zhZUc5Yd8sVRtgxq2EIqwOl
         ZreQ==
X-Gm-Message-State: AC+VfDzRGEkAK1ixPRg8pspkOhQ1iBDk2tdHNIuiBYYfUVIqsJ9zRHwm
	U51jINuyexYrru8egigGB10cF7PHEKwQ
X-Google-Smtp-Source: ACHHUZ6gan5YlBkZGg9KteJiKVhKxkJ5gsh9dOHqcHA/QTL4d+xT++IRNn1eOG3Ha8PAz+KvOVFz0vRB3dhD
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a81:c509:0:b0:55a:3133:86fa with SMTP id
 k9-20020a81c509000000b0055a313386famr182818ywi.3.1685722171727; Fri, 02 Jun
 2023 09:09:31 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:04 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-7-vipinsh@google.com>
Subject: [PATCH v2 06/16] KVM: arm64: Correct the kvm_pgtable_stage2_flush() documentation
From: Vipin Sharma <vipinsh@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove _range suffix from kvm_pgtable_stage2_flush_range which is used
in documentation of kvm_pgtable_stage2_flush(). There is no function
named kvm_pgtable_stage2_flush_range().

Fixes: 93c66b40d728 ("KVM: arm64: Add support for stage-2 cache flushing in generic page-table")
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 850d65f705fa..d542a671c564 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -657,9 +657,8 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
 
 /**
- * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
- * 				      of Coherency for guest stage-2 address
- *				      range.
+ * kvm_pgtable_stage2_flush() - Clean and invalidate data cache to Point of
+ *				Coherency for guest stage-2 address range.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address from which to flush.
  * @size:	Size of the range.
-- 
2.41.0.rc0.172.g3f132b7071-goog

