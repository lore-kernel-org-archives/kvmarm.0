Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B0DC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:42:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3BB94B118;
	Thu,  3 Feb 2022 12:42:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EsaOjkPYu5I5; Thu,  3 Feb 2022 12:42:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EC664B133;
	Thu,  3 Feb 2022 12:42:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2E84B108
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7VClCXzfwAiR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:42:10 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 751784B174
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:08 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 k2-20020a6bba02000000b00604f85cceffso2427811iof.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Feb 2022 09:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=V8BbjeU/NUjuU0PC2phaUtgSmpC9nGD4vm8lUsINuPc=;
 b=CquM8kVvpzZqCsqd3uTsfb/Kq+NX1L8Btg7Y4cIvmQCfpvGHXwVLO/7lenwDXHB8eq
 +zPvw2EGJWYdyXqu9YhkKlgMvyeX7KCDkq5pI+qkUQ5te6Azs6NyvqIERfSxZxAGSk3P
 wDkIuA/Q5meKfi+a9mjf2y7mIR7cjKwYlWfwd+PxKQaDDnBl2nkoaKd4IfwZ7MXgV7F5
 ASwYXKF6UNO7gZbDel/rBRqKxvbvPv4X6fIaSjuHTddVptehyzWbzTtEydDY5/AkyKF5
 yyg3zzFZdpU7Cs0gcfQMUq/U9PtFAdV612z0aA5iGaOKg4XC6TqsbxXnBSvR+InZy+8S
 phWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=V8BbjeU/NUjuU0PC2phaUtgSmpC9nGD4vm8lUsINuPc=;
 b=ZMs9ytCAMWiKAEaKE2SG4BaHAy2j/FoofCTu5HQ9u97fJxV1eI6koQmktkIN+Zq8jN
 BoaSaklTmsKmNJONKHwU9p5QJpxkpBg/co6GBaEcuahOLUVoz5+7yvm8ZKCJlFJ8zmuC
 c3+kNijzV0QhjGndYSvKdTbds0sx3pQg/WkmUebhuSLzMsMN/X8SQwaSCpBabKoxUmAR
 4rqZq0nVnfUQL/0W/mcJY6CX+Gx7DmjanpwEwSAc7XSMLAtg6byDSRuqvl45+59pyhzd
 mJF1KEdiH6EY5NB46j3f5qvmA7Adr2XLgBj8hs4HbRLuLcPpfWqzgcNtnArnhHCM/Iuu
 jAZg==
X-Gm-Message-State: AOAM530GQrRkB7puU/QdmbqHVBWEvA42aX0O5LcSdrQLg0IaU/GDWqaZ
 sPdb6XwTojtSA9VEYtkHmpnRoiA/belKn2kus9fKuLcprQcEfdauovPNNRoUlLMLTkQgENgzzHh
 ihsqd5lcD1giKIygOQqDR695EqoroZFlm7uhR2kmnZdBOU2OJhcBaXssvcKt6jZ5ISURmcg==
X-Google-Smtp-Source: ABdhPJwvty3JHxDSDgNiODiOwQlb6U16qNxJc1J7l+iM6Xi2RAAcYFElWAr1Q86A+cSIHHHQIY21vcySbA0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:c24c:: with SMTP id
 k12mr9848406ilo.45.1643910127829; 
 Thu, 03 Feb 2022 09:42:07 -0800 (PST)
Date: Thu,  3 Feb 2022 17:41:58 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-6-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed
 regs
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

OSLSR_EL1 is now part of the visible system register state. Add it to
the get-reg-list selftest to ensure we keep it that way.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index f769fc6cd927..f12147c43464 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -760,6 +760,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(2, 0, 0, 15, 5),
 	ARM64_SYS_REG(2, 0, 0, 15, 6),
 	ARM64_SYS_REG(2, 0, 0, 15, 7),
+	ARM64_SYS_REG(2, 0, 1, 1, 4),	/* OSLSR_EL1 */
 	ARM64_SYS_REG(2, 4, 0, 7, 0),	/* DBGVCR32_EL2 */
 	ARM64_SYS_REG(3, 0, 0, 0, 5),	/* MPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 0),	/* ID_PFR0_EL1 */
-- 
2.35.0.263.gb82422642f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
