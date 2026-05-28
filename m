Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC062EDD7D
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 06:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779951324; cv=none; b=kquzqQucs1SCM1oJE3J1OqMlATXpEQV6c5ilFCjtiuEV4H8CtNqeTAtcw6ZAt8gELuQwy8h5IllsNx3r7QmaFvbSaOeRsYPN84Be6QzvqXaZy/vGuOFm3+WpANUgY3WmmyHhuDx7UGmbAbksSxmhEfFtfFgS/gkOsNXCHfTFRtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779951324; c=relaxed/simple;
	bh=ij85/aAKgcDYX+cdb77sOhYL+oKjAi0tecDfGmXPEAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mmKHw1y2TYbdCBKIzsViH5UiKPlepK9/Kf0iM+TekDrXwlu1cZmw3ATzS2Jj8W9pcCFDaS7qhd0ukvEdR3p5nJwz1F194qa4VLRifgirrvetq5zxr70asRoe9qUpGBvON5xL5XOOjoedni+bPnJpsZkBW6Exszx7ccZHU6bcgck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KwLoRPhv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KwLoRPhv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779951321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mmDhoG17mw4NgiWZMgx23xHdUQBzuYviNZS63oMCAI=;
	b=KwLoRPhvQNGrBSFMTwsyRynXML2CBXGc+HacSxn2fxDFWLQbPN1zz8yHhWcE3/BFkwBveY
	JDc/IGN+8XjIC2ogkCMHQoxVuRu9qbWc8+lkHavZ30IOdyGkpnEU7/GQmix0ZddiM60MJ5
	vhLwR0XXbg7AXP9HeLrCt468hsxcRDw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-vfhRey6MOQGNEyY2hsFOHg-1; Thu, 28 May 2026 02:55:19 -0400
X-MC-Unique: vfhRey6MOQGNEyY2hsFOHg-1
X-Mimecast-MFC-AGG-ID: vfhRey6MOQGNEyY2hsFOHg_1779951319
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c82ba4715b6so13549933a12.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 23:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779951319; x=1780556119;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5mmDhoG17mw4NgiWZMgx23xHdUQBzuYviNZS63oMCAI=;
        b=iV9L5EZEceSpuTkgpQu9toZ5SMMxLWX/8Tap64czdJkxTKKcl9l1itdjo9aALxfoz3
         VTGRP6yH04KmlQSqjj1lmoOIfGmjdLEm1wAYIeKsdumlw1GhAMTZpMzPcLJlB2JKj7FG
         wiHVkXkzE8qxAkmHp2ljXO/qZjpsL5m2vENVaTTv0150PflCgGpewZpERyoYSl894/eS
         T8XdIDuhbiujALidNjzew+aLtPnVPt9ibLZppabYvxzUunci0HpsJCCa1tgM8TTYRzru
         Bp6iVFMJOPol2uThUhYkqgy4XNb19VRll5vPT+yiM8RWPV9CCo2sqOus1EFgWVdQ1gnR
         4h3Q==
X-Forwarded-Encrypted: i=1; AFNElJ8Hqf2lZe0TNU6MV7KkLUx6xwz3gaeY1oFft3gItlk8Mbn6kgJj6gd0uDC6Bm4rkU+LXduqgOM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtBMzmZ6eIMhHtG5j3lUhVZZkJuh0Yx9aDSA5IufwBOdQfMfSC
	HCItfQlw6XS8eZI/bwLsDZRDPZQNlysG+HfiNcRd5UcYfaMJ00hHKZaUPwiVD9RiKBLnf/pRlZ0
	EDC+TY22LplBhNVMpZ4YCxPRtJU/NayAwLoL5lPOco7iucFBdyQyKB4y8Ow==
X-Gm-Gg: Acq92OGgFql/fynFX9G0x7VasRitxGXGSnLzX2XYg/DkaUDMKElDybg6PVPYZwzEs6N
	TICVkgGsSK/WM0xEtZdL+8xgxKYGuNmN5DMpproSC+acP+sMkT6iLZGWYdP2oYgc7/L/cgTyUgc
	5zoYllkUXfu8O3AfDQyENOoO5qs4JOYqo3d3ch1cJZGNoJUsJiZmk/W3Ib7XpquChp4atSzjk5K
	wAsKV42erV7BIDnYy/KGYijuyXxypCeZbguWeQfz640hafIcIg7+P3Tz9y4qplvXOwG9NkCjrJ9
	lMj8kUHnZ0mCSUN8rrgaUCtCVPRv6rlgNsWgsL7fxdL3A5BSbC8+9rNrpI5/3XCyvUsB+oeOfgM
	4sla6A/gPluET4A+uSlVPiQqu4liLDLi3jUDoMH38nj5H8ISftNeLNptkaEmtpFTeZRWuH4EY7v
	M=
X-Received: by 2002:a05:6a00:13a5:b0:82f:6858:3f6 with SMTP id d2e1a72fcca58-8415ef53fd6mr25752365b3a.0.1779951318556;
        Wed, 27 May 2026 23:55:18 -0700 (PDT)
X-Received: by 2002:a05:6a00:13a5:b0:82f:6858:3f6 with SMTP id d2e1a72fcca58-8415ef53fd6mr25752335b3a.0.1779951318036;
        Wed, 27 May 2026 23:55:18 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d7301255sm4623141b3a.57.2026.05.27.23.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 23:55:17 -0700 (PDT)
Message-ID: <775a0d29-4d92-4ecc-96dd-5b0eaeff1528@redhat.com>
Date: Thu, 28 May 2026 16:55:06 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 32/44] KVM: arm64: Handle Realm PSCI requests
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
 <20260513131757.116630-33-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-33-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zubNwIkEFFgql75bENFiHYE4CXKpawUgu0OHT4e2oPU_1779951319
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 5/13/26 11:17 PM, Steven Price wrote:
> The RMM needs to be informed of the target REC when a PSCI call is made
> with an MPIDR argument.
> 
> This requirement will be removed in a future release of the RMM 2.0
> specification but is still required for v2.0-bet1.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Chanegs since v13:
>   * The ioctl KVM_ARM_VCPU_RMI_PSCI_COMPLETE has gone. The RMI call is
>     made automatically just before entering the REC again.
> Changes since v12:
>   * Chance return code for non-realms to -ENXIO to better represent that
>     the ioctl is invalid for non-realms (checkpatch is insistent that
>     "ENOSYS means 'invalid syscall nr' and nothing else").
> Changes since v11:
>   * RMM->RMI renaming.
> Changes since v6:
>   * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
>   * Minor renaming/formatting fixes.
> ---
>   arch/arm64/include/asm/kvm_rmi.h |  3 ++
>   arch/arm64/kvm/psci.c            | 15 ++++++++-
>   arch/arm64/kvm/rmi.c             | 58 ++++++++++++++++++++++++++++++++
>   3 files changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index b65cfec10dee..eacf82a7467d 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -109,6 +109,9 @@ int realm_map_non_secure(struct realm *realm,
>   			 unsigned long size,
>   			 enum kvm_pgtable_prot prot,
>   			 struct kvm_mmu_memory_cache *memcache);
> +int realm_psci_complete(struct kvm_vcpu *source,
> +			struct kvm_vcpu *target,
> +			unsigned long status);
>   
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 3b5dbe9a0a0e..a2cd55dc7b5b 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -103,7 +103,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>   
>   	reset_state->reset = true;
>   	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> -

This change isn't supposed to be part of this patch :-)

>   	/*
>   	 * Make sure the reset request is observed if the RUNNABLE mp_state is
>   	 * observed.
> @@ -142,6 +141,20 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>   	/* Ignore other bits of target affinity */
>   	target_affinity &= target_affinity_mask;
>   
> +	if (vcpu_is_rec(vcpu)) {
> +		struct kvm_vcpu *target_vcpu;
> +
> +		/* RMM supports only zero affinity level */
> +		if (lowest_affinity_level != 0)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		target_vcpu = kvm_mpidr_to_vcpu(kvm, target_affinity);
> +		if (!target_vcpu)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		return PSCI_RET_SUCCESS;
> +	}
> +
>   	/*
>   	 * If one or more VCPU matching target affinity are running
>   	 * then ON else OFF
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 761b38a4071c..2b03e962ee41 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -3,6 +3,7 @@
>    * Copyright (C) 2023-2025 ARM Ltd.
>    */
>   
> +#include <uapi/linux/psci.h>
>   #include <linux/kvm_host.h>
>   
>   #include <asm/kvm_emulate.h>
> @@ -127,6 +128,25 @@ static void free_rtt(phys_addr_t phys)
>   	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>   }
>   
> +int realm_psci_complete(struct kvm_vcpu *source, struct kvm_vcpu *target,
> +			unsigned long status)
> +{
> +	int ret;
> +
> +	/*
> +	 * XXX: RMM-v2.0 doesn't require the target REC address for completing
> +	 * PSCI requests. Temporary hack until RMM implementation catches up
> +	 * to the full spec.
> +	 */
> +	ret = rmi_psci_complete(virt_to_phys(source->arch.rec.rec_page),
> +				virt_to_phys(target->arch.rec.rec_page),
> +				status);
> +	if (ret)
> +		return -EINVAL;

		return -ENXIO;

> +
> +	return 0;
> +}
> +
>   static int realm_rtt_create(struct realm *realm,
>   			    unsigned long addr,
>   			    int level,
> @@ -1004,6 +1024,41 @@ static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>   	rec->run->exit.ripas_base = base;
>   }
>   
> +static void kvm_rec_complete_psci(struct kvm_vcpu *vcpu)
> +{
> +	struct rec_run *run = vcpu->arch.rec.run;
> +	unsigned long status = PSCI_RET_DENIED;
> +	unsigned long ret = vcpu_get_reg(vcpu, 0);
> +	struct kvm_vcpu *target;
> +
> +	switch (run->exit.gprs[0]) {
> +	/*
> +	 * XXX: RMM-v2.0 doesn't cause RMI_EXIT_PSCI for AFFINITY_INFO
> +	 * Temporary hack until tf-RMM gets the REC to MPIDR mapping via
> +	 * RD Auxiliary granules.
> +	 * For now always report SUCCESS
> +	 */
> +	case PSCI_0_2_FN64_AFFINITY_INFO:
> +		status = PSCI_RET_SUCCESS;
> +		break;
> +	case PSCI_0_2_FN64_CPU_ON: {
> +		if (ret != PSCI_RET_SUCCESS &&
> +		    ret != PSCI_RET_ALREADY_ON)
> +			status = PSCI_RET_DENIED;
> +		else
> +			status = PSCI_RET_SUCCESS;
> +		break;
> +	}
> +	default:
> +		return;
> +	}
> +
> +	target = kvm_mpidr_to_vcpu(vcpu->kvm, run->exit.gprs[1]);
> +	/* RMM makes sure that we don't get RMI_EXIT_PSCI for invalid mpidrs */
> +	if (target)
> +		realm_psci_complete(vcpu, target, status);
> +}
> +
>   /*
>    * kvm_rec_pre_enter - Complete operations before entering a REC
>    *
> @@ -1028,6 +1083,9 @@ int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
>   		for (int i = 0; i < REC_RUN_GPRS; i++)
>   			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>   		break;
> +	case RMI_EXIT_PSCI:
> +		kvm_rec_complete_psci(vcpu);
> +		break;
>   	case RMI_EXIT_RIPAS_CHANGE:
>   		kvm_complete_ripas_change(vcpu);
>   		break;

Thanks,
Gavin

