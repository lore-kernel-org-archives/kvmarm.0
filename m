From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Implement branch predictor hardening for Falkor
Date: Tue, 9 Jan 2018 09:41:46 +0000
Message-ID: <20180109094146.GB4297@arm.com>
References: <1515184139-23743-1-git-send-email-shankerd@codeaurora.org>
 <20180108170933.GU25869@arm.com> <20180108184446.GC13175@arm.com>
 <01fe1f41-ac45-0c19-a502-77b915c48fcf@codeaurora.org>
 <fa96f638-075e-10a0-d764-9c24b50fcf13@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B59ED49D27
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 04:37:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rtji2m6QSjsL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 04:37:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C5A406D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 04:37:03 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <fa96f638-075e-10a0-d764-9c24b50fcf13@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

You'll need to send a fixup patch. for-next/core is non-rebasing.

Will

On Mon, Jan 08, 2018 at 03:44:24PM -0600, Shanker Donthineni wrote:
> Hi Will/Catalin,
> 
> Please drop https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?h=kpti&id=79ad24ef6c260efa0614896b15e67f4829448e32 in which you've removed FALKOR MIDR change. I've posted
> v2 patch series including typo fix & FALKOR MIDR patch which is already available in upstream v4.15-rc7
> branch. Please merge v2 patch.
> 
> On 01/08/2018 01:10 PM, Shanker Donthineni wrote:
> > Hi Will,
> > 
> > On 01/08/2018 12:44 PM, Will Deacon wrote:
> >> On Mon, Jan 08, 2018 at 05:09:33PM +0000, Will Deacon wrote:
> >>> On Fri, Jan 05, 2018 at 02:28:59PM -0600, Shanker Donthineni wrote:
> >>>> Falkor is susceptible to branch predictor aliasing and can
> >>>> theoretically be attacked by malicious code. This patch
> >>>> implements a mitigation for these attacks, preventing any
> >>>> malicious entries from affecting other victim contexts.
> >>>
> >>> Thanks, Shanker. I'll pick this up (fixing the typo pointed out by Drew).
> >>
> >> Note that MIDR_FALKOR doesn't exist in mainline, so I had to drop those
> >> changes too. See the kpti branch for details.
> >>
> > 
> > The FALKOR MIDR patch is already available in the upstream kernel v4.15-rc7
> >     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64?h=v4.15-rc7&id=c622cc013cece073722592cff1ac6643a33b1622
> > 
> > If you want I can resend the above patch in v2 series including typo fix.
> > 
> >> If you'd like anything else done here, please send additional patches to me
> >> and Catalin that we can apply on top of what we currently have. Note that
> >> I'm in the air tomorrow, so won't be picking up email.
> >>
> >> Cheers,
> >>
> >> Will
> >>
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >>
> > 
> 
> -- 
> Shanker Donthineni
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
