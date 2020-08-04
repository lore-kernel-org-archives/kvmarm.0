Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F45C433E1
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6297E2067D
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xmDdxPVB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6297E2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 165954B798;
	Tue,  4 Aug 2020 08:44:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QXjTVKWsfqXx; Tue,  4 Aug 2020 08:44:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F414B7BD;
	Tue,  4 Aug 2020 08:44:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E4A34B713
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yqpk-cjYPxe5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 08:44:22 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 838474B6C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:22 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id k20so2763191wmi.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2020 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=pXFf5i+ccqczXVXTg/nZ29LHnMvff9vMvvoJKipTK/k=;
 b=xmDdxPVBebllwYSXr8MTF5/0WVgZGKSZUMcEmtg1Yb6lXQo90+6kVdw3cQCf4XLw2a
 M7kb5BeEfu2MZRYypdtYVL7FuPiQ9THnz2WAl4CNEiw92SXD1Gp2UD3XZwg82u3Ec4mv
 t3ZWzvYQJ2a0G4okutZQe+5ypiJzpjGTq3/5YMxxkhi1n/QDZTKpGr0WFAPJg4NFSYxF
 rzXEuRDF0jzSKq3FW5Wgttxs2iCjBLDtl0PSrYbT2lfK2UrFozrTRxtfl4VFYOEwim7v
 WZZ0lo3eI2JwOsiFmXAMwp3UwPLdLcwIVZCe4upmuSA1YTH3p9bYdrrABYOA4zvUNdI1
 7UHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=pXFf5i+ccqczXVXTg/nZ29LHnMvff9vMvvoJKipTK/k=;
 b=Sixfa3J7CmBkSLPjPJcFocjc+oQPI+dZAJfecTL5ridwlAUaoNsNegmgWtx6pN+JF1
 ZQ6SqrcCpr/hIWK4Pl1m4NdYeKdDoFSbQIscPJK4HbATvP9mXUYRjPYmSPIxIaNGgp/M
 DhRcf16knm7z/tzkJiUb8WNaxYTvCOPM/fVVf2WK5zzThQ5uyjLGfKnVNm22SAbksYPn
 U+vBVbjrvkrd2WqftPgUAVNzrac33a6/hsqZzHGFOAKEdchcPUevecc8EA2VX65znunz
 hk5gv5Jl8w3IMv355vP7lJUZ5vmEqS7hrnuyv2t7rj4quRNEUHuOP+NECqKeM0T/7bT5
 qlCQ==
X-Gm-Message-State: AOAM533jyYsiZvYnBYUsEE/Lo/sD7OAwkTHI7EvphoUUbMvIm3YQc28S
 q1iOG0qqwzRABwA0lFrARR1qbQ==
X-Google-Smtp-Source: ABdhPJxSYL3nLFynYC8/0kcrhha40SMBrbJj4GceYNd50xdCxUrISm9qcztn279uGdoJsV28A5ASGg==
X-Received: by 2002:a1c:1bc4:: with SMTP id b187mr3879098wmb.175.1596545061671; 
 Tue, 04 Aug 2020 05:44:21 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id 15sm4107897wmo.33.2020.08.04.05.44.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 77F6D1FF7E;
 Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH v1 0/3] put arm64 kvm_config on a diet
Date: Tue,  4 Aug 2020 13:44:14 +0100
Message-Id: <20200804124417.27102-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

SGksCgpXaGVuIGJ1aWxkaW5nIGd1ZXN0IGtlcm5lbHMgZm9yIHZpcnR1YWxpc2F0aW9uIHdlIHdl
cmUgYnJpbmdpbmcgaW4gYQpidW5jaCBvZiBzdHVmZiBmcm9tIHBoeXNpY2FsIGhhcmR3YXJlIHdo
aWNoIHdlIGRvbid0IG5lZWQgZm9yIG91cgppZGVhbGlzZWQgZml4YWJsZSB2aXJ0dWFsIFBDSSBk
ZXZpY2VzLiBUaGlzIHNlcmllcyBtYWtlcyBzb21lIEtjb25maWcKY2hhbmdlcyB0byBhbGxvdyB0
aGUgVGh1bmRlclggYW5kIFhHZW5lIFBDSSBkcml2ZXJzIHRvIGJlIGNvbXBpbGVkCm91dC4gSXQg
YWxzbyBkcm9wcyBQQ0lfUVVJUktTIGZyb20gdGhlIEtWTSBndWVzdCBidWlsZCBhcyBhIHZpcnR1
YWwKUENJIGRldmljZSBzaG91bGQgYmUgcXVpcmsgZnJlZS4KClRoaXMgaXMgbXkgZmlyc3QgdGlt
ZSBoYWNraW5nIGFyb3VuZCBLY29uZmlnIHNvIEkgaG9wZSBJJ3ZlIGdvdCB0aGUKYmFsYW5jZSBi
ZXR3ZWVuIGRlcGVuZHMgYW5kIHNlbGVjdHMgcmlnaHQgYnV0IHBsZWFzZSBsZXQgYmUga25vdyBp
ZiBpdApjb3VsZCBiZSBzcGVjaWZpZWQgaW4gYSBjbGVhbmVyIHdheS4KCkFsZXggQmVubsOpZSAo
Myk6CiAgYXJtNjQ6IGFsbG93IGRlLXNlbGVjdGlvbiBvZiBUaHVuZGVyWCBQQ0kgY29udHJvbGxl
cnMKICBhcm02NDogZ2F0ZSB0aGUgd2hvbGUgb2YgcGNpLXhnZW5lIG9uIENPTkZJR19QQ0lfWEdF
TkUKICBrZXJuZWwvY29uZmlnczogZG9uJ3QgaW5jbHVkZSBQQ0lfUVVJUktTIGluIEtWTSBndWVz
dCBjb25maWdzCgogYXJjaC9hcm02NC9LY29uZmlnLnBsYXRmb3JtcyAgICB8IDIgKysKIGFyY2gv
YXJtNjQvY29uZmlncy9kZWZjb25maWcgICAgfCAxICsKIGRyaXZlcnMvcGNpL2NvbnRyb2xsZXIv
S2NvbmZpZyAgfCA3ICsrKysrKysKIGRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvTWFrZWZpbGUgfCA4
ICsrKy0tLS0tCiBrZXJuZWwvY29uZmlncy9rdm1fZ3Vlc3QuY29uZmlnIHwgMSArCiA1IGZpbGVz
IGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgotLSAKMi4yMC4xCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
