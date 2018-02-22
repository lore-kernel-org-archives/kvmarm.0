From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 26/40] KVM: arm/arm64: Prepare to handle deferred
 save/restore of SPSR_EL1
Date: Thu, 22 Feb 2018 14:49:04 +0100
Message-ID: <20180222134904.vwbdauxzdca53psq@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-27-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-27-christoffer.dall@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 15, 2018 at 10:03:18PM +0100, Christoffer Dall wrote:
> SPSR_EL1 is not used by a VHE host kernel and can be deferred, but we
> need to rework the accesses to this register to access the latest value
> depending on whether or not guest system registers are loaded on the CPU
> or only reside in memory.
> 
> The handling of accessing the various banked SPSRs for 32-bit VMs is a
> bit clunky, but this will be improved in following patches which will
> first prepare and subsequently implement deferred save/restore of the
> 32-bit registers, including the 32-bit SPSRs.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v2:
>      - New patch (deferred register handling has been reworked)
> 
>  arch/arm/include/asm/kvm_emulate.h   | 12 ++++++++++-
>  arch/arm/kvm/emulate.c               |  2 +-
>  arch/arm64/include/asm/kvm_emulate.h | 41 +++++++++++++++++++++++++++++++-----
>  arch/arm64/kvm/inject_fault.c        |  4 ++--
>  virt/kvm/arm/aarch32.c               |  2 +-
>  5 files changed, 51 insertions(+), 10 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
