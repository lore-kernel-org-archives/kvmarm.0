From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 13:52:24 -0700
Message-ID: <CAGXu5jKCSFVhGSD5mGLiAo6-G+k24g2Y=9p8Kr2-SffAY=uEBQ@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
 <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
 <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
 <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
 <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com>
 <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com>
 <alpine.LFD.2.20.1704241249350.32200@eddie.linux-mips.org>
 <CAK8P3a03BTEBgz87k_dhJuqzOYQm_S5FFDrFgcBAE5FCH-e=dQ@mail.gmail.com>
 <alpine.LFD.2.20.1704241908260.32200@eddie.linux-mips.org> <CAK8P3a0HQUqtL=9pgPEreQJaA0AksiR06B4oAwvbYnJeA-2i7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0HQUqtL=9pgPEreQJaA0AksiR06B4oAwvbYnJeA-2i7w@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 24, 2017 at 1:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> How about this approach then:
>
> - To keep it simple, we update the README.rst to say that a minimum
>   gcc-4.3 is required, while recommending gcc-4.9 for all architectures
> - Support for gcc-4.0 and earlier gets removed from linux/compiler.h,
>   and instead we add a summary of what I found, explaining that
>   gcc-4.1 has active users on a few architectures.
> - We make the Makefile show a warning once during compilation for
>   gcc earlier than 4.3.

This sounds good to me!

-Kees

-- 
Kees Cook
Pixel Security
