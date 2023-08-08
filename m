Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3C1BB4E
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 23:13:44 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so5338166276.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 16:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536423; x=1692141223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8aS9+bqGGIGJd4osXg0UNYpwpvIxhiWvvz+QMPQ0Ulo=;
        b=r5BfuQMefAg0Tnr2FQaEIivjC4JzNAMuw4qxGVtci6+U9djSIpA11Hdl+rJc6en91J
         y/h+YDs0QAA5xFNhoGQE0fza9XyovVTAf2+ZIQj9pZdiciK8WN7z5vHDkRS5bze2JrvX
         1Pi0zGoodsu607T4DyfgYeotzEFP9OFg33WWk/J6RT4OzDi2b1Fi3JqRQ6HpyZZ+gywn
         +UZCzVUhZNvWuqdnzNxXM4bRsJeE1eSS8tnxOTUMx2/t6MN7k2idS2QWNmkVWa/w66NG
         yQ/AVA1aDJm/DL0O+01cjluCupsA1erg2PPaJFd5MY5BuRKvpf3vdiz+yo1bLlWRTbiY
         xCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536423; x=1692141223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8aS9+bqGGIGJd4osXg0UNYpwpvIxhiWvvz+QMPQ0Ulo=;
        b=dHEW3NszU7H2QsnuO86Zj6n3Z8PZtJNEFCl3AxRhLIF5gLqJmcYQQogBC53p8xh79Y
         DIVkLGgBSDyt0rm9kI8PZOMAYzZkp0xSqI75sKs6HTkQbjIHWhDJEjvLkwnRzhBzwTt1
         Jt6cvzAsczzgj/efSMvWYTykIK5UxXDq/a6UB5mxcb1dsYjEEvKyJIpgKg+6H1VW+VIx
         R4nQqA4YJnNfM1n8Kvu7PF9te/OHMBroG9OcRdV4ffVDM3HBm/v/1+Lmw06dXAPQ82D0
         dCk6/X6oBW3DYDhztMvsmiHPn859dWR/cDC3XK0b7FlfziFrVwl+dnRMg96QONdtmZK8
         Fu/g==
X-Gm-Message-State: AOJu0YwYK8v/mkns8NoJeAMF2GZPKANEJ4Ntbq85vJu5+ehKHFgXZlkA
	e+C9q19VylPE8ocxJhSVsUaMjFtAsrzA
X-Google-Smtp-Source: AGHT+IGN6Wyp+xgEmWlEdpiyTqEz05f+ph0g541H8xJPxC5yzYpq7Xwg2KskI5Za7Uo8sgiAN3njNrOwDHIy
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5b:890:0:b0:d10:dd00:385 with SMTP id
 e16-20020a5b0890000000b00d10dd000385mr25024ybq.0.1691536423557; Tue, 08 Aug
 2023 16:13:43 -0700 (PDT)
Date: Tue,  8 Aug 2023 23:13:24 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-9-rananta@google.com>
Subject: [PATCH v8 08/14] arm64: tlb: Implement __flush_s2_tlb_range_op()
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
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Define __flush_s2_tlb_range_op(), as a wrapper over
__flush_tlb_range_op(), for stage-2 specific range-based TLBI
operations that doesn't necessarily have to deal with 'asid'
and 'tlbi_user' arguments.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/tlbflush.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index b9475a852d5be..93f4b397f9a12 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -340,6 +340,9 @@ do {									\
 	}								\
 } while (0)
 
+#define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
+	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false)
+
 static inline void __flush_tlb_range(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end,
 				     unsigned long stride, bool last_level,
-- 
2.41.0.640.ga95def55d0-goog

