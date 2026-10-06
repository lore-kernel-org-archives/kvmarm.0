Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540B91C5F27
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791256634; cv=none; b=YdIqBlKHq6LALzDzto/EGjG83eU787jbgMCqTjibRpHr81UgFYogCHKYH1leMqkivL1Uqtp3FvDBmkZDkQVKOLC0nPPz/+vLdkr8X/8/1lC2njCPqKduFDyRXhIuMmOLJncpMF/QiaGkMDNs7a6zN7kfrSQOxo21N5/eDuvC3as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791256634; c=relaxed/simple;
	bh=OCwy2T21o6KZK5vUec+S24BqJgmIfSohdnltBRqhZh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qFJHROldR4rpGM26rQeRmPUH3bfxUitD91odbCRPR+xx85qrSaRMiempBVjkK03rENqyJVvURI/X4XiKsB7AmVkeoN2wr2bzcN07EG1JczIJf5tM6IeJB/LVnH+b1HBEZE3Xn5v8IDTu9DwZvA3ufVIts0ZCHz1DTquOQ8qZQ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JmRa6+pG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JmRa6+pG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791256632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmIEoaAK9H0I/DObf/8+7Lpe62dBXA5oIjHsrjeoKTg=;
	b=JmRa6+pG+IfDsTB9eepNfpqWczkdHGUdGggMTuKdZCcorkxOVQklsIna/sgOlxYcPNymWc
	ddHuqZo1Xk8cuGs9GxmKRpWVNOv98I1IGdxmE8HJfPdGLKK0MzyGmN9xX5ZAgC+oO+Du4+
	DbQmt6Axb51VYKrsTbJeQjyFL7Ot74I=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-wBkpmHDONAyF0gPcXLjsnw-1; Mon, 05 Oct 2026 23:17:11 -0400
X-MC-Unique: wBkpmHDONAyF0gPcXLjsnw-1
X-Mimecast-MFC-AGG-ID: wBkpmHDONAyF0gPcXLjsnw_1791256630
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc4ac5feaa4so1898562a12.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791256630; x=1791861430;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmIEoaAK9H0I/DObf/8+7Lpe62dBXA5oIjHsrjeoKTg=;
        b=N2JYIQar5+ZZTpEbsrBYy0l10wN4KATt7CpgUF2xpkZZXqbd+8dwrnLUFmbbXhWNKV
         1sclgvT8G8Qn6YSgCL+Ugkwy+zxCAZAtX9rz7J79Tn4sFXqhXV71P2d6d2B1uJUPb8tI
         lWT24xQic6GZGgW+m+O0J9m8UQHVqZJQNXNuaOfrLY1qVJLj14JnRoUU98+/fUQ1pgyB
         kv3qosgif6c1P3MZ8fqPAZzpEWWUlqdcKaJp4O8x9I3PRd1OumoP2FLJ3gPKFqRxdU6g
         NvtMwIl/PAT/r4tan/DjGco0sknx3IgoInIH2UYbH0sEbduy2D0/wuBx7vFhcOcfhwqx
         zx/w==
X-Forwarded-Encrypted: i=1; AKwUvBwtKiXRWANputJpRQgoZuGFGf8YpzD+jrq/Bys3SVIoMYIVuK/MPww8OW2DL0OiJzHH0cxxX50=@lists.linux.dev
X-Gm-Message-State: AFuF++lsZ1hHuUY1iir96ouCMschce1Li/17FUQSqZpJlkM7DM5HadcK
	wkwJGTFYPJqjqI2OwVe/LlpgEM1OoMLUzPwxihcfbDTZqwNJaqAAGL+NRn3i1tMpNrw9dT+99e8
	vg2BrdYHg/whmXDudkgMIjn0yFdCxHf9vcfY7ul/XN37fDcJUmLeN9kMk8Q==
X-Gm-Gg: AYBFou2tQ/gkrB902GEqYX6hLIjLADcdT3OTJYnJVray/fTGOR4yDibqaOTqJerOhSe
	bnW6g6e3fL4IB+619W6ytzmfc2QUmJw4UtR7j1ILu2qMjS/SQXO/0ZpmXAY2dnLuhch3rfT/49H
	WxRKPBqYWlUgXP4KtCJsGWVQ55LNWu/Bgl66SNgmeHmtyczyD73RVBXHUEJw2ZLBRNC0sTbLciT
	QlURQ1idkAHG0gUFvk5GQoPbgh36IJKr5mTl4DdTkbAhqsNGXpZFhT6M4VUeBgD6ha3WKM1W926
	2o4KDX9pEyjaWqHulbC7JNuuHix1jl7ypU6W5HxpHeMXyQaIEyMvDpfoHVXE3FPC7bdB9ONcTIs
	OFKbRn4O2RLaTTTs6xDvnGATwgqd4YoQLG65yO8aiew==
X-Received: by 2002:a05:6300:6698:b0:3de:7bd5:fb47 with SMTP id adf61e73a8af0-3e12474463bmr68482637.39.1791256630139;
        Mon, 05 Oct 2026 20:17:10 -0700 (PDT)
X-Received: by 2002:a05:6300:6698:b0:3de:7bd5:fb47 with SMTP id adf61e73a8af0-3e12474463bmr68459637.39.1791256629711;
        Mon, 05 Oct 2026 20:17:09 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6b358400sm1870050a12.4.2026.10.05.20.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:17:08 -0700 (PDT)
Message-ID: <fdc81d01-27df-4557-80bf-80d4527e4bf2@redhat.com>
Date: Tue, 6 Oct 2026 13:16:59 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 16/23] KVM: arm64: CCA: Add VCPU load/put for Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-17-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-17-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2xJTu6YNvAiEYOOYLxczOrTdzAzLlBEpo_32B2KNyGA_1791256630
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> RMM controls the VCPU settings and most are hidden from the KVM, except
> for the VGIC and timer bits.
> 
> A later patch would add syncing the VCPU state into the Realm REC related
> SMC parameters.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6c81fec35ecec..294cea4cc8271 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -802,6 +802,13 @@ static void pkvm_vcpu_load(struct kvm_vcpu *vcpu)
>   			  &vcpu->arch.vgic_cpu.vgic_v3);
>   }
>   
> +static void realm_vcpu_load(struct kvm_vcpu *vcpu)
> +{
> +	kvm_timer_vcpu_load(vcpu);
> +	kvm_vgic_load(vcpu);
> +	vcpu_set_wfx_traps(vcpu);

Why we need to call vcpu_set_wfx_traps(), which updates 'vcpu->arch.hcr_el2'? I don't
see how 'vcpu->arch.hcr_el2' is affects realm in RMM. Could you please explain in the
commit log.

> +}
> +
>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
>   	vcpu->cpu = cpu;
> @@ -854,6 +861,12 @@ static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
>   	kvm_vcpu_pmu_restore_host(vcpu);
>   }
>   
> +static void realm_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	kvm_timer_vcpu_put(vcpu);
> +	kvm_vgic_put(vcpu);
> +}
> +
>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
>   	vcpu->arch.vcpu_ops->vcpu_put(vcpu);
> @@ -2213,6 +2226,11 @@ static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
>   	.vcpu_put = pkvm_vcpu_put,
>   };
>   
> +static const struct kvm_vcpu_ops realm_vcpu_ops = {
> +	.vcpu_load = realm_vcpu_load,
> +	.vcpu_put = realm_vcpu_put,
> +};
> +
>   #define KVM_VCPU_OPS(flavor, ops)		\
>   	[(flavor)] = &(ops)
>   

Thanks,
Gavin

