Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAE8C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1239461107
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1239461107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B983E4B207;
	Mon, 13 Sep 2021 16:49:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y+f0xqsms9bb; Mon, 13 Sep 2021 16:49:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD2104B1ED;
	Mon, 13 Sep 2021 16:49:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3FE24B1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id keEH1SwlcMB7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 16:49:56 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A95794B1A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:49:54 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 g15-20020a63564f000000b00261998c1b70so8041322pgm.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
 b=jXfd6Ifbv2PUpHnXkJKAouWhIx2rYsNCCmG89uNRrOlOzCsjeYdmZPzk7mQuLwmR6r
 HOnftjjdFpgdyeyrS9r1+xeyl+Z5dbnbGGrObV6o+HbKo1FTge0yKCDMgwpOj14py+V1
 BFJnXQbJTaKi2YgBbos4ghKJeyONx2b2NwHcB1YLf2Ijco6HnidQU1ZWLXg2T0xYYU9o
 aAJIP0FW5mCUmEVJD3qU1APMqM3FiNktBmol28OLolIw4CyTzcnpvwgA1ZDMgNYpUokQ
 UkGiNSM75gqzCAq7jQEGsroFKM6zUAUvJ1nDq6vWGlhJj7QmBIuX2XcKbZcz1qhZ+1NU
 FCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
 b=aybQOjOmRmwENvEqhoOVZ86KwfRJs7CF/rK64R9MZtLjICw8ze20U0JWv0T+bmFP0D
 ZIWlOf66ggxFVcErwLZk09l/0B08rb0zTaT6TsPxEK0FBlLDXrFAib0CDh41MRFd+Wfs
 UxgClLvIcBOTbmSGRV+2iumArGo1KB76EOKvuMRYCxSZD1qY9Jsln7OCP/idReuBQGv5
 ciORuS2hlUYnxko/Nj29zQT/nsu04EW4lDl4KW9YQ3xBEKT8EOIRE+l6lEHKi/S5ru5i
 BCAzzcc+zarRUkLEquqxmfxdh0tcwANwtFgpPrQdZtxPLCaMymKqKx+W1ugiVJ49sGvr
 BSmw==
X-Gm-Message-State: AOAM532GzvxuEivviFdT2i9qOUP+KkkpcO/69V515gcnDLbP14cVzfeU
 MRhozd26Xvi1288BRdM2LhRuPr5Nw1Pm
X-Google-Smtp-Source: ABdhPJz6fEdV2KzMR0VbG5Fihm2AW9Am9+ncpGXvD07/3wOpr20Yhs6cZzmeUf6DUvnyDHdc3aA+w846Q2BW
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a63:6e03:: with SMTP id
 j3mr12719146pgc.465.1631566193824; Mon, 13 Sep 2021 13:49:53 -0700 (PDT)
Date: Mon, 13 Sep 2021 20:49:21 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-6-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 05/14] KVM: arm64: selftests: Add support for cpu_relax
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
