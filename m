From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 11/40] KVM: arm64: Improve debug register save/restore
 flow
Date: Wed, 21 Feb 2018 18:40:06 +0100
Message-ID: <20180221174006.s2wua73l73y5gxjq@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-12-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-12-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:03:03PM +0100, Christoffer Dall wrote:
> Instead of having multiple calls from the world switch path to the debug
> logic, each figuring out if the dirty bit is set and if we should
> save/restore the debug registers, let's just provide two hooks to the
> debug save/restore functionality, one for switching to the guest
> context, and one for switching to the host context, and we get the
> benefit of only having to evaluate the dirty flag once on each path,
> plus we give the compiler some more room to inline some of this
> functionality.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v1:
>      - Remove leading underscores from local variables
> 
>  arch/arm64/include/asm/kvm_hyp.h | 10 ++-----
>  arch/arm64/kvm/hyp/debug-sr.c    | 56 +++++++++++++++++++++++++++-------------
>  arch/arm64/kvm/hyp/switch.c      |  6 ++---
>  3 files changed, 42 insertions(+), 30 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
