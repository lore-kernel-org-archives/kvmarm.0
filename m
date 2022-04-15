Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6835BC43217
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 220714B172;
	Fri, 15 Apr 2022 17:59:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MXLaDMdmt37D; Fri, 15 Apr 2022 17:59:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CF6402DB;
	Fri, 15 Apr 2022 17:59:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6394B102
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HqCiTnrCx5Go for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:29 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16F3D4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:25 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 a9-20020a5d89c9000000b0064cb68a9ba6so5444817iot.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jzvc81PBGj4bV/jHUjtzPtFNqWylMffaehwRBxD6iIE=;
 b=aWkRKsBqnouPuu0iRgQFmbdZNwM6u65S9STgd8WzLazymunDNq+F/2LV041lFacxkX
 sH2au5CIL4U6btbR36TcgERHcBL5JA8T93pnN1zy/vCBpJyTdEx4s8aDOU+JwJD7FEgH
 EDuCMiJ2lKlmqCfo2HCyFA8YBpzh+0As1Im7YSg7MivXDgsyltO1HdVbeLv+yGFmNIPi
 O5p8sXbUH14m1SBo2J0fuW1TDCouol/p3zaCmN7Pb1tclO6RjKEsMyqqJ0eOLp38uD1h
 AbzgBBIOOsbBeQk1WFRiKNO/0k6ugAlDvMy5k+FqVLVzTLXvQl7QmS1J6MjDvDSfP9W4
 9n1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jzvc81PBGj4bV/jHUjtzPtFNqWylMffaehwRBxD6iIE=;
 b=csk31JfwRuErr0ue6Ll47mu1lcsLqvn1aeDozyXBBWgmwF6PpULejvtVBoxg2eKLa5
 /XEQlQpsOThGf+UA2PyLIh7eGCzjlzK+kpPYoAIjXTKt2bTbUp4pWaxpFxrDoFinM7bu
 eaHpbxrUwQp+lBH8VTqw9hl6ZiRu0+HP1Lj8In+kZ9HBOgh4JltsJg9Sv/aLWxuDylD/
 VpaPgrIJ6ZKkOD90lMie0wX6ek8tFsw8cRxpsuzGls9yZrXDfq9+AJdgNtgvPEhlN1bY
 51aWspL8anzHrmMub9J4Zzizj3mey8KxtWok2scocjNMR0MygVD7oLj5A9tmBHWkrju0
 3zLg==
X-Gm-Message-State: AOAM530iwhO9mcFPMRbhkylyVugo5ZN7lw2TsMJWuv/DqkmipkLSa5tl
 eDj9RkNRPJweSYpaVRXPf62aSe7bcSH74SbCWptgYKEKzAWZ3jZuZT1YKgE92857pVdA9/g9uve
 Xf/fViNfhCNwyb1gMwYMzzGJXYjT0lcSsjrZiMZH+GEOiglH1V/vk3Cx34W03YdGUd5omVg==
X-Google-Smtp-Source: ABdhPJy0T0D9tPSOS2fkDjAWGdXFAsgYKiBOBw6Vv9SkS2qbIf2KOV78tziChH3+cjdCnnpihxhBubRLicI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b0f:b0:2c7:9a3f:6e84
 with SMTP id
 i15-20020a056e021b0f00b002c79a3f6e84mr312271ilv.32.1650059964470; Fri, 15 Apr
 2022 14:59:24 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:59:01 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-18-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 17/17] TESTONLY: KVM: arm64: Add super lazy accounting of
 stage 2 table pages
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Don't use this please. I was just being lazy but wanted to make sure
tables are all accounted for.

There's a race here too, do you see it? :)

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2881051c3743..68ea7f0244fe 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -95,6 +95,8 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 	return !pfn_is_map_memory(pfn);
 }
 
+static atomic_t stage2_pages = ATOMIC_INIT(0);
+
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_caches *mmu_caches = arg;
@@ -112,6 +114,8 @@ static void *stage2_memcache_zalloc_page(void *arg)
 		return NULL;
 	}
 
+	atomic_inc(&stage2_pages);
+
 	hdr->page = virt_to_page(addr);
 	set_page_private(hdr->page, (unsigned long)hdr);
 	return addr;
@@ -121,6 +125,8 @@ static void stage2_free_page_now(struct stage2_page_header *hdr)
 {
 	WARN_ON(page_ref_count(hdr->page) != 1);
 
+	atomic_dec(&stage2_pages);
+
 	__free_page(hdr->page);
 	kmem_cache_free(stage2_page_header_cache, hdr);
 }
@@ -662,6 +668,8 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.icache_inval_pou	= invalidate_icache_guest_page,
 };
 
+static atomic_t stage2_mmus = ATOMIC_INIT(0);
+
 /**
  * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
@@ -699,6 +707,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
+	atomic_inc(&stage2_mmus);
+
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	return 0;
@@ -796,6 +806,9 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 		kvm_pgtable_stage2_destroy(pgt);
 		kfree(pgt);
 	}
+
+	if (atomic_dec_and_test(&stage2_mmus))
+		WARN_ON(atomic_read(&stage2_pages));
 }
 
 /**
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
