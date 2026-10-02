Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD535E1B8
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 06:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790923709; cv=pass; b=Cn81aPUyuAUJzbvfoveFUh7uBoKc0r5hP9lKnO5HIg2YbjQWPEzsbRY9qCnpq2qVz1Uhklg/gunJ1RKMZjMM1jbbUcVa/UPlTBMSmFpScFc/9KBLn0wkM6cSYv15A62lDzsbmMNdWJ6K7cEqm3mn9l2XBZtArGaEvz0dsx539LA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790923709; c=relaxed/simple;
	bh=Gn3DzN67gt8dqk+SVB2qqbya2F4alfWx+9qoC2ReG4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YdRv1zVbJH0pFLuNFgvn3s97NktYjHmWhYMx9O2/rBsAClv1j4Nqf52Wzg5LgSminEFklpxDSZVxrAjoWytHeYk5BItuF/ZSvScCG92AUfSAyP1ulD0wJoi/Y0FY+OOrVgDC2DojOJFi+PKSUO1l6VYYGdCFsP05b90ZjnPPztM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault.org header.i=@brainfault.org header.b=kBqJ6XuA; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault.org header.i=@brainfault.org header.b="kBqJ6XuA"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5ba3f77a228so2261182e87.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 23:48:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790923705; cv=none;
        d=google.com; s=arc-20260327;
        b=kGJQDN5enLwKtA+i8Ciw4JePjzS7qNy7rQowHOKbNIMVy+gqUXjMgsRQ4wS7CMddX7
         kaB1YEiV59JN9kQQ15fW3mUDgYCgq7oNlUMe3Gcl9OUgW9LEbzM9S+Ovn7o5OyzPYEiE
         dZOKQx8nG9iiwgQqIp0e43HED5ujPxZzyYKBJfwlGKQBDGNefr/hbXBlYlye/G6vA9YR
         ONKxV1rDRmA8uIgMOK5/6Hc0w8WTF6noJ9LARtY14RnR0uzMN8+WSCONDjXNNnAzvv1u
         a3bixofFc8FoJMJL+oebWWjj8nblg4CMPMzraEUpoUZKdKzwg5O+5kSenJXz7xhLtuWX
         KZUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6lOPOZOlRG1U0jS9b5qGM2HS9CvZmsUPCrds2bv1Jqg=;
        fh=cjlYWr1kiWQUoQJ6iXnQ2xsFDb61hPmwOpCnFhqxGCE=;
        b=WgefxINhQ8q8y6X9hs6PbKOA1uw13lcmqPhZpetALThHk+/6NY1dWNGQ4CtPEYsT2T
         rJDmW2wgqru+Q/G25QDNmY7MYpmeXV7qhKpfGC5swuzOAdLBFCdZ4BVZoJi/KBCAGEKl
         1MZpukt1Cm9/Sot+YorhRRl0oJEfdoariAZJDr8BFjYsvDP+O/1oSDdLC/TnPH9Uw271
         pHhSB/JrYKHfFF/4Q7RQWR0Z0V2w0zPT/CGLWr3u05qwnJjtm8g1M4W7gimtHzkhM35r
         pB71KFLy54IhU8inBy8DGkHN9Qyo5F0V5EU/4KbltpvmqfXvQg5AA56vtjPp2l/kX3c4
         67bg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault.org; s=google; t=1790923705; x=1791528505; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6lOPOZOlRG1U0jS9b5qGM2HS9CvZmsUPCrds2bv1Jqg=;
        b=kBqJ6XuADhsqLeZFH/l78OB7lKnNt5gzQFXUbkVqy1O9VysSXQC6HRhFltuud/yYjt
         5viQoko4BBTbUITBu9CpWRkGfKqsW89cFoO2pzh7rqjk4fKdnc+F+IS+l17cK8u7Zil2
         pBg1SXwD0V2D2YJLeCn4B2ullyc2eW3G0sp33rUIiuiTlqbnQVHp9z/4VganwLTjVku4
         DvwQLe7Yw+7pFXDBNfp7yu8ltx3D27Qe4khFH8R1KOxZzI1CGAvUQHxV2csGPn15ynFS
         k6C6yVwO0J+dPHmu2ensG9/UIIZ64wi4cU2tkhIy6PPsVJDwEEMIOTQwsySzBzBS6oXK
         s6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790923705; x=1791528505;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6lOPOZOlRG1U0jS9b5qGM2HS9CvZmsUPCrds2bv1Jqg=;
        b=LKNWcKVmFxhRmnH1Q3B/ew0jRiPEeN7b1dNNPeQq9cm5Gd3DxrS93K6epnTlt/J5/F
         Q6kF2nLYNn9xorbpSTQ8OTLCY6CvCk4TMWdHOzH5DJvF9zLTLKWpPdzq5VYcuOdjQatI
         /fLqwRzgUxmjGOhjNMy6V1nZL03Li09r3l13om15PXlaxmW9hXfTRgj77wJNsk+4f9ds
         TkmRVJUnvmJckzqSe3XXrm/rhlkwDF1GQnoyepCcp2E7TBCKSu+1MwMYVCRNW9uoe2mf
         lCRlewi99ss5SBuqzYcFJIar/TwSOlwGeiULSETx7fjBvTX82mfnlsbwfWfpXdXtv1yE
         Iugg==
X-Forwarded-Encrypted: i=1; AKwUvBzGwKlcsEEaGE62CqMLG6FQz93TmLKyf7+G9YkckL4h++lQrYSGn1ykOzdnxH0aZ+vPdaHdUGU=@lists.linux.dev
X-Gm-Message-State: AFq9FYK0U2aaCcC5LjKHkHEO4sjLoPNa8yYe6FWRkCKn4g9Ql7sJM7QD
	p4FaM9LMnLUnd+JuS2qkOYcMDpwA9VvrRTEl1CbMTy4dcZF6ndF2OKO364kpa1SOerjhMPz82jC
	3tZ2UifJhv03bsut4axJonc+McXJdDshtGohdszKUNg==
X-Gm-Gg: AYBFou3Ap8/jSZ7D3JyJ060OpnuAMQWZ/bl3wB5TF/OlhMEX6cLsbHDr/fAPgs8kunB
	1HgENmszHIIuglP/Qg8CQ52NwwjlRtf+urRlVNXk89cQBUE4LGVVHptS/0g5elFEhCLNT11ud7s
	xVGivLcUGZ+0NutVRZWmp6nZhzrh8k/G8JuUTCfN7DXU3XRFg4SgdtjmqVuZu5rZnllYolrLog0
	twhHSzTpET/nKMVbtUyX2KUsKZwBnak9mFDnNesdqAzlxjzGXmiEHHr007C/8spZTdtbH808e4v
	UNIkJRiyeVeElyZ9gCQwqTC3J+ZI9Rd+nH/+d1w1vuYXsuaUybDPZxabmcMPIl8+7KTUykyek2i
	DfR/9QzaJeKEl8JTwFC6rDzIzpBub8c/PbGDZevlMXLyoAmHGVhlHaAcxFOcGhBZd7mz5iP3VK7
	N5prDVXKWSmQ==
X-Received: by 2002:a05:6512:401d:b0:5b8:fa05:e49c with SMTP id
 2adb3069b0e04-5bb9bb19500mr596734e87.34.1790923704845; Thu, 01 Oct 2026
 23:48:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904175550.430266-1-dongli.zhang@oracle.com> <20260904175550.430266-2-dongli.zhang@oracle.com>
In-Reply-To: <20260904175550.430266-2-dongli.zhang@oracle.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 2 Oct 2026 12:18:11 +0530
X-Gm-Features: AclHuK8jni4c7kFYNY1Z67Q0WeqgvibrlMJVROVFG2iQbTyVsq4GtRVUGzMalTs
Message-ID: <CAAhSdy2oKW8SDKd5ax8Tw3Wr-i8_x+i2WviK_9r6+HsG-83FYw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: Move last_steal to common struct kvm_vcpu
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, 
	atish.patra@linux.dev, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, dwmw2@infradead.org, joe.jin@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 11:26=E2=80=AFPM Dongli Zhang <dongli.zhang@oracle.c=
om> wrote:
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

For KVM RISC-V:
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup


> ---
> Marc suggested reusing CONFIG_HAVE_PV_STEAL_CLOCK_GEN, but I introduced
> HAVE_KVM_PV_STEAL_TIME instead.
>
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
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
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
>         struct kvm *kvm =3D vcpu->kvm;
>         u64 base =3D vcpu->arch.steal.base;
> -       u64 last_steal =3D vcpu->arch.steal.last_steal;
> +       u64 last_steal =3D vcpu->last_steal;
>         u64 offset =3D offsetof(struct pvclock_vcpu_stolen_time, stolen_t=
ime);
>         u64 steal =3D 0;
>         int idx;
> @@ -25,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>         idx =3D srcu_read_lock(&kvm->srcu);
>         if (!kvm_get_guest(kvm, base + offset, steal)) {
>                 steal =3D le64_to_cpu(steal);
> -               vcpu->arch.steal.last_steal =3D READ_ONCE(current->sched_=
info.run_delay);
> -               steal +=3D vcpu->arch.steal.last_steal - last_steal;
> +               vcpu->last_steal =3D READ_ONCE(current->sched_info.run_de=
lay);
> +               steal +=3D vcpu->last_steal - last_steal;
>                 kvm_put_guest(kvm, base + offset, cpu_to_le64(steal));
>         }
>         srcu_read_unlock(&kvm->srcu, idx);
> @@ -61,7 +61,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>          * Start counting stolen time from the time the guest requests
>          * the feature enabled.
>          */
> -       vcpu->arch.steal.last_steal =3D current->sched_info.run_delay;
> +       vcpu->last_steal =3D current->sched_info.run_delay;
>         kvm_write_guest_lock(kvm, base, &init_values, sizeof(init_values)=
);
>
>         return base;
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
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
> -               vcpu->arch.st.last_steal =3D current->sched_info.run_dela=
y;
> +               vcpu->last_steal =3D current->sched_info.run_delay;
>                 kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>                 return 0;
>         default:
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index ed9e092c97ba..728d29eba8e0 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -187,8 +187,8 @@ static void kvm_update_stolen_time(struct kvm_vcpu *v=
cpu)
>         smp_wmb();
>
>         unsafe_get_user(steal, &st->steal, out);
> -       steal +=3D current->sched_info.run_delay - vcpu->arch.st.last_ste=
al;
> -       vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> +       steal +=3D current->sched_info.run_delay - vcpu->last_steal;
> +       vcpu->last_steal =3D current->sched_info.run_delay;
>         unsafe_put_user(steal, &st->steal, out);
>
>         smp_wmb();
> @@ -1205,7 +1205,7 @@ static int kvm_loongarch_pvtime_set_attr(struct kvm=
_vcpu *vcpu,
>
>         if (!ret) {
>                 vcpu->arch.st.guest_addr =3D gpa;
> -               vcpu->arch.st.last_steal =3D current->sched_info.run_dela=
y;
> +               vcpu->last_steal =3D current->sched_info.run_delay;
>                 kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>         }
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
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
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.=
c
> index 60e50296a008..9a77d3bde7c7 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> @@ -19,13 +19,13 @@
>  static void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
>  {
>         vcpu->arch.sta.shmem =3D INVALID_GPA;
> -       vcpu->arch.sta.last_steal =3D 0;
> +       vcpu->last_steal =3D 0;
>  }
>
>  void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu)
>  {
>         gpa_t shmem =3D vcpu->arch.sta.shmem;
> -       u64 last_steal =3D vcpu->arch.sta.last_steal;
> +       u64 last_steal =3D vcpu->last_steal;
>         __le32 __user *sequence_ptr;
>         __le64 __user *steal_ptr;
>         __le32 sequence_le;
> @@ -67,8 +67,8 @@ void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *=
vcpu)
>
>         if (!WARN_ON(get_user(steal_le, steal_ptr))) {
>                 steal =3D le64_to_cpu(steal_le);
> -               vcpu->arch.sta.last_steal =3D READ_ONCE(current->sched_in=
fo.run_delay);
> -               steal +=3D vcpu->arch.sta.last_steal - last_steal;
> +               vcpu->last_steal =3D READ_ONCE(current->sched_info.run_de=
lay);
> +               steal +=3D vcpu->last_steal - last_steal;
>                 WARN_ON(put_user(cpu_to_le64(steal), steal_ptr));
>         }
>
> @@ -115,7 +115,7 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kv=
m_vcpu *vcpu)
>                 return SBI_ERR_INVALID_ADDRESS;
>
>         vcpu->arch.sta.shmem =3D shmem;
> -       vcpu->arch.sta.last_steal =3D current->sched_info.run_delay;
> +       vcpu->last_steal =3D current->sched_info.run_delay;
>
>         return 0;
>  }
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
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
> @@ -2129,9 +2129,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu=
)
>         smp_wmb();
>
>         unsafe_get_user(steal, &st->steal, out);
> -       steal +=3D current->sched_info.run_delay -
> -               vcpu->arch.st.last_steal;
> -       vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> +       steal +=3D current->sched_info.run_delay - vcpu->last_steal;
> +       vcpu->last_steal =3D current->sched_info.run_delay;
>         unsafe_put_user(steal, &st->steal, out);
>
>         version +=3D 1;
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
