From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 13:45:33 +0000
Message-ID: <20150224134533.GM11603@redhat.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com> <20150224124710.GB21364@cbox>
 <54EC78D1.3030703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1417146712
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 08:40:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VZbDFgi9eZwE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 08:40:04 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 275C846710
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 08:40:03 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <54EC78D1.3030703@arm.com>
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

On Tue, Feb 24, 2015 at 01:12:49PM +0000, Marc Zyngier wrote:
> Here's my theory: userspace is accessing something it should never
> access (outside of RAM, basically), and doing so via a kernel interface.
> 
> Is this process accessing /dev/mem by any chance? dmidecode anyone?

Not as far as I know.  The userspace process is inserting modules.

Here is the userspace function which is most likely to be running:

https://github.com/libguestfs/supermin/blob/master/src/init.c#L292

Unfortunately because of lack of a full stack trace, I can't be sure
exactly what system call is failing, but I'll probably add more debug
to the userspace program later.

BTW this worked fine in 3.19.  It's started failing in 3.20/4.0.  It
also works fine on x86.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
