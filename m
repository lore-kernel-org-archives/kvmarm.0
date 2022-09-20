Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69562C6FA90
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:15:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E27184B739;
	Tue, 20 Sep 2022 00:15:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tmLoeDs8W-M4; Tue, 20 Sep 2022 00:15:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB324B6C8;
	Tue, 20 Sep 2022 00:15:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA2A4B629
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y7qMB1mdClwO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:15:20 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D27654B6F9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:17 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 r62-20020a252b41000000b006af00577c42so1101647ybr.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
 b=kxmzAzbRSSTmS/necb6FSVv6pOQxsL0i1TKoQQkJzxVpnz6tGtjcVaaklDcLGbUrk+
 joWUq64QCKwGg4ZH+Pmid3mVhBwqX/jtj6ocDSh60ZxPJbMfz793LvV1G1rOUSyWVMW7
 +YJTy+bqPqOwHDb2vJ5ZpuZbRONzDrfo1nmDJ0S751UuB3WUO9oobSow+G7IwVsGTFHk
 Y8Tx4t89Lh6aiwnZlAJgPwcmmaMsncZNCUw+ReiKUpUAW8PLOdJ1RAHq2oGtkbG6tLbb
 HWSvstxZ+QSgKh/OMYyPJr8FTKLATudnX55pqZnSKa2EARd9Cbd5zTrkxrUTXcLWIwwi
 HcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
 b=s+zXJScfJqnes91y7u5i/I8TfecxYIrkzCEBdSKVoyGwk0f34HSR4jTv0iKPLU8FGX
 NQUUhwFJxLBCG3LPdNUVrn87vpynAChmAUUbx4T5LnS8Z86PX9gx8YKXnUWwbSO+xRZ3
 PBev9hs0Cd/9RaK8kL2PKjCoRBB8VGymYT5q+TjDT52bkc+W3FrZa1VKA+3NqGoTJeGw
 x9z4MmAno3RHSAwb4ZE1mEJ3OnJMgDSu+da0AMDRjMCSePz2DAgVdQSQdgMWpg5Wgkty
 tYGTqEP9aBxVD1d+ICTKUQGhc6UB5Bu5h13x0Qh3wWjUJHVYm4cir63WH3vssdu7k0xM
 44WA==
X-Gm-Message-State: ACrzQf1hohc3jUyuzCF19ZMWTldtA+iw1UaZjL3/HkZooLP0dc6lg4HY
 6adWhU7Zek+9J2BBm55g6iYKc5IsC1kABQ==
X-Google-Smtp-Source: AMsMyM4JNtOCdb6R8HptXS8YUiTx/ILZ4Xh5QhI7jbZOyJFuBxoaMBBtVCq8X3G0fqCqeU/ItHPx55UZnBKgNw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:1102:b0:6af:d093:7f2d with SMTP
 id o2-20020a056902110200b006afd0937f2dmr18517821ybu.642.1663647317295; Mon,
 19 Sep 2022 21:15:17 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:14:59 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-4-ricarkol@google.com>
Subject: [PATCH v6 03/13] KVM: selftests: Add missing close and munmap in
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
