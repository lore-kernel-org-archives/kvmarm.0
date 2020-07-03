Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B8AC433EC
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 02:36:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7D5F20B1F
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 02:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7D5F20B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E1284B272;
	Thu,  2 Jul 2020 22:36:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uLoPvJEFAac5; Thu,  2 Jul 2020 22:36:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847704B270;
	Thu,  2 Jul 2020 22:36:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A1434B26D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 22:36:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S5oVYOqwoqzA for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 22:36:08 -0400 (EDT)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACD4F4B256
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 22:36:07 -0400 (EDT)
IronPort-SDR: VE5nt3EzloPUTOV2L72mFEQz68W2ygvVuAD+AlDJl1y+yfF+MkSy6gbEreDpwIO54mqQ0XNv7t
 N2k0RzqT/3aw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="231938486"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; d="scan'208";a="231938486"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Jul 2020 19:36:05 -0700
IronPort-SDR: AESbTuN/UT4ZkbG1N/XVt8y93FcKopX5vpg+RKbIC32XUvak9vEiWLEUl5G8Qd5f6UDgFmZHmi
 FFTUYnoXWDwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; d="scan'208";a="278295735"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga003.jf.intel.com with ESMTP; 02 Jul 2020 19:36:05 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 06/21] KVM: x86/mmu: Move fast_page_fault() call above
 mmu_topup_memory_caches()
Date: Thu,  2 Jul 2020 19:35:30 -0700
Message-Id: <20200703023545.8771-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200703023545.8771-1-sean.j.christopherson@intel.com>
References: <20200703023545.8771-1-sean.j.christopherson@intel.com>
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
index 748235877def..3d0768e16463 100644
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
