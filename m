From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 6/7] arm64: docs: document KVM support of pointer
 authentication
Date: Fri, 2 Nov 2018 09:39:39 +0100
Message-ID: <20181102083939.GW12057@e113682-lin.lund.arm.com>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
 <1539773280-4159-7-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539773280-4159-7-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 17, 2018 at 04:17:59PM +0530, Amit Daniel Kachhap wrote:
> The documentation is updated to help in using pointer authentication
> for KVM guests.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  Documentation/arm64/pointer-authentication.txt | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
> index 8a9cb57..b00d735 100644
> --- a/Documentation/arm64/pointer-authentication.txt
> +++ b/Documentation/arm64/pointer-authentication.txt
> @@ -78,7 +78,13 @@ to TTBR1 addresses (e.g. kernel pointers).
>  Virtualization
>  --------------
>  
> -Pointer authentication is not currently supported in KVM guests. KVM
> +Pointer authentication is enabled in KVM guest when virtual machine is
> +created by passing a flag requesting this feature to be enabled. Without
> +this flag, pointer authentication is not enabled in KVM guests and KVM
>  will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
>  the feature will result in an UNDEFINED exception being injected into
>  the guest.
> +
> +The flag to enable this feature is KVM_ARM_VCPU_PTRAUTH and should be
> +used in KVM API KVM_ARM_VCPU_INIT. The pointer authentication key
> +registers are hidden from userspace if this feature is not enabled.
> -- 
> 2.7.4
> 

I think this is placed in the wrong file.

Any information about the KVM API should go in
Documentation/virtual/kvm/api.txt.

The only information about KVM that belongs in this file would be host
running a VM with ptrauth can affect the host's ptrauth state (if that
applies).


Thanks,

    Christoffer
