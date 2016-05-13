From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic-new: Switch to
 firmware-independent probing
Date: Fri, 13 May 2016 09:02:24 +0100
Message-ID: <57358A10.8070404@arm.com>
References: <1462869983-5410-1-git-send-email-marc.zyngier@arm.com>
 <20160512190216.GO27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D563F407AD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 03:59:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NwEUhLsjU6V8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2016 03:59:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD04A4053F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 03:59:24 -0400 (EDT)
In-Reply-To: <20160512190216.GO27623@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/05/16 20:02, Christoffer Dall wrote:
> On Tue, May 10, 2016 at 09:46:23AM +0100, Marc Zyngier wrote:
>> As we did for the legacy code, switch the new VGIC implementation
>> the firmware-independent probing, giving us ACPI support for free.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> So just remembered you wrote this after sending my comments to patch 48.
> 
> Are we planning to squash this into the series so I can review in
> completeness/with context, or?

This should indeed be squashed in the existing series, no need for an
intermediate step.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
