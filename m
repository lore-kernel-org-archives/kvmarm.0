Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE95C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Dec 2021 13:46:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 674004B177;
	Fri,  3 Dec 2021 08:46:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PBc6jQNFfo1N; Fri,  3 Dec 2021 08:46:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 543DB4B19F;
	Fri,  3 Dec 2021 08:46:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A5B4B086
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 07:27:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfZELyKXlIRW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Dec 2021 07:27:49 -0500 (EST)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35AB74AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 07:27:49 -0500 (EST)
Received: by mail-pf1-f172.google.com with SMTP id x131so2733002pfc.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Dec 2021 04:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-transfer-encoding:content-language;
 bh=EA1du2e/ZPRzAt8K2DwIBgKjt5fsYwCbvSbLazp7FLA=;
 b=LnM14K0IH4hYWcx02Er5ag2+HMiyqlgR3Q0bBB0hoE/Yc+j2TzxgPYYBQHoDDQVheC
 2a1bjHXoHd+TLSDN5O7+t0DRX69uBDy1EpyIyLNnxRNBGd2czsiIHVDxr5tuI7xBzqYB
 /zTgw0PRoCeM4qOjNA7MACeNFmJfs7LtjmdeeHv7B+nhBnrKOEMjQtDmTh2gWHD+pkAG
 NCQfOnkp188m9zVsO6H4hFy6PPLm3lptrOhWxNYp//2esTtA4RfdwB6rAbNuhzZmdTJb
 jKTb7az+bf+exKCMGMRr61twCq1sgAWX500Y21LfOvfxR4xiz15JmzzH0kxo7NXy8oup
 Yj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=EA1du2e/ZPRzAt8K2DwIBgKjt5fsYwCbvSbLazp7FLA=;
 b=ndTID0jWYs+X0enZ6KdcbeywlN329uccNLC8a/Gbjj2WseslpIMPJZWQSHVGiDDfb5
 KTHCiARz+3yOjMtf4n6FrXF+f6Vcit5xSuu42oJUcmhSWC09OCNFZ6miiP/ulSKOz0iK
 72YzcMd6fnuWrjJ35VFB/WYZaWav5950hqVmCywE1cMp3eL8NrR85xs537Sul0Fo9F2e
 EKE+xQ/PdY9dQmgqONenb+okwFc42ZG+/JTrunAhJMdikqB4DmbvSU5leG0MtD9eSJvs
 nCRsur6Ov7795Tr/815yFjo7sIttDlwYXMsFQI62No7OTrzHsJ2dYaL64jAAB0YpHwsh
 OXEw==
X-Gm-Message-State: AOAM532VNH8INxaa0t06XT7GqM7CBHq8kD/iMJ6YqGuR2N7W8H70jbUz
 Ox24bWhbu3FHjtlbSSogecOeTQ==
X-Google-Smtp-Source: ABdhPJyrxTUXmZtazjCg/eZ+NyB0KowH4QAVCWqZOWtphbHo3fiDsky8cC6Lf9QHm8d5ncPuLQ4aIg==
X-Received: by 2002:a63:6687:: with SMTP id a129mr4131270pgc.477.1638534468248; 
 Fri, 03 Dec 2021 04:27:48 -0800 (PST)
Received: from [10.152.0.6] ([94.177.118.64])
 by smtp.gmail.com with ESMTPSA id mp12sm5226964pjb.39.2021.12.03.04.27.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 03 Dec 2021 04:27:47 -0800 (PST)
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <ee119b42-92b1-5744-4321-6356bafb498f@linaro.org>
Date: Fri, 3 Dec 2021 20:27:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211027104428.1059740-1-eric.auger@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 03 Dec 2021 08:46:41 -0500
Cc: kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
 chenxiang66@hisilicon.com, maz@kernel.org, vdumpa@nvidia.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, alex.williamson@redhat.com,
 yi.l.liu@intel.com, nicolinc@nvidia.com, vsethi@nvidia.com, sumitg@nvidia.com,
 lushenming@huawei.com, wangxingang5@huawei.com
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

CkhpLCBFcmljCgpPbiAyMDIxLzEwLzI3IOS4i+WNiDY6NDQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4g
VGhpcyBzZXJpZXMgYnJpbmdzIHRoZSBJT01NVSBwYXJ0IG9mIEhXIG5lc3RlZCBwYWdpbmcgc3Vw
cG9ydAo+IGluIHRoZSBTTU1VdjMuCj4KPiBUaGUgU01NVXYzIGRyaXZlciBpcyBhZGFwdGVkIHRv
IHN1cHBvcnQgMiBuZXN0ZWQgc3RhZ2VzLgo+Cj4gVGhlIElPTU1VIEFQSSBpcyBleHRlbmRlZCB0
byBjb252ZXkgdGhlIGd1ZXN0IHN0YWdlIDEKPiBjb25maWd1cmF0aW9uIGFuZCB0aGUgaG9vayBp
cyBpbXBsZW1lbnRlZCBpbiB0aGUgU01NVXYzIGRyaXZlci4KPgo+IFRoaXMgYWxsb3dzIHRoZSBn
dWVzdCB0byBvd24gdGhlIHN0YWdlIDEgdGFibGVzIGFuZCBjb250ZXh0Cj4gZGVzY3JpcHRvcnMg
KHNvLWNhbGxlZCBQQVNJRCB0YWJsZSkgd2hpbGUgdGhlIGhvc3Qgb3ducyB0aGUKPiBzdGFnZSAy
IHRhYmxlcyBhbmQgbWFpbiBjb25maWd1cmF0aW9uIHN0cnVjdHVyZXMgKFNURSkuCj4KPiBUaGlz
IHdvcmsgbWFpbmx5IGlzIHByb3ZpZGVkIGZvciB0ZXN0IHB1cnBvc2UgYXMgdGhlIHVwcGVyCj4g
bGF5ZXIgaW50ZWdyYXRpb24gaXMgdW5kZXIgcmV3b3JrIGFuZCBib3VuZCB0byBiZSBiYXNlZCBv
bgo+IC9kZXYvaW9tbXUgaW5zdGVhZCBvZiBWRklPIHR1bm5lbGluZy4gSW4gdGhpcyB2ZXJzaW9u
IHdlIGFsc28gZ2V0Cj4gcmlkIG9mIHRoZSBNU0kgQklORElORyBpb2N0bCwgYXNzdW1pbmcgdGhl
IGd1ZXN0IGVuZm9yY2VzCj4gZmxhdCBtYXBwaW5nIG9mIGhvc3QgSU9WQXMgdXNlZCB0byBiaW5k
IHBoeXNpY2FsIE1TSSBkb29yYmVsbHMuCj4gSW4gdGhlIGN1cnJlbnQgUUVNVSBpbnRlZ3JhdGlv
biB0aGlzIGlzIGFjaGlldmVkIGJ5IGV4cG9zaW5nCj4gUk1ScyB0byB0aGUgZ3Vlc3QsIHVzaW5n
IFNoYW1lZXIncyBzZXJpZXMgWzFdLiBUaGlzIGFwcHJvYWNoCj4gaXMgUkZDIGFzIHRoZSBJT1JU
IHNwZWMgaXMgbm90IHJlYWxseSBtZWFudCB0byBkbyB0aGF0Cj4gKHNpbmdsZSBtYXBwaW5nIGZs
YWcgbGltaXRhdGlvbikuCj4KPiBCZXN0IFJlZ2FyZHMKPgo+IEVyaWMKPgo+IFRoaXMgc2VyaWVz
IChIb3N0KSBjYW4gYmUgZm91bmQgYXQ6Cj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9saW51
eC90cmVlL3Y1LjE1LXJjNy1uZXN0ZWQtdjE2Cj4gVGhpcyBpbmNsdWRlcyBhIHJlYmFzZWQgVkZJ
TyBpbnRlZ3JhdGlvbiAoYWx0aG91Z2ggbm90IG1lYW50Cj4gdG8gYmUgdXBzdHJlYW1lZCkKPgo+
IEd1ZXN0IGtlcm5lbCBicmFuY2ggY2FuIGJlIGZvdW5kIGF0Ogo+IGh0dHBzOi8vZ2l0aHViLmNv
bS9lYXVnZXIvbGludXgvdHJlZS9zaGFtZWVyX3JtcnJfdjcKPiBmZWF0dXJpbmcgWzFdCj4KPiBR
RU1VIGludGVncmF0aW9uIChzdGlsbCBiYXNlZCBvbiBWRklPIGFuZCBleHBvc2luZyBSTVJzKQo+
IGNhbiBiZSBmb3VuZCBhdDoKPiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL3FlbXUvdHJlZS92
Ni4xLjAtcm1yLXYyLW5lc3RlZF9zbW11djNfdjEwCj4gKHVzZSBpb21tdT1uZXN0ZWQtc21tdXYz
IEFSTSB2aXJ0IG9wdGlvbikKPgo+IEd1ZXN0IGRlcGVuZGVuY3k6Cj4gWzFdIFtQQVRDSCB2NyAw
LzldIEFDUEkvSU9SVDogU3VwcG9ydCBmb3IgSU9SVCBSTVIgbm9kZQoKVGhhbmtzIGEgbG90IGZv
ciB1cGdyYWRpbmcgdGhlc2UgcGF0Y2hlcy4KCkkgaGF2ZSBiYXNpY2FsbHkgdmVyaWZpZWQgdGhl
c2UgcGF0Y2hlcyBvbiBIaVNpbGljb24gS3VucGVuZzkyMC4KQW5kIGludGVncmF0ZWQgdGhlbSB0
byB0aGVzZSBicmFuY2hlcy4KaHR0cHM6Ly9naXRodWIuY29tL0xpbmFyby9saW51eC1rZXJuZWwt
dWFkay90cmVlL3VhY2NlLWRldmVsLTUuMTYKaHR0cHM6Ly9naXRodWIuY29tL0xpbmFyby9xZW11
L3RyZWUvdjYuMS4wLXJtci12Mi1uZXN0ZWRfc21tdXYzX3YxMAoKVGhvdWdoIHRoZXkgYXJlIHBy
b3ZpZGVkIGZvciB0ZXN0IHB1cnBvc2UsCgpUZXN0ZWQtYnk6IFpoYW5nZmVpIEdhbyA8emhhbmdm
ZWkuZ2FvQGxpbmFyby5vcmc+CgpUaGFua3MKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
