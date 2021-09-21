Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9441C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:11:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 547B561100
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:11:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 547B561100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F5B4B1B4;
	Wed, 22 Sep 2021 09:11:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i1L1hDpftzwJ; Wed, 22 Sep 2021 09:11:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53FD54B165;
	Wed, 22 Sep 2021 09:11:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E2A4064F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:22:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mK3Y8EYp-Fr3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 18:22:38 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55D5F4048A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:22:38 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 k12-20020a05620a0b8c00b003d5c8646ec2so4083255qkh.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 15:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:message-id:mime-version:subject:from:to:cc;
 bh=Q20iEess0fifQ1UuQbXOXFqiUUzry/ZTlIcm76UAWxM=;
 b=JfW08WvwR5NppuckDbGBjuYm/qfKFPNTAZMbHjE/W+axyhP3dc87K2dMjwCziGbrNR
 5Qhg0J8NmGL98SrOSvD9+8fWKrNBvaBv4Bb712hBTDXdcAkjRaecIZM3yTmnh/YCLd1j
 j4567Vp0WodpV5fuJ38h92olkRvx4Hh61wgCKUVTrypmncIQgF7Ri1gQk00SQi/HSyow
 FU9+od8W/IBrgXjkjHAVl9RVO+lIOxAvuEQlvTwimT1f12eK4eJcULYfQ+OhzITQA4SX
 BCUUCMylJy5CnztKQ+q2PhL/PAPjBBJ/v0LuXubz46t0KKEapi2MizSOXqYgukZgXHs/
 NGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
 :from:to:cc;
 bh=Q20iEess0fifQ1UuQbXOXFqiUUzry/ZTlIcm76UAWxM=;
 b=f2KnW9UChal0xTdk5oR4T0Erz87FTiVRoExONby4WoK05uaAFExXSDdCqaLXgGTHfR
 d4iBUQJR73Intrt5n+f0QFow0t9KywD/sZAmXwM5ZsivdiNg9vZad7Y+rwYtHD3sFaJ7
 qv+0+vf15JhePERo6TUBKCKpTFPA3ZafW5oB97I6BdjWW5F+PSKI0zXaTidGnuQQmCok
 bcWlPMTaVP+ZLKBhgmxzSEPfsYsfilYHIRTOVdqKNfBfQU0P6Nn91I96kbG4AJGE5zqP
 Jtp6FXrzABChYHG/MUGBFwOM9QMMpAjIpbbFmgEXTv26TUPB2UFXVuQ2j+PXUiCxNQnj
 jfEw==
X-Gm-Message-State: AOAM532fnn+hRdSTW1HRX6ohJq/25S9D98MPW+iJCmG8DpktYQSq6K4v
 UQmUZ1pwTpSdhc5ExuuMzhQnhu/B4yw=
X-Google-Smtp-Source: ABdhPJyWLleGn2Q9uDNlTmU74iPlGeJ9AoH7VeL2KdOBb7ybZB1A31L8xwxPOwizMhE7GlKn0cZbRD9sBg8=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a25:ea51:: with SMTP id
 o17mr38809433ybe.192.1632262957862; 
 Tue, 21 Sep 2021 15:22:37 -0700 (PDT)
Date: Tue, 21 Sep 2021 15:22:29 -0700
Message-Id: <20210921222231.518092-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 0/2] KVM: arm64: Clean up CONFIG_KVM vs CONFIG_HAVE_KVM
From: Sean Christopherson <seanjc@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Fix an oddity where arm64 can end up with KVM=y and HAVE_KVM=n.  This
doesn't cause problems today as no generic code that supports arm64 uses
HAVE_KVM, but that may not always be the case, e.g. I stumbled across this
when exploring hiding perf's guest callbacks behind HAVE_KVM=y.

Sean Christopherson (2):
  KVM: arm64: Unconditionally include generic KVM's Kconfig
  KVM: arm64: Depend on HAVE_KVM => OF instead of directly on OF

 arch/arm64/Kconfig     | 1 +
 arch/arm64/kvm/Kconfig | 9 ++-------
 2 files changed, 3 insertions(+), 7 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
