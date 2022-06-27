Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8794AC43334
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jun 2022 15:55:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D97AD4B22C;
	Mon, 27 Jun 2022 11:55:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iMojBhRCLTuC; Mon, 27 Jun 2022 11:55:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 725B44B236;
	Mon, 27 Jun 2022 11:55:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F2D4B208
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 11:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OviPVndQhOQG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 11:55:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 804874B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 11:55:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1656345343;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HuLM69wVueZYYIAkbfqpnLdfUqCDZ1pi8iyqjjngfEM=;
 b=PrhxOpHbxrNBQmQkPNaeO08fkInYZi8CLv7Mg0vb9yUwS3mZMreY09X7XoJgXdzAr6vDFK
 8Nt/IKdAqKleM8XnnTp8B0IMcfUz7Wpc5UpBFHkUilYm6xAK9hgWOqKZG0ozqEOlrlcPdY
 scySTgfLFSE1yJT15VGpWlI8LZS2Tjk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-xBsmTYLoN0ep9wZPhvZvJA-1; Mon, 27 Jun 2022 11:55:36 -0400
X-MC-Unique: xBsmTYLoN0ep9wZPhvZvJA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D72CE3C11E6A;
 Mon, 27 Jun 2022 15:55:35 +0000 (UTC)
Received: from localhost (unknown [10.39.192.87])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 709C5492CA3;
 Mon, 27 Jun 2022 15:55:35 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Steven Price <steven.price@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
In-Reply-To: <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
Organization: Red Hat GmbH
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com> <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date: Mon, 27 Jun 2022 17:55:33 +0200
Message-ID: <875ykmcd8q.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andy Lutomirski <luto@amacapital.net>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

[I'm still in the process of trying to grok the issues surrounding
MTE+KVM, so apologies in advance if I'm muddying the waters]

On Sat, Jun 25 2022, Steven Price <steven.price@arm.com> wrote:

> On 24/06/2022 18:05, Catalin Marinas wrote:
>> + Steven as he added the KVM and swap support for MTE.
>> 
>> On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
>>> Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
>>> depend on being able to map guest memory as MAP_SHARED. The current
>>> restriction on sharing MAP_SHARED pages with the guest is preventing
>>> the use of those features with MTE. Therefore, remove this restriction.
>> 
>> We already have some corner cases where the PG_mte_tagged logic fails
>> even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
>> KVM MAP_SHARED will potentially make things worse (or hard to reason
>> about; for example the VMM sets PROT_MTE as well). I'm more inclined to
>> get rid of PG_mte_tagged altogether, always zero (or restore) the tags
>> on user page allocation, copy them on write. For swap we can scan and if
>> all tags are 0 and just skip saving them.
>> 
>> Another aspect is a change in the KVM ABI with this patch. It's probably
>> not that bad since it's rather a relaxation but it has the potential to
>> confuse the VMM, especially as it doesn't know whether it's running on
>> older kernels or not (it would have to probe unless we expose this info
>> to the VMM in some other way).

Which VMMs support KVM+MTE so far? (I'm looking at adding support in QEMU.)

>> 
>>> To avoid races between multiple tasks attempting to clear tags on the
>>> same page, introduce a new page flag, PG_mte_tag_clearing, and test-set it
>>> atomically before beginning to clear tags on a page. If the flag was not
>>> initially set, spin until the other task has finished clearing the tags.
>> 
>> TBH, I can't mentally model all the corner cases, so maybe a formal
>> model would help (I can have a go with TLA+, though not sure when I find
>> a bit of time this summer). If we get rid of PG_mte_tagged altogether,
>> this would simplify things (hopefully).
>> 
>> As you noticed, the problem is that setting PG_mte_tagged and clearing
>> (or restoring) the tags is not an atomic operation. There are places
>> like mprotect() + CoW where one task can end up with stale tags. Another
>> is shared memfd mappings if more than one mapping sets PROT_MTE and
>> there's the swap restoring on top.
>> 
>>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>>> index f6b00743c399..8f9655053a9f 100644
>>> --- a/arch/arm64/kernel/mte.c
>>> +++ b/arch/arm64/kernel/mte.c
>>> @@ -57,7 +57,18 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
>>>  	 * the new page->flags are visible before the tags were updated.
>>>  	 */
>>>  	smp_wmb();
>>> -	mte_clear_page_tags(page_address(page));
>>> +	mte_ensure_page_tags_cleared(page);
>>> +}
>>> +
>>> +void mte_ensure_page_tags_cleared(struct page *page)
>>> +{
>>> +	if (test_and_set_bit(PG_mte_tag_clearing, &page->flags)) {
>>> +		while (!test_bit(PG_mte_tagged, &page->flags))
>>> +			;
>>> +	} else {
>>> +		mte_clear_page_tags(page_address(page));
>>> +		set_bit(PG_mte_tagged, &page->flags);
>>> +	}
>
> I'm pretty sure we need some form of barrier in here to ensure the tag
> clearing is visible to the other CPU. Otherwise I can't immediately see
> any problems with the approach of a second flag (it was something I had
> considered). But I do also think we should seriously consider Catalin's
> approach of simply zeroing tags unconditionally - it would certainly
> simplify the code.

What happens in kvm_vm_ioctl_mte_copy_tags()? I think we would just end
up copying zeroes?

That said, do we make any assumptions about when KVM_ARM_MTE_COPY_TAGS
will be called? I.e. when implementing migration, it should be ok to
call it while the vm is paused, but you probably won't get a consistent
state while the vm is running?

[Postcopy needs a different interface, I guess, so that the migration
target can atomically place a received page and its metadata. I see
https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/;
has there been any follow-up?]

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
