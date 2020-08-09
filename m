Return-Path: <SRS0=1DcR=BT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D32C433DF
	for <kvmarm@archiver.kernel.org>; Sun,  9 Aug 2020 16:13:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BA352065D
	for <kvmarm@archiver.kernel.org>; Sun,  9 Aug 2020 16:13:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S70c/ofM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BA352065D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E7F4B8DB;
	Sun,  9 Aug 2020 12:13:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kcYZSyWEQ06U; Sun,  9 Aug 2020 12:13:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 552554B8D4;
	Sun,  9 Aug 2020 12:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 265AB4B8D1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Aug 2020 12:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gknMk3avfIcD for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Aug 2020 12:13:14 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564FB4B837
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Aug 2020 12:13:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596989594;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mg/sYUoBZz1byLWR2WieaEgLigz8B2nOGaHe6iDN1Yo=;
 b=S70c/ofMbOcM/tviHBXg8TuFmE8zmGAYpUxcdgwjc04MPUVF49/UG5c9d3x3J2wHmttRwl
 cHutnWZmJ1+ak4O5arPnBVxDhGxvWv/DwxVwknF/6cQd3d6TBCrVlj4wyWZSXW3x8FXaIz
 VYPQ/kMJHMg/VUkcivgC2BCLQI3bMVM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-u5tVcnQLMxqSRK85TK0s5w-1; Sun, 09 Aug 2020 12:13:11 -0400
X-MC-Unique: u5tVcnQLMxqSRK85TK0s5w-1
Received: by mail-wm1-f72.google.com with SMTP id c124so1981955wme.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Aug 2020 09:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=mg/sYUoBZz1byLWR2WieaEgLigz8B2nOGaHe6iDN1Yo=;
 b=cP0XDwggKA8mSE5pR6G5vbu7xN1vhqUupsql3XkPj1jRRQJt9Yzc/A049mDNprnfTc
 ubyixYfF7ousmKtuw3ziRZwTUEG/JhmnHMocu5kuN9Ab48gqeED3CwvuzZ5onASHdDK0
 53qT2Gy2gnAwEdoso2H7xu9UbxGaaPcQKJKGWlc5KiD2Pij+xx4LLy3AnGZ76jvmTE0n
 JLEgMRM+1kF1z0K/4JVZCrqMAJk+ISHGNCT3TTBNZ96F6wYYPq+A2ezYOOCbWvuiC2Ig
 aXmL/+H0rFOcyZvoiEjQZDzNB66gfYpCv875T4TEsAJAVt0+pm/5UydHxrhMV3iFfBOA
 hPow==
X-Gm-Message-State: AOAM532vLy/nrlbeOp8whMd2aOtNc+WYB7Ricmo6n5CmIcC2wv7XpQ0w
 +xlZ9gurByWgK8L9Q9qA8nyTPSJtK0d9j+JNgIOwLHa8pdPaSNwunWZJz/Gvs7vC1Havi1bZStS
 WYfuWWk7l0hrY/dYrEVeR9Sfj
X-Received: by 2002:a7b:cb19:: with SMTP id u25mr20628925wmj.113.1596989590719; 
 Sun, 09 Aug 2020 09:13:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoaRt4v6dETBL0JGQT56R5w6T3hYkaDa6PIHuw8DyoGUmzXuvVwqp9ViRh/pLxUaOaLGmzkA==
X-Received: by 2002:a7b:cb19:: with SMTP id u25mr20628892wmj.113.1596989590465; 
 Sun, 09 Aug 2020 09:13:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8deb:6d34:4b78:b801?
 ([2001:b07:6468:f312:8deb:6d34:4b78:b801])
 by smtp.gmail.com with ESMTPSA id y84sm18313519wmg.38.2020.08.09.09.13.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 09 Aug 2020 09:13:09 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.9
To: Marc Zyngier <maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb8e16e4-ed3c-6cf8-4f21-57d2e6184fb8@redhat.com>
Date: Sun, 9 Aug 2020 18:13:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 05/08/20 19:56, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.9

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
