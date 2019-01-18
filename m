From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 00/12] arm64: SVE guest support test hacks
Date: Fri, 18 Jan 2019 16:14:09 +0000
Message-ID: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Julien Grall <Julien.Grall@arm.com>, Andre Przywara <andre.przywara@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series, based on kvmtool master [1], contains development hacks
to accompany the recently posted v4 SVE guest support series for the
Linux kernel [2].

This is not proposed for upstreaming in its current form, but some
things are probably close to being appropriate for upstream.

Comments and review welcome (but don't sweat the details too much).

[1] 
git://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git master
https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/

Specifically, commit fdd26ecb4bc5 ("kvm-cpu: Pause vCPU in signal handler").

[2] [PATCH v4 00/25] KVM: arm64: SVE guest support
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-January/034134.html
git://linux-arm.org/linux-dm.git sve-kvm/v4/head
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v4/head


Dave Martin (12):
  guest: Add generated file guest/guest_init.c to .gitignore
  update_headers: Sync kvm UAPI headers with linux v5.0-rc2
  Makefile: [HACK] Work around GCC 8 warnings :(
  Makefile: [HACK] Pass relevant flags when checking for libfdt
  arm64: Correct ARM64_CORE_REG() size encodings for all core registers
  arm64: [HACK] Pull in kvm UAPI header updates from SVE development
    branch
  arm64: [HACK] Add option to show the kernel's KVM register ID list
  arm64: [HACK] Basic SVE support
  arm64: [HACK] Show extra info about SVE with --show-reg-list
  arm64: [HACK] Allow configuration of the guest's set of SVE vector
    lengths
  arm64: [HACK] FPSIMD/SVE register dumping for lkvm debug
  arm64: [HACK] Check that out-of-range SVE register IDs can't be dumped

 Makefile                                  |  11 +-
 arm/aarch32/include/asm/kvm.h             |  55 ++++++-
 arm/aarch64/include/asm/kvm.h             |  54 ++++++-
 arm/aarch64/include/kvm/kvm-config-arch.h |   9 ++
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |   3 +-
 arm/aarch64/kvm-cpu.c                     | 209 ++++++++++++++++++++++++-
 arm/include/arm-common/kvm-config-arch.h  |   2 +
 arm/kvm-cpu.c                             | 239 ++++++++++++++++++++++++++++
 guest/.gitignore                          |   1 +
 include/linux/kvm.h                       | 250 +++++++++++++++++++++++++++++-
 mips/include/asm/kvm.h                    |  23 ++-
 powerpc/include/asm/kvm.h                 |  39 +++++
 x86/include/asm/kvm.h                     |  69 ++++++++-
 13 files changed, 944 insertions(+), 20 deletions(-)
 create mode 100644 guest/.gitignore

-- 
2.1.4
