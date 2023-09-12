Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87F945F
	for <kvmarm@lists.linux.dev>; Tue, 12 Sep 2023 04:14:46 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68fb71ded6dso1471722b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Sep 2023 21:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1694492086; x=1695096886; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drM0H8ao22RI12hMMB2VfXYxqiSVys99eLtTMdg41bs=;
        b=XxM90ur81fz6vNPkDMf/6lDIoKvCEJFQb0QZ6LnH0evxyI5kOtv2VVqLKPsNxUC2mL
         pJ7fTcG0aWIbvHbNQVM6QeP/r7b5kG04Trs+i2GDvHOIFZ8oI0Fhmzl/ibfWEqQ4JV7K
         j+zdS6SF9/pRuNXzyzZ8wo0nceh3fCE66MP9hoKa2slXrHRMjv4REao7zUB2MngGX/fm
         6idRA3lza1uUC9ho1CI7Jf1uTJcazIGQ3TSLOkyiSrZ+whnsAk8aaalt2BgrcvEZRwgG
         mhT+Ka9ZAEB1gTZlCuLzh0E8fJETMoRAUQunt57QPIcyBAztecK7Ib0QMoS8pVeZJQdH
         4geQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694492086; x=1695096886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=drM0H8ao22RI12hMMB2VfXYxqiSVys99eLtTMdg41bs=;
        b=p6lI8mqe8YaBcbNDuBcPzOrJ3wInzJLQwlSGsSUHEU4BSjv9yXtmdNsRk4qoSLoOd+
         32/6fHqn6w10DNJychYyBVU4cujURA4rx23nesWr+7bEctdbXsukEPfEIYaEnjwSGy2q
         g9d+xt8KP9Ooc03JFm51MWAayoVSKzYP2kR3OLa+QN4KHbMbtU4mJ1R6be5xLO3FAD2G
         jiVFFUFeS3pzL1yISBGqiNeZ6K6ymKa5K2m/TqQzrKScJS3PIOnyMdhLalukFJ1edM3e
         9z7QMNVw0FURk5HaDkSqrphNdKO8BkbXJgoNnwJN0/FeeWB/zvNmDW16OwUe19x8NtGE
         DYOQ==
X-Gm-Message-State: AOJu0YxvlQTBQIrkZLDL/xJM8A5TAXYnQGKl+OjlJOFmWtZ1XIdHBFGx
	7gdk1IpNZWCAEXc5RJwwl5PiTA==
X-Google-Smtp-Source: AGHT+IGstt/vwuSpm6rFlRDM4PATk6FF/oRYMNvZG9bcxVP4oaJfy6XkFEJSUJYu9JC4by/XrcLx3A==
X-Received: by 2002:a05:6a00:15ca:b0:68a:4dfa:ea63 with SMTP id o10-20020a056a0015ca00b0068a4dfaea63mr11064158pfu.19.1694492085788;
        Mon, 11 Sep 2023 21:14:45 -0700 (PDT)
Received: from [10.3.221.67] ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id bk15-20020aa7830f000000b00689f5940061sm3510656pfb.17.2023.09.11.21.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 21:14:45 -0700 (PDT)
Message-ID: <28610076-6ac7-4004-8479-e0005ff96c63@bytedance.com>
Date: Tue, 12 Sep 2023 12:13:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2] KVM: arm/arm64: optimize vSGI injection performance
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, zhouyibo@bytedance.com,
 zhouliang.001@bytedance.com
References: <20230825015811.5292-1-zhaoxu.35@bytedance.com>
 <86o7iidzwb.wl-maz@kernel.org>
From: zhaoxu <zhaoxu.35@bytedance.com>
In-Reply-To: <86o7iidzwb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2023/9/4 17:57, Marc Zyngier wrote:
> On Fri, 25 Aug 2023 02:58:11 +0100,
> Xu Zhao <zhaoxu.35@bytedance.com> wrote:
[...]
>> -	unsigned long affinity;
>> -	int level0;
>> +	u64 aff;
>>   
>> -	/*
>> -	 * Split the current VCPU's MPIDR into affinity level 0 and the
>> -	 * rest as this is what we have to compare against.
>> -	 */
>> -	affinity = kvm_vcpu_get_mpidr_aff(vcpu);
>> -	level0 = MPIDR_AFFINITY_LEVEL(affinity, 0);
>> -	affinity &= ~MPIDR_LEVEL_MASK;
>> +	/* aff3 - aff1 */
>> +	aff = (((reg) & ICC_SGI1R_AFFINITY_3_MASK) >> ICC_SGI1R_AFFINITY_3_SHIFT) << 16 |
>> +		(((reg) & ICC_SGI1R_AFFINITY_2_MASK) >> ICC_SGI1R_AFFINITY_2_SHIFT) << 8 |
>> +		(((reg) & ICC_SGI1R_AFFINITY_1_MASK) >> ICC_SGI1R_AFFINITY_1_SHIFT);
> 
> Here, you assume that you can directly map a vcpu index to an
> affinity. It would be awesome if that was the case. However, this is
> only valid at reset time, and userspace is perfectly allowed to change
> this mapping by writing to the vcpu's MPIDR_EL1.
> 
> So this won't work at all if userspace wants to set its own specific
> CPU numbering.
> 
> 	M.
> 
Hi Marc,

Yes, i don't think too much about userspace can change MPIDR value, I 
checked the source code of qemu, qemu create vcpu sequentially, so in 
this case, vcpu_id is equivalent to vcpu_idx which means vcpu_id 
represents the position in vcpu array.

These days, I'm still thinking about whether it is because of the 
content related to future vcpu hot-plug feature that vcpu_id can be 
modified, but now it seems that's not entirely the case.

I have read your latest patch and have been deeply inspired, and Thanks 
for agreeing with this issue.

With Regards
	Xu.
