From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 14:10:28 +0000
Message-ID: <54EC8654.1060905@arm.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com> <20150224124710.GB21364@cbox>
 <54EC78D1.3030703@arm.com> <20150224134533.GM11603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D23CF4673E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 09:04:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TjvhogqhLHK8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 09:04:52 -0500 (EST)
Received: from usa-sjc-mx-foss1.foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 952BE46640
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 09:04:51 -0500 (EST)
In-Reply-To: <20150224134533.GM11603@redhat.com>
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

On 24/02/15 13:45, Richard W.M. Jones wrote:
> On Tue, Feb 24, 2015 at 01:12:49PM +0000, Marc Zyngier wrote:
>> Here's my theory: userspace is accessing something it should never
>> access (outside of RAM, basically), and doing so via a kernel interface.
>>
>> Is this process accessing /dev/mem by any chance? dmidecode anyone?
> 
> Not as far as I know.  The userspace process is inserting modules.
> 
> Here is the userspace function which is most likely to be running:
> 
> https://github.com/libguestfs/supermin/blob/master/src/init.c#L292

Hmmm. That seems quite inoffensive indeed...

> Unfortunately because of lack of a full stack trace, I can't be sure
> exactly what system call is failing, but I'll probably add more debug
> to the userspace program later.
> 
> BTW this worked fine in 3.19.  It's started failing in 3.20/4.0.  It
> also works fine on x86.

Any chance you could find out whether that's a host or guest regression?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
