From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: HCPTR cp15 writes need isb?
Date: Tue, 16 Jun 2015 07:46:24 +0100
Message-ID: <20150616074624.64b7d71c@why.wild-wind.fr.eu.org>
References: <557F7D1F.1070308@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBFD7551D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2015 02:33:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEtk8Ua9R6ja for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2015 02:33:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76638551D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2015 02:33:37 -0400 (EDT)
In-Reply-To: <557F7D1F.1070308@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vikram Sethi <vikrams@codeaurora.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "mmcilvai@qti.qualcomm.com" <mmcilvai@qti.qualcomm.com>, "vikrams@qti.qualcomm.com" <vikrams@qti.qualcomm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 16 Jun 2015 02:34:23 +0100
Vikram Sethi <vikrams@codeaurora.org> wrote:

Hi Vikram,

> Hi Marc, Christoffer, Catalin, Will,
> 
> I'm seeing an issue with KVM HCPTR (cp15) writes on guest entry/exit
> on one of Qualcomm's CPU cores in AArch32 host and AArch32 guest
> mode. Our CPU architects believe that HCPTR cp15 writes are context
> changing and require an isb. With an isb in set_hcptr macro in
> arch/arm/kvm/interrupts_head.S I am able to boot the Aarch32 guest,
> but without it, I see strange crashes to hyp_undef or hyp_pabt.

[...]

Can you look at the following patch (queued for 4.2)?

http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/330955.html

Please let me know if this solves the issue you are seeing.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
