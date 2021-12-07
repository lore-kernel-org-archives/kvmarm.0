Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF093C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 10:27:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DC640667;
	Tue,  7 Dec 2021 05:27:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 77boIs8He-k4; Tue,  7 Dec 2021 05:27:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B4A49F5F;
	Tue,  7 Dec 2021 05:27:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3917849F5F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:27:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yibsmfDp4-70 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 05:27:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09F0240667
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 05:27:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638872870;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WuGNH/dyVygpiGOJkCWGmo3DKhkMVbJWC9pFgiPTsyo=;
 b=D0iZdz0y1cfknqbh9GRULsU7V9SHmLbBvwHqPiuKgXunx/F6/1m3BIldJ8J7zq1vV5i1Bo
 k5LZ7nW07hTvE1SCM15OHlHrrn78rOlGiVABKdo+V0p7AphTvrXMzrXpDiGxo3waUJkWzr
 ZohXaX/0kM+xaBoO40lF/WWzk4YomZo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-_kOML7uePhqovr-PuqIH7Q-1; Tue, 07 Dec 2021 05:27:46 -0500
X-MC-Unique: _kOML7uePhqovr-PuqIH7Q-1
Received: by mail-wr1-f72.google.com with SMTP id
 k8-20020a5d5248000000b001763e7c9ce5so2775515wrc.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 02:27:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=WuGNH/dyVygpiGOJkCWGmo3DKhkMVbJWC9pFgiPTsyo=;
 b=YaEdU+1dt5q8KsEdQmVUW61SrNKr3Wni3DI2ZRQh0kaYOzmLYRjRd6UFOYopgwegqm
 OKZfbR1RoeYLL9aLVGfe5FjOrinSx0n/wEGy4k/kC3y+Nsb6zvI2J6sH7UkeSDHrhHe/
 /woyNwdKfA5cQhpNyNRZzDb8+4n/oV//hWwkEfOO8vrPUIouD+240kYaA3Occo+qvIAn
 Gzw3wSPQQiAUauaZrEZ2jdCK/kNRAiecD/7QrWNgi4Ni+BJrZCXPMjirNR2D+RnbPqcU
 pKAMdKrTeh7Xze1brACkZXLyXvMb7dJtPPrBx2kVjRogvZnIR0MCLbxRYem2BjAu4k7l
 4sOA==
X-Gm-Message-State: AOAM533V7+XSgYTBfORmIFhzrQks9TDAqQSWoXilt60JiZpNUo7TtroW
 n8CX+RAfWaOqDR0DLM+J3m3Cc2z1098PHkPF8gmKZyUyi+TsoHvmQFwsbs/MOsFs4p28pysYvpf
 va9rMH96jNOY7vVdsAv38/tGN
X-Received: by 2002:adf:d22a:: with SMTP id k10mr51871524wrh.80.1638872865076; 
 Tue, 07 Dec 2021 02:27:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5SYKxnf/czGLnzekcByHTylqSUw2oDFUY77k108vZsKZFOCs+7tv9nPFdqCwIsIDIRwPszg==
X-Received: by 2002:adf:d22a:: with SMTP id k10mr51871467wrh.80.1638872864803; 
 Tue, 07 Dec 2021 02:27:44 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d15sm18622235wri.50.2021.12.07.02.27.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Dec 2021 02:27:43 -0800 (PST)
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To: Zhangfei Gao <zhangfei.gao@linaro.org>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <ee119b42-92b1-5744-4321-6356bafb498f@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <7763531a-625d-10c6-c35e-2ce41e75f606@redhat.com>
Date: Tue, 7 Dec 2021 11:27:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ee119b42-92b1-5744-4321-6356bafb498f@linaro.org>
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

SGkgWmhhbmdmZWksCgpPbiAxMi8zLzIxIDE6MjcgUE0sIFpoYW5nZmVpIEdhbyB3cm90ZToKPgo+
IEhpLCBFcmljCj4KPiBPbiAyMDIxLzEwLzI3IOS4i+WNiDY6NDQsIEVyaWMgQXVnZXIgd3JvdGU6
Cj4+IFRoaXMgc2VyaWVzIGJyaW5ncyB0aGUgSU9NTVUgcGFydCBvZiBIVyBuZXN0ZWQgcGFnaW5n
IHN1cHBvcnQKPj4gaW4gdGhlIFNNTVV2My4KPj4KPj4gVGhlIFNNTVV2MyBkcml2ZXIgaXMgYWRh
cHRlZCB0byBzdXBwb3J0IDIgbmVzdGVkIHN0YWdlcy4KPj4KPj4gVGhlIElPTU1VIEFQSSBpcyBl
eHRlbmRlZCB0byBjb252ZXkgdGhlIGd1ZXN0IHN0YWdlIDEKPj4gY29uZmlndXJhdGlvbiBhbmQg
dGhlIGhvb2sgaXMgaW1wbGVtZW50ZWQgaW4gdGhlIFNNTVV2MyBkcml2ZXIuCj4+Cj4+IFRoaXMg
YWxsb3dzIHRoZSBndWVzdCB0byBvd24gdGhlIHN0YWdlIDEgdGFibGVzIGFuZCBjb250ZXh0Cj4+
IGRlc2NyaXB0b3JzIChzby1jYWxsZWQgUEFTSUQgdGFibGUpIHdoaWxlIHRoZSBob3N0IG93bnMg
dGhlCj4+IHN0YWdlIDIgdGFibGVzIGFuZCBtYWluIGNvbmZpZ3VyYXRpb24gc3RydWN0dXJlcyAo
U1RFKS4KPj4KPj4gVGhpcyB3b3JrIG1haW5seSBpcyBwcm92aWRlZCBmb3IgdGVzdCBwdXJwb3Nl
IGFzIHRoZSB1cHBlcgo+PiBsYXllciBpbnRlZ3JhdGlvbiBpcyB1bmRlciByZXdvcmsgYW5kIGJv
dW5kIHRvIGJlIGJhc2VkIG9uCj4+IC9kZXYvaW9tbXUgaW5zdGVhZCBvZiBWRklPIHR1bm5lbGlu
Zy4gSW4gdGhpcyB2ZXJzaW9uIHdlIGFsc28gZ2V0Cj4+IHJpZCBvZiB0aGUgTVNJIEJJTkRJTkcg
aW9jdGwsIGFzc3VtaW5nIHRoZSBndWVzdCBlbmZvcmNlcwo+PiBmbGF0IG1hcHBpbmcgb2YgaG9z
dCBJT1ZBcyB1c2VkIHRvIGJpbmQgcGh5c2ljYWwgTVNJIGRvb3JiZWxscy4KPj4gSW4gdGhlIGN1
cnJlbnQgUUVNVSBpbnRlZ3JhdGlvbiB0aGlzIGlzIGFjaGlldmVkIGJ5IGV4cG9zaW5nCj4+IFJN
UnMgdG8gdGhlIGd1ZXN0LCB1c2luZyBTaGFtZWVyJ3Mgc2VyaWVzIFsxXS4gVGhpcyBhcHByb2Fj
aAo+PiBpcyBSRkMgYXMgdGhlIElPUlQgc3BlYyBpcyBub3QgcmVhbGx5IG1lYW50IHRvIGRvIHRo
YXQKPj4gKHNpbmdsZSBtYXBwaW5nIGZsYWcgbGltaXRhdGlvbikuCj4+Cj4+IEJlc3QgUmVnYXJk
cwo+Pgo+PiBFcmljCj4+Cj4+IFRoaXMgc2VyaWVzIChIb3N0KSBjYW4gYmUgZm91bmQgYXQ6Cj4+
IGh0dHBzOi8vZ2l0aHViLmNvbS9lYXVnZXIvbGludXgvdHJlZS92NS4xNS1yYzctbmVzdGVkLXYx
Ngo+PiBUaGlzIGluY2x1ZGVzIGEgcmViYXNlZCBWRklPIGludGVncmF0aW9uIChhbHRob3VnaCBu
b3QgbWVhbnQKPj4gdG8gYmUgdXBzdHJlYW1lZCkKPj4KPj4gR3Vlc3Qga2VybmVsIGJyYW5jaCBj
YW4gYmUgZm91bmQgYXQ6Cj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9lYXVnZXIvbGludXgvdHJlZS9z
aGFtZWVyX3JtcnJfdjcKPj4gZmVhdHVyaW5nIFsxXQo+Pgo+PiBRRU1VIGludGVncmF0aW9uIChz
dGlsbCBiYXNlZCBvbiBWRklPIGFuZCBleHBvc2luZyBSTVJzKQo+PiBjYW4gYmUgZm91bmQgYXQ6
Cj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9lYXVnZXIvcWVtdS90cmVlL3Y2LjEuMC1ybXItdjItbmVz
dGVkX3NtbXV2M192MTAKPj4gKHVzZSBpb21tdT1uZXN0ZWQtc21tdXYzIEFSTSB2aXJ0IG9wdGlv
bikKPj4KPj4gR3Vlc3QgZGVwZW5kZW5jeToKPj4gWzFdIFtQQVRDSCB2NyAwLzldIEFDUEkvSU9S
VDogU3VwcG9ydCBmb3IgSU9SVCBSTVIgbm9kZQo+Cj4gVGhhbmtzIGEgbG90IGZvciB1cGdyYWRp
bmcgdGhlc2UgcGF0Y2hlcy4KPgo+IEkgaGF2ZSBiYXNpY2FsbHkgdmVyaWZpZWQgdGhlc2UgcGF0
Y2hlcyBvbiBIaVNpbGljb24gS3VucGVuZzkyMC4KPiBBbmQgaW50ZWdyYXRlZCB0aGVtIHRvIHRo
ZXNlIGJyYW5jaGVzLgo+IGh0dHBzOi8vZ2l0aHViLmNvbS9MaW5hcm8vbGludXgta2VybmVsLXVh
ZGsvdHJlZS91YWNjZS1kZXZlbC01LjE2Cj4gaHR0cHM6Ly9naXRodWIuY29tL0xpbmFyby9xZW11
L3RyZWUvdjYuMS4wLXJtci12Mi1uZXN0ZWRfc21tdXYzX3YxMAo+Cj4gVGhvdWdoIHRoZXkgYXJl
IHByb3ZpZGVkIGZvciB0ZXN0IHB1cnBvc2UsCj4KPiBUZXN0ZWQtYnk6IFpoYW5nZmVpIEdhbyA8
emhhbmdmZWkuZ2FvQGxpbmFyby5vcmc+CgpUaGFuayB5b3UgdmVyeSBtdWNoLiBBcyB5b3UgbWVu
dGlvbmVkLCB1bnRpbCB3ZSBkbyBub3QgaGF2ZSB0aGUKL2Rldi9pb21tdSBpbnRlZ3JhdGlvbiB0
aGlzIGlzIG1haW50YWluZWQgZm9yIHRlc3RpbmcgcHVycG9zZS4gVGhlIFNNTVUKY2hhbmdlcyBz
aG91bGRuJ3QgYmUgbXVjaCBpbXBhY3RlZCB0aG91Z2guClRoZSBhZGRlZCB2YWx1ZSBvZiB0aGlz
IHJlc3BpbiB3YXMgdG8gcHJvcG9zZSBhbiBNU0kgYmluZGluZyBzb2x1dGlvbgpiYXNlZCBvbiBS
TVJScyB3aGljaCBzaW1wbGlmeSB0aGluZ3MgYXQga2VybmVsIGxldmVsLgoKVGhhbmtzIQoKRXJp
Ywo+Cj4gVGhhbmtzCj4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
