Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDC7C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C4402067D
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nMnqkLp9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C4402067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 408BB4B6C9;
	Tue,  4 Aug 2020 08:44:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sYtf-KnRmbJy; Tue,  4 Aug 2020 08:44:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1A64B71A;
	Tue,  4 Aug 2020 08:44:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC8054B71A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PCJm3O7m2iRm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 08:44:21 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAEB54B711
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:21 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id t14so2778768wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2020 05:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=kh3fLdhtAK8iltYl6aGsCpfSwDzQcJQDII6+Lr3Ir4w=;
 b=nMnqkLp9MyaD7mVBWPOdpipOJAA/A+eqGB2+7v2AnGvajHcTmtJGzfEa8AObnk3OGO
 X6yzj+zqibdmVd52uW6BsVLE1twlWOD8iHOgBNZ4VGgtFVF3pWYXGAqPfb8l+53YHRNG
 fkEUw2haM1Xyld8Y5Y4NGy7cZi9KRdEu+s1yEngpns9vBqo+5u5vyUfrDXyt3ivwb/rB
 clg/7E3xKGUCx24uRr1RBdN9jkogBMFaY3KQRg6bWxxmOvo5fYHBnXt+k0Nf+/PDBu2f
 s6HexrWOx4jElhs7Dd34qf7UdiQd6LCDGnCq2XOnNawU9uylFjuZkOHE2fgbsJFmSbff
 SnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=kh3fLdhtAK8iltYl6aGsCpfSwDzQcJQDII6+Lr3Ir4w=;
 b=E1qXDgBM13tm2Ii2k3I4FOobgujnIeOVVlgcCxngVohoNBTViBS+rj1NhVThD+M3b6
 /Bo+mPJ4OwkjyR2DflIkCnFXAIpdayDlO6+PCHg8Nre/yQZsn9DgMLkXM6LEGcQXRc5b
 4Yrlet0dOLdUzDds8BRI4PxOiiH0vzRxi21gRPZQfFcoQ05775Bc5mFpg9n/tEGE98wf
 oRAhYQECX0DVNhAhBxbzSCmi2bDc99r20ZdTyNeU00oa9P96W70+PsPBFIwhcgyUS4r5
 MGCzwTjzTtNJM/8ciNCf79soWkKq39NojEouaHlQwsXATVGP/bQgr2Om9LEUiUi4fcYS
 xpqA==
X-Gm-Message-State: AOAM532GvSAzi51dp9hwKjsFpE9cDOofcTUn7zHKkId5K5p7/PGynfvD
 Q9ZGzH4G2DTI/vu6gKEiFmLKVQ==
X-Google-Smtp-Source: ABdhPJxlETqHM58ekeF7YRtlEWgL6bu7W0dZE0N/3gry/XAbgEfMhCjsPaytXate5VOSsOPSdbiQrg==
X-Received: by 2002:a1c:7702:: with SMTP id t2mr3859731wmi.169.1596545060810; 
 Tue, 04 Aug 2020 05:44:20 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id r206sm4554096wma.6.2020.08.04.05.44.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 9218B1FF8C;
 Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1 2/3] arm64: gate the whole of pci-xgene on CONFIG_PCI_XGENE
Date: Tue,  4 Aug 2020 13:44:16 +0100
Message-Id: <20200804124417.27102-3-alex.bennee@linaro.org>
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

VGhpcyBpcyBhIGxpdHRsZSB3ZWlyZGVyIGFzIGJpdHMgb2YgdGhlIGZpbGUgYXJlIGFscmVhZHkg
Y29uZGl0aW9uZWQKb24gdGhlIGV4aXRpbmcgc3ltYm9sLiBFaXRoZXIgd2F5IHRoZXkgYXJlIG5v
dCBhY3R1YWxseSBuZWVkZWQgZm9yCm5vbi14Z2VuZSBtYWNoaW5lcyBzYXZpbmcgYW5vdGhlciAx
Mms6Cgotcnd4ci14ci14IDEgYWxleCBhbGV4ICA4NjAzMzg4MCBBdWcgIDMgMTY6Mzkgdm1saW51
eC5vcmlnKgotcnd4ci14ci14IDEgYWxleCBhbGV4ICA4NTY1MjQ3MiBBdWcgIDMgMTY6NTQgdm1s
aW51eC5ybS10aHVuZGVyKgotcnd4ci14ci14IDEgYWxleCBhbGV4ICA4NTYzOTgwOCBBdWcgIDMg
MTc6MTIgdm1saW51eCoKClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVA
bGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL3BjaS9jb250cm9sbGVyL01ha2VmaWxlIHwgNCArLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9wY2kvY29udHJvbGxlci9NYWtlZmlsZSBiL2RyaXZlcnMvcGNpL2NvbnRy
b2xsZXIvTWFrZWZpbGUKaW5kZXggOGZhZDQ3ODFhNWQzLi4zYjliNzJmNTc3M2EgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvcGNpL2NvbnRyb2xsZXIvTWFrZWZpbGUKKysrIGIvZHJpdmVycy9wY2kvY29u
dHJvbGxlci9NYWtlZmlsZQpAQCAtNDcsNiArNDcsNCBAQCBvYmoteQkJCQkrPSBtb2JpdmVpbC8K
IAogb2JqLSQoQ09ORklHX1BDSV9USFVOREVSKSArPSBwY2ktdGh1bmRlci1lY2FtLm8KIG9iai0k
KENPTkZJR19QQ0lfVEhVTkRFUikgKz0gcGNpLXRodW5kZXItcGVtLm8KLWlmZGVmIENPTkZJR19Q
Q0kKLW9iai0kKENPTkZJR19BUk02NCkgKz0gcGNpLXhnZW5lLm8KLWVuZGlmCitvYmotJChDT05G
SUdfUENJX1hHRU5FKSArPSBwY2kteGdlbmUubwotLSAKMi4yMC4xCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
