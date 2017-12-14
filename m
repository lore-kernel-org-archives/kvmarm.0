From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Thu, 14 Dec 2017 14:09:54 +0100
Message-ID: <20171214130954.GV910@cbox>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <20171213091803.GQ910@cbox>
 <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CB640795
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Dec 2017 08:06:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hEkGhxhRNls6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Dec 2017 08:06:28 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE6CE49D5E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Dec 2017 08:06:27 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id f140so11302486wmd.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Dec 2017 05:10:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jia He <hejianet@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jia He <jia.he@hxt-semitech.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 14, 2017 at 12:57:54PM +0800, Jia He wrote:
Hi Jia,

> =

> I have tried your newer level-mapped-v7 branch, but bug is still there.
> =

> There is no special load in both host and guest. The guest (kernel
> 4.14) is often hanging when booting
> =

> the guest kernel log
> =

> [ OK ] Reached target Remote File Systems.
> Starting File System Check on /dev/mapper/fedora-root...
> [ OK ] Started File System Check on /dev/mapper/fedora-root.
> Mounting /sysroot...
> [ 2.670764] SGI XFS with ACLs, security attributes, no debug enabled
> [ 2.678180] XFS (dm-0): Mounting V5 Filesystem
> [ 2.740364] XFS (dm-0): Ending clean mount
> [ OK ] Mounted /sysroot.
> [ OK ] Reached target Initrd Root File System.
> Starting Reload Configuration from the Real Root...
> [ 61.288215] INFO: rcu_sched detected stalls on CPUs/tasks:
> [ 61.290791] 1-...!: (0 ticks this GP) idle=3D574/0/0 softirq=3D5/5 fqs=
=3D1
> [ 61.293664] (detected by 0, t=3D6002 jiffies, g=3D-263, c=3D-264, q=3D39=
760)
> [ 61.296480] Task dump for CPU 1:
> [ 61.297938] swapper/1 R running task 0 0 1 0x00000020
> [ 61.300643] Call trace:
> [ 61.301260] __switch_to+0x6c/0x78
> [ 61.302095] cpu_number+0x0/0x8
> [ 61.302867] rcu_sched kthread starved for 6000 jiffies!
> g18446744073709551353 c18446744073709551352 f0x0 RCU_GP_WAIT_FQS(3)
> ->state=3D0x402 ->cpu=3D1
> [ 61.305941] rcu_sched I 0 8 2 0x00000020
> [ 61.307250] Call trace:
> [ 61.307854] __switch_to+0x6c/0x78
> [ 61.308693] __schedule+0x268/0x8f0
> [ 61.309545] schedule+0x2c/0x88
> [ 61.310325] schedule_timeout+0x84/0x3b8
> [ 61.311278] rcu_gp_kthread+0x4d4/0x7d8
> [ 61.312213] kthread+0x134/0x138
> [ 61.313001] ret_from_fork+0x10/0x1c
> =

> Maybe my previous patch is not perfect enough, thanks for your comments.
> =

> I digged it futher more, do you think below code logic is possibly
> problematic?
> =

> =

> vtimer_save_state=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (vtimer->loaded =3D false=
, cntv_ctl is 0)
> =

> kvm_arch_timer_handler=A0=A0=A0=A0=A0=A0=A0=A0(read cntv_ctl and set vtim=
er->cnt_ctl =3D 0)
> =

> vtimer_restore_state =A0 =A0 =A0 =A0 =A0=A0 (write vtimer->cnt_ctl to cnt=
v_ctl,
> then cntv_ctl will
> =

> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 =A0 =A0 be 0 forever)
> =

> =

> If above analysis is reasonable

Yes, I think there's something there if the hardware doesn't retire the
signal fast enough...

> how about below patch? already
> tested in my arm64 server.
> =

> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index f9555b1..ee6dd3f 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -99,7 +99,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq,
> void *dev_id)
> =A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0 vtimer =3D vcpu_vtimer(vcpu);
> =

> -=A0=A0=A0=A0=A0=A0 if (!vtimer->irq.level) {
> +=A0=A0=A0=A0=A0=A0 if (vtimer->loaded && !vtimer->irq.level) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vtimer->cnt_ctl =3D read_sy=
sreg_el0(cntv_ctl);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (kvm_timer_irq_can_fire(=
vtimer))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kvm=
_timer_update_irq(vcpu, true, vtimer);
> =


There's nothing really wrong with that patch, I just didn't think it
would be necessary, as we really shouldn't see interrupts if the timer
is not loaded.  Can you confirm that a WARN_ON(!vtimer->loaded) in
kvm_arch_timer_handler() gives you a splat?

Also, could you give the following a try (without your patch):

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 73d262c4712b..4751255345d1 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -367,6 +367,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
 =

 	/* Disable the virtual timer */
 	write_sysreg_el0(0, cntv_ctl);
+	isb();
 =

 	vtimer->loaded =3D false;
 out:

Thanks,
-Christoffer
