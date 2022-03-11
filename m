Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB65C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F16B49F09;
	Fri, 11 Mar 2022 12:41:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YmqEK2F5IEuq; Fri, 11 Mar 2022 12:41:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08D8749EE1;
	Fri, 11 Mar 2022 12:41:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F0E49EED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ItzqIj9O-mw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:15 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2F7740B91
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:12 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 x6-20020a923006000000b002bea39c3974so5972685ile.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ueuw6G3CB3aC6lh20NpaqUZj77A7koOiFEWMjHH47o0=;
 b=emHdHGZ7VoMCVW+tBvbqRBR3shon8hDPVzTreGlVv0x5af9H5PaJYsRQ6qP1Y1qg93
 w5su+HLqeZpGjfPiHTWt8cz7N9M1xzHGIRqxVGK53Dbo3fXYn09/n3m7dwpP4PStKOFV
 vKmJOfUA3PNgAzQ6nRKcN+/xUMG9aELEDVogerM/pfhhqw0bXSlpdCLTWWSiFroD+1M+
 SCOvQdmhyzJsmCRuid+gZ/AH5d0e2IpfPzImkHJmNA4JqXhT8ezksrnvKA4iDLHWaiOj
 ouxq8jazGhLAgermQ4RF+EoaZcL3nrP4OM06PQwBMBoGqqyfSDChLR0RkOGXRj8e3Nxm
 8+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ueuw6G3CB3aC6lh20NpaqUZj77A7koOiFEWMjHH47o0=;
 b=R+sX/6XUE+FV/UbuJCES2kds7CPQMQUN4gL/Ka8t1wmqrWW9SSJiOaTcEADv+W4yfi
 RT6alQRz27rTFXT20D1njtXSKCuAGECOf+LvSvwfHST56mnnfkJ6goONLl0hO5Rp7H14
 8pP2EXQ1lub1lXiO/W3hrFnywfzbLFt8imRQRQq5FyiR3Rb2Qpj2jQjBRpjJ47GyMThH
 YX8nho6oiJhg3HYLK2+pMkYKccD78/ZO5XejZrlw4PuZwvGNaoLbuwHEP4/Nmb9hvwt/
 LR9hWBxoRrSH1djlVOdBDpY+KSg4fhWn8IF5z1wDX5gBnTACkMT2osMHmNdTRevcu09/
 JIMA==
X-Gm-Message-State: AOAM530Zp1UJqEjpfHkH6de+Qmt2UxLPGUg5ZjbSl31tXwFETvjX5C7A
 Dw02sIVjHgDdsIEjJhQLdyfiCVMN4JU1QPpwDtC19ARBL7k3Xowrawrx+J5+zPjbDrZWiSD+nUr
 R6MuPeYdGYZgvA12sPrvyIBE/YuZ6VCt7p0M83JvKbpXkqNGdTUdNvVkG2Wjhl1UQhNTYlw==
X-Google-Smtp-Source: ABdhPJyOYB8mAhfnrE18fEDSYqH98DncrKtJHVGBq0WqibguhNJlqPsHtU7nCGpfqDEzzx7hzv9FxNaDErw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:154b:b0:648:cab0:aa72
 with SMTP id
 h11-20020a056602154b00b00648cab0aa72mr1961053iow.33.1647020472189; Fri, 11
 Mar 2022 09:41:12 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:57 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-12-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 11/15] selftests: KVM: Rename psci_cpu_on_test to psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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
index dce7de7755e6..ac69108d9ffd 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,7 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vgic_init
 /aarch64/vgic_irq
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..61e11e372366 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -103,7 +103,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
