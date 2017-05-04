From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 02/24] KVM: arm/arm64: Add GICV3 pending table save
 API documentation
Date: Thu, 4 May 2017 15:24:26 +0200
Message-ID: <20170504132426.GO5923@cbox>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-3-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F6240A86
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 09:21:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Irgbui-1c4U5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 09:21:23 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0247F40A69
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 09:21:22 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id 142so11115094wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 May 2017 06:24:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1493898284-29504-3-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:22PM +0200, Eric Auger wrote:
> Add description for how to save GICV3 LPI pending bit into
> guest RAM pending tables.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
> v5: creation
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> index c1a2461..9293b45 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> @@ -167,11 +167,17 @@ Groups:
>      KVM_DEV_ARM_VGIC_CTRL_INIT
>        request the initialization of the VGIC, no additional parameter in
>        kvm_device_attr.addr.
> +    KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
> +      save all LPI pending bits into guest RAM pending tables.
> +
> +      The first kB of the pending table is not altered by this operation.
>    Errors:
>      -ENXIO: VGIC not properly configured as required prior to calling
>       this attribute
>      -ENODEV: no online VCPU
>      -ENOMEM: memory shortage when allocating vgic internal data
> +    -EFAULT: Invalid guest ram access
> +    -EBUSY:  One or more VCPUS are running
>  
>  
>    KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
> -- 
> 2.5.5
> 
