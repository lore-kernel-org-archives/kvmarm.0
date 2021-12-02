Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB818C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 11:54:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4970E4B1B3;
	Thu,  2 Dec 2021 06:54:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M6PpRaM+7LVM; Thu,  2 Dec 2021 06:54:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0464B175;
	Thu,  2 Dec 2021 06:54:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D73B64B13A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:53:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RiSBvbz6luR4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 06:53:56 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C3404B0C3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:53:56 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id 137so22786761wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 03:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=+UeYzBMgRKj6oO+ZQIPz1JkXMR6XE0UYsSwgh092H/8=;
 b=wLyJSdkNKX9i2jQbWvNzS7ISoGlxZrNXXkVv5wrju7EPmYlUj6jhV9VkuYhwL4tMd1
 4LWL1z1HnSuRTBMq6aOS7vkRSQhxWIYDQDM6IIzmdY3uJiPQod4+pjQGC5eURjd/7j2W
 NqBWiyzoiNCFFWEXXR5GTy1Af8CWVEevJThpm8dnEt8xPSFxKmTmdd2tAy5HI6UdWv8j
 eKg4WjBj5qZgPN/FoyAaqum6XWYyZwWx7VT6pYrVH/VnlaqL5u1D3IS/zhwR9sCeJ/vu
 u7f6g7Yxzn6kpgSnJHiQjqW5iWn1EAUejstfYzCIPvCkprfKUq4atQhjq3WkUbeDWBM0
 /ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=+UeYzBMgRKj6oO+ZQIPz1JkXMR6XE0UYsSwgh092H/8=;
 b=tg6TSWzXIPbjRC3+hzwCLXj/llLU+dJYtO5B1Edc/8kyxivPbhZkwwtaHBVVX6ouU6
 RznMYBOlpPzB6n+E2amvZ+lKyeX5NfMYroW33M1V9jEC7T0HIbXKCRk4/8peo9ThGHr3
 e7owjZbzRzOxUhuP6PXNXD6vIejP3LDt0M0A5+Ker9XK7w7kzAo0GmO8lfh9b81WZzW8
 TXOjmUmS1Tk3GXQVBqEA/R3PbFxaMwT/ArGlIr+Qd4pjZ0KNJTIIIKt9gPUcJEQ33Hh5
 +CxKS60dfs6+pzlHBlTY1ULCBoLAOEUlFgwn0xt9uFEk9Ei5bZ9XRGNMv7gwF0wNlZTJ
 j9jg==
X-Gm-Message-State: AOAM533UOf7bZhuZ1olJIC3wKjscx+bYmCFqiQ8P9X9cA7h0EuOFj9LT
 L5n3K3LCNKDq5eQZxCs7bgfh7g==
X-Google-Smtp-Source: ABdhPJwVNmlD8zuKLw5J+ryv5dY1uQUg+XGqJlUenngQf9X/voMaDW/6oELSYsp15xkyfMOXK+Zmcw==
X-Received: by 2002:a05:600c:3647:: with SMTP id
 y7mr5816276wmq.39.1638446035103; 
 Thu, 02 Dec 2021 03:53:55 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z8sm2493015wrh.54.2021.12.02.03.53.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 874C31FF98;
 Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v9 1/9] docs: mention checkpatch in the README
Date: Thu,  2 Dec 2021 11:53:44 +0000
Message-Id: <20211202115352.951548-2-alex.bennee@linaro.org>
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

U2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpBY2tl
ZC1ieTogQW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Ck1lc3NhZ2UtSWQ6IDwyMDIx
MTExODE4NDY1MC42NjE1NzUtMi1hbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpBY2tlZC1ieTogVGhv
bWFzIEh1dGggPHRodXRoQHJlZGhhdC5jb20+CgotLS0KdjkKICAtIHNsaWdodGx5IG1vcmUgd2Vh
c2VsbHkgc3RhdGVtZW50IGFib3V0IGNoZWNrcGF0Y2gKLS0tCiBSRUFETUUubWQgfCAzICsrKwog
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL1JFQURNRS5tZCBi
L1JFQURNRS5tZAppbmRleCA2ZTZhOWQwNC4uMjQ1MDUyYjQgMTAwNjQ0Ci0tLSBhL1JFQURNRS5t
ZAorKysgYi9SRUFETUUubWQKQEAgLTE4MiwzICsxODIsNiBAQCB0aGUgY29kZSBmaWxlcy4gIFdl
IGFsc28gc3RhcnQgd2l0aCBjb21tb24gY29kZSBhbmQgZmluaXNoIHdpdGggdW5pdCB0ZXN0CiBj
b2RlLiBnaXQtZGlmZidzIG9yZGVyRmlsZSBmZWF0dXJlIGFsbG93cyB1cyB0byBzcGVjaWZ5IHRo
ZSBvcmRlciBpbiBhCiBmaWxlLiAgVGhlIG9yZGVyRmlsZSB3ZSB1c2UgaXMgYHNjcmlwdHMvZ2l0
LmRpZmZvcmRlcmA7IGFkZGluZyB0aGUgY29uZmlnCiB3aXRoIGBnaXQgY29uZmlnIGRpZmYub3Jk
ZXJGaWxlIHNjcmlwdHMvZ2l0LmRpZmZvcmRlcmAgZW5hYmxlcyBpdC4KKworV2Ugc3RyaXZlIHRv
IGZvbGxvdyB0aGUgTGludXgga2VybmVscyBjb2Rpbmcgc3R5bGUgc28gaXQncyByZWNvbW1lbmRl
ZAordG8gcnVuIHRoZSBrZXJuZWwncyAuL3NjcmlwdHMvY2hlY2twYXRjaC5wbCBvbiBuZXcgcGF0
Y2hlcy4KLS0gCjIuMzAuMgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
