Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7398C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 11:54:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FAA34B1EC;
	Thu,  2 Dec 2021 06:54:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PuVuQUNqofrh; Thu,  2 Dec 2021 06:54:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E46094B17D;
	Thu,  2 Dec 2021 06:54:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D91C4B13A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:54:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N1AaKlJxqiPO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 06:53:57 -0500 (EST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A59B4B149
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:53:57 -0500 (EST)
Received: by mail-wr1-f50.google.com with SMTP id a9so59100120wrr.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 03:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=IvLpBDRS2Pdn+vA+erULS+6P/ROHm9M1862F9XFkLVo=;
 b=O6eWGC3lK1k2bdwvVVPl5U+azr4tVe10ZfOseYEtT96guc8yYcVbGVXdvPxMDHDV6T
 ec8eelKu7vuYLLcWfa84OcJZa61vTDqh/68FnL5TMrUaeYOiUH+nlv5SGVJKjuRfJB2w
 eRQGbwxrDMMwzfi/qmdJgT1kRqCN/NxApzDQ8ev6Ifyl95rmkqHDyLjjOugf3wipv0c0
 D0V+iiqsk+YZ5tBgsw7mnMbz7TjwZxivudsoti9xuT8SvjMv+via/Z+rH9vGEbT53g6L
 SjqLUbQUkSEorUWLw3+7TYh7GhKlVDzrjRNzQTQialDgp8+rOui1JsLVZiQIx3kTkv/8
 x2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=IvLpBDRS2Pdn+vA+erULS+6P/ROHm9M1862F9XFkLVo=;
 b=WvOzGGdzPf9TwPZ4I1JOBQJ5m3akhsY22ytBB3U5VdHsvQEUHbiyEdJ0KC4wi9eYw4
 jkl2OmIk4iCmcSfUf805Eh4Ay1vPytaWS+zeHoCNjROenCEnwwk8Z5KULOafm/Fr372p
 3tARAgML5+8DDIiNXHsBcQPjL/XzPV0GOGx+/N/RBP8tsvKf8MmyDmjyinqeeGl3y/KC
 R1wvsr2iLnHoDH06gm2oU2u/HnDUXrHP0Q4xtpym0XF0NwpUa3X+m/CRz4pPeVBI/ZuX
 mYZnlDqHxy3YZ2lUt5ej+J9ZMJ656O0mX5BQhUD4/a6DkhHfeb1C4XJfrsNJ6PZpYHRl
 NKdg==
X-Gm-Message-State: AOAM533WfVdUUZDSqWPMyLiKyLeaj/a4R0W8MXjpVzcsld0hLFEmVlV3
 nwqVFGqG/SVpMCuVHtP3dHFzbA==
X-Google-Smtp-Source: ABdhPJwi/7A808rEy78vOiFE7u0TCcCzTOnMSi1t/OE7sTq+JunTgf07UGOwCnnDDX1W7awt1Jf5jQ==
X-Received: by 2002:a5d:4b45:: with SMTP id w5mr14000332wrs.272.1638446036493; 
 Thu, 02 Dec 2021 03:53:56 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id j18sm2419580wmq.44.2021.12.02.03.53.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id A6E631FF9A;
 Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v9 3/9] Makefile: add GNU global tags support
Date: Thu,  2 Dec 2021 11:53:46 +0000
Message-Id: <20211202115352.951548-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, christoffer.dall@arm.com,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Ck1lc3NhZ2UtSWQ6IDwyMDIxMTExODE4NDY1MC42NjE1NzUtNC1hbGV4LmJlbm5lZUBsaW5hcm8u
b3JnPgotLS0KIE1ha2VmaWxlIHwgNSArKysrLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5k
ZXggYjgwYzMxZjguLjBiN2MwM2FjIDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmls
ZQpAQCAtMTIyLDYgKzEyMiw5IEBAIGNzY29wZToKIAkJLW5hbWUgJyouW2Noc1NdJyAtZXhlYyBy
ZWFscGF0aCAtLXJlbGF0aXZlLWJhc2U9JChDVVJESVIpIHt9IFw7IHwgc29ydCAtdSA+IC4vY3Nj
b3BlLmZpbGVzCiAJY3Njb3BlIC1iawogCi0uUEhPTlk6IHRhZ3MKKy5QSE9OWTogdGFncyBndGFn
cwogdGFnczoKIAljdGFncyAtUgorCitndGFnczoKKwlndGFncwotLSAKMi4zMC4yCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
