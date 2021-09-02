Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B14C4320A
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 13:46:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 057CD610CD
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 13:46:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 057CD610CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7504B4B10E;
	Thu,  2 Sep 2021 09:46:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V--mlK7O1nOx; Thu,  2 Sep 2021 09:46:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D20C4B134;
	Thu,  2 Sep 2021 09:46:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 688824B0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 09:46:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gqm2PaiFWL4Z for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 09:46:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99EBE4B10E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 09:46:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630590369;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PcQKXY/cQKOdShIe+YVlSE7XvlfimtQWI3kVCVJqZrE=;
 b=b1vzPZ9JXu6L4cVcxglXRIxWoBlHaNFzfNCD16uPWuJtdIGzE1muhCtqUpgQLo+uk7PxNL
 qE4v6sP3bVJgP0lZAwNCONOyQ9/dyywl1crKQfpH6jvdVQctCmUbjr0U7l38y3j6BAHsfv
 BX89nUKMUDI+DKq6nBs3w2R8QWDMKMk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-fkhahTlZNI2YUl6uQYEAMA-1; Thu, 02 Sep 2021 09:46:08 -0400
X-MC-Unique: fkhahTlZNI2YUl6uQYEAMA-1
Received: by mail-qt1-f199.google.com with SMTP id
 n19-20020ac81e13000000b0029f679691eeso1268285qtl.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 06:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PcQKXY/cQKOdShIe+YVlSE7XvlfimtQWI3kVCVJqZrE=;
 b=PP79PSAdc8KAsGbCXQNFQupZL1Y/UYuRvjQBN7QHkjEeaHYBR6k9nNqse74VzqK76r
 wAdr39KpYJ5PK8xFB1OAEFfpCEkxzjagv3dNoHNqPDp69CEoglVIsHeROpSBOjMdmqIK
 aaCTu9DNG+RX4Ts0exKLyscpm6TvHT2vzEkGH0sffGMzdANY5XQ+adfc5b/s4/JOCPaz
 ot5CGmSj7Ev2qRAHDXQi1eiVywb0pU8l59GRj56UfaPF1EK+DTdW3SdolhQGcc2nE+C1
 JxWkWe6X4H0zlqgim1cPA4P7UznlIM38XT67cNYv/5rPs14TsQ39HIIvRC6EACsFQyUB
 C9FA==
X-Gm-Message-State: AOAM533U75f2PrSbttB+qsdxRge+4clGx+wE9YJCw9dWaTMasSPk5N2l
 Q/v3LE2LkqvOQ6iKzzWhGSKgKCff7jZnKGyI+QY8CQn54D7EjQUVEp+TrGXftrNiKMEfM5mB15m
 SW1V1bWtfkQ9Ag4NoofzkDmjQ
X-Received: by 2002:a0c:d804:: with SMTP id h4mr3371873qvj.37.1630590368132;
 Thu, 02 Sep 2021 06:46:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx83mm+WcK2lvoIW0v47pEySyGsM3Sm0Io+mwVAic5avZpGftQiWmMPlQQwHQjgqGnarNFYXg==
X-Received: by 2002:a0c:d804:: with SMTP id h4mr3371853qvj.37.1630590367962;
 Thu, 02 Sep 2021 06:46:07 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id d20sm1413091qkl.13.2021.09.02.06.46.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 06:46:07 -0700 (PDT)
Date: Thu, 2 Sep 2021 15:46:03 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
Message-ID: <20210902134603.zqdaqa4yfndi2dmc@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-4-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-4-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 01, 2021 at 09:14:03PM +0000, Raghavendra Rao Ananta wrote:
> Implement the guest helper routine, cpu_relax(), to yield
> the processor to other tasks.
> 
> The function was derived from
> arch/arm64/include/asm/vdso/processor.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
>  1 file changed, 5 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
