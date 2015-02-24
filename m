From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 21:57:23 +0900
Message-ID: <CAFEAcA-MV5qRQ+e8AeuSW6Uma3VryFV6vhWUubCKtTx0EGN=nA@mail.gmail.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D951346694
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:52:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BAewysv5rWXu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 07:52:03 -0500 (EST)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
 [209.85.217.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0AB34665A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:52:02 -0500 (EST)
Received: by lbjb6 with SMTP id b6so24727231lbj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 04:57:43 -0800 (PST)
In-Reply-To: <20150224122925.GL11603@redhat.com>
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

On 24 February 2015 at 21:29, Richard W.M. Jones <rjones@redhat.com> wrote:
> On Tue, Feb 24, 2015 at 09:15:18PM +0900, Peter Maydell wrote:
>> Complex insns are things like load-multiple (there's a complete
>> list in the ARM ARM somewhere). Generally this indicates a guest
>> bug because you really shouldn't be accessing devices with
>> weird instructions like that (and you shouldn't be accessing
>> unmapped memory at all).
>
> I'm not super-familiar with the aarch64 instruction set, but
> according to qemu the instruction is:
>
> b8004403        str     w3, [x0],#4
>
> (in __copy_to_user).  My interpretation is this is storing the
> lower 32 bits of x3 into the storage pointed to by x0 (+ 4 bytes?)

This syntax is post-indexed register writeback, ie
"write lower 32 bits of x3 into the storage pointed to by x0,
and then increment x0 by 4".

> Is that one of the complicated ones?

Yes. Writeback is one of the "complex" cases not handled by
syndrome information alone.

As Christoffer says, I'm not sure why we're getting a stage
2 abort on this __copy_to_user: the target of a __copy_to_user
ought to either be guest RAM or something unmapped in stage
1, I would have thought...

-- PMM
