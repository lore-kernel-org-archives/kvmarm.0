Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DC7ECAAD5
	for <kvmarm@archiver.kernel.org>; Tue,  6 Sep 2022 18:09:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D38E94BBB4;
	Tue,  6 Sep 2022 14:09:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XrLuHny4koAs; Tue,  6 Sep 2022 14:09:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D31774BB9C;
	Tue,  6 Sep 2022 14:09:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC6AC4BC64
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fBEs6OHiua2d for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 14:09:40 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC7124BB94
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:40 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k14-20020a25e80e000000b006aa1160dfe3so1209583ybd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 11:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=Y+OPxQ5AWFMtnU0dHjjR3+DOg2GIHj7/VBS3FzZlKj0=;
 b=kN8zzv7uiZEn8zwiQPHFwI8t63lHXUuE8j8u79e7MDqO/PYCyCdjx3uq2JwQT2YMA8
 vr49Vw4PR1tiDGjrfMp4SuYE+8PyKDoO2sWdl3Tbs/mZ683Ox6Q812fCImU83PN2B1QT
 PqQ9w7fXuY/VzfpM1hvi4JJ98op2j7fPdVVbzVj2OoufLWSXyYhu+F2bcuaebYVVLqCI
 R/b7rIa/UhFWjIQqoMxxookySHSMoDfE7Xy0tJpke5tQQy2AnSEQyu+mAwEmwmGTtN4j
 YtFumVaGUpvJY48IJL/HMethavHUcah9UExsZ41xwaJXxOxNysutwu7qz1d11SS05KUR
 9mQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=Y+OPxQ5AWFMtnU0dHjjR3+DOg2GIHj7/VBS3FzZlKj0=;
 b=P2nQ009Ar7gNC2Z3iq2wY2e8l8JaGvXUn9YUtgcRK74JR+jRIjXPunXDnr9ORn7N5r
 g+Lu8VZFZawsT+2IFiSDYi4S4LOY1549h0mks1Pg58wLIYRpxBO6ehNPX2j8us21E7ha
 J58lqRMpnzg2UpM/KI2s2cVkuR0EqjfAeaQ6ya4zHbMs00KcGjnzt6gvZ3UD3VWjeXHA
 GjpkOXMiS5LOZIySudmp7kUdRl8BlImd451RHr5hkB87QmCK7ThpbC0oMVuGSOHZRlO9
 O8JTNDgQtkQZ0AXyksmmDXy9+PS2a9hwDDP/bxwaiy2AjCqJ7fUIx7qKLRs7KHGuEGf9
 SusQ==
X-Gm-Message-State: ACgBeo1yI6r0IyrT0A0LVGShDx+bmYDFmE4tFBJNJOVHMkDoUL11iFaS
 9pO9W6HxhTMzu5OHmo8vTkJysZN+2qOcDw==
X-Google-Smtp-Source: AA6agR4ySKWHnI41ZN/mG2ne0AGMDwf5L2OJtYAPLM0Rb3A+J+MVOfmECZFXwRPRqhGuYpuf0MM5DeqYIehqpw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:c986:0:b0:325:1b81:9f77 with SMTP id
 l128-20020a0dc986000000b003251b819f77mr41841979ywd.182.1662487780294; Tue, 06
 Sep 2022 11:09:40 -0700 (PDT)
Date: Tue,  6 Sep 2022 18:09:20 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-4-ricarkol@google.com>
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
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
