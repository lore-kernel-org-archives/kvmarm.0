Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D91C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 12:00:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C342F4B8A2;
	Mon,  7 Nov 2022 07:00:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5sy6YofpIng7; Mon,  7 Nov 2022 07:00:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3104B89F;
	Mon,  7 Nov 2022 07:00:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC5A4B89F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 07:00:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f0munUFmg6wB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 07:00:47 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA1D84B88A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 07:00:46 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id k8so15889645wrh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 04:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=zWvz8bh4+vQKDNdPBDvtEEjozaiA8NxpItsV7tm0Qy0=;
 b=RM2XZktvK25OAmJHVCsqxExlx2YDb8taU5jJP6p51IieAMAC7rVqfwilaQF7Xqqe3G
 UwMWWVo3jrRu5oK/J3jJN4bG6MrzlcwfXbL/gDA98pemG49BzKD6bgFyow0xVV6hIC4N
 cf6zx1TH/gu3ilDDICAD4lfW6uErG3Aj8PE+aPiMsDZzvwiNA5Y84Nf0p0SZtWeekrp2
 3qdK1/twOpDLX49v/t/ybYncTBiauIlLPODLWk6KsnXmtK/KZ/QbdXqSQ3r7uxN3WAvW
 bCAtytlDiReH1KhZkxHPGBBrCC7+BrOifMA+vx31z4AXM6SLhrkDGFn6tpeXsfo6CyjO
 Ug9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=zWvz8bh4+vQKDNdPBDvtEEjozaiA8NxpItsV7tm0Qy0=;
 b=wLD5JOkiXogBJZiqWt5j6ZbPtK9JzDWHLid7BIA7U4N9jj0+hB8VmbFTl4+Dl588LM
 QwLklUFgxE530B53Brki3hRrjR0fBPtfEaK51AoMx/fm7Z8sOP7BN/A2MBSxvOGkfHXo
 aZlQM6UQhG0bsPmy1pbePp0ZYfw6mBGqJr8ZTgwoKNJNeEXbDd22fUvAWWA9lALK+CDA
 HSXkgSL4qB6BkX/Amq8Du+MmSQdV7aW68vlFypG78lPU2qmOg0q6ZQL+vEt2AfVVhaEo
 aMT00bEVvKFBuBk89zKCGMUYLVAwi1FFzp2+yVW+XU1nxtSdbkObmJ3U9z1B1Q1YOYGU
 d1Og==
X-Gm-Message-State: ACrzQf1heJU0aHcZBEDYRw8/kytRCHzr8gpykHhttcqc+Ub2/AQBQeVD
 8qBfC5NOApZ3xzR98oHyNlkjOA==
X-Google-Smtp-Source: AMsMyM59k115pH9o+6WIgEa9CaPh3ktLnt7NSnldWl3F1VAmeY4BCiQWWWW9a39fkvnQOQN6hJYR7A==
X-Received: by 2002:adf:e241:0:b0:238:3c64:decc with SMTP id
 bl1-20020adfe241000000b002383c64deccmr15833238wrb.698.1667822445787; 
 Mon, 07 Nov 2022 04:00:45 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8?
 ([2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8])
 by smtp.gmail.com with ESMTPSA id
 g2-20020a5d4882000000b00236cb3fec8fsm8600966wrq.9.2022.11.07.04.00.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Nov 2022 04:00:45 -0800 (PST)
Message-ID: <180b91af-a2aa-2cfd-eb7f-b2825c4e3dbe@bytedance.com>
Date: Mon, 7 Nov 2022 12:00:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted
 check
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <87k048f3cm.wl-maz@kernel.org>
From: Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <87k048f3cm.wl-maz@kernel.org>
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



On 06/11/2022 16:35, Marc Zyngier wrote:
> On Fri, 04 Nov 2022 06:20:59 +0000,
> Usama Arif <usama.arif@bytedance.com> wrote:
>>
>> This patchset adds support for vcpu_is_preempted in arm64, which
>> allows the guest to check if a vcpu was scheduled out, which is
>> useful to know incase it was holding a lock. vcpu_is_preempted can
>> be used to improve performance in locking (see owner_on_cpu usage in
>> mutex_spin_on_owner, mutex_can_spin_on_owner, rtmutex_spin_on_owner
>> and osq_lock) and scheduling (see available_idle_cpu which is used
>> in several places in kernel/sched/fair.c for e.g. in wake_affine to
>> determine which CPU can run soonest):
> 
> [...]
> 
>> pvcy shows a smaller overall improvement (50%) compared to
>> vcpu_is_preempted (277%).  Host side flamegraph analysis shows that
>> ~60% of the host time when using pvcy is spent in kvm_handle_wfx,
>> compared with ~1.5% when using vcpu_is_preempted, hence
>> vcpu_is_preempted shows a larger improvement.
> 
> And have you worked out *why* we spend so much time handling WFE?
> 
> 	M.

Its from the following change in pvcy patchset:

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e778eefcf214..915644816a85 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -118,7 +118,12 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
         }

         if (esr & ESR_ELx_WFx_ISS_WFE) {
-               kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
+               int state;
+               while ((state = kvm_pvcy_check_state(vcpu)) == 0)
+                       schedule();
+
+               if (state == -1)
+                       kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
         } else {
                 if (esr & ESR_ELx_WFx_ISS_WFxT)
                         vcpu_set_flag(vcpu, IN_WFIT);


If my understanding is correct of the pvcy changes, whenever pvcy 
returns an unchanged vcpu state, we would schedule to another vcpu. And 
its the constant scheduling where the time is spent. I guess the affects 
are much higher when the lock contention is very high. This can be seem 
from the pvcy host side flamegraph as well with (~67% of the time spent 
in the schedule() call in kvm_handle_wfx), For reference, I have put the 
graph at:
https://uarif1.github.io/pvlock/perf_host_pvcy_nmi.svg

Thanks,
Usama

> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
