Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99F1C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 15:48:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E82C4B27E;
	Sat, 30 Apr 2022 11:48:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bvBW-JIpXNR6; Sat, 30 Apr 2022 11:48:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90E1D4B2A1;
	Sat, 30 Apr 2022 11:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C4A14B1C5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 01:01:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1olim0GHkCN0 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 30 Apr 2022 01:01:38 -0400 (EDT)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F1A04B1BF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 01:01:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=UN4x7iH4NKXkteoWIh3EUxDFhL5V4nUDAqGTxkHP6DM=; b=KR8l/WAr9lBc5OBVsczVxMqTZl
 gvcPHgjQ70H81QG8/xWxtjwDT0OaksyA7HF1GxQSxddUnU1ExA/LAcuB1vjdlaN9WRWwbZy0irhom
 b+F/edUU5pBSHWcE7s3O2b0ENOUIvvsmxPvw8UddvBsxFBT2RrVLWGzQAWEmngUE/YdqbzrT33WBc
 3mX7IO8twjOIrUAfQrmjfJaOCSKLxyeUyfwFEiMBqTBmnMjQiG8Enh8hTdC/jTkoA3pRBkINSF+kz
 P8SnjKUlpMVqpZl97eq3gZI6JKWfKbfj/Oc5q3IJh4SXcg1WzCQN9NV0jJ87Evc45068WMf+jGyk9
 /Ppu/P5w==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nkfES-00DdP7-Cx; Sat, 30 Apr 2022 05:01:24 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: nvhe: eliminate kernel-doc warnings
Date: Fri, 29 Apr 2022 22:01:23 -0700
Message-Id: <20220430050123.2844-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Mailman-Approved-At: Sat, 30 Apr 2022 11:48:22 -0400
Cc: kernel test robot <lkp@intel.com>, Marc Zyngier <maz@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org,
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

Don't use begin-kernel-doc notation (/**) for comments that are not in
kernel-doc format.

This prevents these kernel-doc warnings:

arch/arm64/kvm/hyp/nvhe/switch.c:126: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Disable host events, enable guest events
arch/arm64/kvm/hyp/nvhe/switch.c:146: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Disable guest events, enable host events
arch/arm64/kvm/hyp/nvhe/switch.c:164: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Handler for protected VM restricted exceptions.
arch/arm64/kvm/hyp/nvhe/switch.c:176: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
arch/arm64/kvm/hyp/nvhe/switch.c:196: warning: Function parameter or member 'vcpu' not described in 'kvm_handle_pvm_fpsimd'
arch/arm64/kvm/hyp/nvhe/switch.c:196: warning: Function parameter or member 'exit_code' not described in 'kvm_handle_pvm_fpsimd'
arch/arm64/kvm/hyp/nvhe/switch.c:196: warning: expecting prototype for Handler for protected floating(). Prototype was for kvm_handle_pvm_fpsimd() instead

Fixes: 09cf57eba304 ("KVM: arm64: Split hyp/switch.c to VHE/nVHE")
Fixes: 1423afcb4117 ("KVM: arm64: Trap access to pVM restricted features")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: David Brazdil <dbrazdil@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/hyp/nvhe/switch.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -150,7 +150,7 @@ static void __hyp_vgic_restore_state(str
 	}
 }
 
-/**
+/*
  * Disable host events, enable guest events
  */
 static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
@@ -170,7 +170,7 @@ static bool __pmu_switch_to_guest(struct
 	return (pmu->events_host || pmu->events_guest);
 }
 
-/**
+/*
  * Disable guest events, enable host events
  */
 static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
@@ -188,7 +188,7 @@ static void __pmu_switch_to_host(struct
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
-/**
+/*
  * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
  *
  * Returns true if the hypervisor has handled the exit, and control should go
@@ -205,7 +205,7 @@ static bool kvm_handle_pvm_sys64(struct
 		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
-/**
+/*
  * Handler for protected floating-point and Advanced SIMD accesses.
  *
  * Returns true if the hypervisor has handled the exit, and control should go
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
