Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF181C43217
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 13:15:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D9C14B17C;
	Thu,  3 Nov 2022 09:15:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vwU1Obp4z8gH; Thu,  3 Nov 2022 09:15:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 185EC4B59D;
	Thu,  3 Nov 2022 09:15:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 938304B59D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:15:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IuIYWf00BV28 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 09:15:46 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F34D4B17C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:15:46 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id bs21so2729836wrb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 06:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=/Uz8rR70OjyKINZokXTU1v1eU2uJSzZ6mJlBltevdQ8=;
 b=VsokLj8NPmmHIxAkl3U4Zzp9E2X0fE9dwKRILlOwYTC5LgI1wcPxeWlSpBDgZ2CmGb
 /cy/OLTi12us88ZigGcDebbjqepOHRisM5W05l4aMBAw/T/Pbo70p2e/eBOUAYC6kfHN
 XO5zvr0AR+3+u9m84L6yOf8JDsoCwrA6aZSQ9p5KFwWH3pFt/UW+cpZaqAaNhL42bzja
 /d2sKiGkYVjYLG5n6SK12FlE+GKh4a4gSRx8yawMPvf3reGzFbhKoH/9grm8BK+Uybbw
 og0TS+SlpJbgYS/Qx+Q4uY6SV86MMuq1AlKypE+rpBQG4W9uIKbYqO8mm89JA3vgje9d
 ibqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=/Uz8rR70OjyKINZokXTU1v1eU2uJSzZ6mJlBltevdQ8=;
 b=OzwnfVpASOXPFfElI+D/Yzre02DS2U25rtQEC1bpWW9rVMuNXU/sXOv3d4oJmqFq07
 lEL+DXIXvaU0kF0ct/riAfusy02fmk3aE41uG/VsKX2qqC4QWEdp5tJFe0XkOLuJ1EP8
 dT8HcMS1K4R9x7pePPAT/5JUw944s36K5bTRmKAu2YaU4NLHKOUrcwCqhPwp4ndGvnvg
 98XJH1nnPoRgPw+l7BQMPXn1SyA9AwPJ/gIhKoBwKdk9qW2ggDUE7MJVz+hobcpro0X6
 1lSLwCEaMQdUqtzUxodlAhR+tPEy1YbseQ+s/E9QyzS/lVQBPzGeDPOOKnla+gIkaT7R
 k+Cw==
X-Gm-Message-State: ACrzQf1mbatvDsDs6h10rbDn4WE7FLw03sczWY9VH7ZzZRa8X8XF6Uq8
 qofPxiVO/9buKrLewDYWePpGUQ==
X-Google-Smtp-Source: AMsMyM5/gRUBbSwi+M4mmRLzP89ZKG4CtBvh+iLD5Myg/vwJXcBalU33moc/YnG5bfRjlBqnD+q09w==
X-Received: by 2002:a5d:6ac7:0:b0:236:b281:150 with SMTP id
 u7-20020a5d6ac7000000b00236b2810150mr18040279wrw.29.1667481345487; 
 Thu, 03 Nov 2022 06:15:45 -0700 (PDT)
Received: from ?IPV6:2a02:6b6a:b4d7:0:e42f:dffe:32d3:8bf2?
 ([2a02:6b6a:b4d7:0:e42f:dffe:32d3:8bf2])
 by smtp.gmail.com with ESMTPSA id
 c4-20020a05600c0a4400b003cf894c05e4sm4027606wmq.22.2022.11.03.06.15.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 06:15:44 -0700 (PDT)
Message-ID: <61800b69-5f6a-d173-fc42-628ee3db15d8@bytedance.com>
Date: Thu, 3 Nov 2022 13:15:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [RFC 1/6] KVM: arm64: Document PV-lock interface
Content-Language: en-US
To: Bagas Sanjaya <bagasdotme@gmail.com>
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
 <20221102161340.2982090-2-usama.arif@bytedance.com>
 <Y2M6eU6xW7jjVQNx@debian.me>
From: Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <Y2M6eU6xW7jjVQNx@debian.me>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 fam.zheng@bytedance.com, maz@kernel.org, punit.agrawal@bytedance.com,
 linux@armlinux.org.uk, liangma@liangbit.com, steven.price@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

Thanks for the review. I will include the changes in the next version I 
send for pvlock. I have sent a patch to fix pvtime here 
https://lore.kernel.org/all/20221103131210.3603385-1-usama.arif@bytedance.com/.

Usama

On 03/11/2022 03:50, Bagas Sanjaya wrote:
> On Wed, Nov 02, 2022 at 04:13:35PM +0000, Usama Arif wrote:
>> +    ============= ========    ==========
>> +    Function ID:  (uint32)    0xC6000020
>> +    PV_call_id:   (uint32)    The function to query for support.
>> +                              Currently only PV_LOCK_PREEMPTED is supported.
>> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>> +                              PV-lock feature is supported by the hypervisor.
>> +    ============= ========    ==========
>> +
>> +PV_LOCK_PREEMPTED
>> +    ============= ========    ==========
>> +    Function ID:  (uint32)    0xC6000021
>> +    Return value: (int64)     IPA of the pv lock data structure for this
>> +                              VCPU. On failure:
>> +                              NOT_SUPPORTED (-1)
>> +    ============= ========    ==========
>> +
> 
> You need to fix up these tables above:
> 
> ---- >8 ----
> 
> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
> index 766aeef50b2d31..940a1cb221bc90 100644
> --- a/Documentation/virt/kvm/arm/pvlock.rst
> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> @@ -15,21 +15,23 @@ The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
>   ARCH_FEATURES mechanism before calling it.
>   
>   PV_LOCK_FEATURES
> -    ============= ========    ==========
> +
> +    ============= ========    =================================================
>       Function ID:  (uint32)    0xC6000020
>       PV_call_id:   (uint32)    The function to query for support.
>                                 Currently only PV_LOCK_PREEMPTED is supported.
>       Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>                                 PV-lock feature is supported by the hypervisor.
> -    ============= ========    ==========
> +    ============= ========    =================================================
>   
>   PV_LOCK_PREEMPTED
> -    ============= ========    ==========
> +
> +    ============= ========    ==========================================
>       Function ID:  (uint32)    0xC6000021
>       Return value: (int64)     IPA of the pv lock data structure for this
>                                 VCPU. On failure:
>                                 NOT_SUPPORTED (-1)
> -    ============= ========    ==========
> +    ============= ========    ==========================================
>   
>   The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
>   memory with inner and outer write back caching attributes, in the inner
> 
> The similar fixup should also be made to the tables in
> Documentation/virt/kvm/arm/pvtime.rst, though.
> 
>> +The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
>> +memory with inner and outer write back caching attributes, in the inner
>> +shareable domain.
>> +
>> +PV_LOCK_PREEMPTED returns the structure for the calling VCPU.
>> +
>> +PV lock state
>> +-------------
>> +
>> +The structure pointed to by the PV_LOCK_PREEMPTED hypercall is as follows:
>> +
>> ++-----------+-------------+-------------+---------------------------------+
>> +| Field     | Byte Length | Byte Offset | Description                     |
>> ++===========+=============+=============+=================================+
>> +| preempted |      8      |      0      | Indicate if the VCPU that owns  |
>> +|           |             |             | this struct is running or not.  |
>> +|           |             |             | Non-zero values mean the VCPU   |
>> +|           |             |             | has been preempted. Zero means  |
>> +|           |             |             | the VCPU is not preempted.      |
>> ++-----------+-------------+-------------+---------------------------------+
>> +
>> +The preempted field will be updated to 1 by the hypervisor prior to scheduling
>> +a VCPU. When the VCPU is scheduled out, the preempted field will be updated
>> +to 0 by the hypervisor.
>> +
>> +The structure will be present within a reserved region of the normal memory
>> +given to the guest. The guest should not attempt to write into this memory.
>> +There is a structure per VCPU of the guest.
>> +
>> +For the user space interface see Documentation/virt/kvm/devices/vcpu.rst
>> +section "4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL".
> 
> Use reST labels for cross-referencing to the documentation section:
> 
> ---- >8 ----
> 
> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
> index 940a1cb221bc90..4e9d09b76ef033 100644
> --- a/Documentation/virt/kvm/arm/pvlock.rst
> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> @@ -62,5 +62,5 @@ The structure will be present within a reserved region of the normal memory
>   given to the guest. The guest should not attempt to write into this memory.
>   There is a structure per VCPU of the guest.
>   
> -For the user space interface see Documentation/virt/kvm/devices/vcpu.rst
> -section "4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL".
> +For the user space interface see :ref:`KVM_VCPU_TSC_CTRL in Generic vcpu
> +interface documentation <kvm-vcpu-tsc-ctrl>`.
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 223ac2fe62f01f..6532f61073a39c 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -194,6 +194,8 @@ base address must be 64 byte aligned and exist within a valid guest memory
>   region. See Documentation/virt/kvm/arm/pvtime.rst for more information
>   including the layout of the stolen time structure.
>   
> +.. _kvm-vcpu-tsc-ctrl:
> +
>   4. GROUP: KVM_VCPU_TSC_CTRL
>   ===========================
>   
> 
> Also, you need to add the documentation to table of contents (index):
> 
> ---- >8 ----
> 
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index e8484843215808..b8499dc00a6a96 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -10,4 +10,5 @@ ARM
>      hyp-abi
>      hypercalls
>      pvtime
> +   pvlock
>      ptp_kvm
> 
> Thanks.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
