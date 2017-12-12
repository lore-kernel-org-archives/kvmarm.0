From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 15/30] arm64/sve: Signal handling support
Date: Tue, 12 Dec 2017 11:36:18 -0800
Message-ID: <CAGXu5j+Kxd9+QBKmFa0i34Xqygh45pE_zQ00VfW87+20m1pSjg@mail.gmail.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <1509465082-30427-16-git-send-email-Dave.Martin@arm.com>
 <CAGXu5jJgsAg1VBMbx=mV3ep4hzs+1G46Sow4eeFqCK31b_sORA@mail.gmail.com>
 <20171207104948.GE31900@arm.com>
 <CAGXu5jLO6tHm-mCPBo-csCw--+_jhLfGD_sHXCkFjmyvdame=g@mail.gmail.com>
 <20171211140720.GE2141@arm.com>
 <CAGXu5j+2MNOnAfstr8RyD0Orrt37ewL8uE2N8e3fL--fNPs3TQ@mail.gmail.com>
 <20171212104030.GG28301@arm.com>
 <20171212111125.GL22781@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 493A349D6A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 14:32:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oAYrcmTGzPgQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 14:32:50 -0500 (EST)
Received: from mail-vk0-f68.google.com (mail-vk0-f68.google.com
 [209.85.213.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D2DA40795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 14:32:50 -0500 (EST)
Received: by mail-vk0-f68.google.com with SMTP id y187so3330531vkd.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 11:36:20 -0800 (PST)
In-Reply-To: <20171212111125.GL22781@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha <libc-alpha@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 12, 2017 at 3:11 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> On Tue, Dec 12, 2017 at 10:40:30AM +0000, Will Deacon wrote:
>> On Mon, Dec 11, 2017 at 11:23:09AM -0800, Kees Cook wrote:
>> > On Mon, Dec 11, 2017 at 6:07 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > > On Thu, Dec 07, 2017 at 10:50:38AM -0800, Kees Cook wrote:
>> > >> My question is mainly: why not just use copy_*() everywhere instead?
>> > >> Having these things so spread out makes it fragile, and there's very
>> > >> little performance benefit from using __copy_*() over copy_*().
>> > >
>> > > I think that's more of a general question. Why not just remove the __
>> > > versions from the kernel entirely if they're not worth the perf?
>> >
>> > That has been something Linus has strongly suggested in the past, so
>> > I've kind of been looking for easy places to drop the __copy_*
>> > versions. :)
>>
>> Tell you what then: I'll Ack the arm64 patch if it's part of a series
>> removing the thing entirely :p
>>
>> I guess we'd still want to the validation of the whole sigframe though,
>> so we don't end up pushing half a signal stack before running into an
>> access_ok failure?
>
> That's an interesting question.  In many cases access_ok() might become
> redundant, but for syscalls that you don't want to have side-effects
> on user memory on failure it's still relevant.
>
> In the signal case we'd still an encompassing access_ok() to prevent
> stack guard overruns, because the signal frame can be large and isn't
> written or read contiguously or in a well-defined order.

Yeah, I think bailing early is fine. I think the existing access_ok()
checks are fine; I wouldn't want to drop those.

-Kees

-- 
Kees Cook
Pixel Security
