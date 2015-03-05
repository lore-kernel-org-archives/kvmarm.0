From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 5 Mar 2015 12:03:49 +0000
Message-ID: <20150305120348.GD7712@e104818-lin.cambridge.arm.com>
References: <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
 <20150304122956.GT28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu-JnvXFzr-fpjZZ-zTt8hOSfGqefw69s+4JX2iu_6_BMw@mail.gmail.com>
 <20150304141212.GA5352@hawk.usersys.redhat.com>
 <20150304142943.GU28951@e104818-lin.cambridge.arm.com>
 <54F73ACF.1090605@redhat.com>
 <20150304172855.GA28951@e104818-lin.cambridge.arm.com>
 <54F82C06.2000701@redhat.com>
 <20150305110415.GA7712@e104818-lin.cambridge.arm.com>
 <CAFEAcA98j_EsP4Hy20tQCKdnP3=NuvS3Ona37peBjan8aWLSEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA98j_EsP4Hy20tQCKdnP3=NuvS3Ona37peBjan8aWLSEA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 05, 2015 at 08:52:49PM +0900, Peter Maydell wrote:
> On 5 March 2015 at 20:04, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Thu, Mar 05, 2015 at 11:12:22AM +0100, Paolo Bonzini wrote:
> >> On 04/03/2015 18:28, Catalin Marinas wrote:
> >> >> > Can you add that property to the device tree for PCI devices too?
> >> >
> >> > Yes but not with mainline yet:
> >> >
> >> > http://thread.gmane.org/gmane.linux.kernel.iommu/8935
> >> >
> >> > We can add the property at the PCI host bridge level (with the drawback
> >> > that it covers all the PCI devices), like here:
> >>
> >> Even covering all PCI devices is not enough if we want to support device
> >> assignment of PCI host devices.
> >
> > Can we not have another PCI bridge node in the DT for the host device
> > assignments?
> 
> I'd hate to have to do that. PCI should be entirely probeable
> given that we tell the guest where the host bridge is, that's
> one of its advantages.

I didn't say a DT node per device, the DT doesn't know what PCI devices
are available (otherwise it defeats the idea of probing). But we need to
tell the OS where the host bridge is via DT.

So the guest would be told about two host bridges: one for real devices
and another for virtual devices. These can have different coherency
properties.

-- 
Catalin
