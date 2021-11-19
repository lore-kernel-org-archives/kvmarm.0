Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E98CC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A021D61B54
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A021D61B54
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B03B4B173;
	Fri, 19 Nov 2021 11:37:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tT7A+BYzicFL; Fri, 19 Nov 2021 11:37:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 734A84B160;
	Fri, 19 Nov 2021 11:37:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62C104B13D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mHf8wktkg2ZD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 11:37:13 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E43FE40573
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:12 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id
 j140-20020a1c2392000000b003399ae48f58so3055539wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 08:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Ne94VJfZDK04h60ves/49Vcgxn9w2Q0j+uNO+mfL7rY=;
 b=NQkP/P7hX5+nO7R0Rf53Kv3BJ7CFzilsoscyduffj1rubsPnP6sBb0O0qy35gFKvpK
 50xrWOMR9SZyZjMAZItCL5nt+YnZ9OQfCm3zDkF/KcQHbibgeHMQnnerlEBpCafbXRwd
 73HGc3cDfS6/9hXzRCslyLVb/3B+NVdnTo37A9H2SD4Sn9UG9FL229kcqt77Hju00iFL
 KOSD5M7e2HeHErq61GB4sizSEeyUJOvEt1R3g9jpWBZWvhKLnhmx8yBCZzUezpzy4uI7
 mmHLyc88PJzST1i4PYLZRcSfQ89HkUNCN3WN5ZdD6sjpqvyjdj5+SVh8ap8Brk6Id2Mq
 0rUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Ne94VJfZDK04h60ves/49Vcgxn9w2Q0j+uNO+mfL7rY=;
 b=F/udLPNb/P7mdvvyj96/XBzAwIpyGZE8DWT+N77YYbf3hPwc025tjzvCVQH5chVrek
 GrCgFRoQeJmr4n07IPKT82jK7uWDdRITlMfXEqWCMXeDrmKOHagC4eWmFGnjI1waELs6
 rRWPOwcY6IFIjmnie6iOvNK/ov9Ir+sbd75JWcK7DwaDbwAbbyGesrnCQsNrNjHN+hZg
 XM+EOE/ksMiv3V0uyE62EcyKAZePRGR5uNZsHMvwESgo+Zuo2dsG7BzIlW9bDmIET57p
 TmdXU6DJoL6DNOB84I56fEGR4kAcSO1P5JHFc5aH6kR/bd+NqMChSK2AokipCDOEvRG0
 ihYg==
X-Gm-Message-State: AOAM532v3xJ/iRKtgkC4LJ+Ce3vw+RxJfTWNTlvCtdoHGAYzcUJHBQuj
 3c4jHvqoYWUITzzpEJZjFFvMHw==
X-Google-Smtp-Source: ABdhPJwCtAhq2pYFZwvjfWTMoIx08PNceplWytfolYdNt0A+2FzmEq8lkJB/7bIO+pClFqXXU0Omxw==
X-Received: by 2002:a7b:c756:: with SMTP id w22mr1280618wmk.34.1637339831812; 
 Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id n32sm16627337wms.1.2021.11.19.08.37.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 648011FF98;
 Fri, 19 Nov 2021 16:37:10 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 1/3] arm64: remove invalid check from
 its-trigger test
Date: Fri, 19 Nov 2021 16:37:08 +0000
Message-Id: <20211119163710.974653-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163710.974653-1-alex.bennee@linaro.org>
References: <20211119163710.974653-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, Shashi Mallela <shashi.mallela@linaro.org>,
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

V2hpbGUgYW4gSVJRIGlzIG5vdCAiZ3VhcmFudGVlZCB0byBiZSB2aXNpYmxlIHVudGlsIGFuIGFw
cHJvcHJpYXRlCmludmFsaWRhdGlvbiIgaXQgZG9lc24ndCBzdG9wIHRoZSBhY3R1YWwgaW1wbGVt
ZW50YXRpb24gZGVsaXZlcmluZyBpdAplYXJsaWVyIGlmIGl0IHdhbnRzIHRvLiBUaGlzIGlzIHRo
ZSBjYXNlIGZvciBRRU1VJ3MgVENHIGFuZCBhcyB0ZXN0cwpzaG91bGQgb25seSBiZSBjaGVja2lu
ZyBhcmNoaXRlY3R1cmFsIGNvbXBsaWFuY2UgdGhpcyBjaGVjayBpcwppbnZhbGlkLgoKU2lnbmVk
LW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpSZXZpZXdlZC1i
eTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpDYzogU2hhc2hpIE1hbGxlbGEg
PHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Ck1lc3NhZ2UtSWQ6IDwyMDIxMDUyNTE3MjYyOC4y
MDg4LTItYWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tLQp2NAogIC0gZHJvcCB0aGUgcGVuZGlu
ZyB0ZXN0IGFsdG9nZXRoZXIKdjMKICAtIHJlZmxvdyB0aGUgY29tbWVudCwgZHJvcCAid2lsbGlu
Z2x5IGRvIG5vdCBjYWxsIiBhcyBwZXIgRXJpYydzIHN1Z2dlc3Rpb24KLS0tCiBhcm0vZ2ljLmMg
fCAyOCArKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNl
cnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcm0vZ2ljLmMgYi9hcm0v
Z2ljLmMKaW5kZXggOTgxMzVlZi4uMWI5YWQwNiAxMDA2NDQKLS0tIGEvYXJtL2dpYy5jCisrKyBi
L2FybS9naWMuYwpAQCAtNzMyLDM0ICs3MzIsMjIgQEAgc3RhdGljIHZvaWQgdGVzdF9pdHNfdHJp
Z2dlcih2b2lkKQogCQkJImRldjIvZXZlbnRpZD0yMCBkb2VzIG5vdCB0cmlnZ2VyIGFueSBMUEki
KTsKIAogCS8qCi0JICogcmUtZW5hYmxlIHRoZSBMUEkgYnV0IHdpbGxpbmdseSBkbyBub3QgY2Fs
bCBpbnZhbGwKLQkgKiBzbyB0aGUgY2hhbmdlIGluIGNvbmZpZyBpcyBub3QgdGFrZW4gaW50byBh
Y2NvdW50LgotCSAqIFRoZSBMUEkgc2hvdWxkIG5vdCBoaXQKKwkgKiByZS1lbmFibGUgdGhlIExQ
SS4gV2hpbGUgIkEgY2hhbmdlIHRvIHRoZSBMUEkgY29uZmlndXJhdGlvbgorCSAqIGlzIG5vdCBn
dWFyYW50ZWVkIHRvIGJlIHZpc2libGUgdW50aWwgYW4gYXBwcm9wcmlhdGUKKwkgKiBpbnZhbGlk
YXRpb24gb3BlcmF0aW9uIGhhcyBjb21wbGV0ZWQiIGhhcmR3YXJlIHRoYXQgZG9lc24ndAorCSAq
IGltcGxlbWVudCBjYWNoZXMgbWF5IGhhdmUgZGVsaXZlcmVkIHRoZSBldmVudCBhdCBhbnkgcG9p
bnQKKwkgKiBhZnRlciB0aGUgZW5hYmxpbmcuIENoZWNrIHRoZSBMUEkgaGFzIGhpdCBieSB0aGUg
dGltZSB0aGUKKwkgKiBpbnZhbGwgaXMgZG9uZS4KIAkgKi8KLQlnaWN2M19scGlfc2V0X2NvbmZp
Zyg4MTk1LCBMUElfUFJPUF9ERUZBVUxUKTsKLQlzdGF0c19yZXNldCgpOwotCWNwdW1hc2tfY2xl
YXIoJm1hc2spOwotCWl0c19zZW5kX2ludChkZXYyLCAyMCk7Ci0Jd2FpdF9mb3JfaW50ZXJydXB0
cygmbWFzayk7Ci0JcmVwb3J0KGNoZWNrX2Fja2VkKCZtYXNrLCAtMSwgLTEpLAotCQkJImRldjIv
ZXZlbnRpZD0yMCBzdGlsbCBkb2VzIG5vdCB0cmlnZ2VyIGFueSBMUEkiKTsKLQotCS8qIE5vdyBj
YWxsIHRoZSBpbnZhbGwgYW5kIGNoZWNrIHRoZSBMUEkgaGl0cyAqLwogCXN0YXRzX3Jlc2V0KCk7
Ci0JY3B1bWFza19jbGVhcigmbWFzayk7Ci0JY3B1bWFza19zZXRfY3B1KDMsICZtYXNrKTsKKwln
aWN2M19scGlfc2V0X2NvbmZpZyg4MTk1LCBMUElfUFJPUF9ERUZBVUxUKTsKIAlpdHNfc2VuZF9p
bnZhbGwoY29sMyk7Ci0Jd2FpdF9mb3JfaW50ZXJydXB0cygmbWFzayk7Ci0JcmVwb3J0KGNoZWNr
X2Fja2VkKCZtYXNrLCAwLCA4MTk1KSwKLQkJCSJkZXYyL2V2ZW50aWQ9MjAgcGVuZGluZyBMUEkg
aXMgcmVjZWl2ZWQiKTsKLQotCXN0YXRzX3Jlc2V0KCk7CiAJY3B1bWFza19jbGVhcigmbWFzayk7
CiAJY3B1bWFza19zZXRfY3B1KDMsICZtYXNrKTsKIAlpdHNfc2VuZF9pbnQoZGV2MiwgMjApOwog
CXdhaXRfZm9yX2ludGVycnVwdHMoJm1hc2spOwogCXJlcG9ydChjaGVja19hY2tlZCgmbWFzaywg
MCwgODE5NSksCi0JCQkiZGV2Mi9ldmVudGlkPTIwIG5vdyB0cmlnZ2VycyBhbiBMUEkiKTsKKwkJ
CSJkZXYyL2V2ZW50aWQ9MjAgdHJpZ2dlcnMgYW4gTFBJIik7CiAKIAlyZXBvcnRfcHJlZml4X3Bv
cCgpOwogCi0tIAoyLjMwLjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
