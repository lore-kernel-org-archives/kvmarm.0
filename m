Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF4AC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58CF749F1C;
	Fri, 15 Apr 2022 17:59:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id THUP4gszWj2U; Fri, 15 Apr 2022 17:59:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35A7949ED3;
	Fri, 15 Apr 2022 17:59:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 103A140037
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FczcDFsKeHru for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:09 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E709349EE1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:09 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d2d45c0df7so75869177b3.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Tyg2Q1CJQYh6kqJKn5I8WsZWhqynGf1zv3GZVnyVrPI=;
 b=bs/o3a1yI+YtQKTec7tfylXXQu4M6ad2QWFFL62JX+gXbwqO9FEus3pkH+ThX+JPAr
 JPEPreeCxgkfcEjZxuDSMTLLZUbJYuMNUMiPP28ZaBVQA8xAoGGJwyWWqjUTVOr9w+H1
 scbsRRQ4oV/0Ko6nzOrL8D58Z+zUc2quNieeYqKnL4/2GddH6EUAGmW8TUmhdokw0buR
 c0G9PrlnzO6Zct/R0EMtBthEbtbkFluRFT3bcL6Benpi1sBm1BLEUooH5TD8OFDM9SNB
 FGX1+tPIQqSDfmOl4/bgqfhcbkyjAEMmpAUImOqM0PuNfNbC+i60/UI9Bsp0mp7hYMtn
 Jqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Tyg2Q1CJQYh6kqJKn5I8WsZWhqynGf1zv3GZVnyVrPI=;
 b=Gw3Kv6Dkuvvk+WBwTqXtlAKz6VylLyX8HATELoDTbHwzgU89UZanLzdv5IHjiJ8Qqh
 gdK7ff8W8j/VYb1u7ELHIncH9Oy26A1UdZwn6vvAjQUtB03Zn6Qr8NOuKJFZpxTiYweK
 CA3LPpiy876DSykHK9hCUSIzEXcyks+OTg4fnleZS0GBH7dc4AZ4kjKVolDYMo4VR0Sv
 6um4cs78hYPkWNDW2CFCGX24wKVHvVElavkC9azv9Cs+1fzP0NdkM3IK2NexIJjFxtsh
 pTzx3LNZBdxrn05rpSw+th0VJxpc/g6a9MZkStQsegDfKPTf5X9gQXVKMYrkkP6zgpU8
 le7w==
X-Gm-Message-State: AOAM533qRPvXgta9TRn8ad5F25bu0p4cogmEUDH+sYtJFFfkB9my8UIx
 ujIuQrQpFoeFVBiUm6VdVxdQpGv/FCZHAOEdHH5L/uCaCn5urYPBbdfNpVRqzJiBMpdEMzEPxTx
 qTu8HCBAL9kKzhZDu3xeswBnE+83wSSe140PzLr6lNXks5zvQngqjWS/MPKRcWhN+pM6jrA==
X-Google-Smtp-Source: ABdhPJxEvl0U3CkvkcrBAn3HsWtsYmV0z/JZVUMkoVOPtU1p1JiWR679eaZiC7C8eGZtheHJa4oZ8Gi2BLk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:544:b0:641:4007:1da8
 with SMTP id
 z4-20020a056902054400b0064140071da8mr1070971ybs.195.1650059949262; Fri, 15
 Apr 2022 14:59:09 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:45 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-2-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 01/17] KVM: arm64: Directly read owner id field in
 stage2_pte_is_counted()
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

A subsequent change to KVM will make use of additional bits in invalid
ptes. Prepare for said change by explicitly checking the valid bit and
owner fields in stage2_pte_is_counted()

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2cb3867eb7c2..e1506da3e2fb 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -172,6 +172,11 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
 	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
 }
 
+static u8 kvm_invalid_pte_owner(kvm_pte_t pte)
+{
+	return FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte);
+}
+
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -679,7 +684,7 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	 * encode ownership of a page to another entity than the page-table
 	 * owner, whose id is 0.
 	 */
-	return !!pte;
+	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
 }
 
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
