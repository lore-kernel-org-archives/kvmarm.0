Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B661EA80
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 12:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746015083; cv=none; b=e3E+/VDPm9dS7a5U4ukRvIgseX67oZ4TQvwm8Hk4XVwA6+lkBWQgLLUHJNEu+QsVrcNgIsZ87mTeEJrVgyue4bN1tzxoxTG4tXYRAqppp7qvxToyP5/PFrUspxhyOy2n34jI3atE25+S/ZiOWqy+lnZ9jo3t3kTXEGOmSn7TOCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746015083; c=relaxed/simple;
	bh=WBVwmUGhNQeqSG1wEq0pfwpkL0pYYhpZqSLVK9JWP60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YRiWZq6tyYACdHze5OXY/4hYi6M/N1cxPldGNBB5Pz8o+sDZ0bwCqMzpK0zmo53P8lYLMVYdqRTps8mp1pxECKy9pZywX3K/xOXrISlFXi+Ov9gSrUh7PGJZI/O+cCZuzKjKXGtAD6bflWooCE3I0lrHs0Du9bjAJCjpAj0YMSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AD9ZwQDi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AD9ZwQDi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746015080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7tFgFXzqc2ivrCQjcqTMjWCPkQCLYsEDRrk0U+aYhgw=;
	b=AD9ZwQDiw12pJ4/0qBFC0KYKIY275yb2X44z9HbIgp7HlY5DmTSsRRDxdraq4Ui2EztyY/
	oOGPOt6ijRTV18Z5Fp+eSX97nIgiVdvVI38rnF5wNZbPJ0Sr5lPZl/iR9bHsZf9tXu6YCm
	BG3ptSO/YFU/yQZDKDmj7IceVcVXaGY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-Cj79jUSmPZe4-llIKAUDGg-1; Wed, 30 Apr 2025 08:11:19 -0400
X-MC-Unique: Cj79jUSmPZe4-llIKAUDGg-1
X-Mimecast-MFC-AGG-ID: Cj79jUSmPZe4-llIKAUDGg_1746015078
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2242f3fd213so61373595ad.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 05:11:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746015078; x=1746619878;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7tFgFXzqc2ivrCQjcqTMjWCPkQCLYsEDRrk0U+aYhgw=;
        b=IObzBSecNfU/PkD/D4uRmNIfhEjwgqYi3GO1Rg9YBKaZ2E64/YuPV4Ndhwtp7zLm3z
         V8THOwJtYBfcHr0/t0kgtWvBjSiHlzS+T+nG+8+jBx1/UBT8vrgxseMLyPpPTNDsNvEr
         fN0dYl2/XRtT86unrmtl3s/AeIOkF4G+vqgunCbXMaXh1LjuGtasfZ4H35BhaEHGdvmx
         7bdnHJF2vPE6SObvHpMipLA50N3Dw/NJYvwEnbuRH0T9VeS+GD/nMFIfjG3nfT3hnJm/
         PNGOJk+RQuChNr7V21D24YpoGYgJdcrpYKO3ydq3up7GydsequULMrpRdt9qIWtjdYEq
         dLHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs6fTCmaabz/X/Qkan+CfE/tq7pnRnrnljhd3IxDQI45yFi5ModOGwqq4w3NJTQK0gzSe50W4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUfUtZzbEj7vguP/E/28UmtA0jB6ljqIPPTpeGHT3jeLpctx1G
	GcoXFBMXqHuEYsJWnewisys/oGrUkjoXu1a62TRYWCDc1Jiop8PISiQVdu346crqOLKq9s8Vavr
	BFYcxFA4EyRDKyicGJEsKeaqDjrsdIsJbsE7yWrku1kLBWMyZLeVXNQ==
X-Gm-Gg: ASbGncvFB3kYRP86iavu1KgO1i9oSxYEPjeSilW3N1bWYDyeIyMdXZ608sFJXCmZAci
	UEfkRZwWUsqw8jiEz7j/sjkvybMjHjundcIe/GN8pMhcMBtONElymIShmTt5zUs2U2Umr04o2se
	DWxwRag98nvgeXdLmgtlDoC0qqqR0Elvx9jxqeI/Vn80YTw6L8KKcAFrCMaJATuWQ9/J0cFiegq
	atC8896g45n7ljHfyzdq3ekDw0JYDC4Un9hxr6qrRYeCQlP+HH+Vhfqt2kbXwT+3dxNn+BZ9tvo
	44nNvJWtEkuW
X-Received: by 2002:a17:902:ebcc:b0:223:f408:c3f8 with SMTP id d9443c01a7336-22df578bcebmr38849545ad.14.1746015078599;
        Wed, 30 Apr 2025 05:11:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHL6LT3h1gUo31SZA1COwvt+3Fy8+QNcJQ2pDlfoosU3yDt8W0PlDXI1jufTia5Y9HcVnFrHw==
X-Received: by 2002:a17:902:ebcc:b0:223:f408:c3f8 with SMTP id d9443c01a7336-22df578bcebmr38849145ad.14.1746015078260;
        Wed, 30 Apr 2025 05:11:18 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50e89acsm120641205ad.113.2025.04.30.05.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 05:11:17 -0700 (PDT)
Message-ID: <b5770d9b-4f17-4be8-95a7-1549322debb2@redhat.com>
Date: Wed, 30 Apr 2025 22:11:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/43] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-18-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-18-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hAJ_ldVyMG9Ht-K3_nAAyl0OLsT9P6188h2M7loz3DE_1746015078
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> The guest can request that a region of it's protected address space is
> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
> RSI_IPA_STATE_SET. This causes a guest exit with the
> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
> protected region to unprotected (or back), exiting to the VMM to make
> the necessary changes to the guest_memfd and memslot mappings. On the
> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
> calls.
> 
> The VMM may wish to reject the RIPAS change requested by the guest. For
> now it can only do with by no longer scheduling the VCPU as we don't
> currently have a usecase for returning that rejection to the guest, but
> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
> open for adding a new ioctl in the future for this purpose.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Rework the loop in realm_set_ipa_state() to make it clear when the
>     'next' output value of rmi_rtt_set_ripas() is used.
> New patch for v7: The code was previously split awkwardly between two
> other patches.
> ---
>   arch/arm64/kvm/rme.c | 88 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 88 insertions(+)
> 

One nitpick below, either way:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index bee9dfe12e03..fe0d5b8703d2 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -624,6 +624,65 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>   		realm_unmap_private_range(kvm, start, end);
>   }
>   
> +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			       unsigned long start,
> +			       unsigned long end,
> +			       unsigned long ripas,
> +			       unsigned long *top_ipa)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	unsigned long ipa = start;
> +	int ret = 0;
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS) {
> +			ipa = next;
> +		} else if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {

--->

> +			int walk_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			/*
> +			 * If the RMM walk ended early then more tables are
> +			 * needed to reach the required depth to set the RIPAS.
> +			 */
> +			if (walk_level < level) {
> +				ret = realm_create_rtt_levels(realm, ipa,
> +							      walk_level,
> +							      level,
> +							      memcache);
> +				/* Retry with RTTs created */
> +				if (!ret)
> +					continue;
> +			} else {
> +				ret = -EINVAL;
> +			}
> +

<--- This block of code have been existing in multiple functions. I guess
it would be worthy to introduce a helper for it if you agree. Alternatively,
it's definitely something to do in the future, after this series is merged :)

> +			break;
> +		} else {
> +			WARN(1, "Unexpected error in %s: %#x\n", __func__,
> +			     ret);
> +			ret = -ENXIO;
> +			break;
> +		}
> +	}
> +
> +	*top_ipa = ipa;
> +
> +	if (ripas == RMI_EMPTY && ipa != start)
> +		realm_unmap_private_range(kvm, start, ipa);
> +
> +	return ret;
> +}
> +
>   static int realm_init_ipa_state(struct realm *realm,
>   				unsigned long ipa,
>   				unsigned long end)
> @@ -863,6 +922,32 @@ void kvm_destroy_realm(struct kvm *kvm)
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
>   }
>   
> +static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long base = rec->run->exit.ripas_base;
> +	unsigned long top = rec->run->exit.ripas_top;
> +	unsigned long ripas = rec->run->exit.ripas_value;
> +	unsigned long top_ipa;
> +	int ret;
> +
> +	do {
> +		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> +					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +		write_lock(&kvm->mmu_lock);
> +		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
> +		write_unlock(&kvm->mmu_lock);
> +
> +		if (WARN_RATELIMIT(ret && ret != -ENOMEM,
> +				   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
> +				   base, top, ripas))
> +			break;
> +
> +		base = top_ipa;
> +	} while (top_ipa < top);
> +}
> +
>   int kvm_rec_enter(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -873,6 +958,9 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu)
>   		for (int i = 0; i < REC_RUN_GPRS; i++)
>   			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>   		break;
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		kvm_complete_ripas_change(vcpu);
> +		break;
>   	}
>   
>   	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)

Thanks,
Gavin

