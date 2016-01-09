From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Sat, 9 Jan 2016 13:29:56 +0100
Message-ID: <20160109122956.GA30867@cbox>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com>
 <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
 <20160107203647.GJ6199@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 646894993D
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:25:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kH7hQyM-yust for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jan 2016 07:25:30 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6605B497F8
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:25:30 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id f206so206980050wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Jan 2016 04:29:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160107203647.GJ6199@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 07, 2016 at 09:36:47PM +0100, Andrew Jones wrote:
> On Thu, Jan 07, 2016 at 02:56:15PM +0000, Peter Maydell wrote:
> > On 7 January 2016 at 14:49, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> > >>> +
> > >>> +Groups:
> > >>> +  KVM_DEV_ARM_PMU_GRP_IRQ
> > >>> +  Attributes:
> > >>> +    The attr field of kvm_device_attr encodes one value:
> > >>> +    bits:     | 63 .... 32 | 31 ....  0 |
> > >>> +    values:   |  reserved  | vcpu_index |
> > >>> +    A value describing the PMU overflow interrupt number for the specified
> > >>> +    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
> > >>> +    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
> > >>> +    same for all vcpus, while as a SPI it must be different for each vcpu.
> > >>
> > >> I see we're using vcpu_index rather than MPIDR affinity value
> > >> for specifying which CPU we're configuring. Is this in line with
> > >> our planned API for GICv3 configuration?
> > >>
> > > Here vcpu_index is used to indexing the vCPU, no special use.
> > 
> > Yes, but you can identify the CPU by index, or by its MPIDR.
> > We had a discussion about which was the best way for doing
> > the VGIC API, and I can't remember which way round we ended up
> > going for. Whichever we chose, we should do the same thing here.
> 
> I think we should start up a new discussion on this. My understanding,
> after a chat with Igor, who was involved in the untangling of vcpu-id and
> apic-id for x86, is that using vcpu-id is preferred, unless of course
> the device expects an apic-id/mpidr, in which case there's no reason to
> translate it on both sides.
> 

I'm fairly strongly convinced that we should use the full 32-bit
compressed MPIDR for everything ARM related going forward, as this will
cover any case required and leverages and architecturally defined way of
uniquely identifying a (v)CPU.

-Christoffer
