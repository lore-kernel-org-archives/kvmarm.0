Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3206C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:10:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F4C04B1F3;
	Wed,  1 Dec 2021 12:10:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hv7PfQ9Y0b4N; Wed,  1 Dec 2021 12:10:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E06C24B222;
	Wed,  1 Dec 2021 12:10:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3FBA4B1F3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:10:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 613AM70H5Ftu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:10:22 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 349204B1A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:10:22 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id j3so53861317wrp.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=/X+/QxH+bVpFbkeVkq7fkm197u4ULafwc+IR32ELh1k=;
 b=go/sAKu7WW/YgsktUC2OW1737aLS+jPp0bC/fb2h5/iwMr+Os3UTniuAczMdvZT6Kb
 2oID0VC8Y9ivdrkQJGNx4MX4jEl1zRSzFYTZnPylIVikppQJ927Ke+ZCfpP9kPLHHS0F
 Cpzb3h9ScWgG7vQot5tgvZecFfNj7046fphQ/9HB/dRpxa6OuZ++nG+0r6m2b1OKbfii
 BuLHL/r3ABllhuL26zxNm5YTUB8en3EkzkYSwSnhAAEzgxUt5x4H6HNxfvifxwEfMnQz
 mp+5vhdsGIk9xmJgbEBKWWsNoyBOTMvGjXlXKSky8Gs0793EnfIdHN2wytXVCemSPSeD
 F6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=/X+/QxH+bVpFbkeVkq7fkm197u4ULafwc+IR32ELh1k=;
 b=XqViGADoFc7Q4X6qhmbw3Sy7ty3bjQL1dYMqbZQaeN7xbPstvFOLpxjJ60/zvUNQ7v
 DyOxC/aYBmooJObGzRj/k3bjK9WmuoAECvshtJxmpl66O3ChCMiJi8BDE42EAMrYeo8U
 Nc3X1yNDXYbz7QNy1RjSSlI/nNnNR1yiYifOf6GbhQo0g6/HKSv9J6VfSG67h1cG3cvu
 eWREQhsBnJ27JVDN6oAHlT6ySWPdyvlDN1t9QxVl7x3Ma0/p0PlbhVUPQ5KfCp8L5Gjn
 uTjk+R2jQ153p1KZy8TojMu5bIMEtymCOJXYb6uDO/Wh2zmF8p/3KWk16MvkIos0UkJO
 6ZPg==
X-Gm-Message-State: AOAM5309ahHGN3SgKvEvL38aSrtPhKXEwnbNQSPemJOj5yDqGwy5L1HB
 6djjZmqw5lQvTB8uRKV1crcAmg==
X-Google-Smtp-Source: ABdhPJw2gK/ra0IeZfBdyCLqQaEhPVT3xRtPOjjBII6XwS3PuoIKwZpcVTOvBz3S4B8LRrF5JuAFUA==
X-Received: by 2002:a5d:6d4c:: with SMTP id k12mr8069364wri.511.1638378621070; 
 Wed, 01 Dec 2021 09:10:21 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id k27sm1776152wms.41.2021.12.01.09.10.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Dec 2021 09:10:20 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 29B4B1FF96;
 Wed,  1 Dec 2021 17:10:19 +0000 (GMT)
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
 <20211124164859.4enqimrptr3pfdkp@gator> <87o860xpkr.fsf@linaro.org>
 <20211201164100.57ima4v5ppqojmu7@gator>
User-agent: mu4e 1.7.5; emacs 28.0.60
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Date: Wed, 01 Dec 2021 17:07:18 +0000
In-reply-to: <20211201164100.57ima4v5ppqojmu7@gator>
Message-ID: <87k0goxnd0.fsf@linaro.org>
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIFdlZCwgRGVj
IDAxLCAyMDIxIGF0IDA0OjIwOjAyUE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gCj4+
IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4+IAo+PiA+IE9uIFRo
dSwgTm92IDE4LCAyMDIxIGF0IDA2OjQ2OjQ0UE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToK
Pj4gPj4gVGhlIHVwY29taW5nIE1UVENHIHRlc3RzIGRvbid0IG5lZWQgdG8gYmUgcnVuIGZvciBu
b3JtYWwgS1ZNIHVuaXQKPj4gPj4gdGVzdHMgc28gbGV0cyBhZGQgdGhlIGZhY2lsaXR5IHRvIGhh
dmUgYSBjdXN0b20gc2V0IG9mIHRlc3RzLgo+PiA+Cj4+ID4gSSB0aGluayBhbiBlbnZpcm9ubWVu
dCB2YXJpYWJsZSBvdmVycmlkZSB3b3VsZCBiZSBiZXR0ZXIgdGhhbiB0aGlzIGNvbW1hbmQKPj4g
PiBsaW5lIG92ZXJyaWRlLCBiZWNhdXNlIHRoZW4gd2UgY291bGQgYWxzbyBnZXQgbWtzdGFuZGFs
b25lIHRvIHdvcmsgd2l0aAo+PiA+IHRoZSBuZXcgdW5pdHRlc3RzLmNmZyBmaWxlcy4gT3IsIGl0
IG1heSBiZSBiZXR0ZXIgdG8ganVzdCBhZGQgdGhlbSB0bwo+PiA+IHRoZSBtYWluIHVuaXR0ZXN0
cy5jZmcgd2l0aCBsaW5lcyBsaWtlIHRoZXNlCj4+ID4KPj4gPiBncm91cHMgPSBub2RlZmF1bHQg
bXR0Y2cKPj4gPiBhY2NlbCA9IHRjZwo+PiA+Cj4+ID4gVGhhdCdsbCAiZGlydHkiIHRoZSBsb2dz
IHdpdGggU0tJUCAuLi4gKHRlc3QgbWFya2VkIGFzIG1hbnVhbCBydW4gb25seSkKPj4gPiBmb3Ig
ZWFjaCBvbmUsIGJ1dCBhdCBsZWFzdCB3ZSB3b24ndCBlYXNpbHkgZm9yZ2V0IGFib3V0IHJ1bm5p
bmcgdGhlbSBmcm9tCj4+ID4gdGltZSB0byB0aW1lLgo+PiAKPj4gU28gd2hhdCBpcyB0aGUgbWVh
bmluZyBvZiBhY2NlbCBoZXJlPyBJcyBpdDoKPj4gCj4+ICAgLSB0aGlzIHRlc3Qgb25seSBydW5z
IG9uIGFjY2VsIEZPTwo+PiAKPj4gb3IKPj4gCj4+ICAgLSB0aGlzIHRlc3QgZGVmYXVsdHMgdG8g
cnVubmluZyBvbiBhY2NlbCBGT08KPj4gCj4+IGJlY2F1c2Ugd2hpbGUgdGhlIHRlc3RzIGFyZSBm
b3IgVENHIEkgd2FudCB0byBydW4gdGhlbSBvbiBLVk0gKHNvIEkgY2FuCj4+IHZhbGlkYXRlIHRo
ZSB0ZXN0IG9uIHJlYWwgSFcpLiBJZiBJIGhhdmUgYWNjZWw9dGNnIHRoZW46Cj4+IAo+PiAgIGVu
diBBQ0NFTD1rdm0gUUVNVT0kSE9NRS9sc3JjL3FlbXUuZ2l0L2J1aWxkcy9hbGwvcWVtdS1zeXN0
ZW0tYWFyY2g2NCAuL3J1bl90ZXN0cy5zaCAtZyBtdHRjZwo+PiAgIFNLSVAgdGxiZmx1c2gtY29k
ZTo6YWxsX290aGVyICh0Y2cgb25seSwgYnV0IEFDQ0VMPWt2bSkKPj4gICBTS0lQIHRsYmZsdXNo
LWNvZGU6OnBhZ2Vfb3RoZXIgKHRjZyBvbmx5LCBidXQgQUNDRUw9a3ZtKQo+PiAgIFNLSVAgdGxi
Zmx1c2gtY29kZTo6YWxsX3NlbGYgKHRjZyBvbmx5LCBidXQgQUNDRUw9a3ZtKQo+PiAgIC4uLgo+
PiAKPj4gc28gSSBjYW4gZWl0aGVyIGRyb3AgdGhlIGFjY2VsIGxpbmUgYW5kIHJlbHkgb24gbm9k
ZWZhdWx0IHRvIGVuc3VyZSBpdAo+PiBkb2Vzbid0IHJ1biBub3JtYWxseSBvciBtYWtlIHRoZSBl
bnYgQUNDRUwgcHJvY2Vzc2luZyBsZXNzIGFuYWwgYWJvdXQKPj4gcHJldmVudGluZyBtZSBydW5u
aW5nIFRDRyB0ZXN0cyB1bmRlciBLVk0uIFdoYXQgZG8geW91IHRoaW5rPwo+Cj4gSnVzdCBkcm9w
IHRoZSAnYWNjZWwgPSB0Y2cnIGxpbmUuIEkgb25seSBzdWdnZXN0ZWQgaXQgYmVjYXVzZSBJIGRp
ZG4ndAo+IGtub3cgeW91IGFsc28gd2FudGVkIHRvIHJ1biB0aGUgTVRUQ0cgInNwZWNpZmljIiB0
ZXN0cyB1bmRlciBLVk0uIE5vdywKPiB0aGF0IEkgZG8sIEkgd29uZGVyIHdoeSB3ZSB3b3VsZG4n
dCBydW4gdGhlbSBhbGwgdGhlIHRpbWUsIGkuZS4gbm8KPiBub2RlZmF1bHQgZ3JvdXA/IERvIHRo
ZSB0ZXN0cyBub3QgZXhlcmNpc2UgZW5vdWdoIGh5cGVydmlzb3IgY29kZSB0bwo+IGJlIHdvcnRo
IHRoZSBlbmVyZ3kgdXNlZCB0byBydW4gdGhlbT8KCkkgdGhpbmsgaW4gbW9zdCBjYXNlcyBpZiB0
aGV5IGZhaWwgdW5kZXIgS1ZNIGl0IHdvdWxkbid0IGJlIGR1ZSB0byB0aGUKaHlwZXJ2aXNvciBi
ZWluZyBicm9rZW4gYnV0IHRoZSBzaWxpY29uIG5vdCBtZWV0aW5nIGl0J3MgYXJjaGl0ZWN0dXJh
bApzcGVjaWZpY2F0aW9uLiBJJ20gZmluZSB3aXRoIHRoZW0gYmVpbmcgbm9kZWZhdWx0IGZvciB0
aGF0LgoKSSdtIG5vdCBzdXJlIGhvdyBtdWNoIHRoZSB0bGJmbHVzaCBjb2RlIGV4ZXJjaXNlcyBv
biB0aGUgaG9zdC4gVGhlcmUgaXMKYSBXSVAgdGxiZmx1c2gtZGF0YSB3aGljaCBtaWdodCBtYWtl
IGEgY2FzZSBmb3IgYmVpbmcgcnVuIG1vcmUKcmVndWxhcmx5IG9uIEtWTS4KCj4KPiBUaGFua3Ms
Cj4gZHJldwoKCi0tIApBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
