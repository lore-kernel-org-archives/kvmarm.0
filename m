Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1180C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74E7861B31
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 74E7861B31
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF344B183;
	Thu, 18 Nov 2021 13:47:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7l2ZkKiOwZkb; Thu, 18 Nov 2021 13:47:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD9C4B1FC;
	Thu, 18 Nov 2021 13:47:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2C04B219
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:47:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EvzJw683rOl9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:47:06 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D35A04B215
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:47:05 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id n29so13393519wra.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=4ZUZgHuD8NGUtXmK8AnZStWJy8xmbLtZriXcWFhy400=;
 b=tPWuwxoTarEuAMs1Cr0K1Krqok8qufGx6RqHKdovs46l6HbP+r9r+bOksExQa0YZDG
 AsoaKRil8lZWbPR012ZeNS/eQgdcSSwBTND/DHsfkJinAESipF/l47RgYCK7D9yD4Aio
 T8Y6P6sbDUNwqrn8MTUeJG7y6AvFCKD712kKLPvPaWNNtvKuinZplyk7fjbgm3kZsqRJ
 N3v3Jwa1Mfhb2Zk6CWQ2MOZQdSA3rbX5NknoDw2paAGO4VWketi0gk3I3DnClywHpIkE
 dGDdijAlG9Mj05jaZ8QvkdqOixKg8+Bx2d5lVU+Dt2aHvZ+f0HRxD75WSkOJoV62yoac
 BBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=4ZUZgHuD8NGUtXmK8AnZStWJy8xmbLtZriXcWFhy400=;
 b=EmxBR0AwX26C4gExm2+GExxUMwRNmbdLEjJZ1deeZpJJwsW2ys6l+bNsCt6b1Qveu+
 gIDtDIIBV7AQUvVq02OycBQnNAxaCRb2AgBJNX/9kxu9vMpcj92dy3JPDp/SPU4X+jf3
 lr0qsEkCTaaRUT/GjxmK14I5yF2l6ga1tAszaLAwof578BkKCk88xEzRerF1eQUKvOKV
 +Ek9n9iU3jKjm3CVrdkmyPPVHZhXVyBst5u/BcLrJwRb1rRllgLKNtX2cwVhONu+177k
 KjSVLrQjPqJ+bx1XhqsnLGupAzRl3gqJLPzKY/uVVSpBi9oHdUxJjDP//L/FJR53B+F9
 Pdeg==
X-Gm-Message-State: AOAM532v8Q7FGoeTuHik4ZdiwLPR5y6n/jmJn0+WaCb/QFsOndLaHa6t
 9TqWu/w+L8YlV2RzF01g/yWCag==
X-Google-Smtp-Source: ABdhPJwrdug8tImztTIg3ZfiYXxvh9yFWUBC2psfMHONmasEUnH8rpbLxJaonSmjf5pZLT3W2NFuZw==
X-Received: by 2002:a05:6000:2a3:: with SMTP id
 l3mr34560244wry.415.1637261225009; 
 Thu, 18 Nov 2021 10:47:05 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id y142sm458082wmc.40.2021.11.18.10.46.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:47:04 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 8504A1FFA5;
 Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 09/10] arm/run: use separate --accel form
Date: Thu, 18 Nov 2021 18:46:49 +0000
Message-Id: <20211118184650.661575-10-alex.bennee@linaro.org>
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

VGhpcyB3aWxsIGFsbG93IFRDRyB0ZXN0cyB0byBhbHRlciB0aGluZ3Mgc3VjaCBhcyB0Yi1zaXpl
LgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgot
LS0KIGFybS9ydW4gfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJtL3J1biBiL2FybS9ydW4KaW5kZXggYTM5MGNh
NS4uNzNjNmM4MyAxMDA3NTUKLS0tIGEvYXJtL3J1bgorKysgYi9hcm0vcnVuCkBAIC01OCw4ICs1
OCw4IEBAIGlmICRxZW11ICRNIC1kZXZpY2UgJz8nIDI+JjEgfCBncmVwIHBjaS10ZXN0ZGV2ID4g
L2Rldi9udWxsOyB0aGVuCiAJcGNpX3Rlc3RkZXY9Ii1kZXZpY2UgcGNpLXRlc3RkZXYiCiBmaQog
Ci1NKz0iLGFjY2VsPSRBQ0NFTCIKLWNvbW1hbmQ9IiRxZW11IC1ub2RlZmF1bHRzICRNIC1jcHUg
JHByb2Nlc3NvciAkY2hyX3Rlc3RkZXYgJHBjaV90ZXN0ZGV2IgorQT0iLWFjY2VsICRBQ0NFTCIK
K2NvbW1hbmQ9IiRxZW11IC1ub2RlZmF1bHRzICRNICRBIC1jcHUgJHByb2Nlc3NvciAkY2hyX3Rl
c3RkZXYgJHBjaV90ZXN0ZGV2IgogY29tbWFuZCs9IiAtZGlzcGxheSBub25lIC1zZXJpYWwgc3Rk
aW8gLWtlcm5lbCIKIGNvbW1hbmQ9IiQobWlncmF0aW9uX2NtZCkgJCh0aW1lb3V0X2NtZCkgJGNv
bW1hbmQiCiAKLS0gCjIuMzAuMgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
