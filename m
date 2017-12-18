From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Support micro operation measurement on
 arm64
Date: Mon, 18 Dec 2017 19:14:40 +0100
Message-ID: <20171218181440.yggldvw6lry6wsza@hawk.localdomain>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE4F49D5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 13:11:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yDMIg0o6yJsF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 13:11:00 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C97449D40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 13:11:00 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shih-Wei,

Thanks for doing this! Porting Christoffer's selftests to kvm-unit-tests
has been on the kvm-unit-tests' TODO list since it was first introduced.

On Fri, Dec 15, 2017 at 04:15:38PM -0500, Shih-Wei Li wrote:
> The patch provides support for quantifying the cost of micro level
> operations on arm64 hardware. The supported operations include hypercall,
> mmio accesses, EOI virtual interrupt, and IPI send. Measurements are
> currently obtained using timer counters. Further modifications in KVM
> will be required to support timestamping using cycle counters, as KVM
> now disables accesses to the PMU counters from the VM.

KVM only disables access when userspace tells it to, which it doesn't
do by default. Is there something else missing keeping the PMU counters
from being used?

> 
> We iterate each of the tests for millions of times and output their
> average, minimum and maximum cost in timer counts. Instruction barriers

Can we reduce the number of iterations and still get valid results? The
test takes so long that of all the platforms I tested it on timed out
before it completed, except seattle. The default timeout for kvm-unit-
tests is 90 seconds. I'd rather a unit test execute in much shorter time
than that too, in order to keep people encouraged to run them frequently.
If these tests must run a long time, then I think we should add them to
the nodefault group.

> were used before and after taking timestamps to avoid out-of-order
> execution or pipelining from skewing our measurements.
> 
> To improve precision in the measurements, one should consider pinning
> each VCPU to a specific physical CPU (PCPU) and ensure no other task
> could run on that PCPU to skew the results. This can be achieved by
> enabling QMP server in the QEMU command in unittest.cfg for micro test,
> allowing a client program to get the thread_id for each VCPU thread
> from the QMP server. Based on the information, the client program can
> then pin the corresponding VCPUs to dedicated PCPUs and isolate
> interrupts and tasks from those PCPUs.

To isolate the CPUs one would need to boot the host with the isolcpus
kernel command line option. Pinning the VCPUs is pretty easy though,
so we could provide a script that does that in kvm-unit-tests and then
always use it for this test. The script could also warn if we're
pinning to CPUs that haven't been isolated.

> 
> The patch has been tested on arm64 hardware including AMD Seattle and
> ThunderX2, which has GICv2 and GICv3 respectively.

I tried thunderx2, amberwing, mustang, and seattle. Only seattle
completed, the rest timed out.

Thanks,
drew

> 
> Shih-Wei Li (1):
>   arm64: add micro test
> 
>  arm/Makefile.common |   1 +
>  arm/micro-test.c    | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |   6 ++
>  3 files changed, 296 insertions(+)
>  create mode 100644 arm/micro-test.c
> 
> -- 
> 1.9.1
> 
> 
