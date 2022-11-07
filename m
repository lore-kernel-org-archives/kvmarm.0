Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49534C4332F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 17:16:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B585A4B836;
	Mon,  7 Nov 2022 12:16:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5vK5C+VcXPGJ; Mon,  7 Nov 2022 12:16:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AE0E4B869;
	Mon,  7 Nov 2022 12:16:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2A024B84E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:16:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H+NAaI4cC3sx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 12:16:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9B74B836
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:16:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667841398;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sAQme1GAbPodTq1JRNMk+uId/J7lODmXvvWt4/unp6w=;
 b=IPIjgiHTMEhIXqNMwKPFcKLYwz3rqWGxMJg5SGk5XJBaazUtvWmHYgIRkdajOFAqV/gEcQ
 DTTfYM/h5YuYYTea3TxH3FOcIhO9fYnGsIwmQwBZgKo6uEYc7IFL1BICzm1d/6vkiXRD5W
 jPu3ux8DMkZ8Ou/AgpCnH88fGPkMQMA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-ukFuae4ENwyQK-cdkoEeEA-1; Mon, 07 Nov 2022 12:16:35 -0500
X-MC-Unique: ukFuae4ENwyQK-cdkoEeEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CC881C07596;
 Mon,  7 Nov 2022 17:16:34 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EAB3A140EBF5;
 Mon,  7 Nov 2022 17:16:33 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v5 5/8] arm64: mte: Lock a page for MTE tag initialisation
In-Reply-To: <20221104011041.290951-6-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-6-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Mon, 07 Nov 2022 18:16:32 +0100
Message-ID: <87iljq3csv.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

On Thu, Nov 03 2022, Peter Collingbourne <pcc@google.com> wrote:

> From: Catalin Marinas <catalin.marinas@arm.com>
>
> Initialising the tags and setting PG_mte_tagged flag for a page can race
> between multiple set_pte_at() on shared pages or setting the stage 2 pte
> via user_mem_abort(). Introduce a new PG_mte_lock flag as PG_arch_3 and
> set it before attempting page initialisation. Given that PG_mte_tagged
> is never cleared for a page, consider setting this flag to mean page
> unlocked and wait on this bit with acquire semantics if the page is
> locked:
>
> - try_page_mte_tagging() - lock the page for tagging, return true if it
>   can be tagged, false if already tagged. No acquire semantics if it
>   returns true (PG_mte_tagged not set) as there is no serialisation with
>   a previous set_page_mte_tagged().
>
> - set_page_mte_tagged() - set PG_mte_tagged with release semantics.
>
> The two-bit locking is based on Peter Collingbourne's idea.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Steven Price <steven.price@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/include/asm/mte.h     | 35 +++++++++++++++++++++++++++++++-
>  arch/arm64/include/asm/pgtable.h |  4 ++--
>  arch/arm64/kernel/cpufeature.c   |  2 +-
>  arch/arm64/kernel/mte.c          | 12 +++--------
>  arch/arm64/kvm/guest.c           | 16 +++++++++------
>  arch/arm64/kvm/mmu.c             |  2 +-
>  arch/arm64/mm/copypage.c         |  2 ++
>  arch/arm64/mm/fault.c            |  2 ++
>  arch/arm64/mm/mteswap.c          | 14 +++++--------
>  9 files changed, 60 insertions(+), 29 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
