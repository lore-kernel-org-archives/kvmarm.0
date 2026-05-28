Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236E5279334
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 05:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779944609; cv=none; b=gM5/RF3mBBDmdpaTFmhhX/e9a61HHMVYSvBV3blXQoPbT6Cf5FLiws3VEZz2M/ukrWCn9iBm9ifVfxaH8SJcHMsn/yizdWPZIw+4U4OGNb2AQyMEj5cILLOyj3D7Y0DbB2IIDZ793WlIN5PEWWTZ2OKr2NGMTsUYuan+xqd24co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779944609; c=relaxed/simple;
	bh=c3M2wwVK8Ko3wWXtJq5scLGJOnS6c3GEbbCzhOP8rPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NR2rI8M1LGAb9A2aXw3y5OZA+qqy6qZbWz94J0hiuPIcTpOQZBF8U/xf1r39bJa/nZsJ/pqIXYqIcNczQNiyfkL1GqhhL9gq4jvFIJFihatJn1duSZiRUohSlsd9X71RObOiQKxDCjmqemkOaQrU5z7RccSg9obtkFdrj2UkNuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TCRS/Yg/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TCRS/Yg/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779944607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UqvCi0lCynTmviHWeEa7hB9XA+pHd1N3wbumIZfeiYk=;
	b=TCRS/Yg/OTfSo9NmMMzXQV3aSzMKZ4yrfRaE5zr3yKQGyeDMHwud2FEocar9fPgP/lK27j
	z5Y1dWTGNzFVJ/mXQZKjvfkAmKRPTmZgZxMr5DQGdkNbwF2uZ6bzpxR63QwKLZgGGrY9u+
	ycQAxDEuVleGkMK6QwqiAIymSa/XwaI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269--rM8wa9oPVyf3EtEYS9H0Q-1; Thu, 28 May 2026 01:03:25 -0400
X-MC-Unique: -rM8wa9oPVyf3EtEYS9H0Q-1
X-Mimecast-MFC-AGG-ID: -rM8wa9oPVyf3EtEYS9H0Q_1779944604
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ba6fe41283so133862145ad.1
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 22:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779944604; x=1780549404;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UqvCi0lCynTmviHWeEa7hB9XA+pHd1N3wbumIZfeiYk=;
        b=Jyq7Y9PJUguwmJRg2weXQrRtU9IClgKG16RnShRjU5uJO9vWN+UM5pSQA/wCvahw8d
         SprKV4DBtYVZdmIwJNAh6WgT09uOReazk5cnJlCwxQugsEBjZxSMvc3Li4c82kmg74Lg
         BrHNO/mmDmze/v5FdYpxtjrl/Mhye+fvOzG1Sut5HJHVZCJweDe+RPUR6O2ZNQFB3zG/
         ejGyja3UdSIjRIR6hCZqUX0y52JIm5tazWKh1alYYmkqIXXRzm6rObPTi8BKZ9s5t4Ve
         PBFEFBlINcyutwZzi3mN69834mvXQAjKl9FQLDiQaOw+OMmAoBuHp4ONV+VnWhKL/eSn
         WK+g==
X-Forwarded-Encrypted: i=1; AFNElJ8zxwHo7KzgbEFWrQacY8XwuS8wmky6Or9bUv1gTCzwo7iAV/Th9ZXm63QN5uNQ9iKHplKmSn8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxjfyVNx7M0L1ynGlDQjxplB/ZZWNxXIJQMPRCkZIbBPyDx4Jbz
	3A8uCo8MPc6NgiOkuMsw7B/GC+dJ1gv7ICu+/CfOYoFKf5s5lgRm6XbQUO92yjh/l+/p0GfbEe3
	Hpwba4LSniQ4IOSGDAfeF3QqRo4X2dTAmLMQor4gbMkqQuSK1GVTIC7QUlw==
X-Gm-Gg: Acq92OHux6xdQnZemtlpiHh9cQ/LlBlKQpyEFym6GW6DVO4ivaAouvxAYYEIUKN1N7J
	4GvjLEkMT6kaWGHFiB7m8rGrv5v3ac/sEOQwdkb9+h5J8J9mZmGBs1QMF1s096fAHvQJoMHf5Us
	3SwIVIV9FkQOP3iPROGXeVm9Ckc5fU50ClLTcdUN9yE28h4XzOrdLIp3mPaBVSRmYCWvROCPMGM
	swzj9IsXQVbpd4EuJQuqvd2Fi1AKyB+qyXf03L4fsl6APi/bQLs3zbUtnRTwdXSELUOodm26VGN
	g7h2uscZsiXbgWaFx7KNvvk0wzPAdtlITNZoDrqok8el4WIjWDvKkccVrLaAaxWmOfYXog/IYyR
	ngqYSo4/bKW0HTeeCDWqxFrvrcAa8V1HXfF6ilRqRNVNw2JtJZ84FeSiORGRbzpLXYZNQuVu+dc
	g=
X-Received: by 2002:a17:902:c94f:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2beb0366400mr275002275ad.1.1779944603795;
        Wed, 27 May 2026 22:03:23 -0700 (PDT)
X-Received: by 2002:a17:902:c94f:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2beb0366400mr275001935ad.1.1779944603275;
        Wed, 27 May 2026 22:03:23 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56f4343sm221300525ad.36.2026.05.27.22.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 22:03:22 -0700 (PDT)
Message-ID: <8b648b59-c411-4126-be18-686d2927f24a@redhat.com>
Date: Thu, 28 May 2026 15:03:11 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 24/44] KVM: arm64: Handle realm MMIO emulation
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-25-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-25-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0vUH6rL2dpkhEY5x0GjWYOsiKYYox2keeqPZ7Mr9vqE_1779944604
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 5/13/26 11:17 PM, Steven Price wrote:
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
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v7:
>   * New comment for rec_exit_sync_dabt() explaining the call to
>     vcpu_set_reg().
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
>   arch/arm64/kvm/rmi-exit.c     | 14 ++++++++++++++
>   3 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 89982bd3345f..6492397b73d7 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -228,7 +228,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
>   
>   static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
>   {
> -	if (vcpu_el1_is_32bit(vcpu))
> +	if (unlikely(vcpu_is_rec(vcpu)))
> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
> +	else if (vcpu_el1_is_32bit(vcpu))
>   		inject_abt32(vcpu, iabt, addr);
>   	else
>   		inject_abt64(vcpu, iabt, addr);
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index e2285ed8c91d..6a8cb927fcca 100644
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
> @@ -138,14 +139,21 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
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
> @@ -167,14 +175,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   	 * No valid syndrome? Ask userspace for help if it has
>   	 * volunteered to do so, and bail out otherwise.
>   	 *
> -	 * In the protected VM case, there isn't much userspace can do
> +	 * In the protected/realm VM case, there isn't much userspace can do
>   	 * though, so directly deliver an exception to the guest.
>   	 */
>   	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
>   		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), esr,
>   				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
>   
> -		if (vcpu_is_protected(vcpu))
> +		if (vcpu_is_protected(vcpu) || vcpu_is_rec(vcpu))
>   			return kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>   
>   		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
> index e7c51b6cf6ce..8ec0d179eba2 100644
> --- a/arch/arm64/kvm/rmi-exit.c
> +++ b/arch/arm64/kvm/rmi-exit.c
> @@ -25,6 +25,20 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>   
>   static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>   {
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	/*
> +	 * In the case of a write, copy over gprs[0] to the target GPR,
> +	 * preparing to handle MMIO write fault. The content to be written has
> +	 * been saved to gprs[0] by the RMM (even if another register was used
> +	 * by the guest). In the case of normal memory access this is redundant
> +	 * (the guest will replay the instruction), but the overhead is
> +	 * minimal.
> +	 */
> +	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
> +		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
> +			     rec->run->exit.gprs[0]);
> +

{ } is needed here.

>   	return kvm_handle_guest_abort(vcpu);
>   }
>   

Thanks,
Gavin

