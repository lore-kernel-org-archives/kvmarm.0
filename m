From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Thu, 2 Jul 2015 15:40:47 +0200
Message-ID: <55953F5F.9090203@redhat.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35B9A57731
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:29:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id luCqplHJRJtL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:29:39 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38565576DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:29:38 -0400 (EDT)
In-Reply-To: <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 02/07/2015 15:17, Eric Auger wrote:
> - new fields are added on producer side: linux irq, vfio_device handle,
>   active which reflects whether the source is active (at interrupt
>   controller level or at VFIO level - automasked -) and finally an
>   opaque pointer which will be used to point to the vfio_platform_device
>   in this series.

Linux IRQ and active should be okay.  As to the vfio_device handle, you
should link it from the vfio_platform_device instead.  And for the
vfio_platform_device, you can link it from the vfio_platform_irq instead.

Once you've done this, embed the irq_bypass_producer struct in the
vfio_platform_irq struct; in the new kvm_arch_* functions, go back to
the vfio_platform_irq struct via container_of.  From there you can
retrieve pointers to the vfio_platform_device and the vfio_device.

> - new fields on consumer side: the kvm handle, the gsi

You do not need to add these.  Instead, add the kvm handle to irqfd
only.  Like above, embed the irq_bypass_consumer struct in the irqfd
struct; in the new kvm_arch_* functions, go back to the
vfio_platform_irq struct via container_of.

Paolo
