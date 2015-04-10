From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 0/2] ARM adaptations for vhost irqfd setup
Date: Fri, 10 Apr 2015 08:48:08 +0100
Message-ID: <1428652090-5354-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8051E4BFDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 03:40:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ueuAnt6CAuQq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 03:40:40 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 120414BFD6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 03:40:39 -0400 (EDT)
Received: by wiaa2 with SMTP id a2so16505353wia.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 00:48:17 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, peter.maydell@linaro.org, cornelia.huck@de.ibm.com, borntraeger@de.ibm.com, agraf@suse.de, james.hogan@imgtec.com
Cc: aik@ozlabs.ru, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

After the introduction of gicv2m, this series adds missing pieces to
run VIRTIO-PCI with vhost back-end on ARM.

It is proposed to use the kvm_gsi_direct_mapping modality that sets
the irqfd gsi to the MSI data value. With that trick there is no need
to create a KVM MSI routing entry featuring a different gsi.

The only adaptation needed for ARM consists in adding an architecture
specific function that converts the MSI data field into the actual
gsi index: there is an offset of 32 between the MSI data content
(SPI ID) and the SPI index that is passed to KVM_IRQFD ioctl. Once
this is done we can set the requested flags to enable vhost:
kvm_gsi_direct_mapping, kvm_msi_via_irqfd_allowed.

This was tested on XGene, on top of Christoffer's series,
[PATCH 0/3] Add support for for GICv2m and MSIs to arm-virt
(https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg00881.html)

Best Regards

Eric

v1 -> v2:
- abort on i386/mips/s390x since those archs do not support
  kvm_gsi_direct_mapping


Eric Auger (2):
  kvm: introduce kvm_arch_msi_data_to_gsi
  arm_gicv2m: set kvm_gsi_direct_mapping and kvm_msi_via_irqfd_allowed

 hw/intc/arm_gicv2m.c | 2 ++
 include/sysemu/kvm.h | 2 ++
 kvm-all.c            | 2 +-
 target-arm/kvm.c     | 5 +++++
 target-i386/kvm.c    | 5 +++++
 target-mips/kvm.c    | 5 +++++
 target-ppc/kvm.c     | 5 +++++
 target-s390x/kvm.c   | 5 +++++
 8 files changed, 30 insertions(+), 1 deletion(-)

-- 
1.8.3.2
