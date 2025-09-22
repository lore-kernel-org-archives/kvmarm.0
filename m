Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0838BC2FB
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 00:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758499428; cv=none; b=BZ21KphPDlHxiqvR4uIOnzbMD04L623r4yekKzoOhMezK601E+E33K4EnKStAV/ml7Lgn6tSGhXyljaL8xAzii9Aw+J8i//s4ewhN8EayU+oSsdYzLIzRQeqX94v0qiGKxFWAwkmGHaOqj8mzfnay0Yb4rJ22qAlLtQszcDsTvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758499428; c=relaxed/simple;
	bh=Vc+qe4oStpGOoYeSI9upVtp+ku6eEr6v6jB1FhStksw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vBw/3PVSX8vRaZ1ZWF4IGg/N6L4DSTSfhC+ivwD7JD8oE/xFb06SEKa+XNKXaLT+TFGDu5V/uk/Xv/kh8FzFHLGiYYlkU6XTFXmVF08E3dVR5LyDoMGmRmn0w+ESvh0JGGXfW3xHA/gRgdT5vWlxmFzXMNLXcLGG9nX6EqmqLME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TtRTYS54; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TtRTYS54"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758499426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqKU8AOkK2sYZLUnyHJFIE8wA4u3vUpzgORbVfbSXxw=;
	b=TtRTYS542Z2oIpyT3gDmoi7Syp0q3JOz5Un9QS5hQqtnPqoF5QgqcUdYPmhdLlnurFQaGp
	cEgAedvElrbKAlnQ/pUpf64I9etZprxVWJPWDc3buwR9WiprR4q42fGj8+4Yo/kUBJJnxS
	KTAo01DDfY76bZzWKuoXygy2yCmpBGM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-jMqsDSCwPfKG5WmN6zHaow-1; Sun, 21 Sep 2025 20:03:42 -0400
X-MC-Unique: jMqsDSCwPfKG5WmN6zHaow-1
X-Mimecast-MFC-AGG-ID: jMqsDSCwPfKG5WmN6zHaow_1758499422
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-77e7d9ed351so1751590b3a.0
        for <kvmarm@lists.linux.dev>; Sun, 21 Sep 2025 17:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758499422; x=1759104222;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BqKU8AOkK2sYZLUnyHJFIE8wA4u3vUpzgORbVfbSXxw=;
        b=kczscAcd+9h4IqfGCV1nYDjRjp1BjYQa5nwBe6cppc9tdz62Vx+IGrmF2WEyqZhOzA
         mHkZhZ0oqYqHtBrlrdsn3Zrh9xAhp9p0oi/0SqwqL7eC53g5K6p9YzqflChTyfq7gziM
         fbIw8M5CVFZ+WRPF6ja8bMhtYBrUgrBd7oGJpLFG+P7R3SWfsTNOvDEnrvox9AbxzGet
         wk2+6skwBgJRg4e+v5kukNbw/zO7VcS4e918zaHmonojku+GeEEkn3B05mYFI0SWbD9O
         RedUASN56ZFNGEqUTH5tPP4FzoxiYzowk9r53PMHVCd30pPqEAfwJMR9Hnw93fsR/Qi9
         XS+A==
X-Forwarded-Encrypted: i=1; AJvYcCXrCouVaQoQWUw8Xo/skOwjlYaRIBJ4RjkO9nEgMJBtjZz63N/5ylLhfxYFJ80ur2drQuukMaU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNeZY6AaIU/U/NUfAuRz27N9ww9pauylpvu1ZleUzn423jGP2Y
	EkqWOjbi7c/z+vZEqwUQ8eTEAJYoQx2uNC1De150InhB0ixjMgnMMDNU1xotjz5IlakrRGTQez0
	PcrRII+kisHdYELWB3UI9nwqGjTA3OzASnMWYJAatKdsRpavbN3I0eUUk1Q==
X-Gm-Gg: ASbGncuIpayevlQfN8quta6qOH4IjpTINBxnmbO7HDnlunXBG59u38nIex/PWprdlRt
	7IAebcCjG4KupuyjaBVm5LqoQW9iZTh283QJkoF/M9MeV5MO+p4vvWfpbiF1UhcrnWQQVWYtlbU
	2t/pmrMnanGSNKJHD4zX9VbOQy9mA2v0YYfoV97e1GQSlU11eGxzvS5/2Q33ugWRR6UirwMYKZO
	tpWXiFopQYoyjwNS0pAO/dVTSzxoZOnAtr5029I1z5n9/Vij3Hnec4UNAfB2uva1y1eHcDWqCTB
	trvsJU6jI02tLWXZnT9NMNI/7kvzC/zd6kHLF+FFfGo1LKIgK4K2BoJSV6CWHupc0mzCduyhYLq
	ew1Oc
X-Received: by 2002:a05:6a00:10c5:b0:77f:2efb:11d5 with SMTP id d2e1a72fcca58-77f2efb19b5mr3965881b3a.1.1758499421866;
        Sun, 21 Sep 2025 17:03:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV+P3PLtWMFz48LpuCCUOGv1CdGlTH41uj5nbM1D8BAHioMb2Zl8ZXd6r9GdYmEpNm+I3zQw==
X-Received: by 2002:a05:6a00:10c5:b0:77f:2efb:11d5 with SMTP id d2e1a72fcca58-77f2efb19b5mr3965847b3a.1.1758499421542;
        Sun, 21 Sep 2025 17:03:41 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f30749642sm2123356b3a.100.2025.09.21.17.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Sep 2025 17:03:41 -0700 (PDT)
Message-ID: <59d78787-1871-41ba-9a2e-30d1596c021f@redhat.com>
Date: Mon, 22 Sep 2025 10:03:32 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 32/43] arm64: RME: Enable PMU support with a realm
 guest
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-33-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-33-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D1pwxQBsWMgbvgg7ym61UkO6bZScfiXLjyBU0MFl8oM_1758499422
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 12:55 AM, Steven Price wrote:
> Use the PMU registers from the RmiRecExit structure to identify when an
> overflow interrupt is due and inject it into the guest. Also hook up the
> configuration option for enabling the PMU within the guest.
> 
> When entering a realm guest with a PMU interrupt pending, it is
> necessary to disable the physical interrupt. Otherwise when the RMM
> restores the PMU state the physical interrupt will trigger causing an
> immediate exit back to the host. The guest is expected to acknowledge
> the interrupt causing a host exit (to update the GIC state) which gives
> the opportunity to re-enable the physical interrupt before the next PMU
> event.
> 
> Number of PMU counters is configured by the VMM by writing to PMCR.N.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Add a macro kvm_pmu_get_irq_level() to avoid compile issues when PMU
>     support is disabled.
> ---
>   arch/arm64/kvm/arm.c      | 11 +++++++++++
>   arch/arm64/kvm/guest.c    |  7 +++++++
>   arch/arm64/kvm/pmu-emul.c |  3 +++
>   arch/arm64/kvm/rme.c      |  8 ++++++++
>   arch/arm64/kvm/sys_regs.c |  5 +++--
>   include/kvm/arm_pmu.h     |  4 ++++
>   6 files changed, 36 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

