Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521E9C35248
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 00:10:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 148682070E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 00:10:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 148682070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B39524A95C;
	Wed, 29 Jan 2020 19:10:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rq9mXrhGeWgs; Wed, 29 Jan 2020 19:10:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 507664AE94;
	Wed, 29 Jan 2020 19:10:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 696184AC77
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 19:10:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6i15ePkS911e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jan 2020 19:10:34 -0500 (EST)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E5AC4A8E0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 19:10:31 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 29 Jan 2020 16:10:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; d="scan'208";a="261990367"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga002.fm.intel.com with ESMTP; 29 Jan 2020 16:10:30 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5/5] KVM: x86: Set kvm_x86_ops only after ->hardware_setup()
 completes
Date: Wed, 29 Jan 2020 16:10:23 -0800
Message-Id: <20200130001023.24339-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200130001023.24339-1-sean.j.christopherson@intel.com>
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Set kvm_x86_ops with the vendor's ops only after ->hardware_setup()
completes to "prevent" using kvm_x86_ops before they are ready, i.e. to
generate a null pointer fault instead of silently consuming unconfigured
state.

An alternative implementation would be to have ->hardware_setup()
return the vendor's ops, but that would require non-trivial refactoring,
and would arguably result in less readable code, e.g. ->hardware_setup()
would need to use ERR_PTR() in multiple locations, and each vendor's
declaration of the runtime ops would be less obvious.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb36762aa2ce..a9f733c4ca28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7326,8 +7326,6 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
-	kvm_x86_ops = ops->runtime_ops;
-
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0,
 			PT_PRESENT_MASK, 0, sme_me_mask);
@@ -9588,6 +9586,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (r != 0)
 		return r;
 
+	kvm_x86_ops = ops->runtime_ops;
+
 	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
 
 	if (kvm_has_tsc_control) {
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
