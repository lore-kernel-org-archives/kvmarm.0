Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6512DC43219
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 19:58:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E1F54B733;
	Mon, 17 Oct 2022 15:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OP0EUl52iige; Mon, 17 Oct 2022 15:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6774B85B;
	Mon, 17 Oct 2022 15:58:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A0684B6FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VhTanwvgX2ZC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 15:58:42 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 634664B6DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:42 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 g15-20020a25af8f000000b006bcad4bf46aso11407981ybh.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 12:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=frMbmYegxOtgtF+Jjq9ubWz1wi/u8FMIRL0o35ogzl4=;
 b=FVyKm8AJ9lqnXFMnIVBf1tOS8wOQDtJ+Xy2Uop4XBqDNwL3RFWY+6erwzCG4KmxWyA
 WZy+dunuyl1K6cd9rROWRme5kGxDBVofrIEsB3JBAKNLqikP1XSuHM9j14eHUUeImxqk
 qX1+Dll/EhKGvxElhbloQzt2Lhb7zAmFtayUrXTAoCHswiZl5ohjLjTsqMTTh7zgp3mA
 nhe1psiyPBvpZW/NFmG+yf3uxq0ibbR1GQ59RjnF+lJvUqyZqNf0q+03LpGnBEk9YPRk
 RXbOgoJpQfT9u9z4ldIcQPCmSwQ/sveTptXYaLP+g658y8kJAW218iP5/44HgdcEZA7e
 r+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=frMbmYegxOtgtF+Jjq9ubWz1wi/u8FMIRL0o35ogzl4=;
 b=3bWHmwn2TjX4+oJ2Hhb2V0HUUibi/CBx0yYabg4mwrIre+sN9qWCWdJfQ2iBPo34C8
 viHALXTQm9TavVe982aO556zfhyPEeviFTbdEHbEM4bEB2I1CBbCc/FcdKI6mzfuiJkX
 p5qjyzTS0V3r4OZ7FzjlGTR7G3WJh0YBr2pAttbEP2E75+D/oX7+26/SciR6mx1b02St
 N3tCp73t7+aDbbS7v88RJUeqUFf08bOeOU974BpoGbuPExnm7e/35c/3TFBvgnSOdRy+
 ps9BEpAtETABHDk9TMd1Ht+FCOeHf5b5+U74saZDBUC1P4mVqshs9nGrQThM+SiBPvmZ
 YHfg==
X-Gm-Message-State: ACrzQf04QkIFP0OVb69tX74uV5imSPtFSRdNiV+T+/GW1syxtcueQZyU
 N5hXoQpAelg27XNdA4E215OwC0WmHn7WvQ==
X-Google-Smtp-Source: AMsMyM4tK2eFk3WKl8NqSllJ5w9+Cb5/5+XGTB1ov7n5qva2uCfQFWIm97I3xkvFqYDqfYIWH+X6VbW9OzHK4g==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:4004:0:b0:6bd:5cd:9f60 with SMTP id
 n4-20020a254004000000b006bd05cd9f60mr11379639yba.292.1666036721981; Mon, 17
 Oct 2022 12:58:41 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:23 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-4-ricarkol@google.com>
Subject: [PATCH v10 03/14] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 andrew.jones@linux.dev
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
index f1cb1627161f..19e37fb7de7c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -586,6 +586,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
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
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
