Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2EB1E6DC5
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 20:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746219437; cv=none; b=c8CL3nCwetu9/1+xJ/aTIe4+E56qC5R0yy+L6DXDJssIkYIR9XTMu1mLijAGeuesLHZ61reMsg4padCVPfroKygwmEspGDxKhsuYcrOIAv44rCNyxkh9eCD/Riz295IpX+B1HfwqFZyL1S55SwG6gn0rzCHqRvitG/pCVvAvtqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746219437; c=relaxed/simple;
	bh=geu1hvD8M1WtLM5eq0X8U0+bofpDI6etMkY3XNoydoc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XrflNHi52qTddvPWM1UmHbRa5jyTBDstKUHmDEV0xgtNoWc5ETdyvyVAXwEf48xBHtjwaR3wu5K5TzzO2z85PpW9Y+YZhnk6xShDUGQQMsgVWPv0uNc1A4jX0W1F1HpXpigtYispGhoF+ECzwdjQgcROmXGFn2xAbh9oZVVvys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0BPyrVBE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0BPyrVBE"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff8119b436so2109216a91.0
        for <kvmarm@lists.linux.dev>; Fri, 02 May 2025 13:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746219435; x=1746824235; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjfhxP1aTkCqZKrd23sK3YHNUgKYVqxJbIVvYWHW5Vg=;
        b=0BPyrVBE4eIpUfcFlD0mDuUQ5adMawF6+pFQ+BeoKL6qF03N0GOsDt7c/h3131yllI
         E2dCFogmCEEADgap7Wf+3QcweU93qotvTrVEQdLh/R80P5zbehWgk725Q4WD08peRq14
         2K8KjJFJHA/PvxMwjoPJ2RPNGX5CEOU/xUSogH8QRpwKhbvA2T14zZwol1SgYisJUhma
         jf47uezTCsfYo7/qRpLcUJC0IaYZQ50kxGk1dhu116sLmvCwTbG6x8S5ueTpJCvSCoCx
         reirm32t8vIy76Z6T/KypRR09kMxPizemmTqdRJAGj8ZWaAmafnLDEwSn26nkPAn9JLY
         lhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746219435; x=1746824235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjfhxP1aTkCqZKrd23sK3YHNUgKYVqxJbIVvYWHW5Vg=;
        b=e6Te88XVJ/KT6yzaH73EnoQIV4SbiNjkOSpmMTH5u+K1+1jSJ78vbYNH4rP+rCjVNC
         VXP5pIuUvTyjFxeEmUhwFfQGRrKELT266w3Fwp4aKMmxPSwG3+HILq5ZiziUe8l3B7TA
         zQ8+wTgVV/a5lm2WTtskuzFkCui4Cze0N2KgAvCFK567QkxGhzmstzAYSQ5PmzdSlhpn
         p0YRspzM1cezMPcGbnXkVeUNl3zck49YXcdE4Cl43EWZjVzOx5VsqCumtvmGSUsdcrou
         E299kVAEPB45PfUieBFKPd9PUf69NCceW8YaHc8sC8rmTvokdmEYyw5TjByketeIZrWc
         IBjg==
X-Forwarded-Encrypted: i=1; AJvYcCUbFV1ntwxeq8sioQki83QC5HAJVCf75xlNkiNOuY3+FK49ib9UZCWDBhguTmDD/APWMlVWWwk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbbDKsAEO7NgCujepbfQeGjvNrmyB7RsSi9Q4LKPe56Fx11H1P
	zlVmb14sCcBCDx9uJER8wlKVgOsK41R6YfI6YSS1VcxqtH/T8dSgi0aZ3gi5HrxQD6SeO809sNh
	3Lg==
X-Google-Smtp-Source: AGHT+IFuPDTKjcdWvbnOJrt3XOUZC4A4co+KVYAa4VIdQzxs3SS2Bb249oxqj85YoS9Ls6YyYG5MsQtlc4s=
X-Received: from pjbqb9.prod.google.com ([2002:a17:90b:2809:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0e:b0:2ff:618c:a1e0
 with SMTP id 98e67ed59e1d1-30a4e6b2624mr6211245a91.29.1746219435414; Fri, 02
 May 2025 13:57:15 -0700 (PDT)
Date: Fri, 2 May 2025 13:57:13 -0700
In-Reply-To: <20250430203013.366479-6-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250430203013.366479-1-mlevitsk@redhat.com> <20250430203013.366479-6-mlevitsk@redhat.com>
Message-ID: <aBUxqZ6qgfYZLsye@google.com>
Subject: Re: [PATCH v4 5/5] x86: KVM: SEV: implement kvm_lock_all_vcpus and
 use it
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Waiman Long <longman@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Borislav Petkov <bp@alien8.de>, Albert Ou <aou@eecs.berkeley.edu>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Alexander Potapenko <glider@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Andre Przywara <andre.przywara@arm.com>, x86@kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm-riscv@lists.infradead.org, 
	Atish Patra <atishp@atishpatra.org>, Ingo Molnar <mingo@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Keisuke Nishimura <keisuke.nishimura@inria.fr>, 
	Sebastian Ott <sebott@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Shusen Li <lishusen2@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 30, 2025, Maxim Levitsky wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 834f08dfa24c..9211b07b0565 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1392,6 +1392,31 @@ int kvm_trylock_all_vcpus(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
>  
> +/*
> + * Lock all of the VM's vCPUs.
> + * Assumes that the kvm->lock is held.

Add a lockdep assertion instead of a comment.

> + * Returns -EINTR if the process is killed.
> + */
> +int kvm_lock_all_vcpus(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i, j;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)

Needs curly braces.

> +		if (mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock))

I'd rather return mutex_lock_killable_nest_lock()'s error code verbatim.  Then
the function comment can go away, because the only thing remaining would be:

	/*
	 * Lock all of the VM's vCPUs.
	 /*

and that should be completely self-explanatory.  E.g.

int kvm_lock_all_vcpus(struct kvm *kvm)
{
	struct kvm_vcpu *vcpu;
	unsigned long i, j;
	int r;

	lockdep_assert_held(&kvm->lock);

	kvm_for_each_vcpu(i, vcpu, kvm) {
		r = mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock);
		if (r)
			goto out_unlock;
	}
	return 0;

out_unlock:
	kvm_for_each_vcpu(j, vcpu, kvm) {
		if (i == j)
			break;
		mutex_unlock(&vcpu->mutex);
	}
	return r;
}
EXPORT_SYMBOL_GPL(kvm_lock_all_vcpus);
