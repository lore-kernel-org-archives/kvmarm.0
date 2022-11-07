Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80576C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 17:10:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6D44B864;
	Mon,  7 Nov 2022 12:10:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id or0V+w+ze-q4; Mon,  7 Nov 2022 12:10:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 942354B869;
	Mon,  7 Nov 2022 12:10:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8C34B84E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:10:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bPwQBA-4A0ty for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 12:10:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E765E4B823
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:10:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667841050;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rfFJYesx+4rIOVCmddyPJXOJt2foLuyf55xGPHLwEB4=;
 b=QCLcSjSkQde+9sk7Inu0d0l4BpEgCVjC6N1BejCLR+Ip0NkncdNRNdVNCsgJpVtjE3pYiB
 tbV9SmYHc1vxfNDhZ37LAg5lHZHht85YxwzTnsKq6ZW86pLtuBGur9m5ur68xr+VNdUYFy
 bPwBbFzJqjCBrbOkvkh8rbXOdMR9X+k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-jX9ggGZMMGWvypVznMMVmw-1; Mon, 07 Nov 2022 12:10:46 -0500
X-MC-Unique: jX9ggGZMMGWvypVznMMVmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3A3A1C087BA;
 Mon,  7 Nov 2022 17:10:42 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A499D1401C3B;
 Mon,  7 Nov 2022 17:10:41 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v5 3/8] KVM: arm64: Simplify the sanitise_mte_tags() logic
In-Reply-To: <20221104011041.290951-4-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-4-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Mon, 07 Nov 2022 18:10:39 +0100
Message-ID: <87leom3d2o.fsf@redhat.com>
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
> Currently sanitise_mte_tags() checks if it's an online page before
> attempting to sanitise the tags. Such detection should be done in the
> caller via the VM_MTE_ALLOWED vma flag. Since kvm_set_spte_gfn() does
> not have the vma, leave the page unmapped if not already tagged. Tag
> initialisation will be done on a subsequent access fault in
> user_mem_abort().
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [pcc@google.com: fix the page initializer]
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Steven Price <steven.price@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 40 +++++++++++++++-------------------------
>  1 file changed, 15 insertions(+), 25 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
