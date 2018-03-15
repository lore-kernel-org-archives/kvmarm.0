From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v6 24/26] arm64: Make BP hardening slot counter available
Date: Thu, 15 Mar 2018 16:05:03 +0100
Message-ID: <20180315150503.2jliarn6vjnqkmj4@kamzik.brq.redhat.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-25-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180314165049.30105-25-marc.zyngier@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 14, 2018 at 04:50:47PM +0000, Marc Zyngier wrote:
> We're about to need to allocate hardening slots from other parts
> of the kernel (in order to support ARM64_HARDEN_EL2_VECTORS).
> 
> Turn the counter into an atomic_t and make it available to the
> rest of the kernel. Also add BP_HARDEN_EL2_SLOTS as the number of
> slots instead of the hardcoded 4...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/mmu.h   | 3 +++
>  arch/arm64/kernel/bpi.S        | 3 ++-
>  arch/arm64/kernel/cpu_errata.c | 9 ++++-----
>  3 files changed, 9 insertions(+), 6 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
