Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2EFC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 07:07:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2887661101
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 07:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2887661101
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95EF14B107;
	Thu,  9 Sep 2021 03:07:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XvdygnkLgPCh; Thu,  9 Sep 2021 03:07:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B10E54B10A;
	Thu,  9 Sep 2021 03:07:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D98694B107
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 03:07:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rhEiF9Gqejsi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 03:07:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFFCA40623
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 03:07:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631171271;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=O79oda6oITB+svfgMKtqjlq0+9nk7Bi2GmbowOW2Zec=;
 b=aoXZvNBQGMeoAizpgdYOoMHglwirweX/MOiQLBghU4dmXJWE6+3DiuPCuI2Cocvtjm6dst
 n5QdWn2p1BGy9FMDD/z3rAdai6MwGILIMchUx1wAG+07Tq7sbos3DzvyjDbFs7i9kU1UGW
 XrNO/Dl9efnv6nPdTg2U4ZviU0x/jKg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-djQ8mw2dMNqZjCQCfld4eA-1; Thu, 09 Sep 2021 03:07:50 -0400
X-MC-Unique: djQ8mw2dMNqZjCQCfld4eA-1
Received: by mail-ej1-f69.google.com with SMTP id
 q19-20020a1709064cd3b02904c5f93c0124so324617ejt.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 00:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=O79oda6oITB+svfgMKtqjlq0+9nk7Bi2GmbowOW2Zec=;
 b=X6PUGTDoFGOjQHN6i00GSrgPUYhEIZ0ouZsvQ8GHt9PoOQ9xZz61bZKqqhqyBRC1BL
 VcL4CGSaBbUWMdFM7t3UXMTXCwe49ja56iyLNFftk1Lp8Jmn5xIj1BHjoAYRbP7XRE5V
 QEwDSbDuNUrQ5aZPTq4WduzeFXo0sKdlTnGJUbddqO9s9kryf9RDLcWpay6JqMdJT5hw
 DTeKEBnwBg5rQJ3h1x3pR59J4w7OvcrdvGl6DfOeKfHq2kSJreGcgwfEqGkVr3V7G0nt
 y/+gye+nrV5Xojrx9kLbnCpoBQPgD2rGWZlFm1sO0hBUMo0pTw4n0EuQUI9cQB3r2BKH
 C8HA==
X-Gm-Message-State: AOAM532vz045MSgaU4Uv6e4ybo1RHgmHRlCUQa6kHqwYxpXUpYJbCmvU
 3TMtDdInly6/Eev4G5pPU2/rnUKFXXBareJY4e54ByhR9b3LZL7U93RgS0UHCGAyZ+6I+Oacvsg
 Up4GXK/WPPsnaOtSWLA2lChXk
X-Received: by 2002:a17:906:51d4:: with SMTP id
 v20mr1836648ejk.9.1631171269420; 
 Thu, 09 Sep 2021 00:07:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWLGtXgDgvvwtsziSdTGYQx3QchauqHAmrovAlFNC3f5RBpcB0TkK+8vK0bXB5KE9/b8E1Hg==
X-Received: by 2002:a17:906:51d4:: with SMTP id
 v20mr1836629ejk.9.1631171269284; 
 Thu, 09 Sep 2021 00:07:49 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id s18sm425034ejh.12.2021.09.09.00.07.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 00:07:49 -0700 (PDT)
Date: Thu, 9 Sep 2021 09:07:47 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 06/18] KVM: arm64: selftests: Add basic support for
 arch_timers
Message-ID: <20210909070747.5vgud3ssccpo7z2o@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-7-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210909013818.1191270-7-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 09, 2021 at 01:38:06AM +0000, Raghavendra Rao Ananta wrote:
> Add a minimalistic library support to access the virtual timers,
> that can be used for simple timing functionalities, such as
> introducing delays in the guest.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../kvm/include/aarch64/arch_timer.h          | 142 ++++++++++++++++++
>  1 file changed, 142 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
