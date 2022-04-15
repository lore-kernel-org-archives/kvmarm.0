Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFC2C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8033649F46;
	Fri, 15 Apr 2022 17:59:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jf7X1MKe3e62; Fri, 15 Apr 2022 17:59:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DDC4B130;
	Fri, 15 Apr 2022 17:59:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7218D49EE8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vOmVKuQG78be for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:20 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73CCC49EDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:18 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 d19-20020a0566022bf300b00645eba5c992so5453284ioy.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vop5IqucqvM+bii5zgbcIy+JPyxF0keenz7pMhv8m58=;
 b=jHJtFLgbxSnb6N3tLR+HWD/NrSJB2+DQfaJR6BV6mi7BHclXm3b5DYu3lRIqkK8ZCZ
 9Nsc5qvQWjHWPk7VT1sJ3wsYP6XTOuBtzzol+Dyx7Y/G8XVKzTeOZ0wTCYISer2gacY1
 1q7hF+P4I9XhHOxrOx0DwqCHp3nlNR7k1lS2WUuwKr6yrpl/wcv2QIQYdgxci9ERkbhN
 GjVhDkCkSw4jTSLDIZKUru4yoXAgzeVmoDz3uo26yb6h1LXdBYsBdQUdxT5prqHk01wm
 t/IKRZMZolVSXf5jGA0B71c/6Sed7CUrur83859QSKnETLM/2FiH2WcM4zCc5JAIz871
 u5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vop5IqucqvM+bii5zgbcIy+JPyxF0keenz7pMhv8m58=;
 b=FKzbfpkt3pUt+rb6bL51FvXs0mig+2uc2jhO+PfHphKmcFrvB+ySZN0xbEgj0WJRsr
 cEVokzRXQEBASLNJRuNlikx3W+FPGkAfhMhl9hbA9/4WOs9is4dbhERMwmPY9AthkCsK
 babgNtlYrOtdmJTPXWdsGEFkt+cCw+iRXMfQmSmkRGJFexJmc7YBlcj41M1hNy4wAbdC
 SZVoIS0Ef6Vbpds+1Je1vjIXxDwRq8Cw4SFEoTygydnEOL4tJZtTSLMNDqsEXUeJDEFB
 +SaWi1m2iANZCNDYCzbIl4PHZRfBrHoK+muWBJCaGXbdcO3B3EAp88U4RZsi6+If6Phj
 ldpw==
X-Gm-Message-State: AOAM532pXH+xXTMrPvQ3Tlmn9KZ6jnBk/jHEQkfCP2zuzhE8Yng5Lgle
 l8if2XZTcbwyy0ZJoea9p269uQk2hY0kpxSkqPT5JJlDlW5V+wORoXVf3cpKpvmA5vg3D7z1S4Y
 2G9Jvv+gAX4erO+chCFYTb8mLY+b8pSQIObTcNaifW8AAtaal4FT+MTzYZm5LDA8oDYg+ow==
X-Google-Smtp-Source: ABdhPJxNjcu2tnVJ1+/YbC82bpFAmroc7SBNGMAr2Bd/O0LGqLCc49cJVFBPbSuomBfNsod9gY/vH0O4fqo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:164b:b0:323:ac42:8d4b
 with SMTP id
 a11-20020a056638164b00b00323ac428d4bmr475237jat.75.1650059957848; Fri, 15 Apr
 2022 14:59:17 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:54 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-11-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 10/17] KVM: arm64: Assume a table pte is already owned in
 post-order traversal
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

For parallel walks that collapse a table into a block KVM ensures a
locked invalid pte is visible to all observers in pre-order traversal.
As such, there is no need to try breaking the pte again.

Directly set the pte if it has already been broken.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 146fc44acf31..121818d4c33e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -924,7 +924,7 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep, kvm_pte_t old,
 				      struct stage2_map_data *data,
-				      bool shared)
+				      bool shared, bool locked)
 {
 	kvm_pte_t new;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
@@ -948,7 +948,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!stage2_pte_needs_update(old, new))
 		return -EAGAIN;
 
-	if (!stage2_try_break_pte(ptep, old, addr, level, shared, data))
+	if (!locked && !stage2_try_break_pte(ptep, old, addr, level, shared, data))
 		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
@@ -987,7 +987,8 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-				kvm_pte_t *old, struct stage2_map_data *data, bool shared)
+				kvm_pte_t *old, struct stage2_map_data *data, bool shared,
+				bool locked)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 	kvm_pte_t *childp, pte;
@@ -998,10 +999,13 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 	}
 
-	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared);
+	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared, locked);
 	if (ret != -E2BIG)
 		return ret;
 
+	/* We should never attempt installing a table in post-order */
+	WARN_ON(locked);
+
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
@@ -1048,7 +1052,13 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 		childp = data->childp;
 		data->anchor = NULL;
 		data->childp = NULL;
-		ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
+
+		/*
+		 * We are guaranteed exclusive access to the pte in post-order
+		 * traversal since the locked value was made visible to all
+		 * observers in stage2_map_walk_table_pre.
+		 */
+		ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, true);
 	} else {
 		childp = kvm_pte_follow(*old, mm_ops);
 	}
@@ -1087,7 +1097,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_
 	case KVM_PGTABLE_WALK_TABLE_PRE:
 		return stage2_map_walk_table_pre(addr, end, level, ptep, old, data, shared);
 	case KVM_PGTABLE_WALK_LEAF:
-		return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
+		return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, false);
 	case KVM_PGTABLE_WALK_TABLE_POST:
 		return stage2_map_walk_table_post(addr, end, level, ptep, old, data, shared);
 	}
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
