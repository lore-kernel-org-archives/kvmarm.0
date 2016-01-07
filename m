From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 01/20] ARM64: Move PMU register related defines to
 asm/pmu.h
Date: Thu, 07 Jan 2016 10:20:21 +0000
Message-ID: <568E3BE5.8080000@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-2-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:07, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> To use the ARMv8 PMU related register defines from the KVM code,
> we move the relevant definitions to asm/pmu.h header file.
> 
> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
