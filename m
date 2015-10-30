From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v3 0/3] KVM/arm64/arm: enhance armv7/8 fp/simd lazy switch
Date: Fri, 30 Oct 2015 14:56:30 -0700
Message-ID: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: antonios.motakis@huawei.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

This short patch series combines the previous armv7 and armv8 versions.
For an FP and lmbench load it reduces fp/simd context switch from 30-50% down 
to 2%. Results will vary with load but is no worse then current
approach. 

In summary current lazy vfp/simd implementation switches hardware context only 
on guest access and again on exit to host, otherwise hardware context is
skipped. This patch set builds on that functionality and executes a hardware 
context switch only when  vCPU is scheduled out or returns to user space.

Patches were tested on FVP sw platform. FP crunching applications summing up
values, with outcome compared to known result were executed on several guests,
and host.

The test can be found here, https://github.com/mjsmar/arm-arm64-fpsimd-test
Tests executed 24 hours.

armv7 test:
- On host executed 12 fp crunching applications - used taskset to bind 
- Two guests - with 12 fp crunching processes - used taskset to bind
- half ran with 1ms sleep, remaining with no sleep

armv8 test: 
- same as above except used mix of armv7 and armv8 guests.

Every so often injected a fault (via proc file entry) and mismatch between 
expected and crunched summed value was reported. The FP crunch processes could 
continue to run but with bad results.

Looked at 'paranoia.c' - appears like a comprehensive hardware FP 
precision/behavior test.  It will test various behaviors and may fail having 
nothing to do with world switch of fp/simd - 
- Adequacy of guard digits for Mult., Div. and Subt.
- UnderflowThreshold = an underflow threshold.
- V = an overflow threshold, roughly.
...

With outcomes like -
- Smallest strictly positive number found is E0 = 4.94066e-324
- Searching for Overflow threshold: This may generate an error.
...

Personally don't understand everything it's dong.

Opted to use the simple tst-float executable.

These patches are based on earlier arm64 fp/simd optimization work -
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015748.html

And subsequent fixes by Marc and Christoffer at KVM Forum hackathon to handle
32-bit guest on 64 bit host - 
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-August/016128.html

Changes since v2->v3:
- combined arm v7 and v8 into one short patch series
- moved access to fpexec_el2 back to EL2
- Move host restore to EL1 from EL2 and call directly from host
- optimize trap enable code 
- renamed some variables to match usage

Changes since v1->v2:
- Fixed vfp/simd trap configuration to enable trace trapping
- Removed set_hcptr branch label
- Fixed handling of FPEXC to restore guest and host versions on vcpu_put
- Tested arm32/arm64
- rebased to 4.3-rc2
- changed a couple register accesses from 64 to 32 bit


Mario Smarduch (3):
  hooks for armv7 fp/simd lazy switch support
  enable enhanced armv7 fp/simd lazy switch
  enable enhanced armv8 fp/simd lazy switch

 arch/arm/include/asm/kvm_host.h   |  7 +++++
 arch/arm/kernel/asm-offsets.c     |  2 ++
 arch/arm/kvm/arm.c                |  6 ++++
 arch/arm/kvm/interrupts.S         | 60 ++++++++++++++++++++++++++++-----------
 arch/arm/kvm/interrupts_head.S    | 14 +++++----
 arch/arm64/include/asm/kvm_host.h |  4 +++
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/hyp.S              | 37 ++++++++++++++++++++----
 8 files changed, 103 insertions(+), 28 deletions(-)

-- 
1.9.1

