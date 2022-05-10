Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213D6C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 00:16:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 990524B1B5;
	Mon,  9 May 2022 20:16:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z6XSX92LrQAk; Mon,  9 May 2022 20:16:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 306F24B12C;
	Mon,  9 May 2022 20:16:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C03E149F07
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u5TYxu5V6W+O for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 20:16:38 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9AB6F4B11E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:38 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 i6-20020a17090a718600b001dc87aca289so6856635pjk.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 17:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=J9SU8jSKgh6uBb3migUTzAXRu9j22K1MxFAJt62NpsI=;
 b=MSKWPMWuXeOjKPRzEUOdQO7zLqBE+AKJCoK07GnCviMAvxRAyC9qNOMuPdFxMxQdKV
 kskQHmTvrbZqWVGccgkaEzvI67c7QCq4lRe72ySYYD+HEIwDsUoHMOxv78uCtQwzPLrZ
 nhNif7j/z5j67cdu/WE6+5gdEr1N6/0ockMOvI9vWPAoTjzkumGWLSZjV1lFnijesIY1
 9yrgYpGj4/wnyx7MKWdloIIqSE8IV+pFVuFWYLAH7ltUY7CJ48dcflFDMp/NNTtjD9Of
 Q5mCrGDHeDGrMVNFL6+UUVfr+KLi47llh7lira2uRO93QUlupiggN7n3B/nYlZCPb+Iq
 HoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=J9SU8jSKgh6uBb3migUTzAXRu9j22K1MxFAJt62NpsI=;
 b=TAQWy5DZ+LD656BxIOofddConrWPHGt1WqJjD7DwvuaMqomMKTB0FJmjdkdS7MLy9Z
 lixlAhrc4qr0IlgyyLIIzsePAi298sHEvHtSOQi02oAefnPNjiKh1FOeMHtDYoaJtvGH
 ocGynzXq/GW7JxMSHQXm8R9IO/lGNCIUOUv3+41+d/CpgNCHMkwthrogUw7anWSXjK45
 vIaEtQLGawjpudVgQvqyYKyIO9kkPldb2vrm2lOCQrYFS0dcMteEpkBEuRwmJy9JhlgP
 zr9oPlo4uoieKbuBRobJZiigpwBGXnt6Oqycy7h/rpPe2HghQh6Om9F6YTW3uyqKEr0D
 cfWA==
X-Gm-Message-State: AOAM531jM4OPh+Mbxp7YWI2hTxY4tGtkM6mN4vMfmkHy44OaofrXV7YB
 yHRHlCH99zo3wy6QrQlRCjsWJzxSWFx9Mg==
X-Google-Smtp-Source: ABdhPJxxEKHMFVa84Sj8gQlhRu0hArTENa713cCw2C4bSqBV+TEx4yXBkkJ67jV31zsTabD2XsdMLidz9RDPKg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1950:b0:510:739f:a32c with SMTP
 id s16-20020a056a00195000b00510739fa32cmr17950017pfk.77.1652141797773; Mon,
 09 May 2022 17:16:37 -0700 (PDT)
Date: Mon,  9 May 2022 17:16:30 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 1/4] KVM: arm64: vgic: Check that new ITEs could be saved
 in guest memory
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

Try to improve the predictability of ITS save/restores by failing
commands that would lead to failed saves. More specifically, fail any
command that adds an entry into an ITS table that is not in guest
memory, which would otherwise lead to a failed ITS save ioctl. There
are already checks for collection and device entries, but not for
ITEs.  Add the corresponding check for the ITT when adding ITEs.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 47 +++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2e13402be3bd..93a5178374c9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -894,6 +894,18 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	return update_affinity(ite->irq, vcpu);
 }
 
+static bool __is_visible_gfn_locked(struct vgic_its *its, gpa_t gpa)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int idx;
+	bool ret;
+
+	idx = srcu_read_lock(&its->dev->kvm->srcu);
+	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
+	srcu_read_unlock(&its->dev->kvm->srcu, idx);
+	return ret;
+}
+
 /*
  * Check whether an ID can be stored into the corresponding guest table.
  * For a direct table this is pretty easy, but gets a bit nasty for
@@ -908,9 +920,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
 	phys_addr_t base = GITS_BASER_ADDR_48_to_52(baser);
 	int esz = GITS_BASER_ENTRY_SIZE(baser);
-	int index, idx;
-	gfn_t gfn;
-	bool ret;
+	int index;
 
 	switch (type) {
 	case GITS_BASER_TYPE_DEVICE:
@@ -933,12 +943,11 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 			return false;
 
 		addr = base + id * esz;
-		gfn = addr >> PAGE_SHIFT;
 
 		if (eaddr)
 			*eaddr = addr;
 
-		goto out;
+		return __is_visible_gfn_locked(its, addr);
 	}
 
 	/* calculate and check the index into the 1st level */
@@ -964,16 +973,30 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	/* Find the address of the actual entry */
 	index = id % (SZ_64K / esz);
 	indirect_ptr += index * esz;
-	gfn = indirect_ptr >> PAGE_SHIFT;
 
 	if (eaddr)
 		*eaddr = indirect_ptr;
 
-out:
-	idx = srcu_read_lock(&its->dev->kvm->srcu);
-	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
-	srcu_read_unlock(&its->dev->kvm->srcu, idx);
-	return ret;
+	return __is_visible_gfn_locked(its, indirect_ptr);
+}
+
+/*
+ * Check whether an event ID can be stored in the corresponding Interrupt
+ * Translation Table, which starts at device->itt_addr.
+ */
+static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *device,
+		u32 event_id)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	int ite_esz = abi->ite_esz;
+	gpa_t gpa;
+
+	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
+	if (event_id >= BIT_ULL(device->num_eventid_bits))
+		return false;
+
+	gpa = device->itt_addr + event_id * ite_esz;
+	return __is_visible_gfn_locked(its, gpa);
 }
 
 static int vgic_its_alloc_collection(struct vgic_its *its,
@@ -1061,7 +1084,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (!device)
 		return E_ITS_MAPTI_UNMAPPED_DEVICE;
 
-	if (event_id >= BIT_ULL(device->num_eventid_bits))
+	if (!vgic_its_check_event_id(its, device, event_id))
 		return E_ITS_MAPTI_ID_OOR;
 
 	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
