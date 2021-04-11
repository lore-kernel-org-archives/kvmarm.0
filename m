Return-Path: <SRS0=aSj2=JI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07D8C433ED
	for <kvmarm@archiver.kernel.org>; Sun, 11 Apr 2021 12:12:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37937611AD
	for <kvmarm@archiver.kernel.org>; Sun, 11 Apr 2021 12:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37937611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FBD4B630;
	Sun, 11 Apr 2021 08:12:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KjVlUI+qYBBq; Sun, 11 Apr 2021 08:12:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D7334B8F2;
	Sun, 11 Apr 2021 08:12:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA96A4B590
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Apr 2021 08:12:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tdw6jJO9JTV8 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Apr 2021 08:12:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECE314B544
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Apr 2021 08:12:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618143166;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Cd5a7MnBxaCycfDTV6DQTS58oQm03SFk+/qhnkSwHlw=;
 b=CIPfQv4udf2X1b7yCJPTtHGea6TEjO3MF//RveBRyXOaru4hvmf5WjU4VAnB8mAtqDbFNQ
 zx6aBQkb0HPGvlFMdzGuKwZpUwmV3jneD2H5wXTQBdsGXyo52vm/d4vWzTZFbN86X5C19T
 WNfES4J4VLAyDC7hNDB/YQ2oYj6RabU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-r9GIkX2eOQKuVWu8pninBQ-1; Sun, 11 Apr 2021 08:12:42 -0400
X-MC-Unique: r9GIkX2eOQKuVWu8pninBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 141AD10053E6;
 Sun, 11 Apr 2021 12:12:40 +0000 (UTC)
Received: from [10.36.112.22] (ovpn-112-22.ams2.redhat.com [10.36.112.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 362465D6D3;
 Sun, 11 Apr 2021 12:12:29 +0000 (UTC)
Subject: Re: [PATCH v12 01/13] vfio: VFIO_IOMMU_SET_PASID_TABLE
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20210223210625.604517-1-eric.auger@redhat.com>
 <20210223210625.604517-2-eric.auger@redhat.com>
 <d0f254c3-0b63-e4d3-1f58-8940adc7c0bf@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <513f8129-7ddc-f19f-e25a-e2a4b6cbe593@redhat.com>
Date: Sun, 11 Apr 2021 14:12:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d0f254c3-0b63-e4d3-1f58-8940adc7c0bf@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

SGkgWmVuZ2h1aSwKCk9uIDQvNy8yMSAxMTozMyBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIwMjEvMi8yNCA1OjA2LCBFcmljIEF1Z2VyIHdyb3RlOgo+PiArLyoKPj4g
KyAqIFZGSU9fSU9NTVVfU0VUX1BBU0lEX1RBQkxFIC0gX0lPV1IoVkZJT19UWVBFLCBWRklPX0JB
U0UgKyAxOCwKPj4gKyAqwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgdmZpb19pb21tdV90
eXBlMV9zZXRfcGFzaWRfdGFibGUpCj4+ICsgKgo+PiArICogVGhlIFNFVCBvcGVyYXRpb24gcGFz
c2VzIGEgUEFTSUQgdGFibGUgdG8gdGhlIGhvc3Qgd2hpbGUgdGhlCj4+ICsgKiBVTlNFVCBvcGVy
YXRpb24gZGV0YWNoZXMgdGhlIG9uZSBjdXJyZW50bHkgcHJvZ3JhbW1lZC4gU2V0dGluZwo+PiAr
ICogYSB0YWJsZSB3aGlsZSBhbm90aGVyIGlzIGFscmVhZHkgcHJvZ3JhbW1lZCByZXBsYWNlcyB0
aGUgb2xkIHRhYmxlLgo+IAo+IEl0IGxvb2tzIHRvIG1lIHRoYXQgdGhpcyBkZXNjcmlwdGlvbiBk
b2Vzbid0IG1hdGNoIHRoZSBJT01NVSBwYXJ0LgoKWWVwIHRoYXQncyBtaXNsZWFuZGluZy4KCkkg
cmVwbGFjZWQgaXQgYnk6CgogSXQgaXMgYWxsb3dlZCB0byAiU0VUIiB0aGUgdGFibGUgc2V2ZXJh
bCB0aW1lcyB3aXRob3V0IHVuLXNldHRpbmcgYXMKIGxvbmcgYXMgdGhlIHRhYmxlIGNvbmZpZyBk
b2VzIG5vdCBzdGF5IElPTU1VX1BBU0lEX0NPTkZJR19UUkFOU0xBVEUuCgo+IAo+IFt2MTQsMDUv
MTNdIGlvbW11L3NtbXV2MzogSW1wbGVtZW50IGF0dGFjaC9kZXRhY2hfcGFzaWRfdGFibGUKPiAK
PiB8wqDCoMKgIGNhc2UgSU9NTVVfUEFTSURfQ09ORklHX1RSQU5TTEFURToKPiB8wqDCoMKgwqDC
oMKgwqAgLyogd2UgZG8gbm90IHN1cHBvcnQgUzEgPC0+IFMxIHRyYW5zaXRpb25zICovCj4gfMKg
wqDCoMKgwqDCoMKgIGlmIChzbW11X2RvbWFpbi0+czFfY2ZnLnNldCkKPiB8wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBnb3RvIG91dDsKPiAKPiBNYXliZSBJJ3ZlIG1pc3JlYWQgc29tZXRoaW5nPwo+
IAo+IAo+IFRoYW5rcywKPiBaZW5naHVpCj4gCgpUaGFua3MKCkVyaWMKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
