Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0697BC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 18:55:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3AE4B1BD;
	Mon, 25 Apr 2022 14:55:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nFKYsSP39KOo; Mon, 25 Apr 2022 14:55:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A714B17B;
	Mon, 25 Apr 2022 14:55:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8271349F21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KhEt-FOmkchK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 14:55:44 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59C1F4B1D3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:44 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 j17-20020a62b611000000b004fa6338bd77so10854677pff.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0RIUNhOPqpB+HcP2HwzsrrOFF3qCqP329tLBYuBd67E=;
 b=YUTYT09C4kUYu097db2oy0wYcB4QiZZpF+ibqTmsgCmrs0tnYAEmD1oyhU6xNPpSDW
 5YP/UqRtFcrWZXnePhoDgo+2HnniJew9a7i7T30m1yV0NMqnuLNiQ9vOauLFB5MiMirh
 2M9cMFb6XYUpCbI+DyDG516WwrYEjHRD8UtKr9lwcOW2CpKWgaeuKrsmihegBL5WKTwm
 hG8uGNdRabATH4vdvi0yblgUk/RpebKYOCC0r56jGyO7vGyjRBJMa0diVvqm0Je7VZO9
 D9IEooRyyehKCATo7KIqh++6HsJk6p2ay6lItJX+Lo0wiKpjgrrhAyyt08AqdISWX9aE
 YwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0RIUNhOPqpB+HcP2HwzsrrOFF3qCqP329tLBYuBd67E=;
 b=thZrS/vfYLRnor7EVj22JHWipHLkA4nHypux2FGpa85wVr3r4aidFRj2FvCLBaBND6
 kdgqIhYRrQ2yRvCiW9L4Vj8RLK5kOWCXqeA8duL379TV1z2/HABXqpRQHVQBbtTT+qQe
 8mfyBy5vv4Vts5ZF7mLoSp49zV3gfq/Rqd72ZQfMgASVZXYR15ogvIu1gRZjrAvXLvri
 uLE1PJ34TUeZI7fCZvScCrSi+0H/OdvzMtfkNMwT+WlAaK3ep7Hh1YHb0ypcuXdPoFwz
 NIq3eoYccviQKomXaWKI3w8QZkq7sh969p+BmNfFRueoyiKA3w5CYiH6XqQ8WjruJFkI
 J0XQ==
X-Gm-Message-State: AOAM530p9JRXN0WcHy97j/Np3vhfpS1UOHXUnziMfi3BVECrilNCQwPw
 Uiyo22uruXUfplXvRHGsvR4n5AB51KCv2g==
X-Google-Smtp-Source: ABdhPJx8DPrpG0gMUTloJ8fmF2POFuQ8JOkOuYjgYs6Rc/ZB8KM3MbtQp2ca0WZCFkoAaDYMHM6jfYkmP+v+1A==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:d509:b0:15c:fd46:8db with SMTP id
 b9-20020a170902d50900b0015cfd4608dbmr9292897plg.52.1650912943558; Mon, 25 Apr
 2022 11:55:43 -0700 (PDT)
Date: Mon, 25 Apr 2022 11:55:34 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
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
failure. There is some cleanup present for this situation, but it's not
complete. Add the missing free's.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 4ece649e2493..200ac59edaf9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2229,8 +2229,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
-	if (IS_ERR(irq))
+	if (IS_ERR(irq)) {
+		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
+	}
 	ite->irq = irq;
 
 	return offset;
@@ -2498,6 +2500,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (ret > 0)
 		ret = 0;
 
+	if (ret < 0)
+		vgic_its_free_device_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2624,6 +2629,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 		read += cte_esz;
 	}
 
+	if (ret < 0)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2655,7 +2663,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
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
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
