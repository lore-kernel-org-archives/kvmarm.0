From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Clang arm64 build is broken
Date: Fri, 20 Apr 2018 17:36:22 +0100
Message-ID: <8b3e95df-a429-2f84-565c-3caed8e30e28@arm.com>
References: <CAAeHK+wDMH_G=3UuGOda2t0g4TH4TmDAeyG-ydJwg9vmThd3eQ@mail.gmail.com>
 <c61336a2-7c66-ea48-3daa-e644403d7a6e@arm.com>
 <CAKwvOdnKuFuqoWKpVJqVa1u8A0z2+vQp9j7+TsNh9qz3Yitk-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdnKuFuqoWKpVJqVa1u8A0z2+vQp9j7+TsNh9qz3Yitk-Q@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 20/04/18 17:30, Nick Desaulniers wrote:
> On Fri, Apr 20, 2018 at 1:13 AM Marc Zyngier <marc.zyngier@arm.com> wrote:
>> Clang isn't
>> really supported to build the arm64 kernel anyway
> 
> Can you expand on this?  There are millions of arm64 devices shipping with
> Clang built Linux kernels.

How many of these devices run a full-featured mainline kernel?

Sure, Android is building the kernel with clang, but that's with a pile
of out of tree patches. At that point, I'm not sure we're talking about
the same arm64 kernel.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
