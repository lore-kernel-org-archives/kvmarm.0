Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9490C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  4 Dec 2021 14:14:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1BAA4A193;
	Sat,  4 Dec 2021 09:14:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eXaL4iGTf0ME; Sat,  4 Dec 2021 09:14:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D9344A534;
	Sat,  4 Dec 2021 09:14:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 773AA4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Dec 2021 09:14:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C-1V8R5JIv6l for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Dec 2021 09:14:06 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89B04A193
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Dec 2021 09:14:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638627246;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=g0dO/BpdJD9jOnz6LtLs4iLIZSLA8GKvweu8a6+ian4=;
 b=hS77y2//qwClYiI3sXGTLa2cBsSWEMLmTp5t/VZRQgJ3pv8Xt1ZlOpWzwjrits9qzE9Oru
 dux0CdYAO96eSKbpwuHlzKz42IEuteAkRz0FYn56uYHIu1eAbxClJz5UR82EDpP9g2nqmq
 +lnmsHMOiWbtmyTSHISrvJAHqWAN7Fo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-hpz8vVHJMziIcAShbriUgg-1; Sat, 04 Dec 2021 09:14:05 -0500
X-MC-Unique: hpz8vVHJMziIcAShbriUgg-1
Received: by mail-wm1-f71.google.com with SMTP id
 145-20020a1c0197000000b0032efc3eb9bcso5162328wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 04 Dec 2021 06:14:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=g0dO/BpdJD9jOnz6LtLs4iLIZSLA8GKvweu8a6+ian4=;
 b=eZt4qTe9jj1EwMajALhJrHlWraqcYnKxXgPTY4B1F7zepIKotiTGhV8a5IG4eL768G
 8Q3n0/3JN9N83cDXRnzSGiUnGJ5D0tpL89foItBcT6OMSFA+fMSwd4+LcWmIP6OrNias
 AvCFoIiuu90YsfBz+Fw7Vk3qAKKWW5kubgSjNzbLYnqwKlv2QLG3U+OemZjEJTaRyr1q
 J/qn8qPiQZ/9rcItaEGjmNa0kwOvgK4r4TEcEM704LiXbDRJ5v4cbbIOIiXRcewAvl6T
 Cp6OE+/wCgVcfrKEvVIvIxaqzax0cLdsXA3x+IryXa7thOt8pA78QazCZPLdmlb+juTp
 dX0A==
X-Gm-Message-State: AOAM531rgyEWXfAz6vASDc5MOCYMMGyfEMKBzgcV/C2BAGPIJitiVwf0
 TH5+IiINiz98itWITngjkb2/PQR2fdknXYHvw9e8b9THo063x2KY/5aWhHgN3/OjNFbD2mROYjc
 ehJ4qxbw7L8nUrPSXUXEDs/ys
X-Received: by 2002:a5d:5445:: with SMTP id w5mr30131996wrv.163.1638627244220; 
 Sat, 04 Dec 2021 06:14:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP+cc5bD8j/sZ62eB1LAUdM7vgu+TLoJMaRrRrzwWGIK2bb03aFe0LSJreofrDN5481/3qWw==
X-Received: by 2002:a5d:5445:: with SMTP id w5mr30131964wrv.163.1638627243963; 
 Sat, 04 Dec 2021 06:14:03 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d6sm5686326wrx.60.2021.12.04.06.14.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 04 Dec 2021 06:14:03 -0800 (PST)
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Reiji Watanabe <reijiw@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
 <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <2ed3072b-f83d-1b17-0949-ca38267ba94e@redhat.com>
Date: Sat, 4 Dec 2021 15:14:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On 12/4/21 2:04 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Dec 2, 2021 at 2:57 AM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/30/21 6:32 AM, Reiji Watanabe wrote:
>>> Hi Eric,
>>>
>>> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Reiji,
>>>>
>>>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>>>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
>>>>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
>>>>> expose the value for the guest as it is.  Since KVM doesn't support
>>>>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
>>>>> exopse 0x0 (PMU is not implemented) instead.
>>>> s/exopse/expose
>>>>>
>>>>> Change cpuid_feature_cap_perfmon_field() to update the field value
>>>>> to 0x0 when it is 0xf.
>>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>>>> guest should not use it as a PMUv3?
>>>
>>>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>>>> guest should not use it as a PMUv3?
>>>
>>> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
>>> Arm ARM says:
>>>   "IMPLEMENTATION DEFINED form of performance monitors supported,
>>>    PMUv3 not supported."
>>>
>>> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
>>> be exposed to guests (And this patch series doesn't allow userspace
>>> to set the fields to 0xf for guests).
>> What I don't get is why this isn't detected before (in kvm_reset_vcpu).
>> if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
>> init request if the host pmu is implementation defined?
> 
> KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_PMU_V3 will fail in
> kvm_reset_vcpu() if the host PMU is implementation defined.

OK. This was not obvsious to me.

                if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
                        ret = -EINVAL;
                        goto out;
                }

kvm_perf_init
+	if (perf_num_counters() > 0)
+		static_branch_enable(&kvm_arm_pmu_available);

But I believe you ;-), sorry for the noise

Eric

> 
> The AA64DFR0 and DFR0 registers for a vCPU without KVM_ARM_VCPU_PMU_V3
> indicates IMPLEMENTATION DEFINED PMU support, which is not correct.


> 
> Thanks,
> Reiji
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
