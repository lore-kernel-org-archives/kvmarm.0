Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBA2C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 234C261027
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 234C261027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3FEA4B289;
	Fri, 12 Nov 2021 06:47:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K-co0nmtoZrp; Fri, 12 Nov 2021 06:47:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 589B84B2AC;
	Fri, 12 Nov 2021 06:47:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D65224B293
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vq0JLzadGhvo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 06:47:40 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC1A14B28A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:39 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id z200so7486350wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 03:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
 b=ekMdpRSWqlWSiVvgjeBT9YCV7iKV0LVPJ2/pvZ9fE1XNUmTdejv3hLY5TgCN2JeNmm
 RzFDxbABVIOcACSv0wagoMA+lSfGzkkDkkAN//LkyA56Ypv9xHW8vPC3hCOJYYyfV9eL
 QFBZn8oFKa/VYZpynM1yus3PggSbk0k8V0WPGs6Op3CMkIJSeNR+OBx/XOkDTqif+A78
 vmk+j6Awz8fC3m7xjtRDPa+Wddv349oYxfbkFrfZrYAY3XTBPzqxQnZlAVtGHdGfbG5b
 TPZm7b/CebLhI7lxQygEeCptWT0KPezGCjvkJGWc4r2qaGd7S2/ffGCtLeu5yumunjj+
 0ozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
 b=hpCmdGFti0sKOVceIU/eI9uLuyHLq7DyTvYwyxsm04quwm/qkSK9YQJ6zXnXzASyFU
 Y8ep3yphHKewAzJGibC/sOGKVnFhTgvA9KzdXqVGhFUAAA7R2Y9XJvgEkUUHlx1JEvaw
 hwAIJav7O1kARKdEwMSK46F31Bn/Fm902NWTVrLKXYLwlXh5zCtj6t8EFTbMRskOZVce
 zJgIn6UK+EhGjlWtB3jyCiIYSA47jG7JpB83IPpeZ+bDh6rwFZj+jM0S4ihaDnxu4Qxm
 Fqg+yNKNZfjyHDMpmrT1i/BGa4SVLuNi+uh28A1P8dcExFr77dVAgng7RjzpcHUOhrhA
 ovVQ==
X-Gm-Message-State: AOAM5319AnMx+/VzaCu2XZNQ8fBWdPYotXBqkzj+E3oTih6o/SCQsc3d
 n7ObvG3srdcOFl4cWEIvzDcOtw==
X-Google-Smtp-Source: ABdhPJycSrQXrI5ANFDX5SP4MV9P9LBxdBIXWlPbv0YqQTSfXy6gbpG8wLqr2Do/3gKPIUsWbTPCWw==
X-Received: by 2002:a05:600c:221a:: with SMTP id
 z26mr34679356wml.20.1636717659036; 
 Fri, 12 Nov 2021 03:47:39 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id c11sm7674349wmq.27.2021.11.12.03.47.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 03:47:34 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 704FF1FF99;
 Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/3] arm64: enable its-migration tests for
 TCG
Date: Fri, 12 Nov 2021 11:47:33 +0000
Message-Id: <20211112114734.3058678-3-alex.bennee@linaro.org>
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
