From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Fri, 16 Dec 2016 20:58:08 +0100
Message-ID: <3679707.TKdvBNIRe2@wuerfel>
References: <20161216105634.235457-1-arnd@arndb.de>
 <CAMuHMdUa4j8nxrW=fSJQZok3=mW-FWZWHR=cYS2R0gQUeGHgmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E70B840430
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 14:57:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MV+VkjZqcpOq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 14:57:03 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94C88406A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 14:57:02 -0500 (EST)
In-Reply-To: <CAMuHMdUa4j8nxrW=fSJQZok3=mW-FWZWHR=cYS2R0gQUeGHgmQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday, December 16, 2016 4:54:33 PM CET Geert Uytterhoeven wrote:
> Hi Arnd,
> 
> On Fri, Dec 16, 2016 at 11:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Specifically on ARM, going further makes things rather useless especially
> > for build testing: with gcc-4.2, we lose support for ARMv7, EABI, and
> > effectively ARMv6 (as it relies on EABI for building reliably). Also,
> > the number of false-positive build warnings is so high that it is useless
> > for finding actual bugs from the warnings.
> 
> If you start with that activity now, there's indeed a massive amount of
> warnings to look into.
> However, I've been build testing various configs with m68k-linux-gnu-gcc-4.1.2
> and looking at the compiler warnings for years, so I only have to look
> at new warnings.

What's the reason for sticking with gcc-4.1? Does this actually work better
for you than a more recent version, or is it just whatever you installed
when you started the build testing?

	Arnd
