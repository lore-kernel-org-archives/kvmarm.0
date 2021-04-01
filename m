Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0D8C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 11:49:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68342610CE
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 11:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68342610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D27374B5C0;
	Thu,  1 Apr 2021 07:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xY2xZo1ROZUZ; Thu,  1 Apr 2021 07:49:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F9F4B47C;
	Thu,  1 Apr 2021 07:49:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A421D4B2E6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 07:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UuvXGLft6spx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 07:49:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0897F4A551
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 07:49:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617277741;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iYT4yJTC86HCuhZrmDLNovfzTFC4qveUrUuvrfHdzTQ=;
 b=WRPiETqdP6mq9ralbesnKbWLeEg1Ps32KHgLUePJjNiBx7WaVTH0Hvv1hiFhFBOyA1BuBw
 H9ICcbXxuZQPcToFae+LsJMONbLNLPCkINuLHSyNdJ/1u8b+5ofCdDl0cEWkbby40dr8En
 NIXqes5qjsdOK4tM/Tguof47WTpY5UI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-wLIrvw3yMeqg6KUvwwbuZw-1; Thu, 01 Apr 2021 07:48:58 -0400
X-MC-Unique: wLIrvw3yMeqg6KUvwwbuZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BC36107ACCD;
 Thu,  1 Apr 2021 11:48:55 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B7DC19C46;
 Thu,  1 Apr 2021 11:48:46 +0000 (UTC)
Subject: Re: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than one
 context descriptor
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-14-eric.auger@redhat.com>
 <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <bf928484-b9da-a4bc-b761-e73483cb2323@redhat.com>
Date: Thu, 1 Apr 2021 13:48:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: kvm@vger.kernel.org, vivek.gautam@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com, jean-philippe@linaro.org, yi.l.liu@intel.com,
 wangxingang5@huawei.com, maz@kernel.org, joro@8bytes.org, vsethi@nvidia.com,
 zhangfei.gao@linaro.org, jacob.jun.pan@linux.intel.com, will@kernel.org,
 nicoleotsuka@gmail.com, alex.williamson@redhat.com,
 linux-kernel@vger.kernel.org, lushenming@huawei.com,
 iommu@lists.linux-foundation.org, robin.murphy@arm.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMzAvMjEgMTE6MjMgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDIxLzIvMjQgNDo1NiwgRXJpYyBBdWdlciB3cm90ZToKPj4gSW4gcHJl
cGFyYXRpb24gZm9yIHZTVkEsIGxldCdzIGFjY2VwdCB1c2Vyc3BhY2UgcHJvdmlkZWQgY29uZmln
cwo+PiB3aXRoIG1vcmUgdGhhbiBvbmUgQ0QuIFdlIGNoZWNrIHRoZSBtYXggQ0QgYWdhaW5zdCB0
aGUgaG9zdCBpb21tdQo+PiBjYXBhYmlsaXR5IGFuZCBhbHNvIHRoZSBmb3JtYXQgKGxpbmVhciB2
ZXJzdXMgMiBsZXZlbCkuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogU2hhbWVlciBLb2xvdGh1bSA8c2hhbWVl
cmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPgo+PiAtLS0KPj4gwqAgZHJpdmVycy9pb21t
dS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYyB8IDEzICsrKysrKysrLS0tLS0KPj4gwqAg
MSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPj4KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMKPj4g
Yi9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+IGluZGV4IDMz
MmQzMWMwNjgwZi4uYWI3NGEwMjg5ODkzIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL2lvbW11L2Fy
bS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4+ICsrKyBiL2RyaXZlcnMvaW9tbXUvYXJtL2Fy
bS1zbW11LXYzL2FybS1zbW11LXYzLmMKPj4gQEAgLTMwMzgsMTQgKzMwMzgsMTcgQEAgc3RhdGlj
IGludCBhcm1fc21tdV9hdHRhY2hfcGFzaWRfdGFibGUoc3RydWN0Cj4+IGlvbW11X2RvbWFpbiAq
ZG9tYWluLAo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHNtbXVfZG9tYWluLT5zMV9jZmcuc2V0
KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4gwqAgLcKgwqDCoMKg
wqDCoMKgIC8qCj4+IC3CoMKgwqDCoMKgwqDCoMKgICogd2UgY3VycmVudGx5IHN1cHBvcnQgYSBz
aW5nbGUgQ0Qgc28gczFmbXQgYW5kIHMxZHNzCj4+IC3CoMKgwqDCoMKgwqDCoMKgICogZmllbGRz
IGFyZSBhbHNvIGlnbm9yZWQKPj4gLcKgwqDCoMKgwqDCoMKgwqAgKi8KPj4gLcKgwqDCoMKgwqDC
oMKgIGlmIChjZmctPnBhc2lkX2JpdHMpCj4+ICvCoMKgwqDCoMKgwqDCoCBsaXN0X2Zvcl9lYWNo
X2VudHJ5KG1hc3RlciwgJnNtbXVfZG9tYWluLT5kZXZpY2VzLAo+PiBkb21haW5faGVhZCkgewo+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoY2ZnLT5wYXNpZF9iaXRzID4gbWFzdGVyLT5z
c2lkX2JpdHMpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+
ICvCoMKgwqDCoMKgwqDCoCB9Cj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoY2ZnLT52ZW5kb3JfZGF0
YS5zbW11djMuczFmbXQgPT0KPj4gU1RSVEFCX1NURV8wX1MxRk1UXzY0S19MMiAmJgo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICEoc21tdS0+ZmVhdHVyZXMgJiBBUk1fU01NVV9G
RUFUXzJfTFZMX0NEVEFCKSkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7
Cj4+IMKgIMKgwqDCoMKgwqDCoMKgwqDCoCBzbW11X2RvbWFpbi0+czFfY2ZnLmNkY2ZnLmNkdGFi
X2RtYSA9IGNmZy0+YmFzZV9wdHI7Cj4+ICvCoMKgwqDCoMKgwqDCoCBzbW11X2RvbWFpbi0+czFf
Y2ZnLnMxY2RtYXggPSBjZmctPnBhc2lkX2JpdHM7Cj4+ICvCoMKgwqDCoMKgwqDCoCBzbW11X2Rv
bWFpbi0+czFfY2ZnLnMxZm10ID0gY2ZnLT52ZW5kb3JfZGF0YS5zbW11djMuczFmbXQ7Cj4gCj4g
QW5kIHdoYXQgYWJvdXQgdGhlIFNJRFNTIGZpZWxkPwo+IApJIGFkZGVkIHRoaXMgcGF0Y2ggdXBv
biBTaGFtZWVyJ3MgcmVxdWVzdCwgdG8gYmUgbW9yZSB2U1ZBIGZyaWVuZGx5LgpIb3dlciB0aGlz
IHNlcmllcyBkb2VzIG5vdCByZWFsbHkgdGFyZ2V0IG11bHRpcGxlIENEIHN1cHBvcnQuIEF0IHRo
ZQptb21lbnQgdGhlIGRyaXZlciBvbmx5IHN1cHBvcnRzIFNUUlRBQl9TVEVfMV9TMURTU19TU0lE
MCAoMHgyKSBJIHRoaW5rLgpBdCB0aGlzIG1vbWVudCBtYXliZSBJIGNhbiBvbmx5IGNoZWNrIHRo
ZSBzMWRzcyBmaWVsZCBpcyAweDIuIE9yIHNpbXBseQpyZW1vdmVzIHRoaXMgcGF0Y2g/CgpUaG91
Z2h0cz8KCkVyaWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
