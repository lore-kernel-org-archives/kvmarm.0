Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1511EC43334
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 07:30:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52AE14B34B;
	Thu, 23 Jun 2022 03:30:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f-PY+6tyVT7A; Thu, 23 Jun 2022 03:30:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 363C14B32C;
	Thu, 23 Jun 2022 03:30:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06B924B253
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e8tsYGf0dAv4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 22:19:36 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91AA64B19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:36 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31838c41186so36748947b3.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 19:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=clGwED0aj4iCkpRX962hKSp2BNMhn+u4O4Dfvr+4TFo=;
 b=QIc7ryIuzZq7OzN7qncavyfDB+dbKXmztSbltzJfaHp1hfv5Y5C7ooLKoq0+zPKBFW
 Yb0/BwS6ZEfxF45IEKThJ2MueA04/+OqWzX470xd1LnNts5nGxalTSLvPuyQYFShfxVY
 fr4wYm+DZCv+ppd68WfEA3gHFWzd+l9k/IeA3ejN3UEhM2Mgzid5sCvby/eJdNVuWRpQ
 T0hYRgEzg4XuwmsYlfvFW+IIAB7fjU1loFiyTbwdYIVKiDrgd9GjTDFXVUeSo350hrx5
 PUr8oLhkHA9+OABNIyny8ozoHdOiM1g4AmYdxtdgzxsW7Kh9yYaDEBQC7KQPY5UXS7ff
 SqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=clGwED0aj4iCkpRX962hKSp2BNMhn+u4O4Dfvr+4TFo=;
 b=wnlkbwgNISt/2nkFlQghAx6i39b6wDulwUvtTZVThjnhxZWqzf6HjMoFrgrUIt0C2H
 2KXD619ynDzbDq98YN8+BqbolFCJdpiJYhbJC/qQX27Dq1zoYameDP3Z8HX/ZzUSbdh7
 v0e3V9izHlYMWebUUSpfsBWwLBCq3yVFyQsKdZfmODslk8g38tD1nZ2KaYFm1K9OPIrj
 uhcpT/BLtL3MTd66v7NtmhQgROk9zDtpVFDv/+r93ejyNoufCnI98e3dKRVaMWt6MLMo
 mPqCBmcbcCpEdH7hnDzKTHtOfwkGmMejYuxOJPbtXrbj4N4j+p2Uz3v0jG5mZt2GM/+I
 d1Mw==
X-Gm-Message-State: AJIora8j/oZ3/MuPCrNq6p92/b9uxOIHOABgMRXB1DQcwuEFawg13UcH
 Srsj8A8m3AhoREd2st0SxGjybJir+lF+kbObEzpW88fcBdvHCrVZdGs8c+tjh13u6MN5zSFh0cP
 5koEC2XmtI5VIRzs4uQi3k9AbSMQXOmL97FyNFDB3MAVluaC16dIf4WuvDsth8w==
X-Google-Smtp-Source: AGRyM1tFAzIf0LizFYNaF+FpbBnP7KTyC21L9xOk3A4wFYiTKAd03Hngi8vpnd587mAKhdzQ+Cp3fcs=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:ba6f:123c:d287:a160])
 (user=pcc job=sendgmr) by 2002:a81:9c47:0:b0:313:31e7:dc16 with SMTP id
 n7-20020a819c47000000b0031331e7dc16mr7974663ywa.227.1655950776012; Wed, 22
 Jun 2022 19:19:36 -0700 (PDT)
Date: Wed, 22 Jun 2022 19:19:23 -0700
Message-Id: <20220623021926.3443240-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 0/3] KVM: arm64: support MTE in protected VMs
From: Peter Collingbourne <pcc@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 23 Jun 2022 03:30:27 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Deacon <will@kernel.org>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org
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

Hi,

This patch series contains a proposed extension to pKVM that allows MTE
to be exposed to the protected guests. It is based on the base pKVM
series previously sent to the list [1] and later rebased to 5.19-rc2
and uploaded to [2].

This series takes precautions against host compromise of the guests
via direct access to their tag storage, by preventing the host from
accessing the tag storage via stage 2 page tables. The device tree
must describe the physical memory address of the tag storage, if any,
and the memory nodes must declare that the tag storage location is
described. Otherwise, the MTE feature is disabled in protected guests.

Now that we can easily do so, we also prevent the host from accessing
any unmapped reserved-memory regions without a driver, as the host
has no business accessing that memory.

A proposed extension to the devicetree specification is available at
[3], a patched version of QEMU that produces the required device tree
nodes is available at [4] and a patched version of the crosvm hypervisor
that enables MTE is available at [5].

[1] https://lore.kernel.org/all/20220519134204.5379-1-will@kernel.org/
[2] https://android-kvm.googlesource.com/linux/ for-upstream/pkvm-base-v2
[3] https://github.com/pcc/devicetree-specification mte-alloc
[4] https://github.com/pcc/qemu mte-shared-alloc
[5] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/3719324

Peter Collingbourne (3):
  KVM: arm64: add a hypercall for disowning pages
  KVM: arm64: disown unused reserved-memory regions
  KVM: arm64: allow MTE in protected VMs if the tag storage is known

 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/include/asm/kvm_host.h             |  6 ++
 arch/arm64/include/asm/kvm_pkvm.h             |  4 +-
 arch/arm64/kernel/image-vars.h                |  3 +
 arch/arm64/kvm/arm.c                          | 83 ++++++++++++++++++-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  5 +-
 arch/arm64/kvm/mmu.c                          |  4 +-
 12 files changed, 126 insertions(+), 10 deletions(-)

-- 
2.37.0.rc0.104.g0611611a94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
