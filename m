Return-Path: <SRS0=drPj=KU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E186C47085
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4994161429
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4994161429
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFEB24B0C6;
	Tue, 25 May 2021 13:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bYMDOBZlSeFR; Tue, 25 May 2021 13:26:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4C44B0D6;
	Tue, 25 May 2021 13:26:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 628C04AEF8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dD57DhQwcs2T for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 May 2021 13:26:34 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E5274086D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:34 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id z17so33068635wrq.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 10:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=bomimE0My6Mrc6nvo4jcRDAsXmDo+wwewZnyFoFd9Qs=;
 b=FMU3n4mKiMC3eE6glB9HkdZs5xGVasuZxHEKqdM/ZsUo9pAs9YMC0neSuF+Ad4JaQu
 O88qdfYxChF9eRWfVQZw64sa8ZI9BKW7CWCRiAqRdStismovf1xTxHSSWqqdGD6xj7+q
 rr/tfKCh76T+FN2hk5qG8+FdqSF4lkjcAziSPkgHUhRHGdO303tRrJG5RI72coSG9k5a
 qbl7GD+uFYxxlnYBCk5Sfu7AvYCvVY+1X2Q5F7syHfgO+DZYxycLf0HOBNP0HI7iktF4
 AHSeVjT1IVoMj3glEHdhLhRY7LBmHGht6jWbh50NnddoxvwHtiqKvlNzgUOzfUCyYvEU
 K2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=bomimE0My6Mrc6nvo4jcRDAsXmDo+wwewZnyFoFd9Qs=;
 b=bE59HrMyo88fZrgc3He6VkIuD85qPLM8xhVeTv2eJ3+jW5MYsD+JTl8t6aAkeWStcU
 oL5QaAFETSglhgfS4J7TUmDrAjGrJiyiL4VquhMh6XQF5GP40C88HIszzuOJbML48rlU
 1Xzq/w7tb7jjk/If5ht/08GW0uaeGbKY226CccgI/spvZnKUsukdLfNJJmtkUJEozN5p
 nG5SS1Ai8W5pSJeD5EIykzBUyMrMDcXB0LrUvskNw0J7PmL7t/qDEggqZsife2qGaYDt
 3S+/8RDK803HfeMhirpWwe0+bamSPt6M3OVaOjNK2vR5DBj0QxXksdPTgxupeFcupv46
 lFkw==
X-Gm-Message-State: AOAM530ykKcta3KdQ3CLfFN0MZvnuPDk2s6VDadDEz5qEth3m1IcWNd3
 A+mI8qKXiF/596v98nE/GH8ecQ==
X-Google-Smtp-Source: ABdhPJxOcc28Mui0TDrzYURL2X6tyH8HpOBr8o1aIEP2vFUWuQdcnhbd2edMaLArv+UiTrSyKo6ekA==
X-Received: by 2002:a5d:6910:: with SMTP id t16mr28171481wru.416.1621963593368; 
 Tue, 25 May 2021 10:26:33 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id r17sm3575630wmh.25.2021.05.25.10.26.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 8AE6C1FF8C;
 Tue, 25 May 2021 18:26:28 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/4] scripts/arch-run: don't use deprecated
 server/nowait options
Date: Tue, 25 May 2021 18:26:26 +0100
Message-Id: <20210525172628.2088-3-alex.bennee@linaro.org>
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

VGhlIHZlcnkgZmFjdCB0aGF0IFFFTVUgZHJvcHMgdGhlIGRlcHJlY2F0aW9uIHdhcm5pbmcgd2hp
bGUgcnVubmluZyBpcwplbm91Z2ggdG8gY29uZnVzZSB0aGUgaXRzLW1pZ3JhdGlvbiB0ZXN0IGlu
dG8gZmFpbGluZy4gVGhlIGJvb2xlYW4Kb3B0aW9ucyBzZXJ2ZXIgYW5kIHdhaXQgaGF2ZSBhY2Nl
cHRlZCB0aGUgbG9uZyBmb3JtIG9wdGlvbnMgZm9yIGEgbG9uZwp0aW1lLgoKU2lnbmVkLW9mZi1i
eTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpDYzogU2hhc2hpIE1hbGxl
bGEgPHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Ci0tLQogc2NyaXB0cy9hcmNoLXJ1bi5iYXNo
IHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMvYXJjaC1ydW4uYmFzaCBiL3NjcmlwdHMvYXJjaC1ydW4u
YmFzaAppbmRleCA1OTk3ZTM4Li43MDY5M2YyIDEwMDY0NAotLS0gYS9zY3JpcHRzL2FyY2gtcnVu
LmJhc2gKKysrIGIvc2NyaXB0cy9hcmNoLXJ1bi5iYXNoCkBAIC0xMjIsMTQgKzEyMiwxNCBAQCBy
dW5fbWlncmF0aW9uICgpCiAJdHJhcCAna2lsbCAwOyBleGl0IDInIElOVCBURVJNCiAJdHJhcCAn
cm0gLWYgJHttaWdvdXQxfSAke21pZ3NvY2t9ICR7cW1wMX0gJHtxbXAyfSAke2ZpZm99JyBSRVRV
Uk4gRVhJVAogCi0JZXZhbCAiJEAiIC1jaGFyZGV2IHNvY2tldCxpZD1tb24xLHBhdGg9JHtxbXAx
fSxzZXJ2ZXIsbm93YWl0IFwKKwlldmFsICIkQCIgLWNoYXJkZXYgc29ja2V0LGlkPW1vbjEscGF0
aD0ke3FtcDF9LHNlcnZlcj1vbix3YWl0PW9mZiBcCiAJCS1tb24gY2hhcmRldj1tb24xLG1vZGU9
Y29udHJvbCB8IHRlZSAke21pZ291dDF9ICYKIAogCSMgV2UgaGF2ZSB0byB1c2UgY2F0IHRvIG9w
ZW4gdGhlIG5hbWVkIEZJRk8sIGJlY2F1c2UgbmFtZWQgRklGTydzLCB1bmxpa2UKIAkjIHBpcGVz
LCB3aWxsIGJsb2NrIG9uIG9wZW4oKSB1bnRpbCB0aGUgb3RoZXIgZW5kIGlzIGFsc28gb3BlbmVk
LCBhbmQgdGhhdAogCSMgdG90YWxseSBicmVha3MgUUVNVS4uLgogCW1rZmlmbyAke2ZpZm99Ci0J
ZXZhbCAiJEAiIC1jaGFyZGV2IHNvY2tldCxpZD1tb24yLHBhdGg9JHtxbXAyfSxzZXJ2ZXIsbm93
YWl0IFwKKwlldmFsICIkQCIgLWNoYXJkZXYgc29ja2V0LGlkPW1vbjIscGF0aD0ke3FtcDJ9LHNl
cnZlcj1vbix3YWl0PW9mZiBcCiAJCS1tb24gY2hhcmRldj1tb24yLG1vZGU9Y29udHJvbCAtaW5j
b21pbmcgdW5peDoke21pZ3NvY2t9IDwgPChjYXQgJHtmaWZvfSkgJgogCWluY29taW5nX3BpZD1g
am9icyAtbCAlKyB8IGF3ayAne3ByaW50JDJ9J2AKIAotLSAKMi4yMC4xCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
