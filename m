From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: kvm_arch_destroy_vm cleanups
Date: Fri, 1 Dec 2017 09:18:37 +0100
Message-ID: <20171201081837.ggr7wnn6dtx7m2bl@hawk.localdomain>
References: <20171127181718.5290-1-drjones@redhat.com>
 <20171201080919.GC4218@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6432B49D66
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 03:15:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KjznDMjw86Ro for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Dec 2017 03:15:42 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56B4540D25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 03:15:42 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171201080919.GC4218@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 01, 2017 at 09:09:19AM +0100, Christoffer Dall wrote:
> Hi Drew,
> 
> On Mon, Nov 27, 2017 at 07:17:18PM +0100, Andrew Jones wrote:
> > Recently commit b2c9a85dd75a ("KVM: arm/arm64: vgic: Move
> > kvm_vgic_destroy call around") caught my eye. When I looked closer I
> > saw that while it made the code saner, it wasn't changing anything.
> > kvm_for_each_vcpu() checks for NULL kvm->vcpus[i], so there wasn't
> > a NULL dereference being fixed, and because kvm_vgic_vcpu_destroy()
> > was called by kvm_arch_vcpu_free() it was still getting called, just
> > not by kvm_vgic_destroy() as intended. But now the call from
> > kvm_arch_vcpu_free() is redundant, and while currently harmless, it
> > should be removed in case kvm_vgic_vcpu_destroy() were ever to
> > want to reference vgic state, as kvm_vgic_destroy() now comes before
> > kvm_arch_vcpu_free(). Additionally the other architectures set
> > kvm->online_vcpus to zero after freeing them. We might as well do
> > that for ARM too.
> 
> Could this commit message be rewritten to:
> 
>   kvm_vgic_vcpu_destroy already gets called from kvm_vgic_destroy for
>   each vcpu, so we don't have to call it from kvm_arch_vcpu_free.
> 
>   Additionally the other architectures set kvm->online_vcpus to zero
>   after freeing them. We might as well do that for ARM too.

Sure, I don't mind you removing the '-v' (verbose) from it. Should I
respin? Or is that something you don't mind doing while applying?

Thanks,
drew

> 
> ?
> 
> Thanks,
> -Christoffer
> 
> 
> 
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  virt/kvm/arm/arm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index a6524ff27de4..c5bc79c4ccf7 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -188,6 +188,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >  			kvm->vcpus[i] = NULL;
> >  		}
> >  	}
> > +	atomic_set(&kvm->online_vcpus, 0);
> >  }
> >  
> >  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > @@ -296,7 +297,6 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
> >  {
> >  	kvm_mmu_free_memory_caches(vcpu);
> >  	kvm_timer_vcpu_terminate(vcpu);
> > -	kvm_vgic_vcpu_destroy(vcpu);
> >  	kvm_pmu_vcpu_destroy(vcpu);
> >  	kvm_vcpu_uninit(vcpu);
> >  	kmem_cache_free(kvm_vcpu_cache, vcpu);
> > -- 
> > 2.13.6
> > 
