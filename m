From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 02/12] KVM: arm/arm64: Document
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Tue, 24 Apr 2018 23:12:03 +0200
Message-ID: <20180424211203.GA10555@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-3-git-send-email-eric.auger@redhat.com>
 <20180424164649.GA4533@C02W217FHV2R.local>
 <CAFEAcA_EKuW6DWaHCvAftbL6QUSo6WY0cQmHrZhhbP5HoN_NqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA_EKuW6DWaHCvAftbL6QUSo6WY0cQmHrZhhbP5HoN_NqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, Eric Auger <eric.auger.pro@gmail.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, Andre Przywara <andre.przywara@arm.com>, Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 24, 2018 at 05:50:37PM +0100, Peter Maydell wrote:
> On 24 April 2018 at 17:46, Christoffer Dall <christoffer.dall@arm.com> wrote:
> > On Fri, Apr 13, 2018 at 10:20:48AM +0200, Eric Auger wrote:
> >> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> >> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> >> @@ -27,9 +27,32 @@ Groups:
> >>        VCPU and all of the redistributor pages are contiguous.
> >>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
> >>        This address needs to be 64K aligned.
> >> +
> >> +    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION (rw, 64-bit)
> >> +      The attr field of kvm_device_attr encodes 3 values:
> >> +      bits:     | 63   ....  52  |  51   ....   16 | 15 - 12  |11 - 0
> >> +      values:   |     count      |       base      |  flags   | index
> >> +      - index encodes the unique redistributor region index
> >
> > I'm not entirely sure I understand the purpose of the index field.
> > Isn't a redistributor region identified uniquely by its base address?
> 
> You need a way to tell the difference beween:
>  (1) redistributors for CPUs 0..63 at 0x40000000, redistributors
>      for 64..127 at 0x80000000
>  (2) redistributors for CPUs 0..63 at 0x80000000, redistributors
>      for 64..127 at 0x40000000
> 
> The index field tells you which order the redistributor
> regions go in.

ah, right.  This could be implied by the order creating the regions
though, but ok, in that case it's nicer for userspace to state it
explicitly.

Thanks,
-Christoffer
