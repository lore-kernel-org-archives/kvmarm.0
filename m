Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39486C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:00:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF46C408A7;
	Mon, 14 Feb 2022 02:00:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RXsfQTzO0HaK; Mon, 14 Feb 2022 02:00:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 609F240B91;
	Mon, 14 Feb 2022 02:00:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3273640AEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w1iSZ0LtJ8kt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:00:41 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21FAE408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:41 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 a15-20020a17090ad80f00b001b8a1e1da50so11512856pjv.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zPnMHKVlqcgDQB6kXKJ7+KuQAdNLH0y013yuxCMh/uc=;
 b=jAMpDPE2rwLv0xUEZh0rf99E5rltD6fSrYSdLKH9MDqodxvRCPt1zuOb6B9b1nSoMA
 LOc7lWlmOcHkEb3/SBDlw6Q7xWUkfRgOZ1/NqJWEvzc5aDDmO8WA4sfAwP6macnQqeyH
 r6q9dAjHDQScFr8QtjWa/2fYmOShpUA+EwsRzEeG57GB3ibYFUFWOAF6mvoXUDAVkyA5
 qdH+/5VtcQPN2f26W69X4y+bwUZEa/LdHQgNuUtcEPiB3ZcsOsInUXYrSf0CqniMr8OB
 g3UniLutFzrP920Ugjw95OH7nvWvChiNn1a4eZS9a7keu0rnuQTJxjcx3A2k/2SX70Ay
 xBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zPnMHKVlqcgDQB6kXKJ7+KuQAdNLH0y013yuxCMh/uc=;
 b=GTYMVTqBg3rz/IbkeUlo+DIt+yspj0wjsBw2RvSgRQiJBqAFlNUsP/nhv8iHqWgjec
 O1+obolMDM2j/B8E7Oha+U4NanUjVQ5PxaipekUXr7/GHjm0BqlsEInAclVv+feou/AQ
 5Ny7VuoeMo+gF3/f99LmRibfPeLd8RJ22k4yXyzdkGwee4Vmfmf5eIrE2x+KZ9tVAPFG
 eDomuXRROI46+T181KWYw4pVBuZmt7x1qqyU/ocepj6J2AZt8Q6WAGvGgSFBEHDgYcOZ
 JcMm59ITJeU28ntQCgBfyG6tJpTv8N+7WegXv+Bch2mWyeJwVq0m8TxIN1QX2gbxOyHS
 7khA==
X-Gm-Message-State: AOAM5319w15usvHNWO2N6TwlCF0nwePHBVulMBR1275aiLNwAKmXdyQD
 FjTd+dlBR2tPDOKTJ9KwzXiXznDcTl8=
X-Google-Smtp-Source: ABdhPJyJ0YhcLpxpXD9Q6qbj2a2Z8CEceYHauRoXxBka/sS6SnTbMSEqpjKMgS7gdS6Ry14yGjGjZ3cqwj8=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:11d0:: with SMTP id
 q16mr12831689plh.134.1644822040248; Sun, 13 Feb 2022 23:00:40 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:33 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-15-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 14/27] KVM: arm64: Make ID registers without id_reg_info
 writable
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Make ID registers that don't have id_reg_info writable.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fea7b49018b2..9d7041a10b41 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1909,11 +1909,8 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 		/* The value is same as the current value. Nothing to do. */
 		return 0;
 
-	/*
-	 * Don't allow to modify the register's value if the register is raz,
-	 * or the reg doesn't have the id_reg_info.
-	 */
-	if (raz || !GET_ID_REG_INFO(encoding))
+	/* Don't allow to modify the register's value if the register is raz. */
+	if (raz)
 		return -EINVAL;
 
 	/*
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
