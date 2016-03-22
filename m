From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH 04/12] kvm-arm: Rename kvm_pmd_huge to huge_pmd
Date: Tue, 22 Mar 2016 10:03:49 +0000
Message-ID: <56F11885.60900@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
 <1457974391-28456-5-git-send-email-suzuki.poulose@arm.com>
 <20160322085532.GC21047@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160322085532.GC21047@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, kvm@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/03/16 08:55, Christoffer Dall wrote:
> On Mon, Mar 14, 2016 at 04:53:03PM +0000, Suzuki K Poulose wrote:
>> kvm_pmd_huge doesn't have any dependency on the page table
>> where the pmd lives (i.e, hyp vs. stage2). So, rename it to
>> huge_pmd() to make it explicit.
>>
>> kvm_p.d_* wrappers will be used for helpers which differ
>> across hyp vs stage2.
>
> I don't understand this commit message.  Do you associate the kvm_
> prefix specifically with one of hyp or stage2?

So the idea is kvm_ prefix will be used for handling either hyp or stage2
depending on what we are dealing with (i.e, kvm parameter to the helpers).

So here, we just want to know if a given pmd represents a huge page, either
via thp or via hugetlb and that doesn't have anything to do with hyp or stage2.
Hence the change. As

>
> I remember reviewers in the past specifically asked to name anything
> relating to pgtable macros in the kvm code with a kvm_ prefix to
> distinguish them from logic used elsewhere in the kernel.

Correct. In this case it doesn't apply to kvm_pmd_huge().

>
> I specifically do not like having huge_pmd() be significantly different
> in logic from pmd_huge(), so defining pmd_thp_or_huge() for arm64 is a
> much better option.

Yes, I have switched to that in the next version.

Thanks
Suzuki

