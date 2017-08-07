From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v2] KVM: arm64: pass vcpu esr_el2 and far_el2 sysre to
 user space
Date: Tue, 8 Aug 2017 07:53:36 +0800
Message-ID: <4f79970c-5341-f8ef-56bc-e0a9cf227363@huawei.com>
References: <1502133454-5905-1-git-send-email-gengdongjiu@huawei.com>
 <86r2wnxkm7.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86r2wnxkm7.fsf@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Marc,

On 2017/8/8 3:07, Marc Zyngier wrote:
> So if you want that information, extract it, expose what is required,
> strictly what is required, and only when it is required.
> 
> In the meantime, I'm NAKing this patch, and any patch that will expose
> _EL2 registers outside of nested virtualization.
Thanks for your comments, I will follow your suggestion.
