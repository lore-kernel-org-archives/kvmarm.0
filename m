From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 0/2] KVM: Synchronize KVM devices list access and
 create ops
Date: Fri, 12 Aug 2016 14:36:37 +0200
Message-ID: <20160812123637.GD8001@potion>
References: <20160809171301.24283-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160809171301.24283-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@suse.de>, borntraeger@de.ibm.com, paulus@ozlabs.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

2016-08-09 19:12+0200, Christoffer Dall:
> Currently accesses the kvm->devices list is not synchronized by any
> mechanism which can potentially lead to data corruption.  Further, a
> number of the create operations on the individual devices are racy and
> would allow creation of multiple devices, opposite to the intention.
> 
> Factor out portions of the XICS create operation into a separate init
> operation and protect the remaining list accesses and create operations
> with the kvm->lock.
> 
> Tested on arm/arm64 and compile-tested on powerpc for the xics changes.
> Tested-by on other archs would be appreciated.

Applied, thanks.
