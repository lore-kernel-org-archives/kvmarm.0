Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D6EC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 19:14:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF72E4BAF9;
	Thu, 10 Nov 2022 14:14:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QeUr9D7Ycn8I; Thu, 10 Nov 2022 14:14:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA264BAF8;
	Thu, 10 Nov 2022 14:14:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 932074BAF3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 14:14:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mSj65QqGa0P9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 14:14:04 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2476F4BAFE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 14:14:04 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A3EEAB8224F;
 Thu, 10 Nov 2022 19:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC41C433C1;
 Thu, 10 Nov 2022 19:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668107641;
 bh=T79CFtYcyb6c1mZV9P2/O70KOCeYCcKUaMZB5RbWzdg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=M71ylMGIDoqohUmZgQHkfUullJTju+MiiJxtGl2+/DK3+Qe5lxPAOrA0bVmDx8pME
 TObqBbsw343dZSNcM+pdNcOA2W8p7uCF8r/VeNwnIb8aG8eSRO1hHzUb9G+ASqce+m
 CsOmTLmoxv+Ca+xzaCi56t1cLcxbQ+RGppq5plgPxP4kJJP7l46E/O1C8oOXHrIc4A
 QFbnsFVJpTwQ6zWpp84hWIWB/6XtPto7eP5f+LIlpRImONfGI/zz9i+DlZNBJQWJn4
 +5SqLoaK/TFPwCCUDIdcoeam5e7EQDyTmFYy3IFrrsQZFo6WP+bms9uIc3S/UBbkY1
 pONGyRuYZrC/g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1otCzu-005Ekr-OL;
 Thu, 10 Nov 2022 19:13:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: andrew.jones@linux.dev, kvm@vger.kernel.org,
 Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
Date: Thu, 10 Nov 2022 19:13:53 +0000
Message-Id: <166810762188.3361918.17667021556485650781.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: andrew.jones@linux.dev, kvm@vger.kernel.org,
 ricarkol@google.com, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 bgardon@google.com, oupton@google.com, reijiw@google.com, pbonzini@redhat.com,
 eric.auger@redhat.com, rananta@google.com, axelrasmussen@google.com,
 alexandru.elisei@arm.com, dmatlack@google.com, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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

On Mon, 17 Oct 2022 19:58:20 +0000, Ricardo Koller wrote:
> This series adds a new aarch64 selftest for testing stage 2 fault handling
> for various combinations of guest accesses (e.g., write, S1PTW), backing
> sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
> hole, write on a readonly memslot). Each test tries a different combination
> and then checks that the access results in the right behavior (e.g., uffd
> faults with the right address and write/read flag). Some interesting
> combinations are:
> 
> [...]

Applied to next, thanks!

[01/14] KVM: selftests: Add a userfaultfd library
        commit: a93871d0ea9fd59fb5eb783619334183d7f07f51
[02/14] KVM: selftests: aarch64: Add virt_get_pte_hva() library function
        commit: 228f324dc718f702e8777164c4e2e7426824fb13
[03/14] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
        commit: b6b03b86c0250a80b671313dbc0d7bcdbab78f41
[04/14] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h macros
        commit: 41f5189ea9c08f7fc28340a7aefc93d0d2dcb769
[05/14] tools: Copy bitfield.h from the kernel sources
        commit: 590b949597b1e811d35df2f32021dd17d8e47f8c
[06/14] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
        commit: bd3ed7e1a47eb7b3838ca09439f1eb289ec3be1f
[07/14] KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
        commit: 290c5b54012b7f05e9c51af32d557574bf69a654
[08/14] KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and vm_vaddr_alloc()
        commit: 5485e822e31a75dfac3713d94b6b22025d4895da
[09/14] KVM: selftests: Use the right memslot for code, page-tables, and data allocations
        commit: 1446e331432d7f24ed56b870ad605a4345fee43f
[10/14] KVM: selftests: aarch64: Add aarch64/page_fault_test
        commit: 35c5810157124cb71aaa939cd2d5508192714877
[11/14] KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
        commit: 3b1d915659c64dce079f4926a648f2271faea008
[12/14] KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
        commit: a4edf25b3e25656c69cbc768d1c704868e4a616f
[13/14] KVM: selftests: aarch64: Add readonly memslot tests into page_fault_test
        commit: 45acde40f538a30e759f3b3f4aa5089edf097b2f
[14/14] KVM: selftests: aarch64: Add mix of tests into page_fault_test
        commit: ff2b5509e1d252cd18bb1430b5461d5044701559

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
