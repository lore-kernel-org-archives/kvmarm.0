Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BC3C38145
	for <kvmarm@archiver.kernel.org>; Tue,  6 Sep 2022 18:09:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DFA14BCE1;
	Tue,  6 Sep 2022 14:09:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zzEyjNtZ2XHc; Tue,  6 Sep 2022 14:09:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 401CD4BC47;
	Tue,  6 Sep 2022 14:09:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC944BB84
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NlxLSMCnb6rb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 14:09:47 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A1134BBF1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:47 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 i1-20020a170902cf0100b001730caeec78so8186800plg.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 11:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=0SMylmi5VoKukevMCg329nqGKx2bQIjB0CpF+sxCEys=;
 b=j8CaVHHKMwtkw0CT4wOaawapBm/83lk9MV8o9HK1oFoiBAmmJWSgFszewtB/f3aQyr
 qv/JSfwxX2JpW0vWeCmAGyOlt364lyU45six1Bn7jxSwk1hRds9NCVd8HnDXaX3/t54N
 WAEMsZQGcEhGfN3hmUubAgn2r0bSdFKS4qXIgBRKdIfDiKrmXQc+8JZxdGAEA8nrBSFt
 NIrLeiq9SLXBTVJuXucL4lfRRvz7OxejDvDcpAy+YIx9oseJcxXKsu6ayKICw2P9jiCl
 PFBlJ7ebRT0xjADDaA+e8O2gUgbW1uOY2iymZ/xs8mC8u4nibHnV7E765pM2IIj5WIcA
 teJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=0SMylmi5VoKukevMCg329nqGKx2bQIjB0CpF+sxCEys=;
 b=Hn2WNf62KEf5n/nkrUPA+tddOF4+aAxTpzyBfStX158k3GzzGbs92wduiwvcVg3TaN
 Py1K6OPkwxehOjfwCGSJYtd81i099qESvzVZZewJuWUqEjCdbX1LA2gxXGBqYJC3QV9t
 JxyOR5CUV5YEigYQ8jGD+eIyCwM64VoOxp1Jnn20n3bU9DsoFARDib7VY5pWOrJFQD1w
 db+Rf5fj3sKDFDaqcNSMW0iZe0mm0XLyboOj1hZxxFKkiP9ZvFgcwt2BmLFgwKFViHiP
 2jnW1PmLNxMayfySQjIysRCvBlA3/gJ3Zt3STJ6WezXMFHvT7CZIozbcNj9+Z0paTa00
 zpMg==
X-Gm-Message-State: ACgBeo2Ymj+hW/1EZrbZZbAv79h50C946Wf18OElhWsuWSFqUHYL4Qqa
 FfWC2PluTJSTBddvAnSSjCMsVe7OJeiq6g==
X-Google-Smtp-Source: AA6agR6nO2Zhbp7vYQuiuptLKxsuxovt2DSw0/ssCA5XC63l+hdsth9veFaamYsFWfvkP59eq6149XXlA8B55Q==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:164f:b0:1f5:4ced:ed81 with SMTP
 id il15-20020a17090b164f00b001f54ceded81mr25678999pjb.122.1662487786468; Tue,
 06 Sep 2022 11:09:46 -0700 (PDT)
Date: Tue,  6 Sep 2022 18:09:23 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-7-ricarkol@google.com>
Subject: [PATCH v6 06/13] KVM: selftests: Stash backing_src_type in struct
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
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
