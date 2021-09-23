Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2B3C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 22:00:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EC7E61241
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 22:00:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6EC7E61241
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D28A14B166;
	Thu, 23 Sep 2021 18:00:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ss9q9rqaMb-Z; Thu, 23 Sep 2021 18:00:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E4C4B0EC;
	Thu, 23 Sep 2021 18:00:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 069CE4A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 18:00:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7aceburlAmz8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 18:00:47 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F053049F5D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 18:00:46 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 q5-20020a0566022f0500b005d5f7603bafso7118102iow.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=f7vskvTE1f7g6j1G/9mcc6TBVgiYtYDQe3QIkQtPdlk=;
 b=XEkuJx54Rb2fmI8uJkqiTHQ2tWjkNQ24qlfvw6u7Ob8ElAf3Lc5eSH8CRLzb7f0tSt
 ZaCNiAa9jHEvvVKK+IfYG+plg1XoENH0epLflNzjsNxur8rFNJSS/ChXanxY29UxzBJv
 cDa+dEgx1vFHBYhiRGlvKnvd1C32EcB77qaRUu1Lu8mpZzcOerrElqnb2vyLQlaRDHXy
 a3NiADAsN/uZe4Htb5/PZ2X4NxHuNQ4e6LV5NkkAeGdhv202Ao3kt3KDoh4jSfadsz9v
 ARFJy0qtmIpQOykpuoV0CzdnTYzeH2B5Arb7Qb1mObyLfVqeaN5gQG12Ui+BvPtiiMls
 H7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=f7vskvTE1f7g6j1G/9mcc6TBVgiYtYDQe3QIkQtPdlk=;
 b=lxeqQRlQp7S9v+9T26GBwwFTKCCPElY47k2ueIjMG/edZnpJUc8tpo/I8LFMgih/rz
 FTwKT/dAk1bxLrECMD16FgTN6QtTshDQmHhq8EA7vizJgLDNntOtOestT4cdyIix1T0Q
 wN4fcfQZcWmzs7wjnx3yGtets3s4PzUl0+O2oZSaWXySPNpmtauy0naUe1cOsBzIhk/f
 YBewy/9AiBr3iYSTHBdUhMftPbDXyRD1DccYAetWVMwaj6XYeEi4AnICJj/B2lDRXSV9
 9+buB0S/BWBYNenbr5BgiDmlbNemHTd1ETmSk7Tzfg8oHdEJ6grBEgqa34ifZpIryI2I
 tmBQ==
X-Gm-Message-State: AOAM531n9fwhe5WiRIUU4JfrprDE01lq7WOcvh5KFI4qNps8dZeQw8oC
 pnj8Y04h9BxoP3UPpVVshKX0yG4hh3E=
X-Google-Smtp-Source: ABdhPJw7/ZOpW6kzLm/q1fD4TCKb+A42nB2EL3IA5ogaxCUNjeLVhemJc4/cZc2z+VIUYwwPmzi81WOKliM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:6666:: with SMTP id
 l38mr6063627jaf.146.1632434446142; 
 Thu, 23 Sep 2021 15:00:46 -0700 (PDT)
Date: Thu, 23 Sep 2021 22:00:33 +0000
Message-Id: <20210923220033.4172362-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH] selftests: KVM: Call ucall_init when setting up in rseq_test
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Jim Mattson <jmattson@google.com>
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

While x86 does not require any additional setup to use the ucall
infrastructure, arm64 needs to set up the MMIO address used to signal a
ucall to userspace. rseq_test does not initialize the MMIO address,
resulting in the test spinning indefinitely.

Fix the issue by calling ucall_init() during setup.

Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 060538bd405a..c5e0dd664a7b 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -180,6 +180,7 @@ int main(int argc, char *argv[])
 	 * CPU affinity.
 	 */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker, 0);
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
