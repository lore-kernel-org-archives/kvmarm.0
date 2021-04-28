Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A62C43611
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D172161433
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D172161433
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE694B22D;
	Wed, 28 Apr 2021 06:18:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kn1RNmtWg57q; Wed, 28 Apr 2021 06:18:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9464B23F;
	Wed, 28 Apr 2021 06:18:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA6AA4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nd4YQFCc8Fei for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 06:18:47 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0B7E4B22A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:47 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id d11so4581827wrw.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 03:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=JIGl3K3qE3k2BXQSfM80xkGe4hRnH3OA6tpOjjNrd3E=;
 b=Tocu2ZsTcx7VJN6+MVikFztL2wEkgN20wGnOqWs/UwSTwQ8IT1wNoZoLCbL1uytn3f
 qCa6ykXIJ39hLu4V+KCW1lOlOmcToymqvCX7t0lR3o87WapMMqa8pTdRKzo+7J5B3GdX
 cdiIdktldMin4hXEw4px5yAX0xr90WWmxO8smtcZti/I1/LApf837ST2k6Au1cXg6Z5y
 ZmqDDGg96rXNe6zD9MZlfwQRtM+smRh0A5U6Y4j93mTVpC8y5NGpu6NsLMBfYp2NIj7k
 1sGEevKSlWBdzR0UJhugw5fzOXmVcF5hl8CdGbdCsoEuHBke8NPjMo+982KpfVcXN8mH
 6ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=JIGl3K3qE3k2BXQSfM80xkGe4hRnH3OA6tpOjjNrd3E=;
 b=HjgGOZLxgnbm7uJhKXpcKomjCs/3fYojVQGrpjNrcjPWi0DL1IwdoYImdb09a0Dzyr
 2W4kP7mbG0JWCznlQSB86zIPGUQDJtEjjFqAO3KcCkE+z2jfERRonKnxYmcVGdw/LzFw
 t8q1I/wR/jL3aZFfZE04+zbVILbXkjF0POy3MyHggXxmnntnDLzsuaVmbt1hR/s8+LxY
 pUXZXzd/0NaPi5ImZDTBZQaufsodGm1E2n0FVwRSPXv4A3xEhVZaGFHyDZkIg1/5HssY
 xKyGcjjVwweP0qQ5d5EhkAVhpUmrRrKqSJo//aZieYKmnFUYfOreAEModDbcBV8ORcKa
 GGdw==
X-Gm-Message-State: AOAM533R+921oOwoWOw1NN+gvIZL6ye31yhtRFLwcKIXIU15VSks24uy
 sxfhY9BDZkaF0UasPA01IT72mg==
X-Google-Smtp-Source: ABdhPJzY9oNGXhOxLJCihSwIGFeQ6N62MW7ZFy5SInbOGtC3xunUNEQ7q6CYNQ8xm6AW5+ASciIkSA==
X-Received: by 2002:adf:fdcd:: with SMTP id i13mr34506297wrs.185.1619605126850; 
 Wed, 28 Apr 2021 03:18:46 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id s83sm3294855wms.16.2021.04.28.03.18.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 343B41FF8C;
 Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 2/4] scripts/arch-run: don't use deprecated
 server/nowait options
Date: Wed, 28 Apr 2021 11:18:42 +0100
Message-Id: <20210428101844.22656-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
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
eTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgotLS0KIHNjcmlwdHMvYXJj
aC1ydW4uYmFzaCB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9zY3JpcHRzL2FyY2gtcnVuLmJhc2ggYi9zY3JpcHRz
L2FyY2gtcnVuLmJhc2gKaW5kZXggNTk5N2UzOC4uNzA2OTNmMiAxMDA2NDQKLS0tIGEvc2NyaXB0
cy9hcmNoLXJ1bi5iYXNoCisrKyBiL3NjcmlwdHMvYXJjaC1ydW4uYmFzaApAQCAtMTIyLDE0ICsx
MjIsMTQgQEAgcnVuX21pZ3JhdGlvbiAoKQogCXRyYXAgJ2tpbGwgMDsgZXhpdCAyJyBJTlQgVEVS
TQogCXRyYXAgJ3JtIC1mICR7bWlnb3V0MX0gJHttaWdzb2NrfSAke3FtcDF9ICR7cW1wMn0gJHtm
aWZvfScgUkVUVVJOIEVYSVQKIAotCWV2YWwgIiRAIiAtY2hhcmRldiBzb2NrZXQsaWQ9bW9uMSxw
YXRoPSR7cW1wMX0sc2VydmVyLG5vd2FpdCBcCisJZXZhbCAiJEAiIC1jaGFyZGV2IHNvY2tldCxp
ZD1tb24xLHBhdGg9JHtxbXAxfSxzZXJ2ZXI9b24sd2FpdD1vZmYgXAogCQktbW9uIGNoYXJkZXY9
bW9uMSxtb2RlPWNvbnRyb2wgfCB0ZWUgJHttaWdvdXQxfSAmCiAKIAkjIFdlIGhhdmUgdG8gdXNl
IGNhdCB0byBvcGVuIHRoZSBuYW1lZCBGSUZPLCBiZWNhdXNlIG5hbWVkIEZJRk8ncywgdW5saWtl
CiAJIyBwaXBlcywgd2lsbCBibG9jayBvbiBvcGVuKCkgdW50aWwgdGhlIG90aGVyIGVuZCBpcyBh
bHNvIG9wZW5lZCwgYW5kIHRoYXQKIAkjIHRvdGFsbHkgYnJlYWtzIFFFTVUuLi4KIAlta2ZpZm8g
JHtmaWZvfQotCWV2YWwgIiRAIiAtY2hhcmRldiBzb2NrZXQsaWQ9bW9uMixwYXRoPSR7cW1wMn0s
c2VydmVyLG5vd2FpdCBcCisJZXZhbCAiJEAiIC1jaGFyZGV2IHNvY2tldCxpZD1tb24yLHBhdGg9
JHtxbXAyfSxzZXJ2ZXI9b24sd2FpdD1vZmYgXAogCQktbW9uIGNoYXJkZXY9bW9uMixtb2RlPWNv
bnRyb2wgLWluY29taW5nIHVuaXg6JHttaWdzb2NrfSA8IDwoY2F0ICR7Zmlmb30pICYKIAlpbmNv
bWluZ19waWQ9YGpvYnMgLWwgJSsgfCBhd2sgJ3twcmludCQyfSdgCiAKLS0gCjIuMjAuMQoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
