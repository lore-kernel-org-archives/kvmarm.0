Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C926C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 00:16:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC234B20F;
	Mon,  9 May 2022 20:16:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GxpbqFVkvYBx; Mon,  9 May 2022 20:16:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847304B26D;
	Mon,  9 May 2022 20:16:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 724264B14D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 433hrbY2rSQu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 20:16:42 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A51C4B0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:42 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 j21-20020a170902c3d500b0015cecdddb3dso8991427plj.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 17:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rkv0UauUR6p03Dq1oOC6MKynCcxjdK6th2r+Nlj5lMs=;
 b=CyK0DiJcTkSvuONwaO9vVOUUH2lhx7PKmRb9sC0FrS19+ikf4P41ERsVXz6VZQVuuj
 e4Q+Qd+icPsnWPOb26TRdScSj846bFxmn8r+lxGiYCOvQq8Q0GcuS0IWdxMXBOOtucq4
 SJq3suLyFsV3HU/CgVyzxXigFpx00/Kkysvuq0DGJYcpBTMMc/P2zhGTmISit/0LmPm4
 8DqBQ4x2JVUDWwa9pMBasBteKAX282IYlfooc3Ua4/JQc/a7CrbbGszGONr/i5u2a9wD
 isbstQ3pMsn+wWBzd3flbDdyvthUOTCd0/S8yZ5rUV9mKTZmSul6jPVDhyu93LPrh/jc
 Gtxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rkv0UauUR6p03Dq1oOC6MKynCcxjdK6th2r+Nlj5lMs=;
 b=YzVQlNdeN5gkrpLn5xD6fAOpTo3y3klZOjXFxSqEePKdq5tanug3A8fxe6vvAe/6G+
 eq5bawrfg4Lten8hl/TcuH/UrrkqqggEPRiDRaBh9NOKherPgSVL7Zr3DD4ndOmOPIy6
 XDyyCL33PE0q7QFa5zU+z28NeB32PaINa+RaM+2hSKTnwN3gJDNj65qsZTn2tmXyvap/
 jpwzKudwF8V9YcWOc7UHtdQMqcdqtmjItriyhu7t1OpWGybTHhH4e4aqiZlH/xnlLKeD
 PNmLRy9ygmmQ5L9cnyVYPcO+41Gcjpk0dg6IKhdXT3SfauuO2aBiMyoVzrgeL5/ALbrf
 EmlQ==
X-Gm-Message-State: AOAM5306fzlED/Cmi3NF0/W+HmWg/5hlxi8xS1Uk2LjImyeqYL3U7/1y
 Yx+OttACoUiqOG5USSTPJPkhYoMDDxyvjQ==
X-Google-Smtp-Source: ABdhPJxtlJoplMzPFA/LKy0HiYryHf5lEVcj3OtAa3tTvRquT7Dxfslm1eQlVsRiELeYI5ewixkBPH5e3qU5cA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr16828pjy.0.1652141800839; Mon, 09
 May 2022 17:16:40 -0700 (PDT)
Date: Mon,  9 May 2022 17:16:32 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 3/4] KVM: arm64: vgic: Do not ignore vgic_its_restore_cte
 failures
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

Restoring a corrupted collection entry (like an out of range ID) is
being ignored and treated as success. More specifically, a
vgic_its_restore_cte failure is treated as success by
vgic_its_restore_collection_table.  vgic_its_restore_cte uses positive
and negative numbers to return error, and +1 to return success.  The
caller then uses "ret > 0" to check for success.

Fix this by having vgic_its_restore_cte only return negative numbers on
error.  Do this by changing alloc_collection return codes to only return
negative numbers on error.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 8a7db839e3bf..f34e09cc86dc 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -999,15 +999,16 @@ static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *dev
 	return __is_visible_gfn_locked(its, gpa);
 }
 
+/*
+ * Add a new collection into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_alloc_collection(struct vgic_its *its,
 				     struct its_collection **colp,
 				     u32 coll_id)
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
-		return E_ITS_MAPC_COLLECTION_OOR;
-
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
 	if (!collection)
 		return -ENOMEM;
@@ -1101,7 +1102,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	collection = find_collection(its, coll_id);
 	if (!collection) {
-		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		int ret;
+
+		if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+			return E_ITS_MAPC_COLLECTION_OOR;
+
+		ret = vgic_its_alloc_collection(its, &collection, coll_id);
 		if (ret)
 			return ret;
 		new_coll = collection;
@@ -1256,6 +1262,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 		if (!collection) {
 			int ret;
 
+			if (!vgic_its_check_id(its, its->baser_coll_table,
+						coll_id, NULL))
+				return E_ITS_MAPC_COLLECTION_OOR;
+
 			ret = vgic_its_alloc_collection(its, &collection,
 							coll_id);
 			if (ret)
@@ -2491,6 +2501,11 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
+/*
+ * Restore a collection entry into the ITS collection table.
+ * Return +1 on success, 0 if the entry was invalid (which should be
+ * interpreted as end-of-table), and a negative error value for generic errors.
+ */
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 {
 	struct its_collection *collection;
@@ -2517,6 +2532,10 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	collection = find_collection(its, coll_id);
 	if (collection)
 		return -EEXIST;
+
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+		return -EINVAL;
+
 	ret = vgic_its_alloc_collection(its, &collection, coll_id);
 	if (ret)
 		return ret;
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
