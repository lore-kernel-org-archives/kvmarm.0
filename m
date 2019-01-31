From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvmtool] arm: Allow command line for firmware
Date: Thu, 31 Jan 2019 14:07:15 +0100
Message-ID: <20190131130715.d7ctomqoxw5e262f@kamzik.brq.redhat.com>
References: <20190125154308.185131-1-andre.przywara@arm.com>
 <20190130182010.GE18558@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FE3F4A331
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:07:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0VMNZryXselS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 08:07:20 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55BAE4A32D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:07:20 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190130182010.GE18558@fuggles.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 30, 2019 at 06:20:10PM +0000, Will Deacon wrote:
> On Fri, Jan 25, 2019 at 03:43:08PM +0000, Andre Przywara wrote:
> > When loading a firmware instead of a kernel, we can still pass on any
> > *user-provided* command line, as /chosen/bootargs is a generic device tree
> > feature. We just need to make sure to not pass our mangled-for-Linux
> > version.
> > 
> > This allows to run "firmware" images which make use of a command line,
> > still are not Linux kernels, like kvm-unit-tests.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> > Hi Will,
> > 
> > this goes on top of Julien's firmware series (which did not yet appear
> > on kernel.org?)
> > This fixes an issue with some kvm-unit-tests support. [1]
> 
> Does kvm-unit-tests break if we pass the modified command line? I'm wary of
> passing something different depending on whether the payload is firmware or
> kernel, because there's a pretty fine line between the two (and the firmware
> may even just forward the thing on to the kernel it loads).
>

kvm-unit-tests assumes the user or unit test run scripts completely
control the kernel command line. The kernel command line is then
turned into the command line of the test's main() function, plus the
addition of the program name at argv[0]. The unit tests then parse
these command line parameters to determine what to do when testing.
If additional options are passed we need to teach the tests to ignore
them, and there's also risk that something passed in might accidentally
match a unit test parameter.

Thanks,
drew
