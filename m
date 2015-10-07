From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: Virt MM DEBUG_LL support arm32
Date: Wed, 07 Oct 2015 09:40:20 -0700
Message-ID: <56154AF4.60206@samsung.com>
References: <5614683A.1010007@samsung.com>
 <CAFEAcA9ShOzMG7kk9hQRgizJ_u2=Y2B5v6SXi678M1RMZQcPVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB81E412EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 12:38:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8xNfYOeIwAAg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 12:38:26 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D23474126B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 12:38:26 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVU00A0XZNAMH20@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 07 Oct 2015 12:40:22 -0400 (EDT)
In-reply-to: <CAFEAcA9ShOzMG7kk9hQRgizJ_u2=Y2B5v6SXi678M1RMZQcPVA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 10/7/2015 12:07 AM, Peter Maydell wrote:
> On 7 October 2015 at 01:32, Mario Smarduch <m.smarduch@samsung.com> wrote:
>> Hi Peter,
>>    I noticed that icedcc, and 8250 don't work
>> with DEBUG_LL early debug print. And the kernel dies if
>> these are selected. Besides PL011 is there any other
>> serial devices that can be used for early debug with Virt MM?
>> Maybe some additional options are needed?
> 
> PL011 and semihosting are the obvious choices for early
> debug output. There's no 8250 in the virt board so that
> definitely isn't going to work. We don't currently implement
> the ICE DCC channel, though I think Edgar was considering
> connecting it up to a chardev backend.
> 
> Really though, I think the UART and semihosting should
> be enough for whatever the guest wants to do in the way
> of early debug. Why do you need more options?
> 
> thanks
> -- PMM
> 

No actually I was thinking of limiting choices to the ones that work for
Virt MM during kernel config. But thought that maybe others may be
supported through some options. Form me PL011 alone is enough.

- Mario
