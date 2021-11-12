Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD87C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B05C61027
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B05C61027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2B884B2A2;
	Fri, 12 Nov 2021 06:47:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W-7hbmMV5sjK; Fri, 12 Nov 2021 06:47:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78FBE4B2AF;
	Fri, 12 Nov 2021 06:47:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF81F4B28A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eEe4+VPF59Uw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 06:47:40 -0500 (EST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B45C4B28B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:40 -0500 (EST)
Received: by mail-wm1-f52.google.com with SMTP id i12so6632755wmq.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 03:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
 b=nKa9tSnccFVDYKK9xreBf5E8U8DoM82aZKRzyJaAiVfBKT/M0igcWjFSqwJRmAzyH3
 /Ew5QtICgoZALTkGsvJY+v3rwwA/MyZWeZyHLaYJbIyRAaIlUtWtNmhwZVHMnU0M3Tim
 jDoFtQs3T5Su6YcUbiyDbdC2U0rnyn1ziDqio0DeO/bkjljkcIi/z8kuu2XxPvJr6JeG
 LMw1U+Nd5RbjSEU7wdVJiec+W5N8bwQvgzCd4chJG2TOKkvzbKqCNzW7x1PWbzx+7ljV
 VoIcbW9DobWIGLr0rOACJJoyz7zAcMxssMrTIMa1m9MbdhnzH+h6j5CjAJfpbr9wP9AO
 TLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
 b=0ceFL6sK9xKyAvuOIal9ucSQ3wjNpBOIKqwMZgrMPGeHvyLYc+/wPjPY0nk5/cgsWm
 fmKDuzJiciYcnGM8siQz4juZVXwl40vZic4b2xzlNj2Wkd6VdIborqX8d3ZzZe+UaziT
 5sqEDqV7fWQfLpbkpxrAkuYJ9rcHhEr1DzbjXJA56Uh3LfseJj7ylqnUo11PQZhc5Zox
 hF+OotDJNdKraaQl3Ndl2X1iPrtg6VhbvECyBbAqL9p0b1URIO6xCL3fO+VgZqfAbFGg
 fTKaarFg0Z1f+ZEiDfYNUIclxMlngDb5PMpI32/4KXO/AF2kqd2Wj6TA3ilhB9/NrtZs
 tvgw==
X-Gm-Message-State: AOAM531+RQQoCoWvFI7COLDbSni04VsJfnKTUUNWJ9Bk8h7tsN1HZWxy
 4F/eQG3SHED+eGBr5F5vrBJ/Eg==
X-Google-Smtp-Source: ABdhPJyX3niJmZryPUPfdglj9K551u5JXl+8T/X4Z4IMOgbZlZMCBWf27TVzU+y8SWuEhDAPHIgd9g==
X-Received: by 2002:a05:600c:290b:: with SMTP id
 i11mr33816680wmd.137.1636717659462; 
 Fri, 12 Nov 2021 03:47:39 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z7sm11185426wmi.33.2021.11.12.03.47.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 03:47:36 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 8615C1FF9A;
 Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 3/3] arch-run: do not process ERRATA when
 running under TCG
Date: Fri, 12 Nov 2021 11:47:34 +0000
Message-Id: <20211112114734.3058678-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112114734.3058678-1-alex.bennee@linaro.org>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
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
