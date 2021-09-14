Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3B2C43219
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 22:31:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5AD160E94
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 22:31:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A5AD160E94
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3314B0ED;
	Tue, 14 Sep 2021 18:31:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u7BP+TyBCqKe; Tue, 14 Sep 2021 18:31:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FCD94B1A2;
	Tue, 14 Sep 2021 18:31:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E34424B12C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 18:31:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E7rPDughYXcy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 18:31:34 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 223CB4B128
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 18:31:34 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 a23-20020a25ae17000000b005ad73346312so872126ybj.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 15:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
 b=lq/RxhWNVx7HvcaPCnLIvkYwVN/qajC6Z/TJt7BjQwh2kiG8aYIi9XXaH0fBS2ObXi
 uE6/PIk3diZR5P/av9EkChN11F3yxn4ytG2jrnfrPhRGWUQURMRhLO13q9wfpwCR7A5g
 7/RM69WnbITiPwIbs0CKxqrkVixmM0zXsLIHEQ1wRoh9YknzbX05OpiklsPNYRuGulYJ
 ieHH741AlkpjfWugkGP71HaL/RjstLd4VOJDdNdvowz1eyiO3NYovGHA5UHOVGx1wlXU
 yW88zoT/uvTdgcLKGt87Xg/M64lmUFO4TbQhZOSwiPy7azMCeLzAURvn+KJL+pQF/9m8
 vfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
 b=0IOOjwLXwDqb7yNKTMPVIvfUNj0ZHrddt2sny3Pts3j02ct92wdRnssqFHEbf8zV/c
 fc4HYjgct5odtehdP8UOQfW5n1RqbsCvmgfsXXM85/iAnvqu48tsh70RYB3cIaltJ94e
 hhyHf2zHF+SJ9amVN0YRMGCX3MYpVP5CfM2yxMm9cj5wvCyeCAF5cJzKdkiCxLW24Aj3
 u+9kGNCZwZ9lwW4lh4VeJXTm3FvqwEv2mDZWVhKXSvFxV+ohmakJSaBab861S95OjApD
 6AmzYlUCdk5a03dx12ULLFIMlljw1An6/1SEyWWsT+GWAoMJCpMbjenflOc+bk02LhJi
 0Wag==
X-Gm-Message-State: AOAM5314uie0M4Yt1noWo/VpkhFG5Ct1wLuj7IVch7ObpKuk1qF4wjCK
 0SFQpTGbSSMEC+7m9MHGPKrpwoiDv47i
X-Google-Smtp-Source: ABdhPJyLk4QgmytoSzKirQaQHCryllAwONOUAJ9rKEqFuwJe5coEC6Nmu0X3brEpwZMn9TH/d1w9gy2iCB0z
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:61c8:: with SMTP id
 v191mr1965131ybb.472.1631658693708; Tue, 14 Sep 2021 15:31:33 -0700 (PDT)
Date: Tue, 14 Sep 2021 22:31:04 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-6-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 05/15] KVM: arm64: selftests: Add support for cpu_relax
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Implement the guest helper routine, cpu_relax(), to yield
the processor to other tasks.

The function was derived from
arch/arm64/include/asm/vdso/processor.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 93797783abad..265054c24481 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -122,6 +122,11 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
