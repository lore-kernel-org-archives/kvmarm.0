From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/8] arm64: KVM: Fix PMU exception generation
Date: Wed, 22 Feb 2017 11:47:20 +0000
Message-ID: <20170222114728.2472-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Running the following code:

root@zomby-woof:~# cat test-pmu.c
int main(int argc, char *argv[])
{
	unsigned int val;
	asm ("mrc p15, 0, %0, c9, c13, 0\n" : "=r" (val));
	return val;
}

in a 32bit guest (or a 64bit guest with a 32bit userspace) results in
this surprising result:

[  120.347497] kvm [1150]: Unsupported guest CP15 access at: ab0945ae
[  120.353689] kvm [1142]:  { Op0( 0), Op1( 0), CRn( 9), CRm(13), Op2( 0), func_read },

which is weird, because the guest behaves correctly:
root@zomby-woof:~# ./test-pmu 
[   16.184422] test-pmu[740]: undefined instruction: pc=00000000ab0945ae
[   16.186043] Code: 00340001 b4800000 af00b085 60396078 (3f1dee19) 
Illegal instruction

It gets the expected UNDEF, and all is fine. So what?

It turns out that the PMU emulation code is a bit lazy, and tells the
rest of KVM that the emulation has failed, so that an exception gets
delivered. Subtle differences in the 32bit vs 64bit handling make it
spit an "Unsupported..." error.

This series tries to set things straight:
- Allow an exception to be injected from an emulation handler
- Make all PMU illegal accesses inject an UNDEF
- Make these illegal accesses a successful emulation w.r.t the rest of KVM.

In the process, we also squash an interesting bug in the 64bit CP
access. Similar treatment could be applied to the 32bit kernel, except
that we don't ever inject an exception there (no PMU support yet).

Marc Zyngier (8):
  arm64: KVM: Don't skip an instruction if an exception is pending
  arm64: KVM: Let the vcpu carry a pointer to the sys_reg being emulated
  arm64: KVM: Refactor pmu_*_el0_disabled
  arm64: KVM: pmu: Inject UNDEF exception on illegal register access
  arm64: KVM: PMU: Inject UNDEF on non-privileged accesses
  arm64: KVM: PMU: Inject UNDEF on read access to PMSWINC_EL0
  arm64: KVM: pmu: Make illegal accesses seen as successfully emulated
  arm64: KVM: Do not corrupt registers on failed 64bit CP read

 arch/arm64/include/asm/kvm_host.h |   5 ++
 arch/arm64/kvm/sys_regs.c         | 150 +++++++++++++++++++++-----------------
 arch/arm64/kvm/sys_regs.h         |   1 +
 3 files changed, 91 insertions(+), 65 deletions(-)

-- 
2.11.0
