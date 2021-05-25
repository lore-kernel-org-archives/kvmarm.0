Return-Path: <SRS0=drPj=KU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF82C2B9F8
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8470261429
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8470261429
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0389640573;
	Tue, 25 May 2021 13:26:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c8BrNDFuxtVZ; Tue, 25 May 2021 13:26:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE87B4064F;
	Tue, 25 May 2021 13:26:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBE0F4064F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N5t0+WLyFo9q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 May 2021 13:26:31 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C13F140463
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:31 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id t206so17209547wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=tE71iJXd5lNAWxxJLNcL/6uDoH1J0xBWhsOfm3k1uws=;
 b=dkrq9aMX8W87CIgan64n+dK18+xIXr0zcUUaiLS/h5GRwmu+tfrCVKcSHwRYudRTWp
 uyY2t4vFoLQj7cIk23d5S6rAWNHLr8BeUV6dcQxo1gCrLqyRvBepEYMIZaCI3oaEKSXW
 DLdEdnjt7r2yFxFy6LhmeC5oYu4FfavlaZlo/33fKmfQRgRg49tlHMHIUy2ZYVkZPBMl
 5gjFbLuVWgzMO3GpVqra7VNOei53Q1cN7mLLRYZyIu534yaGGgXDVMwKqLea+2MapUDo
 bEgroCVzh7XnQKNvZca82hXV/60s9cPe4IuP1f8PhIsXWpqpNWauw0F/Q4CYH5W4YPZC
 mIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=tE71iJXd5lNAWxxJLNcL/6uDoH1J0xBWhsOfm3k1uws=;
 b=CpGGedGBTXcOPR9us9BjmCiC9Wwbl/vI+ToF0gkGq1PDch7RAF08yTHPluAdfhtpeq
 AScyHLBTNVdfL34U3BMNZy1LG3XlVJTHWZg6MITYPtQNwpLx0ZpobWvYnbPIIyZLYlW2
 XoQtK0EzRaEara52NKBnEXRXoRDA+sHouG7qQRCvPg8uOhYkXgzC0ekwMcr8UxjuCWzh
 PaksDHJcYHpls+ERSc6LnFQJcpT5vmEtkA51ULhudsUKWkvk3OgdesW3gKy0QQIV3YyJ
 +1wR/YSUYQfn4gilmGy6I+JhAwcR2vlRY/h7U6OYbNakFC9BgDjdfH5N1oiv22y1ErXw
 NU3A==
X-Gm-Message-State: AOAM532P3FcZNR1I8MELoy12BA4khsS3v5gGcBNhlrHzg624tgpikar6
 Nj1wfX6szUqdXL9N2aYhEw17Yg==
X-Google-Smtp-Source: ABdhPJz/21wU+3sZAyElQTvCNA8LBhNegY7oMJRYpI7UQ/mzMrv5nQN++xYeVZHvfU5bU4INii/eNA==
X-Received: by 2002:a1c:7402:: with SMTP id p2mr4841895wmc.88.1621963590525;
 Tue, 25 May 2021 10:26:30 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id o21sm11663983wmr.44.2021.05.25.10.26.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 71D031FF7E;
 Tue, 25 May 2021 18:26:28 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/4] enable LPI and ITS for TCG
Date: Tue, 25 May 2021 18:26:24 +0100
Message-Id: <20210525172628.2088-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

VGhpcyBpcyBhIGNvbXBhbmlvbiB0byBTaGFzaGkncyBzZXJpZXMgZW5hYmxpbmcgTFBJIGFuZCBJ
VFMgZmVhdHVyZXMKZm9yIFFFTVUncyBUQ0cgZW11bGF0aW9uLiBUaGlzIGlzIHBhcnQgb2Ygb3Vy
IHB1c2ggZm9yIGEgc2JzYS1yZWYKcGxhdGZvcm0gd2hpY2ggbmVlZHMgYSBtb3JlIG1vZGVybiBz
ZXQgb2YgZmVhdHVyZXMuIFNpbmNlIHRoZSBsYXN0CnBvc3RpbmcgdGhpcyBpcyBub3cgYXQgdjM6
CgogIEZyb206IFNoYXNoaSBNYWxsZWxhIDxzaGFzaGkubWFsbGVsYUBsaW5hcm8ub3JnPgogIFN1
YmplY3Q6IFtQQVRDSCB2MyAwLzhdIEdJQ3YzIExQSSBhbmQgSVRTIGZlYXR1cmUgaW1wbGVtZW50
YXRpb24KICBEYXRlOiBUaHUsIDI5IEFwciAyMDIxIDE5OjQxOjUzIC0wNDAwCiAgTWVzc2FnZS1J
ZDogPDIwMjEwNDI5MjM0MjAxLjEyNTU2NS0xLXNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+CgpU
aGUgb25seSByZWFsIGNoYW5nZSBmcm9tIHRoZSBsYXN0IHZlcnNpb24gd2FzIHRvIGRyb3AgdGhl
IElNUERFRgpiZWhhdmlvdXIgY2hlY2sgaW5zdGVhZCBvZiB0cnlpbmcgdG8gd29yayBhcm91bmQg
aXQgZm9yIHRoZSBUQ0cgY2FzZS4KClBsZWFzZSByZXZpZXcuCgpBbGV4IEJlbm7DqWUgKDQpOgog
IGFybTY0OiByZW1vdmUgaW52YWxpZCBjaGVjayBmcm9tIGl0cy10cmlnZ2VyIHRlc3QKICBzY3Jp
cHRzL2FyY2gtcnVuOiBkb24ndCB1c2UgZGVwcmVjYXRlZCBzZXJ2ZXIvbm93YWl0IG9wdGlvbnMK
ICBhcm02NDogZW5hYmxlIGl0cy1taWdyYXRpb24gdGVzdHMgZm9yIFRDRwogIGFybTY0OiBzcGxp
dCBpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uIGludG8gS1ZNIGFuZCBUQ0cgdmFyaWFu
dHMKCiBzY3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAgNCArKy0tCiBhcm0vZ2ljLmMgICAgICAgICAg
ICAgfCAyMiArKysrKysrKysrKysrLS0tLS0tLS0tCiBhcm0vdW5pdHRlc3RzLmNmZyAgICAgfCAx
MiArKysrKysrKystLS0KIDMgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwgMTQgZGVs
ZXRpb25zKC0pCgotLSAKMi4yMC4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
