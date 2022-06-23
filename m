Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DA4CCA47C
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 13:52:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5AA449EF4;
	Thu, 23 Jun 2022 09:52:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WFriO4ROVoIb; Thu, 23 Jun 2022 09:52:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4ED84B21A;
	Thu, 23 Jun 2022 09:52:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B73C94B21A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 09:52:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FOmelIJSx2vp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 09:52:29 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A98CA49EF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 09:52:29 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id o16so28067452wra.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 06:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=1X9lbKKIV9qycrXRpNydQ+hZtRjdEcBHpnSHAhTustc=;
 b=Q8wLdsGGO2EMGYwRe1qx9L+Id/qeH5FGsNpDqssmOAVha+fiBs8gU15mzwp99iHf3q
 POCKEFtPz9KVHJhzxKH/HhM/1fXiknbk+U23hgE/upekiyWIg6RIq9ieJjrFkznBfLl7
 kWxfSUzP2FIWpewjxG5dF2FJdWSb8fBOcTgdUNgQu5N0RMq98vclEOSuYQQSD/n2m6EO
 GvG76m8q47B5zc6aKTjN9AQ79Z2mKMrKztuOAcpPVkr0H8xu5ETRuxswK9KXrHzeEIFa
 HfjENT5CZl8ih1nw44Oj0gQA9aPwUSNF+otJHjcagPq24kR5XfdSbhtZCsLMKGhE5hM3
 79pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=1X9lbKKIV9qycrXRpNydQ+hZtRjdEcBHpnSHAhTustc=;
 b=U0LL+++gH1EEzJ5r3EnpIkTuWUH5JDDAr/UEfJk7RALixArMcBRN3qCGMm2qfqrUuQ
 on41KztdN0c2YvA0Vs5C32wvcmWjQRPpAWtUQR1GxxUqnnTKunWHVV9/n45x2pwwKXvT
 vfLWz3kYJ7tif3z/DF5ZhSdxdbdDNEq/otdo4SwgrVAHrofME9Sk+DgO+4ESP4XILt1d
 stn24znWwcGzaP1TpB8VLRYO8JR52UGF3JvKdPRfuM8P52tL4diy+2gKDsbIKieXGor5
 HL/h00qEOdGrOCj0WZ8AIz22Zncj1HIv9zx+qSCddbcGesS42ZphafHxoSW1v7DbmP7q
 MFPw==
X-Gm-Message-State: AJIora+WO0j8AyG783QJhoSv5ku0cdze6m5x2AVllcCGm8SMcf3Vvkzo
 qgKmbQRkF8TQXl2acpwenFA7gw==
X-Google-Smtp-Source: AGRyM1s1YMX1GREKjHaIpDGqwB6jmYus7bPtupyPY19Kc6pNGoYQY2OMTwz4NdaQOxFdEYiwc0jUJg==
X-Received: by 2002:adf:ebc4:0:b0:21b:815b:d135 with SMTP id
 v4-20020adfebc4000000b0021b815bd135mr8145392wrn.653.1655992348613; 
 Thu, 23 Jun 2022 06:52:28 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id
 m18-20020a05600c4f5200b0039748be12dbsm3470135wmq.47.2022.06.23.06.52.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 06:52:27 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id E271E1FFB7;
 Thu, 23 Jun 2022 14:52:26 +0100 (BST)
References: <20220623131017.670589-1-drjones@redhat.com>
User-agent: mu4e 1.7.27; emacs 28.1.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: Change drew's email address
Date: Thu, 23 Jun 2022 14:52:22 +0100
In-reply-to: <20220623131017.670589-1-drjones@redhat.com>
Message-ID: <87pmizpjvp.fsf@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, thuth@redhat.com, kvm@vger.kernel.org,
 andre.przywara@arm.com, qemu-devel@nongnu.org, nikos.nikoleris@arm.com,
 qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IEFzIGEgc2lkZSBl
ZmZlY3Qgb2YgbGVhdmluZyBSZWQgSGF0IEkgd29uJ3QgYmUgYWJsZSB0byB1c2UgbXkgUmVkIEhh
dAo+IGVtYWlsIGFkZHJlc3MgYW55bW9yZS4gSSdtIGFsc28gY2hhbmdpbmcgdGhlIG5hbWUgb2Yg
bXkgZ2l0bGFiIGdyb3VwLgo+Cj4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEpvbmVzIDxhbmRyZXcu
am9uZXNAbGludXguZGV2Pgo+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBKb25lcyA8ZHJqb25lc0By
ZWRoYXQuY29tPgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4KCi0tIApBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
