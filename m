Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED79EC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F5FD61B2B
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7F5FD61B2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E13D4B220;
	Thu, 18 Nov 2021 13:47:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iV4-X0AoLnkN; Thu, 18 Nov 2021 13:46:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C33AA4B204;
	Thu, 18 Nov 2021 13:46:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE184B1E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z9TuqhQ3WjU0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:46:57 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D33E4B1E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:57 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id d5so13474759wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=FbAh+aztF0zh2yPX+S7IKVelQO7NqMfexMVIl0szM/Q=;
 b=dKTCZqGr5BEyXulWz04B3VqIQibV6GuezrZHpHVmtIMOLiasDW+K4vSFElaAkUpH1W
 7o4deOFOMy/+LnRBRHXXr/q8me3q6o900zSJ0u4zHpw3BlkRO7QYo9d/LMt0F4XSEtf1
 8b7pm5Mgd+tvJhilUfDAC6h4e0IiQ7tr92FGj0Je/C6vuxuqZ+Nb2uAMgpkO6fSS2E1f
 PoM+6pn8SFi6S2IQvHO5k78NkkNoOOQCAn3/xPJexhPL7a+qfSbWtUFH9MpOMwXZTufk
 R/8hGXhC1V+3N/pWUZkvfAppZxvuI0/6MUeYPlTNOgPDEDmA5mtQ6tQ92ZMkx6o0qKL/
 lWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=FbAh+aztF0zh2yPX+S7IKVelQO7NqMfexMVIl0szM/Q=;
 b=5Q8qMYRBJEqbm7zi7sBboyG+lo1suvyMZsGABKQQpToO7r9JFpGcnwNvlO647ELXOI
 KfW5ldlL3NjOXc6pKHL1HmvNphhYRfmVal/DwifDf7QceRcuClHWN/Pqw87b78XNuDDb
 z51xppwk8l4YFBrXRKZtQHcMeTR6N8DAgBS+XHT+uvwCVaMLxu0QV8WcHOQWWSU2YOTn
 tRvFe55uGroq/8esjWyWppqkmmqRCgP2eU8Ufs0RccBa2xcu2P83CJSNoAiIFB98Akms
 ZiiBk0fB7umWJA8k9pWdqXVEHYVMxaqb2KZvDTzZN3f9V0/xjy2+flK4pqdHMGLV5G4C
 KeQg==
X-Gm-Message-State: AOAM533xJw+ONVQbZ/y97N79KCNatTH764vOy+tim579N5VyPadbvesb
 oET73nUCD8gSzq84dGUGAIL10g==
X-Google-Smtp-Source: ABdhPJwuqcWCq5OtkKnnGu4FzRENuBcr3VIuVBqyCASUcE2XGA1oVULFg2sKZDvp1S0mXlH38p+wWw==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr34905244wrw.118.1637261216576; 
 Thu, 18 Nov 2021 10:46:56 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id c1sm644533wrt.14.2021.11.18.10.46.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:46:54 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 490751FF98;
 Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the README
Date: Thu, 18 Nov 2021 18:46:41 +0000
Message-Id: <20211118184650.661575-2-alex.bennee@linaro.org>
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

U2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgotLS0K
IFJFQURNRS5tZCB8IDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKCmRpZmYg
LS1naXQgYS9SRUFETUUubWQgYi9SRUFETUUubWQKaW5kZXggYjQ5OGFhZi4uNWRiNDhlNSAxMDA2
NDQKLS0tIGEvUkVBRE1FLm1kCisrKyBiL1JFQURNRS5tZApAQCAtMTgyLDMgKzE4Miw1IEBAIHRo
ZSBjb2RlIGZpbGVzLiAgV2UgYWxzbyBzdGFydCB3aXRoIGNvbW1vbiBjb2RlIGFuZCBmaW5pc2gg
d2l0aCB1bml0IHRlc3QKIGNvZGUuIGdpdC1kaWZmJ3Mgb3JkZXJGaWxlIGZlYXR1cmUgYWxsb3dz
IHVzIHRvIHNwZWNpZnkgdGhlIG9yZGVyIGluIGEKIGZpbGUuICBUaGUgb3JkZXJGaWxlIHdlIHVz
ZSBpcyBgc2NyaXB0cy9naXQuZGlmZm9yZGVyYDsgYWRkaW5nIHRoZSBjb25maWcKIHdpdGggYGdp
dCBjb25maWcgZGlmZi5vcmRlckZpbGUgc2NyaXB0cy9naXQuZGlmZm9yZGVyYCBlbmFibGVzIGl0
LgorCitQbGVhc2UgcnVuIHRoZSBrZXJuZWwncyAuL3NjcmlwdHMvY2hlY2twYXRjaC5wbCBvbiBu
ZXcgcGF0Y2hlcwotLSAKMi4zMC4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
