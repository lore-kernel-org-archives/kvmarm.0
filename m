Return-Path: <SRS0=W6Rg=6S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCBCC3A5A9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 16:06:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCF1A206D9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 16:06:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B9z05d8v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCF1A206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 495474B3FF;
	Mon,  4 May 2020 12:06:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sauCEzSbKJAt; Mon,  4 May 2020 12:06:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 546C34B319;
	Mon,  4 May 2020 12:06:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66D164B319
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 12:05:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2LqufCI9qbYH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2020 12:05:58 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0994B314
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 12:05:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1588608358;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/JVeck58huMvFA8/TA03p+8Qjm09cOK85lDBTKzlyGU=;
 b=B9z05d8vQkpj6fdvbsuISg4YlXI58wbKM69Kq0TiCoJA43zKGYKx/qRoj78FNLR6OD/sDl
 hPQqWUAkfnKx+zZ91zIwk5cmAV0dDahYm9AS9Db9VIIfPMcjkDqKSyh3nvVFnQCNVJ8u8v
 cXn3i/6nzsKl7lS3PvUu8yRi1/Bxfk8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-axckyV62ML2Y9tDvVh1DEA-1; Mon, 04 May 2020 12:05:54 -0400
X-MC-Unique: axckyV62ML2Y9tDvVh1DEA-1
Received: by mail-wm1-f69.google.com with SMTP id 71so16512wmb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2020 09:05:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=/JVeck58huMvFA8/TA03p+8Qjm09cOK85lDBTKzlyGU=;
 b=rd7TxZiiWfWC+4iPa5jl91pN9cWj3v27Fgtfm5Quw6h/ka+M20EhV/7yO6EKRypa8R
 W9NnhbA0Pb/YV96/NqgmDptQuIYcZYouQj1eKGmSHKt38qbuNwBdq6CqiF9JlZb0CyKx
 IAnFVcsjLx4jfXv/xskFgcNmFTmoWQXiszQO0bixgjh8xcMeSBDcXT0HrRVQb6x5HkfF
 qoCr7xeQeIhLlu0b3f0Eb897KCst8lwrpNikY9jsedmNkqVDc1qTUt7YX5EoRrfjOiLz
 1bRi2krltC7UsAVKDBWLWNpNZ/nl1rR69gGZHlUpEl8f5RgG8rRBkO0IWTL4c05L6rDP
 ES0g==
X-Gm-Message-State: AGi0PuYKkuNWoNYY3RTbzmUzHe9SXuu9c34GE/SGR5HO7dnFJFYlE3c9
 r+ueTKgukeP1OzjUlrrA4q0mIJJUZZS/oQD5emjRuB7m5BCS6bnwnKiQdoVES/IxJc+A+l9+1Vp
 4dHDUyW8h+Dgegr38pXO/iQju
X-Received: by 2002:a1c:4e16:: with SMTP id g22mr14716565wmh.157.1588608353301; 
 Mon, 04 May 2020 09:05:53 -0700 (PDT)
X-Google-Smtp-Source: APiQypLl+FvW2SgRJan9DFKftDDZJg4qPN8I25yOxi5TFHxm89GNl7rDCkuf9ca4ZxOYRM+JtKXkfg==
X-Received: by 2002:a1c:4e16:: with SMTP id g22mr14716532wmh.157.1588608353041; 
 Mon, 04 May 2020 09:05:53 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
 by smtp.gmail.com with ESMTPSA id n7sm1072795wrm.86.2020.05.04.09.05.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 04 May 2020 09:05:52 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.7, take #2
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20200501101204.364798-1-maz@kernel.org>
 <20200504113051.GB1326@willie-the-truck>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <df78d984-6ce3-f887-52a9-a3e9164a6dee@redhat.com>
Date: Mon, 4 May 2020 18:05:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504113051.GB1326@willie-the-truck>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Fangrui Song <maskray@google.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 04/05/20 13:30, Will Deacon wrote:
> I don't see this queued up in the kvm tree, which appears to have been
> sitting dormant for 10 days. Consequently, there are fixes sitting in
> limbo and we /still/ don't have a sensible base for arm64/kvm patches
> targetting 5.8.
> 
> Paolo -- how can I help get this stuff moving again? I'm more than happy
> to send this lot up to Linus via arm64 if you're busy atm. Please just
> let me know.

10 days is one week during which I could hardly work and the two
adjacent weekends.  So this is basically really bad timing in Marc's
first pull request, that he couldn't have anticipated.

I have pulled both trees now, so you can base 5.8 development on
kvm/master.  It will get to Linus in a couple days.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
