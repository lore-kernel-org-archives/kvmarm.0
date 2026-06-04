Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD63D890E
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 08:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780561685; cv=none; b=iCmWy36/A0Js2rpxY7V2kU484dVbhFsHEOFg1DTeX2zzsIv+1seNTDJjMN4Y5stsVoSc4T50u/G3ApH/tPd691nQ6fm/qm1QDdESXohm/8GDg9BiKgaGPIDOFkEFd1Xu76zQ39YamAJmUS0UQ++7N93KFO++pSUV3RCcE7tV+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780561685; c=relaxed/simple;
	bh=VBWeFRdBhxUXCMrHejtCkSh0CVrGdb/eFzCEALGrU2Q=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=cHiFkiHSD2po/ujlFoYQ2JbTMazCSx4tosTjkoz1uuY4MXHVEKPFTd9RFbGzdJxp/S8mPsbR3wj2ZHhkLvl5cZEuO64ksFEoqWAaJiLsOgxQ0OFSi9IZNMiVXoMEsBpxoYU5cTr2i+0mity1sYD3R3FQJdzLjBIXeA+jlnHZ83w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWTvHxHZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWTvHxHZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780561683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uIKj96R+mEy42VSULqrrxSvXG3JwcLwhhMAkRL+6Hlg=;
	b=CWTvHxHZO+bG9vAmJMj+DHurhOzSoJ7ZEbfITrPDIGceets2bEOR7y7XD+48dR3rE5k8Ph
	vNYTiUkksokchDOTN6psj1JRz/3WXeGIwRUYKmKEhDSEOlrGshqv4+5kEFEecDNwULgddW
	qSZ/HWNlDaJ2RT9TJLtPu7+L8hKpCGc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-JMsTe8KaOTu1pco3uHAwrg-1; Thu, 04 Jun 2026 04:28:01 -0400
X-MC-Unique: JMsTe8KaOTu1pco3uHAwrg-1
X-Mimecast-MFC-AGG-ID: JMsTe8KaOTu1pco3uHAwrg_1780561681
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490ace40f13so1908495e9.3
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 01:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780561680; x=1781166480;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uIKj96R+mEy42VSULqrrxSvXG3JwcLwhhMAkRL+6Hlg=;
        b=PzjWndJ/Sgk9PgFlmkiPi6frfIM/82GNq/NoZ3vIOZnGGnDI1grs76pcjeCSDFK2qK
         ASh1xcBxJUsn6zKzn+kBu3/YABjdhz+Uy6n7/g24oU0qraDCbBY6l2pBCq6S5d2GU5V1
         C/eOFykFj2aR+uzGn2sogZ/vAw4vZQ9H4AjcKqaApm50cF22hfztYAABeTyMMvh2NSgk
         HvM47JQL7tkTMbFsOCpgfOtRRvM+yl7VRwdJ3AVYsG1ISU+7giq2xb8Q65OOIVFkNs8d
         lwJG0eoCUguedjEWLPvSg7z+R4g0Mn/kZD6mSErrVgUoX2uYb1ZFCswaJIl3moAdJvfe
         goGw==
X-Forwarded-Encrypted: i=1; AFNElJ/1/EjShH0SpXbyrxZNKMtetGYAsxsm0Hk3D1+ZmhF2Mp6DMgssbngLpwcx8f0BXv18DHh1sb0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxE42Uk7ofg8AmBDAcFNsYQz37pX2R0kV4Q577y2mOKuUdMWFnq
	z1WsXst8VsYHHLvLGJSPSBRnLbkjNxIdx2UkZEj83A5TRGpj8ZJVi3GaoYMFR2J/oy+b6aXY7Gv
	+y3PinO4CEAeGzMC1mFVFtL6hc3iJLb5uUbeDqD+7JdSA7XtVnEj0lDtJkQ==
X-Gm-Gg: Acq92OG3jX2MQgSGELRSVsxyrJEa5v/n0MgMHXVnWTEb4RiUThHeDNi7bXmV1HkpNQP
	fIoFeqChSSqCxfIKIFwtazd8SDMWpOMNdlYnO9/gmQvSTOGlWA4MN2EQrlxB0qFPbLA3Ged/61V
	ZS1lJuiX5/pfFY1JQa3nDltRrZ11VGEo7jYeGnMpxWkJViBPZHCBVd80sgzylnaHrik4Tcqyf62
	lS472Pvgz4dmknilGn+XSTrhoIdyH96QzmDt+yjVhayHU7wNHKnyjmDZHkbhK8eiwniaqzTlZF0
	MoxG5MqLHdid2encXwj8M0RSE3zKEXgyE8EQk0NJtc1jcJmMHZyDKyJhiKbIwTTVHI6xaSrVVMq
	8n8VeSpWmSiR/MDu8XJJPHXuHgEUbsQ8bu4CJ3GrXsOTESGVyQlheVT6J92UGtw1iYFM0Dz6oWv
	g=
X-Received: by 2002:a05:600c:c10e:b0:490:51e2:bc86 with SMTP id 5b1f17b1804b1-490b5fe81a2mr85465555e9.23.1780561680664;
        Thu, 04 Jun 2026 01:28:00 -0700 (PDT)
X-Received: by 2002:a05:600c:c10e:b0:490:51e2:bc86 with SMTP id 5b1f17b1804b1-490b5fe81a2mr85465165e9.23.1780561680306;
        Thu, 04 Jun 2026 01:28:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b59f0sm61873985e9.2.2026.06.04.01.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 01:27:59 -0700 (PDT)
Message-ID: <76355fdf-4658-4e3c-8dc5-d3aae8399dd8@redhat.com>
Date: Thu, 4 Jun 2026 10:27:58 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v2] KVM/arm64: vgic-its: Make ABI commit helpers return
 void
To: Jackie Liu <liu.yun@linux.dev>, maz@kernel.org, oupton@kernel.org,
 linux-arm-kernel@lists.infradead.org
Cc: yuzenghui@huawei.com, will@kernel.org, kvmarm@lists.linux.dev
References: <20260604075147.53299-1-liu.yun@linux.dev>
In-Reply-To: <20260604075147.53299-1-liu.yun@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WmhZ1UsbtFYMwjPQ84keidkOlZkiDYrHBcaw2wbyTqU_1780561681
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jackie,

On 6/4/26 9:51 AM, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> The return values of vgic_its_set_abi() and vgic_its_commit_v0() are always
> 0 and do not carry useful error information. Simplify by changing them to
> void.
> 
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 1d7e5d560af4..ca48b34dec20 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -27,7 +27,7 @@ static struct kvm_device_ops kvm_arm_vgic_its_ops;
>  
>  static int vgic_its_save_tables_v0(struct vgic_its *its);
>  static int vgic_its_restore_tables_v0(struct vgic_its *its);
> -static int vgic_its_commit_v0(struct vgic_its *its);
> +static void vgic_its_commit_v0(struct vgic_its *its);
>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
>  
> @@ -168,7 +168,7 @@ struct vgic_its_abi {
>  	int ite_esz;
>  	int (*save_tables)(struct vgic_its *its);
>  	int (*restore_tables)(struct vgic_its *its);
> -	int (*commit)(struct vgic_its *its);
> +	void (*commit)(struct vgic_its *its);
>  };
>  
>  #define ABI_0_ESZ	8
> @@ -192,13 +192,13 @@ inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
>  	return &its_table_abi_versions[its->abi_rev];
>  }
>  
> -static int vgic_its_set_abi(struct vgic_its *its, u32 rev)
> +static void vgic_its_set_abi(struct vgic_its *its, u32 rev)
>  {
>  	const struct vgic_its_abi *abi;
>  
>  	its->abi_rev = rev;
>  	abi = vgic_its_get_abi(its);
> -	return abi->commit(its);
> +	abi->commit(its);
>  }
>  
>  /*
> @@ -472,7 +472,8 @@ static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
>  
>  	if (rev >= NR_ITS_ABIS)
>  		return -EINVAL;
> -	return vgic_its_set_abi(its, rev);
> +	vgic_its_set_abi(its, rev);
> +	return 0;
>  }
>  
>  static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
> @@ -1888,14 +1889,11 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  	its->baser_coll_table = INITIAL_BASER_VALUE |
>  		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT);
>  	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
> -
>  	dev->private = its;
>  
> -	ret = vgic_its_set_abi(its, NR_ITS_ABIS - 1);
> -
> +	vgic_its_set_abi(its, NR_ITS_ABIS - 1);
>  	mutex_unlock(&dev->kvm->arch.config_lock);
> -
> -	return ret;
> +	return 0;
>  }
>  
>  static void vgic_its_destroy(struct kvm_device *kvm_dev)
> @@ -2610,7 +2608,7 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  	return ret;
>  }
>  
> -static int vgic_its_commit_v0(struct vgic_its *its)
> +static void vgic_its_commit_v0(struct vgic_its *its)
>  {
>  	const struct vgic_its_abi *abi;
>  
> @@ -2623,7 +2621,6 @@ static int vgic_its_commit_v0(struct vgic_its *its)
>  
>  	its->baser_device_table |= (GIC_ENCODE_SZ(abi->dte_esz, 5)
>  					<< GITS_BASER_ENTRY_SIZE_SHIFT);
> -	return 0;
>  }
>  
>  static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)

