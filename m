Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D128C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FAE561167
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2FAE561167
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD904B090;
	Wed,  8 Sep 2021 21:38:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mk+OzMifRZWB; Wed,  8 Sep 2021 21:38:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D39E44B11A;
	Wed,  8 Sep 2021 21:38:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7304B0E2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4GoETi4FVVEG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:38 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDCF94A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:37 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 q22-20020a63e956000000b002524787adb1so161158pgj.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gnXKJQdV0c3R/PtxS6JEuqPswo+mI03RfMS+GJY9V2c=;
 b=qovCNdObk9hAYj5TRIstPpudmx6SP1gE3xKWc2RIyrpnrPqHTaRlABxqgUjn2zw7rT
 vEidP+eM7AUJIEqMeJgU88+wfjlSHF19U/ZiK9c6aesOhSvvkl4oRIUjCOTHPGyEZWay
 I37gnbfuZr2v8I5I5mxm2EC0V8EZ6yK+qOAnp+jtr324k5m51nzdTq56dzoHMs10+7zn
 8u22Sqvehn7ThNOUO7HAFN5kRqbI2jP4+7K40fB+qnINSr4lmHmlxbbzeV/WnIy1E+x6
 R3gWMpaynW+uiMBXTZa/08/31Czfo6HEvQtCL8VmjI/Mf0dUE+Al2Qvm46MSYSaI3WGq
 IYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gnXKJQdV0c3R/PtxS6JEuqPswo+mI03RfMS+GJY9V2c=;
 b=vD13XvZ6fjmxyHRmpmanECXAsVnBQPNsuj+G8Qf44G+hSSgvP7grDh6y7q2RYB9WTR
 fzyEZ+kpCa67vmfZUm0N2NXkMD7lpm8wasl9nQfD8oRHCj9EsSasoXt3d8DIVowjZf0D
 GrCQIpmPwa4C9FnSagjXMVFzwKuWmvsYxVf6ZZkrq1OWzrHFegW3VN6YTdDeDgVX2Cx6
 38d3m1o7n2/grW8+4y3uVlxTUHkESPN0epxClx7gBhqEmdDC1na51EAhm6kIqrhzcVQF
 XvTD2zO4UDxeBC6Rx+T5CUKAl5jiuvq9dF4apnX8U6PKNUJDPpWIyWmTnBolaOBwTJsd
 9D2A==
X-Gm-Message-State: AOAM533mQsrZnL8IxN0VClpDY6mYD2DkBJ2cS45nR0265T6hFBNDcVp4
 RMNnS1LJIg+BTTNvqj0i5Uyxdpwg9DuC
X-Google-Smtp-Source: ABdhPJzYobbwdhjyH3noMxa1HCPANLozf7zYs5UxTopZ642KuVhxcHxiSRq8EQ2ySUHCdPtjJlAquY0U4s3l
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9693:0:b0:412:448c:89c6 with SMTP id
 f19-20020aa79693000000b00412448c89c6mr616147pfk.82.1631151516895; Wed, 08 Sep
 2021 18:38:36 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:05 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-6-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 05/18] KVM: arm64: selftests: Add support for cpu_relax
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
index ac8b63f8aab7..166d273ad715 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -134,6 +134,11 @@ void vm_install_exception_handler(struct kvm_vm *vm,
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
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
