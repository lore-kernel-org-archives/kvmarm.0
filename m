Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD78C4320A
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 13:44:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 962026109E
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 13:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 962026109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 104A34B10E;
	Thu,  2 Sep 2021 09:44:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OgnR3Q4p8ajK; Thu,  2 Sep 2021 09:44:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D52E4B133;
	Thu,  2 Sep 2021 09:44:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6CA64B131
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 09:44:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v1AdW3WJmgFd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 09:44:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D58F04B129
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 09:44:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630590249;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PRM8lYGUmpsg4gH1Jz3PJxIAnZtJDS7+em5ACTDkhkU=;
 b=T2sQaHX/TcWJ2dahfK5mWTNM7+KrblVFKGdEsrvVUlznzVv9xmQgBbU+yoF5KPL4nLFb1t
 +0pGNHeTIgOYXHjJ09nu/w67yznITVXXgxFfxoJX0Ey+sYl7IEgwNycfziK4hYZxP+ZlYQ
 t3C3YbfeKFRD2rUwusdteme9GDlRMxo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-pSAcI5SLObqhEW8tZ7RFuA-1; Thu, 02 Sep 2021 09:44:08 -0400
X-MC-Unique: pSAcI5SLObqhEW8tZ7RFuA-1
Received: by mail-qk1-f197.google.com with SMTP id
 w2-20020a3794020000b02903b54f40b442so1714317qkd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 06:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PRM8lYGUmpsg4gH1Jz3PJxIAnZtJDS7+em5ACTDkhkU=;
 b=cpkUQDy8uCFZGXvHT5f07CI7em5eEIbxzLPjpqOyxIPg1kxlPI8dRNlMY+vfA/wsqO
 H4dQp5T0zYQpvIUwjfUUtyFHIMSGN5GUp/aEcvC3SYSFk6/yO9bNZWzQndkO11aFMggf
 Rhw/1UW9SJNZIV0/UdweZbalFUdaCj5ZRdXzBhOyEFm3KGTI9KYzlAr1C6a1VbH+BDZJ
 MD1dDQtfpbMgWZT790lq372+dxFo0rpg6uZC+eMEfWiSswZ9AkDAG3WPTNIyS6P01dp0
 GxR4wM1TGgxLtI9DUYySUUl4lPa+9JyqlZ6lycPPBGzXlcFwPOcFEcjyGXgJLAKlst6T
 IYjw==
X-Gm-Message-State: AOAM530J3ewylkxgx/ktHFe4/EL2q57UXqD6gT7a/V83EAVyEe6TCHA6
 kclhIvMVg0eRX/apAtYW6L44OC3nxyUiDtVjvubmAAHQq309DaqSc+FeHOm3fLYfhDLi5Z3DiGP
 Yj3MnPGK4YnNIbAnqO8h093cO
X-Received: by 2002:ae9:ef48:: with SMTP id d69mr3231954qkg.232.1630590247563; 
 Thu, 02 Sep 2021 06:44:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdTmtzmIqhqv1SiL46ML/7VojNuDfGcPgaJcYW31JCHc0kbak0ynOg7JISUhtrJ42VKof4iA==
X-Received: by 2002:ae9:ef48:: with SMTP id d69mr3231851qkg.232.1630590246376; 
 Thu, 02 Sep 2021 06:44:06 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id w11sm1412416qkp.49.2021.09.02.06.44.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 06:44:06 -0700 (PDT)
Date: Thu, 2 Sep 2021 15:44:02 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <20210902134402.zihdyigplaxm432o@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-3-rananta@google.com>
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

On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> For register names that are unsupported by the assembler or the ones
> without architectural names, add the macros write_sysreg_s and
> read_sysreg_s to support them.
> 
> The functionality is derived from kvm-unit-tests and kernel's
> arch/arm64/include/asm/sysreg.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)

If we don't replace with an import of arch/arm64/include/asm/sysreg.h

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
