From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 10/40] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Wed, 21 Feb 2018 18:39:03 +0100
Message-ID: <20180221173903.xlpwnlrnjlpatm5s@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-11-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-11-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:03:02PM +0100, Christoffer Dall wrote:
> The debug save/restore functions can be improved by using the has_vhe()
> static key instead of the instruction alternative.  Using the static key
> uses the same paradigm as we're going to use elsewhere, it makes the
> code more readable, and it generates slightly better code (no
> stack setups and function calls unless necessary).
> 
> We also use a static key on the restore path, because it will be
> marginally faster than loading a value from memory.
> 
> Finally, we don't have to conditionally clear the debug dirty flag if
> it's set, we can just clear it.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v1:
>      - Change dot to comma in comment
>      - Rename __debug_restore_spe to __debug_restore_spe_nvhe
> 
>  arch/arm64/kvm/hyp/debug-sr.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
>

Maybe after this series is merged, if there are any hyp_alternate_select's
left, we can replace all the remaining ones with has_vhe() and then just
completely remove hyp_alternate_select.

Reviewed-by: Andrew Jones <drjones@redhat.com>
