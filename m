Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5B7AD58
	for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 20:08:01 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id i70-20020a6b3b49000000b0074c7f0b085dso33251ioa.22
        for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 12:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hqBDCaRUpk8eeZQxB4xKYCRgQ97yBQOILalgfmcsiXE=;
        b=PpVmRsfgRU3/7G3EUko9SO7Uz+4sbcJza/bKiesHq4gRYVc0ySt6JR2N0ILMGK6IZm
         NZJQ7TUnJv6kKCgDK9fdXRCtZSsNOFeB5uS+ptf2u4V0IukvE621a4uR4PSZukVXATOA
         pWrNGtUZn63LWdSMq6SVGoWgEPivBA4e13bxeyBhzn+zFCYQRQUlrQrslOLSnP4DIPlb
         jYFKzsJMhEPQUNL/N2HlOS3imzJ1QEkn/NIJVATwykJWgh3UANOeE0nIJ46BzE1FoIOS
         NYlNvdeQtC27E+h7LPSVDY/0LBoyqGAp8/Y5w0Gc7jlQ72LIoYIn58ekYRxwWhbGqcqR
         fP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hqBDCaRUpk8eeZQxB4xKYCRgQ97yBQOILalgfmcsiXE=;
        b=7euXPVqYObZ8xOtIlAuhBjs5R7p/VfdvvTambVqFZaSsxpvDzWB7AbjDPogdqKkAgx
         IKwPA3j1LkStxmaVK+JETmFccG193F644fEN0v1omQ2JyyUaXtgBJIGIcLnufSoQoocM
         epby7a+gt3RMKr0ewExkCpKocjSl/UNqSic6OhOP1GMBvNBBN4Oy6NLrWCm2u2Zcsbdy
         jobRCvlzVKSL4rmEgsIRBwy5gCW/PtEFZJ1iyG3YvVZ+XAGIf0MWeoRvvEzXZtocG2+o
         j7kwxUOeQh0dvHBz+PyjGbAMpsON9/cSXaAIJpRMmia7jafFsouYv7EjM4Yllt7a6AJq
         bHrw==
X-Gm-Message-State: AO0yUKXdPOePKFp3L+YGuDmYY95MGIUvoOuPogpOjJ++BRyd//kueowl
	QnekKuixAjjO9fw84WrRNwfRhUAVNw8Ge3wOmw==
X-Google-Smtp-Source: AK7set8qKDHKk40apdIcYxEoC/sxsBMxabxSWSh9r3ex6HkDrTM9Dipd7uUTAZQ4hCt54nyTpZ17rrTiHfIUINRn/g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1146:b0:315:34c0:d463 with
 SMTP id o6-20020a056e02114600b0031534c0d463mr5264952ill.3.1677269280238; Fri,
 24 Feb 2023 12:08:00 -0800 (PST)
Date: Fri, 24 Feb 2023 20:07:59 +0000
In-Reply-To: <20230216142123.2638675-13-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:19 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntk006968w.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 12/16] KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Marc Zyngier <maz@kernel.org> writes:

> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 62ef4883e644..e76e513b90c5 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -29,6 +29,11 @@ struct arch_timer_offset {
>   	 * structure. If NULL, assume a zero offset.
>   	 */
>   	u64	*vm_offset;
> +	/*
> +	 * If set, pointer to one of the offsets in the vcpu's sysreg
> +	 * array. If NULL, assume a zero offset.
> +	 */
> +	u64	*vcpu_offset;
>   };

>   struct arch_timer_vm_offsets {
> --
> 2.34.1

This pointer isn't initialized until next commit and this commit is
small so I think it should be merged with the next one.
