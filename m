From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 15/30] arm64/sve: Signal handling support
Date: Thu, 7 Dec 2017 10:50:38 -0800
Message-ID: <CAGXu5jLO6tHm-mCPBo-csCw--+_jhLfGD_sHXCkFjmyvdame=g@mail.gmail.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <1509465082-30427-16-git-send-email-Dave.Martin@arm.com> <CAGXu5jJgsAg1VBMbx=mV3ep4hzs+1G46Sow4eeFqCK31b_sORA@mail.gmail.com>
 <20171207104948.GE31900@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171207104948.GE31900@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, linux-arch <linux-arch@vger.kernel.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha <libc-alpha@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 7, 2017 at 2:49 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Kees,
>
> On Wed, Dec 06, 2017 at 11:56:50AM -0800, Kees Cook wrote:
>> On Tue, Oct 31, 2017 at 8:51 AM, Dave Martin <Dave.Martin@arm.com> wrote:
>> > Miscellaneous:
>> >
>> >  * Change inconsistent copy_to_user() calls to __copy_to_user() in
>> >    preserve_sve_context().
>> >
>> >    There are already __put_user_error() calls here.
>> >
>> >    The whole extended signal frame is already checked for
>> >    access_ok(VERIFY_WRITE) in get_sigframe().
>>
>> Verifying all these __copy_to/from_user() calls is rather non-trivial.
>> For example, I had to understand that the access_ok() check actually
>> spans memory that both user->sigframe and user->next_frame point into.
>
> I don't think that's particularly difficult -- you just have to read the
> four lines preceding the access_ok.

Sure, but someone working backward from finding the __copy_*, it's
less obvious. :)

>> And it isn't clear to me that all users of apply_user_offset() are
>> within this range too, along with other manually calculated offsets in
>> setup_sigframe().
>
> The offsets passed into apply_user_offset are calculated by
> setup_sigframe_layout as the stack is allocated, so they're correct by
> construction. We could add a size check in apply_user_offset if you like?
>
>> And it's not clear if parse_user_sigframe() is safe either. Are
>> user->fpsimd and user->sve checked somewhere? It seems like it's
>> safely contained by in sf->uc.uc_mcontext.__reserved, but it's hard to
>> read, though I do see access_ok() checks against __reserved at the end
>> of the while loop.
>
> This one is certainly more difficult to follow, mainly because it's spread
> about a bit and we have to check the extra context separately. However, the
> main part of the frame is checked in sys_rt_sigreturn before calling
> restore_sigframe, and the extra context is checked in parse_user_sigframe
> if we find it.
>
> Dave, any thoughts on making this easier to understand?

My question is mainly: why not just use copy_*() everywhere instead?
Having these things so spread out makes it fragile, and there's very
little performance benefit from using __copy_*() over copy_*().

As far as I can see, everything looks correctly checked here, but it
took a while to convince myself of it. Having Dave's description in
the other reply certainly helped, though, thanks for that! :)

-Kees

-- 
Kees Cook
Pixel Security
