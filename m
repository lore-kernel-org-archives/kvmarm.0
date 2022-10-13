Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5876C4321E
	for <kvmarm@archiver.kernel.org>; Thu, 13 Oct 2022 11:35:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F90E40FAC;
	Thu, 13 Oct 2022 07:35:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ywkhL7gBXiBW; Thu, 13 Oct 2022 07:35:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DCA749EED;
	Thu, 13 Oct 2022 07:35:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84FAF49EED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 07:35:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hqrkr1tF3Sgk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Oct 2022 07:35:40 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5203340FAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 07:35:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D9950B81E20;
 Thu, 13 Oct 2022 11:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748D4C433C1;
 Thu, 13 Oct 2022 11:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1665660937;
 bh=TycQmVJ6jXUOyk9ucIX1dRffGw6LVYgXTvtb6cNlgZQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gRinFqH1c2Qd0p3WjDwRlXc2NX091fbWECJol5jdbNJoBs0WmVFStREnwn+3c39eJ
 5osZwwPej6SepvpGUt7GUMq7/SGLOa3SRNATok21IfM3Bt7fO4oCC38R3t0/6oYlYo
 DPXH8J9JGSwl2hndm2hQTpyEeHFHnJWoVIoVx3pRbAPy8CoXFn1qpTfdQrVMyjGn5l
 6ryyCoGQh+xnSJBlpzmWi5LQN+kD5vm41qBqpACJCeJdxkKFe8jOfT6fwOgC6EHEFx
 cxTaplsoq906pTwl5EZOpOFJL+tns4VFtxRXg98/1YSn4E9paguhUMhn/KZQEAEFHa
 qwSQVkLgqHg8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oiwUx-00GI0Y-7d;
 Thu, 13 Oct 2022 12:35:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Fix number of pages for memory slot in
 memslot_modification_stress_test
Date: Thu, 13 Oct 2022 12:35:31 +0100
Message-Id: <166566092380.1304242.1787049894105591539.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221013063020.201856-1-gshan@redhat.com>
References: <20221013063020.201856-1-gshan@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, gshan@redhat.com,
 oliver.upton@linux.dev, linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
 kvm@vger.kernel.org, seanjc@google.com, kvmarm@lists.cs.columbia.edu,
 dmatlack@google.com, pbonzini@redhat.com, venkateshs@chromium.org,
 peterx@redhat.com, shan.gavin@gmail.com, shuah@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: venkateshs@chromium.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, dmatlack@google.com, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Thu, 13 Oct 2022 14:30:20 +0800, Gavin Shan wrote:
> It's required by vm_userspace_mem_region_add() that memory size
> should be aligned to host page size. However, one guest page is
> provided by memslot_modification_stress_test. It triggers failure
> in the scenario of 64KB-page-size-host and 4KB-page-size-guest,
> as the following messages indicate.
> 
>  # ./memslot_modification_stress_test
>  Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
>  guest physical test memory: [0xffbfff0000, 0xffffff0000)
>  Finished creating vCPUs
>  Started all vCPUs
>  ==== Test Assertion Failure ====
>    lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
>    pid=5712 tid=5712 errno=0 - Success
>       1	0x0000000000404eeb: vm_userspace_mem_region_add at kvm_util.c:822
>       2	0x0000000000401a5b: add_remove_memslot at memslot_modification_stress_test.c:82
>       3	 (inlined by) run_test at memslot_modification_stress_test.c:110
>       4	0x0000000000402417: for_each_guest_mode at guest_modes.c:100
>       5	0x00000000004016a7: main at memslot_modification_stress_test.c:187
>       6	0x0000ffffb8cd4383: ?? ??:0
>       7	0x0000000000401827: _start at :?
>    Number of guest pages is not compatible with the host. Try npages=16
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test
      commit: 05c2224d4b049406b0545a10be05280ff4b8ba0a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
