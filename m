From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 15/27] arm64/sve: Probe SVE capabilities and usable vector
 lengths
Date: Thu, 17 Aug 2017 11:46:12 +0100
Message-ID: <5cd3b5c8-acea-044e-c503-a7e8ad0180f8@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-16-git-send-email-Dave.Martin@arm.com>
 <07268b07-c5f4-38d6-257d-5864cb6752c1@arm.com>
 <20170817100424.GI6321@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E848149C4C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Aug 2017 06:44:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3YAJhCo78nEe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Aug 2017 06:44:29 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEFC449C44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Aug 2017 06:44:29 -0400 (EDT)
In-Reply-To: <20170817100424.GI6321@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/08/17 11:04, Dave Martin wrote:
> On Wed, Aug 16, 2017 at 06:48:01PM +0100, Suzuki K Poulose wrote:
>> On 09/08/17 13:05, Dave Martin wrote:
>>> [This sender failed our fraud detection checks and may not be who they appear to be. Learn about spoofing at http://aka.ms/LearnAboutSpoofing]
>
> Any idea what this is ^ ?  I don't know if this is caused by me or you,
> but I only seem to see it on subthreads you've replied to.
>

Dave,

Sorry about that, should have trimmed that. It looks like the mail server is unhappy
about email received via kvmarm list and I don't know why.

>>
>>> +void __init sve_setup(void)
>>> +{
>>> +       u64 zcr;
>>> +       unsigned int max_vl;
>>> +
>>> +       if (!system_supports_sve())
>>> +               return;
>>> +
>>> +       /*
>>> +        * The architecture mandates 128-bit vectors be supported, and
>>> +        * the code assumes elsewhere that sve_vq_map is non-empty:
>>> +        */
>>> +       BUG_ON(!test_bit(vq_to_bit(1), sve_vq_map));
>>> +
>>> +       sve_vq_map_finalised = true;
>>
>> We have something local in cpufeature.c, sys_caps_initialised. May be we could
>> reuse it here ? With or without that change, FWIW.
>
> I'll take a look at that.  Inventing that here seemed a little ugly, and
> this is all driven from the cpufreatures code anyway now which ensures a
> certain ordering.
>
> If I can reuse sys_caps_initialised for this, I will -- seems pointless
> to reinvent it.

Suzuki
