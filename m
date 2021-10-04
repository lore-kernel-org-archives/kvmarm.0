Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A4FC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 12:23:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 547536124C
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 12:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 547536124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C26014B289;
	Mon,  4 Oct 2021 08:23:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vANQswdxAH76; Mon,  4 Oct 2021 08:23:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3F9D4B279;
	Mon,  4 Oct 2021 08:23:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0275D4B276
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 08:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zq6E3IcvE0ph for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 08:23:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E913F4B26D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 08:23:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633350225;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Wl7ICQODkHW0YfDfZWHTQGFAOQQBlguFC3IFpZqYzao=;
 b=bZYcqv9ZABKO/NIvZXNHmDf6zcYS/6x3VmDDF6fRnfjuy0XsPDFpNDnTXDUuiBbNdT0VpH
 u/v7yBDnLWduOBE7DyC69Zts0jYOxCGtD3sLJsoeN5MOOC1cw24zDqYr1YvAj0fn9Y7Q/+
 PIIWO0lkAtuT7SFxvckz3+1LUve3v1U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-vP__lr2ZPM23p4VEe1UH7w-1; Mon, 04 Oct 2021 08:23:44 -0400
X-MC-Unique: vP__lr2ZPM23p4VEe1UH7w-1
Received: by mail-wm1-f72.google.com with SMTP id
 u3-20020a7bcb03000000b0030d5228cbbdso4129251wmj.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 05:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=Wl7ICQODkHW0YfDfZWHTQGFAOQQBlguFC3IFpZqYzao=;
 b=ZbyUgTetjg/SK4th2wMM4Kzi+QMF174JkpwR0hXUr2IjDdL1PKX4/4ZW09HGmq0oq9
 BatpzXaV44o+9Udw5xzkvhQHvmnIS6hWHR0mD0t5E905LP9JPPQxLOSHVhaaok4HUziB
 dsCRGAUXLVORTHV0Pyp+BTUsi9olrqNdPA6U42VuiXeA8oV0IcqwBpaOA0P5pRTvNPId
 Jqvpvm5gPNm8GCA9oUp4W3UoE2uuHFkgH9SDOSLX/h7PXe+/tls2RIOu/NKzwFu5qWdj
 kQEbTKRGfkC0sQXEU/9wrJMON4B/dcEH59AwNimzk3QtXAOX7YxFrEQ6f5IaJJDPnkC6
 kJaQ==
X-Gm-Message-State: AOAM531izZSdbyWdg4uONYj+QWbIThh9QUq+nlavSCx7gVblBcF2yr4J
 hN8vjS3rubqSDNscGX0P4AyJmidBwDssF4M2elisSXZqsd5+UxgGwlzORQxsbhJxb15xgHkxaUD
 XsE4up7VhFcNwZCkAF6PVTKt3
X-Received: by 2002:a05:600c:aca:: with SMTP id
 c10mr18225427wmr.174.1633350223577; 
 Mon, 04 Oct 2021 05:23:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxitcIwPYb5MpA3gCLqjGct65p9PyV+TzRYqXfXifFRuJt7/5ttvdPSHfIcdPnoBpfMalndPA==
X-Received: by 2002:a05:600c:aca:: with SMTP id
 c10mr18225400wmr.174.1633350223347; 
 Mon, 04 Oct 2021 05:23:43 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id f19sm14674493wmf.11.2021.10.04.05.23.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 04 Oct 2021 05:23:42 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-4-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <b36a602e-a8f4-c8ac-bd4b-95fd6d426736@redhat.com>
Date: Mon, 4 Oct 2021 14:23:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-4-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

SGkgTWFyYywKCk9uIDEwLzMvMjEgNjo0NiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEV2ZW4g
d2hlbiB0aGUgVk0gaXMgY29uZmlndXJlZCB3aXRoIGhpZ2htZW09b2ZmLCB0aGUgaGlnaGVzdF9n
cGEKPiBmaWVsZCBpbmNsdWRlcyBkZXZpY2VzIHRoYXQgYXJlIGFib3ZlIHRoZSA0R2lCIGxpbWl0
Lgo+IFNpbWlsYXJpbHksIG5vdGhpbmcgc2VlbSB0byBjaGVjayB0aGF0IHRoZSBtZW1vcnkgaXMg
d2l0aGluCj4gdGhlIGxpbWl0IHNldCBieSB0aGUgaGlnaG1lbT1vZmYgb3B0aW9uLgo+Cj4gVGhp
cyBsZWFkcyB0byBmYWlsdXJlcyBpbiB2aXJ0X2t2bV90eXBlKCkgb24gc3lzdGVtcyB0aGF0IGhh
dmUKPiBhIGNyaXBwbGVkIElQQSByYW5nZSwgYXMgdGhlIHJlcG9ydGVkIElQQSBzcGFjZSBpcyBs
YXJnZXIgdGhhbgo+IHdoYXQgaXQgc2hvdWxkIGJlLgo+Cj4gSW5zdGVhZCwgaG9ub3IgdGhlIHVz
ZXItc3BlY2lmaWVkIGxpbWl0IHRvIG9ubHkgdXNlIHRoZSBkZXZpY2VzCj4gYXQgdGhlIGxvd2Vz
dCBlbmQgb2YgdGhlIHNwZWN0cnVtLCBhbmQgZmFpbCBpZiB3ZSBoYXZlIG1lbW9yeQo+IGNyb3Nz
aW5nIHRoZSA0R2lCIGxpbWl0Lgo+Cj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpA
a2VybmVsLm9yZz4KPiAtLS0KPiAgaHcvYXJtL3ZpcnQuYyB8IDkgKysrKysrKystCj4gIDEgZmls
ZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQg
YS9ody9hcm0vdmlydC5jIGIvaHcvYXJtL3ZpcnQuYwo+IGluZGV4IGJjZjU4ZjY3N2QuLjlkMmFi
ZGJkNWYgMTAwNjQ0Cj4gLS0tIGEvaHcvYXJtL3ZpcnQuYwo+ICsrKyBiL2h3L2FybS92aXJ0LmMK
PiBAQCAtMTYyOCw2ICsxNjI4LDExIEBAIHN0YXRpYyB2b2lkIHZpcnRfc2V0X21lbW1hcChWaXJ0
TWFjaGluZVN0YXRlICp2bXMpCj4gICAgICAgICAgZXhpdChFWElUX0ZBSUxVUkUpOwo+ICAgICAg
fQo+ICAKPiArICAgIGlmICghdm1zLT5oaWdobWVtICYmCj4gKyAgICAgICAgdm1zLT5tZW1tYXBb
VklSVF9NRU1dLmJhc2UgKyBtcy0+bWF4cmFtX3NpemUgPiA0ICogR2lCKSB7Cj4gKyAgICAgICAg
ZXJyb3JfcmVwb3J0KCJoaWdobWVtPW9mZiwgYnV0IG1lbW9yeSBjcm9zc2VzIHRoZSA0R2lCIGxp
bWl0XG4iKTsKPiArICAgICAgICBleGl0KEVYSVRfRkFJTFVSRSk7Cj4gKyAgICB9Cj4gICAgICAv
Kgo+ICAgICAgICogV2UgY29tcHV0ZSB0aGUgYmFzZSBvZiB0aGUgaGlnaCBJTyByZWdpb24gZGVw
ZW5kaW5nIG9uIHRoZQo+ICAgICAgICogYW1vdW50IG9mIGluaXRpYWwgYW5kIGRldmljZSBtZW1v
cnkuIFRoZSBkZXZpY2UgbWVtb3J5IHN0YXJ0L3NpemUKPiBAQCAtMTY1Nyw3ICsxNjYyLDkgQEAg
c3RhdGljIHZvaWQgdmlydF9zZXRfbWVtbWFwKFZpcnRNYWNoaW5lU3RhdGUgKnZtcykKPiAgICAg
ICAgICB2bXMtPm1lbW1hcFtpXS5zaXplID0gc2l6ZTsKPiAgICAgICAgICBiYXNlICs9IHNpemU7
Cj4gICAgICB9Cj4gLSAgICB2bXMtPmhpZ2hlc3RfZ3BhID0gYmFzZSAtIDE7Cj4gKyAgICB2bXMt
PmhpZ2hlc3RfZ3BhID0gKHZtcy0+aGlnaG1lbSA/Cj4gKyAgICAgICAgICAgICAgICAgICAgICAg
IGJhc2UgOgo+ICsgICAgICAgICAgICAgICAgICAgICAgICB2bXMtPm1lbW1hcFtWSVJUX01FTV0u
YmFzZSArIG1zLT5tYXhyYW1fc2l6ZSkgLSAxOwpJIHRoaW5rIEkgd291bGQgaGF2ZSBwcmVmZXJy
ZWQgdG8gaGF2ZQoKaWYgKHZtcy0+aGlnaG1lbSkgewrCoMKgIGZvciAoaSA9IFZJUlRfTE9XTUVN
TUFQX0xBU1Q7IGkgPCBBUlJBWV9TSVpFKGV4dGVuZGVkX21lbW1hcCk7IGkrKykgewrCoMKgwqDC
oMKgwqDCoCBod2FkZHIgc2l6ZSA9IGV4dGVuZGVkX21lbW1hcFtpXS5zaXplOwoKwqDCoMKgwqDC
oMKgwqAgYmFzZSA9IFJPVU5EX1VQKGJhc2UsIHNpemUpOwrCoMKgwqDCoMKgwqDCoCB2bXMtPm1l
bW1hcFtpXS5iYXNlID0gYmFzZTsKwqDCoMKgwqDCoMKgwqAgdm1zLT5tZW1tYXBbaV0uc2l6ZSA9
IHNpemU7CsKgwqDCoMKgwqDCoMKgIGJhc2UgKz0gc2l6ZTsKwqDCoMKgIH0KfQphcyBpdCBpcyB1
c2VsZXNzIHRvIGV4ZWN1dGUgdGhhdCBjb2RlIGFuZCBjcmVhdGUgbmV3IG1lbW1hcCBlbnRyaWVz
IGluCmNhc2Ugb2YgIWhpZ2htZW0uCgpCdXQgbmV2ZXJ0aGVsZXNzLCB0aGlzIGxvb2tzIGNvcnJl
Y3QKCkVyaWMKPiAgICAgIGlmIChkZXZpY2VfbWVtb3J5X3NpemUgPiAwKSB7Cj4gICAgICAgICAg
bXMtPmRldmljZV9tZW1vcnkgPSBnX21hbGxvYzAoc2l6ZW9mKCptcy0+ZGV2aWNlX21lbW9yeSkp
Owo+ICAgICAgICAgIG1zLT5kZXZpY2VfbWVtb3J5LT5iYXNlID0gZGV2aWNlX21lbW9yeV9iYXNl
OwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
