Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E2CECAAD8
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 21:39:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76C5D4B2B7;
	Thu, 22 Sep 2022 17:39:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ygtdgjz91YIO; Thu, 22 Sep 2022 17:39:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287414B282;
	Thu, 22 Sep 2022 17:39:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D6804B282
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:39:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OjuWGf-3++29 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 17:39:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 048E943479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:39:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663882751;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=oggKyBrtLm+rbie47pghj85Ta1UvbEqK5VovLbBRoGo=;
 b=EFve9zOb3Y+B3eeOuv3BGvpHPi82afI8nOTKL2CRosWdhAHfmbBi2h45/fPmjbAMZuojbH
 r3raFinAY4Qccm9BXiaO7HL7LZzf21SweNAVy/Lkp2wgPVXUjYLUt49abVDEaggdxTlEop
 V9AxCsIiTSvZP4ODaEygvso2U0QOSxQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-Y2TYNpImMnC74qVuMNYWlg-1; Thu, 22 Sep 2022 17:39:10 -0400
X-MC-Unique: Y2TYNpImMnC74qVuMNYWlg-1
Received: by mail-qv1-f72.google.com with SMTP id
 f9-20020ad442c9000000b004ac7f4fde18so7348010qvr.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=oggKyBrtLm+rbie47pghj85Ta1UvbEqK5VovLbBRoGo=;
 b=5xONftWrg0f3x9bL8/VUeQYv4KXj7fmauyl+kzW54vvL5FJooUDEfUZ5ZBp5pVbaHZ
 GRfZA27H4Jgsf7ewW6rNpP+wWqI+nhwGdVopW430ffL2EQSYK6fQoR9QEAXcRIjiFhEi
 4C5FjayB5w3FDStQanMuqO1uck2foaj3NccBk1n6OxXDBTAGl8+Jmg9u+Yf805n4HE0/
 UH0BchCi4e/uUOj2X+W9LX02DkKVykzodRjWBBFPOIGI4kdR9lU3IZd2OD9gtuU1hNTa
 WGjp9xnSVgANVt8zXhZZBQ+I/4piD1UJaYWVH2bqIf9aAsXVu1GYl7g4Lg2gaq9WIaxq
 ZqxA==
X-Gm-Message-State: ACrzQf0SFCD/O/o5cYzXM2VOeo4QQVCk1oB5jZrzY19hU4gN0+S+cBrZ
 VxDYfsWOg6lMFqxso1e6fJSZB5kIDfHY27kqpgvvNcJcXI7C6Eg1kJguqp/sPII4oEtx+OJH7F3
 hR011LaZs5xNP8325dbpcaggfGR1Qxr/wlUgLk5ri
X-Received: by 2002:a05:620a:3725:b0:6ce:e7b3:d8e4 with SMTP id
 de37-20020a05620a372500b006cee7b3d8e4mr3683713qkb.144.1663882750100; 
 Thu, 22 Sep 2022 14:39:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5odouBoqKR/EFtNQzxBQaOSq4hKEp3fsEc1XCoKzSGpvsyUKt27I1oSmXbqRykom5IjyysB3VvrBo9iRJBy2s=
X-Received: by 2002:a05:620a:3725:b0:6ce:e7b3:d8e4 with SMTP id
 de37-20020a05620a372500b006cee7b3d8e4mr3683680qkb.144.1663882749867; Thu, 22
 Sep 2022 14:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-6-maz@kernel.org>
In-Reply-To: <20220922170133.2617189-6-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 22 Sep 2022 23:38:58 +0200
Message-ID: <CABgObfbtVAM3t2WC6-8-fLdQZTs6B5Xf2-CZ4oWdJMzXNFWy_g@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: selftests: dirty-log: Upgrade
 dirty_gfn_set_collected() to store-release
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 22, 2022 at 7:02 PM Marc Zyngier <maz@kernel.org> wrote:
> To make sure that all the writes to the log marking the entries
> as being in need of reset are observed in order, use a
> smp_store_release() when updating the log entry flags.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

You also need a load-acquire on the load of gfn->flags in
dirty_gfn_is_dirtied. Otherwise reading cur->slot or cur->offset might
see a stale value.

Paolo

> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 9c883c94d478..3d29f4bf4f9c 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -17,6 +17,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/atomic.h>
> +#include <asm/barrier.h>
>
>  #include "kvm_util.h"
>  #include "test_util.h"
> @@ -284,7 +285,7 @@ static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
>
>  static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
>  {
> -       gfn->flags = KVM_DIRTY_GFN_F_RESET;
> +       smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
>  }
>
>  static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
> --
> 2.34.1
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
