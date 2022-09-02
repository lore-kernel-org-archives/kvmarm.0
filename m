Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09431ECAAD5
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 14:47:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EAF443C8C;
	Fri,  2 Sep 2022 10:47:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eaae8m6vK+ga; Fri,  2 Sep 2022 10:47:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3272849B07;
	Fri,  2 Sep 2022 10:47:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DAD41173
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G2VAfnddUb9A for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 10:47:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45974410DE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1342FED1;
 Fri,  2 Sep 2022 07:47:50 -0700 (PDT)
Received: from [10.57.45.3] (unknown [10.57.45.3])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D383F3FA27;
 Fri,  2 Sep 2022 07:47:41 -0700 (PDT)
Message-ID: <5413e00f-251f-9d48-9cbb-07742feec87f@arm.com>
Date: Fri, 2 Sep 2022 15:47:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings
 with MTE enabled
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>,
 Peter Collingbourne <pcc@google.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-7-pcc@google.com> <YxII905jjQz0FH4D@arm.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <YxII905jjQz0FH4D@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 02/09/2022 14:45, Catalin Marinas wrote:
> On Wed, Aug 10, 2022 at 12:30:32PM -0700, Peter Collingbourne wrote:
>> Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
>> on being able to map guest memory as MAP_SHARED. The current restriction
>> on sharing MAP_SHARED pages with the guest is preventing the use of
>> those features with MTE. Now that the races between tasks concurrently
>> clearing tags on the same page have been fixed, remove this restriction.
>>
>> Signed-off-by: Peter Collingbourne <pcc@google.com>
>> ---
>>  arch/arm64/kvm/mmu.c | 8 --------
>>  1 file changed, 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index d54be80e31dd..fc65dc20655d 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>>  
>>  static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>>  {
>> -	/*
>> -	 * VM_SHARED mappings are not allowed with MTE to avoid races
>> -	 * when updating the PG_mte_tagged page flag, see
>> -	 * sanitise_mte_tags for more details.
>> -	 */
>> -	if (vma->vm_flags & VM_SHARED)
>> -		return false;
> 
> I think this is fine with the locking in place (BTW, it may be worth
> mentioning in the commit message that it's a relaxation of the ABI). I'd
> like Steven to have a look as well when he gets the time, in case we
> missed anything on the KVM+MTE side.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Looks fine to me, and thanks for doing the work: I was never very
pleased with the !VM_SHARED restriction, but I couldn't figure a good
way of getting the locking to work.

Reviewed-by: Steven Price <steven.price@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
