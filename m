Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A090C6FA91
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:26:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5054F4B649;
	Tue, 20 Sep 2022 00:26:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fJCRkeFsTQV5; Tue, 20 Sep 2022 00:26:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 353A14B645;
	Tue, 20 Sep 2022 00:26:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 122584B650
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:26:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jwp7BjxQzxu3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:26:04 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 091D04B637
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:26:04 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 np18-20020a17090b4c5200b00202c7bf5849so456294pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
 b=QxaQjNEOBDnusu2qkcgUEhIz5e/Ww6Dm+kK5u4PD5jYLMNd3KoeWYKMdQ4abBg+IZ4
 DDHAdlqIgfouDwWio46wIDvot2FekExykgoHaDB8achLsH4g9Usx8akp4W+s+eAfHF7h
 /GI6hpsopKlPh07YKMXechsoW+Dxq7NuIbYozTzyqWF4N6yX6Iw017RDq6h/tHWxZmd/
 lpDwjPaY+EM+OmDKbEisojt7Yu/vD3Gkriupmq7bcfNXIma9cLyKYTCCTiCeRaTLbhPP
 r67zIPaskZpvfx+0rfmS/QKGxVlJQrWYEEMRD0l2XxPhYl0vUP2OLEKfcVVRF9Hklat2
 +nQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
 b=cSETZr8t4LZTw4SGLGrwESbsAD6p1hZxQNfdm2VWmcslNw45A7EN9dbpB1f6QebMue
 9RKQgn9UpcL3DbmuDhmQohCc69urUP8JFnrkX0JEih2wG424r6DceneJ4T1Z7Fv+pq3A
 FpVyD8NQXyJwV3hv5PeZwiDj6Q5AGC2LdD1xFprftbtrZIKvZCbsZ/WBwc4cyLkO8PG3
 jVxwXldh0rDpXoK6Br36fz5eHdqN38AU/O35IH69TRj/LH14q2lPdRyJNzPuV/q9rJsH
 TDrzWVZHrmfftifKbU+KNhl9QOQ08gJMkjvUPfDuZygnMgZJXzkkrf6isiZlc4ZdOdoi
 3MVA==
X-Gm-Message-State: ACrzQf0LPgMszueCqFQsV/pb/v/rz9Wys+IPepgt/QC/QtTanLKb7F+C
 kojltKPqD8NPo+obak0gNxfdaFIV2eujfg==
X-Google-Smtp-Source: AMsMyM5SUzY8xCCQhDd0p56bLKQpUUnYjAdA2w6tayk2PFpxKzMRKgn2eI5jMjxPGilgXI82xX9/TMvzwXtp6Q==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a65:4303:0:b0:439:f026:ccee with SMTP id
 j3-20020a654303000000b00439f026cceemr10682373pgq.322.1663647963297; Mon, 19
 Sep 2022 21:26:03 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:25:44 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-7-ricarkol@google.com>
Subject: [PATCH v7 06/13] KVM: selftests: Stash backing_src_type in struct
 userspace_mem_region
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

Add the backing_src_type into struct userspace_mem_region. This struct already
stores a lot of info about memory regions, except the backing source type.
This info will be used by a future commit in order to determine the method for
punching a hole.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..b2dbe253d4d0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -34,6 +34,7 @@ struct userspace_mem_region {
 	struct sparsebit *unused_phy_pages;
 	int fd;
 	off_t offset;
+	enum vm_mem_backing_src_type backing_src_type;
 	void *host_mem;
 	void *host_alias;
 	void *mmap_start;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9dd03eda2eb9..5a9f080ff888 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -887,6 +887,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
