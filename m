Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A5EC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 428714B1F2;
	Sat, 23 Apr 2022 04:57:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SnUZzfQGZZKk; Sat, 23 Apr 2022 04:57:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 161294B289;
	Sat, 23 Apr 2022 04:57:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 441FE40C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ouJrAdCrToxG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:06:07 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 008124A104
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:07 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 j10-20020a170903024a00b0015a1050d608so5394174plh.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kWwdM6A6P8/IuSsS3ESiLqrrdzrHfrWJ/AAbUmXSl2Q=;
 b=R5R30ofn1vT0B52vHAVy90sP8NWeAZk6uMpASj40sPxLLgzd2ZuOhesc6L/vaSciGX
 87A3/3Qkbiw1Jk6/rP7+fnq2RGGkxxQAxUHvI0b1BWtmszbA0LwIv3qS7ZaWzCx0KLaL
 VK5tmwOU/bgQEzGPKc94RnF/A3q/3k7LFK3VARKssk6TAFHeYXKTzl0zRj3Q3p3xHuKj
 ASu3Vi4NipZHZTd78zSj5VH0uaJlnVnRVoaWpMPez2YoRLrby2DeUwBQ56WSIMTywDqq
 QSQk+xMkFSDdB3EgCE3L0r1ViEw6ieR9wK4UKK8wJZZxeRSsEhnpihM85gN+RwfYexCl
 p7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kWwdM6A6P8/IuSsS3ESiLqrrdzrHfrWJ/AAbUmXSl2Q=;
 b=Zh2vlPt3v/nFxi54m3HwniehWagHBi6vMa3t2d46UECX3eyTtMYaZXtOLQjU3vvvrb
 avvWQsf5fBNZZkMBDsq1zGyz/7lxtwgfIanOATPup7Zx51T3LJq/5+GOtoX9HfzPRyOA
 bIsJHOr+090Gm2OEe533WaDSkRx5ph1Cg9IQanOckRyiv4LGkTJK0/oPtKsD0jv5Jayn
 5AM/bMrSJqqU94Y1FbRog/f8F1o1FwlWRaRJDHYV0lGi9HxSIwhBGjjbsF1JQ/5x4y/R
 PorknnV3a57KN9FeB3TpsCg1iUJEK5Cagr3DHjTkL1RR5mlhboYNj6iReZ0aMxlPW/+H
 qZAQ==
X-Gm-Message-State: AOAM531q/v/CTwLz2WfdjZ7slgg/qqV/APctLQHsZiALE3rxNPTQuLhD
 NAH7IgRTnnX5JXVyuyq7eftf4nanew+5Qg==
X-Google-Smtp-Source: ABdhPJyrKsBSTehaAqfzYOFua5pU71lBgPsCafuSicdpbjxOGLjE18EgDYm93QHLrLLvseNhpIztJ+Y4kBHGiw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:10d0:b0:4f7:5af4:47b6 with SMTP
 id d16-20020a056a0010d000b004f75af447b6mr6733898pfu.6.1650661566123; Fri, 22
 Apr 2022 14:06:06 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:37 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in
 __kvm_mmu_get_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 23 Apr 2022 04:57:06 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
it to vcpu_or_null to prevent future commits from accidentally taking
dependency on it without first considering the NULL case.

The vcpu pointer is only used for syncing indirect shadow pages in
kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
correctness since unsync pages can simply be zapped. But this should
never occur in practice, since the only use-case for passing a NULL vCPU
pointer is eager page splitting which will only request direct shadow
pages (which can never be unsync).

Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
called to get an indirect shadow page with a NULL vCPU pointer, since
zapping unsync SPs is a performance overhead that should be considered.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 04029c01aebd..21407bd4435a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
-static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			 struct list_head *invalid_list)
+static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
+			   struct kvm_mmu_page *sp,
+			   struct list_head *invalid_list)
 {
-	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
+	int ret = -1;
+
+	if (vcpu_or_null)
+		ret = vcpu_or_null->arch.mmu->sync_page(vcpu_or_null, sp);
 
 	if (ret < 0)
-		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+
 	return ret;
 }
 
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			 struct list_head *invalid_list)
+{
+	return __kvm_sync_page(vcpu->kvm, vcpu, sp, invalid_list);
+}
+
 static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 					struct list_head *invalid_list,
 					bool remote_flush)
@@ -2004,7 +2015,7 @@ static void clear_sp_write_flooding_count(u64 *spte)
 }
 
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
-						     struct kvm_vcpu *vcpu,
+						     struct kvm_vcpu *vcpu_or_null,
 						     gfn_t gfn,
 						     struct hlist_head *sp_list,
 						     union kvm_mmu_page_role role)
@@ -2053,7 +2064,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			 * If the sync fails, the page is zapped.  If so, break
 			 * in order to rebuild it.
 			 */
-			ret = kvm_sync_page(vcpu, sp, &invalid_list);
+			ret = __kvm_sync_page(kvm, vcpu_or_null, sp, &invalid_list);
 			if (ret < 0)
 				break;
 
@@ -2120,7 +2131,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 }
 
 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
-						      struct kvm_vcpu *vcpu,
+						      struct kvm_vcpu *vcpu_or_null,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      union kvm_mmu_page_role role)
@@ -2129,9 +2140,22 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
+	/*
+	 * A vCPU pointer should always be provided when getting indirect
+	 * shadow pages, as that shadow page may already exist and need to be
+	 * synced using the vCPU pointer (see __kvm_sync_page()). Direct shadow
+	 * pages are never unsync and thus do not require a vCPU pointer.
+	 *
+	 * No need to panic here as __kvm_sync_page() falls back to zapping an
+	 * unsync page if the vCPU pointer is NULL. But still WARN() since
+	 * such zapping will impact performance and this situation is never
+	 * expected to occur in practice.
+	 */
+	WARN_ON(!vcpu_or_null && !role.direct);
+
 	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 
-	sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
+	sp = kvm_mmu_find_shadow_page(kvm, vcpu_or_null, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
 		sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
