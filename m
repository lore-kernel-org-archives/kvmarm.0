From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 0/2] KVM: arm64: Optime FPSIMD context handling
Date: Fri, 16 Feb 2018 18:29:29 +0000
Message-ID: <1518805771-15346-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This series attempts to integrate KVM's FPSIMD context handling more
closely with the host, so that we can take advantage of better
knowledge about when the FPSIMD registers are live and whose data they
contain.

These patches are based on:

git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git vhe-optimize-v4
ef09bac916ae ("KVM: arm/arm64: Avoid VGICv3 save/restore on VHE with no IRQs")

...and currently completely untested.

They do build for defconfig at least.


This is still a big hack and I may have missed something critical,
so I invite people to come and poke holes it...

Dave Martin (2):
  KVM: arm64: Convert lazy FPSIMD context switch trap to C
  KVM: arm64: Eliminate most redundant FPSIMD saves and restores

 arch/arm64/include/asm/fpsimd.h      |  1 +
 arch/arm64/include/asm/kvm_host.h    | 10 ++++++-
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h    | 14 +++++----
 arch/arm64/kernel/fpsimd.c           |  7 ++++-
 arch/arm64/kvm/hyp/entry.S           | 57 ++++++++++++++----------------------
 arch/arm64/kvm/hyp/switch.c          | 37 ++++++++++++++++++++---
 virt/kvm/arm/arm.c                   | 50 +++++++++++++++++++++++++++++++
 8 files changed, 130 insertions(+), 47 deletions(-)

-- 
2.1.4
