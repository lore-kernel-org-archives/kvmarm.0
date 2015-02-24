From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 13:16:05 +0100
Message-ID: <20150224121605.GA21364@cbox>
References: <20150224115935.GA26241@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AE9B466D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:10:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A4PWHLX6hl4V for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 07:10:00 -0500 (EST)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AD014659A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:09:59 -0500 (EST)
Received: by labgd6 with SMTP id gd6so25131896lab.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 04:15:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20150224115935.GA26241@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Rich,

On Tue, Feb 24, 2015 at 11:59:35AM +0000, Richard W.M. Jones wrote:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1194366
> 
> Has anyone seen this KVM error?  Or have suggestions how to debug it
> further?
> 
>   kvm [2028]: load/store instruction decoding not implemented

This typically means either (a) you're running an ancient 32-bit guest
or (b) your icache/dcache is poluted and you're executing the wrong
instructions.

> 
> Qemu prints this before crashing:
> 
>   error: kvm run failed Function not implemented
>   (followed by a register dump)
> 
> It happens precisely when the guest loads the crc32-arm64.ko module.
> 
> Both the guest and host kernel are 4.0.0-0.rc1.git0.1.fc23.aarch64
> 
Which hardware is this?  Which distro/rootfs?

Doing anything fancy like device passthrough etc.?  Can you share your
QEMU cmdline?

Thanks,
-Christoffer
