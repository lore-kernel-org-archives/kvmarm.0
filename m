Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17032C6FA91
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:26:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4A654B765;
	Tue, 20 Sep 2022 00:26:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KMo75fC1rxNB; Tue, 20 Sep 2022 00:26:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA26A4B69D;
	Tue, 20 Sep 2022 00:26:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB2B4B653
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:25:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jPQaNxs1eOF5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:25:58 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D32FB4B6B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:25:58 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-34546b03773so11203617b3.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
 b=p9b3BJlyK/xx0kc1n4jrz4NOkmP/E44tN2jGWvb5s0PcagXYBrHqp0hWXeENhXfgwJ
 2hbCkK/TEEJDrE9cLerHKEy4bJxHMyYnD4TcoDDebSFEJGmrkiN1G1VXU2zl1i3EVR7P
 R3gBxmTbKpOCI1llN214a5jPPu38guQZsHPYSaC7UJOIBW+VMHLh9262hNPVm0OpYoj1
 VvfP6S0GIX0iVCv4kGuPKN3sHF/xyJqI6OHsm13M3IcEbtQCEhBJRfdqJ4ZL93wAvD6B
 jaslgqZv8c8XtqOymwE7B8d6jkXFFRG7o8UuSjylhM4xAk9ZbReA//imiAYOjoWvDp+c
 btzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
 b=APdlCQh7sxlvMH5VatJH0KYBxCa+C0vdWCYVizmoNW7uiHakAgnAYJtFFT2HpP+RT2
 2DZTrfp6UV8t5uebfl1Df36/RxDBuc+Ri+SRUroAaBRk9GHgVH0s6Tfc7WRtJjBYs2TO
 1RRwnE5ZatnKbloXH2u2VeurkT6GZczn3KGTuhRa/ORHA3bNtaAxXgHUJcW5D7P7POjN
 eGO4LDbly2koXoIru2hR6ZEk286l+NNQLLV4us/uQeFX8nXVZM/vv4WLRaRpnD6ZdcKy
 g/KZQiYu5fdESbC0LK+dfWplduRfz7MRJ8vIhiAIEjzehrPe1jadHLOsLsyH+pLtZ486
 h8zw==
X-Gm-Message-State: ACrzQf3yKnmVb29l+iZgGg1LhzJh4A4/9bnO9TliNiQ/y6lRBdUqVW82
 JL5v3Ci/mDOfZUXCEzXMe2O+dbMJa0JM1w==
X-Google-Smtp-Source: AMsMyM5NeIBoSbQIjYC9IGSltG/CyuMY5IR1gm9/YeISFgoG3OEz5dIPhdCQjt7X8rjyq48WA6JhTpOFQwfzqQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:848:0:b0:683:58d:ea95 with SMTP id
 v8-20020a5b0848000000b00683058dea95mr16671577ybq.565.1663647958467; Mon, 19
 Sep 2022 21:25:58 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:25:41 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-4-ricarkol@google.com>
Subject: [PATCH v7 03/13] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..9dd03eda2eb9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -544,6 +544,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	if (region->fd >= 0) {
+		/* There's an extra map when using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
