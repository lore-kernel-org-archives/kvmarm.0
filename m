Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4BBC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:26:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21E574B30D;
	Mon,  9 May 2022 12:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LW6+4g4toCVz; Mon,  9 May 2022 12:26:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F101C4B2F4;
	Mon,  9 May 2022 12:26:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 759134B20F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rb75D5qLzdaj for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:26:14 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FC204B1B5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:26:14 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 t15-20020a17090a3b4f00b001d67e27715dso10828361pjf.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=24ZXTLzrcb04Vr94e2BinqljFa5PLSd+pPp++TfBpV4=;
 b=P2MUNiyZ52zkfiPjcTS8SbrOv+J4pIHeiuXQFaZnESg+NLVcCU4AR/+fuZgpSBJHvE
 rej/pBP0q29OlurWs27cZq38903lkbwzGDQrWMriEBwcQEe3UtVPAayTBp96OwiKgap+
 LxnYhTuP4ZWRpIebRHdev99As+Py+mvlCVMd3D2qN5Qmpq8aghskctCe/hfEfC249O+L
 3n0gWT+eovPuEaB24iPZEmL9XqbtVwLE//FTCfavnJqsLwR6eOuJ/ZgMEPsWRJFbX9I8
 dfcd2f2RR2knl9FJNgaSc9pfkr2xrKpX4HOJPcQnVcrbmwKGZvCTvtme2vs6Y1WphhFs
 dGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=24ZXTLzrcb04Vr94e2BinqljFa5PLSd+pPp++TfBpV4=;
 b=fH+TcDlesWCjdJ3xraZB1ArqrtkudJYH4rRZOouTeL1ciQ+ZodN7IZVp7Ykn7rC6KX
 UYNLsVpsfeqM0+LhZEwN1YUlyKcM74P1s2ihS8UZDeezoMwXQMECG7wQw8zbuncDRWjp
 5K89d7A0k/E8Zg/7NW001utl2BgPUXKDgfLDPO+qf4o5oOkewYGYw299Z+1jAH1ouZrI
 57Kkdafi7vLqprqKjdTYHdRjmEEC7zTFWKdxDiSsmuXKqU7VB5Zh2YXjRnwtMrd0O9Hb
 Eekqe2N30YgwnfTA8X17g6mbp6TAnzUflGtwKAmaGuCITCf1otAJfToj6iNEPx8wgW0J
 NgLw==
X-Gm-Message-State: AOAM531SgSTWIwofGxUiXoZ7oJIXdULyguWmze3EPJYNUQKowVejH3kw
 XhEU1wjSMtquLvIhanXTQS/u9JHsSULtKflO/6dy2w+NoIJXA7li9l3stxw2+88ZDsNOoCtjt51
 gnFrP7FAFHYBVJu1oeq+yYXyVxex26vOyWgB9CW2mbQLejh+lilvrcLbUvsjSZeTMsV6e7A==
X-Google-Smtp-Source: ABdhPJw1MOqIa/OCx3HluxWiZNUBlyVCmiV5/bxnPcSifyQh0atyvanFNrvtWw7hQl7rFciI7mrRmNlka6M=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:e94e:b0:15b:22a7:f593 with SMTP id
 b14-20020a170902e94e00b0015b22a7f593mr17113726pll.148.1652113573120; Mon, 09
 May 2022 09:26:13 -0700 (PDT)
Date: Mon,  9 May 2022 16:25:57 +0000
Message-Id: <20220509162559.2387784-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH 0/2] KVM: arm64: Minor pKVM cleanups
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

I was reading through some of the pKVM stuff to get an idea of how it
handles feature registers and spotted a few minor nits.

Applies cleanly to 5.18-rc5.

Oliver Upton (2):
  KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
  KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE

 arch/arm64/kvm/hyp/nvhe/switch.c   | 19 +------------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  3 ---
 2 files changed, 1 insertion(+), 21 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
