Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9F3C433ED
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 11:02:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 23E6E6121D
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 11:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E6E6121D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8CF4B456;
	Mon,  3 May 2021 07:02:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 80I5EjtKnjR2; Mon,  3 May 2021 07:02:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 747724B45B;
	Mon,  3 May 2021 07:02:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 563C54B3E8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 07:02:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L+EL9E+R+cG8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 07:02:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A49004B368
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 07:02:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620039753;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/EWTxxOMyJ8o5vQqPG2GzHZg6NeXROGBPlWyiCjpcdE=;
 b=R6N9wgYzQSDcmBKSjgF3z4fE8gCGMC6CtwVwNVoW2OZTMVRwHhOyH2qx4Q9Dsq3L7FNdwm
 zDkk60gFvzdo6TlqwrQqZynfnbjmWMrN1/cM7Ls8OVP7bJPi3fRW08yWVM0Wo9ZVUESf+x
 7wqeUGKeBLH+EVy4vwb1w4Aq+md6HSc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-e8waMxUhO3iq2XPmyz-z3A-1; Mon, 03 May 2021 07:02:32 -0400
X-MC-Unique: e8waMxUhO3iq2XPmyz-z3A-1
Received: by mail-ed1-f71.google.com with SMTP id
 s20-20020a0564025214b029038752a2d8f3so4307268edd.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 May 2021 04:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/EWTxxOMyJ8o5vQqPG2GzHZg6NeXROGBPlWyiCjpcdE=;
 b=bYMCugby/cDGb9jTKVY+bs55SlzKr0IFRSKAvx6tJJ+n3561mco7EU38ZJI+ZHrM+Y
 Xc7yVr+qxFGeZvSmDu2rkxJ0ASfzPrhHVh7I3xCMgzBuKrS0Sj2zaeoknVixzHs1tA7l
 SdwWP8l1l6J1z1pSU60Sl4QS5R+bkfGCPUQ3j7hLDObOgNYZ+ZI6ODDkAQ/HbsjHKtOl
 pzR1ZTV3ZHd1W6+JFVuoBxrRByi4S6ULU8BZ8Iqg/Plw7sKcdvGE6JtrEcYct0OGfjG0
 HWXfY60xDixWtRhwbvz3L1crP3YZ8DBYFf0Lc3UqOEkjNZjaekTBQxvMdc6iUrxWLepG
 EP+w==
X-Gm-Message-State: AOAM5320Q/YGmw3VnntwfxsBwbSqlmLtjSsQU9q7q2Q/NhKBsYC6Uejq
 5Fk5fE0K8QPHl8mVlfqHWzhwMat9PWpZwcadgTXP43sm6vvVu2fE9gGFjcXXukWGo1pcOm15jtA
 KpT5cYUI8l67Qv9C1Ta4CWSKW
X-Received: by 2002:a05:6402:105a:: with SMTP id
 e26mr19293177edu.164.1620039751026; 
 Mon, 03 May 2021 04:02:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylvnp9X0+uVBO9kOzAkvwMm/5iedsAamzZstZykQGU7cKIbzwdsosMtEaYT37CgFxd2xM9kQ==
X-Received: by 2002:a05:6402:105a:: with SMTP id
 e26mr19293100edu.164.1620039750229; 
 Mon, 03 May 2021 04:02:30 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id re14sm11068149ejb.20.2021.05.03.04.02.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 03 May 2021 04:02:29 -0700 (PDT)
Date: Mon, 3 May 2021 13:02:28 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 1/5] KVM: selftests: Rename vm_handle_exception
Message-ID: <20210503110228.646nvqd3ickuolbu@gator.home>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-2-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210430232408.2707420-2-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
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

On Fri, Apr 30, 2021 at 04:24:03PM -0700, Ricardo Koller wrote:
> Rename the vm_handle_exception function to a name that indicates more
> clearly that it installs something: vm_install_vector_handler.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
>  5 files changed, 9 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
