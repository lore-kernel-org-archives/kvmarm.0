Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3C1C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:48:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4626C4B1F2;
	Wed, 27 Apr 2022 14:48:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CICbBOryU0O2; Wed, 27 Apr 2022 14:48:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 102E04B21A;
	Wed, 27 Apr 2022 14:48:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4873B4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8PlLVD1xJ4Ok for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:48:25 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C6194B22C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:23 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 64-20020a630843000000b0039d909676d5so1304935pgi.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=h6i932oX/jFZxDeCgPoTJkzP+yH7aYfI+DgBzirxODs=;
 b=QIZgIEqufTlsX6ImsR51+hEPqbxHx3Yf30qGjXgSYPJCBVtJj4VFyxlmGt4GLy2fme
 O8v20Qbl7rUGzQVhQvtgICDH36pYKZjiSHCDic9hjSujDY59PrB6N3ef3LAwDSvgCCgY
 LoDThBX9JNQmVC4vz9ZOE3BzD8QhP9UVJnKsnh3PPZE0I9Q+BVwlhA+BW/nCI7HMuwKI
 QMvn2o5vyv7eFxrsRZ1DJlK1ewKninzZ2J5mX9C86VZFH4ZQW5rVGEOiB8xlMJiDT3YO
 Yjj/Ska9kuvKyxC9bgoavvCxoPprqgGd1e3PNCk21QMX6meNtLRxdo9IOkIDrzCiubzM
 v50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=h6i932oX/jFZxDeCgPoTJkzP+yH7aYfI+DgBzirxODs=;
 b=vwUCSE6MoZMSEFEgYoRSJsqz0wY/tsF5w5WElUUi5e3P3TRhFXA1W7+O21aBlBwxLN
 EZnaui8TxxhDBJR5/DNLVlwzQe5MRotKzlzoDGEHrH1uwjVd02I5zrLtaRWHUhJ/9cGf
 dXwCB/up74VqWVC/gAE6uzpaqjq4RtLQ4UOuBfgR9Wn2FdvjBSNtY/oV9Ikwu9oPNj8K
 xmJ2zTxY6IS6sbEbfvsyLmWvuef3EdSJ+Er4aRiNr2lBBY4wt8jxPjLGn4LBJ4v0aKOI
 yEHUmr8oj8ryNx6LrUbpo8afyqdxQ9Ja+dvC+g8cTAyOnWGxJLmK7c6lxFJr69m0zw6T
 gR5Q==
X-Gm-Message-State: AOAM532T0ziGpjhujxmnqsu0Gtwvc7t1ipb8yvPy3D7B3Kj5ykOvT7HR
 W1y3qycpMXh4qIsw8WsRyziUG9xr0u478A==
X-Google-Smtp-Source: ABdhPJzNqPfb/x+YKrEsZ3li+cQ0pLyAnvLP4bZGKCHDHyL9eXtfLjRh5cZ+nMHDNIO+Th6alnvjKnACtR2EJA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:1e03:0:b0:505:64c1:3e19 with SMTP id
 e3-20020a621e03000000b0050564c13e19mr31675138pfe.32.1651085303160; Wed, 27
 Apr 2022 11:48:23 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:48:14 -0700
In-Reply-To: <20220427184814.2204513-1-ricarkol@google.com>
Message-Id: <20220427184814.2204513-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220427184814.2204513-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 86c26aaa8275..c35534d7393a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2222,8 +2222,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
-	if (IS_ERR(irq))
+	if (IS_ERR(irq)) {
+		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
+	}
 	ite->irq = irq;
 
 	return offset;
@@ -2491,6 +2493,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (ret > 0)
 		ret = 0;
 
+	if (ret < 0)
+		vgic_its_free_device_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2617,6 +2622,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 		read += cte_esz;
 	}
 
+	if (ret < 0)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2648,7 +2656,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
