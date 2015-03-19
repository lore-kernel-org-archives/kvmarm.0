From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 19 Mar 2015 18:24:53 +0100
Message-ID: <20150319172452.GA7360@hawk.usersys.redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
	<1426705833-2679-1-git-send-email-drjones@redhat.com>
	<550AFFB4.1000504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <550AFFB4.1000504@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: peter.maydell@linaro.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, agraf@suse.de, lersek@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, m.smarduch@samsung.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 19, 2015 at 05:56:20PM +0100, Paolo Bonzini wrote:
> 
> 
> On 18/03/2015 20:10, Andrew Jones wrote:
> > Introduce a new memory region flag, KVM_MEM_UNCACHED, which
> > is needed by ARM. This flag informs KVM that the given memory
> > region is typically mapped by the guest as uncached. KVM for
> > ARM then maps that region as uncached for userspace as well,
> > in order to keep coherency.
> > 
> > Andrew Jones (3):
> >   KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
> >   arm/arm64: KVM: decouple READONLY and UNCACHED
> >   arm/arm64: KVM: implement KVM_MEM_UNCACHED
> > 
> >  Documentation/virtual/kvm/api.txt | 16 ++++---
> >  arch/arm/include/asm/kvm_mmu.h    |  9 ++++
> >  arch/arm/include/uapi/asm/kvm.h   |  2 +
> >  arch/arm/kvm/arm.c                |  1 +
> >  arch/arm/kvm/mmu.c                | 90 ++++++++++++++++++++++++++++++++++-----
> >  arch/arm64/include/asm/kvm_mmu.h  |  9 ++++
> >  arch/arm64/include/uapi/asm/kvm.h |  2 +
> >  include/linux/kvm_host.h          |  1 -
> >  include/uapi/linux/kvm.h          |  2 +
> >  virt/kvm/kvm_main.c               |  7 ++-
> >  10 files changed, 121 insertions(+), 18 deletions(-)
> > 

Hi Paolo,

Thanks for the comments!

> 
> I think the pinning breaks running KVM as non-root (the default ulimit
> -l is just 64 KiB).  Can you do something about it with the MMU
> notifiers instead?

I'll look into this as soon as possible. I'm headed out 25 minutes ago
for some vacation time though, so it'll be week or so before I can.

> 
> It looks very clean.
> 
> The fly in the ointment is that some kind of quirk is probably needed in
> the future for ivshmem---it's definitely not acceptable performance-wise
> to mark it uncached, neither in the guests not in the host.  On the
> other hand that quirk would be necessary only in the guest, not in the
> firmware, so we can live with a mixture of the two approaches.

Yes, quirking ivshmem makes sense. ivshmem users (guest drivers) should
ensure they map the memory as cached, as they know it's normal memory
on the host.

drew
