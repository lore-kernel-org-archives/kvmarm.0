From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] arm64: KVM: Don't generate UNDEF when LORegion feature
 is present
Date: Tue, 6 Nov 2018 09:26:57 +0100
Message-ID: <20181106082657.GI12057@e113682-lin.lund.arm.com>
References: <20181105153026.169248-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 214464A31D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 03:27:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jbPFTzvNBdky for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Nov 2018 03:27:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F7C4A307
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 03:27:00 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181105153026.169248-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Richard Henderson <richard.henderson@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 05, 2018 at 03:30:26PM +0000, Marc Zyngier wrote:
> We currently hide the LORegion feature, and generate an UNDEF
> if the guest dares using the corresponding registers. This is
> a bit extreme, as ARMv8.1 guarantees the feature to be present.
> 
> The guest should check the feature register before doing anything,
> but we could also give the guest some slack (read "allow the
> guest to be a bit stupid").
> 
> So instead of unconditionnaly deliver an exception, let's
> only do it when the host doesn't support LORegion at all (or
> when the feature has been sanitized out), and treat the registers
> as RAZ/WI otherwise (with the exception of LORID_EL1 being RO).
> 
> Fixes: cc33c4e20185 ("arm64/kvm: Prohibit guest LOR accesses")
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
