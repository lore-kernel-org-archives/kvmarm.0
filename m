From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 07/27] arm64/sve: Check SVE virtualisability
Date: Fri, 5 Apr 2019 10:35:36 +0100
Message-ID: <20190405093536.GJ3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-8-git-send-email-Dave.Martin@arm.com>
 <20190404212104.qhtklabh7mzwapje@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 615A64A3B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 05:35:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iXngqpCFsDWw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 05:35:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B99D4A332
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 05:35:42 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404212104.qhtklabh7mzwapje@kamzik.brq.redhat.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 11:21:04PM +0200, Andrew Jones wrote:
> On Fri, Mar 29, 2019 at 01:00:32PM +0000, Dave Martin wrote:
> > Due to the way the effective SVE vector length is controlled and
> > trapped at different exception levels, certain mismatches in the
> > sets of vector lengths supported by different physical CPUs in the
> > system may prevent straightforward virtualisation of SVE at parity
> > with the host.
> > 
> > This patch analyses the extent to which SVE can be virtualised
> > safely without interfering with migration of vcpus between physical
> > CPUs, and rejects late secondary CPUs that would erode the
> > situation further.
> > 
> > It is left up to KVM to decide what to do with this information.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > 
> > ---
> > 
> > QUESTION: The final structure of this code makes it quite natural to
> > clamp the vector length for KVM guests to the maximum value supportable
> > across all CPUs; such a value is guaranteed to exist, but may be
> > surprisingly small on a given hardware platform.
> > 
> > Should we be stricter and actually refuse to support KVM at all on such
> > hardware?  This may help to force people to fix Linux (or the
> > architecture) if/when this issue comes up.
> 
> Blocking KVM would be too harsh, since the users of the host may not
> care about guests with SVE, but still care about guests.
> 
> > 
> > For now, I stick with pr_warn() and make do with a limited SVE vector
> > length for guests.
> 
> I think that's probably the best we can do.

Agreed.  Since it fell out quite nicely this way in the code, this was
my preferred option.

[...]

> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks

---Dave
