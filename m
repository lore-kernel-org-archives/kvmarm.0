Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2E9C3A5A1
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:37:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B52B6205ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:37:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B52B6205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8E84A5B3;
	Thu, 22 Aug 2019 06:37:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NsFEEWFBqaZs; Thu, 22 Aug 2019 06:37:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E484A590;
	Thu, 22 Aug 2019 06:37:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DAD4A590
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 06:37:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xiitHVQ0xWOZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 06:37:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290CC4A58E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 06:37:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF26615AD;
 Thu, 22 Aug 2019 03:37:09 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4D2C3F246;
 Thu, 22 Aug 2019 03:37:07 -0700 (PDT)
Subject: Re: [PATCH v3 04/10] KVM: Implement kvm_put_guest()
To: Jonathan Cameron <jonathan.cameron@huawei.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-5-steven.price@arm.com>
 <20190822112930.000052db@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <003f509f-964b-2af0-d5da-1155fb4ec9d6@arm.com>
Date: Thu, 22 Aug 2019 11:37:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822112930.000052db@huawei.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 22/08/2019 11:29, Jonathan Cameron wrote:
> On Wed, 21 Aug 2019 16:36:50 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
>> kvm_put_guest() is analogous to put_user() - it writes a single value to
>> the guest physical address. The implementation is built upon put_user()
>> and so it has the same single copy atomic properties.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  include/linux/kvm_host.h | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index fcb46b3374c6..e154a1897e20 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -746,6 +746,30 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>>  				  unsigned long len);
>>  int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>>  			      gpa_t gpa, unsigned long len);
>> +
>> +#define __kvm_put_guest(kvm, gfn, offset, value, type)			\
>> +({									\
>> +	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
>> +	type __user *__uaddr = (type __user *)(__addr + offset);	\
>> +	int __ret = 0;							\
> 
> Why initialize __ret?

Good question. Actually looking at this again if I reorder this to be
pessimistic I can make it shorter:

	int __ret = -EFAULT;

	if (!kvm_is_error_hva(__addr))
		__ret = put_user(value, __uaddr);
	if (!__ret)
		mark_page_dirty(kvm, gfn);				
	__ret;

Thanks for taking a look.

Steve

>> +									\
>> +	if (kvm_is_error_hva(__addr))					\
>> +		__ret = -EFAULT;					\
>> +	else								\
>> +		__ret = put_user(value, __uaddr);			\
>> +	if (!__ret)							\
>> +		mark_page_dirty(kvm, gfn);				\
>> +	__ret;								\
>> +})
>> +
>> +#define kvm_put_guest(kvm, gpa, value, type)				\
>> +({									\
>> +	gpa_t __gpa = gpa;						\
>> +	struct kvm *__kvm = kvm;					\
>> +	__kvm_put_guest(__kvm, __gpa >> PAGE_SHIFT,			\
>> +			offset_in_page(__gpa), (value), type);		\
>> +})
>> +
>>  int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
>>  int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
>>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
