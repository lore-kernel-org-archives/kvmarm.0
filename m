From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 0/2] ARM adaptations for vhost irqfd setup
Date: Mon, 1 Jun 2015 19:28:44 +0100
Message-ID: <CAFEAcA_nXG6_7kT-FM954o180Kg7h8Y+J3XL2Xe-=_U-vmcJzA@mail.gmail.com>
References: <1428652090-5354-1-git-send-email-eric.auger@linaro.org>
 <5527869F.5000509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07AF751936
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 14:19:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2wFRJwil3AnO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jun 2015 14:19:09 -0400 (EDT)
Received: from mail-ig0-f181.google.com (mail-ig0-f181.google.com
 [209.85.213.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF8BC52C0D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 14:19:08 -0400 (EDT)
Received: by igbjd9 with SMTP id jd9so68556509igb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Jun 2015 11:29:05 -0700 (PDT)
In-Reply-To: <5527869F.5000509@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: James Hogan <james.hogan@imgtec.com>, eric.auger@st.com, Alexey Kardashevskiy <aik@ozlabs.ru>, Patch Tracking <patches@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cornelia.huck@de.ibm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10 April 2015 at 09:15, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 10/04/2015 09:48, Eric Auger wrote:
>> After the introduction of gicv2m, this series adds missing pieces to
>> run VIRTIO-PCI with vhost back-end on ARM.
>>
>> It is proposed to use the kvm_gsi_direct_mapping modality that sets
>> the irqfd gsi to the MSI data value. With that trick there is no need
>> to create a KVM MSI routing entry featuring a different gsi.
>>
>> The only adaptation needed for ARM consists in adding an architecture
>> specific function that converts the MSI data field into the actual
>> gsi index: there is an offset of 32 between the MSI data content
>> (SPI ID) and the SPI index that is passed to KVM_IRQFD ioctl. Once
>> this is done we can set the requested flags to enable vhost:
>> kvm_gsi_direct_mapping, kvm_msi_via_irqfd_allowed.
>>
>> This was tested on XGene, on top of Christoffer's series,
>> [PATCH 0/3] Add support for for GICv2m and MSIs to arm-virt
>> (https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg00881.html)
>>
>> Best Regards
>>
>> Eric
>>
>> v1 -> v2:
>> - abort on i386/mips/s390x since those archs do not support
>>   kvm_gsi_direct_mapping
>
> Patch 1 is okay.  I guess this series will go through some ARM tree.

Now that I've applied the gicv2m patches I've also applied this
series to target-arm.next.

thanks
-- PMM
