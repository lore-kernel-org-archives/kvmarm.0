Return-Path: <SRS0=Gv/P=VF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D73DC606AC
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 11:47:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98C102086D
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 11:47:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98C102086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C27F4A53A;
	Mon,  8 Jul 2019 07:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NVByq2d2eQBD; Mon,  8 Jul 2019 07:47:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8B9E4A50D;
	Mon,  8 Jul 2019 07:47:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3BCE4A50D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 07:47:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PVZB8Eqcelic for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jul 2019 07:47:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D96ED4A502
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 07:47:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EDAA360;
 Mon,  8 Jul 2019 04:47:23 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7F983F738;
 Mon,  8 Jul 2019 04:47:22 -0700 (PDT)
Date: Mon, 8 Jul 2019 12:47:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jon Masters <jcm@jonmasters.org>
Subject: Re: FYI: Possible HPFAR_EL2 corruption (LPAE guests on AArch64 hosts)
Message-ID: <20190708114716.GA33099@lakrids.cambridge.arm.com>
References: <7dd77cea-d673-269a-044f-4df269db7e5e@jonmasters.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7dd77cea-d673-269a-044f-4df269db7e5e@jonmasters.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>
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

On Sun, Jul 07, 2019 at 11:39:46PM -0400, Jon Masters wrote:
> Hi all,

Hi Jon,

[adding Marc and the kvm-arm list]

> TLDR: We think $subject may be a hardware errata and we are
> investigating. I was asked to drop a note to share my initial analysis
> in case others have been experiencing similar problems with 32-bit VMs.
> 
> The Fedora Arm 32-bit builders run as "armv7hl+lpae" (aarch32) LPAE
> (VMSAv8-32 Long-descriptor table format in aarch32 execution state) VMs
> on AArch64 hosts. Under certain conditions, those builders will "pause"
> with the following obscure looking error message:
> 
> kvm [10652]: load/store instruction decoding not implemented
> 
> (which is caused by a fall-through in io_mem_abort, the code assumes
> that if we couldn't find the guest memslot we're taking an IO abort)
> 
> This has been happening on and off for more than a year, tickled further
> by various 32-bit Fedora guest updates, leading to some speculation that
> there was actually a problem with guest toolchains generating
> hard-to-emulate complex load/store instruction sequences not handled in KVM.
> 
> After extensive analysis, I believe instead that it appears on the
> platform we are using in Fedora that a stage 2 fault (e.g. v8.0 software
> access bit update in the host) taken during stage 1 guest page table
> walk will result in an HPFAR_EL2 truncation to a 32-bit address instead
> of the full 48-bit IPA in use due to aarch32 LPAE. I believe that this
> is a hardware errata and have requested that the vendor investigate.
> 
> Meanwhile, I have a /very/ nasty patch that checks the fault conditions
> in kvm_handle_guest_abort and if they match (S1 PTW, etc.), does a
> software walk through the guest page tables looking for a PTE that
> matches with the lower part of the faulting address bits we did get
> reported to the host, then re-injects the correct fault. With this
> patch, the test builder stays up, albeit correcting various faults:
> 
> [  143.670063] JCM: WARNING: Mismatched FIPA and PA translation detected!
> [  143.748447] JCM: Hyper faulting far: 0x3deb0000
> [  143.802808] JCM: Guest faulting far: 0xb6dce3c4 (gfn: 0x3deb)
> [  143.871776] JCM: Guest TTBCR: 0xb5023500, TTBR0: 0x5b06cc40
> [  143.938649] JCM: Guest PGD address: 0x5b06cc50
> [  143.991962] JCM: Guest PGD: 0x5b150003
> [  144.036925] JCM: Guest PMD address: 0x5b150db0
> [  144.090238] JCM: Guest PMD: 0x43deb0003
> [  144.136241] JCM: Guest PTE address: 0x43deb0e70
> [  144.190604] JCM: Guest PTE: 0x42000043bb72fdf
> [  144.242884] JCM: Manually translated as: 0xb6dce3c4->0x43bb72000
> [  144.314972] JCM: Faulting IPA page: 0x3deb0000
> [  144.368286] JCM: Faulting PTE page: 0x43deb0000
> [  144.422641] JCM: Fault occurred while performing S1 PTW -fixing
> [  144.493684] JCM: corrected fault_ipa: 0x43deb0000
> [  144.550133] JCM: Corrected gfn: 0x43deb
> [  144.596145] JCM: handle user_mem_abort
> [  144.641155] JCM: ret: 0x1

When the conditions are met, does the issue continue to trigger
reliably?

e.g. if you return to the guest without fixing the fault, do you always
see the truncation when taking the fault again?

If you try the translation with an AT, does that work as expected? We've
had to use that elsewhere; see __populate_fault_info() in
arch/arm64/kvm/hyp/switch.c.

Thanks,
Mark.

> 
> Eventually, we might be looking to upstream something once we can figure
> out a nice way to generically walk guest page tables and fixup (there's
> no alternatives framework in virt/kvm/arm/mmu.c yet, etc.). I'll ask
> that the vendor take a look at this if we confirm a problem exists.
> 
> We'll followup. I wanted to let folks know we are working it since some
> of you had feared there was something worse with load/store instruction
> generation in recent 32-bit guests. That appears to not be the case.
> 
> Jon.
> 
> P.S. A full writeup of what we are seeing and linked bugzilla with debug
> only quick hack patch is here:
> https://medium.com/@jonmasters_84473/debugging-a-32-bit-fedora-arm-builder-issue-73295d7d673d
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
