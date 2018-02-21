From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 12/40] KVM: arm64: Factor out fault info population
 and gic workarounds
Date: Wed, 21 Feb 2018 18:41:11 +0100
Message-ID: <20180221174111.hrjmal6lofmvqqoj@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-13-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-13-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:03:04PM +0100, Christoffer Dall wrote:
> The current world-switch function has functionality to detect a number
> of cases where we need to fixup some part of the exit condition and
> possibly run the guest again, before having restored the host state.
> 
> This includes populating missing fault info, emulating GICv2 CPU
> interface accesses when mapped at unaligned addresses, and emulating
> the GICv3 CPU interface on systems that need it.
> 
> As we are about to have an alternative switch function for VHE systems,
> but VHE systems still need the same early fixup logic, factor out this
> logic into a separate function that can be shared by both switch
> functions.
> 
> No functional change.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 104 ++++++++++++++++++++++++--------------------
>  1 file changed, 57 insertions(+), 47 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
