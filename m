From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Thu, 20 Apr 2017 12:52:18 -0700
Message-ID: <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de>
 <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8DBF40FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Apr 2017 15:49:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TkVJkO0rWWTF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Apr 2017 15:49:40 -0400 (EDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
 [209.85.223.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFA2240FAF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Apr 2017 15:49:39 -0400 (EDT)
Received: by mail-io0-f182.google.com with SMTP id r16so80839782ioi.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Apr 2017 12:52:21 -0700 (PDT)
In-Reply-To: <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
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
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 20, 2017 at 3:15 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sun, Apr 16, 2017 at 9:52 PM, Kees Cook <keescook@chromium.org> wrote:
>>>> The original gcc-4.3 release was in early 2008. If we decide to still
>>>> support that, we probably want the first 10 quirks in this series,
>>>> while gcc-4.6 (released in 2011) requires none of them.
>>
>> I'd be in support of raising the minimum to gcc 4.6. (I'd actually
>> prefer 4.7, just to avoid some 4.6 packaging issues, and for better
>> gcc plugin support.)
>>
>> I'm curious what gcc 4.6 binaries are common in the wild besides
>> old-stable Debian (unsupported in maybe a year from now?) and 12.04
>> Ubuntu (going fully unsupported in 2 weeks). It looks like 4.6 was
>> used only in Fedora 15 and 16 (both EOL).
>
> I think we are better off defining two versions: One that we know
> a lot of people care about, and we actively try to make that work
> well in all configurations (e.g. 4.6, 4.7 or 4.8), fixing all warnings
> we run into, and an older version that we try not to break
> intentionally (e.g. 3.4, 4.1 or 4.3) but that we only fix when
> someone actually runs into a problem they can't work around
> by upgrading to a more modern compiler.

For "working well everywhere" I feel like 4.8 is the better of those
three (I'd prefer 4.9). I think we should avoid 4.6 -- it seems not
widely used.

For an old compiler... yikes. 3.4 sounds insane to me. :)

-Kees

-- 
Kees Cook
Pixel Security
