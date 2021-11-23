Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C4AC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 21:01:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70BCA4B15C;
	Tue, 23 Nov 2021 16:01:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3vXrSbke0ZjV; Tue, 23 Nov 2021 16:01:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EEE44B132;
	Tue, 23 Nov 2021 16:01:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA3EB4B10C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KlzeS6AwCt9h for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 16:01:17 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91A004B0F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 16:01:17 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 g10-20020a92cdaa000000b00260fbb604easo214144ild.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zz/xhPyoPXicYUMo26iz+W4ztk9QLIUECi8yH0EE7Hg=;
 b=FPW2vvMEF0DWDy4pjYuYom7O9yhLArCXJ1IIIMafjH4l9SQfuEz8J6FSjgPKgvHDaK
 DeBp6PeziJvrhgneRyz+rm+FkgN/NezBffwxGMpDfggznwqV99WmAWiZCD8N2DgV1bS8
 r2QDDazxIzsxwyPXvSZihMTMmtbjUrPbY83UArR2T/PZBc1y88t0Sc7je51Z/CSxSHai
 ZRcYz8NU/ysUeWm25rP3blxxgU8VDJdjei2+qBFGiFDtkXqyuiogjzH82aK/MyhahMWb
 4LPyjD+RYSfQeNq7mCdSe6sIs/C0e/fUK+K8PkaIOIWtK73aljR+R1fxD0uS0UQ/jq0U
 7Tpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zz/xhPyoPXicYUMo26iz+W4ztk9QLIUECi8yH0EE7Hg=;
 b=IcVmPpJxalNM60ODjhA+pmBD1IVD30gvwCQobESFxSD8PWnOfQx6nrzqEG/9phLqcA
 Jbh313x3A5b81Zv4P0Bk7j8TlkJNhkP3hudaE9pxhGbn0YDaF7B9cg/n4zkqT7akPStj
 6aeFkuzGB++lJZ/7hOFQxtf+7vN86xVbZV5/cmmw4SV5yQyYYYYTFhZtW5FHnrtBZzET
 AKgIF2KsnuK3vTuZGiHbI2ZcuPn1t54YoBTDmZyY6/whSyxOnlohdHjfvw39wJ7+MPcN
 Dfbu/db1uNTtOvZQuhI0rFhd/q9+K/r8nb+EjP7KFmWdddgZlGUU81X6qrqJVpJVtDdz
 9VMQ==
X-Gm-Message-State: AOAM530MeFxERyhZxVhXQA/hsXpfU1vf+g5fjMqkewueI76iiprvCxvL
 meEhPN2ZHoFikOO0jzIOFL11+s8YQ6L9aKiLtTIvwSpzXgyRwn7K45pTmJFRCuC7iJ0sSFfMeXt
 KTfv0X+xzocJ3tFijVcIGIqzVS74IYpVviAsxuJ93gsjnLbg32XVmOxJj8fGfP9oRl4ceng==
X-Google-Smtp-Source: ABdhPJx+by8JvSWhwxRKIldPBbHOsPDBS6NTTo+dJ01tZHkK4K1KEKpOIEbd3eNqZtzCQs9wCBQyxE4E9+Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2b10:: with SMTP id
 p16mr9105121iov.2.1637701277092; Tue, 23 Nov 2021 13:01:17 -0800 (PST)
Date: Tue, 23 Nov 2021 21:01:04 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-2-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as
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

Any valid implementation of the architecture should generate an
undefined exception for writes to a read-only register, such as
OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
behavior.

Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
write ever traps to EL2, inject an undef into the guest and print a
warning.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..11b4212c2036 100644
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
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
