From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv2] ARM64: KVM: use lm_alias() for kvm_ksym_ref()
Date: Fri, 25 May 2018 12:28:19 +0100
Message-ID: <20180525112818.x4ar6a3awnaxstf7@lakrids.cambridge.arm.com>
References: <20180510111347.32253-1-mark.rutland@arm.com>
 <20180525105010.qswcppfkybznmzka@lakrids.cambridge.arm.com>
 <1f54d71c-6ae1-732f-3ee0-99e38287a3b0@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1f54d71c-6ae1-732f-3ee0-99e38287a3b0@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 25, 2018 at 12:08:28PM +0100, Marc Zyngier wrote:
> On 25/05/18 11:50, Mark Rutland wrote:
> > On Thu, May 10, 2018 at 12:13:47PM +0100, Mark Rutland wrote:
> >> For historical reasons, we open-code lm_alias() in kvm_ksym_ref().
> >>
> >> Let's use lm_alias() to avoid duplication and make things clearer.
> >>
> >> As we have to pull this from <linux/mm.h> (which is not safe for
> >> inclusion in assembly), we may as well move the kvm_ksym_ref()
> >> definition into the existing !__ASSEMBLY__ block.
> >>
> >> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> >> Cc: Christoffer Dall <christoffer.dall@arm.com>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> Cc: kvmarm@lists.cs.columbia.edu
> >> ---
> >>  arch/arm64/include/asm/kvm_asm.h | 7 +++++--
> >>  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > Marc, Christoffer, are you happy to pick this up?
> 
> I've queued it some time ago (see kvmarm/queue), but failed to mention
> it on the list...

Ah, cheers!

I'll drop this from my list of things to poke. :)

Thanks,
Mark.
