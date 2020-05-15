Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4BAC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDDC020709
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="XH/o0H7o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDDC020709
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47D0C4B4CA;
	Fri, 15 May 2020 06:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w3IKLu-32rKL; Fri, 15 May 2020 06:58:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54CD04B4C9;
	Fri, 15 May 2020 06:58:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E99754B4C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:58:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZSMFPhwu+ufQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 06:58:57 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E30154B4C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:58:56 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id w64so2161238wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 03:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=n0WmKLG9AhFHe1sx7/xWBbs910NkW2ou4PIf9/zvdZk=;
 b=XH/o0H7oM78CWsMava6ImC+pDI6hF6ua9+7a+QgMxesqt0yvnk3qtmKK2Kdbnpgwn5
 syN/+CbKjm6nWhTD4kIjUoLCKKDl0DlXsbkO5IvT0Ng63b17fu0k70ArZyIFneeBaLRz
 raNSACI6WrwfkYHp+NLgayYvdjKyhhOPIG/9EnB9PD4u3xxQQz7jOb2yARtaUaugtPMx
 f2om0EoHE2cV01n/1IlqoPq1I3NpnCfjdh4Irg94n2vsLyaQthwX7TH58GQap8aIibHq
 HX/YAdJj4EJ54cR/YtNxaqTu/khLe/vqabq3I08duZ21GmKhMeAnn0qbb3oOZpPG1tZJ
 FCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=n0WmKLG9AhFHe1sx7/xWBbs910NkW2ou4PIf9/zvdZk=;
 b=EwcXV6nlQk5ZUNiHLSL03ok2BjiAtm5cND8UJOriOPIUT+sTNUqbDGBrH8p9raxDC3
 TPJs2jnpyGFg5dH/bq3VkJGkYy188/hccckt/Stl08gZu5HkNajjTNqfXUsWWkR1jNjD
 OGpBHymrSNleDOk+tpxg+91LvxKQ7OTDr7AQ5C2PE7Uelg8h0Sf9x8mCsaFper8TRzT5
 fD2BE7RHBN5rwBp4W84digSWOizwt/OyxOXCYDKkLLzeMNtcXzlcHV7XJ3P1IvR6/x/h
 9IVdtRLdVId09D1xKW1Q2E9Dh4q0nXyRdV9tHM0CLlCXMejhcmz5VZZQSTIZV0pUPJWK
 K3GA==
X-Gm-Message-State: AOAM532fuBHY/x8Mae2rbtKv25LGPJBlMmLmzPomnuDHNQa5HMTdXrBg
 Mc93ydDY5IpLWyobhaxHMKVppQ==
X-Google-Smtp-Source: ABdhPJyFi+//KaD2VusD1LXgNbdSGbxHqdar1dGWec/TaEPF0FrbkPG38tGqXW8/K5EnBa5mk9BeqA==
X-Received: by 2002:a7b:ca53:: with SMTP id m19mr3574570wml.182.1589540335813; 
 Fri, 15 May 2020 03:58:55 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id x184sm3090403wmg.38.2020.05.15.03.58.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 03:58:55 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 01/14] arm64: kvm: Fix symbol dependency in
 __hyp_call_panic_nvhe
Date: Fri, 15 May 2020 11:58:28 +0100
Message-Id: <20200515105841.73532-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515105841.73532-1-dbrazdil@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

__hyp_call_panic_nvhe contains inline assembly which did not declare
its dependency on the __hyp_panic_string symbol.

The static-declared string has previously been kept alive because of a use in
__hyp_call_panic_vhe. Fix this in preparation for separating the source files
between VHE and nVHE when the two users land in two different compilation
units. The static variable otherwise gets dropped when compiling the nVHE
source file, causing an undefined symbol linker error later.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8a1e81a400e0..7a7c08029d81 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -836,7 +836,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 	 * making sure it is a kernel address and not a PC-relative
 	 * reference.
 	 */
-	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
+	asm volatile("ldr %0, =%1" : "=r" (str_va) : "S" (__hyp_panic_string));
 
 	__hyp_do_panic(str_va,
 		       spsr, elr,
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
