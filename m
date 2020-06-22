Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F7CC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA994207F5
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA994207F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 940174B113;
	Mon, 22 Jun 2020 16:09:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aYyL736KjgfF; Mon, 22 Jun 2020 16:09:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C72C74B0F6;
	Mon, 22 Jun 2020 16:09:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3163C4B07F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x+7xdpe6O3lh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 16:09:13 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E36274B0D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:11 -0400 (EDT)
IronPort-SDR: EfDc7BV4nt4Zk9vhKUmgzjLOxItX4KZRdDozfDd3cWFsXhN+AU67OPt/IhIauSx0n2qoNQejcj
 8SqQHRkxmWYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142921276"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="142921276"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Jun 2020 13:09:11 -0700
IronPort-SDR: IRgUCTEaPJr/2/orSxWBxKSmIS60menKPUWxbbZ7C2802ZcPzS1mSvGZqhNP3PjvlDU4QyUDeZ
 zZbdgzTcmLcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="318877068"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 13:09:10 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 06/21] KVM: x86/mmu: Move fast_page_fault() call above
 mmu_topup_memory_caches()
Date: Mon, 22 Jun 2020 13:08:07 -0700
Message-Id: <20200622200822.4426-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622200822.4426-1-sean.j.christopherson@intel.com>
References: <20200622200822.4426-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, Junaid Shahid <junaids@google.com>,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Avoid refilling the memory caches and potentially slow reclaim/swap when
handling a fast page fault, which does not need to allocate any new
objects.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5e773564ab20..4b4c3234d623 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4095,6 +4095,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
+	if (fast_page_fault(vcpu, gpa, error_code))
+		return RET_PF_RETRY;
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -4102,9 +4105,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (lpage_disallowed)
 		max_level = PG_LEVEL_4K;
 
-	if (fast_page_fault(vcpu, gpa, error_code))
-		return RET_PF_RETRY;
-
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
