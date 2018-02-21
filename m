From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 22/40] KVM: arm64: Don't save the host ELR_EL2 and
 SPSR_EL2 on VHE systems
Date: Wed, 21 Feb 2018 18:49:24 +0100
Message-ID: <20180221174924.lazhs44fi4qmvend@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-23-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-23-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:03:14PM +0100, Christoffer Dall wrote:
> On non-VHE systems we need to save the ELR_EL2 and SPSR_EL2 so that we can
> return to the host in EL1 in the same state and location where we issued a
> hypercall to EL2, but on VHE ELR_EL2 and SPSR_EL2 are not useful because we
> never enter a guest as a result of an exception entry that would be directly
> handled by KVM. The kernel entry code already saves ELR_EL1/SPSR_EL1 on
> exception entry, which is enough.  Therefore, factor out these registers into
> separate save/restore functions, making it easy to exclude them from the VHE
> world-switch path later on.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
