Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2E91F4629
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 06:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068092; cv=none; b=W5w5KhZM6soPKFl0HeDsetLR9E7djDsw+K8Z+fT3qGArU9w3YK6nfhPEfZCb29gCeA5sceAa0kKxoVlt/4r/pQgFvr1RdwlAjJqOqVwdzgstztLolpLewut9S8hQDoVu4xbFEyqB6X/QLJadSaoZia2z1NyltXDqLiX77jX+5Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068092; c=relaxed/simple;
	bh=eL87BOoGzXVDBj2SXPjQdFK+ZlB7bcDHzO1QoGp1gFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFzPaVnDhtWe4YKKflbZk+cn5tb1jB00ZcXZnEC4XuVJmZtaUwLE+7+xYOJYHcZakPWAZF4A1jzLrAMftdIeUa2450v4eoH+/J1G0gKSxO8hInnld3H4lhbeyIK40t4cPQpy+7fKOthcj+CZ6ZR7qh7Ns2lQryuwRWrmm7RQ4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EFanl4cC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EFanl4cC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boHxbjq3P2vU0fO6UUb8Hfrkk8ida9vHUjKzaMq4o5k=;
	b=EFanl4cCIrBKwUVkdCRuxa6ahlQnAfhxZY8aaFiubc6h8caETz0aKD6Fx4Ap63Qzk9O+Wc
	vyQpAnlYmsW25lRVBSNFyb15CRGoe1biiOgzULFZ09M0/KkKcxvYpyBCM7yag/7yEUfKby
	nhnYu0GBjNEL02zCnyjAsJ9XrRD/3E4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-Zvq8r2I1Ob-WeVtDlknm_Q-1; Tue, 04 Mar 2025 01:01:26 -0500
X-MC-Unique: Zvq8r2I1Ob-WeVtDlknm_Q-1
X-Mimecast-MFC-AGG-ID: Zvq8r2I1Ob-WeVtDlknm_Q_1741068085
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-22379c2e96aso23793435ad.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 22:01:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741068085; x=1741672885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=boHxbjq3P2vU0fO6UUb8Hfrkk8ida9vHUjKzaMq4o5k=;
        b=AU0CH4Ri5Xri4f4BZFT+IysVVTU0xe+E+NG/etlSW5rCqwAUFGUU36oIFz7O8JRkmE
         H3o4SppQN7A/i7uGEXkhkretJrDlyx1uUsoUpJHvqoc6ZuN++gxWSf7agAAggbNVP7nn
         pRXmV/gWed3UMrCxEZ4fL64uUgeWYOgVc6CDVwT0NofO6I5aU77Ba8vUljzbtkD4/3Cq
         N2gHK4Slwz4hWMTfzCOaWAGQhknpi9q+C5HHI/umbXr0T4/y6hYfCC9gywfOIr6XgL7n
         4XCMCeuR/miNJiVLDN4JGNpEbcmSS7O8YnodZEeLLVGj48Hz84efH+lpXUMXd2xuclDb
         09fA==
X-Forwarded-Encrypted: i=1; AJvYcCXWUcfdRpRvZ3yV3ChJJxDa2nZrfpLqJt374Wmvs5eTr7pKj/O+s7Vme9Mf9vID9qoGGnD109M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxFcQFvGlBTvaBZxnlqOveuNjiBra/kytUbC1jts/NSpCXISDh
	Ty3+bMzm8YQBKAitlkyu40SoONlkcqj690qMxKyKHtVwv2jj3bGM9+NFDZa5t6qhkkZAI5ILCPi
	NKqGaVdDaEqJbP62QxLExkXXy/C379TAa4Bc53JtSTNzh41iMPB8IqA==
X-Gm-Gg: ASbGncvs301p1d6RmTbNYFB5qT56/aMhYgkdXCHzVDvr7TzdtQdfmXi+8ZzxNoLTsn2
	v7SsI5Z0OEmUb2pNyhGgMtHPMjXahGvJlqqekDGKO6b9nxBAasXWu7QWJJikSOd1xNjJ7vs1WRV
	kuepJz/nCLZNaER/vg7YF9aaLrfE66iFVkbKBGgSzmnF5agsqQlLdF/3JkhKfOrl7MWVL4psFT+
	HuSquBDUG04bDwSvTeYoikG55Xtg3Cgk3lAxwWBSEsGIDujM6LQMi/RlapK8+gnEr7p/3Q8i1T9
	piRojYe1MTUYbHU2tg==
X-Received: by 2002:a17:902:d543:b0:210:f706:dc4b with SMTP id d9443c01a7336-22368f8901emr239972425ad.13.1741068085384;
        Mon, 03 Mar 2025 22:01:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHElCuS6yRgRylUHMYlinoo6CRmRHfyntq1vELw6NqviCnDfsX3HH8S1d66GYPIYgVFC5KeFg==
X-Received: by 2002:a17:902:d543:b0:210:f706:dc4b with SMTP id d9443c01a7336-22368f8901emr239972065ad.13.1741068085037;
        Mon, 03 Mar 2025 22:01:25 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504dc6desm87837665ad.168.2025.03.03.22.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:01:24 -0800 (PST)
Message-ID: <12b5ba41-4b1e-4876-9796-d1d6bb344015@redhat.com>
Date: Tue, 4 Mar 2025 16:01:16 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 28/45] arm64: rme: support RSI_HOST_CALL
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-29-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-29-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0hZN1RQMp8nLPXlmlsEwgz_dpmPTt6qU-LzHIjfgkKU_1741068085
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Forward RSI_HOST_CALLS to KVM's HVC handler.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Setting GPRS is now done by kvm_rec_enter() rather than
>     rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>     enter/exit). This fixes a bug where the registers set by user space
>     were being ignored.
> ---
>   arch/arm64/kvm/rme-exit.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> index c785005f821f..4f7602aa3c6c 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -107,6 +107,26 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>   	return -EFAULT;
>   }
>   
> +static int rec_exit_host_call(struct kvm_vcpu *vcpu)
> +{
> +	int ret, i;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu->stat.hvc_exit_stat++;
> +
> +	for (i = 0; i < REC_RUN_GPRS; i++)
> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
> +
> +	ret = kvm_smccc_call_handler(vcpu);
> +
> +	if (ret < 0) {
> +		vcpu_set_reg(vcpu, 0, ~0UL);
> +		ret = 1;
> +	}
> +
> +	return ret;
> +}
> +

I don't understand how a negative error can be returned from kvm_smccc_call_handler().
Besides, SMCCC_RET_NOT_SUPPORTED has been set to GPR[0 - 3] if the request can't be
supported. Why we need to set GPR[0] to ~0UL, which corresponds to SMCCC_RET_NOT_SUPPORTED
if I'm correct. I guess change log or a comment to explain the questions would be
nice.

>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -168,6 +188,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>   		return rec_exit_psci(vcpu);
>   	case RMI_EXIT_RIPAS_CHANGE:
>   		return rec_exit_ripas_change(vcpu);
> +	case RMI_EXIT_HOST_CALL:
> +		return rec_exit_host_call(vcpu);
>   	}
>   
>   	kvm_pr_unimpl("Unsupported exit reason: %u\n",

Thanks,
Gavin

