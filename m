Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0507FC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 11:06:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA30C4B0DF;
	Tue,  7 Dec 2021 06:06:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cp73VAk6aN-C; Tue,  7 Dec 2021 06:06:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A793C4B0C0;
	Tue,  7 Dec 2021 06:06:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA9D14B0B3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 06:06:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I4KQtGcKGvHg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 06:06:21 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 941964A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 06:06:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638875181;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nRg5DINjCe5e0zYHOQ+el+Q1dd4HwA20H1HpRmk80lA=;
 b=ioER9X+PKW6+3Kwu5G7u9QyebmL3StAyc1NwOInC0KkpEvTyIgdH63VVkjz3s1RXyAyXHU
 dWj8hmP85v0dfooEkb/DvMpZ9Dk2RubEZqseKgxO7Qur/itXXvI/xEPSJ/wxef1AdIBdRd
 E+kThYdRQGRCuzrCQfonLFtEneQkr+s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-olYtg8RhNmmvX1op_KprBw-1; Tue, 07 Dec 2021 06:06:19 -0500
X-MC-Unique: olYtg8RhNmmvX1op_KprBw-1
Received: by mail-wm1-f71.google.com with SMTP id
 o18-20020a05600c511200b00332fa17a02eso1215910wms.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 03:06:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=nRg5DINjCe5e0zYHOQ+el+Q1dd4HwA20H1HpRmk80lA=;
 b=xzckkH+9jQYWGAKrdTSY+HI+aQyWPeRi3PGnZVQwiEiL3QYWkM1DtMjozXcKDzM143
 eL/afkQfX2kEd0VojE1l0/CS87iLRIT4Axm/wzaMpzAmsQialxrFULFLUBI1nXrh7WGW
 gj2VeKTt6Sc6847Vo2BLPXCu9TX8FzfQGgJW8OOCfRhczrQFjOJxCc0j3WvimbtsGOHL
 MSTTRJ5X+asrs0X63XNbhzCtFnVUxnAcTWFv45toWv2DDGMT330X9tDLaemiAKTA/EpT
 05red+qAZjNmA8ZWvjUyPQgVzfTvlusiJVr0xT0tRoJptjKrUAQzaLrN2d6eIhR/EIwH
 DNIQ==
X-Gm-Message-State: AOAM532TEMbWQvELu1Tsr3pecFT/Njw9+gqpKDvvsO1BATCyDQrXO/sM
 WwWdmOUZlch4t614GFsHtLHuzeg1rCeX0RszoUrNMVjqw4yeyE04bfFi/iT9LC16Gy+jSI3ldQw
 FsST/1PZ1523hvbd/FYFynht0
X-Received: by 2002:a05:600c:3b28:: with SMTP id
 m40mr6117099wms.100.1638875177867; 
 Tue, 07 Dec 2021 03:06:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxi/ivnznn7trJTjiidNkJzjz1zRWIo5Uu4Z3R2uCviGWKVwvEBCQ2nckpYn4cvfIBk5jTULQ==
X-Received: by 2002:a05:600c:3b28:: with SMTP id
 m40mr6117074wms.100.1638875177635; 
 Tue, 07 Dec 2021 03:06:17 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id g4sm14083363wro.12.2021.12.07.03.06.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Dec 2021 03:06:17 -0800 (PST)
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To: Zhangfei Gao <zhangfei.gao@linaro.org>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <ee119b42-92b1-5744-4321-6356bafb498f@linaro.org>
 <7763531a-625d-10c6-c35e-2ce41e75f606@redhat.com>
 <c1e9dd67-0000-28b5-81c0-239ceda560ed@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <15a9875b-130a-e889-4e13-e063ef2ce4f9@redhat.com>
Date: Tue, 7 Dec 2021 12:06:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c1e9dd67-0000-28b5-81c0-239ceda560ed@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
 chenxiang66@hisilicon.com, maz@kernel.org, vdumpa@nvidia.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, alex.williamson@redhat.com,
 yi.l.liu@intel.com, nicolinc@nvidia.com, vsethi@nvidia.com, sumitg@nvidia.com,
 lushenming@huawei.com, wangxingang5@huawei.com
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

SGkgWmhhbmdmZWksCgpPbiAxMi83LzIxIDExOjM1IEFNLCBaaGFuZ2ZlaSBHYW8gd3JvdGU6Cj4K
Pgo+IE9uIDIwMjEvMTIvNyDkuIvljYg2OjI3LCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBIaSBaaGFu
Z2ZlaSwKPj4KPj4gT24gMTIvMy8yMSAxOjI3IFBNLCBaaGFuZ2ZlaSBHYW8gd3JvdGU6Cj4+PiBI
aSwgRXJpYwo+Pj4KPj4+IE9uIDIwMjEvMTAvMjcg5LiL5Y2INjo0NCwgRXJpYyBBdWdlciB3cm90
ZToKPj4+PiBUaGlzIHNlcmllcyBicmluZ3MgdGhlIElPTU1VIHBhcnQgb2YgSFcgbmVzdGVkIHBh
Z2luZyBzdXBwb3J0Cj4+Pj4gaW4gdGhlIFNNTVV2My4KPj4+Pgo+Pj4+IFRoZSBTTU1VdjMgZHJp
dmVyIGlzIGFkYXB0ZWQgdG8gc3VwcG9ydCAyIG5lc3RlZCBzdGFnZXMuCj4+Pj4KPj4+PiBUaGUg
SU9NTVUgQVBJIGlzIGV4dGVuZGVkIHRvIGNvbnZleSB0aGUgZ3Vlc3Qgc3RhZ2UgMQo+Pj4+IGNv
bmZpZ3VyYXRpb24gYW5kIHRoZSBob29rIGlzIGltcGxlbWVudGVkIGluIHRoZSBTTU1VdjMgZHJp
dmVyLgo+Pj4+Cj4+Pj4gVGhpcyBhbGxvd3MgdGhlIGd1ZXN0IHRvIG93biB0aGUgc3RhZ2UgMSB0
YWJsZXMgYW5kIGNvbnRleHQKPj4+PiBkZXNjcmlwdG9ycyAoc28tY2FsbGVkIFBBU0lEIHRhYmxl
KSB3aGlsZSB0aGUgaG9zdCBvd25zIHRoZQo+Pj4+IHN0YWdlIDIgdGFibGVzIGFuZCBtYWluIGNv
bmZpZ3VyYXRpb24gc3RydWN0dXJlcyAoU1RFKS4KPj4+Pgo+Pj4+IFRoaXMgd29yayBtYWlubHkg
aXMgcHJvdmlkZWQgZm9yIHRlc3QgcHVycG9zZSBhcyB0aGUgdXBwZXIKPj4+PiBsYXllciBpbnRl
Z3JhdGlvbiBpcyB1bmRlciByZXdvcmsgYW5kIGJvdW5kIHRvIGJlIGJhc2VkIG9uCj4+Pj4gL2Rl
di9pb21tdSBpbnN0ZWFkIG9mIFZGSU8gdHVubmVsaW5nLiBJbiB0aGlzIHZlcnNpb24gd2UgYWxz
byBnZXQKPj4+PiByaWQgb2YgdGhlIE1TSSBCSU5ESU5HIGlvY3RsLCBhc3N1bWluZyB0aGUgZ3Vl
c3QgZW5mb3JjZXMKPj4+PiBmbGF0IG1hcHBpbmcgb2YgaG9zdCBJT1ZBcyB1c2VkIHRvIGJpbmQg
cGh5c2ljYWwgTVNJIGRvb3JiZWxscy4KPj4+PiBJbiB0aGUgY3VycmVudCBRRU1VIGludGVncmF0
aW9uIHRoaXMgaXMgYWNoaWV2ZWQgYnkgZXhwb3NpbmcKPj4+PiBSTVJzIHRvIHRoZSBndWVzdCwg
dXNpbmcgU2hhbWVlcidzIHNlcmllcyBbMV0uIFRoaXMgYXBwcm9hY2gKPj4+PiBpcyBSRkMgYXMg
dGhlIElPUlQgc3BlYyBpcyBub3QgcmVhbGx5IG1lYW50IHRvIGRvIHRoYXQKPj4+PiAoc2luZ2xl
IG1hcHBpbmcgZmxhZyBsaW1pdGF0aW9uKS4KPj4+Pgo+Pj4+IEJlc3QgUmVnYXJkcwo+Pj4+Cj4+
Pj4gRXJpYwo+Pj4+Cj4+Pj4gVGhpcyBzZXJpZXMgKEhvc3QpIGNhbiBiZSBmb3VuZCBhdDoKPj4+
PiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL2xpbnV4L3RyZWUvdjUuMTUtcmM3LW5lc3RlZC12
MTYKPj4+PiBUaGlzIGluY2x1ZGVzIGEgcmViYXNlZCBWRklPIGludGVncmF0aW9uIChhbHRob3Vn
aCBub3QgbWVhbnQKPj4+PiB0byBiZSB1cHN0cmVhbWVkKQo+Pj4+Cj4+Pj4gR3Vlc3Qga2VybmVs
IGJyYW5jaCBjYW4gYmUgZm91bmQgYXQ6Cj4+Pj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9s
aW51eC90cmVlL3NoYW1lZXJfcm1ycl92Nwo+Pj4+IGZlYXR1cmluZyBbMV0KPj4+Pgo+Pj4+IFFF
TVUgaW50ZWdyYXRpb24gKHN0aWxsIGJhc2VkIG9uIFZGSU8gYW5kIGV4cG9zaW5nIFJNUnMpCj4+
Pj4gY2FuIGJlIGZvdW5kIGF0Ogo+Pj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9lYXVnZXIvcWVtdS90
cmVlL3Y2LjEuMC1ybXItdjItbmVzdGVkX3NtbXV2M192MTAKPj4+PiAodXNlIGlvbW11PW5lc3Rl
ZC1zbW11djMgQVJNIHZpcnQgb3B0aW9uKQo+Pj4+Cj4+Pj4gR3Vlc3QgZGVwZW5kZW5jeToKPj4+
PiBbMV0gW1BBVENIIHY3IDAvOV0gQUNQSS9JT1JUOiBTdXBwb3J0IGZvciBJT1JUIFJNUiBub2Rl
Cj4+PiBUaGFua3MgYSBsb3QgZm9yIHVwZ3JhZGluZyB0aGVzZSBwYXRjaGVzLgo+Pj4KPj4+IEkg
aGF2ZSBiYXNpY2FsbHkgdmVyaWZpZWQgdGhlc2UgcGF0Y2hlcyBvbiBIaVNpbGljb24gS3VucGVu
ZzkyMC4KPj4+IEFuZCBpbnRlZ3JhdGVkIHRoZW0gdG8gdGhlc2UgYnJhbmNoZXMuCj4+PiBodHRw
czovL2dpdGh1Yi5jb20vTGluYXJvL2xpbnV4LWtlcm5lbC11YWRrL3RyZWUvdWFjY2UtZGV2ZWwt
NS4xNgo+Pj4gaHR0cHM6Ly9naXRodWIuY29tL0xpbmFyby9xZW11L3RyZWUvdjYuMS4wLXJtci12
Mi1uZXN0ZWRfc21tdXYzX3YxMAo+Pj4KPj4+IFRob3VnaCB0aGV5IGFyZSBwcm92aWRlZCBmb3Ig
dGVzdCBwdXJwb3NlLAo+Pj4KPj4+IFRlc3RlZC1ieTogWmhhbmdmZWkgR2FvIDx6aGFuZ2ZlaS5n
YW9AbGluYXJvLm9yZz4KPj4gVGhhbmsgeW91IHZlcnkgbXVjaC4gQXMgeW91IG1lbnRpb25lZCwg
dW50aWwgd2UgZG8gbm90IGhhdmUgdGhlCj4+IC9kZXYvaW9tbXUgaW50ZWdyYXRpb24gdGhpcyBp
cyBtYWludGFpbmVkIGZvciB0ZXN0aW5nIHB1cnBvc2UuIFRoZSBTTU1VCj4+IGNoYW5nZXMgc2hv
dWxkbid0IGJlIG11Y2ggaW1wYWN0ZWQgdGhvdWdoLgo+PiBUaGUgYWRkZWQgdmFsdWUgb2YgdGhp
cyByZXNwaW4gd2FzIHRvIHByb3Bvc2UgYW4gTVNJIGJpbmRpbmcgc29sdXRpb24KPj4gYmFzZWQg
b24gUk1SUnMgd2hpY2ggc2ltcGxpZnkgdGhpbmdzIGF0IGtlcm5lbCBsZXZlbC4KPgo+IEN1cnJl
bnQgUk1SUiBzb2x1dGlvbiByZXF1aXJlcyB1ZWZpIGVuYWJsZWQsCj4gYW5kIFFFTVVfRUZJLmZk
wqAgaGFzIHRvIGJlIHByb3ZpZGVkIHRvIHN0YXJ0IHFlbXUuCj4KPiBBbnkgcGxhbiB0byBzdXBw
b3J0IGR0YiBhcyB3ZWxsLCB3aGljaCB3aWxsIGJlIHNpbXBsZXIgc2luY2Ugbm8gbmVlZAo+IFFF
TVVfRUZJLmZkIGFueW1vcmUuClllcyB0aGUgc29sdXRpb24gaXMgYmFzZWQgb24gQUNQSSBJT1JU
IG5vZGVzLiBObyBjbHVlIGlmIHNvbWUgRFQKaW50ZWdyYXRpb24gaXMgdW5kZXIgd29yay4gU2hh
bWVlcj8KClRoYW5rcwoKRXJpYwo+Cj4gVGhhbmtzCj4KPgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
