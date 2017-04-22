From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Sat, 22 Apr 2017 04:10:08 +0100 (BST)
Message-ID: <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel> <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com> <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com> <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com> <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 21 Apr 2017, Kees Cook wrote:

> > The linux-4.2 x86 defconfig could still be built with gcc-4.0, but
> > later kernels have several minor problems with that, and
> > require at least gcc-4.3.
> >
> > If we are ok with this status quo, we could simply declare gcc-4.3
> > the absolute minimum version for the kernel, make gcc-4.9
> > the recommeded minimum version, and remove all workarounds
> > for gcc-4.2 or older.
> 
> I think starting with this would be a good first step. I'm not sure
> the best way to add "recommended minimum" to
> Documentation/process/changes.rst hmmm

 FWIW for some reasons (mainly the ability to avoid NPTL) I have stuck to 
GCC 4.1.2 with some MIPS configurations and I've had no issues with that 
compiler up to Linux 4.6.0, which is the last kernel version I have tried 
with that compiler so far.  I could check if anything has regressed since 
then I suppose.

  Maciej
