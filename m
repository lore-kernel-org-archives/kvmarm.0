Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795767253;
	b=I87rcOJdZPeDL1NeSIRYm6BMkTiTLmiNsnuydVK35WCQJQMQQlHdQbVb1fAsFj4Xyx7A
	 yTayZeKhnBnwDULEkv+JO4/mhXT45eCszJxR69BLM5IT+c+Q7bk06XvbsblyU4kQavz5M
	 geOAhZLSDc34yd1xxVudHQWaIgbwkdPwXL1AnsjPMRoI7w/hvYeUUJZvqEzwnX8HSnL1o
	 B8YqJlHryQvWTzMObZUKrU0ZTM4NH8hWvfrmKWJ92PR6gIcENi+pvSrGDP+buGuGlFtjZ
	 sVQJFAEULv0SeyEhhmE3rfAYKqJatnBirXhYpuh5gKQBzF0t3X8AfsdYrMx+ijIsA8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795767253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Apk+wF3JIOKu8ET+h25TVTVOKsViveOnjA4s7dlaLmI=;
	b=r1uLNI6IriGcEGPRZMj4Rne/fHc8OXiil+kimGusKostAE604RYd0eR7W/pek1Ib16Uk
	 7wQqAO7l79RYu+JK1vRSwrZzRFdvgyNSFclijH2yzx8p9yO81JQaISriVU4Cb7LV42e+g
	 FE6xkcDAZrNmv7bG/4SxB7UvrKo2nrcYQ4DWqJcLM0TUK7ygMGY5O6AQjoxPpkeKqW8Vk
	 VmqGQcPUv4P5mo20sYE7KS0YtPBv3XnWJNnpH9y4Xwhc283EkLQQd8soOO0F2beoYgmd5
	 DE2mXWQ9AWMgW3Vqy+TlcuOu9BFIbNk6yy2FRWvaoaLecogKrtEuc3TzfpEmhEDD1gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=BkKFUNGE;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A7C606A327
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 08:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1A7C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=BkKFUNGE
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso4896641f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 00:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795767251; x=1796372051; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Apk+wF3JIOKu8ET+h25TVTVOKsViveOnjA4s7dlaLmI=;
        b=BkKFUNGEX86z2tUe7K2Z4mydLbA/EdYUrg23GUeXwZGOmb8sK/op3vU7EOK2D0y8K3
         ofez2k05BmbTx7/PO1lNFEDXuU0ZL/QuCWD6yYlm/lX0/6LM+/AS9gE1feY1yPnLVrAt
         PhuwNx8kmqKR9Bhxl3qylj+L6Trlu4DtILJhe5cBPU5OTflKqwpTLJTkNfJHegn+KVoe
         RmsgchLjTGBEVDCaRYo0OurRXR7r3MvbRnN+g79a2p4Ui/FbHyb5Fj/9MPy0ubI2hLAa
         KIbaowZn7Yz+txoYL1HriNs5brhV6cvTSVzQH1jC9CyrGJDFR6Ypr12Hgie0UbSx7xDG
         HTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795767251; x=1796372051;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Apk+wF3JIOKu8ET+h25TVTVOKsViveOnjA4s7dlaLmI=;
        b=2HhBLjHcYHTZtPdCHyWVDSpdPXJ6kpnCvU49yd5y09/z+o1RFzztG4T4HjT7yr4cw/
         DVL59GBJt7dZ7NzhLaDV0iJZ/uFVpw/Y21WxvgD0or0wSZFbQKJGYo3OXTkAMxFsFIKt
         BaWNIuPn6FsSuiwpmI8NTdF9j01UBSwcO/5So+FzASuGnXBB5+ehwxUngJdUtP8WG3lg
         ZHQBMmiNzagjRQr+yNgA/o0uXe+tx7pEf5c45IiUGyMVRA75xBhx4VD0QLZRIb+UZEcC
         jE8f0OVN+Cu6Jmp2be2/hqmFPuaAywgKBcCKxYWPhbo6OE5VbhaP3n06BpjL4m/yqrsl
         wQIQ==
X-Gm-Message-State: APuU4Z84H3tQrMWRkjD7KmKAZpkqrS/4mPH6eLFxHy4eCFgN3Ib7biTK
	IChb/dy69YFLiiL3cAURm5GfzMPugv6IESgnb53T77+Ra8k6IjPbRbOYdx8MAgwfeDM=
X-Gm-Gg: AZFdTZdUyhihHjdV+fywr2BDuOTz0mrQ+pyqYxFQwcFYyy2poZbR4uNTuB7SyVGydJp
	y1HWMQxHG9jSz/F2otPb55xok/6BI8l69jkb75HXfH6S1biFNxeFwXikE1FBqq3p3AEaG0m4eSo
	G5vHOpYCOxJoClasn3R3lKbnv+VI1oeINJDN7uqtoj5e2/esPhIP4azDCxXZu5mfYdINfMF3i6+
	Ldby/CLC1laAl6YgRp7Apt4hKJmTgJhbfi/Baxak5rkK6fgPkEpG/TBrYb3d+vXRytTMG1WzP6T
	x75oSSp8Z8t6gYyrbP4TKgV13xxMWDj9gMZWIK9hhgIKOmAC4BPrJ+adkIXnM065aQG/qvK3M+H
	9GYnrB54NhnlqF63KrkSj3ooEN2xhLtLkdKG9IXJBYK7EQ10zCaDa1f7x2fNVcfsEhvinUU1f90
	jrycSQcWwoprfT+CKQBE1eTuLy1cUBQsJkLvetW5+0g92cOr07HatA/6BWY9UzWogiiGg+Dpizm
	5ZdRei7VVbjQUOHT6q7fmwLRWoqG8y9D7c/Ynd8hX6zrQrvIU1CcABfgeTCCkbS8crejaXgaLxv
	jvtv35YJ1brn0439rBI=
X-Received: by 2002:a05:6000:40ca:b0:4a3:976e:27a2 with SMTP id ffacd0b85a97d-4abb5146238mr46038597f8f.34.1795767250897;
        Fri, 27 Nov 2026 00:14:10 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe75sm52271979f8f.24.2026.11.27.00.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:14:10 -0800 (PST)
Date: Fri, 27 Nov 2026 11:14:07 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH v2 09/16] KVM: arm64: Report faults from S1 walk setup at
 the expected start level
Message-ID: <awk7z5-ZlzQDqfcz@stanley.mountain>
References: <20250915114451.660351-1-maz@kernel.org>
 <20250915114451.660351-10-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915114451.660351-10-maz@kernel.org>

Hi Marc,

On Mon, Sep 15, 2025 at 12:44:44PM +0100, Marc Zyngier wrote:
> Translation faults from TTBR must be reported on the start level,
> and not level-0. Enforcing this requires moving quite a lot of
> code around so that the start level can be computed early enough
> that it is usable.
> 

[ snip ]

> @@ -351,12 +351,17 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  
>  	return 0;
>  
> -addrsz:				/* Address Size Fault level 0 */
> +addrsz:
> +	/*
> +	 * Address Size Fault level 0 to indicate it comes from TTBR.
> +	 * yes, this is an oddity.
> +	 */
>  	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(0), false);
>  	return -EFAULT;
>  
> -transfault_l0:			/* Translation Fault level 0 */
> -	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(0), false);
> +transfault:
> +	/* Translation Fault on start level */
> +	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(wi->sl), false);
                                             ^^^^^^
Switching this from 0 to wi->sl was obvoiusly done deliberately but Pereq
is trying to do formal verification based on reading the ARM docs and
matching it with the kernel and the AArch64.AArch64_S1Translate() pseudo
code uses a zero here.

>  	return -EFAULT;
>  }

Part of the issue is that wi->sl can be totally bogus.

   274          ia_bits = get_ia_size(wi);
                                      ^^
ia_bits is based on wl->txsz

   275  
   276          /* AArch64.S1StartLevel() */
   277          stride = wi->pgshift - 3;
   278          wi->sl = 3 - (((ia_bits - 1) - wi->pgshift) / stride);

so wi->sl is based on ->txsx and the "- wi->pgshift" subtract can
underflow.  We check txsz if is invalid later "if (wi->txsz > 39)" etc
but we still end up using the original "wi->sl" invalid start level.

If we made invalid values of ->txsz use zero that would fix my test
cases but it still wouldn't match the doc.

regards,
dan carpenter
