From: Adam Wallis <awallis@codeaurora.org>
Subject: Re: [PATCHv4 06/10] arm64: add basic pointer authentication support
Date: Tue, 22 May 2018 15:08:42 -0400
Message-ID: <4b394038-ffd7-ef28-faaf-00f91febf54a@codeaurora.org>
References: <20180503132031.25705-1-mark.rutland@arm.com>
 <20180503132031.25705-7-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503132031.25705-7-mark.rutland@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 5/3/2018 9:20 AM, Mark Rutland wrote:
> This patch adds basic support for pointer authentication, allowing
> userspace to make use of APIAKey. The kernel maintains an APIAKey value
> for each process (shared by all threads within), which is initialised to
> a random value at exec() time.
> 
> To describe that address authentication instructions are available, the
> ID_AA64ISAR0.{APA,API} fields are exposed to userspace. A new hwcap,
> APIA, is added to describe that the kernel manages APIAKey.
> 
> Instructions using other keys (APIBKey, APDAKey, APDBKey) are disabled,
> and will behave as NOPs. These may be made use of in future patches.
> 
> No support is added for the generic key (APGAKey), though this cannot be
> trapped or made to behave as a NOP. Its presence is not advertised with
> a hwcap.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---


Mark, I was able to verify that a buffer overflow exploit results in a segfault
with these PAC patches. When I compile the same binary without
"-msign-return-address=none", I am able to successfully overflow the stack and
execute malicious code.

Thanks
Adam

Tested-by: Adam Wallis <awallis@codeaurora.org>


-- 
Adam Wallis
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
