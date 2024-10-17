Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B1B1F60A
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 02:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729132636; cv=none; b=qNUAJnha/6/4V4DqnN4Uj66PvDAMyVJFFeD4ymewaY+oTCIyieDD1FKOcBsgyFc/9nN3u3w78JMorxqyE9IqKxOVCyvPOe/DGFk6olQDxJS7zdL3YlQekTKfYBG88DW2Kqnao3dewBQKKWmOb1QVfz4vs37aUIS8QY+Ao/KOGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729132636; c=relaxed/simple;
	bh=fGn6NZzgUTkOc0hgXZYkPdVsV0FaaDgGhbpwDVjEOPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q/h0iGI4cz//As03F0HxDZ0sNc0ZIXnUUAPhvwWqYdIEOKVfS9hqXIUdySD8yGr8fg5fIYnOO8KaWDFFBm8xHWrlVBjRMCDyDX6B64MNQfw3mn7UWbI4YHK3/4/2Tu8YuyRtJ+SAwCpTEP36d2e6QkSjvXE98aO1U5ozE+M90H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KW3G+D2q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KW3G+D2q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729132633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YiSakXyR6J9LBscrOdQ4m8FGebNzhUm0cWuDJybpkwA=;
	b=KW3G+D2qYPoeGWLtQA7oB0vbbmgsRbYUtDBb/9yYQakAdfSsn+NKpHFMwfd6dzsuP/d+36
	zDNAelnLgNIcX2HqkqHd9ryJf3pnYab33Lu5NGbNZ8yyKH2KRTHdsZmrkad8NXtKWABfTV
	2XPEamsRwZHIhOoBWRsx29DQ161ms9w=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-lDNtvjwrPRWX2mNS688o3A-1; Wed, 16 Oct 2024 22:37:09 -0400
X-MC-Unique: lDNtvjwrPRWX2mNS688o3A-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5eb1bc5cd9dso452764eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 19:37:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729132629; x=1729737429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiSakXyR6J9LBscrOdQ4m8FGebNzhUm0cWuDJybpkwA=;
        b=SMz0jxMwl/vIbDzW7SyW3g2GO3wG6i2bTwVc3YUWqQgurQQb3i1ZtMmnn0ZC3gCP0Y
         3E0hCRx3J4JGCj3fy/kS/pwEHNT0huuKRK5YrwkJCYjc4JTn6cH9P3pCgAiNeylfQ++m
         GfpJ9Xde+Jnw66Bb4i5j513Ds/ylbRfjPyWdxJGm8Aq4UBeDgKfl4V7F7drEGcd5lOOU
         1TcYsvmbdzt40QOMmurYKlrW7NV8FlYL4zVhMrmLfXBNXpOcTW+oU+XlZQrVdqlsXh0i
         mfzc6KOXOLmTVuic3VtXUqf5dV1kLB/vJF4nBZOvI/1g7rFfej8t+V4PP9kCJFvWGhKV
         HZlQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+fztKjeyppyvi7teSQ260reFMAO4sXGmgPR92ghKYylAdd+8yQXg0kZ3QZsgfrw7zL3/GG4o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrJv7BayGOT9jzp9tRtW/BhQvQySK58uGadlVNF4ml76ACLCb8
	oc3wZNsJv25wE7QQphya1gwfwfR+4oRKbceRWUNux6IVksIXwCU2upeWN7J3+9X6T9Yy8sAFOYU
	ZJyp9/NMVzQB746DTLuuf4NfMFMenfpVyA9v3TEGuLe3SyN4EexhsIg==
X-Received: by 2002:a05:6358:311c:b0:1c3:77fc:3bb6 with SMTP id e5c5f4694b2df-1c377fc410dmr688504155d.21.1729132628987;
        Wed, 16 Oct 2024 19:37:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZsiUBt/ilu8x8OvNd8btX6bzS8VqVHgEwMcxRiapROKp7byUPsOcK3nzEjixlWXv5E0XtGw==
X-Received: by 2002:a05:6358:311c:b0:1c3:77fc:3bb6 with SMTP id e5c5f4694b2df-1c377fc410dmr688501155d.21.1729132628618;
        Wed, 16 Oct 2024 19:37:08 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e774a2ad7sm3772158b3a.118.2024.10.16.19.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 19:37:07 -0700 (PDT)
Message-ID: <3261be12-59ae-4363-9d3c-44d3de09afec@redhat.com>
Date: Thu, 17 Oct 2024 12:37:01 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/7] KVM: arm64: Fix missing traps of guest accesses to
 the MPAM registers
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-5-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241015133923.3910916-5-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> but didn't add trap handling.
> 
> If you are unlucky, this results in an MPAM aware guest being delivered
> an undef during boot. The host prints:
> | kvm [97]: Unsupported guest sys_reg access at: ffff800080024c64 [00000005]
> | { Op0( 3), Op1( 0), CRn(10), CRm( 5), Op2( 0), func_read },
> 
> Which results in:
> | Internal error: Oops - Undefined instruction: 0000000002000000 [#1] PREEMPT SMP
> | Modules linked in:
> | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.6.0-rc7-00559-gd89c186d50b2 #14616
> | Hardware name: linux,dummy-virt (DT)
> | pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> | pc : test_has_mpam+0x18/0x30
> | lr : test_has_mpam+0x10/0x30
> | sp : ffff80008000bd90
> ...
> | Call trace:
> |  test_has_mpam+0x18/0x30
> |  update_cpu_capabilities+0x7c/0x11c
> |  setup_cpu_features+0x14/0xd8
> |  smp_cpus_done+0x24/0xb8
> |  smp_init+0x7c/0x8c
> |  kernel_init_freeable+0xf8/0x280
> |  kernel_init+0x24/0x1e0
> |  ret_from_fork+0x10/0x20
> | Code: 910003fd 97ffffde 72001c00 54000080 (d538a500)
> | ---[ end trace 0000000000000000 ]---
> | Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> | ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---
> 
> Add the support to enable the traps, and handle the three guest accessible
> registers by injecting an UNDEF. This stops KVM from spamming the host
> log, but doesn't yet hide the feature from the id registers.
> 
> With MPAM v1.0 we can trap the MPAMIDR_EL1 register only if
> ARM64_HAS_MPAM_HCR, with v1.1 an additional MPAM2_EL2.TIDR bit traps
> MPAMIDR_EL1 on platforms that don't have MPAMHCR_EL2. Enable one of
> these if either is supported. If neither is supported, the guest can
> discover that the CPU has MPAM support, and how many PARTID etc the
> host has ... but it can't influence anything, so its harmless.
> 
> Fixes: 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register")
> CC: Anshuman Khandual <anshuman.khandual@arm.com>
> Link: https://lore.kernel.org/linux-arm-kernel/20200925160102.118858-1-james.morse@arm.com/
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/include/asm/cpufeature.h     |  2 +-
>   arch/arm64/include/asm/kvm_arm.h        |  1 +
>   arch/arm64/include/asm/mpam.h           |  2 +-
>   arch/arm64/kernel/image-vars.h          |  5 ++++
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c               |  3 +++
>   6 files changed, 43 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

