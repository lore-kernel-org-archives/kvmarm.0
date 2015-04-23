From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 1/2] kvm-all.c: add qemu_irq/gsi hash table and utility
 routines
Date: Thu, 23 Apr 2015 17:21:30 +0200
Message-ID: <55390DFA.70201@linaro.org>
References: <1429801716-8027-1-git-send-email-eric.auger@linaro.org>
 <1429801716-8027-2-git-send-email-eric.auger@linaro.org>
 <55390E40.5000503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7514E5A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 11:15:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cTqLbl34eHWn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 11:15:53 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 379E64E5A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 11:15:52 -0400 (EDT)
Received: by widdi4 with SMTP id di4so220095957wid.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 08:24:06 -0700 (PDT)
In-Reply-To: <55390E40.5000503@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org, agraf@suse.de
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/23/2015 05:22 PM, Paolo Bonzini wrote:
> 
> 
> On 23/04/2015 17:08, Eric Auger wrote:
>>  int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
>>                                     EventNotifier *rn, int virq);
>>  int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq);
>> +int kvm_irqchip_add_qemuirq_irqfd_notifier(KVMState *s, EventNotifier *n,
>> +                                           EventNotifier *rn, qemu_irq irq);
>> +int kvm_irqchip_remove_qemuirq_irqfd_notifier(KVMState *s, EventNotifier *n,
>> +                                              qemu_irq irq);
> 
> 
> Perhaps rename the existing ones to
> 
> kvm_irqchip_add_irqfd_notifier_gsi
> kvm_irqchip_remove_irqfd_notifier_gsi
> 
> and change the new ones to kvm_irqchip_add_irqfd_notifier and
> kvm_irqchip_remove_irqfd_notifier?
OK thanks!

Eric
> 
> Okay with that change; include it in the vfio-platform series and I'll
> ack it.
> 
> Paolo
> 
