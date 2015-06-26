From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Fri, 26 Jun 2015 11:53:18 +0200
Message-ID: <20150626095318.GG28244@cbox>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
 <558A6A84.5020603@arm.com>
 <20150624085128.GA22785@cbox>
 <558A7936.7020109@arm.com>
 <20150625123034.GE28244@cbox>
 <558BF6C9.3000009@arm.com>
 <558C05A9.8080201@arm.com>
 <CAFEAcA_ULz=ugQW=NmthzqYRtvcfwteQTh0DonHRN6U5NykEtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA_ULz=ugQW=NmthzqYRtvcfwteQTh0DonHRN6U5NykEtQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 25, 2015 at 02:49:08PM +0100, Peter Maydell wrote:
> On 25 June 2015 at 14:44, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > It should always be possible to emulate a "known" CPU on a generic host,
> > and it should be able to migrate. The case we can't migrate is when we
> > let the guest be generic (which I guess should really be unknown, and
> > not generic).
> >
> > So if the user specify "-cpu cortex-a57" on the command line, the guest
> > should be able to migrate from an A72 to an A53. if the user specified
> > "-cpu host", the resulting guest won't be able to migrate.
> >
> > Does it make sense?
> 
> Yes. We've always said "-cpu host" won't be cross-host migratable
> from a QEMU point of view.
> 
ok, this makes sense.  It's basically up to userspace to mandate that
trying to migrate something that used unknown cpu (via -cpu host or
whatever) cannot be migrated.

-Christoffer
