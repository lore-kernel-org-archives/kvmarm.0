Return-Path: <SRS0=p5Xi=DA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE38AC4727E
	for <kvmarm@archiver.kernel.org>; Wed, 23 Sep 2020 11:47:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10CA2214D8
	for <kvmarm@archiver.kernel.org>; Wed, 23 Sep 2020 11:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hRWmXgy1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10CA2214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54D9E4B32B;
	Wed, 23 Sep 2020 07:47:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E5pM3MF4XbZp; Wed, 23 Sep 2020 07:47:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3557E4B28C;
	Wed, 23 Sep 2020 07:47:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2C574B27D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2020 07:47:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMMcGk7El9TO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Sep 2020 07:47:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0DCD4B27A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2020 07:47:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600861662;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YPqJZ9kUOXWQkU3z5eMOLx9N/KiGW7Zqy3WW9MTewTg=;
 b=hRWmXgy1qXDSay587415XvOppoI4wblwozXp4r0hH9nbLIxUGGqlsDpqJ9MygR4BrSeXbZ
 ggAtPJUPjIzLOnKufuK9/8iCkbNBeWWtpLKiUNCrgX8hx3PFBHlgP0pRYogN8rqg37f9zR
 KTyfzvSfkK/0P+SqAImQrPxgiGh0FW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-iQP_rk0SPY-sEjGh61uLIQ-1; Wed, 23 Sep 2020 07:47:40 -0400
X-MC-Unique: iQP_rk0SPY-sEjGh61uLIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0A0F1868425;
 Wed, 23 Sep 2020 11:47:37 +0000 (UTC)
Received: from [10.36.112.29] (ovpn-112-29.ams2.redhat.com [10.36.112.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 415F619C4F;
 Wed, 23 Sep 2020 11:47:22 +0000 (UTC)
Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, robin.murphy@arm.com
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
 <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
Date: Wed, 23 Sep 2020 13:47:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

SGkgWmVuZ2h1aSwKCk9uIDkvMjMvMjAgMToyNyBQTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIwMjAvMy8yMSAwOjE5LCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBGcm9tOiAi
TGl1LCBZaSBMIiA8eWkubC5saXVAbGludXguaW50ZWwuY29tPgo+Pgo+PiBUaGlzIHBhdGNoIGFk
ZHMgYW4gVkZJT19JT01NVV9TRVRfUEFTSURfVEFCTEUgaW9jdGwKPj4gd2hpY2ggYWltcyB0byBw
YXNzIHRoZSB2aXJ0dWFsIGlvbW11IGd1ZXN0IGNvbmZpZ3VyYXRpb24KPj4gdG8gdGhlIGhvc3Qu
IFRoaXMgbGF0dGVyIHRha2VzIHRoZSBmb3JtIG9mIHRoZSBzby1jYWxsZWQKPj4gUEFTSUQgdGFi
bGUuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5p
bnRlbC5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IExpdSwgWWkgTCA8eWkubC5saXVAbGludXguaW50
ZWwuY29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5j
b20+Cj4gCj4gWy4uLl0KPiAKPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11
X3R5cGUxLmMKPj4gYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jCj4+IGluZGV4IGEx
NzdiZjJjNjY4My4uYmZhY2JkODc2ZWUxIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZp
b19pb21tdV90eXBlMS5jCj4+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMK
Pj4gQEAgLTIxNzIsNiArMjE3Miw0MyBAQCBzdGF0aWMgaW50IHZmaW9faW9tbXVfaW92YV9idWls
ZF9jYXBzKHN0cnVjdAo+PiB2ZmlvX2lvbW11ICppb21tdSwKPj4gwqDCoMKgwqDCoCByZXR1cm4g
cmV0Owo+PiDCoCB9Cj4+IMKgICtzdGF0aWMgdm9pZAo+PiArdmZpb19kZXRhY2hfcGFzaWRfdGFi
bGUoc3RydWN0IHZmaW9faW9tbXUgKmlvbW11KQo+PiArewo+PiArwqDCoMKgIHN0cnVjdCB2Zmlv
X2RvbWFpbiAqZDsKPj4gKwo+PiArwqDCoMKgIG11dGV4X2xvY2soJmlvbW11LT5sb2NrKTsKPj4g
Kwo+PiArwqDCoMKgIGxpc3RfZm9yX2VhY2hfZW50cnkoZCwgJmlvbW11LT5kb21haW5fbGlzdCwg
bmV4dCkgewo+PiArwqDCoMKgwqDCoMKgwqAgaW9tbXVfZGV0YWNoX3Bhc2lkX3RhYmxlKGQtPmRv
bWFpbik7Cj4+ICvCoMKgwqAgfQo+PiArwqDCoMKgIG11dGV4X3VubG9jaygmaW9tbXUtPmxvY2sp
Owo+PiArfQo+PiArCj4+ICtzdGF0aWMgaW50Cj4+ICt2ZmlvX2F0dGFjaF9wYXNpZF90YWJsZShz
dHJ1Y3QgdmZpb19pb21tdSAqaW9tbXUsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCB2ZmlvX2lvbW11X3R5cGUxX3NldF9wYXNpZF90YWJsZSAqdXN0cnVjdCkKPj4gK3sKPj4gK8Kg
wqDCoCBzdHJ1Y3QgdmZpb19kb21haW4gKmQ7Cj4+ICvCoMKgwqAgaW50IHJldCA9IDA7Cj4+ICsK
Pj4gK8KgwqDCoCBtdXRleF9sb2NrKCZpb21tdS0+bG9jayk7Cj4+ICsKPj4gK8KgwqDCoCBsaXN0
X2Zvcl9lYWNoX2VudHJ5KGQsICZpb21tdS0+ZG9tYWluX2xpc3QsIG5leHQpIHsKPj4gK8KgwqDC
oMKgwqDCoMKgIHJldCA9IGlvbW11X2F0dGFjaF9wYXNpZF90YWJsZShkLT5kb21haW4sICZ1c3Ry
dWN0LT5jb25maWcpOwo+PiArwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkKPj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZ290byB1bndpbmQ7Cj4+ICvCoMKgwqAgfQo+PiArwqDCoMKgIGdvdG8gdW5s
b2NrOwo+PiArdW53aW5kOgo+PiArwqDCoMKgIGxpc3RfZm9yX2VhY2hfZW50cnlfY29udGludWVf
cmV2ZXJzZShkLCAmaW9tbXUtPmRvbWFpbl9saXN0LCBuZXh0KSB7Cj4+ICvCoMKgwqDCoMKgwqDC
oCBpb21tdV9kZXRhY2hfcGFzaWRfdGFibGUoZC0+ZG9tYWluKTsKPj4gK8KgwqDCoCB9Cj4+ICt1
bmxvY2s6Cj4+ICvCoMKgwqAgbXV0ZXhfdW5sb2NrKCZpb21tdS0+bG9jayk7Cj4+ICvCoMKgwqAg
cmV0dXJuIHJldDsKPj4gK30KPj4gKwo+PiDCoCBzdGF0aWMgbG9uZyB2ZmlvX2lvbW11X3R5cGUx
X2lvY3RsKHZvaWQgKmlvbW11X2RhdGEsCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpCj4+IMKgIHsK
Pj4gQEAgLTIyNzYsNiArMjMxMywyNSBAQCBzdGF0aWMgbG9uZyB2ZmlvX2lvbW11X3R5cGUxX2lv
Y3RsKHZvaWQKPj4gKmlvbW11X2RhdGEsCj4+IMKgIMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
Y29weV90b191c2VyKCh2b2lkIF9fdXNlciAqKWFyZywgJnVubWFwLCBtaW5zeikgPwo+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtRUZBVUxUIDogMDsKPj4gK8KgwqDCoCB9IGVsc2UgaWYg
KGNtZCA9PSBWRklPX0lPTU1VX1NFVF9QQVNJRF9UQUJMRSkgewo+PiArwqDCoMKgwqDCoMKgwqAg
c3RydWN0IHZmaW9faW9tbXVfdHlwZTFfc2V0X3Bhc2lkX3RhYmxlIHVzdHJ1Y3Q7Cj4+ICsKPj4g
K8KgwqDCoMKgwqDCoMKgIG1pbnN6ID0gb2Zmc2V0b2ZlbmQoc3RydWN0IHZmaW9faW9tbXVfdHlw
ZTFfc2V0X3Bhc2lkX3RhYmxlLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgY29uZmlnKTsKPj4gKwo+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGNvcHlfZnJvbV91c2Vy
KCZ1c3RydWN0LCAodm9pZCBfX3VzZXIgKilhcmcsIG1pbnN6KSkKPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIC1FRkFVTFQ7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmICh1c3Ry
dWN0LmFyZ3N6IDwgbWluc3opCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlO
VkFMOwo+PiArCj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAodXN0cnVjdC5mbGFncyAmIFZGSU9fUEFT
SURfVEFCTEVfRkxBR19TRVQpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiB2Zmlv
X2F0dGFjaF9wYXNpZF90YWJsZShpb21tdSwgJnVzdHJ1Y3QpOwo+PiArwqDCoMKgwqDCoMKgwqAg
ZWxzZSBpZiAodXN0cnVjdC5mbGFncyAmIFZGSU9fUEFTSURfVEFCTEVfRkxBR19VTlNFVCkgewo+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2ZmlvX2RldGFjaF9wYXNpZF90YWJsZShpb21tdSk7
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAwOwo+PiArwqDCoMKgwqDCoMKgwqAg
fSBlbHNlCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+IAo+IE5p
dDoKPiAKPiBXaGF0IGlmIHVzZXItc3BhY2UgYmxpbmRseSBzZXQgYm90aCBmbGFncz8gU2hvdWxk
IHdlIGNoZWNrIHRoYXQgb25seSBvbmUKPiBmbGFnIGlzIGFsbG93ZWQgdG8gYmUgc2V0IGF0IHRo
aXMgc3RhZ2UsIGFuZCByZXR1cm4gZXJyb3Igb3RoZXJ3aXNlPwpJbmRlZWQgSSBjYW4gY2hlY2sg
dGhhdC4KPiAKPiBCZXNpZGVzLCBiZWZvcmUgZ29pbmcgdGhyb3VnaCB0aGUgd2hvbGUgc2VyaWVz
IFsxXVsyXSwgSSdkIGxpa2UgdG8ga25vdwo+IGlmIHRoaXMgaXMgdGhlIGxhdGVzdCB2ZXJzaW9u
IG9mIHlvdXIgTmVzdGVkLVN0YWdlLVNldHVwIHdvcmsgaW4gY2FzZSBJCj4gaGFkIG1pc3NlZCBz
b21ldGhpbmcuCj4gCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMDAzMjAxNjE5
MTEuMjc0OTQtMS1lcmljLmF1Z2VyQHJlZGhhdC5jb20KPiBbMl0gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvci8yMDIwMDQxNDE1MDYwNy4yODQ4OC0xLWVyaWMuYXVnZXJAcmVkaGF0LmNvbQoKeWVz
IHRob3NlIDIgc2VyaWVzIGFyZSB0aGUgbGFzdCBvbmVzLiBUaGFuayB5b3UgZm9yIHJldmlld2lu
Zy4KCkZZSSwgSSBpbnRlbmQgdG8gcmVzcGluIHdpdGhpbiBhIHdlZWsgb3IgMiBvbiB0b3Agb2Yg
SmFjb2IncyAgW1BBVENIIHYxMAowLzddIElPTU1VIHVzZXIgQVBJIGVuaGFuY2VtZW50LiBCdXQg
ZnVuY3Rpb25hbGx5IHRoZXJlIHdvbid0IGEgbG90IG9mCmNoYW5nZXMuCgpUaGFua3MKCkVyaWMK
PiAKPiAKPiBUaGFua3MsCj4gWmVuZ2h1aQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
