From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Handle hva aging while destroying the
 vm
Date: Thu, 6 Jul 2017 10:14:08 +0200
Message-ID: <20170706081408.GD18106@cbox>
References: <1499235631-141725-1-git-send-email-agraf@suse.de>
 <20170705085700.GA16881@e107814-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0887340D14
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jul 2017 04:13:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1KLv8vun66pz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jul 2017 04:13:50 -0400 (EDT)
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 992B540A86
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jul 2017 04:13:50 -0400 (EDT)
Received: by mail-lf0-f49.google.com with SMTP id b207so7167370lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Jul 2017 01:14:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170705085700.GA16881@e107814-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 05, 2017 at 09:57:00AM +0100, Suzuki K Poulose wrote:
> Hi Alex,
> 
> On Wed, Jul 05, 2017 at 08:20:31AM +0200, Alexander Graf wrote:
> > The kvm_age_hva callback may be called all the way concurrently while
> > kvm_mmu_notifier_release() is running.
> > 
> > The release function sets kvm->arch.pgd = NULL which the aging function
> > however implicitly relies on in stage2_get_pud(). That means they can
> > race and the aging function may dereference a NULL pgd pointer.
> > 
> > This patch adds a check for that case, so that we leave the aging
> > function silently.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
> > Signed-off-by: Alexander Graf <agraf@suse.de>
> > 
> > ---
> > 
> > v1 -> v2:
> > 
> >   - Fix commit message
> >   - Add Fixes and stable tags
> > ---
> >  virt/kvm/arm/mmu.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> > index f2d5b6c..227931f 100644
> > --- a/virt/kvm/arm/mmu.c
> > +++ b/virt/kvm/arm/mmu.c
> > @@ -861,6 +861,10 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
> >  	pgd_t *pgd;
> >  	pud_t *pud;
> >  
> > +	/* Do we clash with kvm_free_stage2_pgd()? */
> > +	if (!kvm->arch.pgd)
> > +		return NULL;
> > +
> 
> I think this check should be moved up in the chain. We call kvm_age_hva(), with
> the kvm->mmu_lock held and we don't release it till we reach here. So, ideally,
> if we find the PGD is null when we reach kvm_age_hva(), we could simply return
> there, like we do for other call backs from the KVM mmu_notifier.
> 
> 
> ----8>----
> 
> kvm-arm: Handle hva aging while destroying vm
> 
> The mmu_notifier_release() callback of KVM triggers cleaning up
> the stage2 page table on kvm-arm. However there could be other
> notifier callbacks in parallel with the mmu_notifier_release(),
> which could cause the call backs ending up in an empty stage2
> page table. Make sure we check it for all the notifier callbacks.
> 
> Reported-by: Alex Graf <agraf@suse.de>
> Cc: Christoffer Dall <cdall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: stable@vger.kernel.org
> Fixes: commit 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index e2e5eff..db1c7b2 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1665,12 +1665,16 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
>  
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
>  {
> +	if (!kvm->arch.pgd)
> +		return 0;
>  	trace_kvm_age_hva(start, end);
>  	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
>  }
>  
>  int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
>  {
> +	if (!kvm->arch.pgd)
> +		return 0;
>  	trace_kvm_test_age_hva(hva);
>  	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
>  }
> -- 
> 2.7.5
> 

For this patch:

Reviewed-by: Christoffer Dall <cdall@linaro.org>
