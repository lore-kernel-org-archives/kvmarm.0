From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 1/2] kvm: Fix mmu_notifier release race
Date: Tue, 25 Apr 2017 20:49:05 +0200
Message-ID: <20170425184904.GI5713@potion>
References: <1493028624-29837-1-git-send-email-suzuki.poulose@arm.com>
 <1493028624-29837-2-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9D3140C75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 14:46:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hsCGbz1wmP5X for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 14:46:21 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0694A40C74
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 14:46:20 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1493028624-29837-2-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-04-24 11:10+0100, Suzuki K Poulose:
> The KVM uses mmu_notifier (wherever available) to keep track
> of the changes to the mm of the guest. The guest shadow page
> tables are released when the VM exits via mmu_notifier->ops.release().
> There is a rare chance that the mmu_notifier->release could be
> called more than once via two different paths, which could end
> up in use-after-free of kvm instance (such as [0]).
> 
> e.g:
> 
> thread A                                        thread B
> -------                                         --------------
> 
>  get_signal->                                   kvm_destroy_vm()->
>  do_exit->                                        mmu_notifier_unregister->
>  exit_mm->                                        kvm_arch_flush_shadow_all()->
>  exit_mmap->                                      spin_lock(&kvm->mmu_lock)
>  mmu_notifier_release->                           ....
>   kvm_arch_flush_shadow_all()->                   .....
>   ... spin_lock(&kvm->mmu_lock)                   .....
>                                                   spin_unlock(&kvm->mmu_lock)
>                                                 kvm_arch_free_kvm()
>    *** use after free of kvm ***

I don't understand this race ...
a piece of code in mmu_notifier_unregister() says:

  	/*
  	 * Wait for any running method to finish, of course including
  	 * ->release if it was run by mmu_notifier_release instead of us.
  	 */
  	synchronize_srcu(&srcu);

and code before that removes the notifier from the list, so it cannot be
called after we pass this point.  mmu_notifier_release() does roughly
the same and explains it as:

  	/*
  	 * synchronize_srcu here prevents mmu_notifier_release from returning to
  	 * exit_mmap (which would proceed with freeing all pages in the mm)
  	 * until the ->release method returns, if it was invoked by
  	 * mmu_notifier_unregister.
  	 *
  	 * The mmu_notifier_mm can't go away from under us because one mm_count
  	 * is held by exit_mmap.
  	 */
  	synchronize_srcu(&srcu);

The call of mmu_notifier->release is protected by srcu in both cases and
while it seems possible that mmu_notifier->release would be called
twice, I don't see a combination that could result in use-after-free
from mmu_notifier_release after mmu_notifier_unregister() has returned.

Doesn't [2/2] solve the exact same issue (that the release method cannot
be called twice in parallel)?

Thanks.
