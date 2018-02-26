From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH] arm64: rename the function arm64_is_ras_serror() to avoid confusion
Date: Tue, 27 Feb 2018 00:13:03 +0800
Message-ID: <CAMj-D2Cd7_fCwMuHKr-UQ3i4LEDkktxcg_GtO-QCqnj52mHyKA@mail.gmail.com>
References: <1519322552-7374-1-git-send-email-gengdongjiu@huawei.com> <5A90563E.4020608@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5A90563E.4020608@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: Dongjiu Geng <gengdongjiu@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
   Thanks a lot for your review.

2018-02-24 1:58 GMT+08:00 James Morse <james.morse@arm.com>:
> Hi Dongjiu Geng,
>
> On 22/02/18 18:02, Dongjiu Geng wrote:
>> The RAS SError Syndrome can be Implementation-Defined,
>> arm64_is_ras_serror() is used to judge whether it is RAS SError,
>> but arm64_is_ras_serror() does not include this judgement. In order
>> to avoid function name confusion, we rename the arm64_is_ras_serror()
>> to arm64_is_categorized_ras_serror(), this function is used to
>> judge whether it is categorized RAS Serror.
>
> I don't see how 'categorized' is relevant. The most significant ISS bit is used
> to determine if this is an IMP-DEF ESR, or one that uses the architected layout.

>From the name arm64_is_ras_serror(), it used to judge whether this is
RAS Serror,
but arm64_is_ras_serror() think the IMP-DEF SError is not RAS SError,
as shown the code note
and code in[1]. In fact the IMP-DEF SError is also RAS SError, so when
I read the code, it looks like
confusion, so I rename it to arm64_is_categorized_ras_serror(), then
this function is only used to
judge whether this is categorized RAS SError,
if it is categorized, the code will continue judge its Asynchronous Error Type.
if it is uncategorized, the code will panic(this is the original code
logic) or not panic when we support kernel-first or can isolate the
SError

[1]:
 /*
  *  ...................................................
   *CPUs with the RAS extensions have an Implementation-Defined-Syndrome bit
- * If this bit is set, we know its not a RAS SError.
  * ...............................................................................
  */
static inline bool arm64_is_ras_serror(u32 esr)
 {
        WARN_ON(preemptible());

        if (esr & ESR_ELx_IDS)
                return false;
        .........................
}

>
> DFSC of zero means uncategorised. What should we do with an uncategorised SError?

yes, so it returns false because it is uncategorised.

>
> From 2.4.3 "ESB and other physical errors" of [0]
> | It is IMPLEMENTATION DEFINED whether [..]uncategorized SError interrupts
> | are containable or Uncontainable, and whether they can be synchronized by an
> | Error Synchronization Barrier.
>
> We treat uncategorized as uncontainable as that's the worst thing it could be.

in original code, system will panic if it is uncategorized, I do not
change this logic.
 I only rename this function name to make it less confusion
it no need to panic for uncontainable if we can isolate this error.


>
> On aarch32 uncontainable and uncategorized even share an encoding.
> (AET:00 in G7.2.43 "DFSR, Data Fault Status Register", 'state of the PE after
> taking the SError interrupt exception')
>
>
>> Change some code notes, unrecoverable RAS errors is imprecise, but
>> Recoverable RAS errors is precise.
>
> Unrecoverable and Recoverable (but we don't know where it is) are both grouped
> into 'can't make progress'. The comment says:
> | The exception may have been imprecise.
> because one of those two is imprecise.
>
> If anyone cares which one is which, they can read the spec.
>
> I expect this code will one day be replaced with proper kernel-first support,
> its only here to avoid panic()ing due to corrected errors.

Ok, thanks for the explanation.


>
>
> Thanks,
>
> James
>
> [0]
> https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
