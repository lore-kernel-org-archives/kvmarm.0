From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Handle hva aging while destroying the
 vm
Date: Thu, 6 Jul 2017 11:31:26 +0200
Message-ID: <20170706093126.GJ5738@redhat.com>
References: <1499235631-141725-1-git-send-email-agraf@suse.de>
 <20170705085700.GA16881@e107814-lin.cambridge.arm.com>
 <f8794311-ddec-fdb4-9ef2-2e2c05ca7467@suse.de>
 <20170706074513.GC18106@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170706074513.GC18106@cbox>
Sender: stable-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Alexander Graf <agraf@suse.de>, Suzuki K Poulose <Suzuki.Poulose@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

On Thu, Jul 06, 2017 at 09:45:13AM +0200, Christoffer Dall wrote:
> Let's look at the callers to stage2_get_pmd, which is the only caller of
> stage2_get_pud, where the problem was observed:
> 
>   user_mem_abort
>    -> stage2_set_pmd_huge
>       -> stage2_get_pmd
>   
>   user_mem_abort
>    -> stage2_set_pte
>       -> stage2_get_pmd
> 
>   handle_access_fault
>    -> stage2_get_pmd
> 
> For the above three functions, pgd cannot ever be NULL, because this is
> running in the context of a VCPU thread, which means the reference on
> the VM fd must not reach zero, so no need to call that here.

Just a minor nitpick: the !pgd bypass is necessary before the KVM fd
technically reaches zero.

exit_mm->mmput->exit_mmap() will invoke the __mmu_notifier_release
even if the KVM fd isn't zero yet.

This is because the secondary MMU page faults must be shutdown before
freeing the guest RAM (nothing can call handle_mm_fault or any
get_user_pages after mm->mm_users == 0), regardless if
mmu_notifier_unregister hasn't been called yet (i.e. if the /dev/kvm
fd is still open).

Usually the fd is closed immediately after exit_mmap, as exit_files is
called shortly after exit_mm() but there's a common window where the
fd is still open but the !pgd check is already necessary (plus the fd
could in theory be passed to other processes).

> using the kvm->mmu_lock() and understanding that this only happens when
> mmu notifiers call into the KVM MMU code outside the context of the VM.

Agreed.

The other arches don't need any special check to serialize against
kvm_mmu_notifier_release, they're just looking up shadow pagetables
through spte rmap (and they'll find nothing if
kvm_mmu_notifier_release already run).

In theory it would make more sense to put the overhead in the slow
path by adding a mutex to the mmu_notifier struct and then using that
to solve the race between mmu_notifier_release and
mmu_notifier_unregister, and then to hlist_del_init to unhash the mmu
notifier and then to call synchronize_srcu, before calling ->release
while holding some mutex. However that's going to be marginally slower
for the other arches.

In practice I doubt this is measurable and getting away with one less
mutex in mmu notifier_release vs mmu_notifier_unregister sounds
simpler but comments welcome...

Thanks,
Andrea
