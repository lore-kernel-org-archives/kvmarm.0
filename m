From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 1/2] KVM: provide irq_unsafe kvm_guest_{enter|exit}
Date: Thu, 30 Apr 2015 14:01:37 +0200
Message-ID: <554219A1.8050006@de.ibm.com>
References: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com> <1430394211-25209-2-git-send-email-borntraeger@de.ibm.com> <554216EC.6070406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-ppc-owner@vger.kernel.org>
In-Reply-To: <554216EC.6070406@redhat.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

Am 30.04.2015 um 13:50 schrieb Paolo Bonzini:
> 
> 
> On 30/04/2015 13:43, Christian Borntraeger wrote:
>> +/* must be called with irqs disabled */
>> +static inline void __kvm_guest_enter(void)
>>  {
>> -	unsigned long flags;
>> -
>> -	BUG_ON(preemptible());
> 
> Please keep the BUG_ON() in kvm_guest_enter.  Otherwise looks good, thanks!

would be 
	BUG_ON(!irqs_disabled())
then?
