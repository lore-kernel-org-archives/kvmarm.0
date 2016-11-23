From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v11 0/3] ARM PMU tests
Date: Wed, 23 Nov 2016 18:18:25 +0100
Message-ID: <20161123171825.eqvpsx4sxdrbovez@kamzik.brq.redhat.com>
References: <1479839354-22061-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E34A9404AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 12:17:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dlVaGsnVaUEP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 12:17:50 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E772B40428
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 12:17:49 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1479839354-22061-1-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 22, 2016 at 12:29:11PM -0600, Wei Huang wrote:
> Changes from v10:
> * Change the name of loop test function to precise_instrs_loop()
> * Minor comment fixes to measure_instrs() and to explain isb() in loop funcs 
> 
> Note:
> 1) Current KVM code has bugs in handling PMCCFILTR write. A fix (see
> below) is required for this unit testing code to work correctly under
> KVM mode.
> https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022134.html.
> 
> Thanks,
> -Wei
> 
> Christopher Covington (3):
>   arm: Add PMU test
>   arm: pmu: Check cycle count increases
>   arm: pmu: Add CPI checking
> 
>  arm/Makefile.common |   3 +-
>  arm/pmu.c           | 351 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |  19 +++
>  3 files changed, 372 insertions(+), 1 deletion(-)
>  create mode 100644 arm/pmu.c
> 
> -- 
> 1.8.3.1
>

I'm pretty happy with this series. Andre has good suggestions though.
If you send a v12 soon, and nobody complains about my v7 gic series,
then I'll group this with the gic series into a single PULL request
for Radim and Paolo.

Thanks,
drew
