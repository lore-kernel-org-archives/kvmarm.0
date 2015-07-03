From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Fri, 3 Jul 2015 19:20:15 +0200
Message-ID: <5596C44F.8070903@redhat.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
 <55953F5F.9090203@redhat.com> <55968A34.5010409@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23F81579CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 13:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3tV-pUDCbyfm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 13:08:59 -0400 (EDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21FF0579CC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 13:08:58 -0400 (EDT)
Received: by widjy10 with SMTP id jy10so114765253wid.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 10:20:18 -0700 (PDT)
In-Reply-To: <55968A34.5010409@linaro.org>
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



On 03/07/2015 15:12, Eric Auger wrote:
>> > Linux IRQ and active should be okay.  As to the vfio_device handle, you
>> > should link it from the vfio_platform_device instead.  And for the
>> > vfio_platform_device, you can link it from the vfio_platform_irq instead.
> For this last one, I don't think this is achievable since if I store the
> vfio_platform_irq in the opaque, it matches irqs[i] of
> vfio_platform_device and I don't have any mean to retrieve "i" when
> calling container_of.

Right, notice I said "link it":

	struct vfio_platform_irq *irq =
		container_of(prod, struct vfio_platform_irq, producer);
	struct vfio_platform_device *vpdev = irq->vpdev;
	struct vfio_device *vdev = vpdev->vdev;

Would this be okay?

Paolo
