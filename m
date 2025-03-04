Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC931EB5D4
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 05:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741066954; cv=none; b=oayo301ho9Z2CcsXqbEOXDercpnOTebVAF8Q/xG4i+1Bkeu1IVVQ2Tg5uHypMcrlmfbBp+vJ3Lz4+PXyxv5SXrkkYcktICiO0ku7P/wn2qyP2xKK4UMDu6bQqKB45KCD8RjbrTyrDhrt9MPdntHY7tioXLi1MnpGPWBGxK1QseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741066954; c=relaxed/simple;
	bh=NDiYP2H5hYhH1uYD5YWszI9pFiidjNwL9HaA1erSaWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OCN6GawYfaN465Zj6eblduiqvAO65Vcrq5r7YCCcQPT2N3UEI7uB3cTepK/tTAKJig/Dh+g54/cZbuN7Xdc1VrZwANPZAzRsrNYzPHs96cvqIYbAaPo9YBtcGybZhF4vvtIbBcBvkHQEDX7TfkPF0Fj0q1mO9i0jHMhdd4d/BC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EIi4eFhe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EIi4eFhe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741066951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hbTXak4fZZgmEd0OOFQqdTCiZzdYnXYZunDKpr8m1kE=;
	b=EIi4eFhepeOjmAxiwmZv7Pd7FJJgu0kNcQzhNCi0eZDZ5wPQ/0Jrngp+r4qsZlXRqI+615
	VAWuGZdZiERLFeBnUohek0ArYaDCGfu8xXqx7XBIu8VRaoWLlTQ6JdsAE9gR7PrMGFmdvM
	mArm4CSmrQ2aXezhSWJg5LYkjEEr0mA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-djIJGSKROQCY-MZg6BfVWA-1; Tue, 04 Mar 2025 00:42:20 -0500
X-MC-Unique: djIJGSKROQCY-MZg6BfVWA-1
X-Mimecast-MFC-AGG-ID: djIJGSKROQCY-MZg6BfVWA_1741066939
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2f816a85facso10110073a91.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 21:42:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741066939; x=1741671739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbTXak4fZZgmEd0OOFQqdTCiZzdYnXYZunDKpr8m1kE=;
        b=tPDTRJ8ku4RbpSEp0y7/EW986CuBkqRtF/Lq6MNcU5c7DR/lIEPHnN+7mKgZisFLBb
         5K7GVlmeqXCWfB7Xaw9c8SKOPYJPKDxDAauDpwth1vUr6aOGxgVg3IJUexgcZwpr5QPg
         nGwTBMQzQUX/YQkdhY7FUQff7UxeVBDSYqvLxGi4Xjg6IUp1tx/Th/dVQgWQ6vT9p23R
         zqLCk5HFJMf6r9xzNAuqide+QO3iIIB9ML9IpY4OkwfH/GBnPFDlUsi/6wfxQ/hPVt3X
         0AFnlIfXu4gwW6r46TbI4iM7RBp4+ICF1frBsuYaFHrxV20dg+dUKuyznaKywRyerNFO
         rwLw==
X-Forwarded-Encrypted: i=1; AJvYcCXt/hM0zNENohcw5RVbddtxGQmjCws9Ed4XZbQ8xV9ebqYFrKNV7DWP4J/ugmoVwM+aRc2JWy0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0prxw9h6dJjurwpW/b9APfbuNazjBY+fMszxphRu7QDf+ZReA
	kXKs8d2bjoNl5q6dsGYv1p9ypG1bJbm7/eNl2yCQIlSFumlcO8gxILOvi9DfuiBA0oFjZ5TvNlQ
	MMmXFZ9PWSanrCcB7a/1Gkd9XxKa53/4o2oWOFhY3wkcXtwvilXUGEQ==
X-Gm-Gg: ASbGnctt/t3bXoD5f4bPzfmGK1hchcgrYhPyrQcfCFB69QyJdgElvSiknJmykQGEN6d
	kgxbn2i7MXoXL60JF52VRQi1N8/f2X3bXM3zb6FE9ml8/xy/uMiA1aqhzLr6bjtRpRWKOjdtlYW
	eGHDq+nU00MPiIxBV4/cNXZv2rjwsgg37pV4ODSqRDHJXkRysHd19KoyfDeKOucW7QPFWYSmSEL
	L57yDih985ObOAMZMYwjXHldLz1Ji03Jjp8sQOhPLe0OJcXBHgyHsLxLuAj+VQLrcIWWS3wy4V6
	If+kxIArHesBU4JdeQ==
X-Received: by 2002:a05:6a20:c781:b0:1ee:e8c4:e1b6 with SMTP id adf61e73a8af0-1f2f4e01578mr26530451637.33.1741066939185;
        Mon, 03 Mar 2025 21:42:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHurZweDDClFEM+EDFVGKyToeXZSnslvrdiIY31gYPFZM1mfyMjnp3vImA6Ky+0fKgY2QYszg==
X-Received: by 2002:a05:6a20:c781:b0:1ee:e8c4:e1b6 with SMTP id adf61e73a8af0-1f2f4e01578mr26530433637.33.1741066938923;
        Mon, 03 Mar 2025 21:42:18 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af075209ba3sm5804806a12.29.2025.03.03.21.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:42:18 -0800 (PST)
Message-ID: <ecf15da0-49ff-4cc3-9e4e-5c47f79acc06@redhat.com>
Date: Tue, 4 Mar 2025 15:42:10 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 26/45] arm64: Don't expose stolen time for realm guests
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
 <20250213161426.102987-27-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-27-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DB8sLz4zlVtpfzOeoz-mTWhWOhvLJYaFI9tu7R9YbiQ_1741066939
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> It doesn't make much sense as a realm guest wouldn't want to trust the
> host. It will also need some extra work to ensure that KVM will only
> attempt to write into a shared memory region. So for now just disable
> it.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 

With Documentation/virt/kvm/api.rst updated:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a6718dec00c9..79d541c95bfb 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -403,7 +403,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = system_supports_mte();
>   		break;
>   	case KVM_CAP_STEAL_TIME:
> -		r = kvm_arm_pvtime_supported();
> +		if (kvm_is_realm(kvm))
> +			r = 0;
> +		else
> +			r = kvm_arm_pvtime_supported();
>   		break;
>   	case KVM_CAP_ARM_EL1_32BIT:
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);

