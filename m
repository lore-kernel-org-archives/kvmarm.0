From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 13:09:34 +0200
Message-ID: <5554826E.1040706@redhat.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35C251456
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:00:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FzQROpfgHcUB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 07:00:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08DBC51431
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:00:39 -0400 (EDT)
In-Reply-To: <20150514103018.GM32765@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/14/15 12:30, Christoffer Dall wrote:
> On Wed, May 13, 2015 at 01:31:51PM +0200, Andrew Jones wrote:
>> Introduce a new memory region flag, KVM_MEM_UNCACHED, which is
>> needed by ARM. This flag informs KVM that the given memory region
>> is typically mapped by the guest as non-cacheable. KVM for ARM
>> then ensures that that memory is indeed mapped non-cacheable by
>> the guest, and also remaps that region as non-cacheable for
>> userspace, allowing them both to maintain a coherent view.
>>
>> Changes since v1:
>>  1) don't pin pages [Paolo]
>>  2) ensure the guest maps the memory non-cacheable [me]
>>  3) clean up memslot flag documentation [Christoffer]
>> changes 1 and 2 effectively redesigned/rewrote v1. Find v1 here
>> http://www.spinics.net/lists/kvm-arm/msg14022.html
>>
>> The QEMU series for v1 hasn't really changed. Only the linux
>> header hack needed to bump KVM_CAP_UNCACHED_MEM from 107 to
>> 116.  Find the series here
>> http://www.spinics.net/lists/kvm-arm/msg14026.html
>>
>> Testing:
>> This series still needs lots of testing, but I thought I'd
>> kick it to the list early, as there's been recent interest
>> in solving this problem, and I'd like to get test results
>> and opinions on this approach from others sooner than later.
>> I've tested with AAVMF (UEFI for AArch64 mach-virt guests).
>> AAVMF has a kludge in it to avoid the coherency problem.
> 
> How does the 'kludge' work?

https://github.com/tianocore/edk2/commit/f9a8be42

(It's probably worth looking at the documentation in the first hunk too,
under the commit message.)

Thanks
Laszlo


> 
>> I've tested both with and without that kludge active. Both
>> worked for me (almost). Sometimes with the non-kludged
>> version I was still able to see a bit of corruption in
>> grub's output after edk2 loaded it - not much, and not always,
>> but something.
> 
> Remind me, this is a VGA framebuffer corruption with a PCI-plugged VGA
> card?
> 
> Thanks,
> -Christoffer
> 
>> Anyway, it's quite frustrating, as I'm not sure
>> what I'm missing...
>>
>> This series applies to Linus' 110bc76729d4, but I tested with
>> a version backported to the current RHELSA kernel.
>>
>> Thanks for reviews and testing!
>>
>> drew
>>
>>
>> Andrew Jones (3):
>>   arm/arm64: pageattr: add set_memory_nc
>>   KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
>>   arm/arm64: KVM: implement 'uncached' mem coherency
>>
>>  Documentation/virtual/kvm/api.txt     | 20 ++++++++++++------
>>  arch/arm/include/asm/cacheflush.h     |  1 +
>>  arch/arm/include/asm/kvm_mmu.h        |  5 ++++-
>>  arch/arm/include/asm/pgtable-3level.h |  1 +
>>  arch/arm/include/asm/pgtable.h        |  1 +
>>  arch/arm/include/uapi/asm/kvm.h       |  1 +
>>  arch/arm/kvm/arm.c                    |  1 +
>>  arch/arm/kvm/mmu.c                    | 39 ++++++++++++++++++++++-------------
>>  arch/arm/mm/pageattr.c                |  7 +++++++
>>  arch/arm64/include/asm/cacheflush.h   |  1 +
>>  arch/arm64/include/asm/kvm_mmu.h      |  5 ++++-
>>  arch/arm64/include/asm/memory.h       |  1 +
>>  arch/arm64/include/asm/pgtable.h      |  1 +
>>  arch/arm64/include/uapi/asm/kvm.h     |  1 +
>>  arch/arm64/mm/pageattr.c              |  8 +++++++
>>  include/linux/kvm_host.h              |  1 -
>>  include/uapi/linux/kvm.h              |  2 ++
>>  virt/kvm/kvm_main.c                   |  7 ++++++-
>>  18 files changed, 79 insertions(+), 24 deletions(-)
>>
>> -- 
>> 2.1.0
>>
