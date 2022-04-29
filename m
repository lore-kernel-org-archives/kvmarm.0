Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB004C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 15:48:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46B9F4B261;
	Sat, 30 Apr 2022 11:48:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bb4Ug4PEK6gi; Sat, 30 Apr 2022 11:48:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 707BF4B29E;
	Sat, 30 Apr 2022 11:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFD3B4B091
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sNjobEVcn8VW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 16:11:51 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A23D84B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:51 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 w3-20020a17090ac98300b001b8b914e91aso4531390pjt.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 13:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=S3BBsZ5bvk4uzoCkIECYzRGc2TYJKfjLopd3GTSDAKA=;
 b=jyU87f8rJUN/0hbg4f3kdULDqmUiyc07Xb66s8cBmC8eSW5afxPVORIXgO/XcbFugu
 /GO6FtfJ4ZPnIibnkDPCd2vWdazZzlWxhMF1+MfgeVHE4EB8soDI4WiD7pxUHc0XysjZ
 dz0NPsguoIx0yCM0GzW+6AJFD3eMtBn5IljqCyl24S9cni2H7/qF97uyykmSQ8zzR3qj
 0ctQn1mlUvVg2EZJl93vg7f3fTcTbPn8ws29rj4RPyM04s2wTJC2/9P5OL5vwTLWBxg5
 QDDNee7lmxpZqa2y/Fn8/pPEocI38Oecy4dHL012AY61PD0PXJ/gQDtUls02A2N8uheX
 E/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=S3BBsZ5bvk4uzoCkIECYzRGc2TYJKfjLopd3GTSDAKA=;
 b=iZtDdYuFa8F5JOoYOpJW4Io8DUGKKQ4QReQIyIj23vMDBYocURlpj6zG5GD13erfMk
 KB2ZhLULUyyF9M8HRxdxgtFrTAhTN54EsuSKF9jAh77qzm32ZoNCrm6DDHckVbn2j7mG
 K247ZE5EFJRsQSXMHXyAZZOj7goQ09yieovm0cPD3vZIfFAQtt3dABmstwysFyZ44v76
 OZnhW7NO3u1yKJEEN5CWqPT1NLIOxRBSxWWJRwoaRqbK5YTR8JrssXWmQxlcmWaSqCdo
 NURKfT2Egn/iEAhQ6VL1Da9iADFE0scIN6FhCY4xLpNhKeuy9FaBD2VMcGksCbms2GC6
 UYoA==
X-Gm-Message-State: AOAM532dT+t1mGAv93+f8u/Nxws3gPEQfZ5sQw5lmJ+NHhQE4jXh7rlw
 xzVHW2Tc8Vd6ftkB3KKgLZ2gBUYGS4UreD3r
X-Google-Smtp-Source: ABdhPJxOmVuJGvLk2Hjh+EQ9JUFzd7qmz4ZeddVRcuaWheP9plljXX7Xz37I8NLuX36SAI5J9foHUODTgkzaf7D4
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a05:6a00:1411:b0:4fd:e594:fac0 with
 SMTP id l17-20020a056a00141100b004fde594fac0mr831484pfu.79.1651263110818;
 Fri, 29 Apr 2022 13:11:50 -0700 (PDT)
Date: Fri, 29 Apr 2022 20:11:31 +0000
In-Reply-To: <20220429201131.3397875-1-yosryahmed@google.com>
Message-Id: <20220429201131.3397875-5-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in secondary
 pagetable stats
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Sat, 30 Apr 2022 11:48:22 -0400
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

Count the pages used by KVM in arm64 for stage2 mmu in secondary pagetable
stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/arm64/kvm/mmu.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 53ae2c0640bc..fc5030307cce 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_memory_cache *mc = arg;
+	void *virt;
 
 	/* Allocated with __GFP_ZERO, so no need to zero */
-	return kvm_mmu_memory_cache_alloc(mc);
+	virt = kvm_mmu_memory_cache_alloc(mc);
+	if (virt)
+		kvm_account_pgtable_pages(virt, +1);
+	return virt;
 }
 
 static void *kvm_host_zalloc_pages_exact(size_t size)
@@ -102,6 +106,20 @@ static void *kvm_host_zalloc_pages_exact(size_t size)
 	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 
+static void *kvm_s2_zalloc_pages_exact(size_t size)
+{
+	void *virt = kvm_host_zalloc_pages_exact(size);
+	if (virt)
+		kvm_account_pgtable_pages(virt, +(size >> PAGE_SHIFT));
+	return virt;
+}
+
+static void kvm_s2_free_pages_exact(void *virt, size_t size)
+{
+	kvm_account_pgtable_pages(virt, -(size >> PAGE_SHIFT));
+	free_pages_exact(virt, size);
+}
+
 static void kvm_host_get_page(void *addr)
 {
 	get_page(virt_to_page(addr));
@@ -112,6 +130,15 @@ static void kvm_host_put_page(void *addr)
 	put_page(virt_to_page(addr));
 }
 
+static void kvm_s2_put_page(void *addr)
+{
+	struct page *p = virt_to_page(addr);
+	/* Dropping last refcount, the page will be freed */
+	if (page_count(p) == 1)
+		kvm_account_pgtable_pages(addr, -1);
+	put_page(p);
+}
+
 static int kvm_host_page_count(void *addr)
 {
 	return page_count(virt_to_page(addr));
@@ -603,10 +630,10 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
-	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
-	.free_pages_exact	= free_pages_exact,
+	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
+	.free_pages_exact	= kvm_s2_free_pages_exact,
 	.get_page		= kvm_host_get_page,
-	.put_page		= kvm_host_put_page,
+	.put_page		= kvm_s2_put_page,
 	.page_count		= kvm_host_page_count,
 	.phys_to_virt		= kvm_host_va,
 	.virt_to_phys		= kvm_host_pa,
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
