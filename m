Return-Path: <SRS0=W6Rg=6S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFF8C4724C
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 17:02:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BE42206D9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 17:02:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmA84onE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BE42206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A32194B3EC;
	Mon,  4 May 2020 13:02:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wAErPrAxyISf; Mon,  4 May 2020 13:02:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF19B4B43C;
	Mon,  4 May 2020 13:02:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0B5A4B3EC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 13:02:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RFSVOgArU2op for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2020 13:02:33 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E384B434
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 13:02:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1588611753;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DsuiJ3Bl4DYlwcJ0OMVfbSTOPgPDHtHw1erBIpHZk74=;
 b=ZmA84onEXF1RVLzshkZF8wEUEU5PxO4BoTZkqC1K2YEzBD/9Nn+T8291vqPOyOxQuQRQrA
 QtcqBolgfCzG+JENkqvtwdtmRgBl2dVyz1VcxNiF+pV1p5G+YobkFRGF2aBYgLYpWeEB4e
 IZw5mz6ZivI1ie8TsPLXD8tmQpNOpxk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-KVcNzISHMZKQTQ-vR31nvg-1; Mon, 04 May 2020 13:02:31 -0400
X-MC-Unique: KVcNzISHMZKQTQ-vR31nvg-1
Received: by mail-wm1-f72.google.com with SMTP id u11so114785wmc.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2020 10:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=DsuiJ3Bl4DYlwcJ0OMVfbSTOPgPDHtHw1erBIpHZk74=;
 b=rLCCXiwF9LpwcOBzpTdd44WOjUJ2C93TdtpMk/x0Af4Avbz+YfJZ165YqOkHSz0hxb
 C7aQy2AU+5xjLN4ruRHH8+vuupLoM1pak043MTuGARqXz75kovp6IU73RfrTXTrqY8we
 nh8oocdnnMque7bCZCW4lVD46owoSTP+DiQ/vyLH7Bh9lOUlnXlErWi+4HHdq0fI24OZ
 WMTXnYHEJ/WcAcDRTOAlA5+fYRpgit2t38CtNKgFDWtOeGeqe1Lai5cMCiVx6dIbi0GL
 zSzOJL7jVH7iL1iFOh3AiV015fuKJCVtEPLvBWfsL0/Z5+SnzM2UgWFZ94W6XvisZJyC
 h5Cw==
X-Gm-Message-State: AGi0PuZPlWCnzuDX/SF4ru5tVGbLvIwRZGaRatEQpU/ZqMYWgQUOabj7
 2SPvJ5cfV1hsHd7i4Ntfate/s8lshN/i0ntNc3m83IzeDIjsGhXpEAk73mCwLLziZtcNKe+0THB
 +qlOisLJjVqjCDIaA/R19Jr76
X-Received: by 2002:a5d:628e:: with SMTP id k14mr270958wru.390.1588611750792; 
 Mon, 04 May 2020 10:02:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ/Yx8kOwELdCr6LNcodfCIoQBcpJd3XJQs7+YRpB/STWPwshDBcVODsO4ViVUHu2CMySHdIQ==
X-Received: by 2002:a5d:628e:: with SMTP id k14mr270926wru.390.1588611750534; 
 Mon, 04 May 2020 10:02:30 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
 by smtp.gmail.com with ESMTPSA id h137sm1233255wme.0.2020.05.04.10.02.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 04 May 2020 10:02:30 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.7, take #2
To: Will Deacon <will@kernel.org>
References: <20200501101204.364798-1-maz@kernel.org>
 <20200504113051.GB1326@willie-the-truck>
 <df78d984-6ce3-f887-52a9-a3e9164a6dee@redhat.com>
 <20200504165132.GA1833@willie-the-truck>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e715659-112d-febd-91c8-385e272d2425@redhat.com>
Date: Mon, 4 May 2020 19:02:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504165132.GA1833@willie-the-truck>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Fangrui Song <maskray@google.com>,
 Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
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

On 04/05/20 18:51, Will Deacon wrote:
>> 10 days is one week during which I could hardly work and the two
>> adjacent weekends.  So this is basically really bad timing in Marc's
>> first pull request, that he couldn't have anticipated.
> 
> Understood, and thanks for the quick reply. If possible, please just let us
> know in future as we can probably figure something out rather than having
> things sit in limbo.

Indeed, it was my fault.  I got stuck in a "1: tomorrow should be
better" / "no it was actually worse" / "goto 1b" loop.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
