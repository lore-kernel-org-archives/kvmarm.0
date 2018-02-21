From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 16/40] KVM: arm64: Remove noop calls to timer
 save/restore from VHE switch
Date: Wed, 21 Feb 2018 18:43:49 +0100
Message-ID: <20180221174349.3e7kpo475k3pi6rv@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-17-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-17-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:03:08PM +0100, Christoffer Dall wrote:
> The VHE switch function calls __timer_enable_traps and
> __timer_disable_traps which don't do anything on VHE systems.
> Therefore, simply remove these calls from the VHE switch function and
> make the functions non-conditional as they are now only called from the
> non-VHE switch path.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v2:
>      - Added comment explaining the timer enable/disable functions
>        are for !VHE only.
> 
>  arch/arm64/kvm/hyp/switch.c |  2 --
>  virt/kvm/arm/hyp/timer-sr.c | 44 ++++++++++++++++++++++----------------------
>  2 files changed, 22 insertions(+), 24 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
