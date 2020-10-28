Return-Path: <SRS0=GiKq=ED=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D7EC388F7
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 05:53:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F44222282
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 05:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvdFihtV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F44222282
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6474F4B42A;
	Wed, 28 Oct 2020 01:53:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ugRdAcZf1MWD; Wed, 28 Oct 2020 01:53:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 343A34B418;
	Wed, 28 Oct 2020 01:53:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B418F4B417
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 01:53:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lQOG5L+cRS6O for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2020 01:53:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A80B74B3D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 01:53:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603864393;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=14PjKJXyYqZi3FLgU7TINf/mpQJsDgXBWZTjkzU6Ja8=;
 b=HvdFihtVTdqxwKqKISr+siHqjnV6uDZix7c9NbJXhVe0qtVWoYXKVgalcYLPSVldEUequP
 eQ/FWsY88oGEj9SpAuycxgBwy4DIl44AfOIRh+N4pSJW6mDib+nnUl0Z+6RVl3OBBfVEmL
 9w2IZbrSg11pWFGO/eAMgO66TKD1hnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-Y4RCt1lgMw2Yr72NMa_8FA-1; Wed, 28 Oct 2020 01:52:29 -0400
X-MC-Unique: Y4RCt1lgMw2Yr72NMa_8FA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00D1C1007382;
 Wed, 28 Oct 2020 05:52:28 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 836585B4B3;
 Wed, 28 Oct 2020 05:52:26 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Allocate stage-2 pgd pages with
 GFP_KERNEL_ACCOUNT
To: Will Deacon <will@kernel.org>
References: <20201026144423.24683-1-will@kernel.org>
 <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
 <20201027092720.GB26019@willie-the-truck>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <f453962b-6575-d56c-9b13-7ff674d05240@redhat.com>
Date: Wed, 28 Oct 2020 16:52:23 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20201027092720.GB26019@willie-the-truck>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 10/27/20 8:27 PM, Will Deacon wrote:
> On Tue, Oct 27, 2020 at 10:41:33AM +1100, Gavin Shan wrote:
>> On 10/27/20 1:44 AM, Will Deacon wrote:
>>> For consistency with the rest of the stage-2 page-table page allocations
>>> (performing using a kvm_mmu_memory_cache), ensure that __GFP_ACCOUNT is
>>> included in the GFP flags for the PGD pages.
>>>
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: Quentin Perret <qperret@google.com>
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>> ---
>>>    arch/arm64/kvm/hyp/pgtable.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>
>> The patch itself looks good to me:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>> Another question is why the page-table pages for hyp mode aren't
>> allocated with __GFP_ACCOUNT in kvm_pgtable_hyp_init and hyp_map_walker()?
>> The page-table pages for host or guest are allocated with GFP_PGTABLE_USER
>> in alloc_pte_one().
>>
>> #define GFP_PGTABLE_USER      (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
>> #define GFP_PGTABLE_KERNEL    (GFP_KERNEL | __GFP_ZERO)
> 
> I think because the guest pages are allocated as a direct result of the VMM,
> whereas I tend to think of the hyp page-tables more like kernel page-tables
> (which aren't accounted afaik: see GFP_PGTABLE_USER vs GFP_PGTABLE_KERNEL).
> 

Assume qemu is the only userspace counter-part. qemu is the process and could
be put into one cgroup (memory cgroup specificly). Without __GFP_ACCOUNT,
the memory consumed by page-table isn't limited by cgroup policies. I'm not
sure if this is exactly what we want, even it's trivial in terms of the issue
itself and the amount of consumed memory.

Cheers,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
