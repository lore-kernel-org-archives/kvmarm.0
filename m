Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFCB61FFC
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 21:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722634089; cv=none; b=IFwD0BU+FxgbPeOLYFWJMGm8uqhTG5VG3FDrezAgDbH+sg8EmRhxPWwfBrp7yzeRLdYDwyG5jZ2+4zVvpsfhQ44lzeDyMkX+RoPDPj4Uf6hkqQmQmXWneHk8gSxJ7VPbFpRaRq8z8SIusMndwzWMksc+mlEVvLwF7/UKKSo7zJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722634089; c=relaxed/simple;
	bh=Hb5RGJ725IkNLDCGb6BC/OYAZbPAGXAI7qMNSv6Tkxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HTSRiAgBj+IiSi4wjhm6WDsetn+NzcUFMJrmvp1fsiKLAQSHisQN+WjJgehRS+rE3WR7blnVWsMyUCNukdID9M482vgHoyUxbFwW/DWR1/mszMNP6VMeRGyiykk8wDOb3Lrp0pHOSCM8LCnsDsPBcR2pWkbSvPGyxVZV2tL7utY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pSFApp6t; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pSFApp6t"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-428063f4d71so262085e9.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 14:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722634086; x=1723238886; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnigBMu/xWPcjnITDfnjOcwLt//WI1Lvv6cQExwM4m4=;
        b=pSFApp6t0iiwlXntYHicM1WWByznlY5UHBgHqfCxGAPc3tFxVikUyLWlpq6UhwQSGg
         k4owQZYv4eTjv//ZnD2pm1BhE/LZq1BgHsp8pA9em6S2a07zq0/fwnAMN7IKimLmx2xW
         fVPEyyQDCVlCThoLVfmI4u/tESmdu1shyKW2einmtZCfwbSAfkx03BREDkLFcZdMbaEx
         IUD0FYiRmtwJkvltvBgsQitLTd5NIN5pOd3DwuVF6CFpRJcIXIvZQtQKV2BELX0/sTZi
         +TLIwDC+ehvwn7KbeWrd4x/D6mO3TmXp0ALtc24beeZUeSHqq7ic0YjaIq1AqSC9L1nR
         BuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722634086; x=1723238886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnigBMu/xWPcjnITDfnjOcwLt//WI1Lvv6cQExwM4m4=;
        b=ls18ehd8lTR6ET+3WR45IArFoPM5ZP/pEO0APHD2lu6u+nuJqlpP+7CvvSXQG2Oyyf
         QJWmt+v/2i2avbJWi5nflA6S49FzK0B2H2o3FUym9odP6iVkrXvpQCj1nEYVwb0vM1ZP
         AKW7SXIdFkOwl1IaGFUpvh63Dwc2pEmPQ6C/IymtnBBHL9N9KCp+iKs7dKQYBqLQ8JrT
         ucZ82ovEmNnq3/5qoTv02m/DnLZNE/KtMP+LCvhoEgD6K2rCHlxKMn3aNO2v2Xj+p7Tb
         Hp8weMIpyVT1OWpXXsMJ8PYQCQMbNWkrBnamBgWuVEv+rGAGutOVTIHRyObv+b5vN2KQ
         9hIw==
X-Forwarded-Encrypted: i=1; AJvYcCWuMSUDGjGhlBnCGf4Wx+qV1kVZ48rtuGz7++TIpU05sqKg3kj0kmoyEtJMJFa3WECpBGnoq/t/QJQWsIROjod3MUZvpdV4
X-Gm-Message-State: AOJu0YzzJN1G6KM18rzcxrc7gm6Dk0BXWgVdZ2jvIRfRj7KpNRc4b0Q1
	G7FMBxFuaAMvRNJHO9LGt60IbceHAio0/nIslEibEvTYdAjzDA0k86CVCOh1JkootKmHG/9Vq6Q
	ruZ6ctS+F/YR9gSoBW3lFUkaDG7mUIn4G6ywS
X-Google-Smtp-Source: AGHT+IEy0/ExLs2GCA1i58dsZtt/NIgPBvlCOWYfeCAs5ZR2WL7dwgp15gX0w+DpzgpvBN8/PXqcYv3LgOsqEJPu2SQ=
X-Received: by 2002:a05:600c:c8d:b0:426:5ef2:cd97 with SMTP id
 5b1f17b1804b1-428ef474defmr119025e9.2.1722634085870; Fri, 02 Aug 2024
 14:28:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com> <20240802200136.329973-3-seanjc@google.com>
In-Reply-To: <20240802200136.329973-3-seanjc@google.com>
From: Steve Rutherford <srutherford@google.com>
Date: Fri, 2 Aug 2024 14:27:29 -0700
Message-ID: <CABayD+cWH47Ort22iiUcb17-k2Q+54Mh0xooC64rThLOR08Eew@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 1:01=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> To avoid jitter on KVM_RUN due to synchronize_rcu(), use a rwlock instead
> of RCU to protect vcpu->pid, a.k.a. the pid of the task last used to a
> vCPU.  When userspace is doing M:N scheduling of tasks to vCPUs, e.g. to
> run SEV migration helper vCPUs during post-copy, the synchronize_rcu()
> needed to change the PID associated with the vCPU can stall for hundreds
> of milliseconds, which is problematic for latency sensitive post-copy
> operations.
>
> In the directed yield path, do not acquire the lock if it's contended,
> i.e. if the associated PID is changing, as that means the vCPU's task is
> already running.
>
> Reported-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  include/linux/kvm_host.h          |  3 ++-
>  virt/kvm/kvm_main.c               | 32 +++++++++++++++++--------------
>  3 files changed, 21 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index a33f5996ca9f..7199cb014806 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1115,7 +1115,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu=
,
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>
> -#define vcpu_has_run_once(vcpu)        !!rcu_access_pointer((vcpu)->pid)
> +#define vcpu_has_run_once(vcpu)        (!!READ_ONCE((vcpu)->pid))
>
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  #define kvm_call_hyp_nvhe(f, ...)                                       =
       \
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 689e8be873a7..d6f4e8b2b44c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -342,7 +342,8 @@ struct kvm_vcpu {
>  #ifndef __KVM_HAVE_ARCH_WQP
>         struct rcuwait wait;
>  #endif
> -       struct pid __rcu *pid;
> +       struct pid *pid;
> +       rwlock_t pid_lock;
>         int sigset_active;
>         sigset_t sigset;
>         unsigned int halt_poll_ns;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 91048a7ad3be..fabffd85fa34 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -486,6 +486,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, stru=
ct kvm *kvm, unsigned id)
>         vcpu->kvm =3D kvm;
>         vcpu->vcpu_id =3D id;
>         vcpu->pid =3D NULL;
> +       rwlock_init(&vcpu->pid_lock);
>  #ifndef __KVM_HAVE_ARCH_WQP
>         rcuwait_init(&vcpu->wait);
>  #endif
> @@ -513,7 +514,7 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
>          * the vcpu->pid pointer, and at destruction time all file descri=
ptors
>          * are already gone.
>          */
> -       put_pid(rcu_dereference_protected(vcpu->pid, 1));
> +       put_pid(vcpu->pid);
>
>         free_page((unsigned long)vcpu->run);
>         kmem_cache_free(kvm_vcpu_cache, vcpu);
> @@ -3930,15 +3931,17 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
>
>  int kvm_vcpu_yield_to(struct kvm_vcpu *target)
>  {
> -       struct pid *pid;
>         struct task_struct *task =3D NULL;
>         int ret;
>
> -       rcu_read_lock();
> -       pid =3D rcu_dereference(target->pid);
> -       if (pid)
> -               task =3D get_pid_task(pid, PIDTYPE_PID);
> -       rcu_read_unlock();
> +       if (!read_trylock(&target->pid_lock))
> +               return 0;
> +
> +       if (target->pid)
> +               task =3D get_pid_task(target->pid, PIDTYPE_PID);
> +
> +       read_unlock(&target->pid_lock);
> +
>         if (!task)
>                 return 0;
>         ret =3D yield_to(task, 1);
> @@ -4178,9 +4181,9 @@ static int vcpu_get_pid(void *data, u64 *val)
>  {
>         struct kvm_vcpu *vcpu =3D data;
>
> -       rcu_read_lock();
> -       *val =3D pid_nr(rcu_dereference(vcpu->pid));
> -       rcu_read_unlock();
> +       read_lock(&vcpu->pid_lock);
> +       *val =3D pid_nr(vcpu->pid);
> +       read_unlock(&vcpu->pid_lock);
>         return 0;
>  }
>
> @@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                 r =3D -EINVAL;
>                 if (arg)
>                         goto out;
> -               oldpid =3D rcu_access_pointer(vcpu->pid);
> +               oldpid =3D vcpu->pid;
>                 if (unlikely(oldpid !=3D task_pid(current))) {
>                         /* The thread running this VCPU changed. */
>                         struct pid *newpid;
> @@ -4476,9 +4479,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                                 break;
>
>                         newpid =3D get_task_pid(current, PIDTYPE_PID);
> -                       rcu_assign_pointer(vcpu->pid, newpid);
> -                       if (oldpid)
> -                               synchronize_rcu();
> +                       write_lock(&vcpu->pid_lock);
> +                       vcpu->pid =3D newpid;
> +                       write_unlock(&vcpu->pid_lock);
> +
>                         put_pid(oldpid);
>                 }
>                 vcpu->wants_to_run =3D !READ_ONCE(vcpu->run->immediate_ex=
it__unsafe);
> --
> 2.46.0.rc2.264.g509ed76dc8-goog
>
Reviewed-by: Steve Rutherford <srutherford@google.com>
