From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC PATCH v2 38/38] KVM: arm64: Respect the virtual
 CPTR_EL2.TCPAC setting
Date: Tue, 1 Aug 2017 07:03:35 -0400
Message-ID: <CAHyh4xj8p0dCxv72jxYnTpmV8Ydhz2yvOLqpBHgDiyUcd6FUgg@mail.gmail.com>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-39-git-send-email-jintack.lim@linaro.org>
 <20170731125920.GX5176@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A55C49C31
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Aug 2017 07:02:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ajk3wBFAg3lg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Aug 2017 07:02:23 -0400 (EDT)
Received: from mail-oi0-f54.google.com (mail-oi0-f54.google.com
 [209.85.218.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F9AC40FB0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Aug 2017 07:02:22 -0400 (EDT)
Received: by mail-oi0-f54.google.com with SMTP id e124so11755260oig.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Aug 2017 04:03:38 -0700 (PDT)
Received: from mail-oi0-f41.google.com (mail-oi0-f41.google.com.
 [209.85.218.41])
 by smtp.gmail.com with ESMTPSA id s129sm29176762oif.41.2017.08.01.04.03.36
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 01 Aug 2017 04:03:36 -0700 (PDT)
Received: by mail-oi0-f41.google.com with SMTP id e124so11754408oig.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Aug 2017 04:03:36 -0700 (PDT)
In-Reply-To: <20170731125920.GX5176@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: KVM General <kvm@vger.kernel.org>, david.daney@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, stefan@hello-penguin.com, Jonathan Corbet <corbet@lwn.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andy Gross <andy.gross@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-doc@vger.kernel.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Mon, Jul 31, 2017 at 8:59 AM, Christoffer Dall <cdall@linaro.org> wrote:
> On Tue, Jul 18, 2017 at 11:59:04AM -0500, Jintack Lim wrote:
>> Forward CPACR_EL1 traps to the virtual EL2 if virtual CPTR_EL2 is
>> configured to trap CPACR_EL1 accesses from EL1.
>>
>> This is for recursive nested virtualization.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 6f67666..ba2966d 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1091,6 +1091,11 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
>>       if (el12_reg(p) && forward_nv_traps(vcpu))
>>               return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>>
>> +     /* Forward this trap to the virtual EL2 if CPTR_EL2.TCPAC is set*/
>> +     if (!el12_reg(p) && !vcpu_mode_el2(vcpu) &&
>> +         (vcpu_sys_reg(vcpu, CPTR_EL2) & CPTR_EL2_TCPAC))
>> +             return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +
>
> I'm trying to understand what should happen if the VM is in EL1 and
> accesses CPACR_EL12, but the guest hypervisor did not set
> CPTR_EL2.TCPAC, why would we get here, and if there's a good reason why

I guess what you meant is HCR_EL2.NV bit?

> we god here, is the EL12 access not supposed to undef at EL1 as opposed
> to actually work, like it seems your code does when it doesn't take the
> branch?

IIUC, we need to have this logic

if (el12_reg() && virtual HCR_EL2.NV == 0)
   inject_undef();

This is a good point, and should be applied for all traps controlled by NV bit.

>
>>       /*
>>        * When the virtual HCR_EL2.E2H == 1, an access to CPACR_EL1
>>        * in the virtual EL2 is to access CPTR_EL2.
>> --
>> 1.9.1
>>
>
> Thanks,
> -Christoffer
