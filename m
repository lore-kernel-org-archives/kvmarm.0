Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B7CC43217
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:42:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 335504B10A;
	Thu,  3 Feb 2022 12:42:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x8rs8X8Zj-p7; Thu,  3 Feb 2022 12:42:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10DB84B12C;
	Thu,  3 Feb 2022 12:42:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE3D34B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJxxvcUn5Uyo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:42:04 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E4854B0BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:04 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 v70-20020a25c549000000b006130de5790aso7379766ybe.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Feb 2022 09:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=x5tD24Fm1rwvMTOsASLM22AFSW2OawoOEHLwGQ9pDuc=;
 b=VqO8XHbAyLJ2tZ/5GGV07Lv8+Otgp2b4HXEJpAWIswlWiwrdoqvi8vWs6wFL2jgD0n
 1Vej2KnZwNkNolZRflQhj+s0T1pg1WdwwIG+rGLP4BTyf/T08T7yN7C4SIaEdslOEPoI
 KKf+gUUGANaBn05ZhcDUO5b6rLCjXe/hkWpQtHlL1Aibo1be2J3Z8aHKvtJvw/TqstNU
 90SNgQ/dORslJNj3zwhSpWq3eer+0sllJSQ0Pfcu13cOXXr0Ps6siAOA/t65GUPkRzMX
 h0LgAjLbVvmwKg0CIovvOg5CKRhNrja/c3DzkWvXZDDY+pDaV3lqb36AM28U9Nx04Tdp
 XSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=x5tD24Fm1rwvMTOsASLM22AFSW2OawoOEHLwGQ9pDuc=;
 b=adOoieSEq0PhsfAHJFwgswDvzsEwaymrknwMeAIj92P3d28/S0SY2I686SxFdDB9w3
 YsV+GOD8xYSH3S9OE4rlYgeXuM2fjFUhKEnk4V0Pdo2kBEzP1r8hOd6WDiuE6fnGsp4Q
 PQBo0AIOG7+ata4S+qQ9XM77ANXl1jPkcIqs8rpi7JKdOtdz1Pbr1moNf0gkljN4iVHc
 Yl/Ovy7pHpKmjnV6B1nLXn06+Rv5DtAPhxNggUpmZKz6CifF3rlnxwKFNVS+pL1TfbuB
 055JeEj1ixswtQRmexLWzpJYFJBxWPUVLN6sCrp36DfO9dy5E5+gcvuAT54ufhYw9UWe
 X5IA==
X-Gm-Message-State: AOAM530bEL5A8IrSSi6vd3E90QWpjZPEGfNNMdJ41UwvJUQ1ifMSOO3/
 O5y5WujfI9lWo/Pj1bhMx1nJGuudhJaCjr8W5g4Q/N4Hn04GsnZQEj0+I4QyvJbT6HTkWRjP3o9
 UGv8GQUh8mKSpNXh/KDx60Ad/94CZy/BxNQjg+5sdYoOZq/t56IgyWveJ2Q5As0JiYPzcsA==
X-Google-Smtp-Source: ABdhPJzjipG+LZdF5GKOtsltb9S8zXEjr6pV/0RmHZ+YGaUkd3Q7Jy3LB0RxNWMlPEsYdiA5+sBM+SojxyY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0d:c7c6:: with SMTP id
 j189mr5174886ywd.395.1643910123903; 
 Thu, 03 Feb 2022 09:42:03 -0800 (PST)
Date: Thu,  3 Feb 2022 17:41:54 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-2-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as
 undefined
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

Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to
EL2, but the kvm trap handler for OSLSR_EL1 handles writes via
ignore_write(). This is confusing to readers of code, but should have
no functional impact.

For clarity, use write_to_read_only() rather than ignore_write(). If a
trap is unexpectedly taken to EL2 in violation of the architecture, this
will WARN_ONCE() and inject an undef into the guest.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
[adopted Mark's changelog suggestion, thanks!]
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dc2fba316ff..85208acd273d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -292,7 +292,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
-		return ignore_write(vcpu, p);
+		return write_to_read_only(vcpu, p, r);
 	} else {
 		p->regval = (1 << 3);
 		return true;
-- 
2.35.0.263.gb82422642f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
