From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH] arm64: Implement branch predictor hardening for Falkor
Date: Mon, 8 Jan 2018 13:10:39 -0600
Message-ID: <01fe1f41-ac45-0c19-a502-77b915c48fcf@codeaurora.org>
References: <1515184139-23743-1-git-send-email-shankerd@codeaurora.org>
 <20180108170933.GU25869@arm.com> <20180108184446.GC13175@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180108184446.GC13175@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 01/08/2018 12:44 PM, Will Deacon wrote:
> On Mon, Jan 08, 2018 at 05:09:33PM +0000, Will Deacon wrote:
>> On Fri, Jan 05, 2018 at 02:28:59PM -0600, Shanker Donthineni wrote:
>>> Falkor is susceptible to branch predictor aliasing and can
>>> theoretically be attacked by malicious code. This patch
>>> implements a mitigation for these attacks, preventing any
>>> malicious entries from affecting other victim contexts.
>>
>> Thanks, Shanker. I'll pick this up (fixing the typo pointed out by Drew).
> 
> Note that MIDR_FALKOR doesn't exist in mainline, so I had to drop those
> changes too. See the kpti branch for details.
> 

The FALKOR MIDR patch is already available in the upstream kernel v4.15-rc7
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64?h=v4.15-rc7&id=c622cc013cece073722592cff1ac6643a33b1622

If you want I can resend the above patch in v2 series including typo fix.

> If you'd like anything else done here, please send additional patches to me
> and Catalin that we can apply on top of what we currently have. Note that
> I'm in the air tomorrow, so won't be picking up email.
> 
> Cheers,
> 
> Will
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
