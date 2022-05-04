Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F3EC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 785D14B1A9;
	Tue,  3 May 2022 23:25:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kH2Wkq2ejcVK; Tue,  3 May 2022 23:25:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A73D4B21A;
	Tue,  3 May 2022 23:25:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7376849F38
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 39O3BC0ch1FD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:09 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAE994B1BD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:07 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 a23-20020a17090a6d9700b001d60327d73aso2257500pjk.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NIhRSvo0alW8fiKrqDE7euXam9U1frIcI+HOhIjC5O8=;
 b=V9xzQvDqrgHvUdtlyGb5v/iPWp9z+JbG22BBtUhVm7fyagF2xY6KyS3lsxNnwitDhr
 z3fPMqY+Hxgp3n3KJ6/NkeTVfPNk0jANvZ+RzwjqD1Yjm6mqbmeK6ea8btwbNh3x/FxU
 fzr7bD1CZLXo1/bHQsWZMCV7PxcCr04fSzHG/ShHKKjvhOVDOXe5TroOr0vLdlJS7pVU
 6VjnjfXssAZQztQooG4OSmqBsMVWCXFSylsqJtMfXAbQpkA4YAOX3RDwAuSAZShXxoyR
 4PFdqBp1rUgoZhGaRwS4c6dHRV6luP7fXCGVhPvYI0uqcFYk9tcxSpWJFEjnJIqjkYdL
 5kTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NIhRSvo0alW8fiKrqDE7euXam9U1frIcI+HOhIjC5O8=;
 b=mOguc69F/F+9AzjNuRFKJ2Msk0uiEC2NXyvXmT6m5kj9s4opQanfuSi/NU9h2Ayl84
 NMFYPEmQhec4t44VlqDAqWMdv5NgaTGXBsAwfij4UDfelUJkDoh7vVcJZMsgV6GPG9gL
 qQfbyxOu9YLVkstT/gt7Z4mu0yUEji/2ffmlMumAaWnThUxEA8kj8Mql3az+UCbbV7Fs
 gbbTGirYLcBgD3DA1qGmZDtHxcZ6eghGrVntYoP/LeUdWWSaIve3nI1ZTjcReDqid456
 HMRvTrnycXU93rCereGlmLQWKzCDfg5bvAdmQQeGeCO5MItf9OuaFWhrxleuTFUQSRIy
 LLMw==
X-Gm-Message-State: AOAM531Z61lnQozUtk/2/ymo+46iv23yOh23rFeIk+mn/La8aAtdqLXk
 stQRpqUPW2YF6P+DRYkuw2pKuZgr+vB19BtPZaVpW6z4MLkRutAQaHuuSfNCHrKYMOg3ZAh7IgF
 nMSrJowQXatAgWdUJZCSTn0fEXrZ/sSZIXyc7dXo3oQocr4YksST8nrAhP2TxtSV3L1/ZxA==
X-Google-Smtp-Source: ABdhPJx6qcRBndYRKLByoCKibt8KPKYbnYrz0DVxKSNCmNZ79ySqr5+Cv2YGUkJVJo++YbHWCUuOmNESmbU=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:1995:b0:50e:610b:5e53 with SMTP id
 d21-20020a056a00199500b0050e610b5e53mr3997389pfl.37.1651634706895; Tue, 03
 May 2022 20:25:06 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:42 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-9-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 08/12] selftests: KVM: Rename psci_cpu_on_test to psci_test
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

There are other interactions with PSCI worth testing; rename the PSCI
test to make it more generic.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore                          | 2 +-
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c}   | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0b0e4402bba6..1bb575dfc42e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,7 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vcpu_width_config
 /aarch64/vgic_init
 /aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 681b173aa87c..c2cf4d318296 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -105,7 +105,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
