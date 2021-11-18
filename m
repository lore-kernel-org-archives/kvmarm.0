Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87508C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37E8261B29
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:47:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 37E8261B29
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0C5D4B183;
	Thu, 18 Nov 2021 13:46:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xGLrq+LYXYWp; Thu, 18 Nov 2021 13:46:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A34544B214;
	Thu, 18 Nov 2021 13:46:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E90B4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iM3emPq2BHlp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:46:57 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94F604B1E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:55 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id i12so6250616wmq.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=tOmySd5ZdC4WjR5pqWQluHQkWraboy7ZlqKYZZCFjto=;
 b=odLpz8EZ1vyqBAm0rFDZYV49GrwMKDvbxKQ+SyB2aLw0WE8TCSj/Bcy2Xe+Hmz9Yt3
 LhghE7I8TGtpPFT7Sx+h6c0SFZZZqdRuXFVetqaah8ct5fZeP9NLx1w16f9tf5UHFOap
 Q6LFGeNlkOa9WLERkzmi4vtzJNU8HSygywuPF3ynjMS1c3lsHDwQQGA/QbdCC43OICgM
 MUBL/rYK2YWxE1utNrG4cJLqyQmNClwBwhzWgzZXcZTHVmqV9D0zmd5Qfqirl2QVqrks
 bJgSkgaPxF7pqt4M3r/afE2djzrsEJS4xQkH+3X9L76mX6e3eOJvbogjrENFed54AwbF
 /wEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=tOmySd5ZdC4WjR5pqWQluHQkWraboy7ZlqKYZZCFjto=;
 b=oxRImc/LKPoUWefZ3tUg97ttgW8d6LS4vHE/plREX/n8+BuTURGYngtg/OfmVIL8ds
 InkBgDAOfsd+WKw+oHkvI88l2rqKIgQ+P4rGmGE69SqUHQxL5bfEUFT0mqq7sfe66h3G
 h2quawjqksYxJRpgoBrIbt9cd/JLQma8Nc4JrCZUZoZN7upnesfYPDcqneeNqOhxCS1S
 j+uZKnURRddY0LNUcR5ZhGmLkuGLuktz2s/NbmFDNy3n6IfdScqete+KIGifKO6bXczV
 cDAJvRpJ4GrtiQ8rzntet/LW0L/xwGv67FX20zj3u9G6teQDkq3EIIOSd2fe6TvwnhQT
 TzYQ==
X-Gm-Message-State: AOAM532FL5203quaxWpzYM/CrzUX+koDZiaUj+0Y4AMQ1Wtc1zQ0ipDz
 vQt07XsaVhUwS4QeUVh4UZ03Dg==
X-Google-Smtp-Source: ABdhPJyHr89MEcvcKNNgqQkU7LLmSsVqr9xPkXN6m1nHufZRRPmyHO/j2xfEPRMZ4+sIHj9mgtlOow==
X-Received: by 2002:a05:600c:4e01:: with SMTP id
 b1mr12398367wmq.109.1637261214762; 
 Thu, 18 Nov 2021 10:46:54 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id n129sm464676wmn.36.2021.11.18.10.46.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:46:50 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 4A7EF1FF99;
 Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 02/10] arm/flat.lds: don't drop debug during
 link
Date: Thu, 18 Nov 2021 18:46:42 +0000
Message-Id: <20211118184650.661575-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, qemu-arm@nongnu.org, idan.horowitz@gmail.com,
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

SXQgaXMgdXNlZnVsIHRvIGtlZXAgdGhlIGRlYnVnIGluIHRoZSAuZWxmIGZpbGUgc28gd2UgY2Fu
IGRlYnVnIGFuZCBpdApkb2Vzbid0IGdldCBjb3BpZWQgYWNyb3NzIHRvIHRoZSBmaW5hbCAuZmxh
dCBmaWxlLiBPZiBjb3Vyc2Ugd2Ugc3RpbGwKbmVlZCB0byBlbnN1cmUgd2UgYXBwbHkgdGhlIG9m
ZnNldCB3aGVuIHdlIGxvYWQgdGhlIHN5bWJvbHMgYmFzZWQgb24Kd2hlcmUgUUVNVSBkZWNpZGVk
IHRvIGxvYWQgdGhlIGtlcm5lbC4KCiAgKGdkYikgc3ltYm9sLWZpbGUgLi9idWlsZHMvYXJtNjQv
YXJtL3RsYmZsdXNoLWRhdGEuZWxmIC1vIDB4NDAwODAwMDAKClNpZ25lZC1vZmYtYnk6IEFsZXgg
QmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0tCiBhcm0vZmxhdC5sZHMgfCAxIC0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYXJtL2ZsYXQubGRz
IGIvYXJtL2ZsYXQubGRzCmluZGV4IDZmYjQ1OWUuLjQ3ZmNiNjQgMTAwNjQ0Ci0tLSBhL2FybS9m
bGF0LmxkcworKysgYi9hcm0vZmxhdC5sZHMKQEAgLTYyLDcgKzYyLDYgQEAgU0VDVElPTlMKICAg
ICAvRElTQ0FSRC8gOiB7CiAgICAgICAgICooLm5vdGUqKQogICAgICAgICAqKC5pbnRlcnApCi0g
ICAgICAgICooLmRlYnVnKikKICAgICAgICAgKiguY29tbWVudCkKICAgICAgICAgKiguZHluYW1p
YykKICAgICB9Ci0tIAoyLjMwLjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
