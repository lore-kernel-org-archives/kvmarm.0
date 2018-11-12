From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 2/7] arm64/kvm: context-switch ptrauth registers
Date: Mon, 12 Nov 2018 22:32:12 +0000
Message-ID: <20181112223212.5o4ipc5kt5ziuupt@localhost>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
 <1539773280-4159-3-git-send-email-amit.kachhap@arm.com>
 <20181102083725.GV12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181102083725.GV12057@e113682-lin.lund.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Jones <drjones@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 02, 2018 at 09:37:25AM +0100, Christoffer Dall wrote:
> On Wed, Oct 17, 2018 at 04:17:55PM +0530, Amit Daniel Kachhap wrote:
> > From: Mark Rutland <mark.rutland@arm.com>
> > 
> > When pointer authentication is supported, a guest may wish to use it.
> > This patch adds the necessary KVM infrastructure for this to work.
> > 
> > When we schedule a vcpu, we enable guest usage of pointer
> > authentication instructions and accesses to the keys. After these are
> > enabled, we allow context-switching the keys.
> > 
> > Pointer authentication consists of address authentication and generic
> > authentication, and CPUs in a system might have varied support for
> > either. Where support for either feature is not uniform, it is hidden
> > from guests via ID register emulation, as a result of the cpufeature
> > framework in the host.
> > 
> > Unfortunately, address authentication and generic authentication cannot
> > be trapped separately, as the architecture provides a single EL2 trap
> > covering both. If we wish to expose one without the other, we cannot
> > prevent a (badly-written) guest from intermittently using a feature
> > which is not uniformly supported (when scheduled on a physical CPU which
> > supports the relevant feature). When the guest is scheduled on a
> > physical CPU lacking the feature, these attempts will result in an UNDEF
> > being taken by the guest.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: kvmarm@lists.cs.columbia.edu
[...] 
> Two questions:
> 
>  - Can we limit all ptrauth functionality to VHE systems so that we
>    don't need to touch the non-VHE path and so that we don't need any of
>    the __hyp_text stuff?

I would say yes. ARMv8.3 implies v8.1, so can enable ptrauth only when
VHE is built into the kernel and present in the CPU implementation.

>  - Can we move all the save/restore logic to vcpu load/put as long as
>    the host kernel itself isn't using ptrauth, and if the host kernel at
>    some point begins to use ptrauth, can we have a hook to save/restore
>    at that time (similar to what we do for FPSIMD) to avoid this
>    overhead on every switch?

We will probably enable ptrauth for the kernel as well fairly soon, so I
don't think we should base the KVM assumption on the no ptrauth in
kernel use-case.

-- 
Catalin
