From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH 0/4] arm64: Support perf event modifiers :G and :H
Date: Thu, 15 Nov 2018 12:55:45 +0000
Message-ID: <1542286549-4501-1-git-send-email-andrew.murray@arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patchset provides support for perf event modifiers :G and :H which
allows for filtering of PMU events between host and guests when used
with KVM.

As the underlying hardware cannot distinguish between guest and host
context, the performance counters must be stopped and started upon
entry/exit to the guest. This is performed at EL2 in a way that
minimizes overhead and improves accuracy of recording events that only
occur in the requested context.

This has been tested with VHE and non-VHE kernels with a KVM guest.

Andrew Murray (4):
  arm64: KVM: add accessors to track guest/host only counters
  arm64: arm_pmu: Add support for exclude_host/exclude_guest attributes
  arm64: arm_pmu: Exclude EL1,2 with :G :H perf attributes
  arm64: KVM: Enable support for :G/:H perf event modifiers

 arch/arm64/include/asm/kvm_host.h | 20 +++++++++++++++++
 arch/arm64/kernel/perf_event.c    | 45 +++++++++++++++++++++++++++++++++------
 arch/arm64/kvm/hyp/switch.c       | 38 +++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 7 deletions(-)

-- 
2.7.4
