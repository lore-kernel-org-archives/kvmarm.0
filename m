From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Thu, 17 Nov 2016 17:47:51 +0000
Message-ID: <20161117174751.GD21742@leverpostej>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
 <20161116174544.GE11228@leverpostej>
 <20161117164541.uwmearukm3zcwahh@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 831F5401F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:48:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pTv8aJ9nSYGS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 12:47:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C67F401E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:47:59 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161117164541.uwmearukm3zcwahh@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 17, 2016 at 05:45:41PM +0100, Andrew Jones wrote:
> Hi Mark,
> 
> On Wed, Nov 16, 2016 at 05:45:44PM +0000, Mark Rutland wrote:
> > So I don't think we should try to distinguish ARMv8-A AArch32 from
> > ARMv7-A. We should test individual features, or if that's not possible,
> > group them in the same bucket.
> 
> Perhaps I was too quick to look for a general way to approach the first
> place I saw the need, which is
> 
>  check_cntr(read_pmccntr());
>  if (is_aarch64())
>      check_cntr(read_pmccntr64());
> 
> Is PMCCNTR the only "weird" difference?

Define "weird". ;)

I believe the extension of PMCCNTR to 64 bits is part of PMUv3. So you
should be able to check ID_DFR0.PerfMon == 0b0011. For overflow you'll
also need to configure PMCR.LC.

Thanks,
Mark.
