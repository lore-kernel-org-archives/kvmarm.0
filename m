Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024AAC38145
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 10:26:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 516DD4B2A3;
	Fri,  2 Sep 2022 06:26:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5jwoUuzQ21tk; Fri,  2 Sep 2022 06:26:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E544B274;
	Fri,  2 Sep 2022 06:26:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A494B242
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 06:26:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aksZLrkHk0mc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 06:26:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EAFF401AF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 06:26:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1662114392;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/3Op2YuEkkBOG1RJWqT1GBeAbr2w0wiiubsVaWhZ/YI=;
 b=i5RqvA4pWZLyipplRlBJKRnWnpaiDJt+FZN/f9q+NZdtvm6MmJMymhUo8vx40RETykslN7
 xUbknSTN69sbzR2iQwbxPKW93t5/5cT4aVdHFZa6DwgWBmx4lfm1r4gX41MlGJ+4xtbLtp
 7Zdq+8iuQQviMDLbkCW1kZMBeobmMrM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-hZDcB34nPOuFTpVlcDXXzg-1; Fri, 02 Sep 2022 06:26:28 -0400
X-MC-Unique: hZDcB34nPOuFTpVlcDXXzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DA41811130;
 Fri,  2 Sep 2022 10:26:27 +0000 (UTC)
Received: from localhost (unknown [10.39.193.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 121CCC15BC0;
 Fri,  2 Sep 2022 10:26:26 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 1/7] arm64: mte: Fix/clarify the PG_mte_tagged semantics
In-Reply-To: <20220810193033.1090251-2-pcc@google.com>
Organization: Red Hat GmbH
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-2-pcc@google.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date: Fri, 02 Sep 2022 12:26:25 +0200
Message-ID: <87k06mdqcu.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: kvm@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Steven Price <steven.price@arm.com>,
 Marc Zyngier <maz@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Will Deacon <will@kernel.org>, Evgenii Stepanov <eugenis@google.com>
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

On Wed, Aug 10 2022, Peter Collingbourne <pcc@google.com> wrote:

> From: Catalin Marinas <catalin.marinas@arm.com>
>
> Currently the PG_mte_tagged page flag mostly means the page contains
> valid tags and it should be set after the tags have been cleared or
> restored. However, in mte_sync_tags() it is set before setting the tags
> to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
> shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
> write in another thread can cause the new page to have stale tags.
> Similarly, tag reading via ptrace() can read stale tags of the

s/of/if/

> PG_mte_tagged flag is set before actually clearing/restoring the tags.
>
> Fix the PG_mte_tagged semantics so that it is only set after the tags
> have been cleared or restored. This is safe for swap restoring into a
> MAP_SHARED or CoW page since the core code takes the page lock. Add two
> functions to test and set the PG_mte_tagged flag with acquire and
> release semantics. The downside is that concurrent mprotect(PROT_MTE) on
> a MAP_SHARED page may cause tag loss. This is already the case for KVM
> guests if a VMM changes the page protection while the guest triggers a
> user_mem_abort().
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
> v3:
> - fix build with CONFIG_ARM64_MTE disabled
>
>  arch/arm64/include/asm/mte.h     | 30 ++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/pgtable.h |  2 +-
>  arch/arm64/kernel/cpufeature.c   |  4 +++-
>  arch/arm64/kernel/elfcore.c      |  2 +-
>  arch/arm64/kernel/hibernate.c    |  2 +-
>  arch/arm64/kernel/mte.c          | 12 +++++++-----
>  arch/arm64/kvm/guest.c           |  4 ++--
>  arch/arm64/kvm/mmu.c             |  4 ++--
>  arch/arm64/mm/copypage.c         |  4 ++--
>  arch/arm64/mm/fault.c            |  2 +-
>  arch/arm64/mm/mteswap.c          |  2 +-
>  11 files changed, 51 insertions(+), 17 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
