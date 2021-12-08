Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA4DC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 07:33:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 778554B0EF;
	Wed,  8 Dec 2021 02:33:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z+153ZgBmVFb; Wed,  8 Dec 2021 02:33:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73FD44B11A;
	Wed,  8 Dec 2021 02:33:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FAFC4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 02:33:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DptkUgih6Er8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 02:33:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65C4F407F1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 02:33:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638948822;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VaQgBFKDWPtyW4rX+GpfnPjaazD4SfZz/ToOHd0Wuzc=;
 b=buSsHXPc8pO1+bpD8kMOfnqkFMGVVD5yL4FTm+hW8Uv1FxHDFtY38fgsDHJCMeeJESBlwk
 HSeUjK0e8BXQqMKO6VXoaYS3KHpFc7Fx7CE68JRr+YUpgmQ5z51g64hZM/tNCGBDVPHPCC
 LP9mQgqDoZ1/Rw1Z4Q5gIuzXtie7aNs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-51-BYNAI6P2O26QGTmgRXdIxA-1; Wed, 08 Dec 2021 02:33:37 -0500
X-MC-Unique: BYNAI6P2O26QGTmgRXdIxA-1
Received: by mail-wr1-f72.google.com with SMTP id
 d18-20020adfe852000000b001985d36817cso163282wrn.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 23:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=VaQgBFKDWPtyW4rX+GpfnPjaazD4SfZz/ToOHd0Wuzc=;
 b=sORGWupAClrjg7Nyah5RYFpBli6J6d7ck6dCMGrZmfNblWsgi8knESS8PHXWpZw76m
 G5cFOzCUSosPIblk02Ke1qq9XlY8wOxcfI5j7VBdfnif3VS/VYdgtvB8W93K0RRTnL+E
 mGPA1qhoY6aiP4/UuSV/iO87hE72AUc0YS2yp87WeeV6CwBge6DNRN+E//O36tVkbUtc
 XBIQbNJix2gXV0tHqTY22TNQiuaecd5Fx6CpxA/yV3U8vrSTuGNRjPJ6lru7MNJJpkOb
 Hqito6kQXctuz2MzkVOnz9BVrpi3Doplsinw8JsCpC3g5WT3ATVfcFmYr1gJJJ2bYkbF
 8lkA==
X-Gm-Message-State: AOAM530w9se4LRkQ+4t8KfobPpN+1UK/8IDpqVK9IXjURHfYfIvUrDe5
 29R+g51+O5IS3qT3vNltR4wQJoa4AvL5gOdJQ+nICgLrtpLzAMVjSCb6sXTPoACCg+yhXkyKU+p
 eY6FhDf/F6oxiE43j4B8tjAT3
X-Received: by 2002:adf:f708:: with SMTP id r8mr57333483wrp.198.1638948816657; 
 Tue, 07 Dec 2021 23:33:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7KoV5p8PVF3If5VE3e/tXMfPoPdiN58LX+mhb+Qk/apSQFS8E5N4maEwm2dxUTEGR+YL9hQ==
X-Received: by 2002:adf:f708:: with SMTP id r8mr57333432wrp.198.1638948816394; 
 Tue, 07 Dec 2021 23:33:36 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l3sm2033529wmq.46.2021.12.07.23.33.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Dec 2021 23:33:35 -0800 (PST)
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
Date: Wed, 8 Dec 2021 08:33:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kevin.tian@intel.com, lushenming@huawei.com, ashok.raj@intel.com,
 kvm@vger.kernel.org, jean-philippe@linaro.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
 vsethi@nvidia.com, vivek.gautam@arm.com, alex.williamson@redhat.com,
 Jason Gunthorpe <jgg@nvidia.com>, wangxingang5@huawei.com,
 zhangfei.gao@linaro.org, robin.murphy@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgQmFvbHUsCgpPbiAxMi84LzIxIDM6NDQgQU0sIEx1IEJhb2x1IHdyb3RlOgo+IEhpIEVyaWMs
Cj4KPiBPbiAxMi83LzIxIDY6MjIgUE0sIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IE9uIDEyLzYvMjEg
MTE6NDggQU0sIEpvZXJnIFJvZWRlbCB3cm90ZToKPj4+IE9uIFdlZCwgT2N0IDI3LCAyMDIxIGF0
IDEyOjQ0OjIwUE0gKzAyMDAsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+Pj4gU2lnbmVkLW9mZi1ieTog
SmVhbi1QaGlsaXBwZSBCcnVja2VyPGplYW4tcGhpbGlwcGUuYnJ1Y2tlckBhcm0uY29tPgo+Pj4+
IFNpZ25lZC1vZmYtYnk6IExpdSwgWWkgTDx5aS5sLmxpdUBsaW51eC5pbnRlbC5jb20+Cj4+Pj4g
U2lnbmVkLW9mZi1ieTogQXNob2sgUmFqPGFzaG9rLnJhakBpbnRlbC5jb20+Cj4+Pj4gU2lnbmVk
LW9mZi1ieTogSmFjb2IgUGFuPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPgo+Pj4+IFNp
Z25lZC1vZmYtYnk6IEVyaWMgQXVnZXI8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pj4gVGhpcyBT
aWduZWQtb2YtYnkgY2hhaW4gbG9va3MgZHViaW91cywgeW91IGFyZSB0aGUgYXV0aG9yIGJ1dCB0
aGUgbGFzdAo+Pj4gb25lIGluIHRoZSBjaGFpbj8KPj4gVGhlIDFzdCBSRkMgaW4gQXVnIDIwMTgK
Pj4gKGh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L3BpcGVybWFpbC9rdm1hcm0vMjAxOC1B
dWd1c3QvMDMyNDc4Lmh0bWwpCj4+IHNhaWQgdGhpcyB3YXMgYSBnZW5lcmFsaXphdGlvbiBvZiBK
YWNvYidzIHBhdGNoCj4+Cj4+Cj4+IMKgwqAgW1BBVENIIHY1IDAxLzIzXSBpb21tdTogaW50cm9k
dWNlIGJpbmRfcGFzaWRfdGFibGUgQVBJIGZ1bmN0aW9uCj4+Cj4+Cj4+IMKgwqAKPj4gaHR0cHM6
Ly9saXN0cy5saW51eGZvdW5kYXRpb24ub3JnL3BpcGVybWFpbC9pb21tdS8yMDE4LU1heS8wMjc2
NDcuaHRtbAo+Pgo+PiBTbyBpbmRlZWQgSmFjb2Igc2hvdWxkIGJlIHRoZSBhdXRob3IuIEkgZ3Vl
c3MgdGhlIG11bHRpcGxlIHJlYmFzZXMgZ290Cj4+IHRoaXMgZXZlbnR1YWxseSByZXBsYWNlZCBh
dCBzb21lIHBvaW50LCB3aGljaCBpcyBub3QgYW4gZXhjdXNlLiBQbGVhc2UKPj4gZm9yZ2l2ZSBt
ZSBmb3IgdGhhdC4KPj4gTm93IHRoZSBvcmlnaW5hbCBwYXRjaCBhbHJlYWR5IGhhZCB0aGlzIGxp
c3Qgb2YgU29CIHNvIEkgZG9uJ3Qga25vdyBpZiBJCj4+IHNoYWxsIHNpbXBsaWZ5IGl0Lgo+Cj4g
QXMgd2UgaGF2ZSBkZWNpZGVkIHRvIG1vdmUgdGhlIG5lc3RlZCBtb2RlIChkdWFsIHN0YWdlcykg
aW1wbGVtZW50YXRpb24KPiBvbnRvIHRoZSBkZXZlbG9waW5nIGlvbW11ZmQgZnJhbWV3b3JrLCB3
aGF0J3MgdGhlIHZhbHVlIG9mIGFkZGluZyB0aGlzCj4gaW50byBpb21tdSBjb3JlPwoKVGhlIGlv
bW11X3VhcGlfYXR0YWNoX3Bhc2lkX3RhYmxlIHVhcGkgc2hvdWxkIGRpc2FwcGVhciBpbmRlZWQg
YXMgaXQgaXMKaXMgYm91bmQgdG8gYmUgcmVwbGFjZWQgYnkgL2Rldi9pb21tdSBmZWxsb3cgQVBJ
LgpIb3dldmVyIHVudGlsIEkgY2FuIHJlYmFzZSBvbiAvZGV2L2lvbW11IGNvZGUgSSBhbSBvYmxp
Z2VkIHRvIGtlZXAgaXQgdG8KbWFpbnRhaW4gdGhpcyBpbnRlZ3JhdGlvbiwgaGVuY2UgdGhlIFJG
Qy4KClRoYW5rcwoKRXJpYwo+Cj4gQmVzdCByZWdhcmRzLAo+IGJhb2x1Cj4KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
