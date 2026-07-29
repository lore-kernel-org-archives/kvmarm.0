Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1294446E6
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 11:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325183; cv=none; b=MBOcMirsPJHkit/LNujCIjNa03mxmhEJK7zZDEwGUXPaM7TO8aSQEAnbip9SWAMXtReB2tJOtsL/ps/+ej0e6d6Ed1bfzF6I7Lpq5vWqpAXVt7M8R6e2S3oDCHjm62O+5l7sEDjSpoKWV1TtUWUCvOGl77xgayw7BaKZqu2m4Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325183; c=relaxed/simple;
	bh=TdIA0C+hvWbuO2z/X3tRH27TnhL//kWqbhu9cqVNunU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BELmoZiD4xp3903FQcuA5H7/wwDECP7P9iB2S3VhOvlZBC03GJ3W+XpQzjXIw6slD3/Wf2zz/vmCBw8RNsplB920/gej9aNp3g3mWU6kcN7NxDTorDVaptgXRjdtM9CtZXMNGCdXxiP9qZkKdPoHyI6Z68/8JrFuKBBUWzvyGqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wkJNg9/m; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wkJNg9/m"
X-Forwarded-Encrypted: i=1; AHgh+Rod88vMMLhH8K0E76Q/4NxgApoPZWtlJbgAS+D0wRBkdRwfEesulzxYGPsFnvitTHA12ioM7O4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785325178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MgvBuiLRj24R5eL34h27DbmmXIsCnSbcavTOpGhYHMk=;
	b=wkJNg9/mYStUVUmDL6lZ4JyqPUlsIVmFjo233MR8MdmXup2GJMDW43mwZXtB10cIVycjcl
	oO699ZFDT1VfzI+dUwTG4gqsu9TPvoDOq0+7xI+zQHhrxRdCaksQlZ4zIAlIDp8TwKnh+G
	mfpkb5Dxq6g+DXNpNgE5RnBT8/t44+U=
X-Gm-Message-State: AOJu0YwXhA7s/XnZj/122NMLbru98BHobLRZcdgvGErNGj/hrpHcDNDH
	N5J9xfG9QwTT1T4xZC46fJ/mGly4U35RhoG4AsJnhbL8rMQhrpxpubL17TJm64gN1UD61gIdNeM
	ZODGDvQ5ymbFq+qFVB5nH5Si5G3RFhSKvmqadi/nB
X-Received: by 2002:a05:622a:8359:b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-52b2cc84a3emr5917821cf.9.1785325173789; Wed, 29 Jul 2026
 04:39:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722202702.4165917-1-congkai@amazon.com>
In-Reply-To: <20260722202702.4165917-1-congkai@amazon.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 12:38:56 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyMjsF6jp98TQhc+xBm3+p7wykeK-JMvybU+mjyu5gveA@mail.gmail.com>
X-Gm-Features: AUfX_myrOBKJjGr1oQQJhjpP2gtOW_slUtGnIubwUV7eVBsMrgW-SzxzJTTjCds
Message-ID: <CA+EHjTyMjsF6jp98TQhc+xBm3+p7wykeK-JMvybU+mjyu5gveA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
To: Congkai Tan <congkai@amazon.com>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Haris Okanovic <harisokn@amazon.com>, 
	Geoff Blake <blakgeof@amazon.com>, Stanislav Spassov <stanspas@amazon.de>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Wed, 22 Jul 2026 at 21:27, Congkai Tan <congkai@amazon.com> wrote:
...
>
> Congkai Tan (3):
>   KVM: arm64: Expose PMMIR_EL1.SLOTS under strict PMUv3 UAPI
>   KVM: arm64: Advertise STALL_SLOT* in PMCEID1 under strict PMUv3 UAPI
>   KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature
>
> Oliver Upton (1):
>   KVM: arm64: Ignore writes to PMCR_EL0.N when using strict UAPI

Tested on QEMU: boot, get-reg-list, and vpmu_counter_access pass. This
doesn't exercise the KVM_ARM_VCPU_PMU_V3_STRICT runtime path, and the
series adds no functional selftest for the flag.

For the series:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad
