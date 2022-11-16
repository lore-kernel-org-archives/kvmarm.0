Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C8DC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:03:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D39E4B8D0;
	Wed, 16 Nov 2022 12:03:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KChYRqxciKml; Wed, 16 Nov 2022 12:03:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C27294B867;
	Wed, 16 Nov 2022 12:03:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEFF34B866
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eMtdfxrnazs0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:03:39 -0500 (EST)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 724BF4B862
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:39 -0500 (EST)
Received: by mail-ed1-f74.google.com with SMTP id
 f20-20020a0564021e9400b00461ea0ce17cso12908553edf.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=cqmymE4F1AzcVr0rAjT0TqGqidpCow5ff2C/QyEftUQ=;
 b=d5fT1+t1Uo2vlTG633RLZsby5RVVFLgn62ja1ehg00dbGfGQEC4Dclj3otyomMqUPd
 dRK431qRTVccl0zLA+QR3Sg1k5tDwTP8ZvlufaosrJTeU3I9SGP6OP3RA3fRRBtnD8Ra
 5Bw4S/8y6bjg7zU/jiFNGb7HTGS1TeUhX/xk/4NS1EVllxg4OgkSwcX6hc6UYr74us+Q
 7JJL7Zfs2I7Vnj52QpXivh6m59Efsn5pt519MvUQncwPIFm88yDje7J8NmlGrXYMAjTf
 qIASv6dOtCL/6Kntz4wo0E5kYL/8nDfVYFicos/exbnXSX97JGrG8tez3uP+AGBti+4i
 s/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=cqmymE4F1AzcVr0rAjT0TqGqidpCow5ff2C/QyEftUQ=;
 b=2YbS+KvVymkgFA9kNDViwDf6jnzHOwy64XDvwWgoxfGu6yzPIiIoltXj4ZX8/xDZ8r
 irPEYIHdnpe0L6gkr/Toh3/cnpPQUyZEdNh5g0dix3ocuSe7VHVcsahgkp0bFeylTJEZ
 zo0PMTkdX5Ktig2GcmMq+Nhtnaw5RTh2OfLDZgRR6/UWQsO+vEB4iDIimBfYWATPjbC2
 a8hXKdlL2LsX0EJEj/BFsbT/KMcg+K2Gm01GXCMQ5p3MeUa0PW6qoRgW703z/Y9c1IG9
 iDsfm7JdHjWThOUDXmZnA7/cvN6oHu2wtCqqKZOSB0QeJHrdIf9L6nWTcPA1eyCCHfLD
 A08A==
X-Gm-Message-State: ANoB5pl8crgO0+lS+tM2C+wt9FMPI0oTCgAlX8w3Ct1q5D4WNF6lkMMO
 J4xMwnGIJ5r0sA3VciEjWPvqac4W1OCX
X-Google-Smtp-Source: AA0mqf4kQcttgHovLZay3IZ5h8ySDasGuaZQArDBf5GZUHdssSgbM3MLRht2rLrBlFf4v9LLwgRpdc7gy3Ky
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:6893:b0:7ad:14f8:7583 with SMTP id
 n19-20020a170906689300b007ad14f87583mr19341242ejr.185.1668618218081; Wed, 16
 Nov 2022 09:03:38 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-1-qperret@google.com>
Subject: [PATCH 00/12] KVM: arm64: FF-A proxy for pKVM
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
 Andrew Walbran <qwandor@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi all,

pKVM's primary goal is to protect guest pages from a compromised host by
enforcing access control restrictions using stage-2 page-tables. Sadly,
this cannot prevent TrustZone from accessing non-secure memory, and a
compromised host could, for example, perform a 'confused deputy' attack
by asking TrustZone to use pages that have been donated to protected
guests. This would effectively allow the host to have TrustZone
exfiltrate guest secrets on its behalf, hence breaking the isolation
that pKVM intends to provide.

This series addresses this problem by providing pKVM with the ability to
monitor SMCs following the Arm FF-A protocol. FF-A provides (among other
things) a set of memory management APIs allowing the Normal World to
share, donate or lend pages with Secure. By monitoring these SMCs, pKVM
can ensure that the pages that are shared, lent or donated to Secure by
the host kernel are only pages that it owns.

It should be noted that the robustness of this approach relies on having
all Secure Software on the device use the FF-A protocol for memory
management transactions with the normal world, and not use
vendor-specific SMCs that pKVM is unable to parse. This is an important
software requirement to integrate pKVM correctly on a device. For the
record, this work is tractable in real world scenarios -- it was done
for the Pixel 7 and Pixel 7 Pro devices, both of which launched recently
with pKVM enabled.

This series introduces support for monitoring FF-A SMCs in the form of a
minimal proxy running in the EL2 hypervisor. This proxy aims to be
entirely 'transparent' to both the host kernel and TrustZone when the
system behaves correctly (the host is not compromised). The FF-A proxy
intercepts the SMCs coming from the host, and verifies that the pages
involved in the memory transition can be shared/lent/donated legally
before forwarding the SMC to Secure. The proxy also tracks which pages
have been made accessible to TrustZone at any point in time using
software bits in the stage-2 page-table of the host, to ensure they
can't be subsequently donated to guests.

The patch series is divided as follows:

 - patches 01-02 refactor existing FF-A header to allow code re-use;

 - patches 03-07 provide the initial infrastructure at EL2 to handle
   FF-A SMCs;

 - patches 08-12 use the previously introduced infrastructure to
   intercept the main memory management operations to share, reclaim and
   lend memory to/with Secure, and implement the core of the memory
   tracking logic.

Since this series depends on Will's recent pKVM series [1], it is based
on today's kvmarm/next:

    eb8be68e907e ("Merge branch kvm-arm64/misc-6.2 into kvmarm-master/next")

A branch with all the goodies applied can also be found here:

    https://android-kvm.googlesource.com/linux qperret/ffa-proxy

Feedback welcome!

Cheers,
Quentin

[1] https://lore.kernel.org/kvm/20221110190259.26861-1-will@kernel.org/

Fuad Tabba (1):
  KVM: arm64: Handle FFA_FEATURES call from the host

Quentin Perret (1):
  ANDROID: KVM: arm64: pkvm: Add support for fragmented FF-A descriptors

Will Deacon (10):
  firmware: arm_ffa: Move constants to header file
  firmware: arm_ffa: Move comment before the field it is documenting
  KVM: arm64: Block unsafe FF-A calls from the host
  KVM: arm64: Probe FF-A version and host/hyp partition ID during init
  KVM: arm64: Allocate pages for hypervisor FF-A mailboxes
  KVM: arm64: Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host
  KVM: arm64: Add FF-A helpers to share/unshare memory with secure world
  KVM: arm64: Handle FFA_MEM_SHARE calls from the host
  KVM: arm64: Handle FFA_MEM_RECLAIM calls from the host
  KVM: arm64: Handle FFA_MEM_LEND calls from the host

 arch/arm64/include/asm/kvm_host.h             |   1 +
 arch/arm64/include/asm/kvm_pkvm.h             |  21 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/hyp/include/nvhe/ffa.h         |  17 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   3 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 | 741 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   3 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  68 ++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  11 +
 arch/arm64/kvm/pkvm.c                         |   1 +
 drivers/firmware/arm_ffa/driver.c             | 101 +--
 include/linux/arm_ffa.h                       |  93 ++-
 13 files changed, 970 insertions(+), 93 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/ffa.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ffa.c

-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
