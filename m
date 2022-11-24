Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF960C43217
	for <kvmarm@archiver.kernel.org>; Thu, 24 Nov 2022 13:55:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D4D40385;
	Thu, 24 Nov 2022 08:55:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PTqrpFuE9-gH; Thu, 24 Nov 2022 08:55:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D07F740796;
	Thu, 24 Nov 2022 08:55:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40EBA40719
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 08:55:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Stidzfdkd7sy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Nov 2022 08:55:29 -0500 (EST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE51F4018F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 08:55:29 -0500 (EST)
Received: by mail-wm1-f50.google.com with SMTP id v7so1388035wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 05:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=pN+fMTXIbwkvTVCL6teMynvLqCQ1zb8psy5cG5agjcI=;
 b=o29ZVKlW0hg+wTr5SNdc59ZTn7GtkgIjvdfNuhfZ9Go5RYF0bUJQaqw5oksOVSlXKZ
 gcP9TNLHnjIxApSzZCFmyVSHsnHp5d8nqgupDXaf2I2GRs9KooJHuWeafVn03RAPJtr/
 0qkPSxuCTWSkaFU8OuSG1Uq66QpY8nhn69mWWtcNAOe2IaA095kW57glzfzcSggluPjv
 gM2S+9x9+HeAxzpzkyPXaxArRwLN7K37FBGUiotrf5SRPQRRIGyY0GrWM/F6EFK1MOFE
 SuMysdzefbRAZ6CgZjQ+ih+yQp1V+6yCvXoo5pkoW/Kg6aWhZ65xv+8aFUSMN8tbrBJG
 aQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=pN+fMTXIbwkvTVCL6teMynvLqCQ1zb8psy5cG5agjcI=;
 b=1DcLOpZFHIvT4qI3pgj6ihsv3llKebEX5DDmHY0isXWIG4p9Ie1cchBcVEKun3m5M6
 CaQ256tOLo9YvYk38MZfKhGeNiB+f/MUS4F6ug7RBvsni96zWpGxP9BNEi58Y8S8SCLV
 46l4Nsjs6AIP3dhuT6z8hEtKno5LB7NMR097Qj1tOpChT/wzM7Sl8kwnTedIPCJpx6Gk
 cmfJ24dtwy8YeLzkwfsTnakbdW2U5KF+ZbqbWdBta8AaquTEKJj5/M/GWeage6Xr62YF
 gxAwCQ6OzAcAKyMv7+Vgi1Ea+UqnQ+4i5HC6ryLkc5RMC+q58e9C/ullpFgA2FPffdbk
 qflQ==
X-Gm-Message-State: ANoB5pnHITT2Wl4mXlVniQLZ+jsjwLFmVSB2Osb/EcgR+GbgI4kAimns
 Bq87NaFJ83vkyEZq/rlc/n9x5g==
X-Google-Smtp-Source: AA0mqf7LmgqnY5TT62nL6QBBImocwCh9tlDp2Ug4ekB8tl5kFgZ55ulOqFa7jWHsk4HR1gTXeY+Y4A==
X-Received: by 2002:a1c:a381:0:b0:3cf:4d14:5705 with SMTP id
 m123-20020a1ca381000000b003cf4d145705mr12126137wme.35.1669298128503; 
 Thu, 24 Nov 2022 05:55:28 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:f0b8:522f:5d6e:d788?
 ([2a02:6b6a:b4d7:0:f0b8:522f:5d6e:d788])
 by smtp.gmail.com with ESMTPSA id
 h20-20020a05600c351400b003b4935f04a4sm2479548wmq.5.2022.11.24.05.55.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Nov 2022 05:55:28 -0800 (PST)
Message-ID: <95efd030-27f6-5668-a25e-9fbf210bfa1c@bytedance.com>
Date: Thu, 24 Nov 2022 13:55:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted
 check
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <87k048f3cm.wl-maz@kernel.org>
 <180b91af-a2aa-2cfd-eb7f-b2825c4e3dbe@bytedance.com>
 <86r0y1nmep.wl-maz@kernel.org>
From: Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <86r0y1nmep.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 bagasdotme@gmail.com, fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
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



On 18/11/2022 00:20, Marc Zyngier wrote:
> On Mon, 07 Nov 2022 12:00:44 +0000,
> Usama Arif <usama.arif@bytedance.com> wrote:
>>
>>
>>
>> On 06/11/2022 16:35, Marc Zyngier wrote:
>>> On Fri, 04 Nov 2022 06:20:59 +0000,
>>> Usama Arif <usama.arif@bytedance.com> wrote:
>>>>
>>>> This patchset adds support for vcpu_is_preempted in arm64, which
>>>> allows the guest to check if a vcpu was scheduled out, which is
>>>> useful to know incase it was holding a lock. vcpu_is_preempted can
>>>> be used to improve performance in locking (see owner_on_cpu usage in
>>>> mutex_spin_on_owner, mutex_can_spin_on_owner, rtmutex_spin_on_owner
>>>> and osq_lock) and scheduling (see available_idle_cpu which is used
>>>> in several places in kernel/sched/fair.c for e.g. in wake_affine to
>>>> determine which CPU can run soonest):
>>>
>>> [...]
>>>
>>>> pvcy shows a smaller overall improvement (50%) compared to
>>>> vcpu_is_preempted (277%).  Host side flamegraph analysis shows that
>>>> ~60% of the host time when using pvcy is spent in kvm_handle_wfx,
>>>> compared with ~1.5% when using vcpu_is_preempted, hence
>>>> vcpu_is_preempted shows a larger improvement.
>>>
>>> And have you worked out *why* we spend so much time handling WFE?
>>>
>>> 	M.
>>
>> Its from the following change in pvcy patchset:
>>
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index e778eefcf214..915644816a85 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -118,7 +118,12 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>>          }
>>
>>          if (esr & ESR_ELx_WFx_ISS_WFE) {
>> -               kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
>> +               int state;
>> +               while ((state = kvm_pvcy_check_state(vcpu)) == 0)
>> +                       schedule();
>> +
>> +               if (state == -1)
>> +                       kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
>>          } else {
>>                  if (esr & ESR_ELx_WFx_ISS_WFxT)
>>                          vcpu_set_flag(vcpu, IN_WFIT);
>>
>>
>> If my understanding is correct of the pvcy changes, whenever pvcy
>> returns an unchanged vcpu state, we would schedule to another
>> vcpu. And its the constant scheduling where the time is spent. I guess
>> the affects are much higher when the lock contention is very
>> high. This can be seem from the pvcy host side flamegraph as well with
>> (~67% of the time spent in the schedule() call in kvm_handle_wfx), For
>> reference, I have put the graph at:
>> https://uarif1.github.io/pvlock/perf_host_pvcy_nmi.svg
> 
> The real issue here is that we don't try to pick the right vcpu to
> run, and strictly rely on schedule() to eventually pick something that
> can run.
> 
> An interesting to do would be to try and fit the directed yield
> mechanism there. It would be a lot more interesting than the one-off
> vcpu_is_preempted hack, as it gives us a low-level primitive on which
> to construct things (pvcy is effectively a mwait-like primitive).

We could use kvm_vcpu_yield_to to yield to a specific vcpu, but how 
would we determine which vcpu to yield to?

IMO vcpu_is_preempted is very well integrated in a lot of core kernel 
code, i.e. mutex, rtmutex, rwsem and osq_lock. It is also used in 
scheduler to determine better which vCPU we can run on soonest, select 
idle core, etc. I am not sure if all of these cases will be optimized by 
pvcy? Also, with vcpu_is_preempted, some of the lock heavy benchmarks 
come down from spending around 50% of the time in lock to less than 1% 
(so not sure how much more room is there for improvement).

We could also use vcpu_is_preempted to optimize IPI performance (along 
with directed yield to target IPI vCPU) similar to how its done in x86 
(https://lore.kernel.org/all/1560255830-8656-2-git-send-email-wanpengli@tencent.com/). 
This case definitely wont be covered by pvcy.

Considering all the above, i.e. the core kernel integration already 
present and possible future usecases of vcpu_is_preempted, maybe its 
worth making vcpu_is_preempted work on arm independently of pvcy?

Thanks,
Usama

> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
