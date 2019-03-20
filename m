From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH kvmtool v2 0/3] arm64: Basic SVE guest support
Date: Wed, 20 Mar 2019 12:07:25 +0000
Message-ID: <1553083648-5345-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <Julien.Grall@arm.com>, Andre Przywara <andre.przywara@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series, based on kvmtool master [1], contains development hacks
to accompany the recently posted v6 SVE guest support series for the
Linux kernel [2].

This series supersedes the previous posting [3], and is a clean(er)
rewrite of the minimal support required for SVE, without the debug/
testing cruft.

Due to an ABI change, this series does not work with the older (v5)
KVM series.

Testing and review welcome.

In particular, if people have a view on the --sve-vls parameter, I'd
be interested to discuss what that should look like.  See patch 3.

[1] 
git://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git master
https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/

Specifically, commit c57e001a3efb ("arm: Auto-detect guest GIC type").

[2] [PATCH v5 00/26] KVM: arm64: SVE guest support
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/thread.html

(Note, the subject line for this posting was incorrect.  It should have
read: [PATCH v6 00/27] KVM: arm64: SVE guest support)

git://linux-arm.org/linux-dm.git sve-kvm/v6/head
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v6/head


Dave Martin (3):
  arm/arm64: [HACK] Sync kernel headers from sve-guest v6
  arm64: Add basic SVE support
  arm64: Add command-line option to set the guest's SVE vector lengths

 arm/aarch32/include/kvm/kvm-cpu-arch.h    |  5 ++
 arm/aarch64/include/asm/kvm.h             | 22 +++++++
 arm/aarch64/include/kvm/kvm-config-arch.h | 10 +++-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  7 ++-
 arm/aarch64/kvm-cpu.c                     | 97 +++++++++++++++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |  2 +
 arm/kvm-cpu.c                             |  3 +
 include/linux/kvm.h                       |  5 ++
 8 files changed, 149 insertions(+), 2 deletions(-)

-- 
2.1.4
