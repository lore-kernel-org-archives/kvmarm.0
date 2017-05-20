From: Christoffer Dall <cdall@linaro.org>
Subject: Re: Looking a bootloader code on Armv8a cpu
Date: Sat, 20 May 2017 10:43:21 +0200
Message-ID: <20170520084321.GA6319@cbox>
References: <CAPB=Z-rn_VuWosp098cKrtEAwRuqD=1YhjhRJDfYfVbDcXqTSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C97E840BC4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 May 2017 04:40:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RDFNAczouD+F for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 May 2017 04:40:01 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53F6840B8C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 May 2017 04:40:01 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id 123so1113574wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 May 2017 01:43:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-rn_VuWosp098cKrtEAwRuqD=1YhjhRJDfYfVbDcXqTSg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Raz <raziebe@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 19, 2017 at 09:30:12AM +0000, Raz wrote:
> Hey
> 
> I want to run a hypervisor on an Android smart phone. Where can I find a
> modified boot loader that can boot kvm on an Armv8a processor ?
> 

I am not aware of any phone-like hardware that lets you replace the boot
loader and load a custom kernel booted in EL2.

Thanks,
-Christoffer
