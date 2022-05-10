Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E5DC43217
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 00:16:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC2C4B1F3;
	Mon,  9 May 2022 20:16:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DdNRLnXoacw5; Mon,  9 May 2022 20:16:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67E34B129;
	Mon,  9 May 2022 20:16:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D344B20A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O1t45ITjY8I6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 20:16:43 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2CF14B14D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:43 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 q3-20020a17090a304300b001dd2130b435so1421582pjl.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 17:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QD0NrA0rKRp0pec8KTI6IW9xj1xL+jmM30atKcgc1k8=;
 b=IsPJS7H00adX3QCpXSD/mei1YnsTS2t4N0eGi1xaHGFE9rvLkH7wtUefVUaJfrzn2p
 10u5MV81UqQWp3TpHepR6qIEBLGeFmlK0kDu2Kt0BEc1l5jB+ODl1tq//5JLEFO4wbaT
 7KRRS+4714+Dzjthcko2VpxIjKNWkKbe7MEf1NPZoCBOzC7ijO+aAvZSqhnQr9JcxpYF
 +TZ9CyIGWmQXW6DZt9E+Ggsp1F88nhlZhYws0RTap6rjuNvr9klcWR2CgcYO2rS9wxtz
 SgY/DIZ1ud9YikCUqrQPR2gp6+hlA1XGmcXhy+0266rdssKkbAp8XzxMvoK4snDkZciU
 Jmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QD0NrA0rKRp0pec8KTI6IW9xj1xL+jmM30atKcgc1k8=;
 b=PlYczruEN5OqI2tm9rMNi0WafUTWgpNRMnGRbArCGof5MtWGqzwfstyZoksxLsjC/u
 Gk4jTS1GqlGARnp0woG5beKKAn4jdw4KosrTF7h3tV3eiwgf6ep8HNiH/Wv1M68yatgl
 26Jqxc5kZIuMkBH+CAoasFxaqdOmsIqjAeKWWJLJdH1hg1yyTnzUKwB+Oclxmo9ZkdTO
 PpiWeJMMTfACoH/9gDZ1qePeNoXg3A7ouh1oGQChejxNJAwlSmlKDOfURTKvkBO9grQu
 0HKBnrzsFeH+jpfh347RExQurmOlOM259LPbiuo3qqLw3I+xBQ/pE6YRxfB0dGy1qloA
 LsjA==
X-Gm-Message-State: AOAM531Pen0FlZ3WByp2/KBa4ceb5PoF68QuPc5AfzNTv3Jt1uiIFI5x
 zwQZBwTlngNh2283n6iiEatMap179mIDvA==
X-Google-Smtp-Source: ABdhPJxEsqmOiWFXOmG9gfTVXmnMY2awFbxdCsS4fVflAyYeQ7zgfAEbrQ7Klo1c6Bx3gWtqokF0wyTe4W0ZOQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:15c2:b0:510:6d56:730 with SMTP
 id o2-20020a056a0015c200b005106d560730mr18178625pfu.62.1652141802619; Mon, 09
 May 2022 17:16:42 -0700 (PDT)
Date: Mon,  9 May 2022 17:16:33 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
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

Failed ITS restores should clean up all state restored until the
failure. There is some cleanup already present when failing to restore
some tables, but it's not complete. Add the missing cleanup.

Note that this changes the behavior in case of a failed restore of the
device tables.

	restore ioctl:
	1. restore collection tables
	2. restore device tables

With this commit, failures in 2. clean up everything created so far,
including state created by 1.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f34e09cc86dc..b50542c98d79 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2219,8 +2219,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
-	if (IS_ERR(irq))
+	if (IS_ERR(irq)) {
+		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
+	}
 	ite->irq = irq;
 
 	return offset;
@@ -2485,6 +2487,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (ret > 0)
 		ret = 0;
 
+	if (ret < 0)
+		vgic_its_free_device_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2615,6 +2620,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	if (ret > 0)
 		return 0;
 
+	if (ret < 0)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2646,7 +2654,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
 	if (ret)
 		return ret;
 
-	return vgic_its_restore_device_tables(its);
+	ret = vgic_its_restore_device_tables(its);
+	if (ret)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+	return ret;
 }
 
 static int vgic_its_commit_v0(struct vgic_its *its)
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
