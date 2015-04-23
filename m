From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Thu, 23 Apr 2015 11:40:41 +0200
Message-ID: <5538BE19.6030009@linaro.org>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC6C4E4F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 05:35:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DlYa4w+7p6Sf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 05:35:06 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D2324E4F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 05:35:05 -0400 (EDT)
Received: by widdi4 with SMTP id di4so208848310wid.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 02:43:18 -0700 (PDT)
In-Reply-To: <5538BBD3.9040404@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,
On 04/23/2015 11:30 AM, Paolo Bonzini wrote:
> 
> 
> On 23/04/2015 10:49, Eric Auger wrote:
>> This series introduces a new callback function in IRQState, named
>> get_gsi_cb. It is supposed to be populated by the interrupt controller
>> and its role is to convert the interrupt controller pin number into
>> the global system interrupt (gsi) number. The gsi is used when setting
>> irqfd up.
>>
>> With PCI there is a PCIINTxRoute bus lookup mechanism that enables to
>> retrieve the gsi from the PCI host controller/bridge pin. The conversion
>> is implemented by the PCI host controller. With platform devices, this
>> conversion function is implemented by the interrupt controller.
>>
>> Besides the callback member, a setter is introduced. First user is
>> arm_gic_kvm. A public function wraps the callback, qemu_irq_get_gsi.
>>
>> The first user of qemu_irq_get_gsi might be the VFIO platform device.
>> This will come in the "KVM platform device passthrough" series.
> 
> I'm sorry, I cannot understand the point of this without seeing a user.
no problem, I intend to send the KVM platform device passthrough v13
today which will illustrate the usage.
> 
> Why can't you just use a GHashTable?

You mean implementing this hash table in the interrupt controller?

The problem is my VFIO device currently has no link to the interrupt
controller object. Besides it has a platform bus in between. Previously
I devised a reset notifier called in the machine file to pass this link
but Alex was not keen about this method. So the idea here is when the
VFIO sysbus device qemuirq is getting connected, a notifier is called,
VFIO device can retrieve the gsi of this qemu_irq and call KVM_IRQFD
with that gsi.

Best Regards

Eric
  This mustn't be a hot path, since
> VFIO does all the signalling in the kernel via irqfds.
> 
> Paolo
> 
