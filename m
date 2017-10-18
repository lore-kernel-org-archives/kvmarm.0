From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 04/13] arm64: alternatives: use tpidr_el2 on VHE hosts
Date: Wed, 18 Oct 2017 12:00:08 +0100
Message-ID: <20171018110008.pr64c2osf4p4xv3f@armageddon.cambridge.arm.com>
References: <20171017174432.1684-1-james.morse@arm.com>
 <20171017174432.1684-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8EC49D1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 06:59:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMnjhW-zFzho for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 06:59:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FA4F40D25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 06:59:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171017174432.1684-5-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 06:44:23PM +0100, James Morse wrote:
> Now that KVM uses tpidr_el2 in the same way as Linux's cpu_offset in
> tpidr_el1, merge the two. This saves KVM from save/restoring tpidr_el1
> on VHE hosts, and allows future code to blindly access per-cpu variables
> without triggering world-switch.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
