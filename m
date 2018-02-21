From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 04/40] KVM: arm64: Rework hyp_panic for VHE and non-VHE
Date: Wed, 21 Feb 2018 18:32:44 +0100
Message-ID: <20180221173244.bszvzbs7whmr5p3x@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-5-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-5-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:02:56PM +0100, Christoffer Dall wrote:
> VHE actually doesn't rely on clearing the VTTBR when returning to the
> host kernel, and that is the current key mechanism of hyp_panic to
> figure out how to attempt to return to a state good enough to print a
> panic statement.
> 
> Therefore, we split the hyp_panic function into two functions, a VHE and
> a non-VHE, keeping the non-VHE version intact, but changing the VHE
> behavior.
> 
> The vttbr_el2 check on VHE doesn't really make that much sense, because
> the only situation where we can get here on VHE is when the hypervisor
> assembly code actually called into hyp_panic, which only happens when
> VBAR_EL2 has been set to the KVM exception vectors.  On VHE, we can
> always safely disable the traps and restore the host registers at this
> point, so we simply do that unconditionally and call into the panic
> function directly.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v1:
>      - Fixed typos in the commit message
>      - Still use the generic __deactivte_traps() function in the hyp panic
>        code until we rework that logic later.
> 
>  arch/arm64/kvm/hyp/switch.c | 42 +++++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
