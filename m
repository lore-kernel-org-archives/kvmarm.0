Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65523C32796
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:47:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F33B4C5F7;
	Tue, 23 Aug 2022 19:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zDEGU8RAluvu; Tue, 23 Aug 2022 19:47:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17A2C4C5D8;
	Tue, 23 Aug 2022 19:47:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60FE84C5FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MprWCdSBmoLx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:47:44 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62CF64C5F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:44 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-334228502a8so266751967b3.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=ut/GA+FacZO/IB75yXmt4cp0F5A6fO+XeMMzxlRyVIU=;
 b=cvNckTePqyKO1Mh/7TAP/WBZP+qSdz3i3TrGqaC0eQEVKAz+Qb+Apyk/bM/98OrDsm
 b3LcSyR7T4ZgjU7fNlm7pnbeS6dH+5m0RcADT3zB/3hL0zs+qvJNwbPms9/4JQfdSAeY
 mDESXd4zWNOfzwEvkqxJ/2PBE6yrKlC2REnoEO8X2kYFEJs2JgNGO+8OZJ+1fEm4Wvw0
 k++Y8iPuWlTCYZ/ABbm0idizeIZCVubCMpOL86WBnAMS6Fv6McfYvqQXbWlJxV0xbMz8
 l7Je9ry8yT6RYmYS9D8u0HhJ61qj2Gr8s3EYz3Io3ludDm/DJ1tPiU1HQgQnP5kvKVAE
 RCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=ut/GA+FacZO/IB75yXmt4cp0F5A6fO+XeMMzxlRyVIU=;
 b=Prez9QjhwwDAb9Rrh103QefEx+Q8NB4EJrn3vJSUql7SfzPcMRZfm2OalO5mQZF1rY
 na8xHOZHskxkyXONmgqMU9o55PGmk7arsjvgUHGMhJ3IDJM+FBCFIyIMZHYUFAgZsuEh
 g2p6DzT9zzV4sX1YF2YrS5HA3vZfRsGpmTQfETYOy7+AWRGeLKd75J0LE0QPRawf+mOW
 Xo6/QLDpzfDTEYKHwiu/Fn6nEZ9PInnYdn+kaRaMEw9wmdOKjLI9DOXa0NPZFf5cbNXd
 6iEq6pD9cNv8RfrDkcI1bdK0+8ohSaIwTdNIbHew1Gw8S77qThXuZ11PzpFgEKT9zBzF
 87RQ==
X-Gm-Message-State: ACgBeo0NVxMqrTJ4gihC3ztodjlgdK4TcImGHBnwFMQ2pemxrzd1Xpuz
 MbhiNMfn/kfA25UcTfEm02skZsBVRgLMag==
X-Google-Smtp-Source: AA6agR4sRR2WWTTG8vwM/bgxmvAP2fbom624sLHsF0EtT7FtMy8KhHDQYKZdab9+Gf/VZnMuG6NGdHSK06u8ew==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:5c4:0:b0:67b:89d6:cbf5 with SMTP id
 w4-20020a5b05c4000000b0067b89d6cbf5mr25468398ybp.286.1661298464038; Tue, 23
 Aug 2022 16:47:44 -0700 (PDT)
Date: Tue, 23 Aug 2022 23:47:20 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 06/13] KVM: selftests: Stash backing_src_type in struct
 userspace_mem_region
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
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
