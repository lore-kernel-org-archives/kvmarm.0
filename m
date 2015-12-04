From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Fri, 04 Dec 2015 11:28:08 +0000
Message-ID: <566178C8.1070608@arm.com>
References: <cover.1449224338.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB84498A1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 06:26:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q0CDs51qPXJF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2015 06:26:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEDBF49852
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 06:26:35 -0500 (EST)
In-Reply-To: <cover.1449224338.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/12/15 10:25, Pavel Fedin wrote:
> ARM64 CPU has zero register which is read-only, with a value of 0.
> However, KVM currently incorrectly recognizes it being SP (because
> Rt == 31, and in struct user_pt_regs 'regs' array is followed by SP),
> resulting in invalid value being read, or even SP corruption on write.
> 
> The problem has been discovered by performing an operation
> 
>  *((volatile int *)reg) = 0;
> 
> which compiles as "str xzr, [xx]", and resulted in strange values being
> written.
> 
> v1 => v2:
> - Changed type of transfer value to u64 and store it directly in
>   struct sys_reg_params instead of a pointer
> - Use lower_32_bits()/upper_32_bits() where appropriate
> - Fixed wrong usage of 'Rt' instead of 'Rt2' in kvm_handle_cp_64(),
>   overlooked in v1
> - Do not write value back when reading

[+Christoffer]

Hi Pavel,

Thanks a lot for respining this quickly. I just had a few minor
comments, so this is almost ready to go. If you can fix that (and
assuming nobody has any further objection), we'll try to get this queued
ASAP.

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...
