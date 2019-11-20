Return-Path: <SRS0=7egO=ZM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AA0C43215
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 16:43:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F299D2088F
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 16:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F299D2088F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5C94AEBE;
	Wed, 20 Nov 2019 11:43:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hAG9BJrXm6JG; Wed, 20 Nov 2019 11:43:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A92B4AEBB;
	Wed, 20 Nov 2019 11:43:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75EF14A7FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 11:43:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g14b0p4dl0y7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Nov 2019 11:43:08 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F50E4AE89
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 11:43:08 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iXT4E-0007RI-Vl; Wed, 20 Nov 2019 17:42:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 06/22] KVM: Implement kvm_put_guest()
Date: Wed, 20 Nov 2019 16:42:20 +0000
Message-Id: <20191120164236.29359-7-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
References: <20191120164236.29359-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com,
 drjones@redhat.com, borntraeger@de.ibm.com, christoffer.dall@arm.com,
 eric.auger@redhat.com, xypron.glpk@gmx.de, julien.grall@arm.com,
 mark.rutland@arm.com, bigeasy@linutronix.de, steven.price@arm.com,
 tglx@linutronix.de, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Steven Price <steven.price@arm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

From: Steven Price <steven.price@arm.com>

kvm_put_guest() is analogous to put_user() - it writes a single value to
the guest physical address. The implementation is built upon put_user()
and so it has the same single copy atomic properties.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..9907e45f8875 100644
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
