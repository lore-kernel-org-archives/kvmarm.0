Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122FC1D47C3
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 06:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738478517; cv=none; b=VBPA6uiBu/zaknbBBTZG2KuMHC0yVSdoXyFLYJr1o2UC5MgEVeAoZaqM+evjC+kY+w/uyGzPgz9+ASdnwLSRU6ipweYjj0OhJYup2hb86MiN8w0MV442UB73T1kdkyRkbT9/HUdYRch9+wd62oSDJyrrGdVxTDCl77viTsfvQT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738478517; c=relaxed/simple;
	bh=wSTLzGhMLffhO/v6hJYaRpeR5d/1GKbHdC9MlbN+LvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mV3PL5k91x7PaQ9eTGP76aKJfxhXIc1ENUmunvZrRbdEsVPU9Jp26Bt70GE4XPdINhanBHWPdB+HKw670jlSHdgAezQcgruy4Stqv4Cd+9k3iHVjtNSiTWxNWhQ/OF36xgFF85wmNd+r5qUm7xe8nyWjkvodYCNenBeuQ41HRzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YKAQxyXJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YKAQxyXJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738478513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O9bc7QlURY2KqxOqSdcgXWV1nxuIWVaexteEdP17afs=;
	b=YKAQxyXJzy7Oz3kx1bT51cjJjtdmLL6cMJ7PWwq9c0IpZdJYLiP6TCyHesePlfH5WWcDaN
	F+hXKBreEhnY08/czhSd+h46CnETwIn0oD6ni97Z1zCzJnVUvQPGZOO32vtmzrIxUasSr8
	sgxcszAlrDU3GxcARtoGW2HLCGy00Zw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-WZ3MCGUNPAylEPs-m6qxOA-1; Sun, 02 Feb 2025 01:41:51 -0500
X-MC-Unique: WZ3MCGUNPAylEPs-m6qxOA-1
X-Mimecast-MFC-AGG-ID: WZ3MCGUNPAylEPs-m6qxOA
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-21681a2c0d5so59570735ad.2
        for <kvmarm@lists.linux.dev>; Sat, 01 Feb 2025 22:41:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738478510; x=1739083310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O9bc7QlURY2KqxOqSdcgXWV1nxuIWVaexteEdP17afs=;
        b=uCyyr3fR2qeWs47a9rSfEQir2SV2SLal7FyS267q8p+yTvlHfLhPKY6ZkcE7a/WmjY
         R1wiU0bZZAiFoW5S2w3uWcyotXFJmL5ASaCiF40i4F2zl+AgJTEMz3LXdoBP5z3ILKAn
         QtRgMEHXnIQnWBpc0HfLXyKOGn6w2PNuiNCtj/TePdiH+VWVHzCi1MMFBUoM8MV8Cder
         EHPBVCXujzC6V/dSkh1Kt4741IiSxokG+ZFEmvcTTnI4M7IYRIBJkvx8Z1BW344x/FZB
         fXujcNW5U+eUuULHggDfxk7g02pUuIoCTVLHAyHAVsRQc/LrKRIoAX7pIVNKskQxOPV5
         G7Ng==
X-Forwarded-Encrypted: i=1; AJvYcCWAV4fbuWFD9diLxzheW2rPCDnBHyIPkcTZ9ckflq/rBVWEFDUQOUv0oVb6nA4IEhHhjdgIU74=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwbxkaMbCZyQlhB/LxI70/3cqb7ghhJyy58imdtxI1eqB+HRBb
	03xfKaKFiEZmAvkqX6a41sU383aygWHMDcyBbWadECH8WwP1qHsVA1Z/blWNFk0NK56X+GYxuMl
	ukigOQ5cUpU5XcYZH4t3J8D6mlkF7Trd0vLnCHk9ZXbckQsaBHxZ3xQ==
X-Gm-Gg: ASbGncubvvUeYf7gpwg3B1fuFzRUu5OlcSMv13FjkQInYHx3kq8GPsvJJ31rASUtCUf
	9CFEe/qqWRHPt+C/82Tm061J6SZyZoBLyrkovLYsoZ6ruT0t4d7Vd/UIeRluld5JalPV3YzUakD
	uw22eLaqp2ax2KT7FZdJ5nvByebN5QHBotl40+poR3yS/NV4FW3j3cmM8qnZ1s0DTcntfsXuxCS
	TDzx5hGAzZ9eqY6oZ7/bODGEfafrkomaP3+dlaAAQ7Zc1k+UTC6e2fgHFiTXXkF2zaQzchBlv4A
	2hborg==
X-Received: by 2002:a17:902:e742:b0:215:a97a:c6bb with SMTP id d9443c01a7336-21dd7c65891mr279349365ad.12.1738478509998;
        Sat, 01 Feb 2025 22:41:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEgiNqSMRe7eOLK7UU7yfr7SRk/XUpHiWVSGyN9DA4ZXFp8THxJ4DGREQDo0HNpjoMWa/PKyw==
X-Received: by 2002:a17:902:e742:b0:215:a97a:c6bb with SMTP id d9443c01a7336-21dd7c65891mr279349065ad.12.1738478509619;
        Sat, 01 Feb 2025 22:41:49 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32efa0csm53772495ad.116.2025.02.01.22.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 22:41:49 -0800 (PST)
Message-ID: <69a424e0-1350-484c-9ce7-b40c4fcacd8e@redhat.com>
Date: Sun, 2 Feb 2025 16:41:40 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 27/43] arm64: rme: support RSI_HOST_CALL
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-28-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-28-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hC4Z5z2bPYcZkRsn_x4aZwESdMqX23xrewjrjcyxygI_1738478510
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
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
> index 8f0f9ab57f28..b2a367474d74 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -103,6 +103,26 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>   	return 0;
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

It seems that the return value from kvm_smccc_call() won't be negative. Besides,
the host call requests are currently handled by kvm_psci_call(), which isn't
what we want. So I think a new helper is needed and called in kvm_smccc_call_handler().
The new helper simply push the error (NOT_SUPPORTED) to x0. Otherwise, a unexpected
return value will be seen by guest.

handle_rec_exit
   rec_exit_host_call
     kvm_smccc_call_handler

>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -164,6 +184,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
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

