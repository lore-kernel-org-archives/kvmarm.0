Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D523C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:48:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F2D4B205;
	Wed, 27 Apr 2022 14:48:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r9dIPTsq9S6S; Wed, 27 Apr 2022 14:48:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE32C4B219;
	Wed, 27 Apr 2022 14:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C057C4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f97BcNVzyulH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:48:21 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1151F4B1E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:21 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 c9-20020a17090a108900b001d5793b605aso1364377pja.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tBeJ6oaUsK7XGrLiZdmUfKY71LUtrRuNSV5fzcT7ea4=;
 b=RJpDVHZpSR21Hmeb76uuxGVCu/RZJnHARE4NlaQMSydpD4TtqKNZZRtySgltlac9Qj
 MkBGeV44WBp8O3WBb6dB9pG6YV64UpIgtOBHyCvfy+jOuqxycnQEts8GORjdBNf60M6U
 hUG08TjKhzqCQTpZpPikDcuhnp3iaHRdEL8VExDIAZvk+FGIIAGV57+7W62H2B9Hz3fi
 jcMipijk20VhKvrMGrOy9HI9L/Z4uT8DUr4XEaKgkvACAsa0/wijL1+Ef/7169KCbDZ9
 FxEbihUNKAQf3UCyU3PIv8UOcJ9n61OE2beuWEqJI9X0NyddBJNmSml5gfJ9aNVMjr6C
 gkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tBeJ6oaUsK7XGrLiZdmUfKY71LUtrRuNSV5fzcT7ea4=;
 b=H73QE64+BqMRNxrJefLFY18u789SJmSecoSp67PZ1zdsUmh6Yi0odIU7uvjcV2qSoj
 z482a9TNGTk4HZoPqowPWBCoF3aEkE4SxmBs2tVqgof5+yrrNfjLcVOkaLWTwhJVXSLq
 dAZ+fNY+4rq4Cli6z1FuRKR3IqfRACKKI2aqZa0m2u/FTF6cw6t1AcBuRlrWFQoH95PH
 +Qz09hzjeQ2ef6PYHrxeTxlbLI/i/wuW8NRosXp49u5K0RegVGWbGyRK0DvuUTo0pdmw
 YdG56++D/BjuFH1AGb4I/T4b/NPr+rsyjvX/FuU9jwvu5o7y+FCpIrnObHtBxv4HwQGa
 03Uw==
X-Gm-Message-State: AOAM53292DE2x4oLDE8hnY0nhjcWCsmZn1RRySzyElsJtlz8mvZ97kki
 3PLsqYJ6xliy7aXrPUXzXJgcaITUR80IGw==
X-Google-Smtp-Source: ABdhPJxcREI+zbXWqaAX95ttKWddcJh4aoURZJ2BGTbSAms+UvK1QyviluntjpMFD0vdUpXvH09V37n/e973qg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr109008pjy.0.1651085299808; Wed, 27
 Apr 2022 11:48:19 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:48:12 -0700
In-Reply-To: <20220427184814.2204513-1-ricarkol@google.com>
Message-Id: <20220427184814.2204513-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220427184814.2204513-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 2/4] KVM: arm64: vgic: Add more checks when restoring ITS
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
 arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e14790750958..fb2d26a73880 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2198,6 +2198,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (!collection)
 		return -EINVAL;
 
+	if (find_ite(its, dev->device_id, event_id))
+		return -EINVAL;
+
+	if (!vgic_its_check_event_id(its, dev, event_id))
+		return -EINVAL;
+
 	ite = vgic_its_alloc_ite(dev, collection, event_id);
 	if (IS_ERR(ite))
 		return PTR_ERR(ite);
@@ -2319,6 +2325,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 				void *ptr, void *opaque)
 {
 	struct its_device *dev;
+	u64 baser = its->baser_device_table;
 	gpa_t itt_addr;
 	u8 num_eventid_bits;
 	u64 entry = *(u64 *)ptr;
@@ -2339,6 +2346,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
