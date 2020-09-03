Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDFAC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:18:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9A39206C0
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="WGeAJLDM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9A39206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA8E4B255;
	Thu,  3 Sep 2020 05:18:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YvQ2OMLE3ZIH; Thu,  3 Sep 2020 05:18:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D00B4B270;
	Thu,  3 Sep 2020 05:18:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE7F4B249
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:18:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HTvXWNIIZ10o for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 05:18:02 -0400 (EDT)
Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com
 [209.85.218.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D4094B25D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:18:02 -0400 (EDT)
Received: by mail-ej1-f66.google.com with SMTP id a26so2863778ejc.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 02:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=NQv+tl4uppeFkb8OE5qw190d9LgQJYKQj0zpEykuMCM=;
 b=WGeAJLDMsRVumT9Q9ux6Nast3r0JswgFOC70ZutZNZBpf4GDOxF1Vq6GaxB6cpDZ45
 Ubq1CjFd9RyDJye5zoVo0+QI21IJuR8D5K5NTSCX0bfI9NOKTkGvpRSdqjbbeU8lOgnD
 tJC8vPxb//wpf1qUbLuSg0l8hrW/1r/jrioS74dOFucWmTNYEf6D0j0FI538lwVoZMfU
 6nmWYHKuc7tfuY983RwJ7bm/dKm2mVyjPAIdqZoonp/ofsHcYNliONbyDgPpLGYp45Oa
 CHQHOnDIGMvH+AX91mPbZluIWwNyPlz47HjPqLMi0Ot2VIwY+bVwfHvG9y4br0BODeiC
 d9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=NQv+tl4uppeFkb8OE5qw190d9LgQJYKQj0zpEykuMCM=;
 b=WCr4UUFpwYzR+HM9S2KrFOl+KY+rh1u86AAd4d4QjiAYLMjTvh0j0H5MKgMH8DoO8S
 CkNqxKNBBgmi9CgAu2QK4Pdt/KdIRt0spFyoE18hXqdDYmp/eotFtQ+COoz2MzgaagPB
 R++zAB53sVZIUuqPhHefdU5zwUsUzVmCNgd+TEztqXIvFSuPBgU2cc67oFTyv2IQEB+U
 fWpepmunXQC/ANQMh0IsxMbXX5k2LebAYrPxmdezQqPX+6ZF+RlqgwBjLXKsCFk005+9
 xYKJBb0bPzwxr8c0VtLLBaynNcihwEGpCYd2HdoaS/oC/2ZqwgP8TYRNil+Yt47eK47I
 XAMg==
X-Gm-Message-State: AOAM531wVs7OolqJQc+XdHSqWOE/o1v8sfOOoVt9+d3guqJ4LUDG0iSk
 OMYE4hL4YfuVgM2WSdO+s5Zr6g==
X-Google-Smtp-Source: ABdhPJwKWw1WUu0SdgKqUcKkconNR0zceARFGVkjySt2UpxXg4FXus55KxeqDNsvsTsSugbaugIAoQ==
X-Received: by 2002:a17:906:3ac4:: with SMTP id
 z4mr1065800ejd.65.1599124681204; 
 Thu, 03 Sep 2020 02:18:01 -0700 (PDT)
Received: from localhost
 (dynamic-2a00-1028-919a-a06e-64ac-0036-822c-68d3.ipv6.broadband.iol.cz.
 [2a00:1028:919a:a06e:64ac:36:822c:68d3])
 by smtp.gmail.com with ESMTPSA id x25sm2429769edv.42.2020.09.03.02.17.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Sep 2020 02:18:00 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 10/10] kvm: arm64: Remove unnecessary hyp mappings
Date: Thu,  3 Sep 2020 11:17:12 +0200
Message-Id: <20200903091712.46456-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903091712.46456-1-dbrazdil@google.com>
References: <20200903091712.46456-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

With all nVHE per-CPU variables being part of the hyp per-CPU region,
mapping them individual is not necessary any longer. They are mapped to hyp
as part of the overall per-CPU region.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 25 +++++++------------------
 arch/arm64/kvm/arm.c             | 17 +----------------
 2 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 9db93da35606..bbe9df76ff42 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -531,28 +531,17 @@ static inline int kvm_map_vectors(void)
 DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 DECLARE_KVM_NVHE_PER_CPU(u64, arm64_ssbd_callback_required);
 
-static inline int hyp_init_aux_data(void)
+static inline void hyp_init_aux_data(void)
 {
-	int cpu, err;
+	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		u64 *ptr;
-
-		ptr = per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu);
-		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
-		if (err)
-			return err;
-
-		/* Copy value from kernel to hyp. */
-		*ptr = per_cpu(arm64_ssbd_callback_required, cpu);
-	}
-	return 0;
+	/* Copy arm64_ssbd_callback_required values from kernel to hyp. */
+	for_each_possible_cpu(cpu)
+		*(per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu)) =
+			per_cpu(arm64_ssbd_callback_required, cpu);
 }
 #else
-static inline int hyp_init_aux_data(void)
-{
-	return 0;
-}
+static inline void hyp_init_aux_data(void) {}
 #endif
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index df7d133056ce..dfe1baa5bbb7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1631,22 +1631,7 @@ static int init_hyp_mode(void)
 		}
 	}
 
-	for_each_possible_cpu(cpu) {
-		kvm_host_data_t *cpu_data;
-
-		cpu_data = per_cpu_ptr_hyp(kvm_host_data, cpu);
-		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
-
-		if (err) {
-			kvm_err("Cannot map host CPU state: %d\n", err);
-			goto out_err;
-		}
-	}
-
-	err = hyp_init_aux_data();
-	if (err)
-		kvm_err("Cannot map host auxiliary data: %d\n", err);
-
+	hyp_init_aux_data();
 	return 0;
 
 out_err:
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
