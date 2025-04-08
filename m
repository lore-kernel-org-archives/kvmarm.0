Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E4520A5EE
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 05:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744088615; cv=none; b=Mifphagud0WW7ZsvyanDXBn4iBDKGyr089ggBbALAEolAUq9TB/GUAv4J5cEqkQ82f4GgtJdjp4H9Nv/4KEgJcXydYyXXJ4sKb8g140m5O+lCuvQVXrdH36P5MVXnpHthFrdB8bE/C6l8puvGYFdWN363ygHiTCCCioWjy4vaE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744088615; c=relaxed/simple;
	bh=kCrdhF+yR04zpDgvPaEbwrTFya3LR3Mk7SW51smtES0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H8aPH6VJn/43zmtf8EWnOKtEFRo2q2IjkQWZKN7AxoQ4CFHPmfGgos+ktXSHBsfhU0T5w1Y5Xy5kz8iBLFb3Dm0vVfm0NXlNT99cj2GtSyZVxeZKp4hCt8S3OTb7lgziuY4MYD5b54+Rxcc2UfS08IEnrPhx/VDBId/e/7D6G90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDV00UJz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDV00UJz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744088612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=08d10QPRbou7mD/4AaojdjLjtx5I6e0q1cXfeY1kUxQ=;
	b=jDV00UJzZ5HPBfTlzSSvtOJ9hNa4C9YT+gFbVzZT/6U554YjH3dfbg2KAwYkobSE4KUtn1
	sEw8wRDOK5Ho1cmeZ0jT513eLcNgc2LX5SZRfbznQ9DQLWyGAHda3IwpzmfZB5FdeMUNuI
	HLTHBeDbNon4Q8IQs8N1T07YVTUeox8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-Y04E_VBaMKaZPSCUKxBKyw-1; Tue, 08 Apr 2025 01:03:29 -0400
X-MC-Unique: Y04E_VBaMKaZPSCUKxBKyw-1
X-Mimecast-MFC-AGG-ID: Y04E_VBaMKaZPSCUKxBKyw_1744088608
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2240a7aceeaso48783615ad.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 22:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744088608; x=1744693408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08d10QPRbou7mD/4AaojdjLjtx5I6e0q1cXfeY1kUxQ=;
        b=aJntYNdKQ+Dshf4+rcHyUThAhSOYeaxv9TKGSGTHP+gRWmz+9Tn/jPvMHvNlh7Q78x
         F3s/nRzbdNcGMxCUEWF0EoC9IO7N+S637UT0Xy7/6GXSr95hkvKeTP0YpzwPOsXFDIQS
         OzgZNU5Y0LXoWNIlfJJsRZuZ+4xjPJmDQTTblw93I8o1hI5Ra0c75wm05RXtowHB+CUg
         IUdNQGp6A6vIG7DgIchXvjZDu2p1uNdaC/XX90DV55KETKevwWv6qe8rG19A1HMyv5cG
         0iyyweY1hgIM62On1OXG6VJZoteLstjQW2RHh/f5RUjXaVuHC2QwbM4caLncWeJO8Ob7
         cGxA==
X-Forwarded-Encrypted: i=1; AJvYcCV0qSKacTxy1ut0TaVEmZX3GYIQJ2ucmiXE7LKh+CgbGL4ia/mrWol7VQlswQc2tlQLQa3eSoE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzufDVJ3mL34LbtN8x+IU3OCRPMkOWcofi9KkI5okMpSWTRQRjx
	H0BvyUI6BUQLA4+KcvBIdth4iX5mvWzqVL5sIBPAQ64iGI1A0GSGFXZElR6cQuQoojTgzjN4CH/
	ozQ7PVmaI4W1Gbz8Gu+AzLjcrLUXXGQiDzvliKdppuBhmFJHST5IPIg==
X-Gm-Gg: ASbGnctl4QOYhUL71m/VwjG4jO9TofJzzJ2RZmk0mS9Xz0C+Wh1QW3mF6v2OYM+jFjz
	sreMv4Y2k2Mbq/aFAmSpxmq/iT7WJmCxq9bPvYhErpMwkZeS9FcYHiGO+MaE6S1CxQmwZITlEuX
	uvbZU/xM8p/nPXE27SUI5vA69zP3N3uL5UC/2fjDp+m8yRJNZBwq56bMcxy23WkuRUwMKtoxrHS
	apT8rgDuzJ8s2G+hi1kLuh1KKP8tx9bFqTz2A6vBQ76lliqsng0FYsdV3pGspgMEZZHVgr1F7YH
	5WkiQIKYCEm780rm
X-Received: by 2002:a17:902:ccce:b0:215:8809:b3b7 with SMTP id d9443c01a7336-22a8a04593emr212605285ad.7.1744088608543;
        Mon, 07 Apr 2025 22:03:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGML8JrfPQSGP1sTXgAJbLiBC79RWpQvktKvDF6YE82nc5K0KhNIo0FYjrqKNMDpWPDe5wEjg==
X-Received: by 2002:a17:902:ccce:b0:215:8809:b3b7 with SMTP id d9443c01a7336-22a8a04593emr212604925ad.7.1744088608147;
        Mon, 07 Apr 2025 22:03:28 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229785c01b7sm90355785ad.96.2025.04.07.22.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 22:03:27 -0700 (PDT)
Message-ID: <005ccfb3-b616-4723-b039-b8a3d6fb10bc@redhat.com>
Date: Tue, 8 Apr 2025 15:03:19 +1000
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
 <80983793-5df7-4828-96e8-90540e7d9183@redhat.com>
 <95c06abf-591f-4dd0-b1fd-296b0d5ae924@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <95c06abf-591f-4dd0-b1fd-296b0d5ae924@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tHT0FeSEGsud3ItBvlCH5Lua_7uhiegsxWHq2iC7mYU_1744088608
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/8/25 2:34 AM, Steven Price wrote:
> On 04/03/2025 01:03, Gavin Shan wrote:
>> On 2/14/25 2:13 AM, Steven Price wrote:
>>> Entering a realm is done using a SMC call to the RMM. On exit the
>>> exit-codes need to be handled slightly differently to the normal KVM
>>> path so define our own functions for realm enter/exit and hook them
>>> in if the guest is a realm guest.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v6:
>>>    * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>>>      vcpu to the error.
>>>    * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>>>      this exit type.
>>>    * Split code handling a RIPAS change triggered by the guest to the
>>>      following patch.
>>> Changes since v5:
>>>    * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>>>      change on next entry rather than immediately on the exit. This allows
>>>      the VMM to 'reject' a RIPAS change by refusing to continue
>>>      scheduling.
>>> Changes since v4:
>>>    * Rename handle_rme_exit() to handle_rec_exit()
>>>    * Move the loop to copy registers into the REC enter structure from the
>>>      to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>>>      where the handler exits to user space and user space wants to modify
>>>      the GPRS.
>>>    * Some code rearrangement in rec_exit_ripas_change().
>>> Changes since v2:
>>>    * realm_set_ipa_state() now provides an output parameter for the
>>>      top_iap that was changed. Use this to signal the VMM with the correct
>>>      range that has been transitioned.
>>>    * Adapt to previous patch changes.
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |   3 +
>>>    arch/arm64/kvm/Makefile          |   2 +-
>>>    arch/arm64/kvm/arm.c             |  19 +++-
>>>    arch/arm64/kvm/rme-exit.c        | 171 +++++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/rme.c             |  19 ++++
>>>    5 files changed, 208 insertions(+), 6 deletions(-)
>>>    create mode 100644 arch/arm64/kvm/rme-exit.c
>>>
>>
>> With below nitpicks addressed:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>> [...]
>>
>>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>>> new file mode 100644
>>> index 000000000000..aae1adefe1a3
>>> --- /dev/null
>>> +++ b/arch/arm64/kvm/rme-exit.c
>>> @@ -0,0 +1,171 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright (C) 2023 ARM Ltd.
>>> + */
>>> +
>>> +#include <linux/kvm_host.h>
>>> +#include <kvm/arm_hypercalls.h>
>>> +#include <kvm/arm_psci.h>
>>> +
>>> +#include <asm/rmi_smc.h>
>>> +#include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_rme.h>
>>> +#include <asm/kvm_mmu.h>
>>> +
>>> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
>>> +
>>
>> Duplicated to exit_handler_fn, defined in handle_exit.c, need move the
>> definition to header file.
> 
> While I get this is duplication, I'm a little reluctant to move it to a
> header file because this is completely internal to each C file (the
> xxx_exit_handler[] arrays are both static). If either side wants to e.g.
> add an extra argument there shouldn't be a requirement to reflect that
> change in the other.
> 
> Specifically I'm wondering if we're going to ever need to pass an RMI
> return status into the rme-exit callbacks at some point.
> 

Ok, thanks for explaining it in details. In that case, I think it's fine
to keep exit_handler_fn in rme-exit.c.

>>> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +
>>> +    vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
>>> +         rec->run->exit.esr);
>>> +    return -ENXIO;
>>> +}
>>> +
>>> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>>> +{
>>> +    return kvm_handle_guest_abort(vcpu);
>>> +}
>>> +
>>> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +
>>> +    vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
>>> +         rec->run->exit.esr);
>>> +    return -ENXIO;
>>> +}
>>> +
>>> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +    unsigned long esr = kvm_vcpu_get_esr(vcpu);
>>> +    int rt = kvm_vcpu_sys_get_rt(vcpu);
>>> +    bool is_write = !(esr & 1);
>>> +    int ret;
>>> +
>>> +    if (is_write)
>>> +        vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
>>> +
>>> +    ret = kvm_handle_sys_reg(vcpu);
>>> +
>>> +    if (ret >= 0 && !is_write)
>>> +        rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
>>> +
>>
>> Unncessary blank line and the conditon isn't completely correct:
>> kvm_handle_sys_reg()
>> should return 0 if the requested emulation fails, even it always returns
>> 1 for now.
> 
> It shouldn't matter, but like you say it's not technically the correct
> condition so I'll fix this up.
> 

Ok.

> Thanks,
> Steve
> 
>>      ret = kvm_handle_sys_reg(vcpu);
>>      if (ret > 0 && !is_write)
>>          rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
>>
>>> +    return ret;
>>> +}
>>> +
>>

Thanks,
Gavin

