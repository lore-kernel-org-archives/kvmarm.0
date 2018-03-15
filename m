From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: rename the function arm64_is_ras_serror() to avoid
 confusion
Date: Thu, 15 Mar 2018 19:52:17 +0000
Message-ID: <5AAACEF1.1060701@arm.com>
References: <1519322552-7374-1-git-send-email-gengdongjiu@huawei.com> <5A90563E.4020608@arm.com> <CAMj-D2Cd7_fCwMuHKr-UQ3i4LEDkktxcg_GtO-QCqnj52mHyKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMj-D2Cd7_fCwMuHKr-UQ3i4LEDkktxcg_GtO-QCqnj52mHyKA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: Dongjiu Geng <gengdongjiu@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 26/02/18 16:13, gengdongjiu wrote:
> 2018-02-24 1:58 GMT+08:00 James Morse <james.morse@arm.com>:
>> On 22/02/18 18:02, Dongjiu Geng wrote:
>>> The RAS SError Syndrome can be Implementation-Defined,
>>> arm64_is_ras_serror() is used to judge whether it is RAS SError,
>>> but arm64_is_ras_serror() does not include this judgement. In order
>>> to avoid function name confusion, we rename the arm64_is_ras_serror()
>>> to arm64_is_categorized_ras_serror(), this function is used to
>>> judge whether it is categorized RAS Serror.
>>
>> I don't see how 'categorized' is relevant. The most significant ISS bit is used
>> to determine if this is an IMP-DEF ESR, or one that uses the architected layout.
> 
> From the name arm64_is_ras_serror(), it used to judge whether this is
> RAS Serror,
> but arm64_is_ras_serror() think the IMP-DEF SError is not RAS SError,
> as shown the code note and code in[1].

> In fact the IMP-DEF SError is also RAS SError, so when I read the
> code, it looks like

This is just you then. No-one else has your imp-def:RAS error ESR values.

This would be like me adding some impdef branch instruction, then claiming
aarch64_insn_is_branch() doesn't take account of my private additions.

I agree the name is assuming all architected ESR are RAS-errors, and that impdef
ESR are just that: impdef, that's all we know about them. Unless this causes us
to do the wrong thing, I don't think it matters.
Obviously we would need to change it if a new architected ESR is added.


> confusion, so I rename it to arm64_is_categorized_ras_serror(), then

This is actually worse, because there is an architected ESR for 'uncategorized',
that the helper papers-over and treats as uncontained. Calling it 'categorized'
means we now have three states, not two.


> this function is only used to
> judge whether this is categorized RAS SError,
> if it is categorized, the code will continue judge its Asynchronous Error Type.
> if it is uncategorized, the code will panic(this is the original code
> logic) or not panic when we support kernel-first or can isolate the
> SError


Thanks,

James
