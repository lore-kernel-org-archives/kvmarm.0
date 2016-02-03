From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 00/10] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Wed, 3 Feb 2016 13:50:47 +0100
Message-ID: <20160203125047.GB13974@cbox>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
 <1454017899.23148.0.camel@redhat.com> <56AB78B1.2030202@linaro.org>
 <1454096004.9301.1.camel@redhat.com> <56ABD8E0.6080409@linaro.org>
 <20160201140351.GE6828@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29EFA4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2016 07:44:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wxTjY3pEq7SP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2016 07:44:55 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3A9B40FA7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2016 07:44:54 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id 128so163824498wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Feb 2016 04:50:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160201140351.GE6828@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: eric.auger@st.com, kvm@vger.kernel.org, marc.zyngier@arm.com, patches@linaro.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 01, 2016 at 02:03:51PM +0000, Will Deacon wrote:
> On Fri, Jan 29, 2016 at 10:25:52PM +0100, Eric Auger wrote:
> > On 01/29/2016 08:33 PM, Alex Williamson wrote:
> > >>> We know that x86 handles MSI vectors specially, so there is some
> > >>> hardware that helps the situation.  It's not just that x86 has a fixed
> > >>> range for MSI, it's how it manages that range when interrupt remapping
> > >>> hardware is enabled.  A device table indexed by source-ID references a
> > >>> per device table indexed by data from the MSI write itself.  So we get
> > >>> much, much finer granularity,
> > >> About the granularity, I think ARM GICv3 now provides a similar
> > >> capability with GICv3 ITS (interrupt translation service). Along with
> > >> the MSI MSG write transaction, the device outputs a DeviceID conveyed on
> > >> the bus. This DeviceID (~ your source-ID) enables to index a device
> > >> table. The entry in the device table points to a DeviceId interrupt
> > >> translation table indexed by the EventID found in the msi msg. So the
> > >> entry in the interrupt translation table eventually gives you the
> > >> eventual interrupt ID targeted by the MSI MSG.
> > >> This translation capability if not available in GICv2M though, ie. the
> > >> one I am currently using.
> > >>  
> > >> Those tables currently are built by the ITS irqchip (irq-gic-v3-its.c)
> 
> That's right. GICv3/ITS disambiguates the interrupt source using the
> DeviceID, which for PCI is derived from the Requester ID of the endpoint.
> GICv2m is less flexible and requires a separate physical frame per guest
> to achieve isolation.
> 
We should still support MSI passthrough with a single MSI frame host
system though, right?

(Users should just be aware that guests are not fully protected against
misbehaving hardware in that case).

-Christoffer
