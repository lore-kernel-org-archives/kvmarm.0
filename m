Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CFBC4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 11:25:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD6BC2465A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 11:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="bORmW4bE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD6BC2465A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 550D44B20E;
	Mon, 26 Oct 2020 07:25:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ziomf1wF6Hh5; Mon, 26 Oct 2020 07:25:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF2E4B233;
	Mon, 26 Oct 2020 07:25:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C88CC4B217
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 07:25:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1OEbqYii3feq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 07:25:24 -0400 (EDT)
Received: from hqnvemgate26.nvidia.com (hqnvemgate26.nvidia.com
 [216.228.121.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BFB54B20E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 07:25:24 -0400 (EDT)
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by
 hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
 id <B5f96b20e0001>; Mon, 26 Oct 2020 04:25:02 -0700
Received: from HQMAIL107.nvidia.com ([172.20.161.6])
 by hqpgpgate101.nvidia.com (PGP Universal service);
 Mon, 26 Oct 2020 04:25:23 -0700
X-PGP-Universal: processed;
 by hqpgpgate101.nvidia.com on Mon, 26 Oct 2020 04:25:23 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 11:25:23 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 11:25:19 +0000
Received: from santosh-System-Product-Name.nvidia.com (172.20.13.39) by
 mail.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 26 Oct 2020 11:25:15 +0000
From: Santosh Shukla <sashukla@nvidia.com>
To: <maz@kernel.org>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] KVM: arm64: Correctly handle the mmio faulting
Date: Mon, 26 Oct 2020 16:54:07 +0530
Message-ID: <1603711447-11998-2-git-send-email-sashukla@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
References: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1603711502; bh=yL8eU53Ye6VwNxBHiLcoNd9MJdU5fRUmThif3Tv1W5E=;
 h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
 In-Reply-To:References:X-NVConfidentiality:MIME-Version:
 Content-Type;
 b=bORmW4bEHVQTM5SvJ4ehlJSGx/2+rmNkI6kyeR9n+S9qyV8i83rG5SzuBBCSf6U78
 xV5nSUVCGwrD59zGjtJAN8ciibiBqSc9nYEBLqgJLL/1F4Fyl/lifrjL01HvJeEGHo
 uqVmfk2rjWZnyrvlcLukJS8QqqO3WCf6OR5F9COTBcO8XdHG/tg73WvvaFvH8aKmKe
 kfqnMhM7rjqhIpUWKuKWh9BoBLDKrQuaYL85X2c4JvfBIEkFBP+O7xTHNLuMm44r7k
 3dtFMoo2mQmYSIwEiuSRJupob4FeRhMLVxu+0BDqiEBrrzESlO+LTVfU0ntKOFRYFO
 AVfKosh/82Lyg==
Cc: mcrossley@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

The proposition is to set force_pte=true if kvm_is_device_pfn is true.

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
Linux-5.10-rc1 tip: 3650b228

Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device mappings")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
---
v2:
- Per Marc's suggestion - setting force_pte=true.
- Rebased and tested for 5.10-rc1 commit: 3650b228

v1: https://lkml.org/lkml/2020/10/21/460

arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 19aacc7..d4cd253 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -839,6 +839,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (kvm_is_device_pfn(pfn)) {
 		device = true;
+		force_pte = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
