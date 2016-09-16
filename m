From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 15:50:26 +0200
Message-ID: <1474033826.7158.10.camel@redhat.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
         <57DBC782.7080305@arm.com>
         <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
         <20160916123039.GB14140@cbox>
         <da8191ca-6fb1-f960-872c-d6bc27172db8@redhat.com>
         <20160916133027.GA27036@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160916133027.GA27036@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

  Hi,

> That being said, I'm not categorically against these patches, but I
> share Marc's view that we've already seen that non-vgic support had been
> broken for multiple versions without anyone complaining,

Oh, did this ever work?  Work as in "can actually run a virtual
machine", not as in "kvm doesn't throw an error on initialization".

> and without
> automated testing or substantial interest in the work, the patches
> really are likely to bit-rot.

Well, as far I know the rpi3 is the *only* aarch64 hardware which is
easily available and can (with these patches) run kvm.

More powerful stuff with more ram and sata storage and gbit network
(which I'd love to have to play with arm virt on real hardware) is
announced to be available really soon now since ...  half a year at
least?

cheers,
  Gerd

