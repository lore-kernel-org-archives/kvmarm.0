Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35D6C38145
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:47:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FBC24C5CB;
	Tue, 23 Aug 2022 19:47:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0A0UuPKMxB40; Tue, 23 Aug 2022 19:47:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B804C5FC;
	Tue, 23 Aug 2022 19:47:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89AB04C5CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 82gBxUK2Mbhy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:47:38 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B3C44C5F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:37 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-3339532b6a8so262851727b3.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=7GdMmXimiZ4YWrwJpImAuE2Hv/nIHXwvZnlXjRcc/Ng=;
 b=U50s677MuXtHCA+m91knSsMiooIAUVYZ1qG5V8w4MZHNwAzh/1qjoz/1WZ2I30aieX
 Ud5aPr/Q0WD2gs6vc32nZjVfDIwwE8UcXp5zn52cbr6aR+6qdjDjofpcCiOCA5VTPUGO
 Y620V036bl+U35DOe9ACtyBfcKsKQ+20ljhSCkF7/6593InGuJa4oLhzsG1AFWyUlzLy
 1sjCh6i7YqeRUuaZzEzfnX5ogqUcMo9ZWdYGVTFAeV1uZOTXIuyQaBdqMhHrnJc8X6df
 QNOrRObf28q4PaPX3JDubRbZEOzU4NUjvkSJNgqHvne8+3QDN7dSBEl+weJAX9lR5Mmm
 DbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=7GdMmXimiZ4YWrwJpImAuE2Hv/nIHXwvZnlXjRcc/Ng=;
 b=VwDkEWLyZhUUn2PHjYIZNbVmWbXRokXHa1nYVjpXjpUq+wEauyTrF1gLV8DPqOt4qx
 juO6IHtJZqsbQ5mtjHUiiybw00Feuo1KddKYyaDLrhe87JNn2hozZz8Jo0ULkQF3l8z/
 W2LoSXYsykLeRDCUyNnfsPNnbzT1zfOPeaTzuU7TFvwfj7zJapXaS6iC0+qVucCpd7B9
 aVvufd9XQ651qqQEGki6ebB1oDSauW2l0pNfqPYxHFSHlb75Oqdt8eZ7MAA/fjiOd6UF
 z+QYklDogJnT/P1HiWvUvSc9k3NyilziUGnYuV3Unfe0PNMEAFN3VrT7uMOVuxVANEah
 msSw==
X-Gm-Message-State: ACgBeo1WGIbbSN3jYOos55MJK9UYHeGnXZqDMwdrSDPtWbm8nVkGm0S5
 nVmmGsU5Lrw7KUixcW9DjBbuGYJRTIJpJA==
X-Google-Smtp-Source: AA6agR7swNIj54jtNeww5gCy36Djcb8X4Yhe0prRsiQoWTaTJSOMakGqlqhqIwD1Zd62icVZoFHiY7AnoovWUQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:da83:0:b0:329:9c04:fe6d with SMTP id
 c125-20020a0dda83000000b003299c04fe6dmr28577685ywe.196.1661298457217; Tue, 23
 Aug 2022 16:47:37 -0700 (PDT)
Date: Tue, 23 Aug 2022 23:47:17 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 03/13] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: dmatclack@google.com, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com
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
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
