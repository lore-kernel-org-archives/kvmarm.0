From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Remove deprecated create_singlethread_workqueue
Date: Thu, 1 Sep 2016 17:37:30 +0200
Message-ID: <7249cf28-93db-0d7b-1492-7e0ebd3fec54@redhat.com>
References: <20160830175950.GA5958@Karyakshetra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7kVrwQ73302nUuCpsBmOXsHsCXKEujW99"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160830175950.GA5958@Karyakshetra>
Sender: kvm-owner@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7kVrwQ73302nUuCpsBmOXsHsCXKEujW99
Content-Type: multipart/mixed; boundary="BQP23ePBSVptRNuVDvBh1na4PefUQMHoG";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
 Christoffer Dall <christoffer.dall@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Message-ID: <7249cf28-93db-0d7b-1492-7e0ebd3fec54@redhat.com>
Subject: Re: [PATCH] KVM: Remove deprecated create_singlethread_workqueue
References: <20160830175950.GA5958@Karyakshetra>
In-Reply-To: <20160830175950.GA5958@Karyakshetra>

--BQP23ePBSVptRNuVDvBh1na4PefUQMHoG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 30/08/2016 19:59, Bhaktipriya Shridhar wrote:
> The workqueue "irqfd_cleanup_wq" queues a single work item
> &irqfd->shutdown and hence doesn't require ordering. It is a host-wide
> workqueue for issuing deferred shutdown requests aggregated from all
> vm* instances. It is not being used on a memory reclaim path.
> Hence, it has been converted to use system_wq.
> The work item has been flushed in kvm_irqfd_release().
>=20
> The workqueue "wqueue" queues a single work item &timer->expired
> and hence doesn't require ordering. Also, it is not being used on
> a memory reclaim path. Hence, it has been converted to use system_wq.
>=20
> System workqueues have been able to handle high level of concurrency
> for a long time now and hence it's not required to have a singlethreade=
d
> workqueue just to gain concurrency. Unlike a dedicated per-cpu workqueu=
e
> created with create_singlethread_workqueue(), system_wq allows multiple=

> work items to overlap executions even on the same CPU; however, a
> per-cpu workqueue doesn't have any CPU locality or global ordering
> guarantee unless the target CPU is explicitly specified and thus the
> increase of local concurrency shouldn't make any difference.
>=20
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> ---
>  virt/kvm/arm/arch_timer.c | 11 ++---------
>  virt/kvm/eventfd.c        | 22 +++-------------------
>  virt/kvm/kvm_main.c       |  6 ------
>  3 files changed, 5 insertions(+), 34 deletions(-)
>=20
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index e2d5b6f..56e0c15 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -31,7 +31,6 @@
>  #include "trace.h"
>=20
>  static struct timecounter *timecounter;
> -static struct workqueue_struct *wqueue;
>  static unsigned int host_vtimer_irq;
>=20
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -140,7 +139,7 @@ static enum hrtimer_restart kvm_timer_expire(struct=
 hrtimer *hrt)
>  		return HRTIMER_RESTART;
>  	}
>=20
> -	queue_work(wqueue, &timer->expired);
> +	schedule_work(&timer->expired);
>  	return HRTIMER_NORESTART;
>  }
>=20
> @@ -455,12 +454,6 @@ int kvm_timer_hyp_init(void)
>  		goto out_free;
>  	}
>=20
> -	wqueue =3D create_singlethread_workqueue("kvm_arch_timer");
> -	if (!wqueue) {
> -		err =3D -ENOMEM;
> -		goto out_free;
> -	}
> -
>  	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
>  	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
>=20
> @@ -522,7 +515,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	 * VCPUs have the enabled variable set, before entering the guest, if=

>  	 * the arch timers are enabled.
>  	 */
> -	if (timecounter && wqueue)
> +	if (timecounter)
>  		timer->enabled =3D 1;
>=20
>  	return 0;
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index e469b60..f397e9b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -42,7 +42,6 @@
>=20
>  #ifdef CONFIG_HAVE_KVM_IRQFD
>=20
> -static struct workqueue_struct *irqfd_cleanup_wq;
>=20
>  static void
>  irqfd_inject(struct work_struct *work)
> @@ -168,7 +167,7 @@ irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
>=20
>  	list_del_init(&irqfd->list);
>=20
> -	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
> +	schedule_work(&irqfd->shutdown);
>  }
>=20
>  int __attribute__((weak)) kvm_arch_set_irq_inatomic(
> @@ -555,7 +554,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqf=
d *args)
>  	 * so that we guarantee there will not be any more interrupts on this=

>  	 * gsi once this deassign function returns.
>  	 */
> -	flush_workqueue(irqfd_cleanup_wq);
> +	flush_work(&irqfd->shutdown);
>=20
>  	return 0;
>  }
> @@ -592,7 +591,7 @@ kvm_irqfd_release(struct kvm *kvm)
>  	 * Block until we know all outstanding shutdown jobs have completed
>  	 * since we do not take a kvm* reference.
>  	 */
> -	flush_workqueue(irqfd_cleanup_wq);
> +	flush_work(&irqfd->shutdown);
>=20
>  }
>=20
> @@ -622,23 +621,8 @@ void kvm_irq_routing_update(struct kvm *kvm)
>  	spin_unlock_irq(&kvm->irqfds.lock);
>  }
>=20
> -/*
> - * create a host-wide workqueue for issuing deferred shutdown requests=

> - * aggregated from all vm* instances. We need our own isolated single-=
thread
> - * queue to prevent deadlock against flushing the normal work-queue.
> - */
> -int kvm_irqfd_init(void)
> -{
> -	irqfd_cleanup_wq =3D create_singlethread_workqueue("kvm-irqfd-cleanup=
");
> -	if (!irqfd_cleanup_wq)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> -
>  void kvm_irqfd_exit(void)
>  {
> -	destroy_workqueue(irqfd_cleanup_wq);
>  }
>  #endif
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 02e98f3..93506d2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3719,12 +3719,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, u=
nsigned vcpu_align,
>  	 * kvm_arch_init makes sure there's at most one caller
>  	 * for architectures that support multiple implementations,
>  	 * like intel and amd on x86.
> -	 * kvm_arch_init must be called before kvm_irqfd_init to avoid creati=
ng
> -	 * conflicts in case kvm is already setup for another implementation.=

>  	 */
> -	r =3D kvm_irqfd_init();
> -	if (r)
> -		goto out_irqfd;
>=20
>  	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
>  		r =3D -ENOMEM;
> @@ -3805,7 +3800,6 @@ out_free_0a:
>  	free_cpumask_var(cpus_hardware_enabled);
>  out_free_0:
>  	kvm_irqfd_exit();
> -out_irqfd:
>  	kvm_arch_exit();
>  out_fail:
>  	return r;
> --
> 2.1.4
>=20

Rebased (the virt/kvm/arm part doesn't apply anymore due to the CPU
notifier refactoring) and applied, thanks.

Paolo


--BQP23ePBSVptRNuVDvBh1na4PefUQMHoG--

--7kVrwQ73302nUuCpsBmOXsHsCXKEujW99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXyEs+AAoJEL/70l94x66DETYIAIg4MJ9DIFht/BSVORQOtJ3f
cdCZXhvwhqCKSH6XWQgrizVxIc+YmoyGGlo5ICMQzujt/LX/xy5aN2YmzODJYZyI
zRPiGN77iF4BSOfJ+xfWGKIN2v6Yii8yZCioq7vw2Z2ylr/8zL0EShmQ8IIrEB98
EyhKVs6RD03DHtKaJOmfu0ovmnCmQu5UnwOjAgGGgUPfYFcuACZy+CJgBd3sBn68
4Bay53pek4FAKZFTDc9zapkxMT0hgWJniS0O/jxhZm8Pos9qaPFJt4yNFAvZHIr9
ZPu0gJDuEIUy292N184Njn25HHupL7KkANAnFQ2F8MEmbFOmaAILEcaoe6m6zlI=
=qoZE
-----END PGP SIGNATURE-----

--7kVrwQ73302nUuCpsBmOXsHsCXKEujW99--
