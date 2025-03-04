Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596BE1F4299
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 04:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741063989; cv=none; b=FLjVFNXfCPvXjhSVT5Z5rYmpWN7tNMrDFFpax9BQCyXYEX2kqjbJF0P0GAL7VUKRbZwHTFGDOm0Rht+hdlzf9EMJyEAPQfBstIG6dsAYzZnOe1dFWmeivW+fT9Qh4g6d1Lj0oP2G8MH0C+u96Z2KjQ9k9F0OebP2EVjA/h1vrO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741063989; c=relaxed/simple;
	bh=zfjVZcx2cE/z0JCBIXKs0CNEtspZuks9Gv3CVhRkmYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUeAfuNKjIxCSgXMPzjbTwhfyGwt0slqNwrEKD6flg4G3Tb8cykBgwnAhE4MzjtEBDfbYMgDJF+FnyOi0ZZTLn7ffCmZ71TmnYACGG0VUnkof1gqWUotVyDHn2+Q2IMXzhTVodmO12KvHymn/J2R6fX18ZLUQKXxB7ZsWWaFokY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SrMg1k52; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SrMg1k52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741063985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AxELm9JZG3yKkBZZ33qtCi2pLAO/qCPDSQRXT6O3LAA=;
	b=SrMg1k52UIvGcqWppj/DAp4Hh7x2xiofTTFSOjHkD8XApA/2SpW4WMCYk6YBlML8q67d5U
	MNk3utNOyqY9v7xa0YflP6L5xjupNgtDrISDDMSqklVBn8vBlQgD9ZO1kkLGurUY7VIfYE
	uT9BDtQPUglMv3/RP5Dl+y90OOcmQ4o=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-3zcc6mlfPEm1mnk9Sc7AHw-1; Mon, 03 Mar 2025 23:53:01 -0500
X-MC-Unique: 3zcc6mlfPEm1mnk9Sc7AHw-1
X-Mimecast-MFC-AGG-ID: 3zcc6mlfPEm1mnk9Sc7AHw_1741063981
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2fe9527c041so10423861a91.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 20:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741063981; x=1741668781;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AxELm9JZG3yKkBZZ33qtCi2pLAO/qCPDSQRXT6O3LAA=;
        b=S6u7JHOQK+KPixKFgus8ucAOS441wOM8ndOaRXN+XZ2N+XZAuOVgI/eBhP5LLNSft6
         UYYDSRC9AvqCwzLpmDePvOAAiJx89fUjJPzI13tDm27y7ukMMMahgEAAs/gPqhenZME6
         J7XO7mX2SES6EDKtzKh6WVJO9l8OdmtemPY76933T2gvSxW+cYYcD4ur4MhPgo1G5UPd
         sJCGvEsaj7AE2xsWIDNJt+XOPZQ7QCGBvjgj54nXr6xBhIkucepThcXzrpHOPU+bOJE6
         aEVozIyHckcnzB0DCef2ZMLwYY3Dy1y85GDc/dfnQ3lBuEmkOjttz8VlYuKwTx3QqvkS
         jElg==
X-Forwarded-Encrypted: i=1; AJvYcCXj0jDxcEmyYqSFPGcx7aLXQiEKtzumUFSAu9KVUjTu22kmpJtl9jWJFROinPwnBoyH+BHscrw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh0GAw9JKn6xpbGC+L/KSmuDEAwvEeHQCSHmcYaU9N0XZDRwrX
	2AeoIAqgu101S6D0WNtWBTawxytElh35tJ94z8/B23YspMcK1ofETEX3FsekXDx1udfdkpgNES4
	wp7jTveiPxlk93RsXJG9XjHOZyKcqZp+ZWV4llNSrs6n/2SckkEbCkw==
X-Gm-Gg: ASbGnctQppSsw1ahX6Nn+zs+OsYfFcaT8cEXvqbz+NNX4q/mG5VFAH/su+uk1AWnYSZ
	CklHCQIBlldjrYz9PDbfIsGJwGIQclb/mByoMmABF8ZF7EIVHPjahUaiIaEyjYWLaSU25P+ApLk
	voaToNW6kdDnMmOUcb06sJ4A7GA1SufstXfoL/Y8/rdsTKC9PH3dfDS4MT7WUoXaVrW7PG27sDu
	IHkQufwd1aGsdYACKyslnA7xuhJjf7dOy/yzGztRXdvn6Vq1Kz5rzWLFGiFry0GFNKLYbyRYcaE
	ZBwvFIeNEwm0lcbc4g==
X-Received: by 2002:a05:6a00:3916:b0:730:79bf:c893 with SMTP id d2e1a72fcca58-734ac33818amr25659496b3a.4.1741063980692;
        Mon, 03 Mar 2025 20:53:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrKK12tR3N+mbAAVfdfQ2dTRLheKip2yCmHrOCAijBgggtR8kRt8J5JVYj+IuDCpb/96NhUg==
X-Received: by 2002:a05:6a00:3916:b0:730:79bf:c893 with SMTP id d2e1a72fcca58-734ac33818amr25659458b3a.4.1741063980378;
        Mon, 03 Mar 2025 20:53:00 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7362dbde43bsm6584335b3a.25.2025.03.03.20.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 20:52:59 -0800 (PST)
Message-ID: <abec92a5-0158-4d97-bfdc-03e805a4c96b@redhat.com>
Date: Tue, 4 Mar 2025 14:52:51 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/45] KVM: arm64: Handle realm MMIO emulation
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-20-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-20-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3w8epx2OkJNfN68cXSO_x1V8io8domPQj0PVdZb6nB0_1741063981
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> MMIO emulation for a realm cannot be done directly with the VM's
> registers as they are protected from the host. However, for emulatable
> data aborts, the RMM uses GPRS[0] to provide the read/written value.
> We can transfer this from/to the equivalent VCPU's register entry and
> then depend on the generic MMIO handling code in KVM.
> 
> For a MMIO read, the value is placed in the shared RecExit structure
> during kvm_handle_mmio_return() rather than in the VCPU's register
> entry.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Inject SEA to the guest is an emulatable MMIO access triggers a data
>     abort.
>   * kvm_handle_mmio_return() - disable kvm_incr_pc() for a REC (as the PC
>     isn't under the host's control) and move the REC_ENTER_EMULATED_MMIO
>     flag setting to this location (as that tells the RMM to skip the
>     instruction).
> ---
>   arch/arm64/kvm/inject_fault.c |  4 +++-
>   arch/arm64/kvm/mmio.c         | 16 ++++++++++++----
>   arch/arm64/kvm/rme-exit.c     |  6 ++++++
>   3 files changed, 21 insertions(+), 5 deletions(-)
> 

One nitpick below, with it addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index a640e839848e..2a9682b9834f 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -165,7 +165,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
>    */
>   void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
>   {
> -	if (vcpu_el1_is_32bit(vcpu))
> +	if (unlikely(vcpu_is_rec(vcpu)))
> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
> +	else if (vcpu_el1_is_32bit(vcpu))
>   		inject_abt32(vcpu, false, addr);
>   	else
>   		inject_abt64(vcpu, false, addr);
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index ab365e839874..bff89d47a4d5 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -6,6 +6,7 @@
>   
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/rmi_smc.h>
>   #include <trace/events/kvm.h>
>   
>   #include "trace.h"
> @@ -136,14 +137,21 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>   		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
>   			       &data);
>   		data = vcpu_data_host_to_guest(vcpu, data, len);
> -		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> +
> +		if (vcpu_is_rec(vcpu))
> +			vcpu->arch.rec.run->enter.gprs[0] = data;
> +		else
> +			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>   	}
>   
>   	/*
>   	 * The MMIO instruction is emulated and should not be re-executed
>   	 * in the guest.
>   	 */
> -	kvm_incr_pc(vcpu);
> +	if (vcpu_is_rec(vcpu))
> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_EMULATED_MMIO;
> +	else
> +		kvm_incr_pc(vcpu);
>   
>   	return 1;
>   }
> @@ -162,14 +170,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   	 * No valid syndrome? Ask userspace for help if it has
>   	 * volunteered to do so, and bail out otherwise.
>   	 *
> -	 * In the protected VM case, there isn't much userspace can do
> +	 * In the protected/realm VM case, there isn't much userspace can do
>   	 * though, so directly deliver an exception to the guest.
>   	 */
>   	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
>   		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
>   				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
>   
> -		if (vcpu_is_protected(vcpu)) {
> +		if (vcpu_is_protected(vcpu) || vcpu_is_rec(vcpu)) {
>   			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>   			return 1;
>   		}
> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> index aae1adefe1a3..c785005f821f 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -25,6 +25,12 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>   
>   static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>   {
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
> +		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
> +			     rec->run->exit.gprs[0]);
> +

A comment may be needed to explain why GPR[0] has to be copied over. The contexnt
in GPR[0] isn't needed by all cases, being handled by kvm_handle_guest_abort().
Something like below.

	/*
	 * Copy over GPR[0] to the target GPR, preparing to handle MMIO write
	 * fault. The content to be written has been saved to GPR[0] by RMM.
	 * It's overhead to other cases like fault due to MMIO read, shared
	 * or private space access.
	 */

>   	return kvm_handle_guest_abort(vcpu);
>   }
>   

Thanks,
Gavin

