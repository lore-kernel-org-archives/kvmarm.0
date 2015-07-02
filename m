From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: which phone cpu support the arm virtualization
Date: Thu, 2 Jul 2015 16:09:14 +0200
Message-ID: <20150702140914.GI11332@cbox>
References: <BLU181-W761FE3624E17C214EB50C7B8970@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A575777D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:58:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id npBzYP6fJPqD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:57:59 -0400 (EDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A4CD5777C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:57:58 -0400 (EDT)
Received: by lagh6 with SMTP id h6so61912635lag.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 07:09:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <BLU181-W761FE3624E17C214EB50C7B8970@phx.gbl>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: young jams <young.kvm.arm@outlook.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Thu, Jul 02, 2015 at 02:55:24AM +0000, young jams wrote:
> Hi all
> I want to try kvm arm, but i cannot find a board which supports arm hardware-assist visualization. I knows there are some boards like arndale supports it, but i cannot get it. So i am wondering if there are some phones which uses qualcomm or nivida's cpu also supports it.
> 
I think there are, but they are typically locked down at the bootloader
level so you can only boot them in EL1 and you have no way of getting
access to EL2, and therefore no virtualization.

The most easily available option are the CubieTruck boards.

-Christoffer
