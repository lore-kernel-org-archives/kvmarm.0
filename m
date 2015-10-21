From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally
Date: Wed, 21 Oct 2015 15:20:00 +0200
Message-ID: <20151021132000.GA13488@cbox>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
 <1445357947-6022-4-git-send-email-christoffer.dall@linaro.org>
 <672714208.55851501.1445370665940.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <672714208.55851501.1445370665940.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, arnd@arndb.de
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 20, 2015 at 03:51:05PM -0400, Paolo Bonzini wrote:
> Should this be "select" or "depends on"? Not a blocker, can always be=
 fixed in 4.4.
>=20
Hmm, I don't know actually.  I trusted Arnd to make the right call and
given Marc's ack as well, I didn't pay too much attention to that
particular detail.

Arnd, any comments?

Thanks,
-Christoffer

>=20
>=20
> -----Original Message-----
> From: Christoffer Dall [christoffer.dall@linaro.org]
> Received: marted=EC, 20 ott 2015, 18:18
> To: Paolo Bonzini [pbonzini@redhat.com]; kvmarm@lists.cs.columbia.edu=
, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
> CC: Marc Zyngier [marc.zyngier@arm.com]; Arnd Bergmann [arnd@arndb.de=
]; Christoffer Dall [christoffer.dall@linaro.org]
> Subject: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The vgic code on ARM is built for all configurations that enable KVM,
> but the parent_data field that it references is only present when
> CONFIG_IRQ_DOMAIN_HIERARCHY is set:
>=20
> virt/kvm/arm/vgic.c: In function 'kvm_vgic_map_phys_irq':
> virt/kvm/arm/vgic.c:1781:13: error: 'struct irq_data' has no member n=
amed 'parent_data'
>=20
> This flag is implied by the GIC driver, and indeed the VGIC code only
> makes sense if a GIC is present. This changes the CONFIG_KVM symbol
> to always select GIC, which avoids the issue.
>=20
> Fixes: 662d9715840 ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}=
")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 210ecca..356970f 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -21,6 +21,7 @@ config KVM
>  	depends on MMU && OF
>  	select PREEMPT_NOTIFIERS
>  	select ANON_INODES
> +	select ARM_GIC
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
>  	select KVM_MMIO
> --=20
> 2.1.2.330.g565301e.dirty
>=20
