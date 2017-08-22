From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 09/27] arm64/sve: Signal frame and context structure definition
Date: Tue, 22 Aug 2017 16:03:20 +0100
Message-ID: <87shgj4pc7.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com> <1502280338-23002-10-git-send-email-Dave.Martin@arm.com> <87y3qb52ez.fsf@linaro.org> <20170822111705.GT6321@e103592.cambridge.arm.com> <87tw0z4sk2.fsf@linaro.org> <20170822142135.GU6321@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <20170822142135.GU6321@e103592.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, gdb@sourceware.org, Yao Qi <Yao.Qi@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alan Hayward <alan.hayward@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> On Tue, Aug 22, 2017 at 02:53:49PM +0100, Alex Bennée wrote:
>>
>> Dave Martin <Dave.Martin@arm.com> writes:
>>
>> > On Tue, Aug 22, 2017 at 11:22:44AM +0100, Alex Bennée wrote:
>> >>
>> >> Dave Martin <Dave.Martin@arm.com> writes:
>
> [...]
>
>> >> > +/*
>> >> > + * The SVE architecture leaves space for future expansion of the
>> >> > + * vector length beyond its initial architectural limit of 2048 bits
>> >> > + * (16 quadwords).
>> >> > + */
>> >> > +#define SVE_VQ_MIN		1
>> >> > +#define SVE_VQ_MAX		0x200
>> >> > +
>> >> > +#define SVE_VL_MIN		(SVE_VQ_MIN * 0x10)
>> >> > +#define SVE_VL_MAX		(SVE_VQ_MAX * 0x10)
>> >> > +
>> >> > +#define SVE_NUM_ZREGS		32
>> >> > +#define SVE_NUM_PREGS		16
>> >> > +
>> >> > +#define sve_vl_valid(vl) \
>> >> > +	((vl) % 0x10 == 0 && (vl) >= SVE_VL_MIN && (vl) <= SVE_VL_MAX)
>> >> > +#define sve_vq_from_vl(vl)	((vl) / 0x10)
>> >> > +#define sve_vl_from_vq(vq)	((vq) * 0x10)
>> >>
>> >> I got a little confused first time through over what VQ and VL where.
>> >> Maybe it would make sense to expand a little more from first principles?
>> >>
>> >>   /*
>> >>    * The SVE architecture defines vector registers as a multiple of 128
>> >>    * bit quadwords. The current architectural limit is 2048 bits (16
>> >>    * quadwords) but there is room for future expansion beyond that.
>> >>     */
>> >
>> > This comes up in several places and so I didn't want to comment it
>> > repeatedly everywhere.
>> >
>> > Instead, I wrote up something in section 2 (Vector length terminology)
>> > of Documentation/arm64/sve.txt -- see patch 25.  Can you take a look and
>> > see whether that's adequate?
>>
>> Ahh, I hadn't got to that yet. I'm unsure to the order the kernel likes
>> to put things but I like to put design documents at the front of the
>
> I don't have a strong opinion on that -- I had preferred not to add a
> document describing stuff that doesn't exist at the time of commit.
> I could commit a stub document at the start of the series, and then
> commit the real document later.
>
> Either way, it seemed overkill.
>
> Perhaps I should have drawn more attention to the documentation in the
> cover letter, and encouraged reviewers to look at it first.  My
> experience is that people don't often read cover letters...
>
> Now the series is posted, I'm minded to keep the order as-is, unless you
> think it's a big issue.
>
> Adding a reference to the document seems a reasonable thing to do,
> so I could add that.
>
>> patch queue as they are useful primers and saves you having to patch a:
>>
>> modified   arch/arm64/include/uapi/asm/sigcontext.h
>> @@ -132,19 +132,24 @@ struct sve_context {
>>  /*
>>   * The SVE architecture leaves space for future expansion of the
>>   * vector length beyond its initial architectural limit of 2048 bits
>> - * (16 quadwords).
>> + * (16 quadwords). See Documentation/arm64/sve.txt for a summary of
>> + * the terminology of Vector Quads (VQ) and Vector Lengths (VL).
>>   */
>> +
>> +#define SVE_VQ_BITS             128      /* 128 bits in one quadword */
>> +#define SVE_VQ_BYTES            (SVE_VQ_BITS / 8)
>> +
>
> I was trying to keep extraneous #defines to a minimum, since this is a
> uapi header, and people may depend on anything defined here.
>
> I think SVE_VQ_BYTES is reasonable to have, and this allows us to
> rewrite a few hard-coded 0x10s and 16s symbolically which is probably a
> good idea -- I'll add this.
>
> SVE_VQ_BITS looks redundant to me though.  It wouldn't be used for any
> purpose other than defining SVE_VQ_BYTES.

Yeah I was more concerned with getting rid of the magic 0x10's than
showing exactly how many bits something is.

>
>>  #define SVE_VQ_MIN		1
>>  #define SVE_VQ_MAX		0x200
>>
>> -#define SVE_VL_MIN		(SVE_VQ_MIN * 0x10)
>> -#define SVE_VL_MAX		(SVE_VQ_MAX * 0x10)
>> +#define SVE_VL_MIN		(SVE_VQ_MIN * SVE_VQ_BYTES)
>> +#define SVE_VL_MAX		(SVE_VQ_MAX * SVE_VQ_BYTES)
>>
>>  #define SVE_NUM_ZREGS		32
>>  #define SVE_NUM_PREGS		16
>>
>>  #define sve_vl_valid(vl) \
>> -	((vl) % 0x10 == 0 && (vl) >= SVE_VL_MIN && (vl) <= SVE_VL_MAX)
>> +	((vl) % SVE_VQ_BYTES == 0 && (vl) >= SVE_VL_MIN && (vl) <= SVE_VL_MAX)
>>  #define sve_vq_from_vl(vl)	((vl) / 0x10)
>>  #define sve_vl_from_vq(vq)	((vq) * 0x10)
>
> [...]
>
> Cheers
> ---Dave
