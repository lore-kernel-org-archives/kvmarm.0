From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 01/23] arm64: alternatives: Add dynamic patching feature
Date: Wed, 7 Mar 2018 18:09:25 +0000
Message-ID: <20180307180925.ageajlaeqwtt4c2m@armageddon.cambridge.arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180301155538.26860-2-marc.zyngier@arm.com>
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

On Thu, Mar 01, 2018 at 03:55:16PM +0000, Marc Zyngier wrote:
> We've so far relied on a patching infrastructure that only gave us
> a single alternative, without any way to provide a range of potential
> replacement instructions. For a single feature, this is an all or
> nothing thing.
> 
> It would be interesting to have a more flexible grained way of patching
> the kernel though, where we could dynamically tune the code that gets
> injected.
> 
> In order to achive this, let's introduce a new form of dynamic patching,
> assiciating a callback to a patching site. This callback gets source and
> target locations of the patching request, as well as the number of
> instructions to be patched.
> 
> Dynamic patching is declared with the new ALTERNATIVE_CB and alternative_cb
> directives:
> 
> 	asm volatile(ALTERNATIVE_CB("mov %0, #0\n", callback)
> 		     : "r" (v));
> or
> 	alternative_cb callback
> 		mov	x0, #0
> 	alternative_cb_end
> 
> where callback is the C function computing the alternative.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
