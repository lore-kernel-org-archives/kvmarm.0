From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv7 0/3] ARM PMU tests
Date: Thu, 3 Nov 2016 12:01:33 +0100
Message-ID: <20161103110133.inwqphbihphjbtg5@kamzik.brq.redhat.com>
References: <1478125337-11770-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478125337-11770-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


echo $SUBJECT | s/PATCHv7/PATCH v7/  (otherwise busts my filters)

On Wed, Nov 02, 2016 at 05:22:14PM -0500, Wei Huang wrote:
> Changes from v6:
> * Add a new pmu testing for KVM mode in config file
> * Add additional init code, including setting PMCNTENSET and PMCCFILTR, 
>   before reading PMCCNTR. ARMv7 support is also provided
> * Add cycle counter init code for CPI testing
> * Fix pmu_data compilation issue (for gcc 4.8.5)
> * Commit comments were updated
> 
> NOTE:
> 1) Current KVM code has bugs in handling PMCCFILTR write. A fix (see
> below) is required for this unit testing code to work correctly under
> KVM mode.
> https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022134.html.
> 2) Because the code was changed, Drew's original reviewed-by needs to
> be acknowledged by him again.
>

So you guys will hate me for just now bringing it up, but I'd really
prefer we switch from the bitfields to bit defines. We should also
minimize the amount of functions that depend on asms, i.e. only one
function per sysreg should be enough. The rest can be done in C. Please
also make sure the tests run with both tcg and kvm. That may mean probing
something and then reporting a SKIP where a feature isn't implemented.

Thanks,
drew

