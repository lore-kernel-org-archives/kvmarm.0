From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] kvm: remove one useless check extension
Date: Tue, 5 May 2015 14:21:54 +0200
Message-ID: <20150505122154.GD19385@cbox>
References: <1430707729-8175-1-git-send-email-tiejun.chen@intel.com>
 <55473AC6.6020206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55473AC6.6020206@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tiejun Chen <tiejun.chen@intel.com>, kvm@vger.kernel.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <Marc.Zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 04, 2015 at 11:24:22AM +0200, Paolo Bonzini wrote:
> 
> 
> On 04/05/2015 04:48, Tiejun Chen wrote:
> > We already check KVM_CAP_IRQFD in generic once enable CONFIG_HAVE_KVM_IRQFD,
> > 
> > kvm_vm_ioctl_check_extension_generic()
> >     |
> >     + switch (arg) {
> >     +   ...
> >     +   #ifdef CONFIG_HAVE_KVM_IRQFD
> >     +       case KVM_CAP_IRQFD:
> >     +   #endif
> >     +   ...
> >     +   return 1;
> >     +   ...
> >     + }
> >     |
> >     + kvm_vm_ioctl_check_extension()
> > 
> > So its not necessary to check this in arch again, and also fix one typo,
> > s/emlation/emulation.
> > 
> > Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
> > ---
> >  arch/arm/kvm/arm.c       | 1 -
> >  include/uapi/linux/kvm.h | 2 +-
> >  2 files changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index d9631ec..483b5d1 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -171,7 +171,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	int r;
> >  	switch (ext) {
> >  	case KVM_CAP_IRQCHIP:
> > -	case KVM_CAP_IRQFD:
> >  	case KVM_CAP_IOEVENTFD:
> >  	case KVM_CAP_DEVICE_CTRL:
> >  	case KVM_CAP_USER_MEMORY:
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 4b60056..2fa7302 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -894,7 +894,7 @@ struct kvm_xen_hvm_config {
> >   *
> >   * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
> >   * the irqfd to operate in resampling mode for level triggered interrupt
> > - * emlation.  See Documentation/virtual/kvm/api.txt.
> > + * emulation.  See Documentation/virtual/kvm/api.txt.
> >   */
> >  #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
> >  
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Christoffer/Marc, please apply to the ARM tree in order to avoid
> pointless conflicts in kvm_vm_ioctl_check_extension.
> 
Applied, thanks.

-Christoffer
