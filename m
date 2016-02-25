From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Question] Can KVM run on Freescale IMX6 SABRE board?
Date: Thu, 25 Feb 2016 15:30:24 +0000
Message-ID: <CAFEAcA_Dt=swYzqmLMyok5SHWhfFP5Lsj42GnNg0tEg-JjGEyQ@mail.gmail.com>
References: <CAPSnSYoxmmDm--vuigyHb2xPr1GpSf22meO59kDQh1s2HFySiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A1A14852F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 10:23:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OnoYqhnqTa4F for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 10:23:55 -0500 (EST)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com
 [209.85.213.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8539148529
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 10:23:55 -0500 (EST)
Received: by mail-vk0-f52.google.com with SMTP id e6so50501471vkh.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 07:30:43 -0800 (PST)
In-Reply-To: <CAPSnSYoxmmDm--vuigyHb2xPr1GpSf22meO59kDQh1s2HFySiA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: xu mike <upennmike@gmail.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 25 February 2016 at 15:17, xu mike <upennmike@gmail.com> wrote:
> I'm a student from the University of Pennsylvania. I want to try KVM on ARM
> boards.
>
> I have a Freescale IMX6 board [1] which has ARM Cortex A9 processors.
> I'm wondering if KVM can run on the Freescale IMX6 board? or
> Can KVM run on any ARM board with ARM Cortex A9 processors?
>
> I noticed at [2] that " KVM/ARM is designed specifically to work on ARM
> processors with the virtualization extensions enabled to run unmodified
> guest operating systems."
> I'm wondering if this statement is still true?

Yes, it is. You need a CPU with the virtualization extensions,
and the A9 does not have them. You want (for instance) an A15
or an A7. There are cheap A7-based development boards out there,
for instance the CubieTruck (which is not very fast but can run
a mainline Linux kernel and KVM so is a reasonable getting-started
development platform).

thanks
-- PMM
