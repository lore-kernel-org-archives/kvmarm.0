From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/2] arm64: kvm: cache ID register trapping
Date: Thu, 31 Jan 2019 14:17:16 +0100
Message-ID: <20190131131718.1627-1-ard.biesheuvel@linaro.org>
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
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, christoffer.dall@arm.com, Suzuki.Poulose@arm.com, kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

While looking into whether we could report the cache geometry as 1 set
and 1 way so that the ARM kernel doesn't stall for 13 seconds at boot,
I noticed that we don't expose the sanitised version of CTR_EL0 to guests,
so I fixed that first (#1)

Since that gives us most of the groundwork for overriding the cache
geometry, it is a fairly trivial change (#2) to clear the set/way
fields in the CCSIDR register so that it describes 1 set and 1 way.

Changes since v1:
- fix incorrect mask value (#2)
- make trapping conditional on whether either of the issues is being
  worked around, and it disabled otherwise
- add Christoffer's ack

Cc: Suzuki.Poulose@arm.com
Cc: marc.zyngier@arm.com
Cc: christoffer.dall@arm.com

Ard Biesheuvel (2):
  arm64: kvm: expose sanitised cache type register to guest
  arm64: kvm: describe data or unified caches as having 1 set and 1 way

 arch/arm64/include/asm/kvm_emulate.h |  4 ++
 arch/arm64/include/asm/sysreg.h      |  1 +
 arch/arm64/kvm/sys_regs.c            | 74 +++++++++++++++++++-
 3 files changed, 77 insertions(+), 2 deletions(-)

-- 
2.20.1
