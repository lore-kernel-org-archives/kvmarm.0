From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 4/4] arm: pmu: Add CPI
 checking
Date: Thu, 1 Dec 2016 14:47:54 +0100
Message-ID: <20161201134754.w6ybf5e3dm24miip@kamzik.brq.redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-5-git-send-email-wei@redhat.com>
 <20161201092620.hvyndkroiauscxaa@kamzik.brq.redhat.com>
 <369fa1e8-952c-911a-d9f8-ea199405f32f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <369fa1e8-952c-911a-d9f8-ea199405f32f@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Wei Huang <wei@redhat.com>, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, cov@codeaurora.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 01, 2016 at 10:19:13AM +0000, Andre Przywara wrote:
> Hi Drew,
> 
> actually unrelated to this actual patch, but since you mentioned it:
> 
> > As we work out how best to handle tcg-only tests in order to get Alex
> > Bennee's MTTCG tests merged, we'll probably revisit this file,
> 
> So when I was experimenting with kvmtool, I realized that some tests
> would need to be QEMU only. Also I was tempted to try some tests either
> on bare metal machines or in a Fast Model.
> So I wonder if we should have some constraints or tags on the tests, so
> that a certain backend can filter on this and skip if it's not capable?

So far we've been using unittests.cfg flags for filtering, but we could
also teach configure how to set up the build for only certain tests, i.e.
new config options and makefile targets could take use further. The
unittests.cfg file could be split into multiple cfg files as well,
teaching run_tests.sh how to select the right one.

> 
> Just wanted to mention this so that we can use this refactoring
> opportunity to come up with something more generic than just a boolean
> TGC vs. KVM.
> Maybe we should introduce the notion of a "test backend"? That could be
> QEMU/KVM and TCG for now, but later extended to cover kvmtool and
>

So the $TEST_DIR/run (e.g. arm/run) script is currently qemu focused,
and is learning how to deal with both KVM and TCG. We haven't been
trying to keep qemu knowledge in that one file, but we could probably
do it, i.e. rename it to run-qemu and make sure all common script
files are kvm userspace agnostic. I don't think that should be too
difficult. We'll likely need more build config options for this though
too, as load addresses, etc. may change.

> probably other hypervisors like Xen as well.

Also doable once we isolate the hypervisor userspace specifics from
everything else. Same goes for getting tests to run on bare-metal,
launched from the grub prompt or UEFI. But, eventually people will
be confused with the project's name *kvm*-unit-tests :-)

Thanks,
drew
