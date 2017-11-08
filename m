From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 25/26] KVM: arm/arm64: GICv4: Enable VLPI support
Date: Wed, 8 Nov 2017 15:14:39 +0000
Message-ID: <ba1b912b-e15b-1c76-f8e7-b9f7c5d6dc38@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-26-marc.zyngier@arm.com>
 <2d20a22e-214d-3835-7f61-29fc5e88413a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1535C49D55
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Nov 2017 10:12:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o+4rQJTqCbvk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Nov 2017 10:12:45 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D990F40418
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Nov 2017 10:12:45 -0500 (EST)
In-Reply-To: <2d20a22e-214d-3835-7f61-29fc5e88413a@redhat.com>
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
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/11/17 08:44, Auger Eric wrote:
> Hi Marc,
> 
> On 27/10/2017 16:28, Marc Zyngier wrote:
>> All it takes is the has_v4 flag to be set in gic_kvm_info
>> as well as "kvm-arm.vgic_v4_enable=1" being passed on the
>> command line for GICv4 to be enabled in KVM.
> 
> What did you motivate your choice of having an enable option instead of
> a disable option?

Currently, SW MSI injection works really well. It's been validated,
plenty of people are using it. On the other hand, GICv4 is new and
probably buggy. I only know of 2 other people having tried it. I'm also
not sure it gives the best possible performance in the general use case
(oversubscribed host with freely migrating vcpus).

Given that, I'm not keen on making it the default. But if you can report
that it is better and more reliable than SW injection, I'll switch the
default the other way around! ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
