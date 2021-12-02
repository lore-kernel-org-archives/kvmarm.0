Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038E1C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 11:54:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B285F4B207;
	Thu,  2 Dec 2021 06:54:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id na8zQZT8KwY4; Thu,  2 Dec 2021 06:54:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 610154B17D;
	Thu,  2 Dec 2021 06:54:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D6964B1D5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:54:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ki5AbqKLSZQI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 06:54:03 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 487084B192
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:54:02 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id j3so59106691wrp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 03:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=wneIr30hD8kwc2U2ZHDOLOB1FKf9OkenNldv6kSi2AM=;
 b=Kl8tpBn3Y4zU/zs7x1c8P4KdomOcl3MaAS8EWFeE7oHSV04KCwa9TLqHYrAAzy5J7I
 wa4tSSqN+ShT+QikZhcxIzZIu2KcYxPUlopTvfp5sRAlI2R8DHCduDkoe9dTVCMJEYWa
 hDfxQJJPvcyZjW3aVHzX3Axe43hNFpw1LuOXAiDCb60aUwOey6KHz0/93hxGFsr0AM5B
 UGWWHV9kPmNCOz8JpoM3/y3jo2L2lP3AVjgPbn8OgeqP97UlkJr7dxcygdC0Ehq7LQAT
 HBSXQvt5NE4nMH+06kUQOqEi1zDJP2Ip97ZswEZgVSjtcVUFof3tagewKS+XzHzby3dZ
 dG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=wneIr30hD8kwc2U2ZHDOLOB1FKf9OkenNldv6kSi2AM=;
 b=2NzkY7NOJAgHBoIU2+y5dT89jAMIr9v+srmwqYlOfcNdwFODBOFeGrhVIQVWtQyAF0
 4gAP+gN4im8m5cVclm6gkkYFNsR8fW5SwLLnr4z1E65RvZsbAsk+/YyUnq4m2bOSchVc
 ZAn7kLeQTrkf/+yi1AayC2tZFpA84Lq80kq72VeBZNjF0pCZrFe+i6TLlnjdpFLdiIW2
 6HeGBzph9vYzUWY6SVMHiO3cS/NM403UEtWO26Y1AUjPdOX2abDLVeWbQQ7KGRKjpRPu
 CRt9+E+eQ+UtE2SVUJCdqSggQj+ws44Lbt3Pl/u1ZYztW11isWuuHA3Kr+iOvfqj6Aqx
 /d0A==
X-Gm-Message-State: AOAM533rXI5PfBwVRAzXrQd/M0GOSwYssj8L9jJQV7842/PWaLhMXMg3
 Tvl5XFzqQ/pe3zqCcyaIkPaQDA==
X-Google-Smtp-Source: ABdhPJwUUxRIHM8yJU+oqo6jm79Z11Fsxaw5Hbqb20NEb7IxqlmIAH8vSpJU5mnNeUF7SN/OO+EYFw==
X-Received: by 2002:adf:f001:: with SMTP id j1mr13874475wro.351.1638446041299; 
 Thu, 02 Dec 2021 03:54:01 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id 9sm3136858wry.0.2021.12.02.03.53.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Dec 2021 03:53:59 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 12A061FF9F;
 Thu,  2 Dec 2021 11:53:53 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v9 8/9] arm/run: use separate --accel form
Date: Thu,  2 Dec 2021 11:53:51 +0000
Message-Id: <20211202115352.951548-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, christoffer.dall@arm.com,
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

VGhpcyB3aWxsIGFsbG93IFRDRyB0ZXN0cyB0byBhbHRlciB0aGluZ3Mgc3VjaCBhcyB0Yi1zaXpl
LgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpN
ZXNzYWdlLUlkOiA8MjAyMTExMTgxODQ2NTAuNjYxNTc1LTEwLWFsZXguYmVubmVlQGxpbmFyby5v
cmc+Ci0tLQogYXJtL3J1biB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcm0vcnVuIGIvYXJtL3J1bgppbmRleCBh
MzkwY2E1YS4uNzNjNmM4M2EgMTAwNzU1Ci0tLSBhL2FybS9ydW4KKysrIGIvYXJtL3J1bgpAQCAt
NTgsOCArNTgsOCBAQCBpZiAkcWVtdSAkTSAtZGV2aWNlICc/JyAyPiYxIHwgZ3JlcCBwY2ktdGVz
dGRldiA+IC9kZXYvbnVsbDsgdGhlbgogCXBjaV90ZXN0ZGV2PSItZGV2aWNlIHBjaS10ZXN0ZGV2
IgogZmkKIAotTSs9IixhY2NlbD0kQUNDRUwiCi1jb21tYW5kPSIkcWVtdSAtbm9kZWZhdWx0cyAk
TSAtY3B1ICRwcm9jZXNzb3IgJGNocl90ZXN0ZGV2ICRwY2lfdGVzdGRldiIKK0E9Ii1hY2NlbCAk
QUNDRUwiCitjb21tYW5kPSIkcWVtdSAtbm9kZWZhdWx0cyAkTSAkQSAtY3B1ICRwcm9jZXNzb3Ig
JGNocl90ZXN0ZGV2ICRwY2lfdGVzdGRldiIKIGNvbW1hbmQrPSIgLWRpc3BsYXkgbm9uZSAtc2Vy
aWFsIHN0ZGlvIC1rZXJuZWwiCiBjb21tYW5kPSIkKG1pZ3JhdGlvbl9jbWQpICQodGltZW91dF9j
bWQpICRjb21tYW5kIgogCi0tIAoyLjMwLjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
