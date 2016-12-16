From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Fri, 16 Dec 2016 16:54:33 +0100
Message-ID: <CAMuHMdUa4j8nxrW=fSJQZok3=mW-FWZWHR=cYS2R0gQUeGHgmQ@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C0440457
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 10:53:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b927tlePYTSF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 10:53:23 -0500 (EST)
Received: from mail-io0-f195.google.com (mail-io0-f195.google.com
 [209.85.223.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F71E40455
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 10:53:23 -0500 (EST)
Received: by mail-io0-f195.google.com with SMTP id p13so12351163ioi.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 07:54:34 -0800 (PST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,

On Fri, Dec 16, 2016 at 11:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> Specifically on ARM, going further makes things rather useless especially
> for build testing: with gcc-4.2, we lose support for ARMv7, EABI, and
> effectively ARMv6 (as it relies on EABI for building reliably). Also,
> the number of false-positive build warnings is so high that it is useless
> for finding actual bugs from the warnings.

If you start with that activity now, there's indeed a massive amount of
warnings to look into.
However, I've been build testing various configs with m68k-linux-gnu-gcc-4.1.2
and looking at the compiler warnings for years, so I only have to look
at new warnings.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
