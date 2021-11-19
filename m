Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5EFC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 639A661B1E
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 639A661B1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 196184B13A;
	Fri, 19 Nov 2021 11:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YzkJO9W8IK9Z; Fri, 19 Nov 2021 11:37:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E694B175;
	Fri, 19 Nov 2021 11:37:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E3534B160
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pXVSJKtQ+8oa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 11:37:19 -0500 (EST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD9EA4B13A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:16 -0500 (EST)
Received: by mail-wr1-f45.google.com with SMTP id d24so19182128wra.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 08:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=jMPYfacR2Cj+o7xlQDQb9ZFthvee/fPmicID5MFvuIA=;
 b=B/Eq/nE1KTPpwlO++bf+SrXNwr+P61EjRLmdrzsxg2yOW9MuTVqig2j3JPE3fMBATe
 Ai1JDSQagrGCpOon0ZrTRpMsPAE5VbI6/cU7j8XI5/v19gBh+ISt2B+LaKkzfj/kgkbw
 jq8OiJOMWRn2l4aIHmgmWq2hIMXTcXswe7hkHvLpnmQuVGyFMpBh9m/dKCPQu9Duqt32
 BSA2xcBz87ho7BmQJFJ9GP/RKEX9WkeJNKw1T+PyrCrc23u0fw9UKUQbDU3HUxpt3UvK
 VifvGlyUqo5pJigpEQRlidoYQcJWxjo749sO8xRMpdzk23ggIIaWX7tUHHScvPVOQclc
 lhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=jMPYfacR2Cj+o7xlQDQb9ZFthvee/fPmicID5MFvuIA=;
 b=bVseY7OJ4Ssf8eAdrin8d4Hlnf4x0DHr7eTFdjGiQFRWBicf86q2yO32lwExV5Mo/c
 +wreJV8RJWF/kwdjKNXtJfw7ztO4bT46j3I/bLO5lHLrf0NXrAZGRj6sceszbymSgfVs
 OB4pwtj6L8qT0/YRtluIg/z2MNllbWk2ujX3F9Wmt4Hu3/O9cBp0WC0z+vWl/0Q3tb/Q
 ruyc9G1SeX8n7y4UGLskoZwldGFvZeXA17e0nw9R+pj7QR/9ydo8AdLL1XBTu0R4EwTw
 TvSbZjRNoSTRe+c+EClXq7U9aUSvah6HF93X7X2d/B3Rs+zuB9gY8M6MD4x3jiD5yUPf
 FUqA==
X-Gm-Message-State: AOAM530tfrFyRFFqZR+ZxbdSfNgTC9nZkDX/flEPd60Id889eL3LmYnm
 HYeNjch/3F6sg2NyldOUZ/p9hw==
X-Google-Smtp-Source: ABdhPJzikzRuzfho8zkpVhiRsUw1Knnj9YomD9yAbueZCm1uGY6mSMAb9MbUBrGha7HQsdqk6lPKpQ==
X-Received: by 2002:a5d:4492:: with SMTP id j18mr9149357wrq.397.1637339835869; 
 Fri, 19 Nov 2021 08:37:15 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id h18sm259315wre.46.2021.11.19.08.37.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 57DF81FF96;
 Fri, 19 Nov 2021 16:37:10 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/3] GIC ITS tests
Date: Fri, 19 Nov 2021 16:37:07 +0000
Message-Id: <20211119163710.974653-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Cc: maz@kernel.org, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
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

SGksCgpjaGFuZ2VzIHNpbmNlIHYzOgoKICAtIGRyb3BwZWQgdGhlIHBlbmRpbmcgTFBJIHRlc3Qg
YWx0b2dldGhlcgoKQWxleCBCZW5uw6llICgzKToKICBhcm02NDogcmVtb3ZlIGludmFsaWQgY2hl
Y2sgZnJvbSBpdHMtdHJpZ2dlciB0ZXN0CiAgYXJtNjQ6IGVuYWJsZSBpdHMtbWlncmF0aW9uIHRl
c3RzIGZvciBUQ0cKICBhcmNoLXJ1bjogZG8gbm90IHByb2Nlc3MgRVJSQVRBIHdoZW4gcnVubmlu
ZyB1bmRlciBUQ0cKCiBzY3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAgNCArKystCiBhcm0vZ2ljLmMg
ICAgICAgICAgICAgfCAyOCArKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tCiBhcm0vdW5pdHRl
c3RzLmNmZyAgICAgfCAgMyAtLS0KIDMgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwg
MjQgZGVsZXRpb25zKC0pCgotLSAKMi4zMC4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
