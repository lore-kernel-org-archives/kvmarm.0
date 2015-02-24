From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 21:15:18 +0900
Message-ID: <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
References: <20150224115935.GA26241@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 159344660F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:10:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ej87aOdwbjip for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 07:10:04 -0500 (EST)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13C63465AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:09:58 -0500 (EST)
Received: by lbvp9 with SMTP id p9so24511438lbv.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 04:15:38 -0800 (PST)
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 February 2015 at 20:59, Richard W.M. Jones <rjones@redhat.com> wrote:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1194366
>
> Has anyone seen this KVM error?  Or have suggestions how to debug it
> further?
>
>   kvm [2028]: load/store instruction decoding not implemented

This is a fairly common thing to run into and google is bound
to have references to past discussions. What has happened here
is that the guest has attempted a "complex" load/store instruction
to an area of RAM which is not mapped (ie not guest RAM).
For this class of instructions the hardware doesn't provide
syndrome information to allow us to figure out the address/size
etc of the access, so we would have to actually decode the
offending instruction and emulate it; this emulation isn't
implemented.

Complex insns are things like load-multiple (there's a complete
list in the ARM ARM somewhere). Generally this indicates a guest
bug because you really shouldn't be accessing devices with
weird instructions like that (and you shouldn't be accessing
unmapped memory at all).

At some point we might actually implement the decoding,
which will probably just mean your guest crashes inside
the VM rather than outside it.

> Qemu prints this before crashing:
>
>   error: kvm run failed Function not implemented
>   (followed by a register dump)

That's not a QEMU crash, it's QEMU exiting noisily. You can
use the register dump info in combination with the kernel
address map to find out exactly what was trying the access
that failed.

(Maybe we should add a line to that dump saying "this is not
a QEMU crash" because it's kinda misleading :-))

-- PMM
