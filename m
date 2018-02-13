From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 05/41] KVM: arm64: Move HCR_INT_OVERRIDE to default
 HCR_EL2 guest flag
Date: Tue, 13 Feb 2018 22:47:54 +0100
Message-ID: <20180213214754.GJ23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-6-christoffer.dall@linaro.org>
 <ffb7df11-b304-25f7-f3f4-b55cb106b747@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ffb7df11-b304-25f7-f3f4-b55cb106b747@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 09, 2018 at 11:38:50AM +0000, Julien Grall wrote:
> Hi,
> 
> On 01/12/2018 12:07 PM, Christoffer Dall wrote:
> >From: Shih-Wei Li <shihwei@cs.columbia.edu>
> >
> >We always set the IMO and FMO bits in the HCR_EL2 when running the
> >guest, regardless if we use the vgic or not.  By moving these flags to
> >HCR_GUEST_FLAGS we can avoid one of the extra save/restore operations of
> >HCR_EL2 in the world switch code, and we can also soon get rid of the
> >other one.
> >
> >This is safe, because even though the IMO and FMO bits control both
> >taking the interrupts to EL2 and remapping ICC_*_EL1 to ICV_*_EL1
> >executed at EL1, as long as we ensure that these bits are clear when
> >running the EL1 host, as defined in the HCR_HOST_[VHE_]FLAGS, we're OK.
> 
> NIT: I was a bit confused by the end of the sentence because HCR_HOST_FLAGS
> define does not seem to exist.
> 

True, that was nonsense.

I have reworded it slightly.

Thanks,
-Christoffer
