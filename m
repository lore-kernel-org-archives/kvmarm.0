From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/2] ARM adaptations for vhost irqfd setup
Date: Fri, 10 Apr 2015 10:15:27 +0200
Message-ID: <5527869F.5000509@redhat.com>
References: <1428652090-5354-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024A14BFF0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 04:08:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y4xRkW6OiUV5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 04:07:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F8674BFD6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 04:07:57 -0400 (EDT)
In-Reply-To: <1428652090-5354-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org, cornelia.huck@de.ibm.com, borntraeger@de.ibm.com, agraf@suse.de, james.hogan@imgtec.com
Cc: aik@ozlabs.ru, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 10/04/2015 09:48, Eric Auger wrote:
> After the introduction of gicv2m, this series adds missing pieces to
> run VIRTIO-PCI with vhost back-end on ARM.
> 
> It is proposed to use the kvm_gsi_direct_mapping modality that sets
> the irqfd gsi to the MSI data value. With that trick there is no need
> to create a KVM MSI routing entry featuring a different gsi.
> 
> The only adaptation needed for ARM consists in adding an architecture
> specific function that converts the MSI data field into the actual
> gsi index: there is an offset of 32 between the MSI data content
> (SPI ID) and the SPI index that is passed to KVM_IRQFD ioctl. Once
> this is done we can set the requested flags to enable vhost:
> kvm_gsi_direct_mapping, kvm_msi_via_irqfd_allowed.
> 
> This was tested on XGene, on top of Christoffer's series,
> [PATCH 0/3] Add support for for GICv2m and MSIs to arm-virt
> (https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg00881.html)
> 
> Best Regards
> 
> Eric
> 
> v1 -> v2:
> - abort on i386/mips/s390x since those archs do not support
>   kvm_gsi_direct_mapping

Patch 1 is okay.  I guess this series will go through some ARM tree.

Paolo
