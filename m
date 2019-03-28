From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/ARM fixes for 5.1-rc3
Date: Thu, 28 Mar 2019 19:07:50 +0100
Message-ID: <87a94c00-c654-106e-5ab5-22e59af093d8@redhat.com>
References: <20190328133608.110805-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190328133608.110805-1-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Julien Thierry <julien.thierry@arm.com>, YueHaibing <yuehaibing@huawei.com>, Zheng Xiang <zhengxiang9@huawei.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, Eric Auger <eric.auger@redhat.com>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, Nianyao Tang <tangnianyao@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/03/19 14:36, Marc Zyngier wrote:
> Paolo, Radim,
> 
> Here's a handful of KVM/ARM fixes for 5.1-rc3. We have a number of
> stage-2 page table fixes, some srcu fixes the the ITS emulation, a
> reset fix for the virtual PMU, a GICv4 regression fix, and some
> cleanups.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:
> 
>   Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.1
> 
> for you to fetch changes up to 8324c3d518cfd69f2a17866b52c13bf56d3042d8:
> 
>   KVM: arm/arm64: Comments cleanup in mmu.c (2019-03-28 13:17:17 +0000)
> 
> ----------------------------------------------------------------
> KVM/ARM fixes for 5.1
> 
> - Fix THP handling in the presence of pre-existing PTEs
> - Honor request for PTE mappings even when THPs are available
> - GICv4 performance improvement
> - Take the srcu lock when writing to guest-controlled ITS data structures
> - Reset the virtual PMU in preemptible context
> - Various cleanups
> 
> ----------------------------------------------------------------
> Marc Zyngier (4):
>       KVM: arm64: Reset the PMU in preemptible context
>       arm64: KVM: Always set ICH_HCR_EL2.EN if GICv4 is enabled
>       KVM: arm/arm64: vgic-its: Take the srcu lock when writing to guest memory
>       KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslots
> 
> Suzuki K Poulose (2):
>       KVM: arm/arm64: Enforce PTE mappings at stage2 when needed
>       KVM: arm/arm64: Fix handling of stage2 huge mappings
> 
> YueHaibing (1):
>       KVM: arm/arm64: vgic-its: Make attribute accessors static
> 
> Zenghui Yu (1):
>       KVM: arm/arm64: Comments cleanup in mmu.c
> 
>  arch/arm/include/asm/kvm_mmu.h        |  11 +++
>  arch/arm/include/asm/stage2_pgtable.h |   2 +
>  arch/arm64/include/asm/kvm_mmu.h      |  11 +++
>  arch/arm64/kvm/reset.c                |   6 +-
>  virt/kvm/arm/hyp/vgic-v3-sr.c         |   4 +-
>  virt/kvm/arm/mmu.c                    | 125 ++++++++++++++++++++--------------
>  virt/kvm/arm/vgic/vgic-its.c          |  31 +++++----
>  virt/kvm/arm/vgic/vgic-v3.c           |   4 +-
>  virt/kvm/arm/vgic/vgic.c              |  14 ++--
>  9 files changed, 133 insertions(+), 75 deletions(-)
> 

Pulled, thanks.  Will push together with the x86 stuff I'm testing now,
and send it to Linus tomorrow.

Paolo
