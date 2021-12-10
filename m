Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5148BC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 15:39:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C0CF4B20B;
	Fri, 10 Dec 2021 10:39:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yffVTPMTv+3Y; Fri, 10 Dec 2021 10:39:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36F9D4B1F4;
	Fri, 10 Dec 2021 10:39:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 597224B1F0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 10:39:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id obMUt6ZLje-5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 10:39:13 -0500 (EST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com
 [209.85.208.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6986D4B1EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 10:39:13 -0500 (EST)
Received: by mail-ed1-f49.google.com with SMTP id t5so30847387edd.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 07:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=AOZkdRC+CJ+PlUEpOZm9T90sfKp+i/oDgrKmJYRkPhU=;
 b=ZizVwEZkAydiLEQYWBYNODOEWr60QjsjBINddQJTkw8FL+DX0c13Vg1WVtpKq9U+Aq
 e++XdnJH6ohxVIJhSgvgnsU69yn/Iq2aj3Y2t5jz+WLja+jmVNGdBADfTjIIZutTS/xB
 8A8Cz4DLo1E5lBQLm+LsssVKMVZsgJKC4irQ4GnCPwB95S2c59sXVFnSNEt+836wGSjE
 QgNC0CnAPP/qLcCZ5iwDFCqY8x1wUirAfqvEn2hnUMBrggmSRQvWkQbSpCLcl/KI3tJG
 xQJFT8ci6Xzigg1yDJ8qN3KUCqSma/7pD0RNGs4OlwFjoXAeuxrag6QsOIrRWcEQFGTg
 U0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=AOZkdRC+CJ+PlUEpOZm9T90sfKp+i/oDgrKmJYRkPhU=;
 b=JQoi+eOKlsTbjlzMzjyOxXDfnQgrVzXj0j7Rwaf+TkdAN5NSVZdVP64FE1OOvgUekO
 Zse+ewzct3tzB6u/2G0oEpzWYiZ0doaNgzDalajwrm5udLJgKoLn63yoNd7WWwYDIVuP
 zlUi5VskfS8DQ02KNccoa58/0qxaMgyLhLHK3D5iqgu288nB/iN516Jicy0ZeYgTnMtq
 kZvbRADHINdI9aPCvMqmstH9pucbbOstn9gF/PSdPfUK7WHXe8yoPNvteB9ZI0xp04dh
 0qs5K7GAJ1f7ZEPI0RHaLLx/cck7W9XoEMDOp5n3SAYS/szY/WCaGoK1HrBWYsnrjBpp
 fiGg==
X-Gm-Message-State: AOAM531pxCO8eCbJZ+fZJlBUvfAVc2WVJSNQdZfM5nRkk0hYMNP8hmCK
 J1ZqgdSoLOxHwadbB0ZAKrqDcA==
X-Google-Smtp-Source: ABdhPJyKLs05FJwfh3elkrf4n1AKWwU1t1JPNYqG6PNSzNOg39JnN4HBPm/pFLc0ebZKOsKOqT0VOQ==
X-Received: by 2002:a17:906:e115:: with SMTP id
 gj21mr24985353ejb.348.1639150751866; 
 Fri, 10 Dec 2021 07:39:11 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id ne33sm1770325ejc.6.2021.12.10.07.39.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Dec 2021 07:39:10 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id B07661FF96;
 Fri, 10 Dec 2021 15:39:09 +0000 (GMT)
References: <20211202115352.951548-1-alex.bennee@linaro.org>
User-agent: mu4e 1.7.5; emacs 28.0.90
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Date: Fri, 10 Dec 2021 15:38:56 +0000
In-reply-to: <20211202115352.951548-1-alex.bennee@linaro.org>
Message-ID: <87czm4jwpu.fsf@linaro.org>
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

CkFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBIaSwKPgo+
IE5vdCBhIGdyZWF0IGRlYWwgaGFzIGNoYW5nZWQgZnJvbSB0aGUgbGFzdCBwb3N0aW5nIGFsdGhv
dWdoIEkgaGF2ZQo+IGRyb3BwZWQgdGhlIGFkZGl0aW9uYWwgdW5pdHRlc3RzLmNmZyBpbiBmYXZv
dXIgb2Ygc2V0dGluZyAibm9kZWZhdWx0Igo+IGZvciB0aGUgdGVzdHMuIE90aGVyd2lzZSB0aGUg
Y2xlYW4tdXBzIGFyZSBtYWlubHkgdGV4dHVhbCAocmVtb3ZpbmcKPiBwcmludGZzLCByYW5kb20g
bmV3bGluZXMgYW5kIGNsZWFuaW5nIHVwIGNvbW1lbnRzKS4gQXMgdXN1YWwgdGhlCj4gZGV0YWls
cyBhcmUgaW4gdGhlIGNvbW1pdHMgYmVsbG93IHRoZSAtLS0uCj4KPiBJJ3ZlIGFsc28gdHdlYWtl
ZCAuZ2l0L2NvbmZpZyBzbyBnZXRfbWFpbnRhaW5lci5wbCBzaG91bGQgZW5zdXJlCj4gZGlyZWN0
IGRlbGl2ZXJ5IG9mIHRoZSBwYXRjaGVzIDstKQoKR2VudGxlIHBpbmcuLi4KCi0tIApBbGV4IEJl
bm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
