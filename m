Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802273B71C0;
	Thu, 13 Aug 2026 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634960; cv=none; b=ad6cgnzFehoBZQnshXwcxNX2d+XGbRF/ObJ4MHqMxNfggnNpDUYAhJ2ig6nRBiHQ5nO2AHlOPtc/1Vxh/mAersCq85EPfr+rBXa72BjIuIVTJYtO7bcvy6Sk/u+jlD7osoKPN8FbGi/njd6rNTtYo3RoKUXraAVztLiuEJNxahQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634960; c=relaxed/simple;
	bh=XiCbGqpOXXJXofURPwtzJHhcISrABgmJajxK9Ioz9y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4fokn6+lFtoK0Uzi7MpfegXf7XU+RzM60kYDA/fflBSM7PQlgKgJiI958PRfNwvhbWljVtfXnXOz2xHMGlzNz9auOcBKI7rhvw3nibQqp8yE6Zq30MOz8y/+pCCyGqzMk2rK4YcK54JFBcjgDDbiut47tsMLdEX1lYGaC/4HK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wz4RW0h7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wz4RW0h7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECFD31756;
	Thu, 13 Aug 2026 08:29:14 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA5E33F632;
	Thu, 13 Aug 2026 08:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786634958; bh=XiCbGqpOXXJXofURPwtzJHhcISrABgmJajxK9Ioz9y4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wz4RW0h79cKIdIsdDbdMd8NGAcegqk85VdY1+tdw4yN8gzlnr05Af5QUdIpck76X6
	 zeiPKM1/qTYrljz4IWISGzv11YICemYUYPJ+cHWftg4mGDfdsKJeLy8eqrrAWIx1MC
	 Ojrc6+AQac06tJK3Wqj+8qD9p2CTw3puSp/Cy5KE=
Message-ID: <a36e83e2-8f26-4d68-9b5e-756ca8740abf@arm.com>
Date: Thu, 13 Aug 2026 15:38:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 21/45] KVM: arm64: CCA: Handle realm enter/exit
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-22-steven.price@arm.com>
 <anl7EwU9jSig-uQs@FCCLS0092175.localdomain>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <anl7EwU9jSig-uQs@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/08/2026 09:03, Kohei Enju wrote:
> On 08/03 14:43, Steven Price wrote:
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
> 
> Hi Steven,
> 
> I found that when the host kernel is booting with pseudo-NMI enabled
> (irqchip.gicv3_pseudo_nmi=1), Realm VMs fail boot successfully and the
> watchdog reports RCU stalls and soft lockups.
> 
> After some investigations, I confirmed that arch_timer interrupts
> are not being delivered to some CPUs. This appears to be because PMR is
> 000000c0 (GICV3_PRIO_IRQ), as shown below:
> 
>   [  248.769692] pmr: 000000c0
> 
> For normal VMs, KVM opens PMR before entering the guest, because having
> IRQs masked via PMR when entering the guest means the GIC will not
> signal the CPU of interrupts of lower priority, and in the worst case
> a guest exit may never occur.
> (See __kvm_vcpu_run in arch/arm64/kvm/hyp/vhe/switch.c)
> 
> [  248.756980] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  248.758649] rcu:     3-...0: (113 ticks this GP) idle=d2ec/1/0x4000000000000000 softirq=1631/1633 fqs=297
> [  248.759413] rcu:     4-...0: (7 ticks this GP) idle=b77c/1/0x4000000000000000 softirq=1589/1589 fqs=297
> [  248.760101] rcu:     (detected by 7, t=6003 jiffies, g=4553, q=86 ncpus=8)
> [  248.760731] Sending NMI from CPU 7 to CPUs 3:
> [  248.766814] NMI backtrace for cpu 3
> [  248.768285] CPU: 3 UID: 0 PID: 387 Comm: kvm-vcpu-0 Not tainted 7.2.0-rc2-00267-g7326f0114689 #238 PREEMPT(lazy)
> [  248.768681] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 02/02/2022
> [  248.768936] pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [  248.769021] pc : kvm_rec_enter+0xa0/0xb8
> [  248.769585] lr : kvm_rec_enter+0x24/0xb8
> [  248.769655] sp : ffff800084943830
> [  248.769692] pmr: 000000c0
> [  248.769757] x29: ffff800084943830 x28: ffff0000079c6c00 x27: 0000000000000000
> [  248.770441] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> [  248.770536] x23: 0000000080000000 x22: 0000000000000001 x21: 0000000049d99000
> [  248.770590] x20: 0000000049d9a000 x19: ffff00000e018000 x18: 0000000000000000
> [  248.770647] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> [  248.770756] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> [  248.770863] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff8000812ab1bc
> [  248.771018] x8 : 0000000000000000 x7 : 0000000000000020 x6 : 0000000000000080
> [  248.771123] x5 : 0000000000000004 x4 : 0000000000000040 x3 : 0000000000000000
> [  248.771172] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> [  248.771385] Call trace:
> [  248.771612]  kvm_rec_enter+0xa0/0xb8 (P)
> [  248.771757]  kvm_arm_vcpu_enter_exit+0x8c/0x218
> [  248.771796]  kvm_arch_vcpu_ioctl_run+0x274/0x890
> [  248.771843]  kvm_vcpu_ioctl+0x180/0xb50
> [  248.771883]  __arm64_sys_ioctl+0xb4/0x118
> [  248.771920]  invoke_syscall.constprop.0+0xb8/0x120
> [  248.771954]  do_el0_svc+0x48/0xc8
> [  248.771982]  el0_svc+0x48/0x280
> [  248.772012]  el0t_64_sync_handler+0xa0/0xe8
> [  248.772041]  el0t_64_sync+0x1ac/0x1b0
> [...]
> 
>> [...]
>> +int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	int ret;
>> +
>> +	ret = rmi_rec_enter(rec->rec_phys, rec->run_phys);
>> +	if (!ret)
>> +		load_realm_timer_state(vcpu);
>> +
>> +	return ret;
>> +}
> 
> In my testing environment, adding local_daif_mask/restore() in line with
> __kvm_vcpu_run() fixes the issue, and Realm VMs successfully boot
> without RCU stalls or soft lockups.

Hi Kohei,

Thanks for the detailed investigation.

> However, I'm not sure if we can safely call local_daif_mask/restore()
> here, bacause they call trace_hardirqs_off/on(), which presumably cannot
> be called from noinstr context.
> 
> For reference, the VHE hyp path seems to call local_daif_mask/restore()
> from noinstr context, but I'm not sure why this is considered safe:
>   noinstr kvm_arm_vcpu_enter_exit()
>     kvm_call_hyp_ret(__kvm_vcpu_run, vcpu) <- normal function call for VHE
>       local_daif_mask()
>         trace_hardirqs_off()
>       local_daif_restore()
>         trace_hardirqs_off/on()

Yes I'm not sure if there's an existing VHE bug there. But it's only if
CONFIG_TRACE_IRQFLAGS is enabled, so perhaps no-one has noticed?

> The following change works in my test environment.
> Any thoughts on the issue and the proposed fix?

Your proposed fix looks like it matches the VHE behaviour, so I'll go
for that. If there's an existing VHE bug then hopefully the below will
work after the fix for that too.

Thanks,
Steve

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index c242dfc2c7a6..dd7cb2d7db88 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -1307,7 +1307,13 @@ int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
>         struct realm_rec *rec = &vcpu->arch.rec;
>         int ret;
> 
> +       local_daif_mask();
> +       pmr_sync();
> +
>         ret = rmi_rec_enter(rec->rec_phys, rec->run_phys);
> +
> +       local_daif_restore(DAIF_PROCCTX_NOIRQ);
> +
>         if (!ret)
>                 load_realm_timer_state(vcpu);
> 
> Thanks,
> Kohei

