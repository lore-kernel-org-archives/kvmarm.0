Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2796C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 10:37:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BA6B40413;
	Tue,  7 Dec 2021 05:37:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4HdLijtig896; Tue,  7 Dec 2021 05:37:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FDEE49DE3;
	Tue,  7 Dec 2021 05:37:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F23EF4B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:35:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Tx61h1dowco for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 05:35:37 -0500 (EST)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79B814B0A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:35:37 -0500 (EST)
Received: by mail-pl1-f173.google.com with SMTP id u17so9120210plg.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 02:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-transfer-encoding:content-language;
 bh=JxiMwx4C7x5k8y2Xl9TOjw2NlxLDyAqVmINHy5bpGck=;
 b=vK5p9DHLGcOw0yiyBwJ9laMSSiVhDZQCvmpDM1iH75e2UfhLDYH/mf7e2HrefL/sMv
 fhAra2Bm7cbrxeJgUQNpQ12hDCle+9SXTLYbiM/gw88s5dtwt+0nnivf4XJuwXg6Ninb
 QSHEiaoZSstIGC2u3byuj1+L3cvdSkzGWuh2L6DBWe5yDmt9EbHOF47NYdZG8yq0KxCj
 VPIxhqGjsxNJ2uUnhPpAblUNr8sjLY3nb7KpYeFPQYSSuKMUNWtZUIB+sUlCmkMtyJyQ
 RZ1FrGLgkEUTcsMN1wKyAmyuWlOXBASfTDmzMQLTSA9EpwcFt8NZ221OOL4/vrP9wrdN
 gMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=JxiMwx4C7x5k8y2Xl9TOjw2NlxLDyAqVmINHy5bpGck=;
 b=7bJdOgJO6dodVTPlpmkwMbOVvlcbPR0Bue0Ssy/MkufILhS/TMr7L6+oJJztB1axhs
 M+IVGQvQcuhhEOwHz8cIj8dDStWLH9HDy3THoNQ3QfsDcbdNoDZOrE/40Q6z1MU0Jw7p
 pjyrQDUwcJrH9dNRFSzqPbScZ9vo0r8fXgFMr5lTzvR0jwEKfIOit/zzGuF+wzYdqKXf
 weALAjowU5KY2b11xBM7JtXVzFDMPBmsf2G0MvWcohDiK09BcCTl+OIDWV8ULz1MawTh
 ZZH+uyzvnAHUZCKJ72IcqC6sC5L0eMDnGZmlvvFTs7Yn5eeT1g0e7wp6S89W93CMnq9L
 adBg==
X-Gm-Message-State: AOAM532TOotlZlrqYkRhP/C1mhsLoX4AOVD32vA1dZhSui6/OEYhhspK
 peTp8GyLFkBs3/teQX8OEcsirw==
X-Google-Smtp-Source: ABdhPJxVXLdqIw+lDiAPUjGajLKImI1eWzIJDKJ3QTpNQZ82cEF0W15LjnO9lyFohe3k4lFOhliP3g==
X-Received: by 2002:a17:90a:cb98:: with SMTP id
 a24mr5558447pju.153.1638873336553; 
 Tue, 07 Dec 2021 02:35:36 -0800 (PST)
Received: from [10.59.0.6] ([94.177.118.48])
 by smtp.gmail.com with ESMTPSA id y22sm9020940pfa.107.2021.12.07.02.35.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Dec 2021 02:35:36 -0800 (PST)
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To: eric.auger@redhat.com, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <ee119b42-92b1-5744-4321-6356bafb498f@linaro.org>
 <7763531a-625d-10c6-c35e-2ce41e75f606@redhat.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <c1e9dd67-0000-28b5-81c0-239ceda560ed@linaro.org>
Date: Tue, 7 Dec 2021 18:35:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7763531a-625d-10c6-c35e-2ce41e75f606@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 07 Dec 2021 05:37:05 -0500
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

CgpPbiAyMDIxLzEyLzcg5LiL5Y2INjoyNywgRXJpYyBBdWdlciB3cm90ZToKPiBIaSBaaGFuZ2Zl
aSwKPgo+IE9uIDEyLzMvMjEgMToyNyBQTSwgWmhhbmdmZWkgR2FvIHdyb3RlOgo+PiBIaSwgRXJp
Ywo+Pgo+PiBPbiAyMDIxLzEwLzI3IOS4i+WNiDY6NDQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+PiBU
aGlzIHNlcmllcyBicmluZ3MgdGhlIElPTU1VIHBhcnQgb2YgSFcgbmVzdGVkIHBhZ2luZyBzdXBw
b3J0Cj4+PiBpbiB0aGUgU01NVXYzLgo+Pj4KPj4+IFRoZSBTTU1VdjMgZHJpdmVyIGlzIGFkYXB0
ZWQgdG8gc3VwcG9ydCAyIG5lc3RlZCBzdGFnZXMuCj4+Pgo+Pj4gVGhlIElPTU1VIEFQSSBpcyBl
eHRlbmRlZCB0byBjb252ZXkgdGhlIGd1ZXN0IHN0YWdlIDEKPj4+IGNvbmZpZ3VyYXRpb24gYW5k
IHRoZSBob29rIGlzIGltcGxlbWVudGVkIGluIHRoZSBTTU1VdjMgZHJpdmVyLgo+Pj4KPj4+IFRo
aXMgYWxsb3dzIHRoZSBndWVzdCB0byBvd24gdGhlIHN0YWdlIDEgdGFibGVzIGFuZCBjb250ZXh0
Cj4+PiBkZXNjcmlwdG9ycyAoc28tY2FsbGVkIFBBU0lEIHRhYmxlKSB3aGlsZSB0aGUgaG9zdCBv
d25zIHRoZQo+Pj4gc3RhZ2UgMiB0YWJsZXMgYW5kIG1haW4gY29uZmlndXJhdGlvbiBzdHJ1Y3R1
cmVzIChTVEUpLgo+Pj4KPj4+IFRoaXMgd29yayBtYWlubHkgaXMgcHJvdmlkZWQgZm9yIHRlc3Qg
cHVycG9zZSBhcyB0aGUgdXBwZXIKPj4+IGxheWVyIGludGVncmF0aW9uIGlzIHVuZGVyIHJld29y
ayBhbmQgYm91bmQgdG8gYmUgYmFzZWQgb24KPj4+IC9kZXYvaW9tbXUgaW5zdGVhZCBvZiBWRklP
IHR1bm5lbGluZy4gSW4gdGhpcyB2ZXJzaW9uIHdlIGFsc28gZ2V0Cj4+PiByaWQgb2YgdGhlIE1T
SSBCSU5ESU5HIGlvY3RsLCBhc3N1bWluZyB0aGUgZ3Vlc3QgZW5mb3JjZXMKPj4+IGZsYXQgbWFw
cGluZyBvZiBob3N0IElPVkFzIHVzZWQgdG8gYmluZCBwaHlzaWNhbCBNU0kgZG9vcmJlbGxzLgo+
Pj4gSW4gdGhlIGN1cnJlbnQgUUVNVSBpbnRlZ3JhdGlvbiB0aGlzIGlzIGFjaGlldmVkIGJ5IGV4
cG9zaW5nCj4+PiBSTVJzIHRvIHRoZSBndWVzdCwgdXNpbmcgU2hhbWVlcidzIHNlcmllcyBbMV0u
IFRoaXMgYXBwcm9hY2gKPj4+IGlzIFJGQyBhcyB0aGUgSU9SVCBzcGVjIGlzIG5vdCByZWFsbHkg
bWVhbnQgdG8gZG8gdGhhdAo+Pj4gKHNpbmdsZSBtYXBwaW5nIGZsYWcgbGltaXRhdGlvbikuCj4+
Pgo+Pj4gQmVzdCBSZWdhcmRzCj4+Pgo+Pj4gRXJpYwo+Pj4KPj4+IFRoaXMgc2VyaWVzIChIb3N0
KSBjYW4gYmUgZm91bmQgYXQ6Cj4+PiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL2xpbnV4L3Ry
ZWUvdjUuMTUtcmM3LW5lc3RlZC12MTYKPj4+IFRoaXMgaW5jbHVkZXMgYSByZWJhc2VkIFZGSU8g
aW50ZWdyYXRpb24gKGFsdGhvdWdoIG5vdCBtZWFudAo+Pj4gdG8gYmUgdXBzdHJlYW1lZCkKPj4+
Cj4+PiBHdWVzdCBrZXJuZWwgYnJhbmNoIGNhbiBiZSBmb3VuZCBhdDoKPj4+IGh0dHBzOi8vZ2l0
aHViLmNvbS9lYXVnZXIvbGludXgvdHJlZS9zaGFtZWVyX3JtcnJfdjcKPj4+IGZlYXR1cmluZyBb
MV0KPj4+Cj4+PiBRRU1VIGludGVncmF0aW9uIChzdGlsbCBiYXNlZCBvbiBWRklPIGFuZCBleHBv
c2luZyBSTVJzKQo+Pj4gY2FuIGJlIGZvdW5kIGF0Ogo+Pj4gaHR0cHM6Ly9naXRodWIuY29tL2Vh
dWdlci9xZW11L3RyZWUvdjYuMS4wLXJtci12Mi1uZXN0ZWRfc21tdXYzX3YxMAo+Pj4gKHVzZSBp
b21tdT1uZXN0ZWQtc21tdXYzIEFSTSB2aXJ0IG9wdGlvbikKPj4+Cj4+PiBHdWVzdCBkZXBlbmRl
bmN5Ogo+Pj4gWzFdIFtQQVRDSCB2NyAwLzldIEFDUEkvSU9SVDogU3VwcG9ydCBmb3IgSU9SVCBS
TVIgbm9kZQo+PiBUaGFua3MgYSBsb3QgZm9yIHVwZ3JhZGluZyB0aGVzZSBwYXRjaGVzLgo+Pgo+
PiBJIGhhdmUgYmFzaWNhbGx5IHZlcmlmaWVkIHRoZXNlIHBhdGNoZXMgb24gSGlTaWxpY29uIEt1
bnBlbmc5MjAuCj4+IEFuZCBpbnRlZ3JhdGVkIHRoZW0gdG8gdGhlc2UgYnJhbmNoZXMuCj4+IGh0
dHBzOi8vZ2l0aHViLmNvbS9MaW5hcm8vbGludXgta2VybmVsLXVhZGsvdHJlZS91YWNjZS1kZXZl
bC01LjE2Cj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9MaW5hcm8vcWVtdS90cmVlL3Y2LjEuMC1ybXIt
djItbmVzdGVkX3NtbXV2M192MTAKPj4KPj4gVGhvdWdoIHRoZXkgYXJlIHByb3ZpZGVkIGZvciB0
ZXN0IHB1cnBvc2UsCj4+Cj4+IFRlc3RlZC1ieTogWmhhbmdmZWkgR2FvIDx6aGFuZ2ZlaS5nYW9A
bGluYXJvLm9yZz4KPiBUaGFuayB5b3UgdmVyeSBtdWNoLiBBcyB5b3UgbWVudGlvbmVkLCB1bnRp
bCB3ZSBkbyBub3QgaGF2ZSB0aGUKPiAvZGV2L2lvbW11IGludGVncmF0aW9uIHRoaXMgaXMgbWFp
bnRhaW5lZCBmb3IgdGVzdGluZyBwdXJwb3NlLiBUaGUgU01NVQo+IGNoYW5nZXMgc2hvdWxkbid0
IGJlIG11Y2ggaW1wYWN0ZWQgdGhvdWdoLgo+IFRoZSBhZGRlZCB2YWx1ZSBvZiB0aGlzIHJlc3Bp
biB3YXMgdG8gcHJvcG9zZSBhbiBNU0kgYmluZGluZyBzb2x1dGlvbgo+IGJhc2VkIG9uIFJNUlJz
IHdoaWNoIHNpbXBsaWZ5IHRoaW5ncyBhdCBrZXJuZWwgbGV2ZWwuCgpDdXJyZW50IFJNUlIgc29s
dXRpb24gcmVxdWlyZXMgdWVmaSBlbmFibGVkLAphbmQgUUVNVV9FRkkuZmTCoCBoYXMgdG8gYmUg
cHJvdmlkZWQgdG8gc3RhcnQgcWVtdS4KCkFueSBwbGFuIHRvIHN1cHBvcnQgZHRiIGFzIHdlbGws
IHdoaWNoIHdpbGwgYmUgc2ltcGxlciBzaW5jZSBubyBuZWVkIApRRU1VX0VGSS5mZCBhbnltb3Jl
LgoKVGhhbmtzCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
