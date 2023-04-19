Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC092580
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 08:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681894357;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MfypgQsAQvvSjwfduKvBH962yEP7d/91W52VY+6PCr0=;
	b=MXGuNgnzUkS9CTbAsu9BJ0C2geHj0lkdy00Lb4g42vZ2Dbr/hoIyX7t4qtOTm8SIw7TTne
	WwFBNRBI7mP4ePss1+H35BawjYIN6l+qV+OxLT0AW9yHpOmdsiXX8tmcK5d0ehxmqsq/io
	0wWV63D6qJCC0h4k4c2zPpVGnB8bOj4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-DGoLL94wPry52YK64Q5FBg-1; Wed, 19 Apr 2023 04:52:35 -0400
X-MC-Unique: DGoLL94wPry52YK64Q5FBg-1
Received: by mail-wr1-f70.google.com with SMTP id v16-20020adfa1d0000000b002f64d93cfd4so2344850wrv.14
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 01:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681894354; x=1684486354;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MfypgQsAQvvSjwfduKvBH962yEP7d/91W52VY+6PCr0=;
        b=klifRIwhVUFkCyUkMRfEKC3I65R5wwohiL8vBTHMt6vFKGUPHxYhC5axOWyxf5MiJq
         sPB2a4Dq2n72Li9LFdxt23PK+4/H+C882fOt6fHFhc6QJSl9KjmrTZW5VYvzBPmtdXax
         8N3pUIyFFLBDUbpVYd+B7T4KLZGqRnaAvMmpuZoPj0FFtf5At2AW7T16ykrOZM6uAEz0
         lLAD98GowgCe55/YjkCKdBs/UDYLiGrYTyLvYscS16wz1dmCRWryUvYLjHe/1lYat0CC
         8tgJNNgD0ocytwatyq+BCEOj12W1K91XfyJDW8ufucn0TnTRIp8/g0MTPrQgk1bzpGPR
         ovFQ==
X-Gm-Message-State: AAQBX9epswqgSwm2jR5Ds/sE7k27iJN/D3SCI5VNAhJE0ed15K1OVnFn
	k+NVRKWZejrQivlVgYNwBQqBcbjIpGXDWYzVeX3OXVZ5CK15ifVI0eNk3Wz6Ecp9D69XpEv2J7q
	dwwh6lPf4NJKLD/YN
X-Received: by 2002:a7b:cb06:0:b0:3ed:af6b:7fb3 with SMTP id u6-20020a7bcb06000000b003edaf6b7fb3mr16716916wmj.2.1681894354705;
        Wed, 19 Apr 2023 01:52:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZQnCD49jcyev3aaN5LzVuV1X+Aeh6G7SGm7l6bRVobSz0tb5+piU6WxZjxdgpFEG0DgimvJw==
X-Received: by 2002:a7b:cb06:0:b0:3ed:af6b:7fb3 with SMTP id u6-20020a7bcb06000000b003edaf6b7fb3mr16716897wmj.2.1681894354443;
        Wed, 19 Apr 2023 01:52:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c228400b003f17e79d74asm1525878wmf.7.2023.04.19.01.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 01:52:33 -0700 (PDT)
Message-ID: <efa8edbb-c964-0552-8cd7-faf1b2c83cca@redhat.com>
Date: Wed, 19 Apr 2023 10:52:32 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Andre Przywara <andre.przywara@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kernel-janitors@vger.kernel.org
References: <ab7b9caf-5c90-4616-8517-b38637293639@kili.mountain>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ab7b9caf-5c90-4616-8517-b38637293639@kili.mountain>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Dan,

On 4/19/23 10:06, Dan Carpenter wrote:
> The KVM_REG_SIZE() comes from the ioctl and it can be a power of two
> between 0-32768 but if it is more than sizeof(long) this will corrupt
> memory.
>
> Fixes: 99adb567632b ("KVM: arm/arm64: Add save/restore support for firmware workaround state")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm64/kvm/hypercalls.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 2e16fc7b31bf..4f5767fcaca5 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -544,6 +544,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	u64 val;
>  	int wa_level;
>  
> +	if (KVM_REG_SIZE(reg->id) > sizeof(val))
> +		return -EINVAL;
>  	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
>  		return -EFAULT;
>  

