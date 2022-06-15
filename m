Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B330BCCA47D
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jun 2022 18:57:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 022694B1F3;
	Wed, 15 Jun 2022 14:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id heeUDUe1lx0s; Wed, 15 Jun 2022 14:57:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA9544B1FA;
	Wed, 15 Jun 2022 14:57:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E624B1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 14:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HdSbs+KDix+H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2022 14:57:18 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3926B4B1F3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 14:57:18 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 m5-20020a17090a4d8500b001e0cfe135c7so1435139pjh.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 11:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=JOfZ+gB0dYMw5zlfGsNpFQnCHYNIGhGPLB/fJ5JUiU8=;
 b=SmOp6Z2zPaMf+7HW3xlQs45Fjh1wQY3JcE955U5EzRHsTUkE/IVL5RlhOgVgPtTUSd
 40TLB+kwbienuX8Dx2E0wGxELrUEYzz+rLJg+3O0i9zwkTixcET9vp4JBVjxgbrJBAnu
 +cYumohJ/0Z1hODaPf0Ii6qP1SyuhGSKXz4inlCZbL9c2knCQta/33jC2LQmQ/aeD1/y
 Tnpe70f0H+Jx5LGBbpe/TeG9QpvYq8ogcKYRc6PcX+ZPg4yqL5EsPmDFbBWLlmCrK4+l
 wTu6a0wUtxmkc1JTA20jJsnPffMTnk8/bBUa5UdrL8N2SVS1KlYBk5kkxZrRKRWiYilI
 BvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=JOfZ+gB0dYMw5zlfGsNpFQnCHYNIGhGPLB/fJ5JUiU8=;
 b=0gWlPWD8ZunraxVCTbQRd7iaFXUUPeVcn5htFHa5QPedE3WqzcWC1IGEd7MET1QiSS
 k0PK0fff+ybBpq4VLmo8WaehWaAs5px7HhKpcgIfQ78uRcYP+Q01vNooXEX8nTt24N2R
 umbi6MuZrb1VgiU0SkPQUvMSI1fvKJF+qAY81HdhW2xxyulfiftPKl6aASvtxJY38dvI
 zvK8TwjApPMsT1aB28coAMnW2sBeyi+FuEpPAwBrB55aD0BfpI1Xy14T7hbFETrL6hgI
 UsOuRCTfFEi45q9SaoIc1i8B3RQfhH42aPVsko2RAKTGkDxhonmAFz7SU87FRL6o9Nvp
 KtIA==
X-Gm-Message-State: AJIora+t43J7xtJwb1Pp548r4C9MqpACxx0z9h/Iw5ZouGe6u8pQMqk/
 2aetzGwSHrA/563WP86xyFIkgXPkZYex
X-Google-Smtp-Source: AGRyM1tnQw7CJaekFPc8SBXFz+VUADNRt0rkCQV5Q4hm28pSqTrYYIgOQmS9We429pxh9Gldc5o2PJ/GLIXf
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:74c3:b0:167:6811:40 with SMTP id
 f3-20020a17090274c300b0016768110040mr1022512plt.120.1655319436857; Wed, 15
 Jun 2022 11:57:16 -0700 (PDT)
Date: Wed, 15 Jun 2022 18:57:06 +0000
Message-Id: <20220615185706.1099208-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Colton Lewis <coltonlewis@google.com>, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The selftests, when built with newer versions of clang, is found
to have over optimized guests' ucall() function, and eliminating
the stores for uc.cmd (perhaps due to no immediate readers). This
resulted in the userspace side always reading a value of '0', and
causing multiple test failures.

As a result, prevent the compiler from optimizing the stores in
ucall() with WRITE_ONCE().

Suggested-by: Ricardo Koller <ricarkol@google.com>
Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/lib/aarch64/ucall.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index e0b0164e9af8..be1d9728c4ce 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -73,20 +73,19 @@ void ucall_uninit(struct kvm_vm *vm)
 
 void ucall(uint64_t cmd, int nargs, ...)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
+	struct ucall uc = {};
 	va_list va;
 	int i;
 
+	WRITE_ONCE(uc.cmd, cmd);
 	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
+		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
+	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
 }
 
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
-- 
2.36.1.476.g0c4daa206d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
