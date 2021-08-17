Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2AAC432BE
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D06160F58
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D06160F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39ED84B145;
	Tue, 17 Aug 2021 04:12:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O7dqRO0bHDBN; Tue, 17 Aug 2021 04:12:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D494B19A;
	Tue, 17 Aug 2021 04:12:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00C6A4B181
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FzBLh6zDAr92 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:12:10 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DBBE4B156
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:04 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 s4-20020ad44b24000000b0035c77ac6861so11630292qvw.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CiI5OAhgkZ42MHJT2zFxCH5sP5MyitED8/DF2mknSW8=;
 b=N2qruQnB57J1upAsUBNREhuAR3StiZe2QzZ5sJCUFNr7a3zSqoFVSMrJWMj6bHPTUK
 sVdDMSI+dJ/2JRgJ8G7NYagBFHT+BsSJASB/c9Y9FZjN/j1EhQL8ZYFI4QrA0gDqs0jC
 2elLEehk23jjYdR5Hx9ZvwyBJA3KuoaOl8qY7/L784YKX0c0FHWN+05BCelz8E5rfgYS
 9OXpPNBscLSGqXjwGNMw8ANyt8vZVJGLDn81YtH5QtnkigIIlnlB/oZD6JA5no2Yliw9
 UaUriYgFKVvMl273Yj5Z1x3GVVDTMO/Ctqzlkz4vX+gat3oxvr4o7/kY7fAK+aF7UkLF
 u4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CiI5OAhgkZ42MHJT2zFxCH5sP5MyitED8/DF2mknSW8=;
 b=Cl5zdFxV5K1FnU8OolE0IJyQgcvr3ZXQfq2dg7BzYfmKGIrJe0hmjaQb3WLlkg4qS6
 N6Nn9LH1z8FC4rQb1+aOBW6kWzszE2xd+E2jKmGcKP9I2No48c9+AI64D/PqwRcjhP6f
 +I8Nclq9DF+6GPJFqkAXlh4UglZZNZuIJBQED0DbmwfUoHZz8H3dMEHqH0snlBDHd3dA
 jTtflR/Tv7cMONJB0C48fkolExO12vHVhYQyACOMC7PVrQuAlusa0rvrvhcjYQqHtKNV
 WCpMHM/cA0rk+BQMT+7mM9sgvkvbxZitJj8JF8RIFxe5SaOSZ3YAWvEC2w9Xxdta13Vn
 Xy6w==
X-Gm-Message-State: AOAM531jh78lFjZkI8KwNbE4hUQLRUudKzKW2+rcVWHg/2pJO6rnMtoA
 Xzgg2L8KQYQNgKMbTSp0yqimaL5apNtWA5p9IYMF96AjNd17tzhl6zamAtxOnOp/sAOdo8Vg2Su
 97zxLsCoVWI8bk1gFcAbvUf+6BJ/9fbxDINT4bO8qfgozy7X0aXRxejMXEE7fjVVSW2A=
X-Google-Smtp-Source: ABdhPJx3EYuucuTVJB6wfR0mR5/W7Jcy3V7XAywnfoLLIN/YNpK/SPf6PSNDn9Ub/h9uKoQlJkPSo44QGg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr2134781qvs.58.1629187923801; Tue, 17 Aug 2021 01:12:03 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:32 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-14-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 13/15] KVM: arm64: Move sanitized copies of CPU features
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Move the sanitized copies of the CPU feature registers to the
recently created sys_regs.c. This consolidates all copies in a
more relevant file.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d938ce95d3bd..925c7db7fa34 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,12 +25,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 static const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index cd126d45cbcc..d641bae0467d 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,8 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
