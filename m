From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH] kvm-arm: Unmap shadow pagetables properly
Date: Fri, 9 Sep 2016 11:43:42 +0100
Message-ID: <8dd3078a-40ca-9f1f-e536-91e2dbd59907@arm.com>
References: <1473348349-5011-1-git-send-email-suzuki.poulose@arm.com>
 <20160909103844.GA8624@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160909103844.GA8624@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, itaru.kitayama@riken.jp, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/09/16 11:38, Christoffer Dall wrote:
> Hi Suzuki,
>
> On Thu, Sep 08, 2016 at 04:25:49PM +0100, Suzuki K Poulose wrote:

>> This patch fixes the issue by moving the kvm_free_stage2_pgd() to
>> kvm_arch_flush_shadow_all().
>
> Awesome, thanks!
>
> I suppose this is a cc stable patch since as I can tell this bug has
> been here forever.

Yes, I think the code moved around a bit in the past. I will submit the
patches separately for each version once I get ack on this.

Cheers
Suzuki

