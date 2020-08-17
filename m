Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D6CC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:53:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 368282067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="an7O0aBs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 368282067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7504BF91;
	Mon, 17 Aug 2020 04:53:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bRuQqAcgDgSX; Mon, 17 Aug 2020 04:53:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD974BF7D;
	Mon, 17 Aug 2020 04:53:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C9484BF7A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:53:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bQcrjYGkR-Ny for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 04:53:09 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 813C44BF71
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:53:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597654389;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=0YghR5Mms8jHBUWQxThuVTLlaBCYQmrwY5aHeC7UwVY=;
 b=an7O0aBsWCgLmaoRMMhgf6p/ja2PpOG8Nk++ie1nAq9bqqUbxqpoPJ9tnlhrxt4kqMBvfB
 LCiZTEW+21OkbA63xkBlfh3CI24KPUP0CcUHz9G3RMmYq7czqgH5rdXYOfdEcp4zo5BM5Q
 riF8PydvAgO/07SJqJOXVknF0lUvFss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-M9b1GrjmO6u9o76KkD9vjw-1; Mon, 17 Aug 2020 04:53:05 -0400
X-MC-Unique: M9b1GrjmO6u9o76KkD9vjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E445425EF;
 Mon, 17 Aug 2020 08:53:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.210])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B4A4100EBA4;
 Mon, 17 Aug 2020 08:53:00 +0000 (UTC)
Date: Mon, 17 Aug 2020 10:52:57 +0200
From: Andrew Jones <drjones@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Use kvm_write_guest_lock when init
 stolen time
Message-ID: <20200817085257.k3i2nyhqn2nwdotx@kamzik.brq.redhat.com>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-4-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200817033729.10848-4-zhukeqian1@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Aug 17, 2020 at 11:37:29AM +0800, Keqian Zhu wrote:
> There is a lock version kvm_write_guest. Use it to simplify code.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  arch/arm64/kvm/pvtime.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index f7b52ce..2b24e7f 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -55,7 +55,6 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	struct pvclock_vcpu_stolen_time init_values = {};
>  	struct kvm *kvm = vcpu->kvm;
>  	u64 base = vcpu->arch.steal.base;
> -	int idx;
>  
>  	if (base == GPA_INVALID)
>  		return base;
> @@ -66,10 +65,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	 */
>  	vcpu->arch.steal.steal = 0;
>  	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> -
> -	idx = srcu_read_lock(&kvm->srcu);
> -	kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
> -	srcu_read_unlock(&kvm->srcu, idx);
> +	kvm_write_guest_lock(kvm, base, &init_values, sizeof(init_values));
>  
>  	return base;
>  }
> -- 
> 1.8.3.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
