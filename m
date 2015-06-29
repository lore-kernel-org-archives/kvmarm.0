From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 02/13] KVM: extend struct kvm_msi to hold a 32-bit device
 ID
Date: Mon, 29 Jun 2015 17:02:16 +0200
Message-ID: <20150629150216.GA29339@cbox>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-3-git-send-email-andre.przywara@arm.com>
 <20150628191234.GI28244@cbox>
 <55915BD8.4050103@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55915BD8.4050103@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 29, 2015 at 03:53:12PM +0100, Andre Przywara wrote:
> Hi Christoffer,
> 
> thanks for your time to reviewing this! Was probably no pleasure ;-)
> 
> On 28/06/15 20:12, Christoffer Dall wrote:
> > On Fri, May 29, 2015 at 10:53:18AM +0100, Andre Przywara wrote:
> >> The ARM GICv3 ITS MSI controller requires a device ID to be able to
> >> assign the proper interrupt vector. On real hardware, this ID is
> >> sampled from the bus. To be able to emulate an ITS controller, extend
> >> the KVM MSI interface to let userspace provide such a device ID. For
> >> PCI devices, the device ID is simply the 16-bit bus-device-function
> >> triplet, which should be easily available to the userland tool.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  Documentation/virtual/kvm/api.txt | 8 ++++++--
> >>  include/uapi/linux/kvm.h          | 4 +++-
> >>  2 files changed, 9 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> >> index 9fa2bf8..891d64a 100644
> >> --- a/Documentation/virtual/kvm/api.txt
> >> +++ b/Documentation/virtual/kvm/api.txt
> >> @@ -2121,10 +2121,14 @@ struct kvm_msi {
> >>  	__u32 address_hi;
> >>  	__u32 data;
> >>  	__u32 flags;
> >> -	__u8  pad[16];
> >> +	__u32 devid;
> >> +	__u8  pad[12];
> >>  };
> >>  
> >> -No flags are defined so far. The corresponding field must be 0.
> >> +flags: KVM_MSI_VALID_DEVID: devid is valid, otherwise ignored.
> > 
> > I don't see what the 'otherwise ignored' part of the sentence here is
> > meant to say, that the flags field is otherwise ignored for other value?
> 
> No, that the devid field is ignored if this bit isn't set. I can
> rephrase this to be more explicit.
> 
> > That's not what the current API doc specifies, it specifies that the
> > remainder of the field must be 0.
> > 
> >> +devid: If KVM_MSI_VALID_DEVID is set, contains a value to identify the device
> >> +       that wrote the MSI message. For PCI, this is usually a BFD
> >> +       identifier in the lower 16 bits.
> > 
> > I assume plus something else that uniquely identifies the PCI
> > controller?
> 
> Well yes, the device ID is a unique device identifier within a system,
> the BFD use case was just to illustrate this and give a hint to
> userspace what to fill in there. I will explain this better in v2.
> 
> So are you OK with that extension of the API in general? Just asking
> because there is a lot that depends on it.
> 
Yeah, I didn't review the series in detail yet, but the API change looks
ok to me.

-Christoffer
