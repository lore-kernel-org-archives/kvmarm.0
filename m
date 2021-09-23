Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC48C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F08761260
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F08761260
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4356D4B12C;
	Thu, 23 Sep 2021 15:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f33OUcaTXcy0; Thu, 23 Sep 2021 15:16:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 320124B11E;
	Thu, 23 Sep 2021 15:16:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA8F4079A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2WSOqZCWs8O8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:17 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D4ED4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:17 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 z16-20020ac86b90000000b0029eec160182so19391504qts.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=UCMYJurTFuTkCi0HgTfCB5voS1kc3wFR2T934tFa/Zw=;
 b=G3IeFE8bm7uUZsbXeSdob1ZhW9vy4lEwxbjMoMnJ/ggdGOjHFYeJBlrZ/BOqXzzZEM
 qX0u7YyYBe+/t26r2VKhI4LV5MqNOSqU3Tr8XzBJxQzRn7WfNy0EW3bxwaPxKS7LSqsm
 xZ7UIeodcMbXCGBuooPK+dt2KM+fgHg9519qV8DOah6lvf0UQp9tTXrIVsJbv68LeyTw
 ABS2jjrhuCXB8Yv2T9ZsW6OzsThl6b1xmGWcFdJUxOFpGqD00dLdZjdUU74XoXTOW8CG
 oBC+NucSCfdJpw6rfS+bS9SqwXichjKwCGbo5PnWQbUOZPSMFJfkO8xDyDmhLMnRHztd
 Fr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UCMYJurTFuTkCi0HgTfCB5voS1kc3wFR2T934tFa/Zw=;
 b=yWtxIoKXoBj8s6tal5WYV38EgWuoZ+DdUqoHBYVrXuE7+DYUPC35Bguo+zMcuT8OWW
 MqElByvExLxdAaqJ1bqJFDCFYiQu1cB4Z9JMdzR2hIxmimN4VgrnuP8Xa8yFBIOAEZeP
 f9EGqG3BkU1ZvMczUiL8T+3wCwoER6gBHggHKh5esAfmk7N9r5JP0gFed/M2CqEN5E/y
 WRhM/1ogXoOeOVMgrsNKc+tu+yQrquVmHkvTVJpacv0Aut0QISh7ASAIdw9TAtpNSXKJ
 WA+rrL5WkEkxEGIeszsK9kOYWEZccCBtypkW4KhOfsEXQv+0oDO/Sw/QpjKkuUWjFdTN
 6lDQ==
X-Gm-Message-State: AOAM530q0lhtoo+b7wWBlRnTR9NRdi3wzcmWiOfR0qx9EoM2R/dRY6uT
 kj5PfTguJlMSIzdpyy8Is0meTW4Wu3Pdogj9YbGmnWiBX/ppsGn9IeWTec1M2yEY8nk9XPw8WOx
 BdWfIYnWGweq5zwQKNN4cJ/5Sfh4uZFdhYMDF86mUI/66UjNtcGqX+1vGWQuIOSeWaSmIxw==
X-Google-Smtp-Source: ABdhPJxVi0BHEjOTgazTwOWIFtWnIaijjz0Tm9HsTJFcwKzjrq0cP/UG+fQwEF7wSEN7ptIoNhJ0GWQQG30=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:13e3:: with SMTP id
 ch3mr6061613qvb.35.1632424577208; Thu, 23 Sep 2021 12:16:17 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:00 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-2-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 01/11] KVM: arm64: Drop unused vcpu param to
 kvm_psci_valid_affinity()
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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

The helper function does not need a pointer to the vCPU, as it only
consults a constant mask; drop the unused vcpu parameter.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 74c47d420253..d46842f45b0a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -59,8 +59,7 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
+static inline bool kvm_psci_valid_affinity(unsigned long affinity)
 {
 	return !(affinity & ~MPIDR_HWID_BITMASK);
 }
@@ -73,7 +72,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
-	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
+	if (!kvm_psci_valid_affinity(cpu_id))
 		return PSCI_RET_INVALID_PARAMS;
 
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
@@ -132,7 +131,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	target_affinity = smccc_get_arg1(vcpu);
 	lowest_affinity_level = smccc_get_arg2(vcpu);
 
-	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
+	if (!kvm_psci_valid_affinity(target_affinity))
 		return PSCI_RET_INVALID_PARAMS;
 
 	/* Determine target affinity mask */
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
