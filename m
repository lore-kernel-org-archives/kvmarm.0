Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B188C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 14:45:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E1782086A
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 14:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FvCtsbAc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E1782086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D76384B6EF;
	Tue,  4 Aug 2020 10:45:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J7yHtGPAiV9R; Tue,  4 Aug 2020 10:45:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E03BC4B6ED;
	Tue,  4 Aug 2020 10:45:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D83DD4B6ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 10:45:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VZpCcDeaF5k for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 10:45:01 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7EEF4B6E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 10:45:01 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id c19so2348226wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2020 07:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:in-reply-to:date
 :message-id:mime-version:content-transfer-encoding;
 bh=vrgymxZSQXp65WBXBttM1JLkMuaQfRe8wtjepY95tOo=;
 b=FvCtsbAcTet/H4EtE/tlCenlm0kupTJUjVY5BAvOKP8h+7HD+fwbBGKRl+3mTUg2P3
 AOLJFJtqhWheJUnHcvV2gRZZl/e5Hwd0KeJvJKWc6fBfuwnqM5MEHPr9l8kuKh9SEzc6
 JwGUa13Gg4QLl+aX7y0+3wbedQ8FXbbdDg7njlKIw3vrnYglMl8Bbg0Dt8/9Xfr0mIjx
 S7QXNV28j7r4ilqWIXx2d4FkaJUSigF4jIsFiLcXgKIAPIVfUNgI0SeLCt/aTUHz4Zqd
 0FYNtKC4edmbJ2m6bxrgNQ0j/HY3t7uf/ktMC6ppPzM+H2oXHMrmQYNo7acLaSaE5m8W
 VzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject
 :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
 bh=vrgymxZSQXp65WBXBttM1JLkMuaQfRe8wtjepY95tOo=;
 b=s9CsMZuBTI2fZI9GxsKwvhaRs1pyGeVCJ915vQWIJ7jVQjvkznCJTvvVxPg1vIn3jR
 jBzpRa8iNubZ2IuZeNlQUgmKQVdY9zOs9XuYTC9WOd++5cIMYhBZdaewLVKWF4fRh1oB
 wP12vD7CGSxl0E83xFRXA0jFMC9fjJvBlLtaU2OPQTH7uxL0xYG+9h8MDnLQPhG/7Ri/
 EMlQ/U/sv70ww9AJQlwN+pPKp/4/CPDvEdqvJGvUWuebe4dxzzvdl4I9aiULtR5xbYs/
 FbzccSXKu+IwVbcDpNwJyNls8TmGOKHxSFDntMRh3K4XdkIfvEciD2Z9E4Jn0ySEXZmG
 2xyA==
X-Gm-Message-State: AOAM532Slh7OMdyaV40TK+O8dkU1G/7J4GVB6yPEOyAU/LGVRmXvXP2I
 LfQSCVA46aZa6Etl/skmaGgujQ==
X-Google-Smtp-Source: ABdhPJw2+EzPdKAw2t92FR+NukQ9ba0kagdIlf7j4tHEEt17qfb38xGsjZPDOkvrMuYeiS4q2cG8RA==
X-Received: by 2002:a1c:9c14:: with SMTP id f20mr4399867wme.77.1596552300706; 
 Tue, 04 Aug 2020 07:45:00 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z11sm29149417wrw.93.2020.08.04.07.44.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Aug 2020 07:44:59 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id A1F311FF7E;
 Tue,  4 Aug 2020 15:44:58 +0100 (BST)
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
 <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org>
User-agent: mu4e 1.5.5; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-reply-to: <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org>
Date: Tue, 04 Aug 2020 15:44:58 +0100
Message-ID: <87r1smmpw5.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Ck1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyaXRlczoKCj4gT24gMjAyMC0wOC0wNCAx
Mzo0NCwgQWxleCBCZW5uw6llIHdyb3RlOgo+PiBUaGUgVklSVElPX1BDSSBzdXBwb3J0IGlzIGFu
IGlkZWFsaXNlZCBQQ0kgYnVzLCB3ZSBkb24ndCBuZWVkIGEgYnVuY2gKPj4gb2YgYmxvYXQgZm9y
IHJlYWwgd29ybGQgaGFyZHdhcmUgZm9yIGEgVmlydElPIGd1ZXN0Lgo+Cj4gV2hvIHNheXMgdGhp
cyBndWVzdCB3aWxsIG9ubHkgaGF2ZSB2aXJ0aW8gZGV2aWNlcz8KClRoaXMgaXMgdHJ1ZSAtIGFs
dGhvdWdoIHdoYXQgaXMgdGhlIHBvaW50IG9mIGt2bV9ndWVzdC5jb25maWc/IFdlCmNlcnRhaW5s
eSB0dXJuIG9uIGEgd2hvbGUgYnVuY2ggb2YgdmlydCBvcHRpbWlzZWQgcGF0aHdheXMgd2l0aCBQ
QVJBVklSVAphbmQgSFlQRVJWSVNPUl9HVUVTVCBhbG9uZyB3aXRoIHRoZSByZXN0IG9mIFZpcnRJ
Ty4KCj4gT3IgZXZlbiwgdmlydGlvIGRldmljZXMgd2l0aG91dCBidWdzPyBHaXZlbiB0aGF0IHNh
aWQgZGV2aWNlIGNhbgo+IGNvbWUgZnJvbSBhbnkgVk1NLCBJJ20gbm90IHN1cmUgdGhpcyBpcyB0
aGUgcmlnaHQgdGhpbmcgdG8gZG8uCgpQZXJoYXBzIHRoaXMgcGF0Y2ggaXMgb25lIHRvbyBmYXIu
IEkgZG9uJ3QgbWluZCBkcm9wcGluZyBpdCBhcyBsb25nIGFzIEkKY2FuIHN0aWxsIHNsaW0gZG93
biB0aGUga2VybmVscyBJIGtub3cgZG9uJ3QgbmVlZCB0aGUgZXh0cmEgYmxvYXQuCgo+Cj4gVGhh
bmtzLAo+Cj4gICAgICAgICAgTS4KPgo+PiAKPj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6ll
IDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+PiAtLS0KPj4gIGtlcm5lbC9jb25maWdzL2t2bV9n
dWVzdC5jb25maWcgfCAxICsKPj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+PiAK
Pj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9jb25maWdzL2t2bV9ndWVzdC5jb25maWcgCj4+IGIva2Vy
bmVsL2NvbmZpZ3Mva3ZtX2d1ZXN0LmNvbmZpZwo+PiBpbmRleCAyMDg0ODFkOTEwOTAuLjY3Mjg2
M2EyZmRmMSAxMDA2NDQKPj4gLS0tIGEva2VybmVsL2NvbmZpZ3Mva3ZtX2d1ZXN0LmNvbmZpZwo+
PiArKysgYi9rZXJuZWwvY29uZmlncy9rdm1fZ3Vlc3QuY29uZmlnCj4+IEBAIC0xMyw2ICsxMyw3
IEBAIENPTkZJR19JUF9QTlBfREhDUD15Cj4+ICBDT05GSUdfQklORk1UX0VMRj15Cj4+ICBDT05G
SUdfUENJPXkKPj4gIENPTkZJR19QQ0lfTVNJPXkKPj4gK0NPTkZJR19QQ0lfUVVJUktTPW4KPj4g
IENPTkZJR19ERUJVR19LRVJORUw9eQo+PiAgQ09ORklHX1ZJUlRVQUxJWkFUSU9OPXkKPj4gIENP
TkZJR19IWVBFUlZJU09SX0dVRVNUPXkKCgotLSAKQWxleCBCZW5uw6llCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
