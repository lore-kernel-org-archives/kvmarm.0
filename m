Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1DEC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 10:28:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7353A4B08B;
	Tue,  7 Dec 2021 05:28:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ueNmw3jDv1jH; Tue,  7 Dec 2021 05:28:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B4349F5F;
	Tue,  7 Dec 2021 05:28:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 934CA49F5F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:28:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tK9KTkaXubxT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 05:28:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1010B40667
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:28:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638872917;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=d58w/O9tmt4TQ0yEa0JhGzxmg+sZ/WD5ifzH3Bv9Ixg=;
 b=IOM5Is90cwql3d86jczDjOD67f0Jcw/ucdZw/Nx56hqdnC6YeU87Y3WBulVOhZPyyDAqiL
 7S4JuJiCA38UWpNQDTJ7BEg0WMZEkBmCPAWxx3zyAcvUgNeuvB8p8qJpJCArAJPpvdeWII
 T4EXGG20VXYnOKZMkzd+VpbTxFFewPU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-334-7UUmWvy-NXSmmkEKXk3Hig-1; Tue, 07 Dec 2021 05:28:36 -0500
X-MC-Unique: 7UUmWvy-NXSmmkEKXk3Hig-1
Received: by mail-wm1-f71.google.com with SMTP id
 i131-20020a1c3b89000000b00337f92384e0so1018521wma.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 02:28:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=d58w/O9tmt4TQ0yEa0JhGzxmg+sZ/WD5ifzH3Bv9Ixg=;
 b=VLnqMrPfRclkvaSjpiFz/ti8DkB9hSXjGXv9O3vnMofvKlQGspsmR9e1I3IMQdfcb+
 JM2ESqGmQowv1W0vd5bU+TISG/8ZCvzqn8u2NZ9MS5FYGs5R9NKbGK+yULrfvgtWhdMj
 K9W0ZfJIW/ks4+q91A9HVENB7u+pwdrdUCSsn67UrYHNfRioH0K3cz+Fw8N0CLFfKBlI
 Xzq8w7DeFeR0qbVbCu9UA7C5lrQEq7EyVoKg0X3IPHmjCaJVwJe6bYcOPt19tth2JarQ
 wLfn5rXBmmL8Iul+dR/3objkrRyFjwp0whWP+kOj4mdd15vmiL+WFzL7jlCpvpxS07JD
 D8yg==
X-Gm-Message-State: AOAM532pzNQirQlwFQWYywCXmFRQwTMl5+ZTZMoXTZFpdYtARvuxlHFS
 KSzy0ct0P2NssFj8WJqZMdhdr16G0GIrE46IivDr7Iu7BORaA4/pSKCl1l82RJml/ZTVN1oUj7b
 HeWcBNV6zpj7SwGH0i0gG+YOi
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr50103346wrd.33.1638872915671; 
 Tue, 07 Dec 2021 02:28:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9yqgtAotyRXCF75l+LBkff1xoYlfGD7TQ/mCawQyzCBi7p3cdMYW9aV0zdVcyfpRAAKmK1g==
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr50103308wrd.33.1638872915426; 
 Tue, 07 Dec 2021 02:28:35 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id e24sm14675252wra.78.2021.12.07.02.28.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Dec 2021 02:28:34 -0800 (PST)
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To: Sumit Gupta <sumitg@nvidia.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <4921cd06-065d-951d-d396-ee9843882c40@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <780faf42-e035-4bfd-252d-8d009355bd6c@redhat.com>
Date: Tue, 7 Dec 2021 11:28:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4921cd06-065d-951d-d396-ee9843882c40@nvidia.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: vivek.gautam@arm.com, yi.l.liu@intel.com, alex.williamson@redhat.com,
 ashok.raj@intel.com, maz@kernel.org, vsethi@nvidia.com, nicolinc@nvidia.com,
 zhangfei.gao@linaro.org, kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
 Pritesh Raithatha <praithatha@nvidia.com>, nicoleotsuka@gmail.com,
 Sachin Nikam <Snikam@nvidia.com>, wangxingang5@huawei.com,
 chenxiang66@hisilicon.com, vdumpa@nvidia.com, lushenming@huawei.com
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

SGkgU3VtaXQsCgpPbiAxMi8zLzIxIDI6MTMgUE0sIFN1bWl0IEd1cHRhIHdyb3RlOgo+IEhpIEVy
aWMsCj4KPj4gVGhpcyBzZXJpZXMgYnJpbmdzIHRoZSBJT01NVSBwYXJ0IG9mIEhXIG5lc3RlZCBw
YWdpbmcgc3VwcG9ydAo+PiBpbiB0aGUgU01NVXYzLgo+Pgo+PiBUaGUgU01NVXYzIGRyaXZlciBp
cyBhZGFwdGVkIHRvIHN1cHBvcnQgMiBuZXN0ZWQgc3RhZ2VzLgo+Pgo+PiBUaGUgSU9NTVUgQVBJ
IGlzIGV4dGVuZGVkIHRvIGNvbnZleSB0aGUgZ3Vlc3Qgc3RhZ2UgMQo+PiBjb25maWd1cmF0aW9u
IGFuZCB0aGUgaG9vayBpcyBpbXBsZW1lbnRlZCBpbiB0aGUgU01NVXYzIGRyaXZlci4KPj4KPj4g
VGhpcyBhbGxvd3MgdGhlIGd1ZXN0IHRvIG93biB0aGUgc3RhZ2UgMSB0YWJsZXMgYW5kIGNvbnRl
eHQKPj4gZGVzY3JpcHRvcnMgKHNvLWNhbGxlZCBQQVNJRCB0YWJsZSkgd2hpbGUgdGhlIGhvc3Qg
b3ducyB0aGUKPj4gc3RhZ2UgMiB0YWJsZXMgYW5kIG1haW4gY29uZmlndXJhdGlvbiBzdHJ1Y3R1
cmVzIChTVEUpLgo+Pgo+PiBUaGlzIHdvcmsgbWFpbmx5IGlzIHByb3ZpZGVkIGZvciB0ZXN0IHB1
cnBvc2UgYXMgdGhlIHVwcGVyCj4+IGxheWVyIGludGVncmF0aW9uIGlzIHVuZGVyIHJld29yayBh
bmQgYm91bmQgdG8gYmUgYmFzZWQgb24KPj4gL2Rldi9pb21tdSBpbnN0ZWFkIG9mIFZGSU8gdHVu
bmVsaW5nLiBJbiB0aGlzIHZlcnNpb24gd2UgYWxzbyBnZXQKPj4gcmlkIG9mIHRoZSBNU0kgQklO
RElORyBpb2N0bCwgYXNzdW1pbmcgdGhlIGd1ZXN0IGVuZm9yY2VzCj4+IGZsYXQgbWFwcGluZyBv
ZiBob3N0IElPVkFzIHVzZWQgdG8gYmluZCBwaHlzaWNhbCBNU0kgZG9vcmJlbGxzLgo+PiBJbiB0
aGUgY3VycmVudCBRRU1VIGludGVncmF0aW9uIHRoaXMgaXMgYWNoaWV2ZWQgYnkgZXhwb3NpbmcK
Pj4gUk1ScyB0byB0aGUgZ3Vlc3QsIHVzaW5nIFNoYW1lZXIncyBzZXJpZXMgWzFdLiBUaGlzIGFw
cHJvYWNoCj4+IGlzIFJGQyBhcyB0aGUgSU9SVCBzcGVjIGlzIG5vdCByZWFsbHkgbWVhbnQgdG8g
ZG8gdGhhdAo+PiAoc2luZ2xlIG1hcHBpbmcgZmxhZyBsaW1pdGF0aW9uKS4KPj4KPj4gQmVzdCBS
ZWdhcmRzCj4+Cj4+IEVyaWMKPj4KPj4gVGhpcyBzZXJpZXMgKEhvc3QpIGNhbiBiZSBmb3VuZCBh
dDoKPj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9saW51eC90cmVlL3Y1LjE1LXJjNy1uZXN0
ZWQtdjE2Cj4+IFRoaXMgaW5jbHVkZXMgYSByZWJhc2VkIFZGSU8gaW50ZWdyYXRpb24gKGFsdGhv
dWdoIG5vdCBtZWFudAo+PiB0byBiZSB1cHN0cmVhbWVkKQo+Pgo+PiBHdWVzdCBrZXJuZWwgYnJh
bmNoIGNhbiBiZSBmb3VuZCBhdDoKPj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9saW51eC90
cmVlL3NoYW1lZXJfcm1ycl92Nwo+PiBmZWF0dXJpbmcgWzFdCj4+Cj4+IFFFTVUgaW50ZWdyYXRp
b24gKHN0aWxsIGJhc2VkIG9uIFZGSU8gYW5kIGV4cG9zaW5nIFJNUnMpCj4+IGNhbiBiZSBmb3Vu
ZCBhdDoKPj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9xZW11L3RyZWUvdjYuMS4wLXJtci12
Mi1uZXN0ZWRfc21tdXYzX3YxMAo+PiAodXNlIGlvbW11PW5lc3RlZC1zbW11djMgQVJNIHZpcnQg
b3B0aW9uKQo+Pgo+PiBHdWVzdCBkZXBlbmRlbmN5Ogo+PiBbMV0gW1BBVENIIHY3IDAvOV0gQUNQ
SS9JT1JUOiBTdXBwb3J0IGZvciBJT1JUIFJNUiBub2RlCj4+Cj4+IEhpc3Rvcnk6Cj4+Cj4+IHYx
NSAtPiB2MTY6Cj4+IC0gZ3Vlc3QgUklMIG11c3Qgc3VwcG9ydCBSSUwKPj4gLSBhZGRpdGlvbmFs
IGNoZWNrcyBpbiB0aGUgY2FjaGUgaW52YWxpZGF0aW9uIGhvb2sKPj4gLSByZW1vdmFsIG9mIHRo
ZSBNU0kgQklORElORyBpb2N0bCAodGVudGF0aXZlIHJlcGxhY2VtZW50Cj4+IMKgwqAgYnkgUk1S
cykKPj4KPj4KPj4gRXJpYyBBdWdlciAoOSk6Cj4+IMKgwqAgaW9tbXU6IEludHJvZHVjZSBhdHRh
Y2gvZGV0YWNoX3Bhc2lkX3RhYmxlIEFQSQo+PiDCoMKgIGlvbW11OiBJbnRyb2R1Y2UgaW9tbXVf
Z2V0X25lc3RpbmcKPj4gwqDCoCBpb21tdS9zbW11djM6IEFsbG93IHMxIGFuZCBzMiBjb25maWdz
IHRvIGNvZXhpc3QKPj4gwqDCoCBpb21tdS9zbW11djM6IEdldCBwcmVwYXJlZCBmb3IgbmVzdGVk
IHN0YWdlIHN1cHBvcnQKPj4gwqDCoCBpb21tdS9zbW11djM6IEltcGxlbWVudCBhdHRhY2gvZGV0
YWNoX3Bhc2lkX3RhYmxlCj4+IMKgwqAgaW9tbXUvc21tdXYzOiBBbGxvdyBzdGFnZSAxIGludmFs
aWRhdGlvbiB3aXRoIHVubWFuYWdlZCBBU0lEcwo+PiDCoMKgIGlvbW11L3NtbXV2MzogSW1wbGVt
ZW50IGNhY2hlX2ludmFsaWRhdGUKPj4gwqDCoCBpb21tdS9zbW11djM6IHJlcG9ydCBhZGRpdGlv
bmFsIHJlY292ZXJhYmxlIGZhdWx0cwo+PiDCoMKgIGlvbW11L3NtbXV2MzogRGlzYWxsb3cgbmVz
dGVkIG1vZGUgaW4gcHJlc2VuY2Ugb2YgSFcgTVNJIHJlZ2lvbnMKPiBIaSBFcmljLAo+Cj4gSSB2
YWxpZGF0ZWQgdGhlIHJld29ya2VkIHRlc3QgcGF0Y2hlcyBpbiB2MTYgZnJvbSB0aGUgZ2l2ZW4K
PiBicmFuY2hlcyB3aXRoIEtlcm5lbCB2NS4xNSAmIFFlbXUgdjYuMi4gVmVyaWZpZWQgdGhlbSB3
aXRoCj4gTlZNZSBQQ0kgZGV2aWNlIGFzc2lnbmVkIHRvIEd1ZXN0IFZNLgo+IFNvcnJ5LCBmb3Jn
b3QgdG8gdXBkYXRlIGVhcmxpZXIuCj4KPiBUZXN0ZWQtYnk6IFN1bWl0IEd1cHRhIDxzdW1pdGdA
bnZpZGlhLmNvbT4KClRoYW5rIHlvdSB2ZXJ5IG11Y2ghCgpCZXN0IFJlZ2FyZHMKCkVyaWMKPgo+
IFRoYW5rcywKPiBTdW1pdCBHdXB0YQo+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
