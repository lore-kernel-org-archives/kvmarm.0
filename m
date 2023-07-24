Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B39B8C0F
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690208361;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYb22kh8alG5LlKzDg2tPXggiu0mwrnQvKEj35bhOe0=;
	b=NAY1nd1wFEMqSZcnR9AFgKSe3o2VbypdwrjCWMN/HkNv2rBM7KsvotbxUdtOvVKOpcqdov
	PAF9o41IKnWOqEpKe4Xa6XQavirBMBodBy/SWLFsVTFFS4LENTXPhTXJJt54rjyQ/SpCb1
	iRLAPAQ66rjRcTva4OEJy4O99Iy4Irw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-u8Gem7GzPWCxc4aSZz6c_Q-1; Mon, 24 Jul 2023 10:19:19 -0400
X-MC-Unique: u8Gem7GzPWCxc4aSZz6c_Q-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-315926005c9so2079970f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 07:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690208358; x=1690813158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYb22kh8alG5LlKzDg2tPXggiu0mwrnQvKEj35bhOe0=;
        b=jPgX7c/i5eIQGKiayMXFr6c49Tt2FhIrD/rizru3hgv7bns6pCOgAY0SVkokQzSoRo
         NCveVqAeEVuzpM22tDwLmaoYJzHsXDgrsCNYRS8pckT4jiriWkqiisSbqAXeM5ee+LQ8
         M234I7vwHa3UmFsG/1VxIk0N6DRWjvwT6F8V7fG+riXDtoOWOlJ6XzFwtXw7GtauMLde
         e0NmFrYfYkizjRBN5hFYH1k7ctw5a0o+doWMdBtvvYvti6sD+ga83uvKOywcgmNV30Rt
         IY1qD7ZhYPFbp4UEQjU3mXTEmiPsnEXrYLgGgauGc/nyAt7QXRq/+1kms6HJsxVOFYI+
         vtBw==
X-Gm-Message-State: ABy/qLa8v3daV2wk3rx4JaTXxHOymxWD7axs3N5sbH8jiadZNh9R1HxR
	ON0UW1xa5drYB7a512D7tdyjvlh7uzmaCoJhzHLChO8BuAdGM6jv3+zg0mWT58grWoGpcgMyl8Z
	K/u/jR/SMr4i2XSCF
X-Received: by 2002:adf:fec8:0:b0:313:f86f:2851 with SMTP id q8-20020adffec8000000b00313f86f2851mr8405350wrs.3.1690208358607;
        Mon, 24 Jul 2023 07:19:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHiN6PfAHm+REFxXPgyrCMH7IJrGgE0MY5oSex6+ZDc0enUBoZlnmj7g2oP/jjonWtKKrjNLA==
X-Received: by 2002:adf:fec8:0:b0:313:f86f:2851 with SMTP id q8-20020adffec8000000b00313f86f2851mr8405329wrs.3.1690208358308;
        Mon, 24 Jul 2023 07:19:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id j5-20020adff005000000b0031764e85b91sm1394262wro.68.2023.07.24.07.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 07:19:17 -0700 (PDT)
Message-ID: <84951ac4-fe2c-e181-9beb-223d360b87ef@redhat.com>
Date: Mon, 24 Jul 2023 16:19:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 11/27] KVM: arm64: Correctly handle ACCDATA_EL1 traps
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-12-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-12-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Hi Marc,
On 7/12/23 16:57, Marc Zyngier wrote:
> As we blindly reset some HFGxTR_EL2 bits to 0, we also randomly trap
> unsuspecting sysregs that have their trap bits with a negative
> polarity.
>
> ACCDATA_EL1 is one such register that can be accessed by the guest,
> causing a splat on the host as we don't have a proper handler for
> it.
>
> Adding such handler addresses the issue, though there are a number
> of other registers missing as the current architecture documentation
> doesn't describe them yet.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 2 ++
>  arch/arm64/kvm/sys_regs.c       | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 6d3d16fac227..d528a79417a0 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -389,6 +389,8 @@
>  #define SYS_ICC_IGRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
>  #define SYS_ICC_IGRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
>  
> +#define SYS_ACCDATA_EL1			sys_reg(3, 0, 13, 0, 5)
> +
>  #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
>  
>  #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bd3431823ec5..3a6f678ca67d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2151,6 +2151,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
>  	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
>  
> +	{ SYS_DESC(SYS_ACCDATA_EL1), undef_access },
> +
>  	{ SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
>  
>  	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

