From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH/RFC 2/2] KVM: push down irq_save from kvm_guest_exit
Date: Tue, 28 Apr 2015 16:12:42 +0200
Message-ID: <553F955A.6050804@redhat.com>
References: <1430217168-25504-1-git-send-email-borntraeger@de.ibm.com> <1430217168-25504-3-git-send-email-borntraeger@de.ibm.com> <553F70E9.50907@redhat.com> <553F94CF.2080409@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-ppc-owner@vger.kernel.org>
In-Reply-To: <553F94CF.2080409@de.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu



On 28/04/2015 16:10, Christian Borntraeger wrote:
> > Alternatively, the irq-disabled versions could be called
> > __kvm_guest_{enter,exit}.  Then you can use those directly when it makes
> > sense.
>
> ..having a special  __kvm_guest_{enter,exit} without the WARN_ON might be even
> the cheapest way. In that way I could leave everything besides s390 alone and
> arch maintainers can do a followup patch if appropriate.

That's certainly fine with me.

Paolo
