From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [Question] Linux 3.10 supporting AArch64 KVM
Date: Sun, 13 Mar 2016 19:18:52 +0100
Message-ID: <20160313181852.GB15988@cbox>
References: <CAG=tD+-ChHd4c+f0Y8PGcJUpb32nWSv34yfNDwY3JEU7AV+KQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBFFE40FA7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2016 14:18:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dLXo0rfD7fd8 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Mar 2016 14:18:22 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A52C540FA2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2016 14:18:22 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id p65so76174222wmp.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2016 11:18:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAG=tD+-ChHd4c+f0Y8PGcJUpb32nWSv34yfNDwY3JEU7AV+KQg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Fernando Endo <fernando.endo2@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 12, 2016 at 12:22:17PM +0100, Fernando Endo wrote:
> Hello,
> 
> I'd like to know what kernel versions KVM is known to work for AArch64.
> More specifically, if the Linux 3.10 of the Nvidia Tegra TX1 could support
> KVM.
> 
> The released 3.10 kernel does not have the KVM flags enabled, so I suspect
> that this version does not actually support KVM for AArch64.

I believe KVM for AArch64 was merged in 3.9, but it was a very early
version of the code, so I wouldn't recommend basing anything off that.

You could look at the backports for LSK 3.10
(https://git.linaro.org/?p=kernel/linux-linaro-stable.git;a=shortlog;h=refs/heads/linux-linaro-lsk-v3.10)
but I can't make any promises of the quality of that code.

Does the Tegra TX1 board you have even boot Linux in EL2 or haven an
open bootloader?  If not, I would expect this to be your biggest
troubles.

-Christoffer
