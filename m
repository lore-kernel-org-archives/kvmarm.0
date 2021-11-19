Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89699C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 302F261B5E
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 302F261B5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C854B186;
	Fri, 19 Nov 2021 11:37:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LQjxsDqjIAz5; Fri, 19 Nov 2021 11:37:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C394B19A;
	Fri, 19 Nov 2021 11:37:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 681CB40573
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qr9NhJOpyExO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 11:37:16 -0500 (EST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE02F4B13D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:15 -0500 (EST)
Received: by mail-wr1-f50.google.com with SMTP id a9so19132223wrr.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 08:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
 b=YafddRxj9VBjZzRlxSamFKtngp9kYQ/Om6EnwnudYXjJCJd722nl8E5+pxBa7+IsPc
 83efOXLfP236CvwaWzzAxIMlzCcdKh8S+J7sMw2Meb7MZYYiH5kb4BU1yowwH+TewDI6
 X2wl3xmG/2/4mjDUuRK1es7OGu0lWBR2jMsV4LVwHfKT7TPClcNFHc3W/2btWNjvNFJ7
 30Sp0dfQIc5SEF6NpuQjdaATSmdhExxfBHWU3/1SEebk+mYPT8aWAU+Y+5OkvC2aqV5u
 DHNOYSrn9t+mSyQymC+FIW69HipUe4ItdOnWD/ltILkAbB0qE3BAcY5B8wAx+UONSO6i
 3mPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
 b=k0KLa2+E/wQyPHJIM58ee1HWsCPYorjYp4gu5lVheKRcCaLot+vNqQAYVPA4Z8uR8V
 brUbnjFiTGh0ne9h8se4YitL37dJh8DLBMWmnBAw2a7DPURy/CSyCEBFekpABjBrLhpw
 KXc36ZSjVyWNYaIXL6o/REMuD5YpUbFVM/dE2J7mUaAgvSRxNs30xlmDG5/GbgNTAgc2
 08Rmq9i4Pqb048O3Wrz24udJChK9ogvRo6gVdDm2n9SQZhpEqHLr0DlApj948wM6jG3V
 ru2go3/fO+VfyMa8Q9Twq1/iFWa/XM9stUlYw5nZ5MXW8HbJvUG47Xr8LmXk7OVKhndB
 LkUA==
X-Gm-Message-State: AOAM532zqNxxU9axAnFysg+NYesKREvDkx0pg1OZBlkYMMp1J4jR7C8c
 3s+wT5bMTcyL6D+VgwbTQY0WAw==
X-Google-Smtp-Source: ABdhPJy8eUMgWTmXLHQO73lzwoAiNLaV22W1knajMZd2flThIs36ASzjzldkk3oB/MzzmN49Z8cxrQ==
X-Received: by 2002:a05:6000:143:: with SMTP id
 r3mr9139425wrx.236.1637339834937; 
 Fri, 19 Nov 2021 08:37:14 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id r8sm328551wrz.43.2021.11.19.08.37.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 721D91FF9A;
 Fri, 19 Nov 2021 16:37:10 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 3/3] arch-run: do not process ERRATA when
 running under TCG
Date: Fri, 19 Nov 2021 16:37:10 +0000
Message-Id: <20211119163710.974653-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163710.974653-1-alex.bennee@linaro.org>
References: <20211119163710.974653-1-alex.bennee@linaro.org>
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

QWxsIHRoZSBlcnJhdGEgY2hlY2tpbmcgbG9va3MgYXQgdGhlIGN1cnJlbnQgaG9zdCBrZXJuZWwg
dmVyc2lvbi4gRm9yClRDRyBydW5zIHRoaXMgaXMgZW50aXJlbHkgaXJyZWxldmFudCBhcyB0aGUg
aG9zdCBrZXJuZWwgaGFzIG5vIGltcGFjdApvbiB0aGUgYmVoYXZpb3VyIG9mIHRoZSBndWVzdC4g
SW4gZmFjdCB3ZSBzaG91bGQgc2V0IEVSUkFUQV9GT1JDRSB0bwplbnN1cmUgd2UgcnVuIHRob3Nl
IHRlc3RzIGFzIFFFTVUgZG9lc24ndCBhdHRlbXB0IHRvIG1vZGVsCm5vbi1jb25maXJtaW5nIGFy
Y2hpdGVjdHVyZXMuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxp
bmFyby5vcmc+Ci0tLQogc2NyaXB0cy9hcmNoLXJ1bi5iYXNoIHwgNCArKystCiAxIGZpbGUgY2hh
bmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvc2NyaXB0
cy9hcmNoLXJ1bi5iYXNoIGIvc2NyaXB0cy9hcmNoLXJ1bi5iYXNoCmluZGV4IDQzZGE5OTguLmYx
ZjQ0NTYgMTAwNjQ0Ci0tLSBhL3NjcmlwdHMvYXJjaC1ydW4uYmFzaAorKysgYi9zY3JpcHRzL2Fy
Y2gtcnVuLmJhc2gKQEAgLTI2Nyw3ICsyNjcsOSBAQCBlbnZfZmlsZSAoKQogCiBlbnZfZXJyYXRh
ICgpCiB7Ci0JaWYgWyAiJEVSUkFUQVRYVCIgXSAmJiBbICEgLWYgIiRFUlJBVEFUWFQiIF07IHRo
ZW4KKwlpZiBbICIkQUNDRUwiID0gInRjZyIgXTsgdGhlbgorCQlldmFsIGV4cG9ydCAiRVJSQVRB
X0ZPUkNFPXkiCisJZWxpZiBbICIkRVJSQVRBVFhUIiBdICYmIFsgISAtZiAiJEVSUkFUQVRYVCIg
XTsgdGhlbgogCQllY2hvICIkRVJSQVRBVFhUIG5vdCBmb3VuZC4gKEVSUkFUQVRYVD0kRVJSQVRB
VFhUKSIgPiYyCiAJCXJldHVybiAyCiAJZWxpZiBbICIkRVJSQVRBVFhUIiBdOyB0aGVuCi0tIAoy
LjMwLjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
