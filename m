Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374B4C2BB85
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3EFC206E9
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wydQ1wV/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3EFC206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CBF64B213;
	Thu, 16 Apr 2020 07:10:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f74So1XXqR8R; Thu, 16 Apr 2020 07:10:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F36C4B256;
	Thu, 16 Apr 2020 07:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBA824B19E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 00:25:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XIUsD6Knmxzb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 00:25:48 -0400 (EDT)
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com
 [209.85.216.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 855C14B18D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 00:25:48 -0400 (EDT)
Received: by mail-pj1-f68.google.com with SMTP id z9so830337pjd.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 21:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-transfer-encoding:content-language;
 bh=rKdwxJq97I01y7ryQhSihbE5DvwLxtqugoVKkJX3ixQ=;
 b=wydQ1wV/OhVMd3QRFRKKNzkbsnXsrk7VwwEFQLbqM5ghK2myZ3rUwtN43+86ag5Yt2
 TOVAOmy3v83wlL5xBTadZIUPf+hW0tBsAuWepalWfrbGXhvYreeXUsNypMLEaIpgpwvr
 PdXGZjbSqpgXelubvmrELN3048hxl5mUCg3NnN2b4krIxxmP0EodZKg13/EFYF9wHYZu
 th6OcVEd1GYkAlpaK0/CDS+PavGH/YJhb9gM6FMd2Hn30UAhBpPttl/yVOnQckXFs1+9
 ByjKBlDgOAaMd4fSyIWUuB3lXPe1GalgZBYhX0Jk2ev8iAwwfXtj7rBzBsG2jmmx/old
 tBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=rKdwxJq97I01y7ryQhSihbE5DvwLxtqugoVKkJX3ixQ=;
 b=RBoMC64izl96sOlLfuh/1WIsvgd9KH4E+aQQQaKhFztJP3Bg8hkek776cvggOvPaAC
 dFcr3P6jrY2S7flQ8TfYMwSK35LbdcoE7Y3j0p+iYJWNijfa9KH22+PUgcx4xgMnvuBl
 iOzeAtd0ngxOhB8xkk46U6moIbSCLZuzprvSl2PDPqlDijobitRCZkminFm0MAP5so5z
 FG65EBidyyChxWpAB9KHIG6uTwNUGFGRZGtveZcTEDjAJ6cpQYWSZcwk9HUG865+xBYj
 O0P2afdOeLgoPJVUjUpwyH+yuP9dmHfjcCGTYF+Qcz2//DuIgdDyeLwfJI7dnboqX586
 9klA==
X-Gm-Message-State: AGi0PubHXeoBvLT2IEBCpTVcE/Rtp4d51gRBHz/R8ck4oO9gQPrQfphL
 oLI2bJ9W3xL9lW0FNbmDJ0bBHw==
X-Google-Smtp-Source: APiQypIcBT/ktZ74DASZLCa7QPuT/QUI+4S8qRnrlE/V9pcUl97OuPwTBQpFJ7Cl/s+5dnZ05jLWvw==
X-Received: by 2002:a17:90b:3547:: with SMTP id
 lt7mr2650982pjb.96.1587011147553; 
 Wed, 15 Apr 2020 21:25:47 -0700 (PDT)
Received: from [10.129.0.126] ([45.135.186.84])
 by smtp.gmail.com with ESMTPSA id e29sm10568241pgn.57.2020.04.15.21.25.38
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 15 Apr 2020 21:25:47 -0700 (PDT)
Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
References: <20200414150607.28488-1-eric.auger@redhat.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
Date: Thu, 16 Apr 2020 12:25:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 16 Apr 2020 07:10:16 -0400
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 alex.williamson@redhat.com, yi.l.liu@intel.com, bbhushan2@marvell.com
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiAyMDIwLzQvMTQg5LiL5Y2IMTE6MDUsIEVyaWMgQXVnZXIgd3JvdGU6Cj4gVGhpcyB2ZXJz
aW9uIGZpeGVzIGFuIGlzc3VlIG9ic2VydmVkIGJ5IFNoYW1lZXIgb24gYW4gU01NVSAzLjIsCj4g
d2hlbiBtb3ZpbmcgZnJvbSBkdWFsIHN0YWdlIGNvbmZpZyB0byBzdGFnZSAxIG9ubHkgY29uZmln
Lgo+IFRoZSAyIGhpZ2ggNjRiIG9mIHRoZSBTVEUgbm93IGdldCByZXNldC4gT3RoZXJ3aXNlLCBs
ZWF2aW5nIHRoZQo+IFMyVFRCIHNldCBtYXkgY2F1c2UgYSBDX0JBRF9TVEUgZXJyb3IuCj4KPiBU
aGlzIHNlcmllcyBjYW4gYmUgZm91bmQgYXQ6Cj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9s
aW51eC90cmVlL3Y1LjYtMnN0YWdlLXYxMV8xMC4xCj4gKGluY2x1ZGluZyB0aGUgVkZJTyBwYXJ0
KQo+IFRoZSBRRU1VIGZlbGxvdyBzZXJpZXMgc3RpbGwgY2FuIGJlIGZvdW5kIGF0Ogo+IGh0dHBz
Oi8vZ2l0aHViLmNvbS9lYXVnZXIvcWVtdS90cmVlL3Y0LjIuMC0yc3RhZ2UtcmZjdjYKPgo+IFVz
ZXJzIGhhdmUgZXhwcmVzc2VkIGludGVyZXN0IGluIHRoYXQgd29yayBhbmQgdGVzdGVkIHY5L3Yx
MDoKPiAtIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvY292ZXIvMTEwMzk5OTUvIzIzMDEy
MzgxCj4gLSBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL2NvdmVyLzExMDM5OTk1LyMyMzE5
NzIzNQo+Cj4gQmFja2dyb3VuZDoKPgo+IFRoaXMgc2VyaWVzIGJyaW5ncyB0aGUgSU9NTVUgcGFy
dCBvZiBIVyBuZXN0ZWQgcGFnaW5nIHN1cHBvcnQKPiBpbiB0aGUgU01NVXYzLiBUaGUgVkZJTyBw
YXJ0IGlzIHN1Ym1pdHRlZCBzZXBhcmF0ZWx5Lgo+Cj4gVGhlIElPTU1VIEFQSSBpcyBleHRlbmRl
ZCB0byBzdXBwb3J0IDIgbmV3IEFQSSBmdW5jdGlvbmFsaXRpZXM6Cj4gMSkgcGFzcyB0aGUgZ3Vl
c3Qgc3RhZ2UgMSBjb25maWd1cmF0aW9uCj4gMikgcGFzcyBzdGFnZSAxIE1TSSBiaW5kaW5ncwo+
Cj4gVGhlbiB0aG9zZSBjYXBhYmlsaXRpZXMgZ2V0cyBpbXBsZW1lbnRlZCBpbiB0aGUgU01NVXYz
IGRyaXZlci4KPgo+IFRoZSB2aXJ0dWFsaXplciBwYXNzZXMgaW5mb3JtYXRpb24gdGhyb3VnaCB0
aGUgVkZJTyB1c2VyIEFQSQo+IHdoaWNoIGNhc2NhZGVzIHRoZW0gdG8gdGhlIGlvbW11IHN1YnN5
c3RlbS4gVGhpcyBhbGxvd3MgdGhlIGd1ZXN0Cj4gdG8gb3duIHN0YWdlIDEgdGFibGVzIGFuZCBj
b250ZXh0IGRlc2NyaXB0b3JzIChzby1jYWxsZWQgUEFTSUQKPiB0YWJsZSkgd2hpbGUgdGhlIGhv
c3Qgb3ducyBzdGFnZSAyIHRhYmxlcyBhbmQgbWFpbiBjb25maWd1cmF0aW9uCj4gc3RydWN0dXJl
cyAoU1RFKS4KPgo+CgpUaGFua3MgRXJpYwoKVGVzdGVkIHYxMSBvbiBIaXNpbGljb24ga3VucGVu
ZzkyMCBib2FyZCB2aWEgaGFyZHdhcmUgemlwIGFjY2VsZXJhdG9yLgoxLiBuby1zdmEgd29ya3Ms
IHdoZXJlIGd1ZXN0IGFwcCBkaXJlY3RseSB1c2UgcGh5c2ljYWwgYWRkcmVzcyB2aWEgaW9jdGwu
CjIuIHZTVkEgc3RpbGwgbm90IHdvcmssIHNhbWUgYXMgdjEwLAozLsKgIHRoZSB2MTAgaXNzdWUg
cmVwb3J0ZWQgYnkgU2hhbWVlciBoYXMgYmVlbiBzb2x2ZWQswqAgZmlyc3Qgc3RhcnQgcWVtdSAK
d2l0aMKgIGlvbW11PXNtbXV2MywgdGhlbiBzdGFydCBxZW11IHdpdGhvdXTCoCBpb21tdT1zbW11
djMKNC4gbm8tc3ZhIGFsc28gd29ya3Mgd2l0aG91dMKgIGlvbW11PXNtbXV2MwoKVGVzdCBkZXRh
aWxzIGluIGh0dHBzOi8vZG9jcy5xcS5jb20vZG9jL0RSVTVvUjFOdFVFUnNlRk5MCgpUaGFua3MK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
