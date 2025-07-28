Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E0B1D5145
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753719333; cv=none; b=XYyhZVKDea49H79sZ7cG5yzMjrQqq80FqyygNh9UH3N10XeRe9594dotSPfWSMGD4hdGYB1th9Ew0Mmy6+q+6E0jF5jJfD20vLzeVaTHmS7eqT2s/WP6T8wuxOYBo9w0fgZEWezQogebe7zTOisAHWO9QnKDIkQdkfi3bdX+ZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753719333; c=relaxed/simple;
	bh=EBhzNucok/TPWsVp3V0HBuyiJw4ckHclLe6R9HpKU3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o0/q9abHHf93nw/DXHYmDSj8AwOJSlPPGE8J9TzG7bwkCPgpflotZytYS4IcUz9X1l5eqHse20h3s7S6sGaNwPyLZAauDwawl4viNltNMYHvOB4gkrrXOpDfyG0MqHOnqVUR+LV/BGHiuOLeJ1+81n+24fo4pCdXIipQ9ZQou7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O33Xwk1z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O33Xwk1z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753719330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mT34Ny0FmRNZRhIGCkTyjpPrmAjp4dyQwyJBRtQx4a8=;
	b=O33Xwk1zwiqwfycKqEVQm6Jo8K5Upiv1QgpSjwup7vQ5Mc9tvYz9zk2oPYujjMQnIP2/G6
	JyYyAUiWfQp/PJUAOo6ikLBkobviAgCJiTMKC7N/mlfPSlv+Amfl3z1ib7owqDrwNmhERo
	60awyh/Pr8omU9EuncmzbC3DG/JvuB8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-CO1SQaMTOv2q1ZmFRzF0ZQ-1; Mon, 28 Jul 2025 12:15:29 -0400
X-MC-Unique: CO1SQaMTOv2q1ZmFRzF0ZQ-1
X-Mimecast-MFC-AGG-ID: CO1SQaMTOv2q1ZmFRzF0ZQ_1753719328
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ae371f9e3f5so3887466b.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 09:15:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753719328; x=1754324128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mT34Ny0FmRNZRhIGCkTyjpPrmAjp4dyQwyJBRtQx4a8=;
        b=pHDha7o80lKDR56juU/O1t+OSLd37945KX9+HgZd/AJeagxjjxx2KjVcEv/C134buB
         xc3c6HOXl7lBh/2+Kcwp3uULyylu9l2dGsWb0AnCkb1Tgq6LXm8Ci9/1x2uX0NBgrvk2
         XA6Wpm+rlvLgjakNIzzu/XqqVoxNVsxrhDz/8Xu5am44BFcs8HPWos0wEPuYdAKH5TRV
         bpX6DOcoAsL6HjoNDlT9EvjK+YzREW1WQvqSoSaQmaoOqkcxiBMVTIMWejLoNkQWkc0t
         p2WTsgALSQ/uXpXLrZixMdldOEro3RCND8QPPyFqpXlUw4nCzBX2ePN9NXy/kvmNqg3R
         CkcA==
X-Forwarded-Encrypted: i=1; AJvYcCWGCFwGoYKXZpR9y/uUwL/ma/AkKbg/zUzUZXIdJY9lqPk6qSXPaRnKixehIgQepzgsdfP52hc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw17EzgsvtYqjHdvZMjmP8H3zk7h5/pyqx4aT99VJmrCMLZAR5U
	6B/a5A3L5sOvyRHb1eOjra04wXhS4D40UxZKRNtq3U1x8oBMM+z0RVz5BejiF/w5+30Bt1qTZ6t
	wwFUXnElLmPWrcti0slekwVcgWyQ/qlzpVJX7EAITaOaYEYsHirx91fUJLcPam4Oj/w==
X-Gm-Gg: ASbGncswdfywSPHqzFejs7N6TUV5lRcbJpgop8nMx932KqiAPVdzQV82k/cTU8SSFmk
	CxtIFwkX6YFfCvoJriCpPID12+Wk0sTwMdqx9lcr0tIeKbsTFdBHCpv70nTQVA8+PppkgdFGlWK
	j0gsP5HDreQkHpl01nJGmu3WTovc2Kn2fjZp2PzkR/7SUJoaXmcredsx1deZ056lBqmgg6EYqiR
	hnpysAQDfj9WC3GSVuu5GQwsg6z1NA6TAUoOBT5CTz3YEPRwQ39emfD2Gy+fZ6d5/mV5/+FG6p/
	eYk6EQeWRe2Te/2Nsq45uPlPMuTHYSL4njeQaWpssS1MTYiASe48tlqItAdugB2ICkwZ
X-Received: by 2002:a17:907:6d07:b0:ae3:f3d7:d302 with SMTP id a640c23a62f3a-af7bfd85f18mr20401666b.18.1753719327585;
        Mon, 28 Jul 2025 09:15:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLC2Uj2VFJi8Dshxx2zedjzAsvfhDqTptAVI5f9B3UN+iBa1DMOc7Ai42zX/zWBcV3bnLFUw==
X-Received: by 2002:a05:6000:2287:b0:3b7:590d:ac7d with SMTP id ffacd0b85a97d-3b78e3dd99bmr145675f8f.1.1753718868193;
        Mon, 28 Jul 2025 09:07:48 -0700 (PDT)
Received: from [192.168.3.191] (228.246.150.77.rev.sfr.net. [77.150.246.228])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b78d45d010sm560176f8f.8.2025.07.28.09.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 09:07:47 -0700 (PDT)
Message-ID: <3dce347c-80e1-4481-b501-422957e9649d@redhat.com>
Date: Mon, 28 Jul 2025 18:07:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] KVM: arm64: Allow userspace to write
 GICD_TYPER2.nASSGIcap
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
References: <20250724062805.2658919-1-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250724062805.2658919-1-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ldMzALq6TGlDJfylEf8HAd8PjqrGj8lgJ7326BHKck8_1753719328
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 7/24/25 8:27 AM, Oliver Upton wrote:
> v4 -> v5:
>  - Fix polarity of nASSGIreq masking (Ben)
>  - Explicitly call out some subtle changes made in changelogs (Eric)
>  - Avoid open-coding irq_is_ppi() (Eric)
> 
> Oliver Upton (4):
>   KVM: arm64: Disambiguate support for vSGIs v. vLPIs
>   KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
>   KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
>   Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Raghavendra Rao Ananta (2):
>   KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
>   KVM: arm64: selftests: Add test for nASSGIcap attribute
> 
>  .../virt/kvm/devices/arm-vgic-v3.rst          | 17 +++++
>  arch/arm64/kvm/vgic/vgic-init.c               | 21 +++---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         | 70 ++++++++++++-------
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 33 +++++++--
>  arch/arm64/kvm/vgic/vgic-v4.c                 |  4 +-
>  arch/arm64/kvm/vgic/vgic.c                    |  4 +-
>  arch/arm64/kvm/vgic/vgic.h                    |  8 +++
>  include/kvm/arm_vgic.h                        |  3 +
>  tools/testing/selftests/kvm/arm64/vgic_init.c | 42 ++++++++++-
>  9 files changed, 150 insertions(+), 52 deletions(-)
> 
> 
> base-commit: 86731a2a651e58953fc949573895f2fa6d456841

