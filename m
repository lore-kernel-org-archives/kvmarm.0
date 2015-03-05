From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 5 Mar 2015 11:04:16 +0000
Message-ID: <20150305110415.GA7712@e104818-lin.cambridge.arm.com>
References: <54F51A63.4060302@samsung.com>
 <20150304113505.GS28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
 <20150304122956.GT28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu-JnvXFzr-fpjZZ-zTt8hOSfGqefw69s+4JX2iu_6_BMw@mail.gmail.com>
 <20150304141212.GA5352@hawk.usersys.redhat.com>
 <20150304142943.GU28951@e104818-lin.cambridge.arm.com>
 <54F73ACF.1090605@redhat.com>
 <20150304172855.GA28951@e104818-lin.cambridge.arm.com>
 <54F82C06.2000701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6253147D51
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 05:58:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yedQJdshA-nI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 05:58:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F3E47D4D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 05:58:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <54F82C06.2000701@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 05, 2015 at 11:12:22AM +0100, Paolo Bonzini wrote:
> On 04/03/2015 18:28, Catalin Marinas wrote:
> >> > Can you add that property to the device tree for PCI devices too?
> >
> > Yes but not with mainline yet:
> > 
> > http://thread.gmane.org/gmane.linux.kernel.iommu/8935
> > 
> > We can add the property at the PCI host bridge level (with the drawback
> > that it covers all the PCI devices), like here:
> 
> Even covering all PCI devices is not enough if we want to support device
> assignment of PCI host devices. 

Can we not have another PCI bridge node in the DT for the host device
assignments?

> I'd rather not spend effort on a solution that we know will only
> half-work a few months down the road.

Which of the solutions are you referring to? On the Applied Micro
boards, for example, the PCIe is coherent. If you do device assignment,
the guest must be aware of the coherency property of the physical device
and behave accordingly, there isn't much the host can do about it.

-- 
Catalin
