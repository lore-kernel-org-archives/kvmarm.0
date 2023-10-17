Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C3C381D8
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 09:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1ZiMIkv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697534634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLOip3bfQykwpAa56t2wUVTHXUXOa2fVoIje1MZOWNk=;
	b=P1ZiMIkvMjvYG1FDpYBkgRFt/hUDZGYOigTNIXTbDHbZIjMNYVuLgYE9mCrSJWpaRTltyo
	hbwVBP+b4Ir7HdEgvhpEB+oi8kMGoQxr0gHjX/bcAzjyGujK5m8J9KV8NjrM02CetvrLvJ
	Yf6q3oO1VoTP/Z1pdjV9zNWtgy6gqso=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-OdkkVh-qM0GBqCFDhj2_Zw-1; Tue, 17 Oct 2023 05:23:51 -0400
X-MC-Unique: OdkkVh-qM0GBqCFDhj2_Zw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7742eeceeacso693646985a.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 02:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697534630; x=1698139430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLOip3bfQykwpAa56t2wUVTHXUXOa2fVoIje1MZOWNk=;
        b=OWBijkeki0erdE65Cqtv9keitHqO6Jk9pvrYx1p9nuajPWvy29Kf3LLS/iiLJ2dtd+
         O5pEHpVMyb/G3Py4FdAYebDFBsoJC5ESfO/YxTvVhn8WW1i87Jqrkv66dGb36iZhASKN
         r+te1IzknYcNg4M/P1K/6BEjgTKO2eb/Ocj5ONvETaF+hhHPwtfRq0Li8VrCdnXdHlVI
         oAfSshGoYXdcHrYwhE+4uyyuy9hfEyQ+BGKbCmSBPlyyEEu7tbNVy8HdSDwDegHkgMZp
         pSLnvCUMVu5vCRjROX4Fix+Eb94X6YLZhqVQwWr6zx+LwzN7/tZBAMp+Aejn47c+9MVS
         KsNw==
X-Gm-Message-State: AOJu0YxnkNAO/uZiQK5bTjjDy/FzqQwwmo9hQD2D7FINyQTEDQxGXzCj
	/DOQXJ5GxAkD9WCikYTcebKt9Vk8hRpJztBIlXtulg5jJm3QWoNfcMB346p87Sf1bcnPCqYnL7c
	jTDK4ufrxmW1gW4gF
X-Received: by 2002:a05:620a:8010:b0:774:1e8f:222d with SMTP id ee16-20020a05620a801000b007741e8f222dmr1598575qkb.62.1697534630684;
        Tue, 17 Oct 2023 02:23:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmT7PYS690D5pFfAzGmK1CsH9FeDHWgyo1N9tqdzumaM1PuX9H11xDB3OfDXqDTXQdL84fCA==
X-Received: by 2002:a05:620a:8010:b0:774:1e8f:222d with SMTP id ee16-20020a05620a801000b007741e8f222dmr1598569qkb.62.1697534630430;
        Tue, 17 Oct 2023 02:23:50 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.237.139])
        by smtp.gmail.com with ESMTPSA id y12-20020a37e30c000000b0076f058f5834sm488223qki.61.2023.10.17.02.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 02:23:49 -0700 (PDT)
Message-ID: <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
Date: Tue, 17 Oct 2023 11:23:42 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
 <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,
On 10/16/23 23:28, Raghavendra Rao Ananta wrote:
> On Mon, Oct 16, 2023 at 12:45 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Raghavendra,
>>
>> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
>>> From: Reiji Watanabe <reijiw@google.com>
>>>
>>> On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
>>> PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
>> PMOVS{SET,CLR}_EL0?
> Ah, yes. It should be PMOVS{SET,CLR}_EL0.
> 
>>> This function clears RAZ bits of those registers corresponding
>>> to unimplemented event counters on the vCPU, and sets bits
>>> corresponding to implemented event counters to a predefined
>>> pseudo UNKNOWN value (some bits are set to 1).
>>>
>>> The function identifies (un)implemented event counters on the
>>> vCPU based on the PMCR_EL0.N value on the host. Using the host
>>> value for this would be problematic when KVM supports letting
>>> userspace set PMCR_EL0.N to a value different from the host value
>>> (some of the RAZ bits of those registers could end up being set to 1).
>>>
>>> Fix this by clearing the registers so that it can ensure
>>> that all the RAZ bits are cleared even when the PMCR_EL0.N value
>>> for the vCPU is different from the host value. Use reset_val() to
>>> do this instead of fixing reset_pmu_reg(), and remove
>>> reset_pmu_reg(), as it is no longer used.
>> do you intend to restore the 'unknown' behavior at some point?
>>
> I believe Reiji's (original author) intention was to keep them
> cleared, which would still imply an 'unknown' behavior. Do you think
> there's an issue with this?
Then why do we bother using reset_unknown in the other places if
clearing the bits is enough here?

Thanks

Eric
> 
> Thank you.
> Raghavendra
>> Thanks
>>
>> Eric
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 21 +--------------------
>>>  1 file changed, 1 insertion(+), 20 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 818a52e257ed..3dbb7d276b0e 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>>>       return REG_HIDDEN;
>>>  }
>>>
>>> -static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>> -{
>>> -     u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
>>> -
>>> -     /* No PMU available, any PMU reg may UNDEF... */
>>> -     if (!kvm_arm_support_pmu_v3())
>>> -             return 0;
>>> -
>>> -     n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
>>> -     n &= ARMV8_PMU_PMCR_N_MASK;
>>> -     if (n)
>>> -             mask |= GENMASK(n - 1, 0);
>>> -
>>> -     reset_unknown(vcpu, r);
>>> -     __vcpu_sys_reg(vcpu, r->reg) &= mask;
>>> -
>>> -     return __vcpu_sys_reg(vcpu, r->reg);
>>> -}
>>> -
>>>  static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>>  {
>>>       reset_unknown(vcpu, r);
>>> @@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>>         trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
>>>
>>>  #define PMU_SYS_REG(name)                                            \
>>> -     SYS_DESC(SYS_##name), .reset = reset_pmu_reg,                   \
>>> +     SYS_DESC(SYS_##name), .reset = reset_val,                       \
>>>       .visibility = pmu_visibility
>>>
>>>  /* Macro to expand the PMEVCNTRn_EL0 register */
>>
> 

