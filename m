From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3 0/2] kvm: arm/arm64: Fixes for race conditions
Date: Tue, 16 May 2017 11:01:54 +0100
Message-ID: <2b4cd91d-6d0f-3614-faa8-1ebe58bf1313@arm.com>
References: <1494927295-29369-1-git-send-email-suzuki.poulose@arm.com>
 <20170516095318.GA5259@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7418F40A66
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:58:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YbzbEr9F8j-u for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 05:58:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C24640625
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:58:31 -0400 (EDT)
In-Reply-To: <20170516095318.GA5259@cbox>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/17 10:53, Christoffer Dall wrote:
> On Tue, May 16, 2017 at 10:34:53AM +0100, Suzuki K Poulose wrote:
>> The patches fixes race conditions in stage2 pgd accesses.
>>
>> Patch 1 is a fix up for the patch which has already been pushed to
>> kvmarm/master.
>>
>> Patch 2 fixes a case where stage2 PGD could be free'd when we release
>> the kvm->mmu_lock to prevent VCPU starvation.
>>
>> Applies on kvmarm/master tree
>
> Thanks for the rebase and fix.
>
> Applied to master, and for both patches::
>
> Reviewed-by: Christoffer Dall <cdall@linaro.org>
>

Thanks, I think these fixes needs to go to stable as well. I will wait for
these to hit mainline and then send a back port.

Suzuki
