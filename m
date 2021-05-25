Return-Path: <SRS0=drPj=KU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8056C47084
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75D5861429
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75D5861429
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C3C4B0CC;
	Tue, 25 May 2021 13:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id smY8eZlWan28; Tue, 25 May 2021 13:26:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CFE74B0C5;
	Tue, 25 May 2021 13:26:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 384E4407F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dCAd1yFU4Eia for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 May 2021 13:26:32 -0400 (EDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3486F40573
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:32 -0400 (EDT)
Received: by mail-wm1-f49.google.com with SMTP id
 n17-20020a7bc5d10000b0290169edfadac9so4129365wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=kXRo+YB1GVPx3XHHAG0hUMJe4NWtnjWLeQgYeSAHJxA=;
 b=fo46SNxQ9jXF57/LLsGQwmPBq998FOLgxXImtPzwjSv5PhYgCPlHc1Q5qu+x7mR2az
 vn211zLTZ2VgKYgYqldEHEjX99dW4IF9YkS1cymW/a07x23jOQtXuKq5f2ToD6ZVxTLH
 I/1t5tlD4sEFRhf7fVe/R9xfiIFQXTeLL50B72cbHkcwzWDYpsqsgEWbUMrcUWvco6Y0
 5pHuoh3pGs+v6jI414e2f0MTGut8gci+2Kzec0K6/q1qdhwgxP5N4y2iNZUafp3XiVzp
 6GFCTvkRLNcb+lIlSmsoFttxDc/QzKyADnycty46hjwHPlXltbrXid7ttt2DVp2JYlvP
 iJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=kXRo+YB1GVPx3XHHAG0hUMJe4NWtnjWLeQgYeSAHJxA=;
 b=L3ICr6/98rKpNmiloN2KmLfXN4s6iTTJbTxEPY7zsD57jq9AsoHMmbcGmA7bUTnhQT
 ttqAepIsQWALhJ3LQEuWC0BOFG+vBYEd1XRutZ0VpKJ5/VtVXVk5nKo1ndEfaKQNtxaO
 t3u7tY9nNI3r/0mZAs9JXSdt7/BR8HQDUpAa2ep0US6BPTCjfka3llykLkKHlDC9Nto8
 aXasRnpJm3VBHhK3IYFYof7P7jaMuUg9Nzqa+uThG4/O8j3H3WBuu2CThC80Jx6Z4Vkl
 xxHCUUTnw7eYZaqfR00hhuZihAbHVewUQ0PxRY7VWwGN5AW8fLqFJBbC0L1B1UWq0C0Y
 vb1w==
X-Gm-Message-State: AOAM532HiJpdrzP/yoeLtrdz1SPS9+4AGXA2eF3hHEjt6rUrlz21DSUh
 b1QfO8Sa1X/vA6lSYBMCGYfTCw==
X-Google-Smtp-Source: ABdhPJzmGcXaLaloKoNuJvzV+Eso7SMQocRGBo9MMkwzzvUBiIigiYsDrY0W6M1IX6yPpG166F6kwg==
X-Received: by 2002:a1c:4043:: with SMTP id n64mr25571555wma.9.1621963591341; 
 Tue, 25 May 2021 10:26:31 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z9sm11615062wmi.17.2021.05.25.10.26.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 9809D1FF8F;
 Tue, 25 May 2021 18:26:28 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/4] arm64: enable its-migration tests for
 TCG
Date: Tue, 25 May 2021 18:26:27 +0100
Message-Id: <20210525172628.2088-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525172628.2088-1-alex.bennee@linaro.org>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
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

V2l0aCB0aGUgc3VwcG9ydCBmb3IgVENHIGVtdWxhdGVkIEdJQyB3ZSBjYW4gYWxzbyB0ZXN0IHRo
ZXNlIG5vdy4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4KQ2M6IFNoYXNoaSBNYWxsZWxhIDxzaGFzaGkubWFsbGVsYUBsaW5hcm8ub3JnPgotLS0K
IGFybS91bml0dGVzdHMuY2ZnIHwgMiAtLQogMSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvYXJtL3VuaXR0ZXN0cy5jZmcgYi9hcm0vdW5pdHRlc3RzLmNmZwppbmRl
eCBmNzc2YjY2Li4xYTM5NDI4IDEwMDY0NAotLS0gYS9hcm0vdW5pdHRlc3RzLmNmZworKysgYi9h
cm0vdW5pdHRlc3RzLmNmZwpAQCAtMTk0LDcgKzE5NCw2IEBAIGFyY2ggPSBhcm02NAogW2l0cy1t
aWdyYXRpb25dCiBmaWxlID0gZ2ljLmZsYXQKIHNtcCA9ICRNQVhfU01QCi1hY2NlbCA9IGt2bQog
ZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZlcnNpb249MyAtYXBwZW5kICdpdHMtbWlncmF0
aW9uJwogZ3JvdXBzID0gaXRzIG1pZ3JhdGlvbgogYXJjaCA9IGFybTY0CkBAIC0yMDIsNyArMjAx
LDYgQEAgYXJjaCA9IGFybTY0CiBbaXRzLXBlbmRpbmctbWlncmF0aW9uXQogZmlsZSA9IGdpYy5m
bGF0CiBzbXAgPSAkTUFYX1NNUAotYWNjZWwgPSBrdm0KIGV4dHJhX3BhcmFtcyA9IC1tYWNoaW5l
IGdpYy12ZXJzaW9uPTMgLWFwcGVuZCAnaXRzLXBlbmRpbmctbWlncmF0aW9uJwogZ3JvdXBzID0g
aXRzIG1pZ3JhdGlvbgogYXJjaCA9IGFybTY0Ci0tIAoyLjIwLjEKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
