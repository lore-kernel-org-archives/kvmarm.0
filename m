Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD004119FA
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785342870; cv=none; b=qdpsYROgUPC0+EOk/qOon3RZayLzooOLhbnrWymTeT09REeQxDkemFjBGiGKKRnC4XrDc0RZI2sOGM6qLTB4l+Z+Tn4xFbmZ4dhw0tWMI9GF3+RoROKcWXprdqJ8UYojcN8x3R9UWhICKBHWRpWg/o5kzEv4n3KFujOzlb7akrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785342870; c=relaxed/simple;
	bh=xVCMaAYRMoA+7JRlPIAe/kKzeo1xh9J+66pWGwEUyFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b19siAHlZo0YwHY7J4r2R+5TfjDcZFF7MaNU63Ynh5pr5SA9EVgzcQRBR5U+i4SyPJmbpDuJcVuVe2vgSjVC++kI6NUTyyz6u3v71QxKkk9Az8QqRVQ+r9+yxEv8kecM4o/e2bolPhUQYBB3Ep8HB9a1KKshU20Ukk4KQLfo2Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FCD0X156; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FCD0X156"
X-Forwarded-Encrypted: i=1; AHgh+Rrq7Q9kTwLi8KTkpxiKKq/oM0Vkx+Girn20HYxSZft5FJS8mwXEC8h/s1e8uY056cZxAQnfGcc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785342866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CDwMDWK74FGPCQksjJUhT5TIKVqDAVbip9kxaBkjJBk=;
	b=FCD0X156GxRSdy69AnwFVrpQDC1KNPrXkd46HJDtpVePqSGwZGeJ8A9yO0j/fVfMXYNTWB
	7BGHwji+UFesA/kehnFbNYOvMxzTkMU/BE8t6N2qyiufAr/VNfkZwA4fYbGdWu3kUXdFF8
	CEli92GDWYJLgIrb/VFE+vtcp+sMsPo=
X-Gm-Message-State: AOJu0YyGJCPo6gIq7QkdAdnAr5BZ90Hh+hEwGYXIYyol4JBVRiY9KYiY
	Ors5o1+HDjuQy59PMU9HoZOySYmQwRY8k57tDSx/hKmYkj4vMe5D4PjJY7dEOHO9UmdsMJVh74e
	8KWDu/rhDpgJ5BbCiPoQhAntVnMy+dACHeN9PxWIM
X-Received: by 2002:a05:622a:2b49:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-52b3500260fmr2216081cf.12.1785342860083; Wed, 29 Jul 2026
 09:34:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720-hybrid-v9-10-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-10-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 17:33:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzuaMDJm8BPf1sA9DiSDvtyn=C1Z2LrOLYc228XKJzF2w@mail.gmail.com>
X-Gm-Features: AUfX_mzDDgEy7qPOSuwHqBOjPkT5QQo0kZIP1lcw0jJbpzlF7P6EqmFVAn2Xz68
Message-ID: <CA+EHjTzuaMDJm8BPf1sA9DiSDvtyn=C1Z2LrOLYc228XKJzF2w@mail.gmail.com>
Subject: Re: [PATCH v9 10/16] KVM: arm64: Don't clear vcpu->cpu in kvm_arch_vcpu_put()
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Steffen Eiden <seiden@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 06:39, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> From: Oliver Upton <oupton@kernel.org>
>
> commit e9b152cb957c ("arm/arm64: kvm: Set vcpu->cpu to -1 on vcpu_put")
> reset vcpu->cpu in order for the VGIC to determine if there was any vCPU
> running at the time of access. The VGIC has gone through an entire
> rewrite since then, and with commit 7d450e282171 ("KVM: arm/arm64:
> vgic-new: Add userland access to VGIC dist registers") the user
> accessors just grab all vCPU mutexes instead.
>
> Drop this remaining vestige such that kvm_arch_vcpu_load() can properly
> detect a CPU migration. While at it, rework kvm_reset_vcpu() to do a
> much more pedantic check that the provided vCPU is actually what's
> running on the present CPU.
>
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/arm.c   |  1 -
>  arch/arm64/kvm/reset.c | 16 +++++++++++-----
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a06ea39f57b1..72ce79ce4d5e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -749,7 +749,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         kvm_arm_vmid_clear_active();
>
>         vcpu_clear_on_unsupported_cpu(vcpu);
> -       vcpu->cpu = -1;
>  }
>
>  static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index b963fd975aac..6bfb21f00444 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -190,7 +190,8 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>  void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_reset_state reset_state;
> -       bool loaded;
> +       struct kvm_vcpu *running;
> +       bool loaded = false;
>         u32 pstate;
>
>         spin_lock(&vcpu->arch.mp_state_lock);
> @@ -198,10 +199,16 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>         vcpu->arch.reset_state.reset = false;
>         spin_unlock(&vcpu->arch.mp_state_lock);
>
> -       preempt_disable();
> -       loaded = (vcpu->cpu != -1);
> -       if (loaded)
> +       guard(preempt)();
> +
> +       running = kvm_get_running_vcpu();
> +       if (running) {
> +               if (KVM_BUG_ON(running != vcpu, vcpu->kvm))
> +                       return;
> +
> +               loaded = true;
>                 kvm_arch_vcpu_put(vcpu);
> +       }
>
>         if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
>                 if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
> @@ -269,7 +276,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>
>         if (loaded)
>                 kvm_arch_vcpu_load(vcpu, smp_processor_id());
> -       preempt_enable();
>  }
>
>  u32 kvm_get_pa_bits(struct kvm *kvm)
>
> --
> 2.55.0
>
>
