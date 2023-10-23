Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1E81CA96
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 16:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y37h+xBu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698077923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ut5czDDze7j+1Ijghpb8c61xr1AzZHB+GaM5+Au8mg8=;
	b=Y37h+xBu48xXMEkKwxO2g1TbzZLGb0rAGeNJqKgrVFMEQY/N581vXIClZA6b29yNyJXAax
	177iu4YgL+ZZcGPTeeaTTidxDYqI3kiq9vWc4YWuttZObuAt314HDHsFRsTbpmRn+J8+gj
	09YQV1EgizStjl5H3CF6WqehfxOzNXM=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-3iGDmm5pNmO1IXrIyNgAAw-1; Mon, 23 Oct 2023 12:18:39 -0400
X-MC-Unique: 3iGDmm5pNmO1IXrIyNgAAw-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7b6dd44b2easo2092363241.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 09:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698077918; x=1698682718;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ut5czDDze7j+1Ijghpb8c61xr1AzZHB+GaM5+Au8mg8=;
        b=eanJ1sWs2wEv70nTEcLaR6mfums1L0SfHX4iUnx6HSu4E2Cbxp1jwroHrxdP9+RWl2
         dsRoeyGAecaqFX9ZTjMx9jde2FN3dhVAyvgElAmztCdk13ykFiDNNGwvxHGQlS1x3zxm
         o4cp8foMZmvTXnAUgJpJIQLuBdn6KZZk+0DQzkOn6qfAUlnhG7F7ptKaCKKmqC52VkjZ
         ru0yaD1tOj/O6Vm1Wh6CiFFLP/3SDYtU56rpJliJXLxPLRLXqVnFMamwV5W0YE5xqhTe
         WBRGtK2pvNFFl0zTMOUWpYLkrzmwFzpjByPN6rOfrFiyOSG+DPdBsBaUIG9o4LuaKO0q
         PKeA==
X-Gm-Message-State: AOJu0Yyd2km5WZJrV+6caPsEWdNU70ZXZdXBBtE6vpcnDpcgdWrjCKzO
	bV4cc9t9uBDCWI3aROmMuhsuTdCNEvhPih44RMnLiQ9Bx4yesLn+QY34gjsbsOes18N9hFIqzz9
	ezSL1I9EFvi4F2Bdj
X-Received: by 2002:a67:c10e:0:b0:457:c9d2:4624 with SMTP id d14-20020a67c10e000000b00457c9d24624mr8598330vsj.31.1698077918692;
        Mon, 23 Oct 2023 09:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFy1dmvGf+TonaCRs35u3TvwOvOFfRZJMQ/9/d4CfnqFCwWVFMvLeUqOSxJgjtTj2FHYBzaXw==
X-Received: by 2002:a67:c10e:0:b0:457:c9d2:4624 with SMTP id d14-20020a67c10e000000b00457c9d24624mr8598309vsj.31.1698077918408;
        Mon, 23 Oct 2023 09:18:38 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id d9-20020a0cf0c9000000b0066d12d1351fsm2925982qvl.143.2023.10.23.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 09:18:38 -0700 (PDT)
Date: Mon, 23 Oct 2023 18:18:32 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
    Alexandru Elisei <alexandru.elisei@arm.com>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
    Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
    Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v8 03/13] KVM: arm64: PMU: Add a helper to read a vCPU's
 PMCR_EL0
In-Reply-To: <20231020214053.2144305-4-rananta@google.com>
Message-ID: <07c09e70-a337-aa41-f022-7ea43be2c0c0@redhat.com>
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-4-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 20 Oct 2023, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
>
> Add a helper to read a vCPU's PMCR_EL0, and use it whenever KVM
> reads a vCPU's PMCR_EL0.
>
> Currently, the PMCR_EL0 value is tracked per vCPU. The following
> patches will make (only) PMCR_EL0.N track per guest. Having the
> new helper will be useful to combine the PMCR_EL0.N field
> (tracked per guest) and the other fields (tracked per vCPU)
> to provide the value of PMCR_EL0.
>
> No functional change intended.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

