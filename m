Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AC3C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 04:00:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B440E4B641;
	Thu, 29 Dec 2022 23:00:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LtY156Oc7A7m; Thu, 29 Dec 2022 23:00:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8134B64D;
	Thu, 29 Dec 2022 23:00:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9936E4B133
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 23:00:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZlxmfycmnAYX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2022 23:00:28 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 956554B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 23:00:28 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-470d4c948efso152856897b3.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 20:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=yQL8LpFQbWC/4XZqubGHc3h5rf9RkGEx3SeQGahZOzI=;
 b=n+I2UUck4OlTqPy8zYXZ+xx/sIHj/NUhsraDP+JLn0MWryS27ueidGVOObK6RFGIwk
 BL6kbLfQLA6KOWwK/h1q2OpjhInRT7uNChsTZ5/PeTLsJCvsdDOxa+A2jCHpTinNJ36o
 4AMQUVLsLbIMbEvDGIzAH1yA79wByfLwDHDsMUrSYeb8+6im1q5TQgy5cw8HdrV+c7Zp
 GSl4E62BZMYznQzrGz11QM5NRL0h7M9r5fdcQMXfDnMsWIAhhGAPJcg2S3Hqn/uIIpyt
 yO820vWLVAzXwwQGgmhGRNoyqLCDoN8Cz8dERHFNmTgEw+U1IRdEHsHBMDezxOFoydPC
 8bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=yQL8LpFQbWC/4XZqubGHc3h5rf9RkGEx3SeQGahZOzI=;
 b=oW3YtDgGNP3eDLbn4bBIc7T3Z7vp/6WwdK92rJPMb6Ao3O43W6Ej4NJPSkMArj1kee
 i7/fxJg7ln7bvN0cJelke25/SnE9SPQ+IIOPGmM8kJte5WVUAVd8OG6AeYYfF5Ki1/0Q
 R7IbenafRY12B8me0oDGhUjVYuKA1ZNaTvsHzWXl6L7CTfrY/5kgXvZRaazLJuX3uX1Y
 tZxVZ1KnpN/1zebpMvHJPuZd/Z2cAWJwolpPkWrX9KVSy5RJ37+8WJ85kv4wGeFLylcO
 w7RPgHuKxlaQdtvbwwg6+NhG5haL/0/7xK1JEJXNthFR3M4nzG656BimUlKRg0kLi5Uj
 9WzA==
X-Gm-Message-State: AFqh2kpswdWQaRhF9p83pwi0u58gux4cjxRC2Es7aFZRlOBjZo5wOo3f
 pb+uWgqTvYcBkxw7j2D3gimtmQUDSnE=
X-Google-Smtp-Source: AMrXdXvHWmdW4POEvsJkJXQsrQc//66oPLiXUgTOK4KT6ispQGJVgdJ41r+5ZfWiIhEAIgPbKE8yYf9Oybs=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:852:0:b0:711:6d3a:2b9d with SMTP id
 v18-20020a5b0852000000b007116d3a2b9dmr4131790ybq.133.1672372828203; Thu, 29
 Dec 2022 20:00:28 -0800 (PST)
Date: Thu, 29 Dec 2022 19:59:23 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-3-reijiw@google.com>
Subject: [PATCH 2/7] KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0
 and PMCCFILTR_EL0
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

The default reset function for PMU registers (reset_pmu_reg())
now simply clears a specified register. Use that function for
PMUSERENR_EL0 and PMCCFILTR_EL0, since those registers should
simply be cleared on vCPU reset.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ec4bdaf71a15..4959658b502c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1747,7 +1747,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0 },
 	{ PMU_SYS_REG(SYS_PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -1903,7 +1903,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
