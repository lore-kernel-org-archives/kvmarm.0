Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B8834CFD3
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784646207; cv=none; b=SgTFL9fodtlQQwNEtCCgPEDM2lB4ANahnRLnLdxNnzg37sSB3JMEWusRI2RPoXmS3++LhIH2hmljhjrvfX3QVSiA6MdHy56wL3hSxpgOL6IrW1oSUkR3eppuBTDo5wxwQ84esoHOd/kLUqAn1mezcM8W6ammQG92tf5VWPrmd8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784646207; c=relaxed/simple;
	bh=fF6pOV3Aqd0Fkv980PC1XUaAGPByA/Ga5SW4/I3I5SQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KuDjmi/wBknyZZYjRc/Y14//2D3gs9scPtQQIsgVlqK6+razCa737gxdOgOgkO4QB5PWb4Z6uIUgl7pW8FjpyAGIfElqbD1G2lqae9zmu/8Nkaf550A91SAdXdtk626GyzRP4kaWfjwlumQPr1xmPi1ngf2oGNw/UIysu0lZy1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MmAviGzM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MmAviGzM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784646205;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AljakpZ1zPJEZ1/BQ+JkJtG/8jB+hyqekVs37VGAoBE=;
	b=MmAviGzM1LEHlQVRv5gmtDUs2X7Xmay7/SEwQOJpEEqJz59DMRX6U/igcW75m56I3rHEoy
	jURSWVdYrtKjdABkq/nchP2Iu3YML3kfjP9szwevTL/xQj5Q+iskp7Ztu4FHFKyIqTEOaK
	AjIM3rhEpXbZzoRIxarKABBcs/ER5eA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-PJ6XrWrhPaOpR8ZPVISlzA-1; Tue, 21 Jul 2026 11:03:23 -0400
X-MC-Unique: PJ6XrWrhPaOpR8ZPVISlzA-1
X-Mimecast-MFC-AGG-ID: PJ6XrWrhPaOpR8ZPVISlzA_1784646203
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47f83450a8eso335813f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 08:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784646202; x=1785251002;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AljakpZ1zPJEZ1/BQ+JkJtG/8jB+hyqekVs37VGAoBE=;
        b=KjnrPedAGLgcutMnALtnJC8Dss0YqNl5RSgN0aZ/Ds5xvasUKJG8eGBtUOrV6MjJcO
         Wkl3fEIXeSEX1i6pvHByJPZ6qeCIcnUxTfq4WbWUiSQED+c+31ENgFqF4Luk2UY5JCwI
         AKOjbY2gT5teoi8rtAV6K4RTD6cT8KZdeLpEGEoblpJUxoYKcMVHijLg77rPpsj2RxOL
         1ucAuCU7oAgow1DIUAjrlULB0fC2d9JfGsCLk/VLVTMiPqs28cVPL4sMGFud8kz0X2nI
         CLYsA8TpvELUnVxnuhtZj3IGHM+NDGUWbRw2OuACkKN7le0S4CDzXJppc183K70l71OW
         LvAA==
X-Forwarded-Encrypted: i=1; AHgh+RpdqjZNEjs4oCC5Ign3M6foQX0TMSRywtRgq7CGxswT+iAgM9MYcQNp8srdzEIbNS4Xi2tw2Y8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyXcywZciTlKygz4MmBlw62ixl6EiSJGbPPKswTzDVe7Mk5Wqu
	4mBeXtvX2XIkwGyLBofjuqg4xvXtQDxwn2TSfMP3TGudBlxh0h6vEVoOK5sONee9tVKDWn5tVRK
	WcHm22MjRSV+EQb1LZSxwU6ejRvLrnNnZK9zKYBbNVMhLsjuhpDu1FRbaTw==
X-Gm-Gg: AR+sD12guWeJ1dSwvlhQwI7AxnGcfyQKZ5VYMgVZpxLr2SnCwb0utP6YO/4xBIhghCt
	D4xB5Cr+fXFJkJi6a64M9amOa96ml1a01gIDDoWUcN8LKQl29CvNTeY/v0lycXPCd4xHcp9agrf
	HBZwkgYbX+RN76w4zssymwiC8LsMb7l9yUsFKwcHyXn5fH5yed7yHXGrrclvbr7KnOLvwKQKoTn
	Jzm0ZhavOAIX4VUYRYrvge/enKT8uihSzC8n2XyPxaUw/Bi7t5UwzGLGArDgqQ2j+HN7FSQdGcL
	v41RSz7D0/L95ukrQGLk/SLwYhYy2n66zrkb+TKNpVDVjEcDnD8Ph9JS2zLB8sLMGgcochtQqYx
	CmbReYbabfM1R5s7DlgsnBGlp84fsf9IV2wTCK7qjFr0lKSAC
X-Received: by 2002:a05:6000:26c5:b0:47f:6f89:7dae with SMTP id ffacd0b85a97d-47f6f8982e7mr16829481f8f.6.1784646202541;
        Tue, 21 Jul 2026 08:03:22 -0700 (PDT)
X-Received: by 2002:a05:6000:26c5:b0:47f:6f89:7dae with SMTP id ffacd0b85a97d-47f6f8982e7mr16829417f8f.6.1784646202167;
        Tue, 21 Jul 2026 08:03:22 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e519f4sm38082413f8f.14.2026.07.21.08.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 08:03:21 -0700 (PDT)
Message-ID: <da8487e6-2253-43ef-967e-b4d3daf3808b@redhat.com>
Date: Tue, 21 Jul 2026 17:03:19 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 05/19] target/arm/kvm: enable writable
 implementation ID registers
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 prerna.saxena@nutanix.com
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-6-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260716213858.609699-6-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IbYNanGJpxmD0CQnf_FgFk_EHQFEbkck80d5m8LVUkc_1784646203
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 7/16/26 11:38 PM, Khushit Shah wrote:
> Enable KVM_CAP_ARM_WRITABLE_IMP_ID_REGS if the host kernel supports it.
> This allows QEMU to write implementation-defined ID registers (MIDR,
> REVIDR) so that named CPU models can present the correct values to the
> guest instead of inheriting the host's identity.
This is a subset of 
[RFC PATCH RESEND 0/4] hw/arm/virt: Add support for Target
Implementation CPUs
https://lore.kernel.org/all/20250801074730.28329-1-shameerkolothum@gmail.com/

and especially 1/4

Thanks

Eric
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/kvm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 76583db3f0..63b3727e05 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -741,6 +741,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          }
>      }
>  
> +    if (kvm_check_extension(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS)) {
> +        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0)) {
> +            error_report("Failed to enable "
> +                         "KVM_CAP_ARM_WRITABLE_IMP_ID_REGS cap");
> +        }
> +    }
> +
>      if (s->kvm_eager_split_size) {
>          uint32_t sizes;
>  

