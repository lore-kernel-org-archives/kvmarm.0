Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A4D79E2
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 11:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686308400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hp1V+H0c0blZeFGezmZ2Jagy9PHvvFYZ0tk77cJraXU=;
	b=UObiRaNbsPSw3qqCEAL2FjZqUDYLc3zZ32RFxC5Ymg1SG6+RBaMkBydaki8ct5aitg+Uwg
	MgK3xkABPecUvqPZY+gsUKrrUMIzD+cYEW21kYPvsqetnJ4cUYsu2zwZIjcFUygXDQC+UR
	u7+vseowmv/mtiS0GZnxDjMBabe4ZME=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-LiT2uz2SMzCiCXlJ2JPW5Q-1; Fri, 09 Jun 2023 06:59:59 -0400
X-MC-Unique: LiT2uz2SMzCiCXlJ2JPW5Q-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-74faf5008bbso39695185a.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 03:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686308399; x=1688900399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hp1V+H0c0blZeFGezmZ2Jagy9PHvvFYZ0tk77cJraXU=;
        b=ZN4RZtMpl/12cpQe87PawdQjwhdYVEOLi88z+9InWbAeMFc9Ur9pATblGc7cXEYFi6
         Svas40VWHNpoecv80a6u7VrGysk+mg26LHva4MH5N1cWlkKSJLVSqwH15bwbifkd7aI3
         SVZAyMX2RrGdDBu51fio/9nf86poHuYnlabe6eY7z01QdXpfBBOhRatnyq4WUtiZTA1P
         W/gCk6oRwfrAycRJynNP81/CtHL7sPcwppZE0rkEB9a+B2ESkJA6RPbN7gTRHU6kb7R/
         vHyd+vxrEBIVTD/bwRGA+/hydIHYgeh4gUs6ITUpjSm6QiHF/x6LcFABSK74vmyjsODg
         X5nQ==
X-Gm-Message-State: AC+VfDz6H0Sbc09TC/MZFXQabGvZpspSa2C7dFu3dVFhrWhxre67yIde
	Sq+dlDPf0vlIL+4rnzhGwEFya5sCbwlsQuL4+kIpibfr6xGLHxt3YK2aU4KlpHBGbDx2hMvi9GU
	TIuDKNOugeIS1uuLI
X-Received: by 2002:a05:620a:8908:b0:75e:bd15:d95a with SMTP id ql8-20020a05620a890800b0075ebd15d95amr826642qkn.6.1686308399086;
        Fri, 09 Jun 2023 03:59:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5pX2BgRt1yhMGjAkkAV6A3kyJooZuyypF9hAb1zGeqztu2HxgfV33qrZip60badBxrIS0f0w==
X-Received: by 2002:a05:620a:8908:b0:75e:bd15:d95a with SMTP id ql8-20020a05620a890800b0075ebd15d95amr826625qkn.6.1686308398848;
        Fri, 09 Jun 2023 03:59:58 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s1-20020a05620a16a100b0075b35e72a21sm951485qkj.86.2023.06.09.03.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 03:59:58 -0700 (PDT)
Message-ID: <10695b6a-65d5-2df3-e89e-8cc2cd75b8ac@redhat.com>
Date: Fri, 9 Jun 2023 18:59:53 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH kvmtool 12/21] Add helpers to pause the VM from vCPU
 thread
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Will Deacon <will@kernel.org>, Julien Thierry
 <julien.thierry.kdev@gmail.com>, Salil Mehta <salil.mehta@huawei.com>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
 <20230526221712.317287-13-oliver.upton@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230526221712.317287-13-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

I have a play with this series, the guest always hang when hotplug two 
more cpus, it seems the kvm_cpu_continue_vm forget to continue the 
current cpu.

On 5/27/23 06:17, Oliver Upton wrote:
> Pausing the VM from a vCPU thread is perilous with the current helpers,
> as it waits indefinitely for a signal that never comes when invoked from
> a vCPU thread. Instead, add a helper for pausing the VM from a vCPU,
> working around the issue by explicitly marking the caller as paused
> before proceeding.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   include/kvm/kvm-cpu.h |  3 +++
>   kvm-cpu.c             | 15 +++++++++++++++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
> index 0f16f8d6e872..9a4901bf94ca 100644
> --- a/include/kvm/kvm-cpu.h
> +++ b/include/kvm/kvm-cpu.h
> @@ -29,4 +29,7 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu);
>   void kvm_cpu__arch_nmi(struct kvm_cpu *cpu);
>   void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task);
>   
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu);
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu);
> +
>   #endif /* KVM__KVM_CPU_H */
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 7dec08894cd3..9eb857b859c3 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -141,6 +141,21 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
>   	mutex_unlock(&task_lock);
>   }
>   
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
> +{
> +	/*
> +	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
> +	 * signal exit.
> +	 */
> +	vcpu->paused = true;
> +	kvm__pause(vcpu->kvm);
> +}
> +
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
> +{
Here should add:
	vcpu->paused = false;
> +	kvm__continue(vcpu->kvm);
> +}
> +
>   int kvm_cpu__start(struct kvm_cpu *cpu)
>   {
>   	sigset_t sigset;

-- 
Shaoqin

