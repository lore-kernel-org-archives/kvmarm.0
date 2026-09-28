Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA93F3546C4
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558592; cv=none; b=b6zKTKqe2WMZ6Zwr4B2vYRTQ24KqKa8hi7TxTPl27Ijkqa9zfJzuYD4ERoRfLLsP+RBIAV9A21YevsiNYVnGTElnF+CTZDshZO8cl4P+oZsze5F6NXi5FGed9FohVXThiN3ENhS4a7Egzn4HTOmeNHbSFFMXfk8ritXU3fgTUas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558592; c=relaxed/simple;
	bh=tzexRqC3K2iiEzwQnm+LnN1j4dKGRAhl6MlLFdP0ios=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KFPirewqw6wcB8OtNsX6AadqBjvjYVwxLHf1a72ylJj2f8hQCg0Z+clpG+cVORHIOPiQ5bxDlNvbW1sBwWGL/y1DZSlBT+cTMVgwQp7bslc8PRvA2REvyivkIzAbAu4bsQtbyZ42xYFx7Brz7tIZVmgsA3JPMXD6eWRjCMWwNTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ru5i35tE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ru5i35tE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790558578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYhWmKK3WxSPtzfylUKK2UiUNGYDraSdFFrlfHKnCEc=;
	b=Ru5i35tEXDmkgV8tIXcVJcgeQ+ICug4ushZ/np5iPuPZrriHoN1zlhSR76otIzbPii+D4r
	pv42Md1yKW9b2fR7X7Gfg7kK/MfoazyZnBcbZrsHmGWhZgE5fD+vhBbwf2W50q1c0WKnU8
	oHacku+kZLJqD8OO/VNJxJZc5i4xdLI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-GTBLI2qxNBy5D9WlnGjDuA-1; Sun, 27 Sep 2026 21:22:55 -0400
X-MC-Unique: GTBLI2qxNBy5D9WlnGjDuA-1
X-Mimecast-MFC-AGG-ID: GTBLI2qxNBy5D9WlnGjDuA_1790558574
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3a0ad137e87so3995007a91.1
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790558574; x=1791163374;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OYhWmKK3WxSPtzfylUKK2UiUNGYDraSdFFrlfHKnCEc=;
        b=pi3Ni/2IgtkoOvj7+0/hkFs50N9giS0pOmRspa7CrsoUdiPyrHLHDmnqaMEkTnMOuM
         zJ6zTnx1V5fY+1E2cfxgWZVwlwCE7vUrvOvZ0xT4Wo25TZx2ywMnFWaYB5hWevuMNx4D
         8nErxyS78owtGJmamrFaJRh4R1KQGAX1sJ9dwKReIqUZAtq7REZozkpyasZnvY3U5wN6
         eAEKWBdiWcBBsFNisCfDbGUCYhky+vTBL/OC/EN4KxExcIUa+7sFYLb9T1haMZMrge7S
         4TMTazKLMwDzJQgReb0EBm6v5wVRi/N3Lc3b2bX8rQUDKpSMSJHWEWXZ4381VcRRymBp
         J3Fw==
X-Forwarded-Encrypted: i=1; AKwUvBzSZEQt7jb/LaY9TpCW0NlYJW6dknQ0uLeuhuWqF1cStzE9JWvVjOC0sVvefpE01Y5MZ5l9pag=@lists.linux.dev
X-Gm-Message-State: AFq9FYIOvgYbzC++OBPR3ZgmuRZtxs5epuP3AC803vlwdVfn2VgprXMC
	c+3W/zaysx0WoLSh9+gZoPDaG4ESw8IXBON9tb0N7z2ryMoWHU1UEywuO5UVwAGg1Y/llLsKY8t
	ndkP5SUoNOq9Of5ROXg1bMupMjmDozQgvEUIf7HAqiDaBu2N/GqVRgvNujA==
X-Gm-Gg: AYBFou3OE0uCCzhnAIP4LAWqdEx2Z5i4ey9lS7f7f5zKPX0phU99ejnPoJzG9+QSxsF
	F3IvwXyRdNxCc1PdX3x51C7W7QGcz+Mlux5zPYYjYx+sSXDrPABLqwGJRfFMrs3KgJdb+BCg6Y3
	FSOydgbDwP/TcNF/Nk+a4nXugL1HJTE5FDZ7lggxhcMIyOmnBY2AXTr9Rg+EAsHM1p53bBJ3m5a
	4CKaNDTzklE2HR0EZhUEwoVQCBg3zxOP/ikCbmxYmygXX/SbBCzZ1+ED1JhfxxKXpjcsvqxGny7
	YIYgSwF+z4J2Da3q1GHiMXTp6gyKMWpp9biHJ6b9fClna7Sf5DAdQh3bi6rwh+3uLZtlSH73ntg
	pW3fK1JOKxRe/NOIFXNxaRVMMa3P3ibg6uSrP9nNBZQ==
X-Received: by 2002:a17:90b:3c8e:b0:3a0:dec0:c0d2 with SMTP id 98e67ed59e1d1-3a0dec0d44cmr4614958a91.63.1790558574360;
        Sun, 27 Sep 2026 18:22:54 -0700 (PDT)
X-Received: by 2002:a17:90b:3c8e:b0:3a0:dec0:c0d2 with SMTP id 98e67ed59e1d1-3a0dec0d44cmr4614925a91.63.1790558573861;
        Sun, 27 Sep 2026 18:22:53 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976c8f8dsm24238968a91.12.2026.09.27.18.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:22:53 -0700 (PDT)
Message-ID: <e63e7972-f099-4e5f-a2cd-9b87b8d6220d@redhat.com>
Date: Mon, 28 Sep 2026 11:22:45 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 13/20] KVM: arm64: CCA: Add VCPU load/put for Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-14-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-14-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -uNnRDKPvvXvQzLSgI9GboqLGL8VN0K_1iEcu9J1TJc_1790558574
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
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
> index 0e2ab5311e4d8..bcc274df2a915 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -795,6 +795,13 @@ static void pkvm_vcpu_load(struct kvm_vcpu *vcpu)
>   			  &vcpu->arch.vgic_cpu.vgic_v3);
>   }
>   
> +static void realm_vcpu_load(struct kvm_vcpu *vcpu)
> +{
> +	kvm_timer_vcpu_load(vcpu);
> +	kvm_vgic_load(vcpu);
> +	vcpu_set_wfx_traps(vcpu);

vcpu_set_wfx_traps() is updating HCR_{TWE, TWI} field for vcpu->arch.hcr_el2.
Could you help to clarify those two fields need to be updated here? :-)

> +}
> +
>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
>   	vcpu->cpu = cpu;
> @@ -845,6 +852,12 @@ static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
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
> @@ -2202,6 +2215,11 @@ static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
>   	.vcpu_put = pkvm_vcpu_put,
>   };
>   
> +static const struct kvm_vcpu_ops realm_vcpu_ops = {
> +	.vcpu_load = realm_vcpu_load,
> +	.vcpu_put = realm_vcpu_put,
> +};
> +
>   #define KVM_VCPU_OPS(flavor, ops)		\
>   	[(flavor)] = (ops)
>   

Thanks,
Gavin

