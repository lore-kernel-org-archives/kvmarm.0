From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: kvm/arm64: use-after-free in kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Thu, 13 Apr 2017 19:06:59 +0200
Message-ID: <CAAeHK+wTxrieyoNq9JJm_nAG1kt+4hn7-J+1ZBkzFx3Ug2SLUA@mail.gmail.com>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
 <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com> <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
 <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
 <1050c9d8-5813-5df9-29e5-3ab6e61b5de6@arm.com> <88715300-ef58-e7bd-81f5-95e0b9c9c533@arm.com>
 <20170413155045.GA8387@e107814-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170413155045.GA8387@e107814-lin.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 13, 2017 at 5:50 PM, Suzuki K. Poulose
<Suzuki.Poulose@arm.com> wrote:
> On Thu, Apr 13, 2017 at 10:17:54AM +0100, Suzuki K Poulose wrote:
>> On 12/04/17 19:43, Marc Zyngier wrote:
>> > On 12/04/17 17:19, Andrey Konovalov wrote:
>> >
>> > Hi Andrey,
>> >
>> > > Apparently this wasn't fixed, I've got this report again on
>> > > linux-next-c4e7b35a3 (Apr 11), which includes 8b3405e34 "kvm:
>> > > arm/arm64: Fix locking for kvm_free_stage2_pgd".
>> >
>> > This looks like a different bug.
>> >
>> > >
>> > > I now have a way to reproduce it, so I can test proposed patches. I
>> > > don't have a simple C reproducer though.
>> > >
>> > > The bug happens when the following syzkaller program is executed:
>> > >
>> > > mmap(&(0x7f0000000000/0xc000)=3Dnil, (0xc000), 0x3, 0x32, 0xffffffff=
ffffffff, 0x0)
>> > > unshare(0x400)
>> > > perf_event_open(&(0x7f000002f000-0x78)=3D{0x1, 0x78, 0x0, 0x0, 0x0, =
0x0,
>> > > 0x0, 0x6, 0x0, 0x0, 0xd34, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> > > 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x0, 0xffffffff,
>> > > 0xffffffffffffffff, 0x0)
>> > > r0 =3D openat$kvm(0xffffffffffffff9c,
>> > > &(0x7f000000c000-0x9)=3D"2f6465762f6b766d00", 0x0, 0x0)
>> > > ioctl$TIOCSBRK(0xffffffffffffffff, 0x5427)
>> > > r1 =3D ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
>> > > syz_kvm_setup_cpu$arm64(r1, 0xffffffffffffffff,
>> > > &(0x7f0000dc6000/0x18000)=3Dnil, &(0x7f000000c000)=3D[{0x0,
>> > > &(0x7f000000c000)=3D"5ba3c16f533efbed09f8221253c73763327fadce2371813=
b45dd7f7982f84a873e4ae89a6c2bd1af83a6024c36a1ff518318",
>> > > 0x32}], 0x1, 0x0, &(0x7f000000d000-0x10)=3D[@featur2=3D{0x1, 0x3}], =
0x1)
>> >
>> > Is that the only thing the program does? Or is there anything running =
in
>> > parallel?
>> >
>> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > > BUG: KASAN: use-after-free in arch_spin_is_locked
>> > > include/linux/compiler.h:254 [inline]
>> > > BUG: KASAN: use-after-free in unmap_stage2_range+0x990/0x9a8
>> > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
>> > > Read of size 8 at addr ffff800004476730 by task syz-executor/13106
>> > >
>> > > CPU: 1 PID: 13106 Comm: syz-executor Not tainted
>> > > 4.11.0-rc6-next-20170411-xc2-11025-gc4e7b35a33d4-dirty #5
>> > > Hardware name: Hardkernel ODROID-C2 (DT)
>> > > Call trace:
>> > > [<ffff20000808fd08>] dump_backtrace+0x0/0x440 arch/arm64/kernel/trap=
s.c:505
>> > > [<ffff2000080903c0>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:=
228
>> > > [<ffff2000088df030>] __dump_stack lib/dump_stack.c:16 [inline]
>> > > [<ffff2000088df030>] dump_stack+0x110/0x168 lib/dump_stack.c:52
>> > > [<ffff200008406db8>] print_address_description+0x60/0x248 mm/kasan/r=
eport.c:252
>> > > [<ffff2000084072c8>] kasan_report_error mm/kasan/report.c:351 [inlin=
e]
>> > > [<ffff2000084072c8>] kasan_report+0x218/0x300 mm/kasan/report.c:408
>> > > [<ffff200008407428>] __asan_report_load8_noabort+0x18/0x20 mm/kasan/=
report.c:429
>> > > [<ffff2000080db1b8>] arch_spin_is_locked include/linux/compiler.h:25=
4 [inline]
>> >
>> > This is the assert on the spinlock, and the memory is gone.
>> >
>> > > [<ffff2000080db1b8>] unmap_stage2_range+0x990/0x9a8
>> > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
>> > > [<ffff2000080db248>] kvm_free_stage2_pgd.part.16+0x30/0x98
>> > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:842
>> > > [<ffff2000080ddfb8>] kvm_free_stage2_pgd
>> > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:838 [inline]
>> >
>> > But we've taken than lock here. There's only a handful of instructions
>> > in between, and the memory can only go away if there is something
>> > messing with us in parallel.
>> >
>> > > [<ffff2000080ddfb8>] kvm_arch_flush_shadow_all+0x40/0x58
>> > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1895
>> > > [<ffff2000080c379c>] kvm_mmu_notifier_release+0x154/0x1d0
>> > > arch/arm64/kvm/../../../virt/kvm/kvm_main.c:472
>> > > [<ffff2000083f2b60>] __mmu_notifier_release+0x1c0/0x3e0 mm/mmu_notif=
ier.c:75
>> > > [<ffff2000083a1fb4>] mmu_notifier_release
>> > > include/linux/mmu_notifier.h:235 [inline]
>> > > [<ffff2000083a1fb4>] exit_mmap+0x21c/0x288 mm/mmap.c:2941
>> > > [<ffff20000810ecd4>] __mmput kernel/fork.c:888 [inline]
>> > > [<ffff20000810ecd4>] mmput+0xdc/0x2e0 kernel/fork.c:910
>> > > [<ffff20000811fda8>] exit_mm kernel/exit.c:557 [inline]
>> > > [<ffff20000811fda8>] do_exit+0x648/0x2020 kernel/exit.c:865
>> > > [<ffff2000081218b4>] do_group_exit+0xdc/0x260 kernel/exit.c:982
>> > > [<ffff20000813adf0>] get_signal+0x358/0xf58 kernel/signal.c:2318
>> > > [<ffff20000808de98>] do_signal+0x170/0xc10 arch/arm64/kernel/signal.=
c:370
>> > > [<ffff20000808edb4>] do_notify_resume+0xe4/0x120 arch/arm64/kernel/s=
ignal.c:421
>> > > [<ffff200008083e68>] work_pending+0x8/0x14
>> >
>> > So we're being serviced with a signal. Do you know if this signal is
>> > generated by your syzkaller program? We could be racing between do_exi=
t
>> > triggered by a fatal signal (this trace) and the closing of the two fi=
le
>> > descriptors (vcpu and vm).
>> >
>> > Paolo: does this look possible to you? I can't see what locking we hav=
e
>> > that could prevent this race.
>>
>> On a quick look, I see two issues:
>>
>> 1) It looks like the mmu_notifier->ops.release could be called twice for=
 a notifier,
>> from mmu_notifier_unregister() and exit_mmap()->mmu_notifier_release(), =
which is
>> causing the problem as above.
>>
>> This could possibly be avoided by swapping the order of the following op=
erations
>> in themmu_notifier_unregister():
>>
>>  a) Invoke ops->release under src_read_lock()
>>  b) Delete the notifier from the list.
>>
>> which can prevent mmu_notifier_release() calling the ops->release() agai=
n, before
>> we reach (b).
>>
>>
>> 2) The core KVM code does an mmgrab()/mmdrop on the current->mm to pin t=
he mm_struct. But
>> this doesn't prevent the "real_address user space" from being destroyed.=
 Since KVM
>> actually depends on the user pages and page tables, it should really/als=
o(?) use
>> mmget()/mmput() (See Documentation/vm/active_mm.txt). I understand that =
mmget() shouldn't
>> be used for pinning unbounded amount of time. But since we do it from wi=
thin the same
>> process context (like say threads), we should be safe to do so.
>
> Here is a patch which implements (2) above.

Hi Suzuki,

Your patch fixes KASAN reports for me.

Thanks!

>
> ----8>-----
>
> kvm: Hold reference to the user address space
>
> The core KVM code, uses mmgrab/mmdrop to pin the mm struct of the user
> application. mmgrab only guarantees that the mm struct is available,
> while the "real address space" (see Documentation/vm/active_mm.txt) may
> be destroyed. Since the KVM depends on the user space page tables for
> the Guest pages, we should instead do an mmget/mmput. Even though
> mmget/mmput is not encouraged for uses with unbounded time, the KVM
> is fine to do so, as we are doing it from the context of the same process=
.
>
> This also prevents the race condition where mmu_notifier_release() could
> be called in parallel and one instance could end up using a free'd kvm
> instance.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Paolo Bonzin <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: andreyknvl@google.com
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/kvm_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 88257b3..555712e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -613,7 +613,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>                 return ERR_PTR(-ENOMEM);
>
>         spin_lock_init(&kvm->mmu_lock);
> -       mmgrab(current->mm);
> +       mmget(current->mm);
>         kvm->mm =3D current->mm;
>         kvm_eventfd_init(kvm);
>         mutex_init(&kvm->lock);
> @@ -685,7 +685,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>         for (i =3D 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>                 kvm_free_memslots(kvm, kvm->memslots[i]);
>         kvm_arch_free_vm(kvm);
> -       mmdrop(current->mm);
> +       mmput(current->mm);
>         return ERR_PTR(r);
>  }
>
> @@ -747,7 +747,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>         kvm_arch_free_vm(kvm);
>         preempt_notifier_dec();
>         hardware_disable_all();
> -       mmdrop(mm);
> +       mmput(mm);
>  }
>
>  void kvm_get_kvm(struct kvm *kvm)
> --
> 2.7.4
> IMPORTANT NOTICE: The contents of this email and any attachments are conf=
idential and may also be privileged. If you are not the intended recipient,=
 please notify the sender immediately and do not disclose the contents to a=
ny other person, use it for any purpose, or store or copy the information i=
n any medium. Thank you.
