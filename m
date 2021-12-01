Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BF3C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 16:22:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96DF34B27A;
	Wed,  1 Dec 2021 11:22:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dUwEwpmjkVuf; Wed,  1 Dec 2021 11:22:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4601C4B208;
	Wed,  1 Dec 2021 11:22:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4937D4B102
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 11:22:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MJAcWeVT-7xe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 11:22:31 -0500 (EST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E09604B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 11:22:30 -0500 (EST)
Received: by mail-wm1-f51.google.com with SMTP id o29so20880645wms.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 08:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=nCd1FlJuwlol8JfHsZBMh4q7Xxo8vRZYsT7cpMErU+8=;
 b=N5AXa0XGds9hExKOmGXWSzY/w/sFfTu/JDlECRTPLk/cyHcysnjhU3XKdLd2DX0qOc
 4Isugx2RyTK5k+uOiuqMyv2ldiYu7e40AOX/mBJbozN8e0uYQbfDZztYGo6WE6WP6VC9
 i/mIa2up1CSuHA+wQMCH7TTVnRul/hlJB1amIww0xQXEL0I086Mk28LxsVJ3JpN5fYLg
 Q9YKiB4B48QezpubJ16Fn5lHpe3GU3/8bwaW2DGb9F130jTB1rU9bRRaiHFyEPVt3SNr
 WGj+5h+KrrXeVEoTv00mCALRdGB81C5Njy1RPiXJOUoZLwMqtBCFRhYrmwdYCB6Oe3TO
 6d2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=nCd1FlJuwlol8JfHsZBMh4q7Xxo8vRZYsT7cpMErU+8=;
 b=ZL8MPrxUHUH/WOHUjrPnQ82fraGdCUiJuc9R0gF02mahUrJWXIthViec79v9+Yb8gE
 d5nNd4VvGnwXIugNTKkLXb91PS4bvEWRXHgfBe9YUCAlx7pkgW6/sjDuTv1CL8DdEuq1
 V24EFr6Uho3scQToo1UxueQcMx2pCVP5taVQCAzaY5vsn6iqy1vgLXrX+gmudr8jfrfJ
 NIy5D1AuUtMBtDfckhKpolT7DKsnrA4RivwauKh54ehS2ZxgtkNY3kXTqUD9SiNtkaaL
 ZL0WXUcFEJjLOY9HFh6icH2iKL5wgpelM5H2zMVJ6IlAai4aEYjFPQmWGgHJUGLE2HSs
 ALxA==
X-Gm-Message-State: AOAM533v3FoZcvcgckgb3+tsCUpFR01y9zEq56S3JMKOz22X5ic0kiBZ
 iyRZfKo53NL4LY3XcuMEJj9xqA==
X-Google-Smtp-Source: ABdhPJw5mSovegWUJbSMKuylZDiEDy+t6coLgM37P0uX1r9MXZRrqPpfRE3Oj9J4TZrgo3ietSBFbg==
X-Received: by 2002:a1c:1f53:: with SMTP id f80mr8165968wmf.129.1638375749898; 
 Wed, 01 Dec 2021 08:22:29 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id q26sm248744wrc.39.2021.12.01.08.22.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Dec 2021 08:22:29 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 802AB1FF96;
 Wed,  1 Dec 2021 16:22:28 +0000 (GMT)
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
 <20211124164859.4enqimrptr3pfdkp@gator>
User-agent: mu4e 1.7.5; emacs 28.0.60
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Date: Wed, 01 Dec 2021 16:20:02 +0000
In-reply-to: <20211124164859.4enqimrptr3pfdkp@gator>
Message-ID: <87o860xpkr.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
 idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIFRodSwgTm92
IDE4LCAyMDIxIGF0IDA2OjQ2OjQ0UE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gVGhl
IHVwY29taW5nIE1UVENHIHRlc3RzIGRvbid0IG5lZWQgdG8gYmUgcnVuIGZvciBub3JtYWwgS1ZN
IHVuaXQKPj4gdGVzdHMgc28gbGV0cyBhZGQgdGhlIGZhY2lsaXR5IHRvIGhhdmUgYSBjdXN0b20g
c2V0IG9mIHRlc3RzLgo+Cj4gSSB0aGluayBhbiBlbnZpcm9ubWVudCB2YXJpYWJsZSBvdmVycmlk
ZSB3b3VsZCBiZSBiZXR0ZXIgdGhhbiB0aGlzIGNvbW1hbmQKPiBsaW5lIG92ZXJyaWRlLCBiZWNh
dXNlIHRoZW4gd2UgY291bGQgYWxzbyBnZXQgbWtzdGFuZGFsb25lIHRvIHdvcmsgd2l0aAo+IHRo
ZSBuZXcgdW5pdHRlc3RzLmNmZyBmaWxlcy4gT3IsIGl0IG1heSBiZSBiZXR0ZXIgdG8ganVzdCBh
ZGQgdGhlbSB0bwo+IHRoZSBtYWluIHVuaXR0ZXN0cy5jZmcgd2l0aCBsaW5lcyBsaWtlIHRoZXNl
Cj4KPiBncm91cHMgPSBub2RlZmF1bHQgbXR0Y2cKPiBhY2NlbCA9IHRjZwo+Cj4gVGhhdCdsbCAi
ZGlydHkiIHRoZSBsb2dzIHdpdGggU0tJUCAuLi4gKHRlc3QgbWFya2VkIGFzIG1hbnVhbCBydW4g
b25seSkKPiBmb3IgZWFjaCBvbmUsIGJ1dCBhdCBsZWFzdCB3ZSB3b24ndCBlYXNpbHkgZm9yZ2V0
IGFib3V0IHJ1bm5pbmcgdGhlbSBmcm9tCj4gdGltZSB0byB0aW1lLgoKU28gd2hhdCBpcyB0aGUg
bWVhbmluZyBvZiBhY2NlbCBoZXJlPyBJcyBpdDoKCiAgLSB0aGlzIHRlc3Qgb25seSBydW5zIG9u
IGFjY2VsIEZPTwoKb3IKCiAgLSB0aGlzIHRlc3QgZGVmYXVsdHMgdG8gcnVubmluZyBvbiBhY2Nl
bCBGT08KCmJlY2F1c2Ugd2hpbGUgdGhlIHRlc3RzIGFyZSBmb3IgVENHIEkgd2FudCB0byBydW4g
dGhlbSBvbiBLVk0gKHNvIEkgY2FuCnZhbGlkYXRlIHRoZSB0ZXN0IG9uIHJlYWwgSFcpLiBJZiBJ
IGhhdmUgYWNjZWw9dGNnIHRoZW46CgogIGVudiBBQ0NFTD1rdm0gUUVNVT0kSE9NRS9sc3JjL3Fl
bXUuZ2l0L2J1aWxkcy9hbGwvcWVtdS1zeXN0ZW0tYWFyY2g2NCAuL3J1bl90ZXN0cy5zaCAtZyBt
dHRjZwogIFNLSVAgdGxiZmx1c2gtY29kZTo6YWxsX290aGVyICh0Y2cgb25seSwgYnV0IEFDQ0VM
PWt2bSkKICBTS0lQIHRsYmZsdXNoLWNvZGU6OnBhZ2Vfb3RoZXIgKHRjZyBvbmx5LCBidXQgQUND
RUw9a3ZtKQogIFNLSVAgdGxiZmx1c2gtY29kZTo6YWxsX3NlbGYgKHRjZyBvbmx5LCBidXQgQUND
RUw9a3ZtKQogIC4uLgoKc28gSSBjYW4gZWl0aGVyIGRyb3AgdGhlIGFjY2VsIGxpbmUgYW5kIHJl
bHkgb24gbm9kZWZhdWx0IHRvIGVuc3VyZSBpdApkb2Vzbid0IHJ1biBub3JtYWxseSBvciBtYWtl
IHRoZSBlbnYgQUNDRUwgcHJvY2Vzc2luZyBsZXNzIGFuYWwgYWJvdXQKcHJldmVudGluZyBtZSBy
dW5uaW5nIFRDRyB0ZXN0cyB1bmRlciBLVk0uIFdoYXQgZG8geW91IHRoaW5rPwoKLS0gCkFsZXgg
QmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
