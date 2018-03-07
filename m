From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [Qemu-devel] [Qemu-arm] VCPU hotplug on KVM/ARM
Date: Wed, 7 Mar 2018 12:47:39 +0000
Message-ID: <acd04e77-33c9-71f1-c140-1f9c20da8022@arm.com>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
 <20180227104708.GA11391@cbox>
 <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
 <20180227124604.GA2373@cbox>
 <20180227132131.fipafmnb56a7fj76@kamzik.brq.redhat.com>
 <20180301105030.2b716e68@redhat.com>
 <CAFEAcA9yaU745Asy--jM0nu8FDJ62CEXSH_TKa-ZZfC16qye6w@mail.gmail.com>
 <b049a501-cd5e-8c22-9c62-88c950e01b1b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F0C40259
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:40:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 98b13yh4wbvQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 07:40:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B49D401AB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:40:28 -0500 (EST)
In-Reply-To: <b049a501-cd5e-8c22-9c62-88c950e01b1b@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <david@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christofferdall@christofferdall.dk>, QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/03/18 13:32, David Hildenbrand wrote:
> On 01.03.2018 11:05, Peter Maydell wrote:
>> On 1 March 2018 at 09:50, Igor Mammedov <imammedo@redhat.com> wrote:
>>> In QEMU on x86 (and I think ppc, s390 as well), we create vCPUs on demand.>>
>>> It would be nice if ARM would be able to do that too,
>>> so that it could take advantage of the same code.
>>
>> It's not clear to me how that would work, given that for
>> instance the interrupt controller wants to know up-front
>> how many CPUs it has to deal with.
>>
> 
> So how is cpu hotplug handled in HW? Or doesn't it even exist there?

I don't know of any physical system offering that facility.

> (we have max_cpus for the interrupt controller, but not sure if that is
> what we want)
We'd need something along those lines. Each CPU has a notional point to
point link to the interrupt controller (to the redistributor, to be
precise), and this entity must pre-exist.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
