Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA301CAA82
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206442; cv=none; b=XXQVf3w0RPF7jzObljRix7JzTqqVpvf4OQL5FLpXSj4iA0xjlDkCAavKfdQ5Y3mTsX+oTQDLI2UkAzc+mWi6OXVV9HzalM6ag/cuMViLRwDc8+NmqhIWq2g1sc26mhMoYwvGKkTjaARv6thuA6v177Ijpc8k1pu5Uq8EBA/t8ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206442; c=relaxed/simple;
	bh=qoxX74MayVQT3lo4VHMo/vX7lWgGYrnFT4wmOWYfSqQ=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=pRuJX3Z8rOO+7MulI8V7vglzRP2RB+MG8Z6rbMGDBAT02kizebOUev2TbYctw6cDAXby8MQhkmekjwJtQoGIxNl/mh8pHV/H1wJMg99iH12lJhFcazB9fEUl7z0t+GgQ6XTfTCt81xGU2FVCLa8nJv0GI6sF5lMchjVFeXDvdR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LY//Wrsd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LY//Wrsd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744206439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C8sFG62uIhWcCDnsK+TitF7g9YvTTNhbdnhc8bS11xU=;
	b=LY//WrsdjkdAzh9bMRwAeHZLEMxSvcoVBH5cXHb4MxEG1nSkmU65yz+F8ilWqnaVeAkn4Z
	r5GiHwULexAwq5aKp2ef374g8ZQDUb389ULmaULZJLwC1lxw8JY75Prj8AUXsmdTrr/xCv
	3NQfso6odaq1sE/PQZ9BviM37LFRTjw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172--648D_vwNqCUKq3LeYrLtQ-1; Wed, 09 Apr 2025 09:47:17 -0400
X-MC-Unique: -648D_vwNqCUKq3LeYrLtQ-1
X-Mimecast-MFC-AGG-ID: -648D_vwNqCUKq3LeYrLtQ_1744206436
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d6e10f8747so54929085ab.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Apr 2025 06:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206436; x=1744811236;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8sFG62uIhWcCDnsK+TitF7g9YvTTNhbdnhc8bS11xU=;
        b=vOu92w4GMWg5S2mKHe6bxja1HT5xAw+l0v6ou+Y7ihQf7i2q+Qn9yQJmVhaAoXgWr8
         O0G9MRH09r+Ju3CvQCEWPXKcBxO4pO6Ypl1oT4MczFhgrt+2FVAFk6CqaAxqfyV0C0PO
         Mu+bE6TUab2Cuv60qVQxsKMbeCYwx9OhHtxbBTj9VcgcJdimG0LMhh3JnNHw18YhImQ/
         SRurR6hkc8q8E23ihmluiwRZktfTIW6cf8n96tQR92vZlnC9jmq6LkSmTibkJl2QC0s0
         BTDR6ZU1DsX7SZqZ09rIwJZ6GhTdFMTe9gyoI9Su0KO/Dcc317/tTN17ZhQFCjkGHwe0
         AZ4A==
X-Forwarded-Encrypted: i=1; AJvYcCXhfC+7nneYJHduj+KRIgKOafb+12VbrN7DL0kl9BO2ZuWf5SDMzfQMcVvBG5ZaQ51NplFtck4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFiJKO+0Rw3Iy08cw+X1L/mjtMM2R6xt0/A6R+QeWF/qN5UNo0
	dr0VhnTGOsQbZVxK0dsYaPpKmA+Y1/sJbu/ireyRkpl3l1LtlCIzlo8HX7aq5veuIzLGFfSxuKq
	5+0G1bZNBM5P7uTc+AgvwmUOJ/ewQcduqrCoKme1OLFEVACZ3hHjKIQ==
X-Gm-Gg: ASbGncuse7QVuZVQuLO7nNmhMDnVS28QdTzysacHWg0F0Wpf790B1R1Vdb+cjE+E8zm
	QXl/ootASVlbc0Js41rd7AY0fi6RL+KfkBiujREm87YfBnCaPjX95C/fHa1/9NEsmrzT0jQrN/w
	Pqjbp+/hg5AFUWLUD21uTfn/3oFS3CNZl2+C+EqP3YTj+SuhcqeRagjkDYLcfL6OwEWgaFvmDeD
	vTLB/XyUzwn+53Q8mPsA4cHmRnEB3PAk31j+zZy/+T5bFzrK3jTC9CgOSaC1TCM7T2GxvE0VZEJ
	u8ClqELhWjJoeQ1zqxYQLv3zVZQf1ZPXYY97wuHAgdYeGtw4PQLMIk7gOA==
X-Received: by 2002:a05:6e02:1c0e:b0:3d5:dec0:7c03 with SMTP id e9e14a558f8ab-3d77c27fb00mr27400485ab.12.1744206436325;
        Wed, 09 Apr 2025 06:47:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGY11cU0INBe/qnf4e7hQqyG5TAgNSTBjToXX6S3PDZH7tI5Cb3FdlfnkGTFvFeZrlBBTdq0A==
X-Received: by 2002:a05:6e02:1c0e:b0:3d5:dec0:7c03 with SMTP id e9e14a558f8ab-3d77c27fb00mr27400065ab.12.1744206435834;
        Wed, 09 Apr 2025 06:47:15 -0700 (PDT)
Received: from ?IPV6:2601:188:c100:5710:315f:57b3:b997:5fca? ([2601:188:c100:5710:315f:57b3:b997:5fca])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dba85487sm2698105ab.23.2025.04.09.06.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 06:47:15 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <b0fe0707-faae-4e0b-b873-9a80e39471fc@redhat.com>
Date: Wed, 9 Apr 2025 09:47:11 -0400
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: x86: move sev_lock/unlock_vcpus_for_migration
 to kvm_main.c
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 kvm-riscv@lists.infradead.org, Oliver Upton <oliver.upton@linux.dev>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jing Zhang <jingzhangos@google.com>, x86@kernel.org,
 Kunkun Jiang <jiangkunkun@huawei.com>, Boqun Feng <boqun.feng@gmail.com>,
 Anup Patel <anup@brainfault.org>, Albert Ou <aou@eecs.berkeley.edu>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Zenghui Yu <yuzenghui@huawei.com>, Borislav Petkov <bp@alien8.de>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Keisuke Nishimura <keisuke.nishimura@inria.fr>,
 Sebastian Ott <sebott@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, Paul Walmsley
 <paul.walmsley@sifive.com>, Randy Dunlap <rdunlap@infradead.org>,
 Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Andre Przywara <andre.przywara@arm.com>, Thomas Gleixner
 <tglx@linutronix.de>, Sean Christopherson <seanjc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Bjorn Helgaas <bhelgaas@google.com>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
 <20250409014136.2816971-3-mlevitsk@redhat.com>
In-Reply-To: <20250409014136.2816971-3-mlevitsk@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s_SnU4j6oU-rpnPuhbpJEjkwH2h3G5kUXK6mwJH6u_8_1744206436
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/8/25 9:41 PM, Maxim Levitsky wrote:
> Move sev_lock/unlock_vcpus_for_migration to kvm_main and call the
> new functions the kvm_lock_all_vcpus/kvm_unlock_all_vcpus
> and kvm_lock_all_vcpus_nested.
>
> This code allows to lock all vCPUs without triggering lockdep warning
> about reaching MAX_LOCK_DEPTH depth by coercing the lockdep into
> thinking that we release all the locks other than vcpu'0 lock
> immediately after we take them.
>
> No functional change intended.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/sev.c   | 65 +++---------------------------------
>   include/linux/kvm_host.h |  6 ++++
>   virt/kvm/kvm_main.c      | 71 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 81 insertions(+), 61 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..7adc54b1f741 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1889,63 +1889,6 @@ enum sev_migration_role {
>   	SEV_NR_MIGRATION_ROLES,
>   };
>   
> -static int sev_lock_vcpus_for_migration(struct kvm *kvm,
> -					enum sev_migration_role role)
> -{
> -	struct kvm_vcpu *vcpu;
> -	unsigned long i, j;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (mutex_lock_killable_nested(&vcpu->mutex, role))
> -			goto out_unlock;
> -
> -#ifdef CONFIG_PROVE_LOCKING
> -		if (!i)
> -			/*
> -			 * Reset the role to one that avoids colliding with
> -			 * the role used for the first vcpu mutex.
> -			 */
> -			role = SEV_NR_MIGRATION_ROLES;
> -		else
> -			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> -#endif
> -	}
> -
> -	return 0;
> -
> -out_unlock:
> -
> -	kvm_for_each_vcpu(j, vcpu, kvm) {
> -		if (i == j)
> -			break;
> -
> -#ifdef CONFIG_PROVE_LOCKING
> -		if (j)
> -			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
> -#endif
> -
> -		mutex_unlock(&vcpu->mutex);
> -	}
> -	return -EINTR;
> -}
> -
> -static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
> -{
> -	struct kvm_vcpu *vcpu;
> -	unsigned long i;
> -	bool first = true;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (first)
> -			first = false;
> -		else
> -			mutex_acquire(&vcpu->mutex.dep_map,
> -				      SEV_NR_MIGRATION_ROLES, 0, _THIS_IP_);
> -
> -		mutex_unlock(&vcpu->mutex);
> -	}
> -}
> -
>   static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>   {
>   	struct kvm_sev_info *dst = to_kvm_sev_info(dst_kvm);
> @@ -2083,10 +2026,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   		charged = true;
>   	}
>   
> -	ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
> +	ret = kvm_lock_all_vcpus_nested(kvm, false, SEV_MIGRATION_SOURCE);
>   	if (ret)
>   		goto out_dst_cgroup;
> -	ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
> +	ret = kvm_lock_all_vcpus_nested(source_kvm, false, SEV_MIGRATION_TARGET);
>   	if (ret)
>   		goto out_dst_vcpu;
>   
> @@ -2100,9 +2043,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   	ret = 0;
>   
>   out_source_vcpu:
> -	sev_unlock_vcpus_for_migration(source_kvm);
> +	kvm_unlock_all_vcpus(source_kvm);
>   out_dst_vcpu:
> -	sev_unlock_vcpus_for_migration(kvm);
> +	kvm_unlock_all_vcpus(kvm);
>   out_dst_cgroup:
>   	/* Operates on the source on success, on the destination on failure.  */
>   	if (charged)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1dedc421b3e3..30cf28bf5c80 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1015,6 +1015,12 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
>   
>   void kvm_destroy_vcpus(struct kvm *kvm);
>   
> +int kvm_lock_all_vcpus_nested(struct kvm *kvm, bool trylock, unsigned int role);
> +void kvm_unlock_all_vcpus(struct kvm *kvm);
> +
> +#define kvm_lock_all_vcpus(kvm, trylock) \
> +	kvm_lock_all_vcpus_nested(kvm, trylock, 0)
> +
>   void vcpu_load(struct kvm_vcpu *vcpu);
>   void vcpu_put(struct kvm_vcpu *vcpu);
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 69782df3617f..71c0d8c35b4b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1368,6 +1368,77 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>   	return 0;
>   }
>   
> +
> +/*
> + * Lock all VM vCPUs.
> + * Can be used nested (to lock vCPUS of two VMs for example)
> + */
> +int kvm_lock_all_vcpus_nested(struct kvm *kvm, bool trylock, unsigned int role)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i, j;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +
> +		if (trylock && !mutex_trylock_nested(&vcpu->mutex, role))
> +			goto out_unlock;
> +		else if (!trylock && mutex_lock_killable_nested(&vcpu->mutex, role))
> +			goto out_unlock;
> +
> +#ifdef CONFIG_PROVE_LOCKING
> +		if (!i)
> +			/*
> +			 * Reset the role to one that avoids colliding with
> +			 * the role used for the first vcpu mutex.
> +			 */
> +			role = MAX_LOCK_DEPTH - 1;
> +		else
> +			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> +#endif

Lockdep supports up to 8 subclasses, but MAX_LOCK_DEPTH is 48. I believe 
it is OK to add a mutex_trylock_nested(), but can you just use 0 and 1 
for the subclasses?

Cheers,
Longman

