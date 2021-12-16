Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D17C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 12:31:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A9CF4B08D;
	Thu, 16 Dec 2021 07:31:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m2br8wvQu-QG; Thu, 16 Dec 2021 07:31:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDABA4B276;
	Thu, 16 Dec 2021 07:31:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8FDF4B269
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QO0yK1x94eHx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 07:31:42 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88DDC4B249
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 32B09B823F6;
 Thu, 16 Dec 2021 12:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06494C36AE3;
 Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639657900;
 bh=IGI05xEydLFA7YrmGD5I1ifkR6B6NdpQ0RaNjnKoW8I=;
 h=From:To:Cc:Subject:Date:From;
 b=iYGz4qU1gAFa7o40PdxHRf+5HnrXaTdYBxF6Z1Ax0sP6D47Nikx9gagdhCV9OvwHO
 bgSGDefW7CuNwCfl3ykGgYbrTTwMIroqLBazoN/+ilGVICsqNv1pKnt7LeecgF01PW
 3L3C20yM1Rn++m+Sn9f5ZGw5MHPkBDpl2YKQ6+IPSAACImaNeZkgi+ufGFK3SLhnCa
 QseS7wW9yhMcIE4teaPqh4WkFLaWWgX63LGGLQ6Jsc6ejGl0sgy1lPCb3Fu9py16G9
 z8FVua5mCIDlazVQCgrLd6Ghp8TMvuZLfy6VKdM3myrF5TxOQKfTBV6WmS4hoFaKO9
 9mft/oQGV0fHw==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxpv8-00CWIB-0O; Thu, 16 Dec 2021 12:31:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH 0/5] KVM: arm64: Selftest IPA fixes
Date: Thu, 16 Dec 2021 12:31:30 +0000
Message-Id: <20211216123135.754114-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Now that the common variety of fruity arm64 systems makes a pretty
remarkable KVM host, I have decided to run the collection of selftests
on it.

Nothing works. Oh no!

As it turns out, the tests have a notion of "default mode" (36bit PA,
4kB), which cannot work in general on arm64 because there no such
thing as an IPA size that would be valid everywhere (apart from the
minimal 32bit), nor a guaranteed to be supported page size.

This small series is a first attempt at making these things computed
at runtime by making the default something else on systems that do not
support it. It also makes the supported page sizes dynamically
discovered. The initial patch addresses an issue that has already been
addressed separately, and is only there so that I don't get shouted at
by some robot.

With that, the selftests do run on the M1, with the exception of the
memslot tests that are freaked out by the use of 16kB pages on the
host and 4kB in the guest. Maybe I'll implement some form of 16kB
support in the future.

Marc Zyngier (5):
  KVM: selftests: Fix vm_compute_max_gfn on !x86
  KVM: selftests: Initialise default mode in each test
  KVM: selftests: arm64: Introduce a variable default IPA size
  KVM: selftests: arm64: Check for supported page sizes
  KVM: selftests: arm64: Add support for VM_MODE_P36V48_{4K,64K}

 .../selftests/kvm/aarch64/arch_timer.c        |  3 +
 .../selftests/kvm/aarch64/debug-exceptions.c  |  3 +
 .../selftests/kvm/aarch64/get-reg-list.c      |  3 +
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  3 +
 .../testing/selftests/kvm/aarch64/vgic_init.c |  3 +
 .../testing/selftests/kvm/include/kvm_util.h  | 15 ++--
 .../selftests/kvm/kvm_binary_stats_test.c     |  3 +
 .../selftests/kvm/kvm_create_max_vcpus.c      |  3 +
 .../selftests/kvm/lib/aarch64/processor.c     |  8 ++
 tools/testing/selftests/kvm/lib/guest_modes.c | 77 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    |  6 ++
 .../testing/selftests/kvm/memslot_perf_test.c |  4 +
 tools/testing/selftests/kvm/rseq_test.c       |  3 +
 .../selftests/kvm/set_memory_region_test.c    |  4 +
 tools/testing/selftests/kvm/steal_time.c      |  3 +
 15 files changed, 131 insertions(+), 10 deletions(-)

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
