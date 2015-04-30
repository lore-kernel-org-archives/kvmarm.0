From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: provide irq_unsafe kvm_guest_{enter|exit}
Date: Thu, 30 Apr 2015 14:28:23 +0200
Message-ID: <55421FE7.3060905@redhat.com>
References: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
 <1430394211-25209-2-git-send-email-borntraeger@de.ibm.com>
 <554216EC.6070406@redhat.com> <554219A1.8050006@de.ibm.com>
 <554219F2.9020805@de.ibm.com> <55421B0A.2060606@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2167B4F015
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 08:19:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bgij1zPFdMsD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2015 08:19:56 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7D334F00D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 08:19:56 -0400 (EDT)
Received: by wief7 with SMTP id f7so11965910wie.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 05:28:27 -0700 (PDT)
In-Reply-To: <55421B0A.2060606@de.ibm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-mips@linux-mips.org, kvm-ppc@vger.kernel.org, KVM <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 30/04/2015 14:07, Christian Borntraeger wrote:
>>>>> >>>> +static inline void __kvm_guest_enter(void)
>>>>> >>>>  {
>>>>> >>>> -	unsigned long flags;
>>>>> >>>> -
>>>>> >>>> -	BUG_ON(preemptible());
>>>> >>>
>>>> >>> Please keep the BUG_ON() in kvm_guest_enter.  Otherwise looks good, thanks!
>> > 
>> > Ah, you mean have the BUG_ON in the non underscore version? Yes, makes sense.
> Hmmm, too quick.
> the BUG_ON was there to make sure that rcu_virt_note_context_switch is safe.
> The reworked code pulls the rcu_virt_note_context_switch within the irq_save
> section so we no longer need this BUG_ON, no?

Right.  I can apply the patches then!

Paolo
