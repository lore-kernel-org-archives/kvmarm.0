Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B3828E03
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QiouING9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697468292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zp4vUunKfHhqsgxWB38XGElijdQA95U7BhovNf/a+1w=;
	b=QiouING91ljjFwhgHV3LCpsiZUEhS/SXr6D7xq6tcSSST95m2SiIAG7yY6NzNeDQBdAPCH
	p8t1MxEvTX2QrTMmTCtPNrWbnjdoAUct8KOQCfVF9+W4+76e6Wj4qaaaAbluLowyr+hjNH
	uKWXud09LAwuTZjdSrdfYnjM1DAndak=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-8CAONUHTPuKYXaWfjG5ABA-1; Mon, 16 Oct 2023 10:58:09 -0400
X-MC-Unique: 8CAONUHTPuKYXaWfjG5ABA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7742eeceeacso587371985a.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 07:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697468289; x=1698073089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zp4vUunKfHhqsgxWB38XGElijdQA95U7BhovNf/a+1w=;
        b=SXK9Vmu0JvN+Dap94Zn/44BPOlN/t0EJBwNTt2Qvy1TXoMY1SYMgVPfP3YW1nr4274
         YXFFr+OM+EQtIE/XT8RaiztyeuuyKZSQ1KR7llIKTSjd4O4MATQC+cUxFnIpmnbRwGny
         /8BhvgccRGvvKXEf7AlpLbOFyO1lreqRNKpzOFBgS7UAJhH8kKg7v956qcUKbVAn2nJm
         vbWECrj0OA7bpQmpAICXreqMxJWruhIXv0VJ+2HIQJ36EpZl3wVH62EHLeZhsw7ysW3Q
         VrmyQw/8UVVF5H8RVLG+8NGbrLsSh6JPxnuqDLSjVKPYQkNhFmX/ZP9tYA04cMFP4N7P
         ULwQ==
X-Gm-Message-State: AOJu0YxNR+Ch3WNWMMekzWPK6BnacXtL9os2iiKz9cE1R2anFIT87Icw
	kHFxsfLucMnkZTe7t8zmHIBw6XTpOO6AD11nitHSfGyXJivX8Nt4yATgYZ/4KyDGdACgKG/Ei95
	5wmHqdToJMYiYlQzh
X-Received: by 2002:a05:620a:2443:b0:775:6cf8:8da8 with SMTP id h3-20020a05620a244300b007756cf88da8mr43237643qkn.32.1697468289004;
        Mon, 16 Oct 2023 07:58:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFH1XUPIq/8zsNJ+zGr1DyiPdmgqD5oy4QXhwY1W2dDZ9ifLTBchtdNCC4MzTOvWKif9UHV6Q==
X-Received: by 2002:a05:620a:2443:b0:775:6cf8:8da8 with SMTP id h3-20020a05620a244300b007756cf88da8mr43237619qkn.32.1697468288730;
        Mon, 16 Oct 2023 07:58:08 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id o23-20020a05620a111700b007671cfe8a18sm3051684qkk.13.2023.10.16.07.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 07:58:07 -0700 (PDT)
Message-ID: <75297f46-d1d7-2519-cd76-8b6c2246dbb5@redhat.com>
Date: Mon, 16 Oct 2023 16:58:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: arm64: Do not let a L1 hypervisor access the *32_EL2
 sysregs
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231013223311.3950585-1-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231013223311.3950585-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 10/14/23 00:33, Marc Zyngier wrote:
> DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
> UNDEF when AArch32 isn't implemented, which is definitely the case when
> running NV.
> 
> Given that this is the only case where these registers can trap,
> unconditionally inject an UNDEF exception.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arch/arm64/kvm/sys_regs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0afd6136e275..0071ccccaf00 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1961,7 +1961,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	// DBGDTR[TR]X_EL0 share the same encoding
>  	{ SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
>  
> -	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
> +	{ SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 },
>  
>  	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
>  
> @@ -2380,18 +2380,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>  
> -	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> +	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
>  	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
>  	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
>  
> -	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
> +	{ SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
>  	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
>  	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
>  	EL2_REG(ESR_EL2, access_rw, reset_val, 0),
> -	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
> +	{ SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x700 },
>  
>  	EL2_REG(FAR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),

