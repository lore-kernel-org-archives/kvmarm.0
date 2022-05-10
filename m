Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E1BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 00:16:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D0D4B177;
	Mon,  9 May 2022 20:16:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id enTJ2N4Eg76H; Mon,  9 May 2022 20:16:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 597AB4B12C;
	Mon,  9 May 2022 20:16:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 947E94B08B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YXbyHt8t6Lhl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 20:16:41 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 653424B11E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:40 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 s68-20020a637747000000b003aaff19b95bso8053248pgc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 17:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jtn+rVy5vFlg0k3tzksKYO7fwuFm1nz+SKgrvpccqO4=;
 b=fUGRpBAoCkqT7n74Z675y3/12Wkx7hwCvOmct9eVuSEwE1WW3AzyvgJIVesu6rtn3U
 XMmu3nIvouN5arf49cGMGlDIaM//Iua1rJiXyoo+s8MVOB5Q2HmRR8L4GWBINc3Md93G
 ot9MzsJYBKbsw02lO1VvvMNbmeIOaP1rY8E1/9bed6ZDRFvSdvtEDI+buwpuJwXsezdX
 A6gSAGwCNAMgoy9ZcsBE1p/5iX0Y1lhebLBMghyUfDWzc4MAUKDCq+nGg1BdGbqFHesI
 ltD+zY4r6alW5mse5VZcjAKlTmwhYO5YbwH1ut+P6e9pccep3WKVRoQLNzTqFwyZ45yZ
 OdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jtn+rVy5vFlg0k3tzksKYO7fwuFm1nz+SKgrvpccqO4=;
 b=F7ZOsnf3WJyK6C/G9QAfIZq4BKVxNl0Jgq+wFICHjY+NyNyHmqM9uKb+1DYf79qwmd
 fmGCHhYOwplAS0R0MswwGu8OqiIWTzc3ECuSjwTEtc5BitTkJZSxKM23Jn6pUHT0Lafx
 +8zrWuGifZGNNB2sZCF/gAyOTJOApKJfsYjpE1tYi6ZydS7GQIzQ1Nlp88H2C2QT5jV1
 yXfQsnTLkhR4G36fEZhfNuIN7IEarHX0HYdNKIWf5LV9leO7iF4daze0chXw4GT0xk3p
 VmYvdP21dgGmDaNb6UOgPZEYyk777e+f9mLREzD0q4y0Gbf0k0ZpXwqXrQL7SuXyIzIy
 9prw==
X-Gm-Message-State: AOAM532/HA7a+FQzdn26d11ucNTOnCIJBlSRK7fH/iaYrpBvWByyV/Sw
 NbUwlNH2S1/vylw4oAjb82UL1Xr5sy1sUA==
X-Google-Smtp-Source: ABdhPJw75WhU7x216GZ5pXYXnYnVOqapAJKG1SX2v5lk7tXXUt3ABvyI99lLinSyLV51ay6xX6wWq0nuPuuF0A==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:b418:b0:15f:713:c914 with SMTP id
 x24-20020a170902b41800b0015f0713c914mr9990362plr.171.1652141799472; Mon, 09
 May 2022 17:16:39 -0700 (PDT)
Date: Mon,  9 May 2022 17:16:31 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 2/4] KVM: arm64: vgic: Add more checks when restoring ITS
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

Try to improve the predictability of ITS save/restores (and debuggability
of failed ITS saves) by failing early on restore when trying to read
corrupted tables.

Restoring the ITS tables does some checks for corrupted tables, but not as
many as in a save: an overflowing device ID will be detected on save but
not on restore.  The consequence is that restoring a corrupted table won't
be detected until the next save; including the ITS not working as expected
after the restore.  As an example, if the guest sets tables overlapping
each other, which would most likely result in some corrupted table, this is
what we would see from the host point of view:

	guest sets base addresses that overlap each other
	save ioctl
	restore ioctl
	save ioctl (fails)

Ideally, we would like the first save to fail, but overlapping tables could
actually be intended by the guest. So, let's at least fail on the restore
with some checks: like checking that device and event IDs don't overflow
their tables.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 93a5178374c9..8a7db839e3bf 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2198,6 +2198,9 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (!collection)
 		return -EINVAL;
 
+	if (!vgic_its_check_event_id(its, dev, event_id))
+		return -EINVAL;
+
 	ite = vgic_its_alloc_ite(dev, collection, event_id);
 	if (IS_ERR(ite))
 		return PTR_ERR(ite);
@@ -2319,6 +2322,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
 {
 	struct its_device *dev;
+	u64 baser = its->baser_device_table;
 	gpa_t itt_addr;
 	u8 num_eventid_bits;
 	u64 entry = *(u64 *)ptr;
@@ -2339,6 +2343,9 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	if (!vgic_its_check_id(its, baser, id, NULL))
+		return -EINVAL;
+
 	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
