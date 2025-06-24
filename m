Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821912512DD
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 07:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750749919; cv=none; b=IwZ6bOQ66pmUha+uC56RxCliJlDpoeYuihikKPSwc+/QYnLq3BijpHVCFAhgJIFXdsiB3xn+P8JtZEv4z9V18BYI48ho0uEli/NWMSEgfyGSX9XNHS+lKBBN/AUWkNcchYD1ZbQB8YtostaxYChykZCxi8e7JTQ6t8nNW/XGEzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750749919; c=relaxed/simple;
	bh=qTT6SpXUX/0g2pQ5HFQSiMgz0tQTApfNyxJ2okysEzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tFvooQqKQSmtvxphPEPKWQZWfAo77sHwOtE2JMfIp1yC8jjXbL4xcyI+OWdtPtTxZTY3bFa+XvMk5hEibeAo/EkFA9FDfCYPLUnNknM/gokN18SloMmCFGbg4M4oBReDgXjpFaZLCzlI3RMaAWX7g7qhgEG95YaDVR1UIdsJlfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SLVekQZf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SLVekQZf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750749915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgRiV0j85PSRtreLAuxfC6pTAXhw9pPRAHrk5ra/5Es=;
	b=SLVekQZfJaZMc3VZ+aH0pytnpWd/hLFCEnvQpU1j+jEzrH8FmjmlYd/1WZD5Gv8Ud5/JZW
	JT7pQK/DWqtNYTAFDbkmBQGr1rn40oNiduEdqVw/x6979IrIsLmCO/4msfCHUGXLYWC1GF
	cU0jAvhFaSersCjPjfuLSfWzpfvjBes=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-AR2Se8FkOOivlNuu94TFpg-1; Tue, 24 Jun 2025 03:25:12 -0400
X-MC-Unique: AR2Se8FkOOivlNuu94TFpg-1
X-Mimecast-MFC-AGG-ID: AR2Se8FkOOivlNuu94TFpg_1750749911
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4535ad64d30so40216765e9.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 00:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750749911; x=1751354711;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgRiV0j85PSRtreLAuxfC6pTAXhw9pPRAHrk5ra/5Es=;
        b=mFOgb2/aAh+aruIp3W93eQupTPmvYECWzZReMk216ZuWYCyYIO8pDV9ZxqlHPJGbMi
         XYBmqNtTaS02czTUKNXxsFonNjzuDXz0fzuU2soHj6CZs7c9nwT1yr2+WV65pROluaW5
         n2b1aN6LrY9X0Q5QAcuNWBrJpuq4Mk5fTvfrFILML7xuOpuNRX+Y+xdFLaXlR3YQjMC0
         wNTnpSY+LAWenftrsTo8z89vO1OA3UWPOAMZ5SBfAK2QBtoOH2XnGRchdPRkyPM3Ingd
         RihBbnzsWsMIhlzwTvcGeuY3bc4EsMIAAGm1wlG9vDeAEJIR7wbtemh2IoFfPZbxENUp
         2s2g==
X-Forwarded-Encrypted: i=1; AJvYcCXrEk2u5/ysmFoKq18qjgKzWiAvxL7/mAN0NKMUyrkHJVW1Ne/UnLfPzTPI80gy0Xpi2+NeHNg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPgXqFvqv8ucKPg5Cixhk3g2ID/xR9BrwvxMQmAxVQnMuABGhO
	ThQN9aJNaMbIjF7aaxizwbJzDE66huk/G8nXAQEKKJVJiO8WLyGRxqC/3xQHdbf52KAtk2j3BVx
	i9H7LvkAiT8zvcYZLIFtkc4/d6BxN2Ao4bB/i0rgLx7Il4Z4fQTauJjxPPQ==
X-Gm-Gg: ASbGnctPmhdlBaPRFvFRPt1HWiU3wx33FUb9vbLvb8vDTDfZNpmTFjvIFDd/cE/cZ3E
	uWkb74kQJVwtBlsMGoOMaoZ26ZPOM5fE4PhfmFjOUULXHMC1nv9O386uNjdpE+iheX86FDKkw76
	kLKZSknRPCJhdpMta6gGAGTLplUT6h6TbUBXF8YqJit/nO5PiqvzlUCQ4771JM4S02CTzrtYXOy
	DXovzYIi6uYTs5CU/nZPJqZCktOXa/O+MOBXK0+vA00lOvPM68WzLinJ3vu21oeCsgxPA+ZVu2B
	aioAVTFdPuFKjHyaDO4tEcn7v3urWm9I6GHHM9nqMhLamc4EphCqv7M0n49Cmb7D
X-Received: by 2002:a05:600c:c168:b0:43d:9f2:6274 with SMTP id 5b1f17b1804b1-4536c253eecmr103886365e9.14.1750749911273;
        Tue, 24 Jun 2025 00:25:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2um9Qis2AN3HWQ37ati9BBnYWI6SS4ICJEoxMmUlVQC8nuNq4Mjr5VoRjvDjjSGN48+TTXw==
X-Received: by 2002:a05:600c:c168:b0:43d:9f2:6274 with SMTP id 5b1f17b1804b1-4536c253eecmr103885875e9.14.1750749910798;
        Tue, 24 Jun 2025 00:25:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8105f93sm1186791f8f.76.2025.06.24.00.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 00:25:09 -0700 (PDT)
Message-ID: <5e22442e-ddf8-4f5d-b7e4-5e2c9bf783b0@redhat.com>
Date: Tue, 24 Jun 2025 09:25:08 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KVM: arm64: vgic-its: Return -ENXIO to invalid
 KVM_DEV_ARM_VGIC_GRP_CTRL attrs
To: David Woodhouse <dwmw2@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Jing Zhang <jingzhangos@google.com>,
 Kunkun Jiang <jiangkunkun@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Keisuke Nishimura <keisuke.nishimura@inria.fr>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <bbbddd56135399baf699bc46ffb6e7f08d9f8c9f.camel@infradead.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <bbbddd56135399baf699bc46ffb6e7f08d9f8c9f.camel@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VLH3Ji2vdCVsVzIrTlOTwJhbgLucebqs3Eb3KwAQhcg_1750749911
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi David,

On 6/23/25 3:22 PM, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> A preliminary version of a hack to invoke unmap_all_vpes() from an ioctl
> didn't work very well. We eventually determined this was because we were
> invoking it on the wrong file descriptor, but not getting an error.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
In the corresponding doc (virt/kvm/devices/arm-vgic-its.rst)
it is said about possible returned values:
     -ENXIO  ITS not properly configured as required prior to setting
             this attribute
which does not exactly match your situation. Shouldn't we also update
the doc or change the returned value?

Thanks

Eric

> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 534049c7c94b..b34f8976c9cc 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2694,6 +2694,9 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
>  	case KVM_DEV_ARM_ITS_RESTORE_TABLES:
>  		ret = abi->restore_tables(its);
>  		break;
> +	default:
> +		ret = -ENXIO;
> +		break;
>  	}
>  
>  	mutex_unlock(&its->its_lock);

