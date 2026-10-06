Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D71CAA78
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791258944; cv=none; b=hdTGOcynGs9OWUveaFUAQaKeEeH9EW+Df9nOcAcExOtzdpQ7UdSwpdQCcK5yii9hykLAkZDi19O1ADk1JPfNVPWxxrL49FwFTLeaaF2OmfKPl//cWBY4sAXIAGOgmKD6TcKfDmSpBRDbmWkJTV3+DW1ivq7U5T7+SuAXcUSoIlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791258944; c=relaxed/simple;
	bh=MxwPZN7n5B2DE8usWq5PQK1nguduFWWGN/sO04w0Ge0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPkpugDYfCMFdxkL7yfZ57FNJIUWku7EG6td7Ij/tOKi8bJYuNrBMTEitXs3+Kcajrpd16sEhegiMDdbmdXB76NQ9QpGwo1pxKDeos0X9P0Y/D8nN02bDSd91OEcPNVcRiTXflgPjiT4Ke/Td6UHgwikJWi5LK60auiHMjhMSok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UZyRd8Wb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UZyRd8Wb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791258941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYC8oY+LrXwAaiDtJ55Vw+0AspCCI39rFIw270qLm/8=;
	b=UZyRd8WbR9H/ek2vX3r6MVBnp74dOwwfntP33dpFRDNCsBgrPPZhaEbSrCTU6WILz8QaaV
	PdsVXIdQjiQl58z0L8cQVEbfXv0tKch7ZNlkfhr/dM1wF6mjj5qjQ9bNjYqLIDSiyCfSIP
	h/F0W9u0F2lChBvjkPCcYG6KtUiMxTA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-hBTRLkjxPSqOok6ntO9gfw-1; Mon, 05 Oct 2026 23:55:40 -0400
X-MC-Unique: hBTRLkjxPSqOok6ntO9gfw-1
X-Mimecast-MFC-AGG-ID: hBTRLkjxPSqOok6ntO9gfw_1791258940
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a46f0f158dso655408a91.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791258940; x=1791863740;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uYC8oY+LrXwAaiDtJ55Vw+0AspCCI39rFIw270qLm/8=;
        b=VgUFtUmY5YmE7pEUCuRmEgXAcX5e4ZYaJsH7f8mMGcLicDngQfWox1/ABiwJy2Jsk0
         jhFcqPAX8WSf7fQA5KIkVC1e4I3ivIYdLWBDb58uXwj1u73DtiZ2qkn7PV+ydgKaelRC
         HmVM5J6x7qFCauFDe970Ij2E+6+FXqpisQ3Dmlr+ZPL/RL32/Auf4AEiCLKlGguijGcP
         phSmoYwZ7EpPTyz6GUOSfV4RtJ/ynwPVzn79iCzHL5t/lTfNMDiaaewK3kqdpR9AJfBf
         ulVQj/+BkkkHhXMoF27dFkhq/BJ9m0LpVCiNnI71B18DYeMzzYUuBHVVpA/vnXzpsx8D
         i/4A==
X-Forwarded-Encrypted: i=1; AKwUvBx1XSZVPKLvBRhZxFDSPU3l6BScK/t0TCs/GcE3oGgPR+zK5vykDmXRbAfu1ytdi3UGOzBmrV0=@lists.linux.dev
X-Gm-Message-State: AFq9FYIHv0qNX9hnA3HoNoNZRWBQS/YDejOJXSIwPuLcnaj07DukQRj2
	L6KUJKtYXa4yS/KFIjLb/u+0fTnsxutVViVQiP7P5xSNLT9md+r40VqjI22t9H2M6KshTCO7ZKQ
	L3u/YScYT1XGwsBZwNR62m5ztkLRM/zbL+l20MkdekOoF4c+LPxKaOL28gg==
X-Gm-Gg: AYBFou38STTz6uPcttGYxCJv4nJXRZ4VNEV//62+flA6nYbf7304a+HFpA0XTQ2RybN
	zcgJGA8yf8kd8aTFQ1OXjAL9ddK3BdWixew5a0yawve/N8u/M6a+i0vqnRGcuQaBcR1IAIc6dlm
	lN98kHXaSkf4JTGHd9qix6bDgAQZym7EjlnHziSlzS5/MEQPDC73FxyAvSFU6rKH/jut8Nu3H5v
	5gjAChiXE2Zn+Is78cLfXZmK9a24XxqZKleskFh2ikN0XtAgyYO7f4M1wXiZ/A5/SzHYwcb/DGm
	6C3h9qx1mh5ddLhbZ+G0lkGelEvjnsyOgY2ADXoGrC7NyEzK+ZYbo7oAaC2d9Y8Cd/TmC//vPYU
	kR8FR8GVG/ChwiBKFd9IWnaNvXxu6MiwBYuDZ6OkpeQ==
X-Received: by 2002:a17:90b:4d84:b0:3a7:ef4:74ba with SMTP id 98e67ed59e1d1-3a8546a64dfmr1230257a91.55.1791258939700;
        Mon, 05 Oct 2026 20:55:39 -0700 (PDT)
X-Received: by 2002:a17:90b:4d84:b0:3a7:ef4:74ba with SMTP id 98e67ed59e1d1-3a8546a64dfmr1230238a91.55.1791258939230;
        Mon, 05 Oct 2026 20:55:39 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6e2b012esm1790452a12.29.2026.10.05.20.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:55:38 -0700 (PDT)
Message-ID: <e7b6a49c-f9ba-410d-b7b6-55c01d1c5015@redhat.com>
Date: Tue, 6 Oct 2026 13:55:28 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 05/23] KVM: arm64: Track the type of VM in kvm_arch
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
 <20261005090754.2140522-6-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-6-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FgZo35QcySVGsqXoIa9rJ6iRsGJBRkC2hGHj5ylsxCY_1791258940
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> KVM arm64 has different types of VMs with all the different modes in which
> the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
> protected VM and normal VMs with pKVM. We might soon add other types,
> e.g., Arm CCA Realm. So in an effort to make the handling of these
> different types of VMs a bit more friendly to the eyes, add a VM flavor to
> the kvm_arch and we could then add handlers for different operations based
> on the VM type.
> 
> Keep the flavor initialisation at the beginning to allow for the detection
> early enough and fail out on any unsupported requests.
> 
> With that, add wrappers for checking the "type" of a VM and replace the
> existing users with the new wrappers.
> 
> Given we already have the construct of "kvm_vm_is_protected" in the core
> KVM code, use that for all confidential compute guests including Realms
> that we are about to add. Adds __VM_PROTECTED marker vm flavor to draw the
> boundary for "protected VMs". In later patches, we would add Realm VMs,
>   which would also be classified as protected.
> 
> Add a explicit helper to detect if a given VM is a "protected" VM under pKVM.
> Change the existing users that precisely want to check the VM type. These
> include :
>    - kvm_arch_prepare_memory_region - For preventing memslot changes after
>      pVM creation.
> 
> All the others are retained as a wider check for confidential guest VMs.
> These are:
>   - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset
>     configuration
>   - io_mem_abort for dabt handling without valid syndrome information
> 
> Both of which are true for Realms too.
> 
> Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
> checks in the pkvm hyp specific code doesn't need to change, as the only
> protected guests it deals with is "protected pKVM" guests. To tighten this
> init_pkvm_hyp_vm() restricts the hyp copy of the vm_flavor to the ones it
> supports.
> 
> vcpu_is_protected() usage from nVHE hyp code is tricky, as we need to
> convert the vcpu->kvm to the HYP VA before checking the flavor. This
> involves kern_hyp_va() usage in asm/kvm_host.h. To avoid build breaks,
> include asm/kvm_mmu.h to arm64/kvm/mmio.c.
> 
> While at it move the psci_version around to keep the structure packed.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v21:
>   - Drop kern_hyp_va() and restrict nvhe code to always use vcpu_is_protected_pkvm()
>   - Drop kvm_vm_is_unprotected_pkvm() and open code the check
>   - Move psci_version field in kvm_arch around to keep the structure packed
> ---
>   arch/arm64/include/asm/kvm_host.h      | 42 +++++++++++++++++++++++---
>   arch/arm64/include/asm/kvm_pkvm.h      |  4 +--
>   arch/arm64/kvm/arm.c                   | 33 ++++++++++++++++----
>   arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 +-
>   arch/arm64/kvm/hyp/nvhe/pkvm.c         |  6 +++-
>   arch/arm64/kvm/hyp/nvhe/switch.c       |  4 +--
>   arch/arm64/kvm/hyp/nvhe/timer-sr.c     |  2 +-
>   arch/arm64/kvm/mmio.c                  |  1 +
>   arch/arm64/kvm/mmu.c                   |  2 +-
>   arch/arm64/kvm/pkvm.c                  |  6 ++--
>   10 files changed, 79 insertions(+), 23 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

