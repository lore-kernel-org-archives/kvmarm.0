Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50EE6C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C67E02067D
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Riv8iutg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C67E02067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C56C4B7BA;
	Tue,  4 Aug 2020 08:44:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YzmcVRsYZk2C; Tue,  4 Aug 2020 08:44:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BEA54B71E;
	Tue,  4 Aug 2020 08:44:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C69774B6FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aey-eAUwCHSk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 08:44:20 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA9CC4B6C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:20 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id f1so36717084wro.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2020 05:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=CYDox3KQ1JETO7R6nCajEi5q9XM0wuEKwlQrdfldtzE=;
 b=Riv8iutgfQUgNDMN92DtQvb/ueHJ6AIreMGAIsPCtm4ILvbZOn+PBNFru/JxFRQn+a
 9TfiKx4DTAO1/mtV9wsMqag4ynofuu+qJ8KcnT0H01tQepbNaqDTZvqQvMuZtPQBOduf
 CxLDVXhPdqFLT0zbGguTGrJKZfH+S/lGnAzhvNTBi0FcUKC5HJp/+r/qZDgMqCN1u61M
 ZIBRfcVMUR48Uz0nrWv/JeBjsaFxjG5I/w8jfhHReJuMa+Pm25oX2mloao7+N1Yr/e42
 uovU2IyFUipCeXc7bYv0WjUNANHbOH3ka4foDQ5we7li93TpmE8H4yyBhs21Q8mbmEQA
 00PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=CYDox3KQ1JETO7R6nCajEi5q9XM0wuEKwlQrdfldtzE=;
 b=G7qtzJ14JC9qBdeK4+yFhSdAewNyjvnjj9t9ucwAf6OrDCK+JKilQ8bF4lt946RWLz
 MJORdYtZqavaxKZ6KeLaFZYjSy4Q2plre5LkTU47CWJfG3cmSH7LBBTd8TGOUHOkFkW6
 sk0gUEtzy3KQYaEUUipwxnVVBxGEhzC49IiX4o80QOk9+6RZHCyCvOvFq/9YWYhmWX7J
 VNoxUdBoswxPu/p7zZIT+LIy1A0mBBDV80GDJQjZ8i1KVzQCCw1jwcToIyvF3Qx9sY11
 f1BsOCmLMUDrOzNr2AOWCSKuhd3ThSJicBWPXK1HA/Qx/In4ToARXVav5+pdHTAo4m18
 25KQ==
X-Gm-Message-State: AOAM532Phsomkd76b6A/UgbxZQKokMknkBLtaglve3pS/qBV+AvdWdF9
 7yHokHhIiDekC/6f1miq0P3BsQ==
X-Google-Smtp-Source: ABdhPJy369HvI22rb0UHPSZq9AsVjFavkg1pT+b1lsUC4Du192zTR5pC4Bv0+KzFRIkrLbZspUmmgg==
X-Received: by 2002:a5d:6a4a:: with SMTP id t10mr20525689wrw.360.1596545059657; 
 Tue, 04 Aug 2020 05:44:19 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z207sm4576048wmc.2.2020.08.04.05.44.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 9DC9E1FF8F;
 Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM guest
 configs
Date: Tue,  4 Aug 2020 13:44:17 +0100
Message-Id: <20200804124417.27102-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804124417.27102-1-alex.bennee@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

VGhlIFZJUlRJT19QQ0kgc3VwcG9ydCBpcyBhbiBpZGVhbGlzZWQgUENJIGJ1cywgd2UgZG9uJ3Qg
bmVlZCBhIGJ1bmNoCm9mIGJsb2F0IGZvciByZWFsIHdvcmxkIGhhcmR3YXJlIGZvciBhIFZpcnRJ
TyBndWVzdC4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4KLS0tCiBrZXJuZWwvY29uZmlncy9rdm1fZ3Vlc3QuY29uZmlnIHwgMSArCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9rZXJuZWwvY29uZmlncy9rdm1f
Z3Vlc3QuY29uZmlnIGIva2VybmVsL2NvbmZpZ3Mva3ZtX2d1ZXN0LmNvbmZpZwppbmRleCAyMDg0
ODFkOTEwOTAuLjY3Mjg2M2EyZmRmMSAxMDA2NDQKLS0tIGEva2VybmVsL2NvbmZpZ3Mva3ZtX2d1
ZXN0LmNvbmZpZworKysgYi9rZXJuZWwvY29uZmlncy9rdm1fZ3Vlc3QuY29uZmlnCkBAIC0xMyw2
ICsxMyw3IEBAIENPTkZJR19JUF9QTlBfREhDUD15CiBDT05GSUdfQklORk1UX0VMRj15CiBDT05G
SUdfUENJPXkKIENPTkZJR19QQ0lfTVNJPXkKK0NPTkZJR19QQ0lfUVVJUktTPW4KIENPTkZJR19E
RUJVR19LRVJORUw9eQogQ09ORklHX1ZJUlRVQUxJWkFUSU9OPXkKIENPTkZJR19IWVBFUlZJU09S
X0dVRVNUPXkKLS0gCjIuMjAuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
