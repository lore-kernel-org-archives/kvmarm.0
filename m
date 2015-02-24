From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 15:09:11 +0000
Message-ID: <20150224150911.GQ11603@redhat.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com> <20150224124710.GB21364@cbox>
 <54EC78D1.3030703@arm.com> <20150224134533.GM11603@redhat.com>
 <54EC8654.1060905@arm.com> <20150224143608.GO11603@redhat.com>
 <54EC8DE6.8000105@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9077D4677D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:03:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DwtjWJ1Sxalz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 10:03:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D68EC4673D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:03:35 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <54EC8DE6.8000105@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

> On 24/02/15 14:36, Richard W.M. Jones wrote:
> > I can probably bisect this given time, but I'm going to try putting
> > some debug into the userspace process to find out which system call
> > fails first.

Perhaps not surprisingly, it's the init_module syscall which causes
the failure, ie. this line of code:

  https://github.com/libguestfs/supermin/blob/master/src/init.c#L436

I've no idea why that code would call copy_to_user.  It should be
copying the other way ...

It also fails on the first call to init_module, so the fact that it's
loading crc32-arm64.ko may just be a coincidence.

There are no other userspace processes running, but just to be sure
that it's not some other process in the guest, I also added a sleep
before the call to init_module, but same result as above.

I also looked at the implementation of init_module in glibc, but
AFAICT init_module is a straight syscall and glibc is not involved.

I also looked to see if I was calling init_module correctly on aarch64
(in case it has a different # of arguments of something) but it's
called in the same way in the libkmod code, so I think we're OK.

Next up, I will have a go at bisecting the guest kernel.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
