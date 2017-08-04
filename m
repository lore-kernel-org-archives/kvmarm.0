From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH][RESEND] arm64: kvm: reuse existing cache type/info
 related macros
Date: Fri, 4 Aug 2017 14:18:01 +0100
Message-ID: <5267f4a8-7c0d-a37f-5823-ce3385b629b8@arm.com>
References: <1501851237-13017-1-git-send-email-sudeep.holla@arm.com>
 <20170804130854.GB27784@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 779A749C2A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 09:16:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yh8gau6PHPsh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Aug 2017 09:16:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75EC749C28
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 09:16:38 -0400 (EDT)
In-Reply-To: <20170804130854.GB27784@cbox>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/08/17 14:08, Christoffer Dall wrote:
> Hi Sudeep,
> 
> On Fri, Aug 04, 2017 at 01:53:57PM +0100, Sudeep Holla wrote:
>> We already have various macros related to cache type and bitfields in
>> CLIDR system register. We can replace some of the hardcoded values
>> here using those existing macros.
>>
>> This patch reuses those existing cache type/info related macros and
>> replaces the hardcorded values. It also removes some of the comments
>> that become trivial with the macro names.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> ---
>>  arch/arm64/include/asm/cache.h |  7 +++++++
>>  arch/arm64/kernel/cacheinfo.c  |  7 -------
>>  arch/arm64/kvm/sys_regs.c      | 29 +++++++++++++++--------------
>>  3 files changed, 22 insertions(+), 21 deletions(-)
>>
>> Hi,
>>
>> I dropped the support for 64bit format CCSIDR after Will's commit a8d4636f96ad
>> ("arm64: cacheinfo: Remove CCSIDR-based cache information probing"). However
>> I forgot to follow up on this patch which can be still applied. So just
>> reposting again rebasing on v4.13-rc3 as mentioned by Will as it was too
>> late for last cycle. Christoffer was fine with the changes but has not
>> given an official ACK.
>>
> 
> Reviewed-by: Christoffer Dall <cdall@linaro.org>
> 
Thanks for the quick response and review tag.

-- 
Regards,
Sudeep
