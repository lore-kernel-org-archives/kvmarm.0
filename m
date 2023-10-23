Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22AA1CA96
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROVJYtLn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698078012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k37AOFeZP6MoGUQ4Vb6wM81gZSQoevmW3tnnk23uv6g=;
	b=ROVJYtLnwxvg1OUNOtTTJXMB2VFWCYZWg3RBsK8DSjoBUJ81mTNevakASXxAkGq4IifULC
	nUd7fRFH9rRXykBoz9vRqpV6oiVXs83zW7SzOPR0IDgDdoZ8lsqgx/vjHrulmQP70wji7E
	cO3dtuxFnLxr48IAIRvpcWReTOMQD1U=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-eiYGFK1oMHClUQ0yMZKPCw-1; Mon, 23 Oct 2023 12:20:11 -0400
X-MC-Unique: eiYGFK1oMHClUQ0yMZKPCw-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7ae0cb189e5so1024066241.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 09:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698078011; x=1698682811;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k37AOFeZP6MoGUQ4Vb6wM81gZSQoevmW3tnnk23uv6g=;
        b=vh+WKRxF4W3zb+dxRtKxMQ9UXzwJ4F5J58c041lVJUAks2p1G6zzABGQCByfQqB+zQ
         6hl/zbjM9kfL7s9821MaN9Ceoqa9G7Z7VmljFs691WEqPdRhLoBVCOD8WkWadQlHYBgH
         igGVOO/NzZVQzrnLHWqRXUQobKhtwNJ2IptqBc/4vOUKtzQM7emLgSRR0Cs65t6gUORn
         /VwzhOaXt/zqYN0dJ2KC3JUhVt4K5sNl9/5r+y0xX6/sgwEbETe6cjSY29oeUzHHEU7Z
         418yOYplULksmMSw8jm0JQX8dTt/eNOGEEVIVvHfedgqzgHP+GgS4nckwehPkR7nIhjk
         Jyjg==
X-Gm-Message-State: AOJu0Ywk8Jws0KQL8E2Jr0nFe5rhO6RCvFj6qIx2nAP2hkhrW7YcEY+u
	79mG58w66WxuF+Y7wln2lp/WK7pwCrFrJ+7nTxkfoLgfB0eX0cgdNgqdfqX8Oy7AWsMn7+EPS8X
	nTajtH2od/+sdgYpv
X-Received: by 2002:a05:6102:201e:b0:45a:446e:9e56 with SMTP id p30-20020a056102201e00b0045a446e9e56mr2318767vsr.9.1698078010933;
        Mon, 23 Oct 2023 09:20:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHi48t6vWTK9XJQ7E5pyKLYihfMFWMt0mcnEpdf7HDs/kK+hudXHJ+x0AjO5S+z8qlQD+tK/g==
X-Received: by 2002:a05:6102:201e:b0:45a:446e:9e56 with SMTP id p30-20020a056102201e00b0045a446e9e56mr2318758vsr.9.1698078010681;
        Mon, 23 Oct 2023 09:20:10 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b00767d572d651sm2816785qka.87.2023.10.23.09.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 09:20:10 -0700 (PDT)
Date: Mon, 23 Oct 2023 18:20:05 +0200 (CEST)
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
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 04/13] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
In-Reply-To: <20231020214053.2144305-5-rananta@google.com>
Message-ID: <d6721a96-ddbb-6cf9-0fed-6fc754982ffe@redhat.com>
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-5-rananta@google.com>
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
> The number of PMU event counters is indicated in PMCR_EL0.N.
> For a vCPU with PMUv3 configured, the value is set to the same
> value as the current PE on every vCPU reset.  Unless the vCPU is
> pinned to PEs that has the PMU associated to the guest from the
> initial vCPU reset, the value might be different from the PMU's
> PMCR_EL0.N on heterogeneous PMU systems.
>
> Fix this by setting the vCPU's PMCR_EL0.N to the PMU's PMCR_EL0.N
> value. Track the PMCR_EL0.N per guest, as only one PMU can be set
> for the guest (PMCR_EL0.N must be the same for all vCPUs of the
> guest), and it is convenient for updating the value.
>
> To achieve this, the patch introduces a helper,
> kvm_arm_pmu_get_max_counters(), that reads the maximum number of
> counters from the arm_pmu associated to the VM. Make the function
> global as upcoming patches will be interested to know the value
> while setting the PMCR.N of the guest from userspace.
>
> KVM does not yet support userspace modifying PMCR_EL0.N.
> The following patch will add support for that.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

