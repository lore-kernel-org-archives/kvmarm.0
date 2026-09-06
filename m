Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2C63BBFD0
	for <kvmarm@lists.linux.dev>; Sun,  6 Sep 2026 17:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788714857; cv=none; b=ZKsuRbbh95TMF9WXgLskAn4ioEWCdojYizMROuy58dUGtkc3NnDhryhECo9opcPN3DI8Gtr54Jx/00GvX2cMZ95ISdYGWhF3SZvgd1ARjAApCfU7C9fCy88VVgTf3CiUuhDJK6iD689jEq9CL9JuDXfUqgpSf5OjzfGzjbQlzwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788714857; c=relaxed/simple;
	bh=kv66z7JV1166ueZMCWhYRrYKaMpcvrBriXgBRYKc+CA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GcUxkca3VUl6ngIqhTZtUUieQ2xUkGv6/SCj8QQyojp5VojncsfQSMEyD8nbR6O87BLHpXpw0Wy99sA+kVpIItNjlLja6ihB+qN59X2iEcOyC65yYoyF6Qxuvd9jxgxbE32u6i4a9L93GbM5tPU0Zvruxt0tO299IQVQZJkv6Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S57Iv8Dm; arc=none smtp.client-ip=91.218.175.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S57Iv8Dm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kv66z7JV1166ueZMCWhYRrYKaMpcvrBriXgBRYKc+CA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788714853; v=1; x=1789319653;
 b=S57Iv8Dm+4mNlrjcjDmYuuHUiIyA+rBANGQ3JuCkp94Nvc7K3weRIaXCcyfoMh9lxycXB4Yu
 L4R4e6EIMYItXksqoZnf7sfG+aPwW0VTFjtCDGbZCQl9ujWBb0lnR1glHwPbiXRrGhQCyTIc/El
 IUYdAUxxC6FqqwR8MhG+HFKc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 58d9e5cdf729346f;
	Sun, 06 Sep 2026 17:14:13 +0000
X-Mizu-Trace-ID: 58d9e5cdf729346f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so4102e87.1
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 10:14:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzPSVmhVmI+edy6pC3qy1Og7ZNciTEeYsKZiWeFVs55bCKiUCUfIob+QZpy/ZQumsvngPZgivo=@lists.linux.dev
X-Gm-Message-State: AFuF++m9Wz94hPo3hFXeqc1pql+WY9XEqFLiA3fU+qSkcd2/JJ5NQgeD
	T2GQ8zYhYFxz9wQa5uXN/yxA2V2cjtndjcKRg7FvPLFBK9Z8IWYYvFSmLlIZcN0mXOkPinI5vsa
	lgyy1klWaQgdD0IDIzgjcx5wG1KLpzDXFyzwrLUwn
X-Received: by 2002:a05:6512:4053:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b74d007331mr84965e87.0.1788714848215; Sun, 06 Sep 2026
 10:14:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904175550.430266-1-dongli.zhang@oracle.com> <20260904175550.430266-2-dongli.zhang@oracle.com>
In-Reply-To: <20260904175550.430266-2-dongli.zhang@oracle.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 6 Sep 2026 18:13:32 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwMwZCNZRAhve9EVfU30axNZYBbUzE91hv23miGXvscEQ@mail.gmail.com>
X-Gm-Features: AcwNN1XZMT9sy0kcFj7bH_1dkmMWQvLE6JZKEq9JPm5SZfVcw9Kc1Kv5uV3TAXQ
Message-ID: <CA+EHjTwMwZCNZRAhve9EVfU30axNZYBbUzE91hv23miGXvscEQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: Move last_steal to common struct kvm_vcpu
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhaotianrui@loongson.cn, 
	maobibo@loongson.cn, chenhuacai@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, dwmw2@infradead.org, joe.jin@oracle.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Sept 2026 at 18:56, Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
> KVM caches per-vCPU host task's run_delay in per-architecture struct
> kvm_vcpu_arch at last_steal.
>
> Move the cache to struct kvm_vcpu and convert x86, arm64, riscv, and
> loongarch to use the common field.
>
> Add HAVE_KVM_PV_STEAL_TIME so last_steal is used only for architectures
> that implement KVM stealtime.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Marc suggested reusing CONFIG_HAVE_PV_STEAL_CLOCK_GEN, but I introduced
> HAVE_KVM_PV_STEAL_TIME instead.

FWIW, I think HAVE_KVM_PV_STEAL_TIME is the right choice here, since
it's about what KVM itself supports. HAVE_PV_STEAL_CLOCK_GEN is the
guest-side paravirt_steal_clock() config, so a KVM-side symbol fits
the host field better.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> As I have access to only x86 and arm64 KVM hosts, I created and validated
> the selftest on those two architectures only.
>
>  arch/arm64/include/asm/kvm_host.h     |  1 -
>  arch/arm64/kvm/Kconfig                |  1 +
>  arch/arm64/kvm/pvtime.c               |  8 ++++----
>  arch/loongarch/include/asm/kvm_host.h |  1 -
>  arch/loongarch/kvm/Kconfig            |  1 +
>  arch/loongarch/kvm/exit.c             |  2 +-
>  arch/loongarch/kvm/vcpu.c             |  6 +++---
>  arch/riscv/include/asm/kvm_host.h     |  1 -
>  arch/riscv/kvm/Kconfig                |  1 +
>  arch/riscv/kvm/vcpu_sbi_sta.c         | 10 +++++-----
>  arch/x86/include/asm/kvm_host.h       |  1 -
>  arch/x86/kvm/Kconfig                  |  1 +
>  arch/x86/kvm/x86.c                    |  5 ++---
>  include/linux/kvm_host.h              |  4 ++++
>  virt/kvm/Kconfig                      |  3 +++
>  15 files changed, 26 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7..36cb7dee988c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -937,7 +937,6 @@ struct kvm_vcpu_arch {
>
>         /* Guest PV state */
>         struct {
> -               u64 last_steal;
>                 gpa_t base;
>         } steal;
>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 449154f9a485..f5855bfc681c 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -34,6 +34,7 @@ menuconfig KVM
>         select HAVE_KVM_IRQ_BYPASS
>         select HAVE_KVM_READONLY_MEM
>         select HAVE_KVM_VCPU_RUN_PID_CHANGE
> +       select HAVE_KVM_PV_STEAL_TIME
>         select SCHED_INFO
>         select GUEST_PERF_EVENTS if PERF_EVENTS
>         select KVM_GUEST_MEMFD
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index 4ceabaa4c30b..a67d93845d79 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -14,7 +14,7 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>  {
>         struct kvm *kvm = vcpu->kvm;
>         u64 base = vcpu->arch.steal.base;
> -       u64 last_steal = vcpu->arch.steal.last_steal;
> +       u64 last_steal = vcpu->last_steal;
>         u64 offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
>         u64 steal = 0;
>         int idx;
> @@ -25,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>         idx = srcu_read_lock(&kvm->srcu);
>         if (!kvm_get_guest(kvm, base + offset, steal)) {
>                 steal = le64_to_cpu(steal);
> -               vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
> -               steal += vcpu->arch.steal.last_steal - last_steal;
> +               vcpu->last_steal = READ_ONCE(current->sched_info.run_delay);
> +               steal += vcpu->last_steal - last_steal;
>                 kvm_put_guest(kvm, base + offset, cpu_to_le64(steal));
>         }
>         srcu_read_unlock(&kvm->srcu, idx);
> @@ -61,7 +61,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>          * Start counting stolen time from the time the guest requests
>          * the feature enabled.
>          */
> -       vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> +       vcpu->last_steal = current->sched_info.run_delay;
>         kvm_write_guest_lock(kvm, base, &init_values, sizeof(init_values));
>
>         return base;
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 23cfbecebbd7..14514a25b261 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -253,7 +253,6 @@ struct kvm_vcpu_arch {
>         /* paravirt steal time */
>         struct {
>                 u64 guest_addr;
> -               u64 last_steal;
>                 struct gfn_to_hva_cache cache;
>                 u8  preempted;
>         } st;
> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
> index 15da2d88c0c1..4996ec9c07f9 100644
> --- a/arch/loongarch/kvm/Kconfig
> +++ b/arch/loongarch/kvm/Kconfig
> @@ -26,6 +26,7 @@ config KVM
>         select HAVE_KVM_MSI
>         select HAVE_KVM_READONLY_MEM
>         select KVM_COMMON
> +       select HAVE_KVM_PV_STEAL_TIME
>         select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         select KVM_GENERIC_HARDWARE_ENABLING
>         select KVM_MMIO
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 4f58e6e2cf86..56ae6b18f8c1 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -773,7 +773,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
>                 if (!(data & KVM_STEAL_PHYS_VALID))
>                         return 0;
>
> -               vcpu->arch.st.last_steal = current->sched_info.run_delay;
> +               vcpu->last_steal = current->sched_info.run_delay;
>                 kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>                 return 0;
>         default:
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index ed9e092c97ba..728d29eba8e0 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -187,8 +187,8 @@ static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>         smp_wmb();
>
>         unsafe_get_user(steal, &st->steal, out);
> -       steal += current->sched_info.run_delay - vcpu->arch.st.last_steal;
> -       vcpu->arch.st.last_steal = current->sched_info.run_delay;
> +       steal += current->sched_info.run_delay - vcpu->last_steal;
> +       vcpu->last_steal = current->sched_info.run_delay;
>         unsafe_put_user(steal, &st->steal, out);
>
>         smp_wmb();
> @@ -1205,7 +1205,7 @@ static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
>
>         if (!ret) {
>                 vcpu->arch.st.guest_addr = gpa;
> -               vcpu->arch.st.last_steal = current->sched_info.run_delay;
> +               vcpu->last_steal = current->sched_info.run_delay;
>                 kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>         }
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index a30600579231..305875301c04 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -273,7 +273,6 @@ struct kvm_vcpu_arch {
>         /* SBI steal-time accounting */
>         struct {
>                 gpa_t shmem;
> -               u64 last_steal;
>         } sta;
>  };
>
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index ec2cee0a39e0..1ff07a904a02 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -26,6 +26,7 @@ config KVM
>         select HAVE_KVM_READONLY_MEM
>         select HAVE_KVM_DIRTY_RING_ACQ_REL
>         select KVM_COMMON
> +       select HAVE_KVM_PV_STEAL_TIME
>         select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         select KVM_GENERIC_HARDWARE_ENABLING
>         select KVM_MMIO
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
> index 60e50296a008..9a77d3bde7c7 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> @@ -19,13 +19,13 @@
>  static void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
>  {
>         vcpu->arch.sta.shmem = INVALID_GPA;
> -       vcpu->arch.sta.last_steal = 0;
> +       vcpu->last_steal = 0;
>  }
>
>  void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu)
>  {
>         gpa_t shmem = vcpu->arch.sta.shmem;
> -       u64 last_steal = vcpu->arch.sta.last_steal;
> +       u64 last_steal = vcpu->last_steal;
>         __le32 __user *sequence_ptr;
>         __le64 __user *steal_ptr;
>         __le32 sequence_le;
> @@ -67,8 +67,8 @@ void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu)
>
>         if (!WARN_ON(get_user(steal_le, steal_ptr))) {
>                 steal = le64_to_cpu(steal_le);
> -               vcpu->arch.sta.last_steal = READ_ONCE(current->sched_info.run_delay);
> -               steal += vcpu->arch.sta.last_steal - last_steal;
> +               vcpu->last_steal = READ_ONCE(current->sched_info.run_delay);
> +               steal += vcpu->last_steal - last_steal;
>                 WARN_ON(put_user(cpu_to_le64(steal), steal_ptr));
>         }
>
> @@ -115,7 +115,7 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kvm_vcpu *vcpu)
>                 return SBI_ERR_INVALID_ADDRESS;
>
>         vcpu->arch.sta.shmem = shmem;
> -       vcpu->arch.sta.last_steal = current->sched_info.run_delay;
> +       vcpu->last_steal = current->sched_info.run_delay;
>
>         return 0;
>  }
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 683bb8bf43a9..ebdd8526ae12 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -872,7 +872,6 @@ struct kvm_vcpu_arch {
>         struct {
>                 u8 preempted;
>                 u64 msr_val;
> -               u64 last_steal;
>                 struct gfn_to_hva_cache cache;
>         } st;
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 538ed1e80332..b2aea8058841 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -40,6 +40,7 @@ config KVM_X86
>         select HAVE_KVM_MSI
>         select HAVE_KVM_CPU_RELAX_INTERCEPT
>         select HAVE_KVM_NO_POLL
> +       select HAVE_KVM_PV_STEAL_TIME
>         select VIRT_XFER_TO_GUEST_WORK
>         select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         select KVM_VFIO
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 79468ddfe473..927c8b1ed83d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2129,9 +2129,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>         smp_wmb();
>
>         unsafe_get_user(steal, &st->steal, out);
> -       steal += current->sched_info.run_delay -
> -               vcpu->arch.st.last_steal;
> -       vcpu->arch.st.last_steal = current->sched_info.run_delay;
> +       steal += current->sched_info.run_delay - vcpu->last_steal;
> +       vcpu->last_steal = current->sched_info.run_delay;
>         unsafe_put_user(steal, &st->steal, out);
>
>         version += 1;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 03bfc92864b6..ff9d423b6a7c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -398,6 +398,10 @@ struct kvm_vcpu {
>          */
>         struct kvm_memory_slot *last_used_slot;
>         u64 last_used_slot_gen;
> +
> +#ifdef CONFIG_HAVE_KVM_PV_STEAL_TIME
> +       u64 last_steal;
> +#endif
>  };
>
>  /*
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index c3c0ee253fc7..f42a3a0fc5ba 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -82,6 +82,9 @@ config HAVE_KVM_IRQ_BYPASS
>  config HAVE_KVM_VCPU_RUN_PID_CHANGE
>         bool
>
> +config HAVE_KVM_PV_STEAL_TIME
> +       bool
> +
>  config HAVE_KVM_NO_POLL
>         bool
>
> --
> 2.43.7
>
