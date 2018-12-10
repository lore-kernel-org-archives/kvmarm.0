From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v6 04/13] arm64/kvm: hide ptrauth from guests
Date: Mon, 10 Dec 2018 20:30:33 +0000
Message-ID: <60a6ca4b-cfe9-1ed3-dce6-9f58575240ba@arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-5-kristina.martsenko@arm.com>
 <57966497-d21c-5439-e4ba-d75f5552282f@linaro.org>
 <a2eb07e5-6663-aede-fb75-cc91cf3fffa5@arm.com>
 <1f179017-4237-0d36-7adc-0a1470b5fd46@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1f179017-4237-0d36-7adc-0a1470b5fd46@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <richard.henderson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/12/2018 20:22, Richard Henderson wrote:
> On 12/10/18 2:12 PM, Kristina Martsenko wrote:
>> The plan was to disable trapping, yes. However, after that thread there
>> was a retrospective change applied to the architecture, such that the
>> XPACLRI (and XPACD/XPACI) instructions are no longer trapped by
>> HCR_EL2.API. (The public documentation on this has not been updated
>> yet.) This means that no HINT-space instructions should trap anymore.
> 
> Ah, thanks for the update.  I'll update my QEMU patch set.
> 
>>> It seems like the header comment here, and
>> Sorry, which header comment?
> 
> Sorry, the patch commit message.

Ah ok. Still seems correct.

Kristina
