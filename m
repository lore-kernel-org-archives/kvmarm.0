From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Tue, 7 Feb 2017 19:36:08 -0500
Message-ID: <f677c76d-8e2c-2762-bad2-8ef5b030eb45@codeaurora.org>
References: <36478002-4cd8-7f1c-1a25-8bfe35022a47@codeaurora.org>
 <3cab36fb-984a-beae-64db-6ce830ba94f6@arm.com>
 <b4cf83d2-ae05-3362-bc23-2341d00516dc@codeaurora.org>
 <20170201163358.GG8177@arm.com>
 <20170201173609.GE26507@e104818-lin.cambridge.arm.com>
 <20170201174105.GK8177@arm.com>
 <20170201174934.GF26507@e104818-lin.cambridge.arm.com>
 <20170201175947.GL8177@arm.com>
 <20170201182244.GH26507@e104818-lin.cambridge.arm.com>
 <20170201183400.GA31652@arm.com>
 <20170201183812.GI26507@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB88140A3C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Feb 2017 19:35:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P+pB3bw90qci for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Feb 2017 19:35:41 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2F0240A2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Feb 2017 19:35:41 -0500 (EST)
In-Reply-To: <20170201183812.GI26507@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Leeder <nleeder@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/01/2017 01:38 PM, Catalin Marinas wrote:
> On Wed, Feb 01, 2017 at 06:34:01PM +0000, Will Deacon wrote:
>> On Wed, Feb 01, 2017 at 06:22:44PM +0000, Catalin Marinas wrote:
>>> On Wed, Feb 01, 2017 at 05:59:48PM +0000, Will Deacon wrote:
>>>> On Wed, Feb 01, 2017 at 05:49:34PM +0000, Catalin Marinas wrote:
>>>>> On Wed, Feb 01, 2017 at 05:41:05PM +0000, Will Deacon wrote:
>>>>>> Maybe
>>>>>> just select ARM64_PAN if the erratum workaround is selected, then
>>>>>> runtime warning if we find that the h/w doesn't have PAN but does have
>>>>>> the erratum (which should never fire)?
>>>>>
>>>>> You still need this workaround even if you don't want any PAN (both sw
>>>>> and hw PAN disabled). I wouldn't want to select ARM64_PAN since it's not
>>>>> a dependency. It's more like if you do need a PAN, make sure you only
>>>>> use the hw one.
>>>>
>>>> True, in the case that all PAN options are disabled we still want this
>>>> to work. How about:
>>>>
>>>>   select ARM64_PAN if ARM64_SW_TTBR0_PAN
>>>
>>> As I replied to myself, the above would work for me as well, so let's go
>>> for this.
>>>
>>>> In fact, what's the reason for supporting SW_PAN and ARM64_PAN as a
>>>> config combination? Why not just have "PAN" that enables them both and
>>>> uses the hardware feature if it's there?
>>>
>>> Because SW PAN has a non-trivial performance hit. You would enable SW
>>> PAN only if you are paranoid about security. HW PAN, OTOH, is very cheap
>>> and I wouldn't want to miss enabling it in a single Image supporting
>>> ARMv8.0 and ARMv8.1 just because SW PAN is slow on ARMv8.0.
>>>
>>> IOW, ARM64_PAN is default y while ARM64_SW_TTBR0_PAN is default n.
>>
>> Ok, in that case, then how about another permutation: we make
>> ARM64_SW_TTBR0_PAN depend on ARM64_PAN? Then when you select "PAN Support"
>> you get a new menu option underneath it for the emulation? I think that
>> solves the erratum case and the use-case above.
> 
> The problem is that ARM64_PAN is an ARMv8.1 feature and currently
> grouped accordingly in Kconfig. ARM64_SW_TTBR0_PAN is complementary (and
> even not recommended on ARMv8.1). We can do this if we break the ARMv8.x
> feature grouping but just for this erratum, I don't think it's worth.

Thanks all. I've used "select ARM64_PAN if ARM64_SW_TTBR0_PAN" in v6.

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
