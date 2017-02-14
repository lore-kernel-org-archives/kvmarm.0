From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 4/5] arm64: mmu: map .text as read-only from the outset
Date: Tue, 14 Feb 2017 17:49:19 +0000
Message-ID: <42A48E4E-EF3C-4F28-A660-AFEBB238B698@linaro.org>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-5-git-send-email-ard.biesheuvel@linaro.org>
 <20170214155704.GE23718@leverpostej>
 <651D9CBB-3E64-41CE-BF85-D2FF0CB927B7@linaro.org>
 <20170214174029.GJ23718@leverpostej>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E155B40905
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 12:48:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ca7Te6U-pvBC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 12:48:38 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5939540625
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 12:48:38 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id r141so23383690wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 09:49:22 -0800 (PST)
In-Reply-To: <20170214174029.GJ23718@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: keescook@chromium.org, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, andre.przywara@arm.com, nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, labbott@fedoraproject.org
List-Id: kvmarm@lists.cs.columbia.edu


> On 14 Feb 2017, at 17:40, Mark Rutland <mark.rutland@arm.com> wrote:
> 
>> On Tue, Feb 14, 2017 at 04:15:11PM +0000, Ard Biesheuvel wrote:
>> 
>>>> On 14 Feb 2017, at 15:57, Mark Rutland <mark.rutland@arm.com> wrote:
>>>> 
>>>> On Sat, Feb 11, 2017 at 08:23:05PM +0000, Ard Biesheuvel wrote:
>>>> Now that alternatives patching code no longer relies on the primary
>>>> mapping of .text being writable, we can remove the code that removes
>>>> the writable permissions post-init time, and map it read-only from
>>>> the outset.
>>>> 
>>>> Reviewed-by: Laura Abbott <labbott@redhat.com>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> 
>>> This generally looks good.
>>> 
>>> One effect of this is that even with rodata=off, external debuggers
>>> can't install SW breakpoints via the executable mapping.
>> 
>> Interesting. For the sake of my education, could you elaborate on how
>> that works under the hood?
> 
> There are details in ARM DDI 0487A.k_iss10775, Chapter H1, "About
> External Debug", page H1-4839 onwards. Otherwise, executive summary
> below.
> 
> An external debugger can place a CPU into debug state. This is
> orthogonal to execution state and exception level, which are unchanged.
> While in this state, the CPU (only) executes instructions fed to it by
> the debugger through a special register.
> 
> To install a SW breakpoint, the debugger makes the CPU enter debug
> state, then issues regular stores, barriers, and cache maintenance.
> These operate in the current execution state at the current EL, using
> the current translation regime.
> 
> The external debugger can also trap exceptions (e.g. those caused by the
> SW breakpoint). The CPU enters debug state when these are trapped.
> 

OK, thanks for the explanation

>>> We might want to allow that to be overridden. e.g. make rodata= an
>>> early param, and switch the permissions based on that in map_kernel(),
>>> e.g. have:
>>> 
>>>   pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX
>>>                       : PAGE_KERNEL_EXEC);
>>> 
>>> ... and use that for .text and .init.text by default.
>>> 
>>> 
>> 
>> Is there any way we could restrict this privilege to external
>> debuggers?
> 
> My understanding is that we cannot.
> 
>> Having trivial 'off' switches for security features makes me feel
>> uneasy (although this is orthogonal to this patch)
> 
> From my PoV, external debuggers are the sole reason to allow rodata=off
> for arm64, and we already allow rodata=off.
> 
> 

Indeed. If that is how it works currently, we shouldn't interfere with it. If we ever get anywhere with the lockdown patches, we should blacklist this parameter (or rather, not whitelist it, since blacklisting kernel params to enforce security is infeasible imo)
