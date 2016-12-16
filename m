From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v10 8/8] arm/arm64: Documentation: Update arm-vgic-v3.txt
Date: Fri, 16 Dec 2016 13:18:09 +0100
Message-ID: <7d82df18-debd-72e7-af6e-3816b8aaee85@redhat.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-9-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10C3740598
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 07:17:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dBiFH9J699ry for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 07:17:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3330440354
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 07:17:02 -0500 (EST)
In-Reply-To: <1480576187-5012-9-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijaya,

On 01/12/2016 08:09, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> Update error code returned for Invalid CPU interface register
> value and access in AArch32 mode.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> index 9348b3c..0f29850 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -142,10 +142,12 @@ Groups:
>      KVM_DEV_ARM_VGIC_CPU_SYSREGS accesses the CPU interface registers for the
>      CPU specified by the mpidr field.
>  
> +    CPU interface registers access is not implemented for AArch32 mode.
> +    Error -ENXIO is returned when accessed in AArch32 mode.
>    Errors:
>      -ENXIO: Getting or setting this register is not yet supported
>      -EBUSY: VCPU is running
> -    -EINVAL: Invalid mpidr supplied
> +    -EINVAL: Invalid mpidr or register value supplied
>  
>  
>    KVM_DEV_ARM_VGIC_GRP_NR_IRQS
> @@ -193,6 +195,11 @@ Groups:
>  
>  	Bit[n] indicates the status for interrupt vINTID + n.
>  
> +	Getting or setting the level info for an edge-triggered interrupt is
> +	not guaranteed to work.
I don't get this statement. is the API applicable to edge triggered IRQs?

Thanks

Eric
  To restore the complete state of the VGIC, the
> +	configuration (edge/level) of interrupts must be restored before
> +	restoring the level.
> +
>      SGIs and any interrupt with a higher ID than the number of interrupts
>      supported, will be RAZ/WI.  LPIs are always edge-triggered and are
>      therefore not supported by this interface.
> 
