Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD54C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 09:28:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 278E449F5F;
	Thu, 17 Mar 2022 05:28:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZHdZsNFdCWUw; Thu, 17 Mar 2022 05:28:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 221604AC78;
	Thu, 17 Mar 2022 05:28:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8BF149E17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:49:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BuTT75m03vl3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 14:49:38 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9339B49DF6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:49:38 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id d18so2538350plr.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 11:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=y7ERAKcifRzxT6vcVSjDSozSgypW/KEW+vG0ASHCMHY=;
 b=EzwZe3ti/2sTFi0gzWAE+otHNwPAgMXQlTrdW5phcUmxKkHY/mhUFb2IyXF9KVVy/D
 ZZScNEQ30YzZhGoDBcDZwia4z6A8qPXdZYDXWIe1+P7k6dicin06qMrNjt3UBPEGg0xg
 hXRUdafsQ4hecOzsNY8upgcQF/oTX1S+MFQdBAm5vGiFsmlgOef5nXj5Lih8CZJjNAC1
 8z2v38eH+liqupz+geO+Jhdb8o970vpMhLS4UkfDjB26oOyfng2nrCBZgaQQoVM80Uak
 B+d+V2FIZiDq0KBGNEgpnXziZu8VfjqhxX/NJyQgCCDiqwRrqIkL9BtI8MgIhQfcEk6b
 CmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=y7ERAKcifRzxT6vcVSjDSozSgypW/KEW+vG0ASHCMHY=;
 b=OoUiZHHkqaUTIHhJniLf5jWX1VOlALmLWfWnRIE435kf6tUScmy8nXdtYhcj4jc7ya
 W5Aos9CeJBTZ76FEyt2V+6hbfyqKgySDg+s0S+slHhmfmquOO4fW0Ns2u5wwodP2kR6U
 xoNEwEtK4D56bOI64RFmRRzlW7wVaGDZMarDWWlYVKY1KnFDwBmXSTgmwplYQa33z0VD
 Gzw5Gmu4eIaWJLCvOI0HFLy2zXWWQi2rV0UzZFPUCHuC+yIhc1XiaF5goHbdyUS5X+ai
 hYfoYDytbZBIA2nHkAE2F/Ma9aOB5a7ZBFHtIYzFqEXTiKj5hZ+uV/vp0mAUCW0nHiDk
 IQgQ==
X-Gm-Message-State: AOAM531yp3DbjjwrfpNfDKhc/bsNCuBVhBZY2cEbpJv+242/64/SeGxY
 6ilpNEOjWMSTvkCkkcV6JOOwSYZDAye/Nb27u9kN
X-Google-Smtp-Source: ABdhPJxwp/pkpCQtHo7tVh5Dg1xcTc9fNxHdNL+EZXfY9wfYvIVklmRmDUPiJum14n0p7tN0MasdTRHMWSpkdNRp57Q=
X-Received: by 2002:a17:903:32c8:b0:150:1189:c862 with SMTP id
 i8-20020a17090332c800b001501189c862mr878311plr.134.1647456577401; Wed, 16 Mar
 2022 11:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220316060214.2200695-1-morbo@google.com>
 <20220316074356.n7e5lzrmnal2dcgu@gator>
 <334cc93e-9843-daa9-5846-394c199e294f@redhat.com>
In-Reply-To: <334cc93e-9843-daa9-5846-394c199e294f@redhat.com>
From: Bill Wendling <morbo@google.com>
Date: Wed, 16 Mar 2022 11:49:26 -0700
Message-ID: <CAGG=3QWOZVtXfyR4Lu8qBS-ASBFeMaLGo1ANXTxi7gPoLbA2Ag@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
To: Thomas Huth <thuth@redhat.com>
X-Mailman-Approved-At: Thu, 17 Mar 2022 05:28:50 -0400
Cc: Laurent Vivier <lvivier@redhat.com>,
 linux-s390 <linux-s390@vger.kernel.org>, frankja@linux.ibm.com,
 kvm list <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 kvm-ppc@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, imbrenda@linux.ibm.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Mar 16, 2022 at 12:53 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 16/03/2022 08.43, Andrew Jones wrote:
> > On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
> >> Clang warns about using a bitwise '|' with boolean operands. This seems
> >> to be due to a small typo.
> >>
> >>    lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >>            if (can_assume(LIBFDT_ORDER) |
> >>
> >> Using '||' removes this warnings.
> >>
> >> Signed-off-by: Bill Wendling <morbo@google.com>
> >> ---
> >>   lib/libfdt/fdt_rw.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
> >> index 13854253ff86..3320e5559cac 100644
> >> --- a/lib/libfdt/fdt_rw.c
> >> +++ b/lib/libfdt/fdt_rw.c
> >> @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
> >>                      return struct_size;
> >>      }
> >>
> >> -    if (can_assume(LIBFDT_ORDER) |
> >> +    if (can_assume(LIBFDT_ORDER) ||
> >>          !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
> >>              /* no further work necessary */
> >>              err = fdt_move(fdt, buf, bufsize);
> >> --
> >> 2.35.1.723.g4982287a31-goog
> >>
> >
> > This is fixed in libfdt upstream with commit 7be250b4 ("libfdt:
> > Correct condition for reordering blocks"), which is in v1.6.1.
> > We can either take this patch as a backport of 7be250b4 or we
> > can rebase all of our libfdt to v1.6.1. Based on the number of
> > fixes in v1.6.1, which appear to be mostly for compiling with
> > later compilers, I'm in favor of rebasing.
>
> +1 for updating to v1.6.1 completely.
>
Also +1. :-) Thank you!

-bw

> > Actually, we can also use this opportunity to [re]visit the
> > idea of changing libfdt to a git submodule. I'd like to hear
> > opinions on that.
>
> I'm always a little bit torn when it comes to this question. Sure, git
> submodules maybe make the update easier ... but they are a real pita when
> you're working with remote machines that might not have direct connection to
> the internet. For example, I'm used to rsync my sources to the non-x86
> machines, and if you forget to update the submodule to the right state
> before the sync, you've just lost. So from my side, it's a preference for
> continuing without submodules (but I won't insist if everybody else wants to
> have them instead).
>
>   Thomas
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
