From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/2] KVM: arm/mips/x86/power use __kvm_guest_{enter|exit}
Date: Tue, 5 May 2015 14:08:22 +0200
Message-ID: <20150505120822.GB19385@cbox>
References: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
 <1430394211-25209-3-git-send-email-borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-ppc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430394211-25209-3-git-send-email-borntraeger@de.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 30, 2015 at 01:43:31PM +0200, Christian Borntraeger wrote:
> Use __kvm_guest_{enter|exit} instead of kvm_guest_{enter|exit}
> where interrupts are disabled.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

For the ARM part:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
