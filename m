From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3] KVM: arm/arm64: fix the incompatible matching for external abort
Date: Sun, 29 Oct 2017 01:12:32 +0000
Message-ID: <861slmaha7.fsf@arm.com>
References: <1509173159-30579-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509173159-30579-1-git-send-email-gengdongjiu@huawei.com>
        (Dongjiu Geng's message of "Sat, 28 Oct 2017 14:45:59 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, huangshaoyu@huawei.com, wuquanming@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 28 2017 at  2:45:59 pm BST, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> For this matching, switch expression uses fault type which is
> not {I,D}FSC value, but the case expression uses {I,D}FSC,
> they are incompatible. So change the switch expression to
> use {I,D}FSC.

I'm sorry, but I can't manage to parse this commit message. How about
something like this?

"kvm_vcpu_dabt_isextabt() tries to match a full fault syndrome, but
 calls kvm_vcpu_trap_get_fault_type() that only returns the fault class,
 thus reducing the scope of the check. This doesn't cause any observable
 bug yet as we end-up matching a closely related syndrome for which we
 return the same value.

 Using kvm_vcpu_trap_get_fault() instead fixes it for good"

Otherwise:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
