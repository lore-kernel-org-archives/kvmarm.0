From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC PATCH v2 19/31] KVM: arm64: Describe AT instruction
 emulation design
Date: Tue, 3 Oct 2017 17:11:34 -0400
Message-ID: <CAHyh4xgWaPTYn5C-KZKp-wmkCpZ5A--2iemVV5rfG1Opjk1yJw@mail.gmail.com>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
 <1507000273-3735-17-git-send-email-jintack.lim@linaro.org>
 <59D3CAF2.2030704@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A515940638
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Oct 2017 17:11:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gl6tU4i1Y0kW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Oct 2017 17:11:17 -0400 (EDT)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0E6240DBF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Oct 2017 17:11:17 -0400 (EDT)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v93LB8bH058716
 for <kvmarm@lists.cs.columbia.edu>; Tue, 3 Oct 2017 17:11:39 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 6C7A76D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Oct 2017 17:11:39 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 5669384
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Oct 2017 17:11:39 -0400 (EDT)
Received: from mail-wr0-f199.google.com (mail-wr0-f199.google.com
 [209.85.128.199])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v93LBcoV000833
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 3 Oct 2017 17:11:39 -0400
Received: by mail-wr0-f199.google.com with SMTP id y8so2586052wrd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Oct 2017 14:11:39 -0700 (PDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com.
 [74.125.82.54])
 by smtp.gmail.com with ESMTPSA id c34sm12175073ede.84.2017.10.03.14.11.35
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 03 Oct 2017 14:11:36 -0700 (PDT)
Received: by mail-wm0-f54.google.com with SMTP id i124so19457756wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Oct 2017 14:11:35 -0700 (PDT)
In-Reply-To: <59D3CAF2.2030704@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Tue, Oct 3, 2017 at 1:37 PM, James Morse <james.morse@arm.com> wrote:
> Hi Jintack,
>
> On 03/10/17 04:11, Jintack Lim wrote:
>> This design overview will help to digest the subsequent patches that
>> implement AT instruction emulation.
>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 8d04926..d8728cc 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1621,6 +1621,72 @@ static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
>>       { SYS_DESC(SYS_SP_EL2), NULL, reset_special, SP_EL2, 0},
>>  };
>>
>> +/*
>> + * AT instruction emulation
>> + *
>> + * We emulate AT instructions executed in the virtual EL2.
>
>> + * Basic strategy for the stage-1 translation emulation is to load proper
>> + * context, which depends on the trapped instruction and the virtual HCR_EL2,
>> + * to the EL1 virtual memory control registers and execute S1E[01] instructions
>> + * in EL2. See below for more detail.
>
> What happens if the guest memory containing some stage1-page-table has been
> unmapped from stage2? (e.g. its swapped to disk).
>
> (there is some background to this: I tried to implement the kvm_translate
> ioctl() using this approach, running 'at s1e1*' from EL2. I ran into problems
> when parts of the guest's stage1 page tables had been unmapped from stage2.)
>
> From memory, I found that the AT instructions would fault-in those pages when
> run from EL1, but when executing the same instruction at EL2 they just failed
> without any hint of which IPA needed mapping in.

I think I haven't encountered this case yet, probably because I
usually don't set a swap partition.

In fact, I couldn't find pseudocode for AT instructions. If you
happened to have one, is that behavior you observed described in ARM
ARM?

Thanks,
Jintack

>
> I can try digging for any left over code if we want to setup a test case for this...
>
>
> Thanks,
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
