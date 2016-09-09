From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 1/2] arm: KVM: Fix idmap overlap detection when the kernel is
 idmap'ed
Date: Fri,  9 Sep 2016 12:54:55 +0200
Message-ID: <20160909105456.8585-2-christoffer.dall@linaro.org>
References: <20160909105456.8585-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B6FD40F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 06:44:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id osvrFLaxfOVX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2016 06:44:08 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 826EC410B5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 06:44:08 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id 1so25695936wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2016 03:52:40 -0700 (PDT)
In-Reply-To: <20160909105456.8585-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We're trying hard to detect when the HYP idmap overlaps with the
HYP va, as it makes the teardown of a cpu dangerous. But there is
one case where an overlap is completely safe, which is when the
whole of the kernel is idmap'ed, which is likely to happen on 32bit
when RAM is at 0x8000000 and we're using a 2G/2G VA split.

In that case, we can proceed safely.

Reported-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 29d0b23..a3faafe 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1714,7 +1714,8 @@ int kvm_mmu_init(void)
 		 kern_hyp_va(PAGE_OFFSET), kern_hyp_va(~0UL));
 
 	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
-	    hyp_idmap_start <  kern_hyp_va(~0UL)) {
+	    hyp_idmap_start <  kern_hyp_va(~0UL) &&
+	    hyp_idmap_start != (unsigned long)__hyp_idmap_text_start) {
 		/*
 		 * The idmap page is intersecting with the VA space,
 		 * it is not safe to continue further.
-- 
2.9.0
