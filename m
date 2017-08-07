From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: pass vcpu esr_el2 and far_el2 sysre to user space
Date: Mon, 07 Aug 2017 20:07:12 +0100
Message-ID: <86r2wnxkm7.fsf@arm.com>
References: <1502133454-5905-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502133454-5905-1-git-send-email-gengdongjiu@huawei.com>
        (Dongjiu Geng's message of "Tue, 8 Aug 2017 03:17:34 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 08 2017 at  3:17:34 am BST, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> For the firmware-first RAS solution, SEA and SEI is injected
> by the user space, user space needs to know the vcpu's esr_el2 and
> far_el2 value, so add them to sysreg. user space uses
> the IOCTL KVM_GET_ONE_REG can get their value.

Are we playing a game here? Look at my earlier reply: No _EL2 register
will ever be exposed as such to userspace in the context of an EL1 VM.

So if you want that information, extract it, expose what is required,
strictly what is required, and only when it is required.

In the meantime, I'm NAKing this patch, and any patch that will expose
_EL2 registers outside of nested virtualization.

	M.
-- 
Jazz is not dead. It just smells funny.
