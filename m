Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17489C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:36:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E4C361027
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8E4C361027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5034B30F;
	Tue,  5 Oct 2021 09:36:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cM151+5R5LGp; Tue,  5 Oct 2021 09:36:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1009E4B302;
	Tue,  5 Oct 2021 09:36:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 355F44B2F3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:36:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jmmcjEFG1-wh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:36:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47EA34B2C4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:36:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633440993;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=spGyJ7Cf8vpJUL593O/kfEmvQHi4gSPemua27E8EnhM=;
 b=jIlr5zym47dNFdKccke7al8tgSLQJaYdHHZsbj5EIZRicCcJifnA+x3sT4kBYleYFEmSDR
 lRLMGF4j2K2oZML4UIjsxbkyfYqXdYUANvoDPh/WIFia4WrkbNtNFxrQ9hrJ7aEnt4vvCe
 xqUUsbiXyemWjoc7MG3o7b1WlvLXJaA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-tQUr84kNMbCEuujqppk_2g-1; Tue, 05 Oct 2021 09:36:32 -0400
X-MC-Unique: tQUr84kNMbCEuujqppk_2g-1
Received: by mail-ed1-f71.google.com with SMTP id
 i7-20020a50d747000000b003db0225d219so3482737edj.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=spGyJ7Cf8vpJUL593O/kfEmvQHi4gSPemua27E8EnhM=;
 b=D5rJNrbgpexl6zlQqJ6muefQVy3wYjoPvyIPPsSyJ4J8sZ0eh2UPy5b32UPIgsTu+q
 cME9bxsg0A53KsVQNO3MVQ1DIWCFzq2/ao6mEspEMsB8VK2NLaNB0aKpZKz50Z7DKj5x
 ic5KkpGXhKPnjaS0audYOhPgmKoZqNMu/Uxcyi+gH+CB+t/Nsmabas6x7D4n+vkTB+kP
 c33+Txc2B/rkXM0z11sZAT9tdjQcCG1yPdGSDZA9w63eDd6d6wF9FwOVlE6xY7OItf+A
 1rpt6rDssq0CgLs7uIQDpAJMc+HnzVnTedHhMGUwsq6W0Mwhlyx05flcjp95dXjhXJnO
 lu6g==
X-Gm-Message-State: AOAM531/GgH6IcScbJ+JgIcmPSdjfDZ+0Qf+Qiw8ksAY900TJPUU/6eR
 LCCAlNxuxsiZwwn/XCa5zs9JhoGYK65oJS5ZEcODHHQkDVYR+ihwHtPX3yL9A860ureU/uWq2F0
 AVssMBJfRACXaJfN2tYoSlhDr
X-Received: by 2002:a50:e188:: with SMTP id k8mr27017974edl.119.1633440990860; 
 Tue, 05 Oct 2021 06:36:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJVRETLF6a+xnd6Ktl0miKR+7KUXqOoxbXOa/2YXRrb3ceS8NbWdz2P9tIxcjJczoiyT/ukQ==
X-Received: by 2002:a50:e188:: with SMTP id k8mr27017950edl.119.1633440990695; 
 Tue, 05 Oct 2021 06:36:30 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id u16sm2811733edy.55.2021.10.05.06.36.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:36:30 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:36:28 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 07/11] selftests: KVM: Rename psci_cpu_on_test to
 psci_test
Message-ID: <20211005133628.xzyftohm2xekaukq@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-8-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-8-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 07:16:06PM +0000, Oliver Upton wrote:
> There are other interactions with PSCI worth testing; rename the PSCI
> test to make it more generic.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore                          | 2 +-
>  tools/testing/selftests/kvm/Makefile                            | 2 +-
>  .../selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c}   | 0
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename tools/testing/selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c} (100%)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 98053d3afbda..a11b89be744b 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /aarch64/debug-exceptions
>  /aarch64/get-reg-list
> -/aarch64/psci_cpu_on_test
> +/aarch64/psci_test
>  /aarch64/vgic_init
>  /s390x/memop
>  /s390x/resets
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5d05801ab816..6907ee8f3239 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -86,7 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> -TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
> +TEST_GEN_PROGS_aarch64 += aarch64/psci_test
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> similarity index 100%
> rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> rename to tools/testing/selftests/kvm/aarch64/psci_test.c
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
