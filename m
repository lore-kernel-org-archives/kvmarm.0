From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] arm64: kvm: use -fno-jump-tables with clang
Date: Wed, 23 May 2018 10:47:43 -0700
Message-ID: <CAKwvOd=fqk2bQSiPBsUmVSQLGUEGYSUev3iWvico6HOpYs5YJA@mail.gmail.com>
References: <20180518170202.11458-1-samitolvanen@google.com>
 <05d14ac7-0feb-63a3-e7ef-b8ca1ae2fd1d@arm.com> <CAKwvOdm1kYedukCq=g74AvqJHp6KC03oNoouQy2nkvfo4idoEw@mail.gmail.com>
 <8c7be44f-086d-65e3-9969-8182261ce82f@arm.com> <CAKwvOd=XZqg5=mkXZb-cxq3i_AGoJGAbmF=Fwc7Q98oi0tbN9g@mail.gmail.com>
 <3fd89842-86cd-ee01-0c2c-5438dd2d5f2a@arm.com> <CAKwvOdk+=JKcQP1ieLEkZftRGf-pqCTTzEuYvT_45YNMkEw_wA@mail.gmail.com>
 <86k1rzc4ba.wl-marc.zyngier@arm.com> <CAAeHK+z2LmMYasYtRTt2U=QF8Pe_i10RA3-SkLzGXXByZqLh1w@mail.gmail.com>
 <CAKwvOdmWg8o9yoZ+3dCwL8vYB8gzE+AatCbXENN-+Gge9Q6gtA@mail.gmail.com> <CAAeHK+wk0hSH6iQcsLzrpjvsGocev-UZ6=z95ysecdFnAcHVSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeHK+wk0hSH6iQcsLzrpjvsGocev-UZ6=z95ysecdFnAcHVSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: marc.zyngier@arm.com, Sami Tolvanen <samitolvanen@google.com>, christoffer.dall@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 4:54 AM Andrey Konovalov <andreyknvl@google.com>
wrote:
> On Tue, May 22, 2018 at 8:28 PM, Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> > On Fri, May 18, 2018 at 11:13 AM Marc Zyngier <marc.zyngier@arm.com>
wrote:
> >> > - you have checked that with a released version of the compiler, you
> >
> > On Tue, May 22, 2018 at 10:58 AM Andrey Konovalov <andreyknvl@google.com

> > wrote:
> >> Tested-by: Andrey Konovalov <andreyknvl@google.com>
> >
> > Hi Andrey,
> > Thank you very much for this report.  Can you confirm as well the
version
> > of Clang that you were using?

> I'm on 86852a40 ("[InstCombine] Calloc-ed strings optimizations").

> > If it's not a binary release (built from
> > source), would you be able to re-confirm with a released version?

> Sure. Which release should I try and how do I get it?

Maybe clang-6.0 as the latest release (though I suspect you may run into
the recently-fixed-in-clang-7.0 "S" constraint bug that you reported).

I've had luck on debian based distributions installing from:
http://apt.llvm.org/

(These can be added to your /etc/apt/sources.list, then a `sudo apt update`
and `sudo apt install clang-6.0`)

If you're not able to add remote repositories (some employers block this ;)
), then you can find releases for download for a few different platforms:
https://releases.llvm.org/

For example, a quick:
$ mkdir llvm-6.0
$ cd !$
$ wget
https://releases.llvm.org/6.0.0/clang+llvm-6.0.0-x86_64-linux-gnu-debian8.tar.xz
$ tar xvf clang+llvm-6.0.0-x86_64-linux-gnu-debian8.tar.xz
$ ./clang+llvm-6.0.0-x86_64-linux-gnu-debian8/bin/clang-6.0 -v
clang version 6.0.0 (tags/RELEASE_600/final)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: .../llvm-6.0/./clang+llvm-6.0.0-x86_64-linux-gnu-debian8/bin
Found candidate GCC installation: ...
Candidate multilib: .;@m64
Selected multilib: .;@m64

Seems to work.
-- 
Thanks,
~Nick Desaulniers
