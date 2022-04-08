Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEA8C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 660384B086;
	Thu,  7 Apr 2022 20:41:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ePRKk1eaRX-u; Thu,  7 Apr 2022 20:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 452B84B15E;
	Thu,  7 Apr 2022 20:41:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F84D4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0SlERabXp2QN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:32 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 598064B15E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:32 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 x32-20020a631720000000b003981337c300so3891805pgl.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gARM1z8TWPcLta8zngl9X4Eb51iL3uDEv2L7Sujnzmc=;
 b=fw0w/2HTVE3GHwYT1kKkJB7GGiQbxbK9jPoy5eWfwEScRi0F0XDRRYUhcnPlZ/PSoi
 WY+2sNSJC2ulW6fEg9q4lijTezcdTH0uVN9GxUZxP9rhLf2LFJl8tw4nAV/fN/0tHoiP
 ghyC34QypLmnPRiEVcckksMmnDFrzt19JZjE566PTMCPd6IbrTXCAhN9pSH4/d7ncPnL
 zEU6m1GWInfU1cMZ/EN056sjlcONS2cKuviDNJ3kzwZib5Mtu9aaXVoL5jaHFNjAIR+v
 Oiju7dlEh2c+CJRn/LmPNijfh7XJ8R+FSxj/LMoFbteb9iFeJE66Jo7O3NsR2uxRCEXd
 ESIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gARM1z8TWPcLta8zngl9X4Eb51iL3uDEv2L7Sujnzmc=;
 b=SwnIq8vGxIdJzHSvnTYVjeq3sIu/P/3PUKumu06MJTa5aWoApPUe8HNt4z4s8JNjdG
 9GRG9qitsnEXs4R1cHhm3mt727sIJpXtaShpb0XD1opA9FD4o6SQQUT8jCcTHQw1m7Ml
 kt0dklEliB5Geo78GgIeJISurGMmX/DX1Wzy3q2LuQ6A0vq1QsvqDkpx0wnLPA+onvUG
 3/xWejYGMLD7NW1NQc3v/ESmvRO4/2EyauuyVSYyFpc2D9gYz9iqoFilyOpoiYvv1mUP
 2NgWkHbqN3MxU3NGSl0xEInqf0OvXXtsh2rZ3GgfcCmgrhYfdbWwt9nlglkOpFxicC90
 nFnQ==
X-Gm-Message-State: AOAM5304aZXU6rbRI/oNlEZdeloCyajN3CDHl8b4Y3WaRBwWXsjNQ2DX
 Q9FHVN/yRjTlUBwSsXEm4XMsDXlOGmj92g==
X-Google-Smtp-Source: ABdhPJzRgN+sMT9MhT0Mu86l71agS8/aGmuvBBJg8sMMx2/UHmcc2ZsWJo6jNZwn4d6Nf44QLSwyUyjz26442A==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:db48:b0:1ca:ab67:d75 with SMTP id
 u8-20020a17090adb4800b001caab670d75mr36135pjx.1.1649378491209; Thu, 07 Apr
 2022 17:41:31 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:12 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 05/13] KVM: selftests: Add missing close and munmap in
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

Reviewed-by: Ben Gardon <bgardon@google.com>
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
