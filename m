Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFD1C43334
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0B3D4C56C;
	Tue, 26 Jul 2022 03:38:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oabMtldezQY4; Tue, 26 Jul 2022 03:38:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 866FE4C564;
	Tue, 26 Jul 2022 03:38:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6029A4C536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WopeMAaVK8Es for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:25 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39EFB4C54C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:25 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-317f6128c86so105735027b3.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=9z1geK001Lgo4aQzTlFwh7+mdMHid79qtYIr9n0hiZw=;
 b=akqv8KPpQa1VNcDlRwBAf0WpbIAk4vEtYIJMvicQmBFeAaugRk9kLN6l+vafdsELTk
 NtqHPyYUML5CJ4AjDiY3dTaY+cSkOpg128D4ZkUQUG9Fz38Uro8ofjsPN0WzDtIet4WQ
 SZYEv+uBqfLl3qepTZ0OG6h7bYpZ3eDokb5EaIFJXHoiXBj3RK1eGwGvMWUb7qW6iO7g
 nyY0uYsGfoAPSXbog85aTEium1GWJ1Xhh3lcJ8Yp8ebpVrv98qa30n06S4cvxkTePaJB
 VUVCyyYygnDOUIC/8x/7m9q/JVzqjGe8IUGeLpvtVWbUFSdClA40lQjVHGIkuc85K3fB
 gYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=9z1geK001Lgo4aQzTlFwh7+mdMHid79qtYIr9n0hiZw=;
 b=VFtE1ZYgkpXL++YCx24A3yt6ec4zhDncjN1b/kB66m/fMILF15c89TuVP9Nk4vXcQC
 AVo9KdW1kl12xRiS+HOyoyd193NFAw3L6tWW0oS84qCm1nlzlq8NnGEEki6AQzB8ackg
 ZY0CuX/pYBi65rKm5Yj208Edc8g2MFgk75f6dXadXNjokGdwIRJzcQO37e4Pn3QjPGxi
 2i+z0huHSm+JmB7aYHS1fB52BjP6CXvPm5SNULNuN05fW6QKizNxDHFyWGtKDql7DsLn
 Q4o/7Zi2UcKwjPpG4pF4peLhpf7NY+guAFUN7jyKK0RxRI7SbpH1S0qu31ZRYttyTp1E
 a+Qw==
X-Gm-Message-State: AJIora+dOf4AHb7DVW+eRmQqtbYK7EMY1e/EOy5R028OA8rD/ek3Mvnx
 vG9WB5TpG0nxB9Ff9Pz8FHbp7hPWkZpY/iJwCQ==
X-Google-Smtp-Source: AGRyM1u5wMrg3Dj62VDc19qLELQ21pNgDjr7RG8JmDND2ovfsQwBtAh8lTkmGF1a/0WVMU+4RWrNFRXG8A0elKLu0w==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:ccca:0:b0:66e:c109:a884 with SMTP
 id l193-20020a25ccca000000b0066ec109a884mr12597907ybf.161.1658821105018; Tue,
 26 Jul 2022 00:38:25 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:45 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-13-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 12/17] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

VGhpcyBjYW4gYmUgdXNlZCB0byBkaXNhYmxlIHN0YWNrdHJhY2UgZm9yIHRoZSBwcm90ZWN0ZWQg
S1ZNCm5WSEUgaHlwZXJ2aXNvciwgaW4gb3JkZXIgdG8gc2F2ZSBvbiB0aGUgYXNzb2NpYXRlZCBt
ZW1vcnkgdXNhZ2UuCgpUaGlzIG9wdGlvbiBpcyBkaXNhYmxlZCBieSBkZWZhdWx0LCBzaW5jZSBw
cm90ZWN0ZWQgS1ZNIGlzIG5vdCB3aWRlbHkKdXNlZCBvbiBwbGF0Zm9ybXMgb3RoZXIgdGhhbiBB
bmRyb2lkIGN1cnJlbnRseS4KClNpZ25lZC1vZmYtYnk6IEthbGVzaCBTaW5naCA8a2FsZXNoc2lu
Z2hAZ29vZ2xlLmNvbT4KUmV2aWV3ZWQtYnk6IEZ1YWQgVGFiYmEgPHRhYmJhQGdvb2dsZS5jb20+
ClRlc3RlZC1ieTogRnVhZCBUYWJiYSA8dGFiYmFAZ29vZ2xlLmNvbT4KLS0tCgpDaGFuZ2VzIGlu
IHY2OgogIC0gQWRkIEZ1YWTigJlzIFJldmlld2VkLWJ5IGFuZCBUZXN0ZWQtYnkgdGFncwoKQ2hh
bmdlcyBpbiB2NToKICAtIE1ha2UgUFJPVEVDVEVEX05WSEVfU1RBQ0tUUkFDRSBkZXBlbmQgb24g
TlZIRV9FTDJfREVCVUcsIHBlciBNYXJjCgogYXJjaC9hcm02NC9rdm0vS2NvbmZpZyB8IDE1ICsr
KysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS9hcmNoL2FybTY0L2t2bS9LY29uZmlnIGIvYXJjaC9hcm02NC9rdm0vS2NvbmZpZwppbmRl
eCA4YTVmYmJmMDg0ZGYuLjA5Yzk5NTg2OTkxNiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0v
S2NvbmZpZworKysgYi9hcmNoL2FybTY0L2t2bS9LY29uZmlnCkBAIC00Niw2ICs0NiwyMSBAQCBt
ZW51Y29uZmlnIEtWTQogCiAJICBJZiB1bnN1cmUsIHNheSBOLgogCitjb25maWcgUFJPVEVDVEVE
X05WSEVfU1RBQ0tUUkFDRQorCWJvb2wgIlByb3RlY3RlZCBLVk0gaHlwZXJ2aXNvciBzdGFja3Ry
YWNlcyIKKwlkZXBlbmRzIG9uIE5WSEVfRUwyX0RFQlVHCisJZGVmYXVsdCBuCisJaGVscAorCSAg
U2F5IFkgaGVyZSB0byBlbmFibGUgcEtWTSBoeXBlcnZpc29yIHN0YWNrdHJhY2VzIG9uIGh5cF9w
YW5pYygpCisKKwkgIElmIHlvdSBhcmUgbm90IHVzaW5nIHByb3RlY3RlZCBuVkhFIChwS1ZNKSwg
c2F5IE4uCisKKwkgIElmIHVzaW5nIHByb3RlY3RlZCBuVkhFIG1vZGUsIGJ1dCBjYW5ub3QgYWZm
b3JkIHRoZSBhc3NvY2lhdGVkCisJICBtZW1vcnkgY29zdCAobGVzcyB0aGFuIDAuNzUgcGFnZSBw
ZXIgQ1BVKSBvZiBwS1ZNIHN0YWNrdHJhY2VzLAorCSAgc2F5IE4uCisKKwkgIElmIHVuc3VyZSwg
c2F5IE4uCisKIGNvbmZpZyBOVkhFX0VMMl9ERUJVRwogCWJvb2wgIkRlYnVnIG1vZGUgZm9yIG5v
bi1WSEUgRUwyIG9iamVjdCIKIAlkZXBlbmRzIG9uIEtWTQotLSAKMi4zNy4xLjM1OS5nZDEzNmM2
YzNlMi1nb29nCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
