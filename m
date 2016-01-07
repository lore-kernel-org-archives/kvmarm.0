From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 03/20] KVM: ARM64: Add offset defines for PMU registers
Date: Thu, 07 Jan 2016 10:23:12 +0000
Message-ID: <568E3C90.4010305@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-4-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-4-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:07, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> We are about to trap and emulate accesses to each PMU register
> individually. This adds the context offsets for the AArch64 PMU
> registers.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
