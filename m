From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 03/17] KVM: extend struct kvm_msi to hold a 32-bit
 device ID
Date: Thu, 7 Jul 2016 11:37:21 +0200
Message-ID: <20160707093721.GF12608@cbox>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-4-andre.przywara@arm.com>
 <20160706210648.GD12608@cbox>
 <8e1bab2c-b584-0723-6b23-fb2d5dd959c1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276FD411E3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2016 05:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ttCG0UGwycuw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2016 05:30:45 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A21D640F9B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2016 05:30:45 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id n127so8837756wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jul 2016 02:36:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <8e1bab2c-b584-0723-6b23-fb2d5dd959c1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 06, 2016 at 10:54:58PM +0100, Andr=E9 Przywara wrote:
> On 06/07/16 22:06, Christoffer Dall wrote:
> > On Tue, Jul 05, 2016 at 12:22:55PM +0100, Andre Przywara wrote:
> >> The ARM GICv3 ITS MSI controller requires a device ID to be able to
> >> assign the proper interrupt vector. On real hardware, this ID is
> >> sampled from the bus. To be able to emulate an ITS controller, extend
> >> the KVM MSI interface to let userspace provide such a device ID. For
> >> PCI devices, the device ID is simply the 16-bit bus-device-function
> >> triplet, which should be easily available to the userland tool.
> >>
> >> Also there is a new KVM capability which advertises whether the
> >> current VM requires a device ID to be set along with the MSI data.
> >> This flag is still reported as not available everywhere, later we will
> >> enable it when ITS emulation is used.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> Reviewed-by: Eric Auger <eric.auger@linaro.org>
> >> ---
> >>  Documentation/virtual/kvm/api.txt | 12 ++++++++++--
> >>  include/uapi/linux/kvm.h          |  5 ++++-
> >>  2 files changed, 14 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual=
/kvm/api.txt
> >> index 09efa9e..6551311 100644
> >> --- a/Documentation/virtual/kvm/api.txt
> >> +++ b/Documentation/virtual/kvm/api.txt
> >> @@ -2175,10 +2175,18 @@ struct kvm_msi {
> >>  	__u32 address_hi;
> >>  	__u32 data;
> >>  	__u32 flags;
> >> -	__u8  pad[16];
> >> +	__u32 devid;
> >> +	__u8  pad[12];
> >>  };
> >>  =

> >> -No flags are defined so far. The corresponding field must be 0.
> >> +flags: KVM_MSI_VALID_DEVID: devid contains a valid value
> >> +devid: If KVM_MSI_VALID_DEVID is set, contains a unique device identi=
fier
> >> +       for the device that wrote the MSI message.
> >> +       For PCI, this is usually a BFD identifier in the lower 16 bits.
> >> +
> >> +The per-VM KVM_CAP_MSI_DEVID capability advertises the need to provide
> >> +the device ID. If this capability is not set, userland cannot rely on
> >> +the kernel to allow the KVM_MSI_VALID_DEVID flag being set.
> > =

> > If KVM_CAP_MSI_DEVID is set, is it an error to provide a struct kvm_msi
> > without the KVM_MSI_VALID_DEVID flag set, or not necessarily?
> =

> In the moment we return an error when the bit is not set. But
> theoretically a guest could have other (in-kernel emulated) MSI
> controllers which don't require a device ID, though currently there is no=
ne.
> The reason for both the KVM capability and the flag on the ioctl is for
> mutual assurance that both userland and the kernel know about this ITS
> specific extension.
> This KVM_SIGNAL_MSI API is rather generic, so I don't want to
> unnecessarily slam the door on other emulated ITS controllers.
> =


That's a reasonable argument, that you could have multiple MSI
controllers with/without device ids.

Thanks,
-Christoffer
