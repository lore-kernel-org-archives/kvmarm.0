Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B133839B7;
	Mon, 10 Aug 2026 08:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786349072; cv=none; b=hIHBUKGmMuY+uTFk2hugxYIyanDrmeQpA+WJuIhE1MYFd4u0PnvoxiwtREyYEC3+yz+3bhI4CXVui0+qnkANbhlEuCqp9sn0VZYBiD1qBJoPu1QEU3IYYJzLqcTIFDR9VkUxM/rzyQ0VQd2qwws58Wzd53XMkygiS1y8NdOFg3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786349072; c=relaxed/simple;
	bh=gTCgRTRbO71RhS/662ipRYrMCfFYH4BSpUcquX2qvVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X33KF93roiuyaLJ4yo5AdB/8DjLGYaWXQVqaXtvwmme6fSfsSFhK9FX6eoQin9kXURnPWN0XKoJhOMrseFBroUOiOrD6jgQm2CFh8DXROKWVmWd3il1HTQaPER7/iZ3t2PSZGEEpLm+iQlP25xyoTmvKIwvx3J6+bsblkg0a7Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=oZTLp60V; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="oZTLp60V"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1786349073; x=1817885073;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gTCgRTRbO71RhS/662ipRYrMCfFYH4BSpUcquX2qvVg=;
  b=oZTLp60V+oXGhQVWdqfUN/Wcel/QrCe5PSXlaDYfGjq7v/3jw6EbMFkM
   APvgwTkCUrgjgmq4lx0cIfo0dYvqzoCUzLG6ZttTsr6Dn+dxZMn0BjXF6
   y+wQhlQeagbg2LMWJDoQpKzckBVkuHMK7AIbewZRh7zm2w3Bl1wiTLlK5
   CMoqNsJ3lUm5tI4c3fqOlA7bDqA5xhSYw24PcSWnEd/pTt3RVZNLVbvim
   b1zdQgQfQ0kT1+X+N2pTEHl8wmB71EyU9LA6N6PupgA0miDG6G1i3ugXy
   o2R8+1ObwyOZ5us7nz7s2nRSXYvmwW4MfmBate/6t9P2o1b5CA0ymkdZg
   w==;
X-CSE-ConnectionGUID: mhNIlaUyRFyJwjKkmsDhbQ==
X-CSE-MsgGUID: F8p7n6I+R0+TTuJli0zMsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="229293335"
X-IronPort-AV: E=Sophos;i="6.25,215,1779116400"; 
   d="scan'208";a="229293335"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 17:03:21 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 85D37C00416;
	Mon, 10 Aug 2026 08:03:18 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (unknown [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 3B66FC17089;
	Mon, 10 Aug 2026 08:03:18 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.69.80])
	by az2nlsmom4.fujitsu.com (Postfix) with SMTP id 3776520000EC;
	Mon, 10 Aug 2026 08:03:09 +0000 (UTC)
Date: Mon, 10 Aug 2026 17:03:02 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 21/45] KVM: arm64: CCA: Handle realm enter/exit
Message-ID: <anl7EwU9jSig-uQs@FCCLS0092175.localdomain>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-22-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260803134403.80630-22-steven.price@arm.com>

On 08/03 14:43, Steven Price wrote:
> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.

Hi Steven,

I found that when the host kernel is booting with pseudo-NMI enabled
(irqchip.gicv3_pseudo_nmi=1), Realm VMs fail boot successfully and the
watchdog reports RCU stalls and soft lockups.

After some investigations, I confirmed that arch_timer interrupts
are not being delivered to some CPUs. This appears to be because PMR is
000000c0 (GICV3_PRIO_IRQ), as shown below:

  [  248.769692] pmr: 000000c0

For normal VMs, KVM opens PMR before entering the guest, because having
IRQs masked via PMR when entering the guest means the GIC will not
signal the CPU of interrupts of lower priority, and in the worst case
a guest exit may never occur.
(See __kvm_vcpu_run in arch/arm64/kvm/hyp/vhe/switch.c)

[  248.756980] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  248.758649] rcu:     3-...0: (113 ticks this GP) idle=d2ec/1/0x4000000000000000 softirq=1631/1633 fqs=297
[  248.759413] rcu:     4-...0: (7 ticks this GP) idle=b77c/1/0x4000000000000000 softirq=1589/1589 fqs=297
[  248.760101] rcu:     (detected by 7, t=6003 jiffies, g=4553, q=86 ncpus=8)
[  248.760731] Sending NMI from CPU 7 to CPUs 3:
[  248.766814] NMI backtrace for cpu 3
[  248.768285] CPU: 3 UID: 0 PID: 387 Comm: kvm-vcpu-0 Not tainted 7.2.0-rc2-00267-g7326f0114689 #238 PREEMPT(lazy)
[  248.768681] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 02/02/2022
[  248.768936] pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[  248.769021] pc : kvm_rec_enter+0xa0/0xb8
[  248.769585] lr : kvm_rec_enter+0x24/0xb8
[  248.769655] sp : ffff800084943830
[  248.769692] pmr: 000000c0
[  248.769757] x29: ffff800084943830 x28: ffff0000079c6c00 x27: 0000000000000000
[  248.770441] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[  248.770536] x23: 0000000080000000 x22: 0000000000000001 x21: 0000000049d99000
[  248.770590] x20: 0000000049d9a000 x19: ffff00000e018000 x18: 0000000000000000
[  248.770647] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[  248.770756] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  248.770863] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff8000812ab1bc
[  248.771018] x8 : 0000000000000000 x7 : 0000000000000020 x6 : 0000000000000080
[  248.771123] x5 : 0000000000000004 x4 : 0000000000000040 x3 : 0000000000000000
[  248.771172] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
[  248.771385] Call trace:
[  248.771612]  kvm_rec_enter+0xa0/0xb8 (P)
[  248.771757]  kvm_arm_vcpu_enter_exit+0x8c/0x218
[  248.771796]  kvm_arch_vcpu_ioctl_run+0x274/0x890
[  248.771843]  kvm_vcpu_ioctl+0x180/0xb50
[  248.771883]  __arm64_sys_ioctl+0xb4/0x118
[  248.771920]  invoke_syscall.constprop.0+0xb8/0x120
[  248.771954]  do_el0_svc+0x48/0xc8
[  248.771982]  el0_svc+0x48/0x280
[  248.772012]  el0t_64_sync_handler+0xa0/0xe8
[  248.772041]  el0t_64_sync+0x1ac/0x1b0
[...]

> [...]
> +int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	int ret;
> +
> +	ret = rmi_rec_enter(rec->rec_phys, rec->run_phys);
> +	if (!ret)
> +		load_realm_timer_state(vcpu);
> +
> +	return ret;
> +}

In my testing environment, adding local_daif_mask/restore() in line with
__kvm_vcpu_run() fixes the issue, and Realm VMs successfully boot
without RCU stalls or soft lockups.

However, I'm not sure if we can safely call local_daif_mask/restore()
here, bacause they call trace_hardirqs_off/on(), which presumably cannot
be called from noinstr context.

For reference, the VHE hyp path seems to call local_daif_mask/restore()
from noinstr context, but I'm not sure why this is considered safe:
  noinstr kvm_arm_vcpu_enter_exit()
    kvm_call_hyp_ret(__kvm_vcpu_run, vcpu) <- normal function call for VHE
      local_daif_mask()
        trace_hardirqs_off()
      local_daif_restore()
        trace_hardirqs_off/on()

The following change works in my test environment.
Any thoughts on the issue and the proposed fix?

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index c242dfc2c7a6..dd7cb2d7db88 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1307,7 +1307,13 @@ int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
        struct realm_rec *rec = &vcpu->arch.rec;
        int ret;

+       local_daif_mask();
+       pmr_sync();
+
        ret = rmi_rec_enter(rec->rec_phys, rec->run_phys);
+
+       local_daif_restore(DAIF_PROCCTX_NOIRQ);
+
        if (!ret)
                load_realm_timer_state(vcpu);

Thanks,
Kohei
