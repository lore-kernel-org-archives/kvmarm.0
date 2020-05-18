Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD373C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 07:37:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 480DB20715
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 07:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 480DB20715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nubificus.co.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A33414B181;
	Mon, 18 May 2020 03:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mJH2SHlVyjOW; Mon, 18 May 2020 03:37:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADAF14B191;
	Mon, 18 May 2020 03:37:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 904774B183
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 02:58:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tHGr2sjuFZaK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 02:58:10 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 506DF4B156
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 02:58:10 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id l17so10419756wrr.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 May 2020 23:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition:user-agent;
 bh=+D77RfiJOu4D1YxT/E/Zl3KQA8PQ7qtZd5MuZFWy0Z8=;
 b=eR4/+U5XtYG0hRezX4wYjPewOM321zfsJP/YDx3YJdkJeqznYc2uMMYUY/bxCJEvDJ
 /hUPOakwMEwnFVOQOipN87p7XraNSHS7+UgL3ucm2S+P45X1WUYNOH+BYZAPHPaH0Gq0
 76Y1JtRlMvXJDfWEIgh6EViXsA1yanlhYpEyyhk4F34wkC9Cl+k+sAWHRYxDAAWKoMiX
 wrE1S3ALUwusGczX0LTbC3t0SmffpcYQMQ03QstesZXDQgL5PHYB79/cPSYacAZHtvv9
 8Ktnhee7cCcOgv1Xs37TfwwVPNDGYcxw1qcZOkJIbtuFpIAkL3QtJZjSyfrSNQ2JLDnB
 JZ/g==
X-Gm-Message-State: AOAM5313zgy5V4mR2c/4uq3Cf8TOalGMLIyGXFg0ykLuh0AqA/AeAdvn
 tCrU6cgAn0PCLBLxB61ZHeE=
X-Google-Smtp-Source: ABdhPJyxw+2tvhwUPs5V0h23SzHGXLChNa2LJLySoY5UzfK9tiPx/GZscXXrz3LabEGdcG6dz3I77A==
X-Received: by 2002:adf:f981:: with SMTP id f1mr17802097wrr.244.1589785089337; 
 Sun, 17 May 2020 23:58:09 -0700 (PDT)
Received: from bf.nubificus.co.uk ([2a02:587:b919:800:aaa1:59ff:fe09:f176])
 by smtp.gmail.com with ESMTPSA id x184sm15563684wmg.38.2020.05.17.23.58.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 May 2020 23:58:08 -0700 (PDT)
Date: Mon, 18 May 2020 09:58:05 +0300
From: Anastassios Nanos <ananos@nubificus.co.uk>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Expose KVM API to Linux Kernel
Message-ID: <cover.1589784221.git.ananos@nubificus.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Mon, 18 May 2020 03:37:55 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Jim Mattson <jmattson@google.com>
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

To spawn KVM-enabled Virtual Machines on Linux systems, one has to use
QEMU, or some other kind of VM monitor in user-space to host the vCPU
threads, I/O threads and various other book-keeping/management mechanisms.
This is perfectly fine for a large number of reasons and use cases: for
instance, running generic VMs, running general purpose Operating systems
that need some kind of emulation for legacy boot/hardware etc.

What if we wanted to execute a small piece of code as a guest instance,
without the involvement of user-space? The KVM functions are already doing
what they should: VM and vCPU setup is already part of the kernel, the only
missing piece is memory handling.

With these series, (a) we expose to the Linux Kernel the bare minimum KVM
API functions in order to spawn a guest instance without the intervention
of user-space; and (b) we tweak the memory handling code of KVM-related
functions to account for another kind of guest, spawned in kernel-space.

PATCH #1 exposes the needed stub functions, whereas PATCH #2 introduces the
changes in the KVM memory handling code for x86_64 and aarch64.

An example of use is provided based on kvmtest.c
[https://lwn.net/Articles/658512/] at
https://github.com/cloudkernels/kvmmtest

Anastassios Nanos (2):
  KVMM: export needed symbols
  KVMM: Memory and interface related changes

 arch/arm64/include/asm/kvm_host.h   |   6 ++
 arch/arm64/kvm/fpsimd.c             |   8 +-
 arch/arm64/kvm/guest.c              |  48 +++++++++++
 arch/x86/include/asm/fpu/internal.h |  10 ++-
 arch/x86/kvm/cpuid.c                |  25 ++++++
 arch/x86/kvm/emulate.c              |   3 +-
 arch/x86/kvm/vmx/vmx.c              |   3 +-
 arch/x86/kvm/x86.c                  |  38 ++++++++-
 include/linux/kvm_host.h            |  36 +++++++++
 virt/kvm/arm/arm.c                  |  18 +++++
 virt/kvm/arm/mmu.c                  |  34 +++++---
 virt/kvm/async_pf.c                 |   4 +-
 virt/kvm/coalesced_mmio.c           |   6 ++
 virt/kvm/kvm_main.c                 | 120 ++++++++++++++++++++++------
 14 files changed, 316 insertions(+), 43 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
