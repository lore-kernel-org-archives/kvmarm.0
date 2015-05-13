From: Andrew Jones <drjones@redhat.com>
Subject: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Wed, 13 May 2015 13:31:51 +0200
Message-ID: <1431516714-25816-1-git-send-email-drjones@redhat.com>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, agraf@suse.de
Cc: catalin.marinas@arm.com, j.fanguede@virtualopensystems.com, lersek@redhat.com, m.smarduch@samsung.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a new memory region flag, KVM_MEM_UNCACHED, which is
needed by ARM. This flag informs KVM that the given memory region
is typically mapped by the guest as non-cacheable. KVM for ARM
then ensures that that memory is indeed mapped non-cacheable by
the guest, and also remaps that region as non-cacheable for
userspace, allowing them both to maintain a coherent view.

Changes since v1:
 1) don't pin pages [Paolo]
 2) ensure the guest maps the memory non-cacheable [me]
 3) clean up memslot flag documentation [Christoffer]
changes 1 and 2 effectively redesigned/rewrote v1. Find v1 here
http://www.spinics.net/lists/kvm-arm/msg14022.html

The QEMU series for v1 hasn't really changed. Only the linux
header hack needed to bump KVM_CAP_UNCACHED_MEM from 107 to
116.  Find the series here
http://www.spinics.net/lists/kvm-arm/msg14026.html

Testing:
This series still needs lots of testing, but I thought I'd
kick it to the list early, as there's been recent interest
in solving this problem, and I'd like to get test results
and opinions on this approach from others sooner than later.
I've tested with AAVMF (UEFI for AArch64 mach-virt guests).
AAVMF has a kludge in it to avoid the coherency problem.
I've tested both with and without that kludge active. Both
worked for me (almost). Sometimes with the non-kludged
version I was still able to see a bit of corruption in
grub's output after edk2 loaded it - not much, and not always,
but something. Anyway, it's quite frustrating, as I'm not sure
what I'm missing...

This series applies to Linus' 110bc76729d4, but I tested with
a version backported to the current RHELSA kernel.

Thanks for reviews and testing!

drew


Andrew Jones (3):
  arm/arm64: pageattr: add set_memory_nc
  KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
  arm/arm64: KVM: implement 'uncached' mem coherency

 Documentation/virtual/kvm/api.txt     | 20 ++++++++++++------
 arch/arm/include/asm/cacheflush.h     |  1 +
 arch/arm/include/asm/kvm_mmu.h        |  5 ++++-
 arch/arm/include/asm/pgtable-3level.h |  1 +
 arch/arm/include/asm/pgtable.h        |  1 +
 arch/arm/include/uapi/asm/kvm.h       |  1 +
 arch/arm/kvm/arm.c                    |  1 +
 arch/arm/kvm/mmu.c                    | 39 ++++++++++++++++++++++-------------
 arch/arm/mm/pageattr.c                |  7 +++++++
 arch/arm64/include/asm/cacheflush.h   |  1 +
 arch/arm64/include/asm/kvm_mmu.h      |  5 ++++-
 arch/arm64/include/asm/memory.h       |  1 +
 arch/arm64/include/asm/pgtable.h      |  1 +
 arch/arm64/include/uapi/asm/kvm.h     |  1 +
 arch/arm64/mm/pageattr.c              |  8 +++++++
 include/linux/kvm_host.h              |  1 -
 include/uapi/linux/kvm.h              |  2 ++
 virt/kvm/kvm_main.c                   |  7 ++++++-
 18 files changed, 79 insertions(+), 24 deletions(-)

-- 
2.1.0
