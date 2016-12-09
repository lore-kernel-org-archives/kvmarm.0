From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests v2 2/2] arm/pmu: don't run tcg tests
Date: Fri, 9 Dec 2016 18:45:50 +0100
Message-ID: <20161209174550.adauvogh3bbw25er@hawk.localdomain>
References: <20161208170549.8793-1-drjones@redhat.com>
 <20161208170549.8793-3-drjones@redhat.com>
 <dd08b360-a0e9-1d98-a703-c54adb50e4a2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CAB0403F8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 12:44:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LPNkfD20r+iO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2016 12:44:53 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B38E1401C7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 12:44:53 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <dd08b360-a0e9-1d98-a703-c54adb50e4a2@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 09, 2016 at 12:22:33PM -0500, Christopher Covington wrote:
> On 12/08/2016 12:05 PM, Andrew Jones wrote:
> > The TCG PMU is barely implemented for ARM and not at all implemented
> > for AArch64. Let's not bother running the TCG-only tests yet. We'll
> > likely move them to a new TCG-only unittests.cfg at some point before
> > re-enabling them too.
> 
> ID_AA64DFR0_EL1 isn't implemented in TCG, which should be first fixed
> and then tested. I think and hope we're in agreement on that.

It is implemented in TCG. The v8_idregs table has this

  { .name = "ID_AA64DFR0_EL1", .state = ARM_CP_STATE_AA64,
    .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 5, .opc2 = 0,
    .access = PL1_R, .type = ARM_CP_CONST,
    /* We mask out the PMUVer field, because we don't currently
     * implement the PMU. Not advertising it prevents the guest
     * from trying to use it and getting UNDEFs on registers we
     * don't implement.
     */
    .resetvalue = cpu->id_aa64dfr0 & ~0xf00 },

Notice the big comment stating PMUVer is zero on purpose.

> 
> However the cycle counter, PMCCNTR, is very much implemented on AArch64
> TCG. We've been successfully testing it for months.

It's working, yes, but not because the PMU is fully implemented. Any
guest that first probes (correctly) and then uses won't even try. The
only probe that succeeds (arm32 ID_DFR0) returns 2, which is invalid
for AArch64.

Since we're not a real kernel, but a unit testing framework, we can
bypass probes when appropriate and just test to see what happens.
I'm not sure it's worth it for testing TCG, which states it's not
implemented yet though. If this is something you need now, then
maybe we should add a command line option to this test that allows
the probe to be skipped.

Thanks,
drew

> 
> Thanks,
> Cov
> 
> -- 
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
> Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
> Aurora Forum, a Linux Foundation Collaborative Project.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
