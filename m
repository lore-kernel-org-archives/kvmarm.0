From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 16/21] KVM: arm64: Save/Restore guest DISR_EL1
Date: Tue, 31 Oct 2017 04:27:51 +0000
Message-ID: <86lgjs3prs.fsf@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-17-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D99A49D20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 00:26:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qRvXeL083+z1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 00:26:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E58549D13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 00:26:21 -0400 (EDT)
In-Reply-To: <20171019145807.23251-17-james.morse@arm.com> (James Morse's
 message of "Thu, 19 Oct 2017 15:58:02 +0100")
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
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 19 2017 at  4:58:02 pm BST, James Morse <james.morse@arm.com> wrote:
> If we deliver a virtual SError to the guest, the guest may defer it
> with an ESB instruction. The guest reads the deferred value via DISR_EL1,
> but the guests view of DISR_EL1 is re-mapped to VDISR_EL2 when HCR_EL2.AMO
> is set.
>
> Add the KVM code to save/restore VDISR_EL2, and make it accessible to
> userspace as DISR_EL1.
>
> Signed-off-by: James Morse <james.morse@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
