Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75463C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FBC34C3DB;
	Tue, 22 Feb 2022 23:19:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5PSrOjNoWGVd; Tue, 22 Feb 2022 23:19:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4F984C3EF;
	Tue, 22 Feb 2022 23:19:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C314C30C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I7HHGzB4eU7F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:47 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BE314C2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:47 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 w25-20020a6bd619000000b00640ddd0ad11so5865557ioa.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wVJSZRZwihrGXsYBdQrl6MVYBmihMEt9qMrxhWCnPXM=;
 b=N/JCXhOQbZYBtBap29e0M9kthtoVctwJ3DWY9n2yCxNcrsh71ds4U8uyVEgHm/j/5P
 uDWmdYQuTo/8LK9xaR6tqWPtyDm41EL6yVK6uQmhvwMkI3ghkwLuB2HFxzaoSBVB7Xgi
 PjH3fMWodmUAnyGuivMpQOHxD01Yio7g9K8mJQhvCMQ20+qWOMh3PA9qIAFbYoishMP/
 n7OX0dn6R3LWXThUMB4RHLzSxlCyOI13gABtaFlGWVkI6sCzUPcMvRNynX1VVQYqLKb4
 5lEfU/gopvUmZZU94Vcc2qTVZ2ylbc8vk2STfUyrLEYL+H/HZ0DiKswbxaA/yXe9HpPz
 pXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wVJSZRZwihrGXsYBdQrl6MVYBmihMEt9qMrxhWCnPXM=;
 b=CG2N20jhyS06Nnf7uFvq7hqj41VCm4iBgntr2DO4uRUe0sxtOG6LwrLid07r/jwTHy
 Jv5OGqCxtAlBuzIv0d1z9vhCUqbeHmyQU/R09YMpFChLZKelWuDAFO5P8u6ylrgHhyRx
 mT4xBkjPP9VOoJqzbLQb5yvSAGUrANxDO5B+x2+VGhD8MbAr5fERK0i0V9kkdwaYq2Sw
 gF5RYfzGLpBd7Wr1mkauh2KMX2mVsFZxn5gX1y59v7eDjUpXm6qqgFk2SdZf3cyb/9Pl
 zKcWiu21X/g66LanIqDmgALJsURVQ5pVhRVirY0SjppVEqcDMG7ZNour6TsMBFryUeXI
 Cy7Q==
X-Gm-Message-State: AOAM5306TUMZf0JMtg4R3dFMxiCNLOZrFuvQ5BcEAyMzgRuSthne13yo
 jwbapWpkkMePpbYn/FKgL0Yiebuih0d8Ud2Iv54em3aL/4vS1mE00ZTlFuD0Q+gnwJvgu+cRwrW
 AgV84uNT84xHdJ9KLsk7BDTSkP4rnaJSqB706JJmv/fIEl4LsVWj8YufgRKK5f2BkXiNS/Q==
X-Google-Smtp-Source: ABdhPJwoH+KbUWMS62f0vLQp0EEfYidZ9n2pGeH/otXeHZB0fgbVAZB0q/pMxaHf3iUu51F+xuNUW44FvvY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:661a:0:b0:640:dd42:58ff with
 SMTP id
 a26-20020a6b661a000000b00640dd4258ffmr11611644ioc.64.1645589987008; Tue, 22
 Feb 2022 20:19:47 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:36 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-12-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 11/19] KVM: arm64: Return a value from check_vcpu_requests()
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

A subsequent change to KVM will introduce a vCPU request that could
result in an exit to userspace. Change check_vcpu_requests() to return a
value and document the function. Unconditionally return 1 for now.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6af680675810..f6ce97c0069c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -719,7 +719,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-static void check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   <= 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
@@ -749,6 +758,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
+
+	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
@@ -859,7 +870,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		update_vmid(&vcpu->arch.hw_mmu->vmid);
 
-		check_vcpu_requests(vcpu);
+		if (ret > 0)
+			ret = check_vcpu_requests(vcpu);
 
 		/*
 		 * Preparing the interrupts to be injected also
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
