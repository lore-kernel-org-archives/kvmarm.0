From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Sat, 16 Dec 2017 11:44:56 +0800
Message-ID: <b98d911d-afc3-115b-3ba0-35b1daf63723@huawei.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com> <4af78739-99da-4056-4db1-f80bfe11081a@huawei.com>
 <5A283F26.3020507@arm.com> <4b37e86d-eee3-c51e-eceb-5d0c7ad12886@huawei.com>
 <5A3419FF.30101@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5629D49D6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 22:41:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T7-p5WviwvE3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 22:41:57 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36C6D49D4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 22:41:57 -0500 (EST)
In-Reply-To: <5A3419FF.30101@arm.com>
Content-Language: en-US
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
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/12/16 2:52, James Morse wrote:
>> signal, it will record the CPER and trigger a IRQ to notify guest, as shown below:
>>
>> SIGBUS_MCEERR_AR trigger Synchronous External Abort.
>> SIGBUS_MCEERR_AO trigger GPIO IRQ.
>>
>> For the SIGBUS_MCEERR_AO and SIGBUS_MCEERR_AR, we have already specify trigger method, which all
>>
>> not involve _trigger_ an SError.
> It's a policy choice. How does your virtual CPU notify RAS errors to its virtual
> software? You could use SError for SIGBUS_MCEERR_AR, it depends on what type of
> CPU you are trying to emulate.
> 
> I'd suggest using NOTIFY_SEA for SIGBUS_MCEERR_AR as it avoids problems where
> the guest doesn't take the SError immediately, instead tries to re-execute the
I agree it is better to use NOTIFY_SEA for SIGBUS_MCEERR_AR in this case.

> code KVM has unmapped from stage2 because its corrupt. (You could detect this
> happening in Qemu and try something else)For something else, using NOTIFY_SEI for SIGBUS_MCEERR_AR? At current implementation,
It seems only have this case that "KVM has unmapped from stage2", do you thing we still have something else?

> 
> 
> Synchronous/asynchronous external abort matters to the CPU, but once the error
> has been notified to software the reasons for this distinction disappear. Once
> the error has been handled, all trace of this distinction is gone.
> 
> CPER records only describe component failures. You are trying to re-create some
> state that disappeared with one of the firmware-first abstractions. Trying to
> re-create this information isn't worth the effort as the distinction doesn't
> matter to linux, only to the CPU.
> 
> 
>> so there is no chance for Qemu to trigger the SError when gets the SIGBUS_MCEERR_A{O,R}.
> You mean there is no reason for Qemu to trigger an SError when it gets a signal
> from the kernel.
> 
> The reasons the CPU might have to generate an SError don't apply to linux and
> KVM user space. User-space will never get a signal for an uncontained error, we
> will always panic(). We can't give user-space a signal for imprecise exceptions,
> as it can't return from the signal. The classes of error that are left are
> covered by polled/irq and NOTIFY_SEA.
> 
> Qemu can decide to generate RAS SErrors for SIGBUS_MCEERR_AR if it really wants
> to, (but I don't think you should, the kernel may have unmapped the page at PC
> from stage2 due to corruption).
yes, you also said you do not want to generate RAS SErrors for SIGBUS_MCEERR_AR,
so Qemu does not know in which condition to generate RAS SErrors.

> 
> I think the problem here is you're applying the CPU->software behaviour and
> choices to software->software. By the time user-space gets the error, the
> behaviour is different.
In the KVM, as a policy choice to reserve this API to specify guest ESR and drive to trigger SError is OK,
At least for Qemu it does not know in which condition to trigger it.
