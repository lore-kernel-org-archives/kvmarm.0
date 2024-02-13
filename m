Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A3757866
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707832808; cv=none; b=kzZFSFlZ5K6piD3SxbBgN+hRXlpuLItREzm5E9cznbdDi20v4lP3+8dyi0X/I/bsDmkjHVf74EKslM/IPusoud3YFHI5w+MW/+xFY2ESSDjTEBuznNyQKxPJ+VQVWkf7ilRAPTIi7580+im4l/Uen7wX2WVAE3vRoWe7yNZvWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707832808; c=relaxed/simple;
	bh=4u9sc+QNED3CJ+fSGOGjZne+qJh7eQhKuyelS688kjw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZP6Z8d/JBcSMkU1a6GfX6ujkxp3i7FVT94fe48jPIYdG6AkMNbIm+zVnRCfPq7FTAkqTlGe4NARs2dMgp4qxCiQt8oHt/0fUd3ZYsJZUqVc1hhs3wkn8q1T1OUTSLmUvotlxaOVhYFjm44GH6MP59S5UgI2LcxebzEPbNY1Pm4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TJ126oKf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJ126oKf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707832805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UvzMThjrmX5VRs5A15rA0Fn09gCPS7ih0g5+Tw8a6cA=;
	b=TJ126oKfsrfS7yOw5LHU2Ajicr5JgGv0UUMM8Pc656uSobPiQAet0FT4aAZk3Cq1xHk1/s
	TtPEglIPvjqPoulEMKB3CMgxnYSgK6/4UWZPjDaqa/8iS0b6a5Tw0+pcJeLb2LQBTEebbV
	TFYoLV3W1WD8MRKNXyIx1UZcQLIQ41Q=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-IeH7BRR-MsCKJVzDW7U1KQ-1; Tue, 13 Feb 2024 08:59:37 -0500
X-MC-Unique: IeH7BRR-MsCKJVzDW7U1KQ-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dc6b26eef6cso1343563276.3
        for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 05:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707832777; x=1708437577;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvzMThjrmX5VRs5A15rA0Fn09gCPS7ih0g5+Tw8a6cA=;
        b=S6m8vo2QwlNsG93/5jLWatheHMj1pNkHx3oZem3iydiOTzIewZevSkUZ2NplNWh6xC
         afU/s0mk28S4exSqD50T7UomHk+7F0mGP4Jhfey9sPuAuUDN9ZEDhL+xXyZ7RkQ0HnHd
         N7YL9oJyKtLlyxtWLSG2FRJXD+ldDcV7nf2ElLbTBbK19StS/iFLhSawD92tRA+cZx4N
         ezH2ocVXws+PnQhIXFpF+R17idvU3uc1EeWDqAGsryrQvvJIxx/3EnepggOwN8cjZEDD
         dUrZYoh4jNcL3EH27Uu0GkQsBIVmXl87m6Hfj3Tu2zIBocE9516cxU51P9F/MlPuLPpT
         YC8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUp+XVCFH6eZSvpECTvgsUNoekhzCSe/kWyj5fRXhGHLc1DBNqwlsM6vy1mOSODCykrT8VEMx6iCSi1NFxHjRcph3YRhY/L
X-Gm-Message-State: AOJu0YwxkWmQozLk6u2Am7ZjHJ5X+0pngTMu6+prtVxAE8dPKgyKoWAu
	r2vXiwqL8lY0RU5kaS5Jy0NcJ1lwkr0Yz3OtjgO2tNMCzdfbr7PVYfJS0NIRT87lpNNOKlgT1q2
	SsfE8hDvL5rj1GQhjKtRH+1v4lm32k409swQpYFwJVzT24ixT5cK5xQ==
X-Received: by 2002:a25:74c4:0:b0:dcc:9f62:7520 with SMTP id p187-20020a2574c4000000b00dcc9f627520mr1499026ybc.59.1707832777216;
        Tue, 13 Feb 2024 05:59:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmUPIRkMZ5eEAdw/hNLzMd1L1jCaLBuvqVUChpY8/SE1/7cWhaAdI5BzN+RNyXTxVkGcyFHg==
X-Received: by 2002:a25:74c4:0:b0:dcc:9f62:7520 with SMTP id p187-20020a2574c4000000b00dcc9f627520mr1498999ybc.59.1707832776915;
        Tue, 13 Feb 2024 05:59:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXusaj9FdpGwXliFhVjhzjbDxZP4LcsrdcCNps/66sXwi9o6BFqTvKJBYI3AQ2ogwcGiaWrvmxOSqDrDtTBYjEme0gjWekBg/rX29SPnv2sd5qiWesu5YjNou8UvarYAST9webGckfdNK4sX3dqLvb3MmzK4V+U1aBt6Xt7fa7lLdd6YRH8BnpQ2eKKWBn6Xrmq4xrvnkZZzvXoIHOkv8kTrX7Ca3P4s49Ni98+eWeYdxWJBeZUzx+7oS2VrAWCCcJBdG0ghKnIGgBINcmycQzxjKFKxxg042Z3pv+ZFyE/vVwHa1dZorlBEC8WlAhZpY5s9za5MFtawIq8SpwfwEYMKQ/uUiA/gT+zwAer9vGJx93lERZakoZIPTemSQEWNGbFIH9HZLUCqVsZB9lfwiou817P4kiKd/Dg/psoCRg5uJEy7NY2aMBwNct0QpyURSInMKrtygB8VRo7oRPkr3FZZ5TxksiL
Received: from ?IPV6:2a01:e0a:59e:9d80:4685:ff:fe66:ea36? ([2a01:e0a:59e:9d80:4685:ff:fe66:ea36])
        by smtp.gmail.com with ESMTPSA id s9-20020a05620a080900b00785b0827ee6sm2965084qks.22.2024.02.13.05.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 05:59:36 -0800 (PST)
Message-ID: <82b72bd2-c079-40c3-90b8-30174f2a8fe0@redhat.com>
Date: Tue, 13 Feb 2024 14:59:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v1 2/4] KVM: arm64: Document
 KVM_ARM_GET_REG_WRITABLE_MASKS
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.linux.dev>,
 ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>,
 Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck
 <cohuck@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Sebastian Ott <sebott@redhat.com>
References: <20230919175017.538312-1-jingzhangos@google.com>
 <20230919175017.538312-3-jingzhangos@google.com>
In-Reply-To: <20230919175017.538312-3-jingzhangos@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/19/23 19:50, Jing Zhang wrote:
> Add some basic documentation on how to get feature ID register writable
> masks from userspace.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 42 ++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 21a7578142a1..2defb5e198ce 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6070,6 +6070,48 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
>  interface. No error will be returned, but the resulting offset will not be
>  applied.
>  
> +4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
> +-------------------------------------------
> +
> +:Capability: KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
> +:Architectures: arm64
> +:Type: vm ioctl
> +:Parameters: struct reg_mask_range (in/out)
> +:Returns: 0 on success, < 0 on error
> +
> +
> +::
> +
> +        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
> +        #define ARM64_FEATURE_ID_RANGE_IDREGS	BIT(0)
> +
> +        struct reg_mask_range {
> +                __u64 addr;             /* Pointer to mask array */
> +                __u32 range;            /* Requested range */
> +                __u32 reserved[13];
> +        };
> +
> +This ioctl copies the writable masks for Feature ID registers to userspace.
> +The Feature ID space is defined as the AArch64 System register space with
> +op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
when attempting a migration between Ampere Altra and ThunderXv2 the
first hurdle is to handle a failure when writing ICC_CTLR_EL1
(3.0.12.12.4) on dest. This reg is outside of the scope of the above
single range (BIT(0)).

This may be questionable if we want to migrate between those types of
machines but the goal is to exercise different scenarios to have a
gloval view of the problems.

This reg exposes some RO capabilities such as ExtRange, A3V, SEIS,
IDBits, ...
So to get the migration going further I would need to tweek this on the
source - for instance I guess SEIS could be reset despite the host HW
cap - without making too much trouble.

What would you recommend, adding a new range? But I guess we need to
design ranges carefully otherwise we may be quickly limited by the
number of flag bits.

Any suggestion?

Thanks

Eric
> +
> +The mask array pointed to by ``addr`` is indexed by the macro
> +``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
> +to know what bits can be changed for the system register described by ``op0,
> +op1, crn, crm, op2``.
> +
> +The ``range`` field describes the requested range of registers. The valid
> +ranges can be retrieved by checking the return value of
> +KVM_CAP_CHECK_EXTENSION_VM for the KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
> +capability, which will return a bitmask of the supported ranges. Each bit
> +set in the return value represents a possible value for the ``range``
> +field.  At the time of writing, only bit 0 is returned set by the
> +capability, meaning that only the value ``ARM64_FEATURE_ID_RANGE_IDREGS``
> +is valid for ``range``.
> +
> +The ``reserved[13]`` array is reserved for future use and should be 0, or
> +KVM may return an error.
> +
>  5. The kvm_run structure
>  ========================
>  

