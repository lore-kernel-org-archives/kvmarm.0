From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 00/23] arm64: Virtualization Host Extension support
Date: Fri, 5 Feb 2016 08:56:00 +0000
Message-ID: <56B463A0.7010801@arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <20160204192641.GJ13974@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD47E48529
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 03:50:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CYF7XnrAagmU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2016 03:50:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6633241AF6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 03:50:32 -0500 (EST)
In-Reply-To: <20160204192641.GJ13974@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/02/16 19:26, Christoffer Dall wrote:
> On Wed, Feb 03, 2016 at 05:59:53PM +0000, Marc Zyngier wrote:
>> ARMv8.1 comes with the "Virtualization Host Extension" (VHE for
>> short), which enables simpler support of Type-2 hypervisors.
>>
>> This extension allows the kernel to directly run at EL2, and
>> significantly reduces the number of system registers shared between
>> host and guest, reducing the overhead of virtualization.
>>
>> In order to have the same kernel binary running on all versions of the
>> architecture, this series makes heavy use of runtime code patching.
>>
>> The first 22 patches massage the KVM code to deal with VHE and enable
>> Linux to run at EL2. The last patch catches an ugly case when VHE
>> capable CPUs are paired with some of their less capable siblings. This
>> should never happen, but hey...
>>
>> I have deliberately left out some of the more "advanced"
>> optimizations, as they are likely to distract the reviewer from the
>> core infrastructure, which is what I care about at the moment.
>>
>> Note: GDB is currently busted on VHE systems, as it checks for version
>>       6 on the debug architecture, while VHE is version 7. The
>>       binutils people are on the case.
>>
>> This has been tested on the FVP_Base_SLV-V8-A model, and based on
>> v4.5-rc2. I've put a branch out on:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vhe
>>
> 
> You can have my reviewed-by on all patches that I didn't already review
> or ack explicitly.

Thanks for the review, much appreciated.

> Only exception is the debug stuff where I didn't manage to page in the
> context, so hopefully familiar with that code can have a look.

I think this will have to be Mr Deacon.

Thanks again,

	M.
-- 
Jazz is not dead. It just smells funny...
