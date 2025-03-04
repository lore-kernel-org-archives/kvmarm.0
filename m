Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DC1149C7D
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 05:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741065354; cv=none; b=IjwcYtJS392TSDq7BuIgiWX1u0Be4V4cq5UzQWoA0kE5dhtcWHEPL1ftf4yg37fpQ3lcIcdvZy8sZd3q7rGVHb3vFMxaFdsaKk5QTMzIYa/HIwkozdfFZ9qKovIUI7DwQSq/tY4XYrzRkKR6drWpcz86PsGwnNL6m9mdw9yZ1k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741065354; c=relaxed/simple;
	bh=I70BjEXqWMzdLTvepT7oYU6oxEIcfIfhUlrieGGjjJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fcERioc4+eSxTIhfNLMYfCZ9whl/oDHxmZi/IZ1NeO3NWHNO+95D4QUKmJBSsRaMuD0N0o5FWxt/5uyXyeug0rW9ZKI7lO90v9GHWzUp0kfOeg/GP/ANhDVRgKhpeHYrjFTCA1T+6ldyCABZppeZliR0BG+KpfvRntku09L2WxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KR1AOVr5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KR1AOVr5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741065351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHp7c8083IblnSkSElkO4q8Pyi74C3j+q7Rd++XFOzQ=;
	b=KR1AOVr5D/tVoWUXUQRn36CaTbpt6o/GxeF5nfukGLSAxMboYReitphGPVHmHqjRnZjTAd
	GIlBvupMRsUzP044oyyYKr37l3NwKZ8eZUArAj/moRLPnO2P9RvYCfWyrenRYpVVzhYuq/
	C+OeSAth9/AaNxi7BWv4vQVJm5DlqlI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-Hr4vKlDVMqmiSwkzYZNvUw-1; Tue, 04 Mar 2025 00:15:40 -0500
X-MC-Unique: Hr4vKlDVMqmiSwkzYZNvUw-1
X-Mimecast-MFC-AGG-ID: Hr4vKlDVMqmiSwkzYZNvUw_1741065339
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22366bcf24bso73110865ad.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 21:15:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741065339; x=1741670139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iHp7c8083IblnSkSElkO4q8Pyi74C3j+q7Rd++XFOzQ=;
        b=Z3lvnWyAvGtSW6Wm6C53FZxm1jfMxiiD+ds63yJm4tp/W1RBHTF03mnMpD6wW146B6
         IsJek5CrpOglYLMoxOK88K0f0NUhQ3Yz3ECBTlppRDxjQlQQcCOHbR+QKu7hXBeR7Z0M
         XO8A7hVypnuGd/swniFSKdhJ5jk5npgEXcD9vvoYfdk50t4TyKOEp1NWDH/TJm86WL8+
         2X5SOncpbxL3P3vK59E4i7zY6gvAqw2G+cGlftunRJWE6NOI/JHti2gNyYW5sXEP9qTs
         qQoL2hPURT9/UCL0r5wzIGkqybwBxn76xtiOa19zmN+dAhAAzk1qIF5x170/hqSif5uP
         uSeg==
X-Forwarded-Encrypted: i=1; AJvYcCW0KbJLyWWaiGTdJzPk0WbTJ+K1m3TifvyR6uahj/uR6uYDbx7xJnAUlmQFv90K6JIhnDXup38=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8DVEU3zVrdjQk4RV57w20XbzfLJFYJ1HWWlIwomS1lrdZ8owv
	r5iZNWFf3343ePiH/mOxooKPeb38TyfoMnJzTcpnC9I2OFUNTBoGyldQkeK9ng79ctU6NwOneUw
	3zTitD9kT5XmG41IlPp/IH9b9/Lrlv2w+CmvGm0hv44Hs3uc50Djmwg==
X-Gm-Gg: ASbGncu0ucsbR2dWPIF8mCgWg6OiTkwGsJKxKii72lWslKkhbfXjbdw97twV0W93PwG
	Eh8E/C8uLz9QRsoajGIQN0X/VDUSa8MsyiI1OOMfNXj8Rl5Bht5Qhkvm9YHP22G9uu9LdCnm3kZ
	j02yAUp0LZ5FCMUtVmIUZ4fW6beSK/OFXBxia6eiApzvacQMp+P4EiWkEW6zhMjJdYDrzbzSajL
	gdyEPPonnjnHiSeEmQt9QTPut5MALY4Aziouq4ouiDtOiO5id4rWI6hIOhqPlFPHSCYqNEqeM0w
	ZlO4a8YFUOY1z7j+TQ==
X-Received: by 2002:a17:903:244d:b0:215:9470:7e82 with SMTP id d9443c01a7336-22368f71b7amr213249435ad.4.1741065339569;
        Mon, 03 Mar 2025 21:15:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwYeNz4BZ5M1mONF0+zOWTYRV5h3Fu8fVqk+GofZ0hdvm3v9bSMtAm5K07jzNGKbCercWDMg==
X-Received: by 2002:a17:903:244d:b0:215:9470:7e82 with SMTP id d9443c01a7336-22368f71b7amr213249125ad.4.1741065339283;
        Mon, 03 Mar 2025 21:15:39 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fe825a99a7sm13451855a91.6.2025.03.03.21.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:15:38 -0800 (PST)
Message-ID: <eb8ea5a0-fe6c-4b96-92da-f9ec0355b4dd@redhat.com>
Date: Tue, 4 Mar 2025 15:15:31 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/45] KVM: arm64: Handle realm VCPU load
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
 <20250213161426.102987-23-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-23-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ByE4RJM1D_E9t3k3ZtBY22y9wENyu3Sc_sB7pTnO4L4_1741065339
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> When loading a realm VCPU much of the work is handled by the RMM so only
> some of the actions are required. Rearrange kvm_arch_vcpu_load()
> slightly so we can bail out early for a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 

One nitpick below:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 49ad633c5ca5..3e13e3d87ed9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -633,10 +633,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	kvm_vgic_load(vcpu);
>   	kvm_timer_vcpu_load(vcpu);
>   	kvm_vcpu_load_debug(vcpu);
> -	if (has_vhe())
> -		kvm_vcpu_load_vhe(vcpu);
> -	kvm_arch_vcpu_load_fp(vcpu);
> -	kvm_vcpu_pmu_restore_guest(vcpu);
>   	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>   		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>   
> @@ -659,6 +655,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
>   			     &vcpu->arch.vgic_cpu.vgic_v3);
>   	}

A spare line is needed here.

> +	/* No additional state needs to be loaded on Realmed VMs */
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +
> +	if (has_vhe())
> +		kvm_vcpu_load_vhe(vcpu);
> +	kvm_arch_vcpu_load_fp(vcpu);
> +	kvm_vcpu_pmu_restore_guest(vcpu);
>   
>   	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
>   		vcpu_set_on_unsupported_cpu(vcpu);

Thanks,
Gavin

