From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 04/18] KVM: arm/arm64: Introduce
 kvm_arch_vcpu_run_pid_change
Date: Wed, 23 May 2018 15:40:26 +0100
Message-ID: <20180523144026.GM13470@e103592.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-5-git-send-email-Dave.Martin@arm.com>
 <87muwqtp8z.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <87muwqtp8z.fsf@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 03:34:20PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > From: Christoffer Dall <christoffer.dall@linaro.org>
> >
> > KVM/ARM differs from other architectures in having to maintain an
> > additional virtual address space from that of the host and the
> > guest, because we split the execution of KVM across both EL1 and
> > EL2.
> >
> > This results in a need to explicitly map data structures into EL2
> > (hyp) which are accessed from the hyp code.  As we are about to be
> > more clever with our FPSIMD handling on arm64, which stores data in
> > the task struct and uses thread_info flags, we will have to map
> > parts of the currently executing task struct into the EL2 virtual
> > address space.
> >
> > However, we don't want to do this on every KVM_RUN, because it is a
> > fairly expensive operation to walk the page tables, and the common
> > execution mode is to map a single thread to a VCPU.  By introducing
> > a hook that architectures can select with
> > HAVE_KVM_VCPU_RUN_PID_CHANGE, we do not introduce overhead for
> > other architectures, but have a simple way to only map the data we
> > need when required for arm64.
> >
> > This patch introduces the framework only, and wires it up in the
> > arm/arm64 KVM common code.
> >
> > No functional change.
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  include/linux/kvm_host.h | 9 +++++++++
> >  virt/kvm/Kconfig         | 3 +++
> >  virt/kvm/kvm_main.c      | 7 ++++++-
> >  3 files changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 6930c63..4268ace 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1276,4 +1276,13 @@ static inline long kvm_arch_vcpu_async_ioctl(str=
uct file *filp,
> >  void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> >  		unsigned long start, unsigned long end);
> >
> > +#ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
> > +int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
> > +#else
> > +static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> > +{
> > +	return 0;
> > +}
> > +#endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
> > +
> >  #endif
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index cca7e06..72143cf 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -54,3 +54,6 @@ config HAVE_KVM_IRQ_BYPASS
> >
> >  config HAVE_KVM_VCPU_ASYNC_IOCTL
> >         bool
> > +
> > +config HAVE_KVM_VCPU_RUN_PID_CHANGE
> > +       bool
> =

> This almost threw me as I thought you might be able to enable this and
> break the build, but apparently not:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Without a "help", the option seems non-interactive and cannot be true
unless something selects it.  It seems a bit weird to me too, but the
idiom appears widely used...

Christoffer?

[...]

Cheers
---Dave
