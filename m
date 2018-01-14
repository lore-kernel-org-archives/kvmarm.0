From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v6 11/16] firmware: arm_sdei: Add support for CPU and
 system power states
Date: Sun, 14 Jan 2018 12:20:37 +0000
Message-ID: <20180114122037.GA18073@red-moon>
References: <20180108153818.22743-1-james.morse@arm.com>
 <20180108153818.22743-12-james.morse@arm.com>
 <20180108172226.GC2530@red-moon>
 <20180113120031.5m6eykwzqnioyb33@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF04149D96
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Jan 2018 07:14:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ztv7PtoZLcJj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 14 Jan 2018 07:14:43 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2F540EA6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 Jan 2018 07:14:43 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180113120031.5m6eykwzqnioyb33@armageddon.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org, Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu, Loc Ho <lho@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 13, 2018 at 12:00:31PM +0000, Catalin Marinas wrote:
> On Mon, Jan 08, 2018 at 05:22:26PM +0000, Lorenzo Pieralisi wrote:
> > On Mon, Jan 08, 2018 at 03:38:13PM +0000, James Morse wrote:
> > 
> > [...]
> > 
> > > +/* When entering idle, mask/unmask events for this cpu */
> > 
> > Just mentioning (since I know you know), this notifier is called also
> > through syscore_ops so it is not just idle (CPUidle or Suspend-to-idle).
> > 
> > > +static int sdei_pm_notifier(struct notifier_block *nb, unsigned long action,
> > > +			    void *data)
> > > +{
> > > +	int rv;
> > > +
> > > +	switch (action) {
> > > +	case CPU_PM_ENTER:
> > > +		rv = sdei_mask_local_cpu();
> > > +		break;
> > > +	case CPU_PM_EXIT:
> > > +		rv = sdei_unmask_local_cpu();
> > 
> > You should handle CPU_PM_ENTER_FAILED here for correctness,
> > in case the notifier chain fails.
> 
> So, just to confirm, the CPU_PM_ENTER_FAILED case goes together with
> CPU_PM_EXIT so that we unmask the SDE again for the CPU.

Yes, that's correct (I do not think that's a problem with current
mainline but that ought to be handled correctly anyway).

Lorenzo
