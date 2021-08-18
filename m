Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EDEC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 14:42:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07974610CF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 14:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07974610CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B354A523;
	Wed, 18 Aug 2021 10:42:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XWjveilVq+Lc; Wed, 18 Aug 2021 10:42:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ABAE4A524;
	Wed, 18 Aug 2021 10:42:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3B84A524
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 10:42:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dn9f5nVKRPc2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 10:42:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F7DD4A523
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 10:42:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1629297734;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=oHOC6qM8SYsxg5GXK1RakJzITqPj1QkZBCg9QMQDUco=;
 b=ExDE5HSdvxpSgkFmK6WH6dgfpnc2brl5eRmmiNZF5QGM/c5EjvNxZjtNMezcaJ/wZGZqLc
 M9iTIwhWyheo7SrpIaMTA9SLidqUMUMqWt2kU61SdP5UlKxTcaemXRAEcX4pygs44kk6+X
 ozKoGfxOzcYAutmYPgq7UaxhtttvhiQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-1hnvb22VMTCxJQPBB6sklw-1; Wed, 18 Aug 2021 10:42:10 -0400
X-MC-Unique: 1hnvb22VMTCxJQPBB6sklw-1
Received: by mail-ed1-f72.google.com with SMTP id
 di3-20020a056402318300b003bebf0828a2so1163790edb.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 07:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oHOC6qM8SYsxg5GXK1RakJzITqPj1QkZBCg9QMQDUco=;
 b=T7hViRZG9Nt95VWKCysamQ4SyprJrM/Rxanh6OBozHn4Z5zdEfQ25GPCIAR4jvNLFa
 PVwbS0rXVt5fCeoDOaIcfnrDI5NzrsPKraX/SAu6K5vVpOKft/Cd6HPhDK3tRi8ru9Of
 gPHv7zwbq+nWZRywevl8r3B2rDzeV3Cw+d6P0ZWQvaXnSjum/dBVcTUHwSJbeEwBqdSM
 BIg9csij2v80Lgr1UJnwCBkK5DZgudHHFTVDSc/TCEZq7a147aozmNs7AwTns3yojmID
 kcqFAwxKDcdHBlk9gWRqwXLPDrnZwALZFueDR5iuRi8XlM9tHs6j/z/R41WAz+UMksr0
 5J/Q==
X-Gm-Message-State: AOAM5311EYg43FQjj90l7UPWy7OxHvNk8JOLKw1MwPb6xsKjc7mxIf21
 +PuxvCrqLg8xZVKvEt/ATAPadsvaBFM3tDFZ5AyJn9LDHz10MsZ0ozvltK46draYM6a5kc9rqdX
 JIXJGL7mF6Xk1bw7hrKNPvB7/
X-Received: by 2002:a17:906:769a:: with SMTP id
 o26mr10260118ejm.18.1629297729773; 
 Wed, 18 Aug 2021 07:42:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsUMjWsJZkdAO5Ia6PsQSh8NFeDEF2eu0vMI7nX2SYA8sWVGkvZya4kW3CwJkzpaxp1jcgJQ==
X-Received: by 2002:a17:906:769a:: with SMTP id
 o26mr10260095ejm.18.1629297729568; 
 Wed, 18 Aug 2021 07:42:09 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id a2sm112760edm.72.2021.08.18.07.42.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Aug 2021 07:42:09 -0700 (PDT)
Date: Wed, 18 Aug 2021 16:42:07 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 4/4] selftests: KVM: Introduce psci_cpu_on_test
Message-ID: <20210818144207.o7ycdaiy5iyap63k@gator.home>
References: <20210818085047.1005285-1-oupton@google.com>
 <20210818085047.1005285-5-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210818085047.1005285-5-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
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

On Wed, Aug 18, 2021 at 08:50:47AM +0000, Oliver Upton wrote:
> Introduce a test for aarch64 that ensures CPU resets induced by PSCI are
> reflected in the target vCPU's state, even if the target is never run
> again. This is a regression test for a race between vCPU migration and
> PSCI.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |   3 +
>  4 files changed, 126 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
