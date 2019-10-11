Return-Path: <SRS0=GvsF=YE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08CAC47404
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 12:59:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7DD85206A1
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 12:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DD85206A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 383434A8D9;
	Fri, 11 Oct 2019 08:59:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6J07D+Z2I1mb; Fri, 11 Oct 2019 08:59:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34B924A8E3;
	Fri, 11 Oct 2019 08:59:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 707344A891
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 08:59:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QIKrglHFLjy4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Oct 2019 08:59:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C0D4A8D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 08:59:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CF3028;
 Fri, 11 Oct 2019 05:59:47 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com
 [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B7913F6C4;
 Fri, 11 Oct 2019 05:59:45 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 04/10] KVM: Implement kvm_put_guest()
Date: Fri, 11 Oct 2019 13:59:24 +0100
Message-Id: <20191011125930.40834-5-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191011125930.40834-1-steven.price@arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
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

kvm_put_guest() is analogous to put_user() - it writes a single value to
the guest physical address. The implementation is built upon put_user()
and so it has the same single copy atomic properties.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 include/linux/kvm_host.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fcb46b3374c6..bf0ae1825b9c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -746,6 +746,28 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 				  unsigned long len);
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len);
+
+#define __kvm_put_guest(kvm, gfn, offset, value, type)			\
+({									\
+	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
+	type __user *__uaddr = (type __user *)(__addr + offset);	\
+	int __ret = -EFAULT;						\
+									\
+	if (!kvm_is_error_hva(__addr))					\
+		__ret = put_user(value, __uaddr);			\
+	if (!__ret)							\
+		mark_page_dirty(kvm, gfn);				\
+	__ret;								\
+})
+
+#define kvm_put_guest(kvm, gpa, value, type)				\
+({									\
+	gpa_t __gpa = gpa;						\
+	struct kvm *__kvm = kvm;					\
+	__kvm_put_guest(__kvm, __gpa >> PAGE_SHIFT,			\
+			offset_in_page(__gpa), (value), type);		\
+})
+
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
