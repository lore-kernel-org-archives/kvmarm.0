Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A236C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98F2D61038
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 98F2D61038
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 172BB4B28B;
	Fri, 12 Nov 2021 06:47:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SaqXRuSGAxLz; Fri, 12 Nov 2021 06:47:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A1054B293;
	Fri, 12 Nov 2021 06:47:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A68AE4B28B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8tldtf9S+DMW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 06:47:37 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A0014B289
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:37 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id u18so15016879wrg.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 03:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=y/FU8+bwf7DMlYAmB7NLQtYUyzsQrJXGMArM+f/WGbQ=;
 b=oIA3R5dQ8KPpSky2EHZb76G9smza8Up8hdy9YTLR/rN80He4si4N7T3hLw11/rUrND
 RDV7+4YZds9cFkEnxKHSAFfp5DSxwYa14HbCwQDYAdrEDER+XWxp3uhBtx8Iiu1W3/Vj
 Jyo+r/ob1dYpI0p0UZc+24JKo3yYlYk2kmNyQw0zJU2pM76AP1GvTATQcHn3vn9tgu00
 +W546e8e6D07Z1CUFzTuiGEKVhxTZcs6KvU5kFWKtxffq+qm31gjCGxlOwv4OhTfaRbL
 lU7p1XQkhVFqQ6xfBReh5rx+R6PouLMJroulc1ZE/BIM6KfGtzEIKGzjxl/OcpyZYAfK
 cSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=y/FU8+bwf7DMlYAmB7NLQtYUyzsQrJXGMArM+f/WGbQ=;
 b=Nlf2pPvyNaWRgOAmAk+Mu/tc4yBEhU8ORveLyNl6xNgbrutQAuuBHSyEacAMRZNlLp
 M/1W6AeqbLv125xJZQ3p+uidE4iAhZdPTmadJ0knAfaOLZ5CVYSGeQwGu1FJaWeIjEgv
 KvIbYGZ+Vj3ZsJ+4JlxGAcsyxoCpOexIfwUN5CFD90PRrYxYYhHisLysXUMEQUMzwXk/
 pdtIlTHf2Xqg/Ep9skYbqC6BNYVUXiB2o68jTt3AFhNbC+INrJiz/JAb+aw+J19oiuAx
 nD724t6mTmAfBXOgP+DJ9HHQ7xTWP0bUpzjZAzeJiiV0xseBr8d2RGhu/DMAz9G782TB
 mbhg==
X-Gm-Message-State: AOAM531MCJNGWFy4UsXT64ABbXJLd8s5YfHS01QGpSmph+Z8dEK622Ug
 k7omokuPmbCSCPS3vIlmaTTxmA==
X-Google-Smtp-Source: ABdhPJzW5BOflAYjrD9sAe1tHGRVbSLAvpIz35Bl4aw9fwu8ZT75ZP2FyPRAIGfrez5XVflGq+GsOw==
X-Received: by 2002:a5d:6c6b:: with SMTP id r11mr17814784wrz.231.1636717656571; 
 Fri, 12 Nov 2021 03:47:36 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id h15sm5565709wml.9.2021.11.12.03.47.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 03:47:34 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 4C9FC1FF96;
 Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date: Fri, 12 Nov 2021 11:47:31 +0000
Message-Id: <20211112114734.3058678-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
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

SGksCgpTb3JyeSB0aGlzIGhhcyBiZWVuIHNpdHRpbmcgaW4gbXkgdHJlZSBzbyBsb25nLiBUaGUg
Y2hhbmdlcyBhcmUgZmFpcmx5Cm1pbm9yIGZyb20gdjIuIEkgbm8gbG9uZ2VyIHNwbGl0IHRoZSB0
ZXN0cyB1cCBpbnRvIFRDRyBhbmQgS1ZNCnZlcnNpb25zIGFuZCBpbnN0ZWFkIGp1c3QgZW5zdXJl
IHRoYXQgRVJSQVRBX0ZPUkNFIGlzIGFsd2F5cyBzZXQgd2hlbgpydW4gdW5kZXIgVENHLgoKQWxl
eCBCZW5uw6llICgzKToKICBhcm02NDogcmVtb3ZlIGludmFsaWQgY2hlY2sgZnJvbSBpdHMtdHJp
Z2dlciB0ZXN0CiAgYXJtNjQ6IGVuYWJsZSBpdHMtbWlncmF0aW9uIHRlc3RzIGZvciBUQ0cKICBh
cmNoLXJ1bjogZG8gbm90IHByb2Nlc3MgRVJSQVRBIHdoZW4gcnVubmluZyB1bmRlciBUQ0cKCiBz
Y3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAgNCArKystCiBhcm0vZ2ljLmMgICAgICAgICAgICAgfCAx
NiArKysrKystLS0tLS0tLS0tCiBhcm0vdW5pdHRlc3RzLmNmZyAgICAgfCAgMyAtLS0KIDMgZmls
ZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCi0tIAoyLjMwLjIK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
