Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAB22874E3
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 13:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748438896; cv=none; b=aJIx+JVf9Y2naiM7PdY7iEx4vreO2d5tzUx9JIUC2Dg5FQOTXFYoYdiqRIt+M3Rgv5/K43N2VoJRt1PAOtguM1tAPgKYaY6xVXcx+hNdGCQMvEM+gNt1Il3hnMNuX0fPIIvlZMPeGYlBxMMwwWJaU6KtBjJ3his5kj9Huuwfc9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748438896; c=relaxed/simple;
	bh=U8qomunlThM/3D2+2iMrsHuOsKr3NIw4n9pmpjV816I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rQoD5qYwE/R7T9efUwqe6veWez/jitez6dQjWDtqqcEIO/1a63MAwI7VBe9N2izKGAGPHb5vS5hmNxhlYzEheP3v3g5co0aIL/WlTP+ZAOvJPKUu3Tz2jopEaB9cVMRzqPUmvogHPjwsQQcDxOeiCVUaVIV2g5QDTq/kRnDIW94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HENpn3Xv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HENpn3Xv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748438893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UQ9g5LYyLjb8/iVLB1DcVfsrw8TL+AlPQukLnrUz7KA=;
	b=HENpn3XvGzFvnCmtOiPdeLpV2NoMIQ4k+oa3ohBhMQBscoUJaJ+ImODx84WizLpId9Ltct
	pU9/S5tR/nOj2MK3hCIlSih07RjcUVPQK0RAnMgFhfW4Nggwef5Whi4vdK2YAeLXOveGAQ
	Tpfmbz0m4asO7dBX0XcciqKPT0M6hSE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-a2pNXX4iMmut8v__DOTB1A-1; Wed, 28 May 2025 09:28:09 -0400
X-MC-Unique: a2pNXX4iMmut8v__DOTB1A-1
X-Mimecast-MFC-AGG-ID: a2pNXX4iMmut8v__DOTB1A_1748438889
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4ee113461so32143f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 06:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748438888; x=1749043688;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQ9g5LYyLjb8/iVLB1DcVfsrw8TL+AlPQukLnrUz7KA=;
        b=hcNV9sXtgzU01/XdNQzX3NHkekxk1Ko+1SFIRbAqBrLqJ7bowbtdT8LntJcVkLbt2F
         NBW9BMk1OZBLbZWQSHDQL5DL9B04sBTPMUB/57wLKkFlbjGnqLYSCLdf99yg+YfsnAXF
         /sK42P4O1cDwWiqIS5Vf0rmbErONzg6PyZ280ZJSjvhIH/CemgmUeCClDmPppyT1zA87
         7sCHqT5wDlGcxXVByJjHBL/cYRoCc11Hu7YaRq2K/4wM6HrHZ3j/faWpiUvgY0kPKdTO
         MsEl3NNSX8nsfDHvxZobuXhuMzrlIiBbl2g69gQ+23IYnUG2hw/Na2dqbiOlaphERA/S
         4aeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAwBYjFOweis4EASlYU029wnO4ym1GEoAjEJADEd+ndiWUQZTh+jHXKhuQfR1O3t1uBkew2dI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrJmhYUFy4Kg+qfqu+u8uhaqJ6Dm3CjTg1nJgxequkD1sTGZw9
	yUrkSvJL9pHiZEl1c+3GKVSBfSiFfvfDi17Q/tT0BQfpFjP+p5b0w1FsDR/OUPizXbqp3/osCOS
	7yJr5LovLpSRmUaR/z2S2EQ4YLiMTqIWsKcLNJsNZEvjX/TlsmEaZpAWRSw==
X-Gm-Gg: ASbGncsd/yYA2pJcf9m4PyoAKl+cdtBYhl7T9KsSyw6i6khP/xPSUghMLO9rbFfAdpC
	KO9PJt5cG/xVukqXuJzoIaFNReGm0LaNlEJAqFMrlK7MDBRffZ1V+v0YpFcMPJoTWZAilOsyM4P
	OrNkyhgLomqzCXZr+weBHwCqWdrCFyd/Xe2Q4gdYu9GPn/O2eVBVfs1Yf+/O23VDL8dvDOnrZcJ
	SQ1jFadY6piV+l8H/+Uc8+GC7IduuoJNb/qtgO3G1lOefhWOuE2uOqa2vohm+ayGp2cylz3hfaZ
	LU7IiAZLJjkJxXr+C6sDMRcy/iyqea6MrI0nlpq8g1ajBm5Lr+g26w==
X-Received: by 2002:a05:6000:250f:b0:3a4:eac6:e320 with SMTP id ffacd0b85a97d-3a4eac6e4cfmr2302678f8f.3.1748438888526;
        Wed, 28 May 2025 06:28:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbyayzrF6O0WPxMeyUA9UrtC3EPJ8bgX9wDZpJ1+cDqAh15SKbYxky+R1yioFLQpmt8Yx37g==
X-Received: by 2002:a05:6000:250f:b0:3a4:eac6:e320 with SMTP id ffacd0b85a97d-3a4eac6e4cfmr2302654f8f.3.1748438888177;
        Wed, 28 May 2025 06:28:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45072555885sm17994055e9.17.2025.05.28.06.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 06:28:07 -0700 (PDT)
Message-ID: <92c7e99c-5574-422c-92f1-62d5cde58fec@redhat.com>
Date: Wed, 28 May 2025 15:28:06 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/9] KVM: Enable Nested Virt selftests
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, seanjc@google.com,
 darren@os.amperecomputing.com
References: <20250512105251.577874-1-gankulkarni@os.amperecomputing.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250512105251.577874-1-gankulkarni@os.amperecomputing.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s-B--hrflgqBYMhjfKDbrQIcztLQ-UV_Wp7ELE07hUk_1748438889
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ganapatrao,

On 5/12/25 12:52 PM, Ganapatrao Kulkarni wrote:
> This patch series makes the selftest work with NV enabled. The guest code
> is run in vEL2 instead of EL1. We add a command line option to enable
> testing of NV. The NV tests are disabled by default.

For commodity, I would add in the coverletter that for all tests
enhanced with vEL2 testing "-g 1" option shall be added to force that mode.

I don't really get how you chose tests capable to run at vEL2 and
excluded others? Wouldn't it make sense to have a way to run all tests
in either mode?

Thanks

Eric

> 
> Modified around 12 selftests in this series.
> 
> Changes since v1:
> 	- Updated NV helper functions as per comments [1].
> 	- Modified existing testscases to run guest code in vEL2.
> 
> [1] https://lkml.iu.edu/hypermail/linux/kernel/2502.0/07001.html 
> 
> Ganapatrao Kulkarni (9):
>   KVM: arm64: nv: selftests: Add support to run guest code in vEL2.
>   KVM: arm64: nv: selftests: Add simple test to run guest code in vEL2
>   KVM: arm64: nv: selftests: Enable hypervisor timer tests to run in
>     vEL2
>   KVM: arm64: nv: selftests: enable aarch32_id_regs test to run in vEL2
>   KVM: arm64: nv: selftests: Enable vgic tests to run in vEL2
>   KVM: arm64: nv: selftests: Enable set_id_regs test to run in vEL2
>   KVM: arm64: nv: selftests: Enable test to run in vEL2
>   KVM: selftests: arm64: Extend kvm_page_table_test to run guest code in
>     vEL2
>   KVM: arm64: nv: selftests: Enable page_fault_test test to run in vEL2
> 
>  tools/testing/selftests/kvm/Makefile.kvm      |   2 +
>  tools/testing/selftests/kvm/arch_timer.c      |   8 +-
>  .../selftests/kvm/arm64/aarch32_id_regs.c     |  34 ++++-
>  .../testing/selftests/kvm/arm64/arch_timer.c  | 118 +++++++++++++++---
>  .../selftests/kvm/arm64/nv_guest_hypervisor.c |  68 ++++++++++
>  .../selftests/kvm/arm64/page_fault_test.c     |  35 +++++-
>  .../testing/selftests/kvm/arm64/set_id_regs.c |  57 ++++++++-
>  tools/testing/selftests/kvm/arm64/vgic_init.c |  54 +++++++-
>  tools/testing/selftests/kvm/arm64/vgic_irq.c  |  27 ++--
>  .../selftests/kvm/arm64/vgic_lpi_stress.c     |  19 ++-
>  .../testing/selftests/kvm/guest_print_test.c  |  32 +++++
>  .../selftests/kvm/include/arm64/arch_timer.h  |  16 +++
>  .../kvm/include/arm64/kvm_util_arch.h         |   3 +
>  .../selftests/kvm/include/arm64/nv_util.h     |  45 +++++++
>  .../selftests/kvm/include/arm64/vgic.h        |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   3 +
>  .../selftests/kvm/include/timer_test.h        |   1 +
>  .../selftests/kvm/kvm_page_table_test.c       |  30 ++++-
>  tools/testing/selftests/kvm/lib/arm64/nv.c    |  46 +++++++
>  .../selftests/kvm/lib/arm64/processor.c       |  61 ++++++---
>  tools/testing/selftests/kvm/lib/arm64/vgic.c  |   8 ++
>  21 files changed, 604 insertions(+), 64 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/nv_guest_hypervisor.c
>  create mode 100644 tools/testing/selftests/kvm/include/arm64/nv_util.h
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/nv.c
> 

