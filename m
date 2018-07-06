From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 06/16] arm64/sve: Determine virtualisation-friendly
 vector lengths
Date: Fri, 6 Jul 2018 14:20:38 +0100
Message-ID: <c37dbbd8-8ed5-3114-ba9d-248baa59a659@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-7-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C6549E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 09:08:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6pQk7bostdM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 09:08:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C16408B1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 09:08:09 -0400 (EDT)
In-Reply-To: <1529593060-542-7-git-send-email-Dave.Martin@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 21/06/18 15:57, Dave Martin wrote:
> Software at EL1 is permitted to assume that when programming
> ZCR_EL1.LEN, the effective vector length is nonetheless a vector
> length supported by the CPU.  Thus, software may rely on the
> effective vector length being different from that programmed via
> ZCR_EL1.LEN in some situations.
> 
> However, KVM does not tightly bind vcpus to individual underlying
> physical CPUs.  As a result, vcpus can migrate from one CPU to
> another.  This means that in order to preserve the guarantee
> described in the previous paragraph, the set of supported vector
> lengths must appear to be the same for the vcpu at all times,
> irrespective of which physical CPU the vcpu is currently running
> on.
> 
> The Arm SVE architecture allows the maximum vector length visible
> to EL1 to be restricted by programming ZCR_EL2.LEN.  This provides
> a means to hide from guests any vector lengths that are not
> supported by every physical CPU in the system.  However, there is
> no way to hide a particular vector length while some greater vector
> length is exposed to EL1.
> 
> This patch determines the maximum vector length
> (sve_max_virtualisable_vl) for which the set of supported vector
> lengths not exceeding it is identical for all CPUs.  When KVM is
> available, the set of vector lengths supported by each late
> secondary CPU is verified to be consistent with those of the early
> CPUs, in order to ensure that the value chosen for
> sve_max_virtualisable_vl remains globally valid, and ensure that
> all created vcpus continue to behave correctly.
> 
> sve_secondary_vq_map is used as scratch space for these
> computations, rendering its name misleading.  This patch renames
> this bitmap to sve_tmp_vq_map in order to make its purpose clearer.

I'm slightly put off by this patch.

While it does a great job making sure we're always in a situation where
we can offer SVE to a guest, no matter how utterly broken the system is,
I wonder if there is a real value in jumping through all these hoops the
first place.

It is (sort of) reasonable to support a system that has different max
VLs (big-little) and cap it at the minimum of the max VLs (just like we
do for userspace). But I don't think it is reasonable to consider
systems that have different supported VLs in that range, and I don't
think any system exhibit that behaviour.

To put it another way, if a "small" CPU's supported VLs are not a strict
prefix of the "big" ones', we just disable SVE support in KVM. I'd be
tempted to do the same thing for userspace too, but that's a separate
discussion.

Can we turn this patch into one that checks the above condition instead
of trying to cope with an unacceptable level of braindeadness?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
