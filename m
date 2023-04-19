Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F723236
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681899712;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MJWc02GF36vWFoiC/4W/mdrYHVlDhjvglDB41LlD6E=;
	b=EXZEzMUp6tMHukUR2wWOLT+h38aIYaIdcu/FEJll3+5w88N2QB6oY0dDqF12O1YnPeW8Ue
	vrg4n7AsNiiLsyWxQHXn/TihCRDoXm2OYmahttGmDKk4i2DyxihWr9UOrRL+2XtAcLCTZs
	4QWt14m7eMbSuhPy9uwqJXcJPTDZgLo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-kUqicBWoNU-wGdLf6lnQUQ-1; Wed, 19 Apr 2023 06:21:48 -0400
X-MC-Unique: kUqicBWoNU-wGdLf6lnQUQ-1
Received: by mail-qt1-f198.google.com with SMTP id v24-20020a05622a189800b003e0e27bbc2eso22246029qtc.8
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 03:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681899708; x=1684491708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6MJWc02GF36vWFoiC/4W/mdrYHVlDhjvglDB41LlD6E=;
        b=QltdZv+8ZgoSjuPNcUBkdpdvZfqC44XKBB6lvxu+9XDS4aWtZhL0ervigyiC/l1Zlm
         jO0L9jIiqZ0U3QlW/fLf0ODLRl6yzfLhGtQUfhbFnZtQsRESebb53v1pjEKuXYeVLKNx
         6OPLib3viLvEwaKaFXGM75KJXQdn11qKtH3VSuQqSOuxSE61cJLE31QHcSqQ1Ei3jyRY
         OTt0BePmA//5IEVDaIqvXQHNlPYM0dpfb7FCwX7I2wZKqVmJN7nM7/COtYpmtci0htJ3
         qBPlls3TyjZre5XxPP8AmS93YvKASsJx0kBdjbJFmX4Ifz4lpcI8saMAsYpDBtA+6NQR
         W5jg==
X-Gm-Message-State: AAQBX9caL9taco8kCntbLD2RSuZV4yuyZO7nYN0OAz/L/LnxLEx7dFZb
	fJnwCjRqj4tgHwB5vMbIMU8mN3v0mm2VA0Pjkd4AsY+JHQegDt66trhirvOfPn/DgXVv+fLZHsx
	ExybdffUbe9hsCKKn
X-Received: by 2002:a05:622a:181b:b0:3d0:7bdf:42c4 with SMTP id t27-20020a05622a181b00b003d07bdf42c4mr5078028qtc.59.1681899708339;
        Wed, 19 Apr 2023 03:21:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350YpAI4fcVswfakOG1UiC1eLrxoW/AQvarJ7AgPwbl3dPvN82163SakVRvB7U8Rf/LzrrxVjaQ==
X-Received: by 2002:a05:622a:181b:b0:3d0:7bdf:42c4 with SMTP id t27-20020a05622a181b00b003d07bdf42c4mr5078009qtc.59.1681899708037;
        Wed, 19 Apr 2023 03:21:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m12-20020a05620a214c00b0074ded6ad058sm2321278qkm.129.2023.04.19.03.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 03:21:47 -0700 (PDT)
Message-ID: <1cefccb2-c3b2-8c72-6c28-c6fcae0bb2f0@redhat.com>
Date: Wed, 19 Apr 2023 12:21:44 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2] KVM: arm64: Fix buffer overflow in
 kvm_arm_set_fw_reg()
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Andre Przywara <andre.przywara@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kernel-janitors@vger.kernel.org
References: <4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/19/23 12:16, Dan Carpenter wrote:
> The KVM_REG_SIZE() comes from the ioctl and it can be a power of two
> between 0-32768 but if it is more than sizeof(long) this will corrupt
> memory.
>
> Fixes: 99adb567632b ("KVM: arm/arm64: Add save/restore support for firmware workaround state")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> v2: The original patch was okay but checking for != sizeof(val) is
>     stricter and more Obviously Correct[tm].  Return -ENOENT instead of
>     -EINVAL in case future ioctls are added which take a different size.
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
>
>  arch/arm64/kvm/hypercalls.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 2e16fc7b31bf..7fb4df0456de 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -544,6 +544,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	u64 val;
>  	int wa_level;
>  
> +	if (KVM_REG_SIZE(reg->id) != sizeof(val))
> +		return -ENOENT;
>  	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
>  		return -EFAULT;
>  

