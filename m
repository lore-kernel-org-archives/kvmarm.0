Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B22C48BD1
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 12:17:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEA7161042
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 12:17:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEA7161042
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5CF49E8A;
	Thu, 10 Jun 2021 08:17:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SXig6zCfWebr; Thu, 10 Jun 2021 08:17:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3970A49E57;
	Thu, 10 Jun 2021 08:17:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F4E49E57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 08:17:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iXI5Y2b5H8XQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 08:17:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A40AD406DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 08:17:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623327448;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Uv0xs33ewLzq+ryxudIHULBGFCkV88+uHAen7THruNI=;
 b=S73SkCAggSd7OwHoMUfLKqFS3n2mH/P+QgRNF1aWi/VnY8dt8Qo1kr11TIB/xEht3nMGSJ
 8qhmtOsnY8vTtPe2TmPgDNyTzk94gSLI6sv/vLhvrATKx5LgFiB0mDjotXudFmFtCJEXkT
 KkKVSGW45b2GZK7Zg2i1t1FuAR9d4iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-C_LD9CEhMAKT2zbl-a5lDw-1; Thu, 10 Jun 2021 08:17:25 -0400
X-MC-Unique: C_LD9CEhMAKT2zbl-a5lDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EDAB8042B7;
 Thu, 10 Jun 2021 12:17:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com
 (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9EEFC18B42;
 Thu, 10 Jun 2021 12:17:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/7] unify header guards
Date: Thu, 10 Jun 2021 08:17:19 -0400
Message-Id: <162332742682.173232.8556399043091141939.b4-ty@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 kvm-ppc@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, 9 Jun 2021 16:37:05 +0200, Cornelia Huck wrote:
> This is an extension of "s390x: unify header guards" to the rest
> of kvm-unit-tests. I tried to choose a pattern that minimizes the
> changes; most of them are for s390x and x86.
> 
> v1->v2:
> - change the patterns and document them
> - change other architectures and architecture-independent code as well
> 
> [...]

Applied, thanks!

[1/7] README.md: add guideline for header guards format
      commit: 844669a9631d78a54b47f6667c9a2750b65d101c
[2/7] lib: unify header guards
      commit: 9f0ae3012430ed7072d04247fb674125c616a6b4
[3/7] asm-generic: unify header guards
      commit: 951e6299b30016bf04a343973296c4274e87f0e2
[4/7] arm: unify header guards
      commit: 16f52ec9a4763e62e35453497e4f077031abcbfb
[5/7] powerpc: unify header guards
      commit: 040ee6d9aee563b2b1f28e810c5e36fbbcc17bd9
[6/7] s390x: unify header guards
      commit: eb5a1bbab00619256b76177e7a88cfe05834b026
[7/7] x86: unify header guards
      commit: c865f654ffe4c5955038aaf74f702ba62f3eb014

Best regards,
-- 
Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
