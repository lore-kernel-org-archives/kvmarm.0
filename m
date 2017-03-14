From: Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH v3 00/25] arm/arm64: KVM: Rework the hyp-stub API
Date: Tue, 14 Mar 2017 19:08:03 +0530
Message-ID: <8493dac7-c9be-fd3b-c5c0-83fbbfa4af10@ti.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170306142458.8875-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: "J, KEERTHY" <j-keerthy@ti.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On Monday 06 March 2017 07:54 PM, Marc Zyngier wrote:
> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
> could do with some TLC (it cannot perform a soft-restart at HYP, and
> has holes in the hyp-stub support in a number of places). In general,
> it would be desirable for the 32bit behaviour to align on 64bit, if
> only to ease maintenance.
> 
> This series implements the following:
> - Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
> - Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
>   __hyp_reset_vectors
> - Implement add the stub entry points in the KVM init code, which
>   didn't implement any so far
> - Convert the HYP code to use the init code stubs directly
> - Some general cleanup as a result of these changes (which includes
>   killing HVC_GET_VECTORS)
> - Add some API documentation that covers the above
> 
> Patches 9 to 11 would be better squashed into 7 and 8, but I've kept
> separate so that I can take the blame for everything I've broken.

Tested for kexec booting with the patch series applied on linux-next.

kexec is working nicely with HYP and SVC modes. Tested for both modes by
using different u-boot for booting in HYP and SVC modes. Kexec works well.

Tested on DRA7-EVM, AM57XX-EVM and KEYSTONE-K2E-EVM.

Tested-by: Keerthy <j-keerthy@ti.com>

> 
> This has been tested on arm (Cubietruck, Jetson TK1) and arm64
> (Seattle), both as host and guest.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-December/473472.html
> 
> * From v2:
>   - Kill HVC_GET_VECTORS and the corresponding __hyp_get_vectors
> 
> * From v1:
>   - Fixed some glaring bugs (reported by Ard and James)
>   - Tidy up stub vector export on 32bit (Ard)
>   - Nicer VA/PA conversion on 32bit (Ard)
>   - Updated cpu_v7_reset documentation
>   - Cleaned up HYP reset on PM events
>   - Minor stub documentation update
> 
> Marc Zyngier (23):
>   arm64: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
>   arm64: KVM: Implement HVC_RESET_VECTORS stub hypercall
>   arm64: KVM: Implement HVC_GET_VECTORS in the init code
>   arm64: KVM: Allow the main HYP code to use the init hyp stub
>     implementation
>   arm64: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
>   arm64: KVM: Implement HVC_SOFT_RESTART in the init code
>   ARM: KVM: Convert KVM to use HVC_GET_VECTORS
>   ARM: Update cpu_v7_reset documentation
>   ARM: hyp-stub: Use r1 for the soft-restart address
>   ARM: Expose the VA/IDMAP offset
>   ARM: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
>   ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall
>   ARM: KVM: Implement HVC_GET_VECTORS in the init code
>   ARM: KVM: Allow the main HYP code to use the init hyp stub
>     implementation
>   ARM: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
>   ARM: KVM: Implement HVC_SOFT_RESTART in the init code
>   arm/arm64: KVM: Use __hyp_reset_vectors() directly
>   arm/arm64: KVM: Remove kvm_get_idmap_start
>   arm/arm64: KVM: Use HVC_RESET_VECTORS to reinit HYP mode
>   ARM: decompressor: Remove __hyp_get_vectors usage
>   ARM: hyp-stub/KVM: Kill __hyp_get_vectors
>   arm64: hyp-stub/KVM: Kill __hyp_get_vectors
>   arm/arm64: Add hyp-stub API documentation
> 
> Russell King (2):
>   ARM: hyp-stub: improve ABI
>   ARM: soft-reboot into same mode that we entered the kernel
> 
>  Documentation/virtual/kvm/arm/hyp-abi.txt | 45 ++++++++++++++++++++++++++++
>  arch/arm/boot/compressed/head.S           |  5 +++-
>  arch/arm/include/asm/kvm_asm.h            |  2 --
>  arch/arm/include/asm/kvm_host.h           |  6 ----
>  arch/arm/include/asm/kvm_mmu.h            |  1 -
>  arch/arm/include/asm/proc-fns.h           |  4 +--
>  arch/arm/include/asm/virt.h               | 12 +++++++-
>  arch/arm/kernel/hyp-stub.S                | 39 +++++++++++++++++++-----
>  arch/arm/kernel/reboot.c                  |  7 +++--
>  arch/arm/kvm/arm.c                        | 25 ++++++----------
>  arch/arm/kvm/hyp/hyp-entry.S              | 29 ++++++++++++++----
>  arch/arm/kvm/init.S                       | 49 ++++++++++++++++++++++++++-----
>  arch/arm/kvm/interrupts.S                 |  4 ---
>  arch/arm/kvm/mmu.c                        |  5 ----
>  arch/arm/mm/mmu.c                         |  5 ++++
>  arch/arm/mm/proc-v7.S                     | 15 ++++++----
>  arch/arm64/include/asm/kvm_asm.h          |  1 -
>  arch/arm64/include/asm/kvm_host.h         |  7 -----
>  arch/arm64/include/asm/kvm_mmu.h          |  1 -
>  arch/arm64/include/asm/virt.h             | 17 +++++++----
>  arch/arm64/kernel/hyp-stub.S              | 26 ++++++++--------
>  arch/arm64/kvm/hyp-init.S                 | 45 +++++++++++++++++++++-------
>  arch/arm64/kvm/hyp.S                      |  2 +-
>  arch/arm64/kvm/hyp/hyp-entry.S            | 39 ++++++++++++------------
>  24 files changed, 265 insertions(+), 126 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt
> 
