From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/2] KVM: Enforce error in ioctl for compat tasks when
 !KVM_COMPAT
Date: Tue, 19 Jun 2018 11:01:35 +0100
Message-ID: <20180619100134.4loab4jtnfdzrpxu@lakrids.cambridge.arm.com>
References: <20180619094251.8586-1-marc.zyngier@arm.com>
 <20180619094251.8586-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180619094251.8586-2-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 19, 2018 at 10:42:50AM +0100, Marc Zyngier wrote:
> The current behaviour of the compat ioctls is a bit odd.
> We provide a compat_ioctl method when KVM_COMPAT is set, and NULL
> otherwise. But NULL means that the normal, non-compat ioctl should
> be used directly for compat tasks, and there is no way to actually
> prevent a compat task from issueing KVM ioctls.
> 
> This patch changes this behaviour, by always registering a compat_ioctl
> method, even if KVM_COMPAT is not selected. In that case, the callback
> will always return -EINVAL.
> 
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

I virt/kvm/Kconfig we have:

config KVM_COMPAT
       def_bool y
       depends on KVM && COMPAT && !S390

... and in arch/s390 we have COMPAT support, so does this potentially break
anything there?

Thanks,
Mark.

> ---
>  virt/kvm/kvm_main.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ada21f47f22b..8b47507faab5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -116,6 +116,11 @@ static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
>  #ifdef CONFIG_KVM_COMPAT
>  static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
>  				  unsigned long arg);
> +#define KVM_COMPAT(c)	.compat_ioctl	= (c)
> +#else
> +static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
> +				unsigned long arg) { return -EINVAL; }
> +#define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl
>  #endif
>  static int hardware_enable_all(void);
>  static void hardware_disable_all(void);
> @@ -2396,11 +2401,9 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
>  static struct file_operations kvm_vcpu_fops = {
>  	.release        = kvm_vcpu_release,
>  	.unlocked_ioctl = kvm_vcpu_ioctl,
> -#ifdef CONFIG_KVM_COMPAT
> -	.compat_ioctl   = kvm_vcpu_compat_ioctl,
> -#endif
>  	.mmap           = kvm_vcpu_mmap,
>  	.llseek		= noop_llseek,
> +	KVM_COMPAT(kvm_vcpu_compat_ioctl),
>  };
>  
>  /*
> @@ -2824,10 +2827,8 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
>  
>  static const struct file_operations kvm_device_fops = {
>  	.unlocked_ioctl = kvm_device_ioctl,
> -#ifdef CONFIG_KVM_COMPAT
> -	.compat_ioctl = kvm_device_ioctl,
> -#endif
>  	.release = kvm_device_release,
> +	KVM_COMPAT(kvm_device_ioctl),
>  };
>  
>  struct kvm_device *kvm_device_from_filp(struct file *filp)
> @@ -3165,10 +3166,8 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>  static struct file_operations kvm_vm_fops = {
>  	.release        = kvm_vm_release,
>  	.unlocked_ioctl = kvm_vm_ioctl,
> -#ifdef CONFIG_KVM_COMPAT
> -	.compat_ioctl   = kvm_vm_compat_ioctl,
> -#endif
>  	.llseek		= noop_llseek,
> +	KVM_COMPAT(kvm_vm_compat_ioctl),
>  };
>  
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
> @@ -3259,8 +3258,8 @@ static long kvm_dev_ioctl(struct file *filp,
>  
>  static struct file_operations kvm_chardev_ops = {
>  	.unlocked_ioctl = kvm_dev_ioctl,
> -	.compat_ioctl   = kvm_dev_ioctl,
>  	.llseek		= noop_llseek,
> +	KVM_COMPAT(kvm_dev_ioctl),
>  };
>  
>  static struct miscdevice kvm_dev = {
> -- 
> 2.17.1
> 
