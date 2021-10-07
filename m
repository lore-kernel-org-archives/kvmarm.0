Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809E2C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2875A6137F
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2875A6137F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE90A4B261;
	Thu,  7 Oct 2021 19:35:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UeZQ00GE1hIf; Thu,  7 Oct 2021 19:35:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE484B2AA;
	Thu,  7 Oct 2021 19:35:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B52FA4B2A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YBEMF6nkbvNy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 19:35:00 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0C6E4086F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:34:59 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 h3-20020a170902704300b0013dbfc88e14so3936308plt.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 16:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QCcnWTVJdJc/WAVPcR4BCLp4hc0ky0D9nmZjxgNJgVQ=;
 b=J5Xmgczz4lCb1dmoGGK6T6UZMU3ZtPCtrRXDQAc6dfW6LAwT8mz2PBkLySX1KSf/0g
 iQZqLnqge4KAsH/UvJmnm/n3CQOLLG6pAJ0Cx5rukprVcc6cwYVvpz1bOqENfeEaaruC
 X20RMPoyACae29WQ+cawAHGZUYS82Efud+HKLHfSPV7Fl3rX+lDN94Ld9EwLH5IRfDEq
 pk9ZtxsGNPChSqqouYSArHov4QBv8UxeeWA7gIvtLlb1k9ECUSkk30AR+dZfbUZyXc5z
 fkn0kyfE5037sVahR8CYLc/NjJuhH+AeLPd+7KRl0+Bg6KW4twZcZJQpKqPUoIIgeyjP
 JE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QCcnWTVJdJc/WAVPcR4BCLp4hc0ky0D9nmZjxgNJgVQ=;
 b=ADpAm1ccNPcBZ44SeWcDOGAGZwMcGIIf76gcdSxrAaHx2j9AhFLGCvvgiKzHbcjNZ6
 q3IwknCZw21MRFlDNP4bxB73vBCmJf8JpF3ZnrI891ei6Nx0VwJwXYlC41TDM85Fi0R9
 0GgDnIZdjTgDe9Kbn5U7HZ6jZGPhUBAnBXmmnx/MY1t6JEtpDrESVhZg9QIuIM81cyTE
 Tl/uZIjnI2yzfQSfdySFcRvB+ZkmMzVqt8WqFJNMTGnEK79/IXYjMFp/z6lflEF9GTVe
 aiAPtzwCl26QyWVq+3IV5KitTmbZr0Gjw2RksgtS/5zCmoITPWVbGPgSfUI/lsSvNgt6
 aMEA==
X-Gm-Message-State: AOAM533XICPhmdlzKh+Xne8E+j6LDrml9cWCklCYCIyGUC7o9Rz0/hgK
 /FQYpYb6g77nlMjKGa+cZUIBQpmCpKa6
X-Google-Smtp-Source: ABdhPJyGGErVlG3DR0iUPDgUz2iB0THZPL0Jyz4yWpFGkWw4/28sh4UQq1A0wYRTefCNFOZlSuAEIlv+DBxt
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:a3c1:b0:13a:47a:1c5a with SMTP id
 q1-20020a170902a3c100b0013a047a1c5amr6510759plb.13.1633649698763; Thu, 07 Oct
 2021 16:34:58 -0700 (PDT)
Date: Thu,  7 Oct 2021 23:34:29 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-6-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 05/15] KVM: arm64: selftests: Add support for cpu_relax
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
