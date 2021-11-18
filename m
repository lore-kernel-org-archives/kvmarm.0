Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50991C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:46:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EFEC761B1E
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EFEC761B1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 943394B20F;
	Thu, 18 Nov 2021 13:46:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ROGmikOVYUhc; Thu, 18 Nov 2021 13:46:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D2564B1FC;
	Thu, 18 Nov 2021 13:46:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C33F14B183
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aw9A2YWjzetJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:46:53 -0500 (EST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6B434B1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:53 -0500 (EST)
Received: by mail-wm1-f50.google.com with SMTP id o29so6255956wms.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=N1TD+o6fA2jwMAGGm9K/LhqxPmEtAnkZjhJNXEULmUk=;
 b=OZ+0ycbkYM32+k3qsnQBx40UB+HQWYrf4ClPvT9L+GaXRo74oIjcfnG8tB2nzPRVUY
 MK0WqQiXpqYCXs+/HVInv8n6a3FB5TqhV55wnN8ET4JFpkolVeEHwW2rXqwADhwJyhQU
 dhkS7OnJKDDDDqhUuwZSW7rcWltcnbgqDhZsIHy+cBFzhXu90XSEB0kOSoFTwG87WC64
 nwfj2Zlr8ySTd99Z/TSoNnKZJvpfd8BU3Vc+zhM3ucXjuJTUTsZnXy+6wSYVxUPuq3ms
 M2w2fwo+xzjA+7N3KUJ4j800daGm7Npqu8dt6FFkdR9ur3B6aauwHp1Hb6Ar7WympXyE
 R8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=N1TD+o6fA2jwMAGGm9K/LhqxPmEtAnkZjhJNXEULmUk=;
 b=TUV+6DIJf5NZOySuyLKbahVrRGRxadsKiXijBqE7IQ6UduKnxoAiPDiiKot3smiu+M
 RVgPAM5VRo2lFT7FxeD0fvzRK1g3bIbbKPJeRbwslzqrWOPw8FKshsciUTDt1BJu5okn
 6OaFJfa7uzO0pIZJQUi3cFvJaFbmrhGVTFJK5HLmdBZyDqwwgZpzFeSFrRF2iHQkx+Xj
 QZQfwpirbqhC0WH+u+6PTjfZMK62RO/AbxTLw2HMAZpUv++p4tK2KHJ1q2CTG8OlbK0G
 0/bWcC5B99wjhL61zQWn0mFuOhC6vzwOEkPA+64FO2Uryc/B/tNx0394V/IaOs/fdCEF
 4uAA==
X-Gm-Message-State: AOAM533OEZ+vAer1zeYHL9PBOKBt11rzMkTwbINK2Bu+SwagTqHZihyk
 Lu2ppgJYIWLe3cNOKzB/monKWQ==
X-Google-Smtp-Source: ABdhPJwla25wllkelCSuqSunInape1qck1sRu6PWmBGXbmmbMp7JZz+bf9KnvBlWv5Jc/4k8cdhsXg==
X-Received: by 2002:a05:600c:1c20:: with SMTP id
 j32mr12131735wms.1.1637261212696; 
 Thu, 18 Nov 2021 10:46:52 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id n1sm655518wmq.6.2021.11.18.10.46.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:46:50 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 56B171FF9A;
 Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 03/10] Makefile: add GNU global tags support
Date: Thu, 18 Nov 2021 18:46:43 +0000
Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, qemu-arm@nongnu.org, idan.horowitz@gmail.com,
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

SWYgeW91IGhhdmUgY3RhZ3MgeW91IG1pZ2h0IGFzIHdlbGwgb2ZmZXIgZ3RhZ3MgYXMgYSB0YXJn
ZXQuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+
Ci0tLQogTWFrZWZpbGUgfCA1ICsrKystCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRleCBi
ODBjMzFmLi4wYjdjMDNhIDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAt
MTIyLDYgKzEyMiw5IEBAIGNzY29wZToKIAkJLW5hbWUgJyouW2Noc1NdJyAtZXhlYyByZWFscGF0
aCAtLXJlbGF0aXZlLWJhc2U9JChDVVJESVIpIHt9IFw7IHwgc29ydCAtdSA+IC4vY3Njb3BlLmZp
bGVzCiAJY3Njb3BlIC1iawogCi0uUEhPTlk6IHRhZ3MKKy5QSE9OWTogdGFncyBndGFncwogdGFn
czoKIAljdGFncyAtUgorCitndGFnczoKKwlndGFncwotLSAKMi4zMC4yCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
