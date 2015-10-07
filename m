From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: Virt MM DEBUG_LL support arm32
Date: Wed, 7 Oct 2015 08:07:51 +0100
Message-ID: <CAFEAcA9ShOzMG7kk9hQRgizJ_u2=Y2B5v6SXi678M1RMZQcPVA@mail.gmail.com>
References: <5614683A.1010007@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D900412AF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 03:06:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h9EXU-uHi3rl for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 03:06:15 -0400 (EDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
 [209.85.213.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 403F5412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 03:06:15 -0400 (EDT)
Received: by vkfp126 with SMTP id p126so5227750vkf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Oct 2015 00:08:11 -0700 (PDT)
In-Reply-To: <5614683A.1010007@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Peter Maydell <peter.maydell@linaro.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 7 October 2015 at 01:32, Mario Smarduch <m.smarduch@samsung.com> wrote:
> Hi Peter,
>    I noticed that icedcc, and 8250 don't work
> with DEBUG_LL early debug print. And the kernel dies if
> these are selected. Besides PL011 is there any other
> serial devices that can be used for early debug with Virt MM?
> Maybe some additional options are needed?

PL011 and semihosting are the obvious choices for early
debug output. There's no 8250 in the virt board so that
definitely isn't going to work. We don't currently implement
the ICE DCC channel, though I think Edgar was considering
connecting it up to a chardev backend.

Really though, I think the UART and semihosting should
be enough for whatever the guest wants to do in the way
of early debug. Why do you need more options?

thanks
-- PMM
