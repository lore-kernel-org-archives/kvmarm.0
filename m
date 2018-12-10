From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v6 04/13] arm64/kvm: hide ptrauth from guests
Date: Mon, 10 Dec 2018 20:12:54 +0000
Message-ID: <a2eb07e5-6663-aede-fb75-cc91cf3fffa5@arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-5-kristina.martsenko@arm.com>
 <57966497-d21c-5439-e4ba-d75f5552282f@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57966497-d21c-5439-e4ba-d75f5552282f@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <richard.henderson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/12/2018 14:53, Richard Henderson wrote:
> On 12/7/18 12:39 PM, Kristina Martsenko wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> In subsequent patches we're going to expose ptrauth to the host kernel
>> and userspace, but things are a bit trickier for guest kernels. For the
>> time being, let's hide ptrauth from KVM guests.
>>
>> Regardless of how well-behaved the guest kernel is, guest userspace
>> could attempt to use ptrauth instructions, triggering a trap to EL2,
>> resulting in noise from kvm_handle_unknown_ec(). So let's write up a
>> handler for the PAC trap, which silently injects an UNDEF into the
>> guest, as if the feature were really missing.
> 
> Reviewing the long thread that accompanied v5, I thought we were *not* going to
> trap PAuth instructions from the guest.
> 
> In particular, the OS distribution may legitimately be built to include
> hint-space nops.  This includes XPACLRI, which is used by the C++ exception
> unwinder and not controlled by SCTLR_EL1.EnI{A,B}.

The plan was to disable trapping, yes. However, after that thread there
was a retrospective change applied to the architecture, such that the
XPACLRI (and XPACD/XPACI) instructions are no longer trapped by
HCR_EL2.API. (The public documentation on this has not been updated
yet.) This means that no HINT-space instructions should trap anymore.
(The guest is expected to not set SCTLR_EL1.EnI{A,B} since
ID_AA64ISAR1_EL1.{APA,API} read as 0.)

> It seems like the header comment here, and
Sorry, which header comment?

>> +/*
>> + * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
>> + * a NOP).
>> + */
>> +static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +
> 
> here, need updating.

Changed it to "a trapped ptrauth instruction".

Kristina
