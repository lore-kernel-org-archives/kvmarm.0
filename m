Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CDFC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B57C4B14D;
	Tue,  3 May 2022 23:25:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ILPhmLhF20rS; Tue,  3 May 2022 23:25:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E7E4B1F0;
	Tue,  3 May 2022 23:25:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FEC249EE1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0bvjCGWD1KQj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:03 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 193914B1C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:03 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 s18-20020a17090aa11200b001d92f7609e8so54140pjp.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+AoiNQohcEBqsbFrIdWlY/jTmle8ckchXi1SWA9QWT4=;
 b=kav6fAe1UysMDmLFspwmQhdq94eATQWRRD1D9FV5BfsaCSNOmOrjNgw6Ih/qFB2hFP
 KkA0WphPrzKlAu7jLnUAmQlX9FxYxSL5XR/uR+7vhqMeF14/CJ1Lt7Kk8/RxOE8/HMsv
 9JA82R2w68LQCsjI+e2gky3CzbW1HNlOH5uc/fpUkHWRQJ9nbE4Edyxw55yDZ4+3d6AW
 5DowfDS5+gFo08tAcOKj+dsadR4mQG1ftNfhXsKGd4iAq4zK/Abw/PW3qZYMuB5D+YT7
 AtmKcQmParWgFNt2qlDPmkDx4K/08wQcTSDWA15Oj5c4uttCowpHBr0chaueffn/vOC1
 S9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+AoiNQohcEBqsbFrIdWlY/jTmle8ckchXi1SWA9QWT4=;
 b=ooEIcxjnmsl9/sECjUImGhETMjr6jO4Br1MPtRzFQj919nx3oq+qy9PwWYbDjwHppg
 vn/JH9KptLQke2F80BEWMCHQn9x3YvbDSIUhBmIrzZbHzXweZ8sRUrNatlCdg2pGjNPT
 WNPmk2do2ZkLYhgi/4kqSx5ceVoqbr/sS4v/As6m3ZmnOXgOeoJBHxkkjC46kZfbWzna
 +iKM0yQ054FMrvni9QGKsxVlz2rEGiOFjOrH7t7OYksppZRkxbP9i/JDigPuHF77zH15
 ocB4FTXzBKWjx+O69hVoT1F1InxAjMEONLjsyf/Rq5SFAxtq9eTVqF+q9kZ5+JGk7LkJ
 JfuA==
X-Gm-Message-State: AOAM532mxQkxAeJgPtNGFIT/LkL2yelwKCR+MiK35mQ5N4O0AIazwdj3
 Z/5FAjUMPgZhzDOQ5Tdnj+kuG+YHbMf5OWDtCP9Vu90Rot5a0ig5knDaY6E7lUoWa6xMmuOfDFt
 qlvO/TgWWwNnDvSBR6BAuUUFJNgA3CeewdhsE8QhAzzKowE/+KEQkooRncF2RE7IQW2UqzQ==
X-Google-Smtp-Source: ABdhPJw5sIvY/+awP297IVop+k4KJmX4BmEL6dH1itNwUhQj0x3knFEX3fPK00huIqDZftTudy2YPYs+Wk8=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a02:197:b0:382:a4b0:b9a8 with SMTP id
 bj23-20020a056a02019700b00382a4b0b9a8mr16376625pgb.325.1651634702101; Tue, 03
 May 2022 20:25:02 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:39 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-6-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 05/12] KVM: arm64: Return a value from check_vcpu_requests()
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
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

A subsequent change to KVM will introduce a vCPU request that could
result in an exit to userspace. Change check_vcpu_requests() to return a
value and document the function. Unconditionally return 1 for now.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 77b8b870c0fc..efe54aba5cce 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-static void check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   < 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
@@ -678,6 +687,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
+
+	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
@@ -793,7 +804,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (!ret)
 			ret = 1;
 
-		check_vcpu_requests(vcpu);
+		if (ret > 0)
+			ret = check_vcpu_requests(vcpu);
 
 		/*
 		 * Preparing the interrupts to be injected also
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
