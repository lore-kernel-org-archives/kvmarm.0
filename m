From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 18/23] arm64: KVM: Add epilogue branching to the
 vector code
Date: Thu, 8 Mar 2018 13:59:02 +0000
Message-ID: <20180308135902.olhvrydbcszjl3ap@armageddon.cambridge.arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-19-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180301155538.26860-19-marc.zyngier@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 01, 2018 at 03:55:33PM +0000, Marc Zyngier wrote:
> We are soon going to have to do some extra work in the BP hardening
> vector slots. Instead of doing that work in the vectors themselves
> (which would massively reduce the space available to deal with
> Spectre v2), let's branch to an epilogue where we can do "stuff".
> 
> This has a number of consequences:
> - We need some free registers, so we're spilling x0 and x1 on the
>   stack
> - In order to counterbalance this, we branch to the *second* instruction
>   in the vectors, avoiding the initial store that is already there
>   (or loading the registers back if we've branched to a panic vector)
> 
> This is all controlled by a new capability (ARM64_HARDEN_EL2_VECTORS)
> which doesn't get enabled yet.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

That's mostly kvm but anyway:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
