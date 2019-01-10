From: Tianyu Lan <lantianyu1986@gmail.com>
Subject: Re: [PATCH 9/11] KVM/MMU: Flush tlb in the kvm_mmu_write_protect_pt_masked()
Date: Thu, 10 Jan 2019 17:06:25 +0800
Message-ID: <CAOLK0pz6K90+QOMV2Vmhd3vC2t5+15vmUo0E=2rwax7cGDfxjw@mail.gmail.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-10-Tianyu.Lan@microsoft.com> <7eb0cde4-9436-9719-dd13-caf4ab5083a2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7eb0cde4-9436-9719-dd13-caf4ab5083a2@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, Radim Krcmar <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, bp@alien8.de, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm <kvm@vger.kernel.org>, michael.h.kelley@microsoft.com, kys@microsoft.com, vk
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 8, 2019 at 12:26 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/01/19 09:54, lantianyu1986@gmail.com wrote:
> >               rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
> >                                         PT_PAGE_TABLE_LEVEL, slot);
> > -             __rmap_write_protect(kvm, rmap_head, false);
> > +             flush |= __rmap_write_protect(kvm, rmap_head, false);
> >
> >               /* clear the first set bit */
> >               mask &= mask - 1;
> >       }
> > +
> > +     if (flush && kvm_available_flush_tlb_with_range()) {
> > +             kvm_flush_remote_tlbs_with_address(kvm,
> > +                             slot->base_gfn + gfn_offset,
> > +                             hweight_long(mask));
>
> Mask is zero here, so this probably won't work.
>
> In addition, I suspect calling the hypercall once for every 64 pages is
> not very efficient.  Passing a flush list into
> kvm_mmu_write_protect_pt_masked, and flushing in
> kvm_arch_mmu_enable_log_dirty_pt_masked, isn't efficient either because
> kvm_arch_mmu_enable_log_dirty_pt_masked is also called once per word.
>
Yes, this is not efficient.

> I don't have any good ideas, except for moving the whole
> kvm_clear_dirty_log_protect loop into architecture-specific code (which
> is not the direction we want---architectures should share more code, not
> less).

kvm_vm_ioctl_clear_dirty_log/get_dirty_log()  is to get/clear dirty log with
memslot as unit. We may just flush tlbs of the affected memslot instead of
entire page table's when range flush is available.

>
> Paolo
>
> > +             flush = false;
> > +     }
> > +
>


--
Best regards
Tianyu Lan
