From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Wed, 29 Apr 2015 13:19:36 +0200
Message-ID: <20150429111936.GA2918@localhost.localdomain>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
	<1426705833-2679-1-git-send-email-drjones@redhat.com>
	<55409E4E.3090905@suse.de>
	<CAFEAcA8782LF=m_L=iEqgkBAVThO2SxXOu74YaM3YQkvN_4owA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA8782LF=m_L=iEqgkBAVThO2SxXOu74YaM3YQkvN_4owA@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 29, 2015 at 10:19:55AM +0100, Peter Maydell wrote:
> On 29 April 2015 at 10:03, Alexander Graf <agraf@suse.de> wrote:
> >
> >
> > On 18.03.15 20:10, Andrew Jones wrote:
> >> Introduce a new memory region flag, KVM_MEM_UNCACHED, which
> >> is needed by ARM. This flag informs KVM that the given memory
> >> region is typically mapped by the guest as uncached. KVM for
> >> ARM then maps that region as uncached for userspace as well,
> >> in order to keep coherency.
> >
> > I finally managed to give this a spin and immediately ran into an
> > unaligned access trap:

Thanks! And err.. sorry it broke.

> >
> > [  116.509976] Unhandled fault: alignment fault (0x92000061) at
> > 0x000003ffb1300000
> >
> > Program received signal SIGBUS, Bus error.
> > [Switching to Thread 0x3ffb317ecb0 (LWP 1956)]
> > 0x000003ffb685ed68 in memset () from /lib64/libc.so.6
> > (gdb) bt
> > #0  0x000003ffb685ed68 in memset () from /lib64/libc.so.6
> > #1  0x000002aaaac013ec in memset (__len=<optimized out>, __ch=0,
> > __dest=<optimized out>) at /usr/include/bits/string3.h:90
> > #2  vbe_ioport_write_data (opaque=0x2aaabbd3600, addr=<optimized out>,
> > val=65) at /usr/src/debug/qemu-2.3.0-rc4/hw/display/vga.c:739
> > #3  0x000002aaaabe07dc in memory_region_write_accessor (mr=<optimized
> > out>, addr=<optimized out>, value=<optimized out>, size=<optimized out>,
> >     shift=<optimized out>, mask=<optimized out>) at
> > /usr/src/debug/qemu-2.3.0-rc4/memory.c:430
> > [...]
> 
> This appears to be because the KVM_MEM_UNCACHED flag
> confusingly isn't marking the memory as Normal-Noncacheable
> but as Device-nGnRnE (aka Strongly Ordered). You can't unalignedly
> access Device memory (and so you can't use the usual userspace
> memcpy, memset, etc).
> 
> Did we really want Device-nGnRnE memory here? If we did can
> we have a less confusing name for the flag?

I hadn't considered the other side-effects of going with device
vs. normal memory. I'll change patch 3/3 with

31c31
< +	pte = set_pte_bit(pte, L_PTE_MT_UNCACHED);
---
> +	pte = set_pte_bit(pte, L_PTE_MT_WRITEBACK);
166c166
< +	pte = set_pte_bit(pte, PTE_ATTRINDX(MT_DEVICE_nGnRnE));
---
> +	pte = set_pte_bit(pte, PTE_ATTRINDX(MT_NORMAL_NC));



I've left this on the backburner too long, but I can pick it back
up on Monday. I still haven't looked at Paolo's mmu notifier
suggestion yet either. I'll start looking at that as well.

Thanks,
drew


> 
> [for the non-ARM folk, nGnRnE == no gathering of accesses,
> no reordering, no early-write-acknowledgement.]
> 
> thanks
> -- PMM
> 
> 
