Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0688C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 18:55:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 875124B1F0;
	Mon, 25 Apr 2022 14:55:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NJnEuVv6N-U9; Mon, 25 Apr 2022 14:55:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5244B1AF;
	Mon, 25 Apr 2022 14:55:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F3784B1FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKuWbSU6-18S for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 14:55:42 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32BEB4B17C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:41 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 t12-20020a170902a5cc00b001590717a080so9986709plq.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=V2K7SnKFYFulmprPaH+RZG7qmgqMT8zPxXpGoIn56OU=;
 b=oQOJ07E16kMrKbXB2qPqi5FTEGbQA5x5x7KpQvWILMbu49hYxeeAnKzgy2I18WNGNV
 NPvpdsq2UoUgxyutCP8GbTJBxGkiCmzSClWeKA38g3rV5ngQ/8M1r33P7+JMrXsjXKSe
 H/P8KjuQdK+034D19EDDh1YhJJ4y3r8vXCHkGsIKivBSbqJQcbF9qm3H03IgoeW4ZcpL
 Eobxjima9KbrvQnKZaofjlP2dkTJuElHqyCUQ9b+1yoR6ABbkJL7YcEWCcqr11Rmfh07
 Kbd9TTEUCw0/Z31TuhVlwZIWDFYJSwG1KQH+rCdr7h6t8wlqtkIc7ajm5uZ2s9sUAq9Y
 J3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=V2K7SnKFYFulmprPaH+RZG7qmgqMT8zPxXpGoIn56OU=;
 b=HJsZtu3kIym3zq+smWntamzTrykji49h9YVaqDeJSUQWrNVN1TsuFwLedTJWpxuQ5+
 Diuvzvt+HWpeGk9IaQd2WqAaxVqVCraqR7LQ9oiD69DRUNHBhHSZD2+kWZWPdarjoEdn
 qfvM5VLFjOhOoSxRClUX7fT+BVMX36jI71k93ESeKS6qUCNXQ+LU4Vc2AG4D6c/JMRG3
 zQFzxvI+pePAYVzhc31yVGjD3ISxK7CCBeobfSPT1ke5gznOTEiLbwZATCdwt2GD9oQF
 Lz6gZSvvJfvnfOiBonArO1skTZIqahoePgT5NjzIaAjUoMc9YfrWggoofAIi+7qRz/3f
 Dp4Q==
X-Gm-Message-State: AOAM532M2eFn5S3F6uvbvtXq8v78U/WZ+GJlL16vU33pcbVWZlekAS3b
 Lhdli8fnKRKUxEGwd2fckwS9A4GRFx0o9w==
X-Google-Smtp-Source: ABdhPJyF4yyZA/TtlLxSbs4rUcottDbO/lOdokQBuYVGuTNA6prz3lVAkQ3BFrm2lNh8iLAyqXNguNN0Oma/Mw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:87c5:0:b0:50a:9380:3d26 with SMTP id
 i188-20020a6287c5000000b0050a93803d26mr20553270pfe.27.1650912940415; Mon, 25
 Apr 2022 11:55:40 -0700 (PDT)
Date: Mon, 25 Apr 2022 11:55:32 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 2/4] KVM: arm64: vgic: Add more checks when restoring ITS
 tables
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
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

Restoring corrupted ITS tables could lead to a misbehaving ITS, and
possibly a failed ITS save as the save performs more checks than the
restore. Add sanity checks when restoring DTEs and ITEs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index d7c1a3a01af4..dfd73fa1ed43 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2209,6 +2209,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (!collection)
 		return -EINVAL;
 
+	if (find_ite(its, dev->device_id, event_id))
+		return -EINVAL;
+
+	if (!vgic_its_check_ite(its, dev, event_id))
+		return -EINVAL;
+
 	ite = vgic_its_alloc_ite(dev, collection, event_id);
 	if (IS_ERR(ite))
 		return PTR_ERR(ite);
@@ -2330,6 +2336,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
 {
 	struct its_device *dev;
+	u64 baser = its->baser_device_table;
 	gpa_t itt_addr;
 	u8 num_eventid_bits;
 	u64 entry = *(u64 *)ptr;
@@ -2350,6 +2357,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	if (find_its_device(its, id))
+		return -EINVAL;
+
+	if (!vgic_its_check_id(its, baser, id, NULL))
+		return -EINVAL;
+
 	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
