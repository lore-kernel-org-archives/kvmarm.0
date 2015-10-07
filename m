From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: Virt MM DEBUG_LL support arm32
Date: Wed, 7 Oct 2015 22:05:26 +0100
Message-ID: <CAFEAcA8RWhh8agbfAR8JARXU6BY7PyLt3Z9UPzEh7xvJsev7Ng@mail.gmail.com>
References: <5614683A.1010007@samsung.com>
 <CAFEAcA9ShOzMG7kk9hQRgizJ_u2=Y2B5v6SXi678M1RMZQcPVA@mail.gmail.com>
 <56154AF4.60206@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCC3941457
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 17:03:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qrAktwI1Gn8r for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 17:03:48 -0400 (EDT)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com
 [209.85.213.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B622D413E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 17:03:48 -0400 (EDT)
Received: by vkfp126 with SMTP id p126so19946083vkf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Oct 2015 14:05:46 -0700 (PDT)
In-Reply-To: <56154AF4.60206@samsung.com>
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

On 7 October 2015 at 17:40, Mario Smarduch <m.smarduch@samsung.com> wrote:
> On 10/7/2015 12:07 AM, Peter Maydell wrote:
>> On 7 October 2015 at 01:32, Mario Smarduch <m.smarduch@samsung.com> wrote:
>>> Hi Peter,
>>>    I noticed that icedcc, and 8250 don't work
>>> with DEBUG_LL early debug print. And the kernel dies if
>>> these are selected. Besides PL011 is there any other
>>> serial devices that can be used for early debug with Virt MM?
>>> Maybe some additional options are needed?
>>
>> PL011 and semihosting are the obvious choices for early
>> debug output. There's no 8250 in the virt board so that
>> definitely isn't going to work. We don't currently implement
>> the ICE DCC channel, though I think Edgar was considering
>> connecting it up to a chardev backend.
>>
>> Really though, I think the UART and semihosting should
>> be enough for whatever the guest wants to do in the way
>> of early debug. Why do you need more options?

> No actually I was thinking of limiting choices to the ones that work for
> Virt MM during kernel config. But thought that maybe others may be
> supported through some options. Form me PL011 alone is enough.

8250 I think is what kvmtool uses, which is why that is a
permitted option. Not sure who's implementing ICE DCC
(though as I say QEMU might eventually).

thanks
-- PMM
