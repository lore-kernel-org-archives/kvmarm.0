Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43EF2C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F29061424
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F29061424
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6834B1F1;
	Wed, 28 Apr 2021 06:18:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xzma49d-w0NO; Wed, 28 Apr 2021 06:18:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 122C64B22D;
	Wed, 28 Apr 2021 06:18:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22FEC4B22B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tP0H9I20L9oQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 06:18:47 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EFBC4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:47 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id
 82-20020a1c01550000b0290142562ff7c9so4364020wmb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 03:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=PKGDTgiVcM/lQ6iRrmAsUOi9EArz4u3h1iRq434eRSA=;
 b=KR9NTcMYjJQLFeqrQ2TR6ifAqSo99rz39UJx//d3x6y1Dy1pWofUW08E+LT0G8mVAu
 1IM32Pw4NlYnD+xTg/GD6c9VGP7xlLlG9Y2F8puVHsRfS6nDxFa18AxQoLHqOEEiDhFD
 CYUxDhIHvSkLOYmsljUOkO0Pc96WjOXotVbjEexdG/4GSmx91wy1wz3Yo5tqu5m7YE+z
 0ZaBAmhS4XQ54zJmw/RMOXvBqZhFFJ8zXcLcP4QHA4ByKgyzYDoGTPRNb/OtE5I0ZTTr
 nSsnifL9HuaMPbTmyJO09WDgQ3PpZisNvjT6fIKEq7wyFN0EhJEa3+WDeIHyObwh4Rvu
 UZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=PKGDTgiVcM/lQ6iRrmAsUOi9EArz4u3h1iRq434eRSA=;
 b=gPNMU3odB5TzpER/FITxSgI+6mnSVxqZ0a4h7hNE4pG2H3NHUrZZTOgPYFaochEZWX
 PVCYufEB42wykL3H9u4sIQrGVkzcRe0SxVGEcAawzJalz7lXgTlI/1XntM55HVbW2fJK
 5gR0ywjnx2f25iZ5VZmK9jpmJHGlIzAm8BP3VXzVI8NkFZtJykpYLhFDQomOkkNlSznS
 fg/HBuY3kH4qnh/Mr7+5DXc6yuNmX6F+gyoQ7Eit94CWK3+Il2y41haTCMU6WCkN8znA
 tB4XtUe047tWfuwZ3kcMiHS7IS51sE5HFDnISfHhjyz2ZsWlfJ0hLfgIYPvUAER9dD4O
 SjMA==
X-Gm-Message-State: AOAM531I57/FrWTDgDwlyo09TNvE3OesDnZCNroyMbujfJ9QuyDReNPN
 fFZlshMmtF9QZAioy2ucFQotzw==
X-Google-Smtp-Source: ABdhPJzL3juJCDl3XA6F0deoJp88yUP3zghVWwtGs9VLwPOsZipRSr61EUnv0vcux7XC7IERZPmCgQ==
X-Received: by 2002:a05:600c:228a:: with SMTP id
 10mr30822102wmf.115.1619605126000; 
 Wed, 28 Apr 2021 03:18:46 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id l14sm7760562wrv.94.2021.04.28.03.18.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 1B26B1FF7E;
 Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 0/4] enable LPI and ITS for TCG
Date: Wed, 28 Apr 2021 11:18:40 +0100
Message-Id: <20210428101844.22656-1-alex.bennee@linaro.org>
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
ZXQgb2YgZmVhdHVyZXMuCgogIEZyb206IFNoYXNoaSBNYWxsZWxhIDxzaGFzaGkubWFsbGVsYUBs
aW5hcm8ub3JnPgogIFN1YmplY3Q6IFtQQVRDSCB2MiAwLzhdIEdJQ3YzIExQSSBhbmQgSVRTIGZl
YXR1cmUgaW1wbGVtZW50YXRpb24KICBEYXRlOiBXZWQsIDMxIE1hciAyMDIxIDIyOjQxOjQ0IC0w
NDAwCiAgTWVzc2FnZS1JZDogPDIwMjEwNDAxMDI0MTUyLjIwMzg5Ni0xLXNoYXNoaS5tYWxsZWxh
QGxpbmFyby5vcmc+CgpNb3N0IG9mIHRoZSBjaGFuZ2VzIGFyZSBtaW5vciBleGNlcHQgdGhlIGl0
cy10cmlnZ2VyIHRlc3Qgd2hpY2ggc2tpcHMKaW52YWxsIGhhbmRsaW5nIGNoZWNrcyB3aGljaCBJ
IHRoaW5rIGlzIHJlbHlpbmcgb24gSU1QREVGIGJlaGF2aW91cgp3aGljaCB3ZSBjYW4ndCBwcm9i
ZSBmb3IuIFRoZXJlIGlzIGFsc28gYSBoaWxhcmlvdXMgd29yayBhcm91bmQgdG8Kc29tZSBsaW1p
dGF0aW9ucyBpbiB0aGUgcnVuX21pZ3JhdGlvbigpIHNjcmlwdCBpbiB0aGUgbGFzdCBwYXRjaC4K
CkFsZXggQmVubsOpZSAoNCk6CiAgYXJtNjQ6IHNwbGl0IGl0cy10cmlnZ2VyIHRlc3QgaW50byBL
Vk0gYW5kIFRDRyB2YXJpYW50cwogIHNjcmlwdHMvYXJjaC1ydW46IGRvbid0IHVzZSBkZXByZWNh
dGVkIHNlcnZlci9ub3dhaXQgb3B0aW9ucwogIGFybTY0OiBlbmFibGUgaXRzLW1pZ3JhdGlvbiB0
ZXN0cyBmb3IgVENHCiAgYXJtNjQ6IHNwbGl0IGl0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rp
b24gaW50byBLVk0gYW5kIFRDRyB2YXJpYW50cwoKIHNjcmlwdHMvYXJjaC1ydW4uYmFzaCB8ICA0
ICstLQogYXJtL2dpYy5jICAgICAgICAgICAgIHwgNjcgKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLQogYXJtL3VuaXR0ZXN0cy5jZmcgICAgIHwgMjMgKysrKysrKysr
KysrLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDYyIGluc2VydGlvbnMoKyksIDMyIGRlbGV0aW9ucygt
KQoKLS0gCjIuMjAuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
