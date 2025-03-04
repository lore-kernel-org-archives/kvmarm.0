Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374142AAF
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 01:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741050218; cv=none; b=GDq0sVpUO6fnxE6ziwkAqYUWj/QkGu9rWzRcfaxyG9Kd9tb9BNhYAvXuNWacnpxN18PSl533+yPwQQu5GL4cTCQc/CU9IZSwiLKC37ODLYUP0MkVS2/gAiX/EyqzN0Xp85BNHzEaB3RQLFj33xADyVDDhqidNwNDW25hbcRWvK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741050218; c=relaxed/simple;
	bh=X7vkqyMBNaheIUNkehORS3JSEiBfbHm+bdTobACrNNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDAl8CWHxZCdGtqsjjGCpMLXbNMJyOeUMnNohWtJ1WtqFEXqb9IKCq7Qnj5gw9mVK4QmWXxgK3W2YfzSZ68YP7xVGd52x1S4/9+ZGDHMEla3Kuj2p7cT5C+j+Y1MDQR4O+u0eh6EOactWCpw8MP2s2Ozm74rxDN2DAjEUScZVbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E3gd43gT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E3gd43gT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741050216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bnm2BczQeE+oTxQUkTu0mGWgYbP3KRiI/EZBYxWyGBw=;
	b=E3gd43gT3HWq6LpqPb0Ge4U5+bokg2ld+ROxIZprq/iMHQuJdggwQpep6cNEO/UVsF8i5l
	c+RrHOAitu+9YJBkXmisCvBZdbjD/9CYq4dp8m+8aPlPxoqN6HhY/2g90qrpGrHM7OcIXK
	Dhx5sYnobzH3MRIzrnI7kwbufQ5Wi+I=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-QyvHXebkPS6bPEAlm6J_kA-1; Mon, 03 Mar 2025 20:03:33 -0500
X-MC-Unique: QyvHXebkPS6bPEAlm6J_kA-1
X-Mimecast-MFC-AGG-ID: QyvHXebkPS6bPEAlm6J_kA_1741050212
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2fe8fdfdd94so9920448a91.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 17:03:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741050212; x=1741655012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnm2BczQeE+oTxQUkTu0mGWgYbP3KRiI/EZBYxWyGBw=;
        b=TySdnQQz2lZ3iNec54q321AdoSaqqPIHHIZfERbgFaHrjR3wm5qy+2WUOnQIc0Ctrq
         OThQQU7seUih8YEWLQ9bxR7Omb4ku/8HZKNrvtTfDOXwfJAbwIL8boP2E8YqEAiglX8K
         0mnEgTCs1gHCQpZrKBn7tdw0fQUk5PNLgAU1Z/4QpITgFY+lJHKASMoNPAvlvKQywCvK
         l4o2psSmdN3bXyJcxnVkovMzixvHIDyiAv+ApOttqQJhQfWVnUy6ckcgw9l4vBRezoiz
         /RAzVJ4+mlh1302yRJTp3TWZjcqne//M1zeMZex4XvwOUcH2ABRNiQU998dpMhUM0VcJ
         tmaA==
X-Forwarded-Encrypted: i=1; AJvYcCUnYiRBqtuSM09I8J1s37mnXapZ9ipMSQw4pn1CBoclQoZkE/SkYrab/GjL88KAQQbaZVkqxa4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHn3BLdEnY+cnZYdCPqLhq40GNXCHVrSwIJTRjba4W+1w78utf
	X/BFRYbx3xUw9pZsjJIp8FuVG1jiauEqWDCQ1ePFopcMXPu6W7+5x18kF39IxB23Bz1wA6UNHR4
	7g7IZC9VYTYC1NKrDeMfjwXFLguQmP3Ti+mzck+Eq2w6w9c0CUbPeDQ==
X-Gm-Gg: ASbGnct1GyvVVqngQ01kqwtLjAJ85i8Nw3FThSO6x91qGDRSgheZtzCMpR9JcHpU6Xa
	lkxQyhVO1M43S/PTmeI4xN6miRCEUWMCc6KjrCwXrlEsqxFEFy4pjll4ZMKc4dtSpWj3gv4yLQV
	cyrZwtVYacP1B9IpRd/2uLlDlBU/z4JUGsmHoy+lYFcnGKpC72GEDu/IieuzTuVlfsxDsiS9XgG
	nlqfz7gBc2E6j78XA9eLbv1tk7C0zZoJ3rAByy987mtMydrWR6yqCwXUVxd6XEU0xWBd6VwWTDR
	G1XiB71+ib1xinSMyQ==
X-Received: by 2002:a05:6a20:1594:b0:1ee:650b:ac22 with SMTP id adf61e73a8af0-1f2f4e4c8e2mr29503605637.40.1741050211931;
        Mon, 03 Mar 2025 17:03:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEh6O0/XBxWNy8f6zQpOsX8TWQ/teZrvIDTKOnq0U3+AlSWoqSQsK295l3GALc1XNoc+vUz9w==
X-Received: by 2002:a05:6a20:1594:b0:1ee:650b:ac22 with SMTP id adf61e73a8af0-1f2f4e4c8e2mr29503541637.40.1741050211560;
        Mon, 03 Mar 2025 17:03:31 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7ddf2444sm9001374a12.3.2025.03.03.17.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 17:03:30 -0800 (PST)
Message-ID: <80983793-5df7-4828-96e8-90540e7d9183@redhat.com>
Date: Tue, 4 Mar 2025 11:03:21 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 17/45] arm64: RME: Handle realm enter/exit
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-18-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-18-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gyP0DEbCZ29S37pku2ghT7zESefTvqIocoSHDTuDvWE_1741050212
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>     vcpu to the error.
>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>     this exit type.
>   * Split code handling a RIPAS change triggered by the guest to the
>     following patch.
> Changes since v5:
>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>     change on next entry rather than immediately on the exit. This allows
>     the VMM to 'reject' a RIPAS change by refusing to continue
>     scheduling.
> Changes since v4:
>   * Rename handle_rme_exit() to handle_rec_exit()
>   * Move the loop to copy registers into the REC enter structure from the
>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>     where the handler exits to user space and user space wants to modify
>     the GPRS.
>   * Some code rearrangement in rec_exit_ripas_change().
> Changes since v2:
>   * realm_set_ipa_state() now provides an output parameter for the
>     top_iap that was changed. Use this to signal the VMM with the correct
>     range that has been transitioned.
>   * Adapt to previous patch changes.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   3 +
>   arch/arm64/kvm/Makefile          |   2 +-
>   arch/arm64/kvm/arm.c             |  19 +++-
>   arch/arm64/kvm/rme-exit.c        | 171 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/rme.c             |  19 ++++
>   5 files changed, 208 insertions(+), 6 deletions(-)
>   create mode 100644 arch/arm64/kvm/rme-exit.c
> 

With below nitpicks addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

[...]

> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> new file mode 100644
> index 000000000000..aae1adefe1a3
> --- /dev/null
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <kvm/arm_hypercalls.h>
> +#include <kvm/arm_psci.h>
> +
> +#include <asm/rmi_smc.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_rme.h>
> +#include <asm/kvm_mmu.h>
> +
> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
> +

Duplicated to exit_handler_fn, defined in handle_exit.c, need move the
definition to header file.

> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
> +		 rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_handle_guest_abort(vcpu);
> +}
> +
> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
> +		 rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long esr = kvm_vcpu_get_esr(vcpu);
> +	int rt = kvm_vcpu_sys_get_rt(vcpu);
> +	bool is_write = !(esr & 1);
> +	int ret;
> +
> +	if (is_write)
> +		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
> +
> +	ret = kvm_handle_sys_reg(vcpu);
> +
> +	if (ret >= 0 && !is_write)
> +		rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
> +

Unncessary blank line and the conditon isn't completely correct: kvm_handle_sys_reg()
should return 0 if the requested emulation fails, even it always returns 1 for now.

	ret = kvm_handle_sys_reg(vcpu);
	if (ret > 0 && !is_write)
		rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);

> +	return ret;
> +}
> +

[...]

Thanks,
Gavin

