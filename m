Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9731E1C0
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691688634;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+AiiY6yN+8eeM/urhBY+h7LN4h1pOcWCSDE4GkhpOI=;
	b=OJq766MVqrCVLGN/B2KumkylNRWlEm7FYh0aqne6bxuA2bOEmtLBeLnbaiLhps8z0CxF9e
	W/XXVwPRlVu4VItx4a1EV1cU9NsV4BT9qK0tkJLVKwRYJH2XkHIkea+yRIUYzibBtZze0/
	NZ+3Q52IniGm+ERLpzZ3vBlTw2ZwVBw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-HMZEaUagPd2TSztX4PRVDg-1; Thu, 10 Aug 2023 13:30:32 -0400
X-MC-Unique: HMZEaUagPd2TSztX4PRVDg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-63d1bd6dfebso15415786d6.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 10:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691688631; x=1692293431;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+AiiY6yN+8eeM/urhBY+h7LN4h1pOcWCSDE4GkhpOI=;
        b=akra91QorxSt0VUAuw0GhNjvCMCeQNJhpCseStgF3Qx4zWyWjwyyQVOl38dKvex6rt
         xI1QSOldAiN1eAYGnyHYEQyDy/5V8vSCPxUUKexntMPwhRQa2ieoMN88YwznxmW4SuhX
         eBrLSliLoEjydZ2KyF4/Y3x4a8EK+vMjC+Ix/XwANRssP7F4uMbS/Gp6IE47xIRk61vv
         7SikALs96vAfuB5qIvEwK4ZO3SVDmG1KdkSBojgynGgfhh+nwtDkyh7acaShYWVTqE2T
         FgQU6yO9QQCCI63kK5sn/jVr5R3fw33jobr0K7Hak5hCmp9NsbSyRwqUv1ILCKzoxoX+
         qbTg==
X-Gm-Message-State: AOJu0YyAHR3io+mzTXicPfDmqLQ+09MYI57bd6surinsHGE9pXTNctlk
	8rhhZfXZBBAuY5pFQLejb8q3QLT3MiM+lvjKmiSn4Holni3i4O44vEzxiJpdhuGTEep1XFmIBHl
	WmZ/OAqG60EkUHXcy
X-Received: by 2002:a05:622a:1009:b0:403:b5a1:7ee0 with SMTP id d9-20020a05622a100900b00403b5a17ee0mr4699955qte.32.1691688631625;
        Thu, 10 Aug 2023 10:30:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7k7xZYn2uslh+sOmghAXGxheE0UwD+rV28+letgDj4JnRZiuh9xz76rEXAHIAq2cR0gLvTQ==
X-Received: by 2002:a05:622a:1009:b0:403:b5a1:7ee0 with SMTP id d9-20020a05622a100900b00403b5a17ee0mr4699932qte.32.1691688631203;
        Thu, 10 Aug 2023 10:30:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i13-20020ac871cd000000b00403b3156f18sm632149qtp.8.2023.08.10.10.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 10:30:30 -0700 (PDT)
Message-ID: <527eddd0-b069-3b58-d82e-97b758c128ab@redhat.com>
Date: Thu, 10 Aug 2023 19:30:25 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 23/27] KVM: arm64: nv: Add SVC trap forwarding
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-24-maz@kernel.org>
 <2a751a64-559e-cb17-4359-7f368c1b42ca@redhat.com>
 <87wmy3p4ac.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87wmy3p4ac.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,
On 8/10/23 12:42, Marc Zyngier wrote:
> Hi Eric,
>
> On Thu, 10 Aug 2023 09:35:41 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 8/8/23 13:47, Marc Zyngier wrote:
>>> HFGITR_EL2 allows the trap of SVC instructions to EL2. Allow these
>>> traps to be forwarded. Take this opportunity to deny any 32bit activity
>>> when NV is enabled.
>> I can't figure out how HFGITR_EL2.{SVC_EL1, SVC_EL0 and ERET} are
>> handled. Please could you explain.
> - SVC: KVM itself never traps it, so any trap of SVC must be the
>   result of a guest trap -- we don't need to do any demultiplexing. We
>   thus directly inject the trap back. This is what the comment in
>   handle_svc() tries to capture, but obviously fails to convey the
>   point.
Thank you for the explanation. Now I get it and this helps.
>
> - ERET: This is already handled since 6898a55ce38c ("KVM: arm64: nv:
>   Handle trapped ERET from virtual EL2"). Similarly to SVC, KVM never
>   traps it unless we run NV.
OK
>
> Now, looking into it, I think I'm missing the additional case where
> the L2 guest runs at vEL1. I'm about to add the following patchlet:
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 3b86d534b995..617ae6dea5d5 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -222,7 +222,22 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>  	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
>  		return kvm_handle_ptrauth(vcpu);
>  
> -	kvm_emulate_nested_eret(vcpu);
> +	/*
> +	 * If we got here, two possibilities:
> +	 *
> +	 * - the guest is in EL2, and we need to fully emulate ERET
> +	 *
> +	 * - the guest is in EL1, and we need to reinject the
> +         *   exception into the L1 hypervisor.
but in the case the guest was running in vEL1 are we supposed to trap
and end up here? in kvm_emulate_nested_eret I can see
"the current EL is always the vEL2 since we set the HCR_EL2.NV bit only
when entering the vEL2". But I am still catching up on the already landed

[PATCH 00/18] KVM: arm64: Prefix patches for NV support <https://lore.kernel.org/all/20230209175820.1939006-1-maz@kernel.org/>  so please forgive me my confusion ;-)

Thanks

Eric

> +	 *
> +	 * If KVM ever traps ERET for its own use, we'll have to
> +	 * revisit this.
> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		kvm_emulate_nested_eret(vcpu);
> +	else
> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +
>  	return 1;
>  }
>  
>
> Does the above help?
>
> Thanks,
>
> 	M.
>

