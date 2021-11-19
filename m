Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC356C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60A3761B51
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60A3761B51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 055C54B161;
	Fri, 19 Nov 2021 11:37:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XneXpUV0BPxr; Fri, 19 Nov 2021 11:37:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 866D24B172;
	Fri, 19 Nov 2021 11:37:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF444B13A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r0+XJwN2Lgbe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 11:37:13 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B838E4B131
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:37:13 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id u18so19144550wrg.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 08:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
 b=e15kIey1b4CZx3A2gFh3YGoEOOBLANHzES+s8ynrUIMrcIxhZ0RAzYbF33oUmrV6Zq
 FEo1FNJhvaGLwU86/nNt1Swt54YDhfpByOlduRXtxoEUUZ/CRPocMNxR7EjpmxXEZsq9
 t0xLpT3icgEc+CdaWEjtmAm1l5rw4/4pWXHtOffG8Ugx1MwBWB6cjEqJryM6WVfEDiA/
 TSRH8Xos8BfwkRMZz+JRZadeyCekVhdPidAbfrcxzNvl5EVVyuD/qPMYVI0N/Met20Cx
 cCX4GzDT/6DSWrdWTuOHUKahUMw4lIDkaox1a7B9WoA39hMjvHKqiuGk0RulBnxjw3fZ
 opDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
 b=RHO0YOUs2nYag5V8ZijyTbOh04BQhkRR2MawJEF5V3RW0Ao/PwCClYfmsn/b42n1qO
 sNc92b8i+kfp8UFrztUlXYn/i3xoFP+ju+/hNM85JP1bf/+1KISx4WxwUcbEcfHjwHXX
 U9pQdiy2kvaTgIaFoqQbIZQWgAn7zyJ/h10L5huUHG63S0UD/g6vv6XUuBl6zzLGNj6+
 bWlxdBsqsmh2LcuKekPMjjTwzZAnS2J/OsWathCSliQGX3egw/zwNligA6oUxvhQq8/P
 hZZb0cPgpIQEeB397WaKdhlogz1EKGBoVMDgngCHCy/LUxY4qWy+lVVJcn3FSpn+B8G+
 yYcw==
X-Gm-Message-State: AOAM532Y/T3M1nz3IxH17dczGGRArYm6Js7y6zfi9ZL6jG50iIVD17yN
 iMvw3qhZPGJZsqeKKJvzlvJ3OA==
X-Google-Smtp-Source: ABdhPJxD6Qo2C/M31secZFHpzSFy6cyq1TjHV99JAV9UnTNvIRrWR9sjgHQorI8fYuot9nYzW+MgfA==
X-Received: by 2002:a5d:6d0c:: with SMTP id e12mr9307168wrq.94.1637339832664; 
 Fri, 19 Nov 2021 08:37:12 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id a141sm12027233wme.37.2021.11.19.08.37.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 704E91FF99;
 Fri, 19 Nov 2021 16:37:10 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 2/3] arm64: enable its-migration tests for
 TCG
Date: Fri, 19 Nov 2021 16:37:09 +0000
Message-Id: <20211119163710.974653-3-alex.bennee@linaro.org>
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

V2l0aCB0aGUgc3VwcG9ydCBmb3IgVENHIGVtdWxhdGVkIEdJQyB3ZSBjYW4gYWxzbyB0ZXN0IHRo
ZXNlIG5vdy4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4KUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KUmV2
aWV3ZWQtYnk6IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPgpDYzogU2hhc2hpIE1h
bGxlbGEgPHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Ck1lc3NhZ2UtSWQ6IDwyMDIxMDUyNTE3
MjYyOC4yMDg4LTQtYWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tLQp2MwogIC0gYWRkIGl0cy1t
aWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24KLS0tCiBhcm0vdW5pdHRlc3RzLmNmZyB8IDMgLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcm0vdW5pdHRl
c3RzLmNmZyBiL2FybS91bml0dGVzdHMuY2ZnCmluZGV4IGY3NzZiNjYuLjIxNDc0YjggMTAwNjQ0
Ci0tLSBhL2FybS91bml0dGVzdHMuY2ZnCisrKyBiL2FybS91bml0dGVzdHMuY2ZnCkBAIC0xOTQs
NyArMTk0LDYgQEAgYXJjaCA9IGFybTY0CiBbaXRzLW1pZ3JhdGlvbl0KIGZpbGUgPSBnaWMuZmxh
dAogc21wID0gJE1BWF9TTVAKLWFjY2VsID0ga3ZtCiBleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBn
aWMtdmVyc2lvbj0zIC1hcHBlbmQgJ2l0cy1taWdyYXRpb24nCiBncm91cHMgPSBpdHMgbWlncmF0
aW9uCiBhcmNoID0gYXJtNjQKQEAgLTIwMiw3ICsyMDEsNiBAQCBhcmNoID0gYXJtNjQKIFtpdHMt
cGVuZGluZy1taWdyYXRpb25dCiBmaWxlID0gZ2ljLmZsYXQKIHNtcCA9ICRNQVhfU01QCi1hY2Nl
bCA9IGt2bQogZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZlcnNpb249MyAtYXBwZW5kICdp
dHMtcGVuZGluZy1taWdyYXRpb24nCiBncm91cHMgPSBpdHMgbWlncmF0aW9uCiBhcmNoID0gYXJt
NjQKQEAgLTIxMCw3ICsyMDgsNiBAQCBhcmNoID0gYXJtNjQKIFtpdHMtbWlncmF0ZS11bm1hcHBl
ZC1jb2xsZWN0aW9uXQogZmlsZSA9IGdpYy5mbGF0CiBzbXAgPSAkTUFYX1NNUAotYWNjZWwgPSBr
dm0KIGV4dHJhX3BhcmFtcyA9IC1tYWNoaW5lIGdpYy12ZXJzaW9uPTMgLWFwcGVuZCAnaXRzLW1p
Z3JhdGUtdW5tYXBwZWQtY29sbGVjdGlvbicKIGdyb3VwcyA9IGl0cyBtaWdyYXRpb24KIGFyY2gg
PSBhcm02NAotLSAKMi4zMC4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
