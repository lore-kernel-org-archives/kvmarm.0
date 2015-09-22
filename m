From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [RFT - PATCH v2 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Tue, 22 Sep 2015 16:34:01 -0700
Message-ID: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is a 2nd itteration for arm64, v1 patches were posted by mistake from an 
older branch which included several bugs. Hopefully didn't waste too much of 
anyones time.

This patch series is a followup to the armv7 fp/simd lazy switch
implementation, uses similar approach and depends on the series - see
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016516.html

It's based on earlier arm64 fp/simd optimization work - see
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html

And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
32-bit guest on 64 bit host (and may require more here) - see
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html

This series has be tested with arm64 on arm64 with several FP applications 
running on host and guest, with substantial decrease on number of 
fp/simd context switches. From about 30% down to 2% with one guest running.

At this time I don't have arm32/arm64 working and hoping Christoffer and/or
Marc (or anyone) can test 32-bit guest/64-bit host.

Mario Smarduch (2):
  add hooks for armv8 fp/simd lazy switch
  enable armv8 fp/simd lazy switch

 arch/arm/kvm/arm.c                |  2 --
 arch/arm64/include/asm/kvm_asm.h  |  1 +
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/hyp.S              | 58 ++++++++++++++++++++++++++-------------
 5 files changed, 44 insertions(+), 21 deletions(-)

-- 
1.9.1

