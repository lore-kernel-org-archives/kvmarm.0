From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: VCPU hotplug on KVM/ARM
Date: Wed, 25 Jul 2018 11:40:54 +0100
Message-ID: <74427c65-b860-d576-04f9-766253285210@arm.com>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
 <20180227104708.GA11391@cbox>
 <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
 <20180227124604.GA2373@cbox>
 <20180227132131.fipafmnb56a7fj76@kamzik.brq.redhat.com>
 <b589d714-4f12-e450-7ca5-e55fed4d1705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC4B140A6E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 06:40:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jLDfAF2eLItO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 06:40:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8BE54045F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 06:40:58 -0400 (EDT)
In-Reply-To: <b589d714-4f12-e450-7ca5-e55fed4d1705@oracle.com>
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
To: Maran Wilson <maran.wilson@oracle.com>, kvmarm@lists.cs.columbia.edu, bthakur@codeaurora.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <cdall@kernel.org>, david@redhat.com, qemu-devel@nongnu.org, Christoffer Dall <christofferdall@christofferdall.dk>, qemu-arm@nongnu.org, imammedo@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 24/07/18 19:35, Maran Wilson wrote:
> It's been a few months since this email thread died off. Has anyone 
> started working on a potential solution that would allow VCPU hotplug on 
> KVM/ARM ? Or is this a project that is still waiting for an owner who 
> has the time and inclination to get started?

This is typically a project for someone who would have this particular
itch to scratch, and who has a demonstrable need for this functionality.

Work wise, it would have to include adding physical CPU hotplug support
to the arm64 kernel as a precondition, before worrying about doing it in
KVM.

For KVM itself, particular area of interests would be:
- Making GICv3 redistributors magically appear in the IPA space
- Live resizing of GICv3 structures
- Dynamic allocation of MPIDR, and mapping with vcpu_id

This should keep someone busy for a good couple of weeks (give or take a
few months).

That being said, I'd rather see support in QEMU first, creating all the
vcpu/redistributors upfront, and signalling the hotplug event via the
virtual firmware. And then post some numbers to show that creating all
the vcpus upfront is not acceptable.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
