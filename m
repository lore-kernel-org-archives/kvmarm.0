Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A8BC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 18:55:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE6C4B172;
	Mon, 25 Apr 2022 14:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FMQaQPCz5aBV; Mon, 25 Apr 2022 14:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 146204B1AB;
	Mon, 25 Apr 2022 14:55:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D014B14C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4CgjKzxVC36v for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 14:55:39 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA47449F21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 14:55:39 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 g12-20020a170902740c00b0015d243ff163so1396566pll.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 11:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=App4pplJsXE3FSLveDz2wmuYECqKUpv5nRO4FPRMmdg=;
 b=OieVH6OuAfaxBsYvBLUU1Sm/Bcg4piHqTSLuniJiKMzzb4Xb16uXADea01sLsL4MAK
 wDX1d7cBRGuFcE+zVI9UdbPijX959HcyTqyEj8Oyd9CHx2RbY5Gg/UJKckIzoXNhjpwG
 nlOhyym9t3CatcGPYQBzDGTjL2MQn7KXkNBfwGSvIJ3duLRNfDFmeVoLSvFVFsnPs2Gc
 uQeFF/yYp/aPspxGQiRHZuuzJlJFax+r3NvffkHFw1mh5gDg4zSzuIQIY8ofV//yr9FX
 ULdcMozo96Szyd446gkKtArxqxKEmj/Zi3hgjOCYZmsmT9D50KOdAZkZnTNwGGXYrT2I
 wMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=App4pplJsXE3FSLveDz2wmuYECqKUpv5nRO4FPRMmdg=;
 b=qfIdkR9g//4sKmIkp8uRTQhAolT7oH90ycZE31+FxMbGOGPugx50S0bZI24OceBaCi
 zEbzOBC375y7LMaSi/7iDmPChC7dqZCSadTLM6S7yIatxKatPw+EOQd8mPIK/smJJYYV
 +FIT4nkuOjGQUcOB0L5QitMiX5E1MpN/J55bMKdFKE5Wc4neds9OCi9feufqjHMAvJ2Z
 XzMWCZ3REqKDCB6hMdyElxfixFcqg7e2vGgsDia+QOvT30wqNb/U5Ly33SXd6S0BhM/x
 SAdckRr+Sqg5zaObmoNTZg6k+/+7rcvnRfLrw9oQ13+uX3W8AzM2yCJ8tM3+/aFs1+Cd
 Bnrw==
X-Gm-Message-State: AOAM532KX5PixaQFRkJEUXetGuAURUR4wMQ+cJqAMdUR8ohBVr6lyT47
 9XEpUpd9z1d0+WxKGPcdgKRY7zTDBeTiHg==
X-Google-Smtp-Source: ABdhPJzYxv4uwobEhJ21IyQVq7NfTTMu6gZl02k/SyTvc11h4OxfW1IUxPS6HRejSd+Y+JUa91cic71EvRwL+Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:9041:b0:159:e08:5f4b with SMTP id
 w1-20020a170902904100b001590e085f4bmr19351313plz.33.1650912938814; Mon, 25
 Apr 2022 11:55:38 -0700 (PDT)
Date: Mon, 25 Apr 2022 11:55:31 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 1/4] KVM: arm64: vgic: Check that new ITEs could be saved in
 guest memory
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

A command that adds an entry into an ITS table that is not in guest
memory should fail, as any command should be treated as if it was
actually saving entries in guest memory (KVM doesn't until saving).
Add the corresponding check for the ITT when adding ITEs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2e13402be3bd..d7c1a3a01af4 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -976,6 +976,37 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	return ret;
 }
 
+/*
+ * Check whether an event ID can be stored in the corresponding Interrupt
+ * Translation Table, which starts at device->itt_addr.
+ */
+static bool vgic_its_check_ite(struct vgic_its *its, struct its_device *device,
+		u32 event_id)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	int ite_esz = abi->ite_esz;
+	gpa_t gpa;
+	gfn_t gfn;
+	int idx;
+	bool ret;
+
+	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
+	if (event_id >= BIT_ULL(device->num_eventid_bits))
+		return false;
+
+	gpa = device->itt_addr + event_id * ite_esz;
+	gfn = gpa >> PAGE_SHIFT;
+
+	idx = srcu_read_lock(&its->dev->kvm->srcu);
+	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
+	srcu_read_unlock(&its->dev->kvm->srcu, idx);
+	return ret;
+}
+
+/*
+ * Adds a new collection into the ITS collection table.
+ * Returns 0 on success, and a negative error value for generic errors.
+ */
 static int vgic_its_alloc_collection(struct vgic_its *its,
 				     struct its_collection **colp,
 				     u32 coll_id)
@@ -1076,6 +1107,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (find_ite(its, device_id, event_id))
 		return 0;
 
+	if (!vgic_its_check_ite(its, device, event_id))
+		return E_ITS_MAPTI_ID_OOR;
+
 	collection = find_collection(its, coll_id);
 	if (!collection) {
 		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
