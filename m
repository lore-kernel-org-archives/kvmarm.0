Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06396C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:54:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B190A40C52;
	Wed, 23 Mar 2022 18:54:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 60GB11baiDCG; Wed, 23 Mar 2022 18:54:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC9BC4A104;
	Wed, 23 Mar 2022 18:54:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF34249F4E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BWwF2uAC3dWr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:54:19 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F74149F4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:18 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 ob7-20020a17090b390700b001c692ec6de4so5267198pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=RQZ9oTCQlO2kkOxWGWPVIC9nBisyNLoKeQuBeACdbVQ=;
 b=p+g7bWwB50EB/w3hkgA0rVNT57FGibDrrLJK/XlvKLVxecBZRbJrvIbXJ+jcvXAkzn
 S1Ze9G7u8gofjR6Kp6iU/N1kcmwr6vx4FewGe8GM9o6xh5Ixh5kUqRrEYob4wRf9NtBL
 4Dv/9xTXxLXO61IseJp55nta5dXslqhiINmTaykUsTyh75+6wK1aw0BDi5hMhMh2Mzmj
 uCq6mZhZUl4qxzzojSU6UU1eioFrn9aWOO/MbqlItHvp78eaOO7o9GOctz6iLmCFOnx6
 W0vtrPT9wQpToA7Vu1IysUe8y7nqgNr03LQmZKjtFIZlbAuxiXzehToAeivCsGyDUMuZ
 alXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RQZ9oTCQlO2kkOxWGWPVIC9nBisyNLoKeQuBeACdbVQ=;
 b=dkcdpDkPxDIDNeiq0/qdIURw0PyEnbzjnoH9UNLvP2StnB9zej2zSZdq4rGzbILypg
 XHT26WFKL7IOgBEk7wgVPtmNGFrfEWevKxsAmvdMZTlv7Pdlc3bguIxKeybY9pYfFAzi
 QezF45rjvROTNyuI8cY+k/7pulSiziOCpv+sLyJdeshx69sTU0RCS5ZfKzy7qCdiq1FQ
 XCdSWpTrC1DigDFJW5Q64y3GCo9CF1k7GcsRUwsmD+ksDa50h22kU11oNHPUhWg6H9g1
 V7thV2a0Q+ssqzphN20FfaDF9rI9gnlFfaZFA3JIO+XxtgY9XQgB67Q6IKpzxB01ihFF
 igVg==
X-Gm-Message-State: AOAM530x1HM9sdiH1HX4hC31ghlW7Vs8b1AgK25jVJpN0wNzblELdwN9
 GVtNv9SLdn0Du97bnvQ9aV6ExXQ7/8OajA==
X-Google-Smtp-Source: ABdhPJzZggTEZsz9VHBBQHG8G2jPGTIF3aQKjvOX95a74j+hsAPzoyo4bO9e+VNMfrpeBTP6J5d5Gh+F73mgOw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:6c01:0:b0:37c:73a0:a175 with SMTP id
 h1-20020a636c01000000b0037c73a0a175mr1622779pgc.415.1648076057479; Wed, 23
 Mar 2022 15:54:17 -0700 (PDT)
Date: Wed, 23 Mar 2022 15:53:59 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 05/11] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e18f1c93e4b4..268ad3d75fe2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -679,6 +679,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+	if (region->fd >= 0) {
+		/* There's an extra map shen using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
