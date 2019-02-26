From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 05/26] KVM: arm64: Add missing #include of
 <linux/bitmap.h> to kvm_host.h
Date: Tue, 26 Feb 2019 12:40:18 +0000
Message-ID: <20190226124018.GC17422@lakrids.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-6-git-send-email-Dave.Martin@arm.com>
 <20190220152349.GE4763@lakrids.cambridge.arm.com>
 <20190226120616.GG3567@e103592.cambridge.arm.com>
 <20190226123145.GB17422@lakrids.cambridge.arm.com>
 <20190226123320.GW3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190226123320.GW3567@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 26, 2019 at 12:33:22PM +0000, Dave Martin wrote:
> On Tue, Feb 26, 2019 at 12:31:45PM +0000, Mark Rutland wrote:
> > On Tue, Feb 26, 2019 at 12:06:16PM +0000, Dave Martin wrote:
> > > On Wed, Feb 20, 2019 at 03:23:50PM +0000, Mark Rutland wrote:
> 
> [...]
> 
> > > > #include <asm/barrier.h>
> > > 
> > > [...]
> > > 
> > > > #include <linux/jump_label.h>
> > > > #include <linux/percpu.h>
> > > 
> > > Done for those three.
> > 
> > Great.
> > 
> > > > #include <linux/thread_info.h>
> > > 
> > > Since commit e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to
> > > reduce guest/host thrashing", we do have <asm/thread_info.h>.
> > > 
> > > Since this header is not generic, this seems reasonable.  Is there
> > > something from <linux/thread_info.h> used here that I'm missing?
> > 
> > I think I just confused myself; <asm/thread_info.h> seems sufficient.
> 
> OK, I shan't worry about that one, then.

Cool.

FWIW, feel free to add:

Acked-by: Mark Rutland <mark.rutland@arm.com>

... to that fixed-up commmit.

Thanks,
Mark.
