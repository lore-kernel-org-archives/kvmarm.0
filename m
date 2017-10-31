From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 15/21] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Tue, 31 Oct 2017 06:34:32 +0000
Message-ID: <86tvyf3jwn.fsf@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-16-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0EE049D24
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 02:33:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gu53yidTi62W for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 02:33:02 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7837549D23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 02:33:02 -0400 (EDT)
In-Reply-To: <20171019145807.23251-16-james.morse@arm.com> (James Morse's
 message of "Thu, 19 Oct 2017 15:58:01 +0100")
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

On Thu, Oct 19 2017 at  4:58:01 pm BST, James Morse <james.morse@arm.com> wrote:
> Prior to v8.2's RAS Extensions, the HCR_EL2.VSE 'virtual SError' feature
> generated an SError with an implementation defined ESR_EL1.ISS, because we
> had no mechanism to specify the ESR value.
>
> On Juno this generates an all-zero ESR, the most significant bit 'ISV'
> is clear indicating the remainder of the ISS field is invalid.
>
> With the RAS Extensions we have a mechanism to specify this value, and the
> most significant bit has a new meaning: 'IDS - Implementation Defined
> Syndrome'. An all-zero SError ESR now means: 'RAS error: Uncategorized'
> instead of 'no valid ISS'.
>
> Add KVM support for the VSESR_EL2 register to specify an ESR value when
> HCR_EL2.VSE generates a virtual SError. Change kvm_inject_vabt() to
> specify an implementation-defined value.
>
> We only need to restore the VSESR_EL2 value when HCR_EL2.VSE is set, KVM
> save/restores this bit during __deactivate_traps() and hardware clears the
> bit once the guest has consumed the virtual-SError.
>
> Future patches may add an API (or KVM CAP) to pend a virtual SError with
> a specified ESR.
>
> Cc: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
