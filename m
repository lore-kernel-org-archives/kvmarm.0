Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33927C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 01:06:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7C8E4B641;
	Mon, 10 Oct 2022 21:06:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B5dlRSyzeXX7; Mon, 10 Oct 2022 21:06:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E41754B63A;
	Mon, 10 Oct 2022 21:06:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29B5240B92
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 68sJqK+tptu7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 21:06:39 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB8524B492
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:39 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-355bdeba45bso119016757b3.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 18:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=+2DRG2ktbVgPO8gWevB+QacaOchvfaRovAISZPDw15A=;
 b=Ru9bE6+5i93s4ljKiceTT8ECQbHky9nEIOqC8q7N246aJaSCSRd6yJpd3YA9r1JH3q
 MZNmq1Rh8HknqDV5/Y2ef3KeOA7gbWjKkOJjtZKLNy6CwzObUCvwuJ94MZUdQIdIt3t5
 rld6OQuiY7EwKvi6HlTVjSt8Zzn8vTi/7K8RkPUIaQm+SIfAYNXoQc2gpna93DMy6OhN
 S+TjEJvpHNq292kKLI8g5vsyjiA4WSQ3iBMt7uYFt0nSjVAfsB56XIbr5tgEoyM6Uurs
 Q3Wcm3O2LaM+77RJBgCbdjEBwKVFy++ZvYW3DeyDmySmR7oaC3hawVRK/q2WuRrFpVwc
 h7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+2DRG2ktbVgPO8gWevB+QacaOchvfaRovAISZPDw15A=;
 b=nDb8Y38ZglYSFuNp0wzcjdK3tOBwKUvy+ZAK/6+wdzevRE/rJmd6cO+0+U/GkDwhhm
 cYRD24arvs+HBeTKcOgcDkgDK2x5Mb5GEAQ4dxE03wX+cBRZI50JNqoR+hDOkqhPXHcE
 FzVNxntD8484MynrUZWcLf0FKAQyv/KKFYDG9oXBTEJN+5Q3RnKQAEBWDcIH9WuQAk3z
 6wXUGl7M0jmPo5nxRS3vpPwEYGTQV/8FxzEpyV8HDlFVy6pAxhYaL2geDwS9P2R6GUjT
 E2W+A10ISASWMPHOBh5xrcgoZxgad3Hv8N7DdBIP4fSDMMOE2/iqFA4RFwufY2WVoC9T
 BbGw==
X-Gm-Message-State: ACrzQf3oIrBRTaWOIYgY7ZtQ2YmMSiPwd2qs58ygX5Ms0ypm2kftQXEc
 Lo4OtgaTRg777qPv3TBd98XDGnSBxfYwVg==
X-Google-Smtp-Source: AMsMyM519m9aB8GgfmipRWMBbUudlcoeRl8tTANXBJmjT5KugghKlNS7g1jd54VKWTbbPMxzI7dyinv9UFoveA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:d78c:0:b0:360:bbf0:ef88 with SMTP id
 z134-20020a0dd78c000000b00360bbf0ef88mr8633791ywd.206.1665450399492; Mon, 10
 Oct 2022 18:06:39 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:17 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-4-ricarkol@google.com>
Subject: [PATCH v9 03/14] KVM: selftests: Add missing close and munmap in
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
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
