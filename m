From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v3 0/2] Support micro operation measurement on arm64
Date: Thu, 18 Jan 2018 11:45:59 +0300
Message-ID: <20180118084559.f22ffb7uz7zto73y@yury-thinkpad>
References: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, drjones@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 17, 2018 at 04:46:34PM -0500, Shih-Wei Li wrote:
> The patch provides support for quantifying the cost of micro level
> operations on arm64 hardware. The supported operations include hypercall,
> mmio accesses, EOI virtual interrupt, and IPI send. Measurements are
> currently obtained using timer counters. Further modifications in KVM
> will be required to support timestamping using cycle counters, as KVM
> now disables accesses to the PMU counters from the VM. The micro test
> is currently non-default and can be used as a standalone test.
> 
> We iterate each of the tests for millions of times and output their
> average, minimum and maximum cost in timer counts. Instruction barriers
> were used before and after taking timestamps to avoid out-of-order
> execution or pipelining from skewing our measurements.

Again. This is standard procedure to access the timer counter, not
some special precaution. And this sentence is erroneous because you 
flush pipeline only before. Please delete last sentence if you'll
send v4.

> We currently
> skip the test if its cost is smaller than a timer tick for 1000 times.
> 
> To improve precision in the measurements, one should consider pinning
> each VCPU to a specific physical CPU (PCPU) and ensure no other task
> could run on that PCPU to skew the results. This can be achieved by
> enabling QMP server in the QEMU command in unittest.cfg for micro test,
> allowing a client program to get the thread_id for each VCPU thread
> from the QMP server. Based on the information, the client program can
> then pin the corresponding VCPUs to dedicated PCPUs and isolate
> interrupts and tasks from those PCPUs.
> 
> The patch has been tested on arm64 hardware including AMD Seattle and
> ThunderX2, which has GICv2 and GICv3 respectively.

Could you please attach test outputs? I'm especially interested in
testing Christoffer's VHE series to compare your test with mine.

> Changes since v2:
>   - Rebased atop of 4a671159.
>   - Make microtest nondefault.
>   - Output the cost in microseconds.
>   - Added fail safe option to skip the test if the cost is consistently
>     smaller than a timer tick.
>   - Fixed nits from comments in v2.
> 
> Shih-Wei Li (2):
>   arm/arm64: add GICD_IIDR definition
>   arm64: add micro test
> 
>  arm/Makefile.common |   1 +
>  arm/micro-test.c    | 252 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |   7 ++
>  lib/arm/asm/gic.h   |   1 +
>  4 files changed, 261 insertions(+)
>  create mode 100644 arm/micro-test.c
> 
> -- 
> 1.9.1
> 
