From: Eugene Bagdasaryan <eb693@cornell.edu>
Subject: RE: development guide for installing KVMARM kernel
Date: Thu, 6 Oct 2016 18:54:55 +0000
Message-ID: <CY1PR0401MB16290C3826BFA5ED46E3F81BEEC70@CY1PR0401MB1629.namprd04.prod.outlook.com>
References: <CY1PR0401MB1629013D592E886EF2332C80EEC50@CY1PR0401MB1629.namprd04.prod.outlook.com>
 <8a3d33a861d6dc90ef2da82ad3f1950c@www.loen.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 000AD49B55
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2016 14:45:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5cQ89cOzMNnX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Oct 2016 14:45:17 -0400 (EDT)
Received: from limerock03.mail.cornell.edu (limerock03.mail.cornell.edu
 [128.84.13.243])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F4E49B54
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2016 14:45:17 -0400 (EDT)
In-Reply-To: <8a3d33a861d6dc90ef2da82ad3f1950c@www.loen.fr>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <maz@misterjones.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hey Marc

I basically want to try and install OpenStack on RPi, which I guess is possible.
(1) For the 64-bit arm OS, what would you suggest? 


Thank you,
Eugene

-----Original Message-----
From: Marc Zyngier [mailto:maz@misterjones.org] 
Sent: Wednesday, October 5, 2016 12:38 PM
To: kvmarm@lists.cs.columbia.edu; Eugene Bagdasaryan <eb693@cornell.edu>
Subject: Re: development guide for installing KVMARM kernel

Hi Eugene,

On 2016-10-04 19:13, Eugene Bagdasaryan wrote:
> Hey guys
>
> I am trying to install KVMARM kernel on my RPi3, I have found a link 
> to Dev guide 
> (http://www.virtualopensystems.com/en/solutions/guides/kvm-on-arm/
> [1]) the guide seems a bit outdated, since it links to git repo 
> https://github.com/virtualopensystems/linux-kvm-arm [2] that has the 
> latest commit dated back to 2014.

This guide is indeed very much outdated, and is not really helpful in your case.

> Can you please point me to the correct way to install this on 
> RaspbianOS (4.4.11-v7+)

On decent hardware, and with a non broken bootloader, KVM works out of the box (you just have to enable it in the kernel configuration).

Unfortunately, you have at least three issues to solve here:
(1) You're running an old 32bit kernel on 64bit HW
(2) Your bootloader probably enters the kernel in SVC instead of HYP
(3) Your HW lacks some of the  basic requirements to enable virtualization on ARM

(1) can be solved by running a mainline 64bit kernel. You will also need a 64bit userspace (you're currently running ARMv6 code...)
(2) should be solved by using a mainline u-boot, I believe.
(3) is currently worked on, but will require both kernel and qemu patches. It will also be quite slow.

Of course, mainline probably lacks full support of the RPi3 HW. I guess you have to evaluate whether you can switch (1) and (2) before even thinking of (3).

Hope this helps,

         M.
--
Who you jivin' with that Cosmik Debris?
