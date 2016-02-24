From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Feed initialized memory to MMIO accesses
Date: Wed, 24 Feb 2016 12:06:52 +0000
Message-ID: <56CD9CDC.2020100@arm.com>
References: <1455723260-23793-1-git-send-email-marc.zyngier@arm.com>
 <20160224114044.GA18451@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AC83410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 07:00:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XUASCPQnbECQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 07:00:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 383D0410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 07:00:11 -0500 (EST)
In-Reply-To: <20160224114044.GA18451@cbox>
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
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/02/16 11:40, Christoffer Dall wrote:
> On Wed, Feb 17, 2016 at 03:34:20PM +0000, Marc Zyngier wrote:
>> On an MMIO access, we always copy the on-stack buffer info
>> the shared "run" structure, even if this is a read access.
>> This ends up leaking up to 8 bytes of uninitialized memory
>> into userspace.
> 
> I think it only leaks 'len' bytes to userspace ;)
> 
>>
>> An obvious fix for this one is to only perform the copy if
>> this is an actual write.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks. I've pushed this onto master, with a view of sending a PR to
Paolo this evening (hopefully the last one for this cycle).

	M.
-- 
Jazz is not dead. It just smells funny...
