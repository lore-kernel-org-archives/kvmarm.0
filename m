From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 1/2] KVM: provide irq_unsafe kvm_guest_{enter|exit}
Date: Thu, 30 Apr 2015 14:07:38 +0200
Message-ID: <55421B0A.2060606@de.ibm.com>
References: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
 <1430394211-25209-2-git-send-email-borntraeger@de.ibm.com>
 <554216EC.6070406@redhat.com> <554219A1.8050006@de.ibm.com>
 <554219F2.9020805@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E184F00C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 07:59:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uBe-3mbRJ1Gb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2015 07:59:13 -0400 (EDT)
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25D1D4EFF9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 07:59:12 -0400 (EDT)
Received: from /spool/local
 by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Thu, 30 Apr 2015 13:07:43 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id D780817D805A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 13:08:22 +0100 (BST)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com
 [9.149.37.247])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t3UC7eV18257820
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 12:07:40 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t3UC7d4n030872
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 06:07:40 -0600
In-Reply-To: <554219F2.9020805@de.ibm.com>
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
Cc: linux-mips@linux-mips.org, KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Am 30.04.2015 um 14:02 schrieb Christian Borntraeger:
> Am 30.04.2015 um 14:01 schrieb Christian Borntraeger:
>> Am 30.04.2015 um 13:50 schrieb Paolo Bonzini:
>>>
>>>
>>> On 30/04/2015 13:43, Christian Borntraeger wrote:
>>>> +/* must be called with irqs disabled */
>>>> +static inline void __kvm_guest_enter(void)
>>>>  {
>>>> -	unsigned long flags;
>>>> -
>>>> -	BUG_ON(preemptible());
>>>
>>> Please keep the BUG_ON() in kvm_guest_enter.  Otherwise looks good, thanks!
> 
> Ah, you mean have the BUG_ON in the non underscore version? Yes, makes sense.

Hmmm, too quick.
the BUG_ON was there to make sure that rcu_virt_note_context_switch is safe.
The reworked code pulls the rcu_virt_note_context_switch within the irq_save
section so we no longer need this BUG_ON, no?

Christian
