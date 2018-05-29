From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: no need to check return value of debugfs_create
 functions
Date: Tue, 29 May 2018 19:06:25 +0200
Message-ID: <46079df1-2ebf-7ddb-582a-9f644a7802a0@redhat.com>
References: <20180529162204.11757-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529162204.11757-1-gregkh@linuxfoundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Cc: Paul Mackerras <paulus@ozlabs.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Michael Ellerman <mpe@ellerman.id.au>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arvind Yadav <arvind.yadav.cs@gmail.com>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 29/05/2018 18:22, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> This cleans up the error handling a lot, as this code will never get
> hit.
> 
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: kvm@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/powerpc/kvm/book3s_hv.c   |  3 +--
>  virt/kvm/arm/vgic/vgic-debug.c | 17 ++++-----------
>  virt/kvm/arm/vgic/vgic.h       |  4 ++--
>  virt/kvm/kvm_main.c            | 40 +++++++---------------------------
>  4 files changed, 15 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 4d07fca5121c..67d7de1470cc 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3950,8 +3950,7 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
>  	 */
>  	snprintf(buf, sizeof(buf), "vm%d", current->pid);
>  	kvm->arch.debugfs_dir = debugfs_create_dir(buf, kvm_debugfs_dir);
> -	if (!IS_ERR_OR_NULL(kvm->arch.debugfs_dir))
> -		kvmppc_mmu_debugfs_init(kvm);
> +	kvmppc_mmu_debugfs_init(kvm);
>  
>  	return 0;
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> index 10b38178cff2..0140b29079b6 100644
> --- a/virt/kvm/arm/vgic/vgic-debug.c
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -263,21 +263,12 @@ static const struct file_operations vgic_debug_fops = {
>  	.release = seq_release
>  };
>  
> -int vgic_debug_init(struct kvm *kvm)
> +void vgic_debug_init(struct kvm *kvm)
>  {
> -	if (!kvm->debugfs_dentry)
> -		return -ENOENT;
> -
> -	if (!debugfs_create_file("vgic-state", 0444,
> -				 kvm->debugfs_dentry,
> -				 kvm,
> -				 &vgic_debug_fops))
> -		return -ENOMEM;
> -
> -	return 0;
> +	debugfs_create_file("vgic-state", 0444, kvm->debugfs_dentry, kvm,
> +			    &vgic_debug_fops);
>  }
>  
> -int vgic_debug_destroy(struct kvm *kvm)
> +void vgic_debug_destroy(struct kvm *kvm)
>  {
> -	return 0;
>  }
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 830e815748a0..3c38c5349953 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -229,8 +229,8 @@ void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  int vgic_lazy_init(struct kvm *kvm);
>  int vgic_init(struct kvm *kvm);
>  
> -int vgic_debug_init(struct kvm *kvm);
> -int vgic_debug_destroy(struct kvm *kvm);
> +void vgic_debug_init(struct kvm *kvm);
> +void vgic_debug_destroy(struct kvm *kvm);
>  
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c7b2e927f699..0ad400f353fc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -572,10 +572,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  		return 0;
>  
>  	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
> -	kvm->debugfs_dentry = debugfs_create_dir(dir_name,
> -						 kvm_debugfs_dir);
> -	if (!kvm->debugfs_dentry)
> -		return -ENOMEM;
> +	kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
>  
>  	kvm->debugfs_stat_data = kcalloc(kvm_debugfs_num_entries,
>  					 sizeof(*kvm->debugfs_stat_data),
> @@ -591,11 +588,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  		stat_data->kvm = kvm;
>  		stat_data->offset = p->offset;
>  		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
> -		if (!debugfs_create_file(p->name, 0644,
> -					 kvm->debugfs_dentry,
> -					 stat_data,
> -					 stat_fops_per_vm[p->kind]))
> -			return -ENOMEM;
> +		debugfs_create_file(p->name, 0644, kvm->debugfs_dentry,
> +				    stat_data, stat_fops_per_vm[p->kind]);
>  	}
>  	return 0;
>  }
> @@ -3896,29 +3890,18 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
>  	kfree(env);
>  }
>  
> -static int kvm_init_debug(void)
> +static void kvm_init_debug(void)
>  {
> -	int r = -EEXIST;
>  	struct kvm_stats_debugfs_item *p;
>  
>  	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
> -	if (kvm_debugfs_dir == NULL)
> -		goto out;
>  
>  	kvm_debugfs_num_entries = 0;
>  	for (p = debugfs_entries; p->name; ++p, kvm_debugfs_num_entries++) {
> -		if (!debugfs_create_file(p->name, 0644, kvm_debugfs_dir,
> -					 (void *)(long)p->offset,
> -					 stat_fops[p->kind]))
> -			goto out_dir;
> +		debugfs_create_file(p->name, 0644, kvm_debugfs_dir,
> +				    (void *)(long)p->offset,
> +				    stat_fops[p->kind]);
>  	}
> -
> -	return 0;
> -
> -out_dir:
> -	debugfs_remove_recursive(kvm_debugfs_dir);
> -out:
> -	return r;
>  }
>  
>  static int kvm_suspend(void)
> @@ -4046,20 +4029,13 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	kvm_preempt_ops.sched_in = kvm_sched_in;
>  	kvm_preempt_ops.sched_out = kvm_sched_out;
>  
> -	r = kvm_init_debug();
> -	if (r) {
> -		pr_err("kvm: create debugfs files failed\n");
> -		goto out_undebugfs;
> -	}
> +	kvm_init_debug();
>  
>  	r = kvm_vfio_ops_init();
>  	WARN_ON(r);
>  
>  	return 0;
>  
> -out_undebugfs:
> -	unregister_syscore_ops(&kvm_syscore_ops);
> -	misc_deregister(&kvm_dev);
>  out_unreg:
>  	kvm_async_pf_deinit();
>  out_free:
> 

Queued, thanks.

Paolo
