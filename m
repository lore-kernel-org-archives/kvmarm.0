From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH kvm-unit-tests v2 2/2] arm/pmu: don't run tcg tests
Date: Fri, 9 Dec 2016 12:22:33 -0500
Message-ID: <dd08b360-a0e9-1d98-a703-c54adb50e4a2@codeaurora.org>
References: <20161208170549.8793-1-drjones@redhat.com>
 <20161208170549.8793-3-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E91C940423
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 12:21:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mp++T7aC05Kl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2016 12:21:34 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F34C640197
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 12:21:33 -0500 (EST)
In-Reply-To: <20161208170549.8793-3-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 12/08/2016 12:05 PM, Andrew Jones wrote:
> The TCG PMU is barely implemented for ARM and not at all implemented
> for AArch64. Let's not bother running the TCG-only tests yet. We'll
> likely move them to a new TCG-only unittests.cfg at some point before
> re-enabling them too.

ID_AA64DFR0_EL1 isn't implemented in TCG, which should be first fixed
and then tested. I think and hope we're in agreement on that.

However the cycle counter, PMCCNTR, is very much implemented on AArch64
TCG. We've been successfully testing it for months.

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
