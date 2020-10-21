Return-Path: <SRS0=S3n0=D4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D170DC4363A
	for <kvmarm@archiver.kernel.org>; Wed, 21 Oct 2020 19:05:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6B5C221F9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Oct 2020 19:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="lDdPKWe+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6B5C221F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E126A4B56D;
	Wed, 21 Oct 2020 15:05:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JQpiUxewaFus; Wed, 21 Oct 2020 15:05:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D155E4B570;
	Wed, 21 Oct 2020 15:05:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3D544B570
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Oct 2020 12:17:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eF7U3BrEwmdE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Oct 2020 12:17:21 -0400 (EDT)
Received: from hqnvemgate24.nvidia.com (hqnvemgate24.nvidia.com
 [216.228.121.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEEDA4B56F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Oct 2020 12:17:21 -0400 (EDT)
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by
 hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
 id <B5f905eb20001>; Wed, 21 Oct 2020 09:15:46 -0700
Received: from HQMAIL105.nvidia.com ([172.20.161.6])
 by hqpgpgate102.nvidia.com (PGP Universal service);
 Wed, 21 Oct 2020 09:17:20 -0700
X-PGP-Universal: processed;
 by hqpgpgate102.nvidia.com on Wed, 21 Oct 2020 09:17:20 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 21 Oct
 2020 16:17:17 +0000
Received: from santosh-System-Product-Name.nvidia.com (10.124.1.5) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 21 Oct 2020 16:17:13 +0000
From: Santosh Shukla <sashukla@nvidia.com>
To: <maz@kernel.org>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: arm64: Correctly handle the mmio faulting
Date: Wed, 21 Oct 2020 21:46:50 +0530
Message-ID: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1603296946; bh=/pCPC1opPh5gWz/GYqPevuPPTN8cDasp68thhdStyhk=;
 h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
 MIME-Version:Content-Type;
 b=lDdPKWe+hmHsfh8FmF4KGvcqB0iZH79MKwoN1FVWzuE4uFy5A09ApT/Di0B6sC/Qt
 JJaK1NltiOuxPPymlJ2U7cSQK+4vXjdgKfJPwkbhyynhKdjnKm/k+9XuP/J2oPMdjs
 C8VXY1SNh4wIjdc4LgAPY1Ud+bvuY83kt49NDfsND6jgsFwxjHBdppBMQDaXUluSDA
 bbtpavSfuYshfD2QhrmNdBYwGI58FwQcVOARAQqoFno+S713Z+FytsaYGLclPk7DOW
 UG7pYl747POpNWfEcrOHnVIjV8vXDcMHxX2BhJ1nACogi54cD0NvQNc2R0+1fDJG4G
 HPigAkFj5MWaQ==
X-Mailman-Approved-At: Wed, 21 Oct 2020 15:05:20 -0400
Cc: cjia@nvidia.com, Santosh Shukla <sashukla@nvidia.com>,
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

The Commit:6d674e28 introduces a notion to detect and handle the
device mapping. The commit checks for the VM_PFNMAP flag is set
in vma->flags and if set then marks force_pte to true such that
if force_pte is true then ignore the THP function check
(/transparent_hugepage_adjust()).

There could be an issue with the VM_PFNMAP flag setting and checking.
For example consider a case where the mdev vendor driver register's
the vma_fault handler named vma_mmio_fault(), which maps the
host MMIO region in-turn calls remap_pfn_range() and maps
the MMIO's vma space. Where, remap_pfn_range implicitly sets
the VM_PFNMAP flag into vma->flags.

Now lets assume a mmio fault handing flow where guest first access
the MMIO region whose 2nd stage translation is not present.
So that results to arm64-kvm hypervisor executing guest abort handler,
like below:

kvm_handle_guest_abort() -->
 user_mem_abort()--> {

    ...
    0. checks the vma->flags for the VM_PFNMAP.
    1. Since VM_PFNMAP flag is not yet set so force_pte _is_ false;
    2. gfn_to_pfn_prot() -->
        __gfn_to_pfn_memslot() -->
            fixup_user_fault() -->
                handle_mm_fault()-->
                    __do_fault() -->
                       vma_mmio_fault() --> // vendor's mdev fault handler
                        remap_pfn_range()--> // Here sets the VM_PFNMAP
						flag into vma->flags.
    3. Now that force_pte is set to false in step-2),
       will execute transparent_hugepage_adjust() func and
       that lead to Oops [4].
 }

The proposition is to check is_iomap flag before executing the THP
function transparent_hugepage_adjust().

[4] THP Oops:
> pc: kvm_is_transparent_hugepage+0x18/0xb0
> ...
> ...
> user_mem_abort+0x340/0x9b8
> kvm_handle_guest_abort+0x248/0x468
> handle_exit+0x150/0x1b0
> kvm_arch_vcpu_ioctl_run+0x4d4/0x778
> kvm_vcpu_ioctl+0x3c0/0x858
> ksys_ioctl+0x84/0xb8
> __arm64_sys_ioctl+0x28/0x38

Tested on Huawei Kunpeng Taishan-200 arm64 server, Using VFIO-mdev device.
Linux tip: 583090b1

Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3d26b47..ff15357 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1947,7 +1947,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !force_pte)
+	if (vma_pagesize == PAGE_SIZE && !force_pte && !is_iomap(flags))
 		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
 							   &pfn, &fault_ipa);
 	if (writable)
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
