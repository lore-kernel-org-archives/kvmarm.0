From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Handle hva aging while destroying the vm
Date: Tue, 4 Jul 2017 10:35:42 +0200
Message-ID: <20170704083542.GK4066@cbox>
References: <1498231319-199734-1-git-send-email-agraf@suse.de>
 <20170703080313.GB4066@cbox>
 <a7921cdb-a5e5-8fc0-92d5-807f07c59069@suse.de>
 <20170703234149.GE5738@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C44240D43
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 04:35:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N23Q8bxSE24j for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jul 2017 04:35:26 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D6C040960
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 04:35:26 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id w126so188612022wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jul 2017 01:35:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170703234149.GE5738@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 04, 2017 at 01:41:49AM +0200, Andrea Arcangeli wrote:
> Hello,
> 
> On Mon, Jul 03, 2017 at 10:48:03AM +0200, Alexander Graf wrote:
> > On 07/03/2017 10:03 AM, Christoffer Dall wrote:
> > > Hi Alex,
> > >
> > > On Fri, Jun 23, 2017 at 05:21:59PM +0200, Alexander Graf wrote:
> > >> If we want to age an HVA while the VM is getting destroyed, we have a
> > >> tiny race window during which we may end up dereferencing an invalid
> > >> kvm->arch.pgd value.
> > >>
> > >>     CPU0               CPU1
> > >>
> > >>     kvm_age_hva()
> > >>                        kvm_mmu_notifier_release()
> > >>                        kvm_arch_flush_shadow_all()
> > >>                        kvm_free_stage2_pgd()
> > >>                        <grab mmu_lock>
> > >>     stage2_get_pmd()
> > >>     <wait for mmu_lock>
> > >>                        set kvm->arch.pgd = 0
> > >>                        <free mmu_lock>
> > >>     <grab mmu_lock>
> > >>     stage2_get_pud()
> > >>     <access kvm->arch.pgd>
> > >>     <use incorrect value>
> > > I don't think this sequence, can happen, but I think kvm_age_hva() can
> > > be called with the mmu_lock held and kvm->pgd already being NULL.
> > >
> > > Is that possible for the mmu notifiers to be calling clear(_flush)_young
> > > while also calling notifier_release?
> > 
> > I *think* the aging happens completely orthogonally to release. But 
> > let's ask Andrea - I'm sure he knows :).
> 
> I think the sequence can happen. All mmu notifier methods are flushed
> out of CPUs only through synchronize_srcu() which is called as the
> last step in __mmu_notifier_release/unregister. Only after _unregister
> returns you're sure kvm_age_hva cannot run anymore, until that point
> it can still run. Even during exit_mmap->mmu_notifier_release it can
> still run if invoked through rmap walks.
> 
> So while the ->release method runs, all other mmu notifier methods
> could be still invoked concurrently.
> 
> mmu notifier methods are only protected by srcu to prevent the mmu
> notifier structure to be freed from under them, but there's no
> additional locking to serialize them (except for the synchronize_srcu
> that happens as the last step of mmu_notifier_release/unregister, well
> after they may have called the ->release method).
> 
> There's also a comment about it in __mmu_notifier_release:
> 
>  * runs with mm_users == 0. Other tasks may still invoke mmu notifiers
>  * in parallel despite there being no task using this mm any more,
>  * through the vmas outside of the exit_mmap context, such as with
>  * vmtruncate. This serializes against mmu_notifier_unregister with
> 
> And in the mmu_notifier_unregister too:
> 
>  * calling mmu_notifier_unregister. ->release or any other notifier
>  * method may be invoked concurrently with mmu_notifier_unregister,
>  * and only after mmu_notifier_unregister returned we're guaranteed
>  * that ->release or any other method can't run anymore.
> 
> Even ->release could in theory run concurrently against itself if
> mmu_notifier_unregister runs concurrently with mmu_notifier_release
> but that's purely theoretical possibility.
> 

Thanks for the clarification.

So Alex, I think you just need to fix the commit message of this patch.

Thanks,
-Christoffer
