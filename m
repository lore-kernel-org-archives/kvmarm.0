Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F33C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F37BF6135E
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F37BF6135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A57EA4AC78;
	Tue, 19 Oct 2021 08:13:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nrRM3sH6Q44H; Tue, 19 Oct 2021 08:13:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3874B0C0;
	Tue, 19 Oct 2021 08:13:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6C0A4AC78
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GH+RcvqhbXSG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:27 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93B8B4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:26 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 y142-20020a1c7d94000000b00322f2e380f2so660224wmc.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FltoTPFX6jcmVGDt6TNVLWqV+gbyvD26Qibq15L3bkE=;
 b=jlG1oEJu0XALf3UMY9dDzZLKa57GGILI3CeQZbwtRWFXxRmxyJ4hrufsS2cJNR8YIr
 JNvbgekimwjNmNstdhzrPkwKZqgPJPeSo0J71SXvKrgiUXiuiHLmruUHs8rcc/indAiX
 26CLj+txDLSji5YnWMA6yzm7AtzfIVGTatEphI+y5c26xa90hXLAlmYFL//1dTQQOyPw
 HMCbzOhB4xv2VomYIlo14xWYxcD4vbtMZhrxk2yL7qWC5KwsBpwln8lsNwynvPrxIQHB
 Xiss9bsk7TSpL1SH0P53UFrzTXqsorbicgZEDet4/UyMoolHEu3NjoWnHFqaYu3ykP1r
 VGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FltoTPFX6jcmVGDt6TNVLWqV+gbyvD26Qibq15L3bkE=;
 b=jI2Nr3gLK2U5cJ6jrjlbSz7jhC9oncqXOf+f4NZK5GOCogU7RZ3gdw8DZ0xtNjCWae
 5HT6y1q5Opnvr3Mhu7/kuKw4Y/4UnvyrYvD3NnzhxjxAVyT/2JcMrAR9PB/WDxLg3IIW
 OF5kle3NcNGmKc6OthATxnGqkx8RTj5moQnb5aC0nzx99MObla/fZYCRUX4ruAo5gwTO
 Ev4cYFo9uNxuwylP2ry0zeBcJQiu98hnFBfIhhHXthR2PI6X4N1gc8OgD63HHBc7p6wE
 ZWhz1BATl6X4mLqu+Kq2/odMtY/amwzAab9CQeGr/9d25RqmGsad0To9Cch8a7A5UWDw
 o4eQ==
X-Gm-Message-State: AOAM532qmpKpEtbA5OE0rf1ggd4/r5Og/AbppIXOIicIUFFF+PR7AOqt
 oEYGSCwX00mQ1JpKM2Ddnj/z5cm7nSwN
X-Google-Smtp-Source: ABdhPJzHTfoE95BxQfr07fXGEheE3lVwrZ1OysKwSSC2rt9N5CO+2igZJDqU/WMlnTkRLHPLM8olUAyj+sVU
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a1c:2309:: with SMTP id
 j9mr5432829wmj.189.1634645605661; Tue, 19 Oct 2021 05:13:25 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:57 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-9-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 08/15] KVM: arm64: pkvm: Refcount the pages shared with EL2
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In order to simplify the page tracking infrastructure at EL2 in nVHE
protected mode, move the responsibility of refcounting pages that are
shared multiple times on the host. In order to do so, let's create a
red-black tree tracking all the PFNs that have been shared, along with
a refcount.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 78 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0cc4b295e525..f0c16ed95974 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -284,30 +284,88 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
 	}
 }
 
-static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
+struct hyp_shared_pfn {
+	u64 pfn;
+	int count;
+	struct rb_node node;
+};
+
+static DEFINE_MUTEX(hyp_shared_pfns_lock);
+static struct rb_root hyp_shared_pfns = RB_ROOT;
+
+static struct hyp_shared_pfn *find_shared_pfn(u64 pfn, struct rb_node ***node,
+					      struct rb_node **parent)
 {
-	phys_addr_t addr;
-	int ret;
+	struct hyp_shared_pfn *this;
+
+	*node = &hyp_shared_pfns.rb_node;
+	*parent = NULL;
+	while (**node) {
+		this = container_of(**node, struct hyp_shared_pfn, node);
+		*parent = **node;
+		if (this->pfn < pfn)
+			*node = &((**node)->rb_left);
+		else if (this->pfn > pfn)
+			*node = &((**node)->rb_right);
+		else
+			return this;
+	}
 
-	for (addr = ALIGN_DOWN(start, PAGE_SIZE); addr < end; addr += PAGE_SIZE) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
-					__phys_to_pfn(addr));
-		if (ret)
-			return ret;
+	return NULL;
+}
+
+static int share_pfn_hyp(u64 pfn)
+{
+	struct rb_node **node, *parent;
+	struct hyp_shared_pfn *this;
+	int ret = 0;
+
+	mutex_lock(&hyp_shared_pfns_lock);
+	this = find_shared_pfn(pfn, &node, &parent);
+	if (this) {
+		this->count++;
+		goto unlock;
 	}
 
-	return 0;
+	this = kzalloc(sizeof(*this), GFP_KERNEL);
+	if (!this) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	this->pfn = pfn;
+	this->count = 1;
+	rb_link_node(&this->node, parent, node);
+	rb_insert_color(&this->node, &hyp_shared_pfns);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn, 1);
+unlock:
+	mutex_unlock(&hyp_shared_pfns_lock);
+
+	return ret;
 }
 
 int kvm_share_hyp(void *from, void *to)
 {
+	phys_addr_t start, end, cur;
+	u64 pfn;
+	int ret;
+
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
 	if (kvm_host_owns_hyp_mappings())
 		return create_hyp_mappings(from, to, PAGE_HYP);
 
-	return pkvm_share_hyp(kvm_kaddr_to_phys(from), kvm_kaddr_to_phys(to));
+	start = ALIGN_DOWN(kvm_kaddr_to_phys(from), PAGE_SIZE);
+	end = PAGE_ALIGN(kvm_kaddr_to_phys(to));
+	for (cur = start; cur < end; cur += PAGE_SIZE) {
+		pfn = __phys_to_pfn(cur);
+		ret = share_pfn_hyp(pfn);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
