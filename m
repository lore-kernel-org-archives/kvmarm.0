Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88150C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 11:48:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE40C4B17B;
	Mon, 13 Dec 2021 06:48:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rSs6ZxOqmWJW; Mon, 13 Dec 2021 06:48:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF15B4B18A;
	Mon, 13 Dec 2021 06:48:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B12974B17B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 06:48:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EsGlfnFSifXr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 06:48:52 -0500 (EST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4AED4B0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 06:48:52 -0500 (EST)
Received: by mail-wr1-f54.google.com with SMTP id a9so26532440wrr.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 03:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=user-agent:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=1Rff4bZuWwv4l42hBn/B/P9bZKSQ6uv1/058R+cQsuw=;
 b=b+42Lww3OLjAC/HYeR7Ck5vYvmeLgk/wWnBmH4vQuhhjb31947Z4QmpO4hCdaPQMt9
 ZE9NpAG1GagrEOYRVMHenmnUToT1ymTmhZbIXS4QRFpiD9qbSo7+Y6nFbn4AsPa5YPRq
 2xYU4bJgJaTgugpVbcbKJCU3ElGUPvReOvGHKBasPlIJ9wVR0Vw9RG3p0nzFyF/SP6My
 WDgh0Dk4a6Ln3240d0XuBzG98PjO2UjdVvjZQm5Ym46jtxeDhmp+amKK2oqJdCiifikr
 6pN+L0lUs1tGsPrL0GrW/E+EIKr0eEjICPbWG95nLvnWgP374D6rdNxd1PVR5Ce+9Sax
 lc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:user-agent:from:to:cc:subject:date:message-id
 :mime-version:content-transfer-encoding;
 bh=1Rff4bZuWwv4l42hBn/B/P9bZKSQ6uv1/058R+cQsuw=;
 b=AA3Xo+4U1vwXyWA7lcoz9dRNWhiNTEfAPWNJWnpbSQ+8yqgSREJ5vQlrnK3obBYo2x
 +YPViP8McJaXVwI4G+wyqm7Gbnu+92nqCzc9GOHLsuXvFF/63H5imQoDDbjbK6hTq1fB
 VcAQlmDRkaf+EY0ZJ/p26MRbkA1sJA/UOGl0sGunCQ25bL7AZLmPdkAfpnSrmqqKSoAH
 9B0Hgy7652wF5Tjk780b4mHe1j2/AzbMvizPVaI9MVSZrdJYwQf3XdhSajbm5HnPbOcF
 DvYCybAwNMKT3lWnt3feK2rrMZuU48fc0wP2+jam5epJEv8WyHf04QqcjFIx+UiSHwkU
 mIXg==
X-Gm-Message-State: AOAM530wPLOZM/BHmE5Ge1HOBL9A3ztHtc3mtM+JpJ/OzzQfUMw3MMpW
 Pnef+3zVgYRiWbqVLH3h3SqA/w==
X-Google-Smtp-Source: ABdhPJxgc/POAWd7r6xTEg+3geySf2ivwetrGfkW60egMFgc9qK8awl8abx+k3bDn7Ek2KhpWA4kUQ==
X-Received: by 2002:a5d:6481:: with SMTP id o1mr17156591wri.632.1639396131655; 
 Mon, 13 Dec 2021 03:48:51 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id d2sm6883237wmb.31.2021.12.13.03.48.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Dec 2021 03:48:50 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 1F73A1FF96;
 Mon, 13 Dec 2021 11:48:50 +0000 (GMT)
User-agent: mu4e 1.7.5; emacs 28.0.90
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Christoffer Dall <cdall@kernel.org>, Peter Maydell
 <peter.maydell@linaro.org>, shashi.mallela@linaro.org, Vincent Guittot
 <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>
Subject: Configuring the host GIC for guest to guest IPI
Date: Mon, 13 Dec 2021 11:40:41 +0000
Message-ID: <87fsqwn2sd.fsf@linaro.org>
MIME-Version: 1.0
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>, kvmarm@lists.cs.columbia.edu,
 stratos-dev@op-lists.linaro.org
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

CkhpIEdJQyBleHBlcnRzLAoKVGhpcyBjYW1lIHVwIGxhc3Qgd2VlayBpbiB0aGUgU3RyYXRvcyBz
eW5jIGNhbGwgd2hlbiB3ZSB3ZXJlIGRpc2N1c3NpbmcKVmluY2VudCdzIFNDTUkgc2V0dXA6Cgog
IGh0dHBzOi8vbGluYXJvLmF0bGFzc2lhbi5uZXQvd2lraS9zcGFjZXMvU1RSL3BhZ2VzLzI4NjY1
NzQxNTAzLzIwMjEtMTItMDkrUHJvamVjdCtTdHJhdG9zK01lZXRpbmcrTm90ZXMKCndpdGggdGhl
IHNoYXJlZCBtZW1vcnkgYmV0d2VlbiB0aGUgdHdvIGd1ZXN0cyB0aGUgb25seSByZWFzb24gd2UK
Y3VycmVudGx5IGV4aXQgdG8gdGhlIGd1ZXN0IHVzZXJzcGFjZSAoUUVNVSkgaXMgdG8gZm9yd2Fy
ZCBub3RpZmljYXRpb25zCm9mIHZpcnRxdWV1ZSBraWNrcyBmcm9tIG9uZSBndWVzdCB0byB0aGUg
b3RoZXIuIEknbSB2YWd1ZWx5IGF3YXJlIGZyb20KbXkgdGltZSBsb29raW5nIGF0IEdJQyBjb2Rl
IHRoYXQgaXQgY2FuIGJlIGNvbmZpZ3VyZWQgZm9yIElQSSBJUlFzCmJldHdlZW4gdHdvIGNvcmVz
LiBEbyB3ZSBoYXZlIHRoYXQgYWJpbGl0eSBiZXR3ZWVuIHR3byB2Q1BVcyBmcm9tCmRpZmZlcmVu
dCBndWVzdHM/CgpJZiBub3Qgd2hhdCB3b3VsZCBpdCB0YWtlIHRvIGVuYWJsZSBzdWNoIGEgZmVh
dHVyZT8KCi0tIApBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
