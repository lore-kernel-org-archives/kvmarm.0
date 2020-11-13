Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E1DC61DD8
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 16:12:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E3C1208D5
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 16:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jnq303J2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E3C1208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFAF74BBE3;
	Fri, 13 Nov 2020 11:12:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x3afibsoM1qG; Fri, 13 Nov 2020 11:12:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B355F4BBE1;
	Fri, 13 Nov 2020 11:12:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9ED4BBE1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 11:12:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q0B3oVEELZse for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 11:12:00 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A4C54BBDD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 11:12:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605283920;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MzPV3G2COP33yZAJV3i6S/9jkDAO8h9mjkNYvu/SPwg=;
 b=Jnq303J2Z/RjIfJm1K5QD3lgghrXWIp7O/Oe/5luHx70/eAgJilAv/5owLJoI0C7Zvb5j5
 AScaduk5wl4URvWFRKtRzARCK3K1qaZ8WRkWjC9V1W4Of5pR7rcTSie3azJbFjGTe26Iju
 RekkIWUbeynzXTkBQeC0f59VRyNd9Hc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-vDgneSjqO1Gg21M8dJbxMw-1; Fri, 13 Nov 2020 11:11:58 -0500
X-MC-Unique: vDgneSjqO1Gg21M8dJbxMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58756801FDE;
 Fri, 13 Nov 2020 16:11:56 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8442B46;
 Fri, 13 Nov 2020 16:11:49 +0000 (UTC)
Subject: Re: [PATCH v10 05/11] vfio/pci: Register an iommu fault handler
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, robin.murphy@arm.com
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-6-eric.auger@redhat.com>
 <571978ff-ee8a-6e9f-6755-519d0871646f@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <80befd0f-8876-2cd2-7af0-c5e32e79323b@redhat.com>
Date: Fri, 13 Nov 2020 17:11:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <571978ff-ee8a-6e9f-6755-519d0871646f@huawei.com>
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

SGkgWmVuZ2h1aSwKCk9uIDkvMjQvMjAgMTA6NDkgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDIwLzMvMjEgMDoxOSwgRXJpYyBBdWdlciB3cm90ZToKPj4gUmVnaXN0
ZXIgYW4gSU9NTVUgZmF1bHQgaGFuZGxlciB3aGljaCByZWNvcmRzIGZhdWx0cyBpbgo+PiB0aGUg
RE1BIEZBVUxUIHJlZ2lvbiByaW5nIGJ1ZmZlci4gSW4gYSBzdWJzZXF1ZW50IHBhdGNoLCB3ZQo+
PiB3aWxsIGFkZCB0aGUgc2lnbmFsaW5nIG9mIGEgc3BlY2lmaWMgZXZlbnRmZCB0byBhbGxvdyB0
aGUKPj4gdXNlcnNwYWNlIHRvIGJlIG5vdGlmaWVkIHdoZW5ldmVyIGEgbmV3IGZhdWx0IGFzIHNo
b3duIHVwLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhh
dC5jb20+Cj4gCj4gWy4uLl0KPiAKPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9wY2kvdmZp
b19wY2kuYyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2kuYwo+PiBpbmRleCA1ODZiODlkZWJl
ZDUuLjY5NTk1YzI0MGJhZiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3Bj
aS5jCj4+ICsrKyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2kuYwo+PiBAQCAtMjcsNiArMjcs
NyBAQAo+PiDCoCAjaW5jbHVkZSA8bGludXgvdmZpby5oPgo+PiDCoCAjaW5jbHVkZSA8bGludXgv
dmdhYXJiLmg+Cj4+IMKgICNpbmNsdWRlIDxsaW51eC9ub3NwZWMuaD4KPj4gKyNpbmNsdWRlIDxs
aW51eC9jaXJjX2J1Zi5oPgo+PiDCoCDCoCAjaW5jbHVkZSAidmZpb19wY2lfcHJpdmF0ZS5oIgo+
PiDCoCBAQCAtMjgzLDYgKzI4NCwzOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHZmaW9fcGNpX3Jl
Z29wcwo+PiB2ZmlvX3BjaV9kbWFfZmF1bHRfcmVnb3BzID0gewo+PiDCoMKgwqDCoMKgIC5hZGRf
Y2FwYWJpbGl0eSA9IHZmaW9fcGNpX2RtYV9mYXVsdF9hZGRfY2FwYWJpbGl0eSwKPj4gwqAgfTsK
Pj4gwqAgK2ludCB2ZmlvX3BjaV9pb21tdV9kZXZfZmF1bHRfaGFuZGxlcihzdHJ1Y3QgaW9tbXVf
ZmF1bHQgKmZhdWx0LAo+PiB2b2lkICpkYXRhKQo+PiArewo+PiArwqDCoMKgIHN0cnVjdCB2Zmlv
X3BjaV9kZXZpY2UgKnZkZXYgPSAoc3RydWN0IHZmaW9fcGNpX2RldmljZSAqKWRhdGE7Cj4+ICvC
oMKgwqAgc3RydWN0IHZmaW9fcmVnaW9uX2RtYV9mYXVsdCAqcmVnID0KPj4gK8KgwqDCoMKgwqDC
oMKgIChzdHJ1Y3QgdmZpb19yZWdpb25fZG1hX2ZhdWx0ICopdmRldi0+ZmF1bHRfcGFnZXM7Cj4+
ICvCoMKgwqAgc3RydWN0IGlvbW11X2ZhdWx0ICpuZXcgPQo+PiArwqDCoMKgwqDCoMKgwqAgKHN0
cnVjdCBpb21tdV9mYXVsdCAqKSh2ZGV2LT5mYXVsdF9wYWdlcyArIHJlZy0+b2Zmc2V0ICsKPj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnLT5oZWFkICogcmVnLT5lbnRyeV9zaXplKTsKPiAK
PiBTaG91bGRuJ3QgJ3JlZy0+aGVhZCcgYmUgcHJvdGVjdGVkIHVuZGVyIHRoZSBmYXVsdF9xdWV1
ZV9sb2NrPyBPdGhlcndpc2UKPiB0aGluZ3MgbWF5IGNoYW5nZSBiZWhpbmQgb3VyIGJhY2tzLi4u
Pgo+IFdlIHNob3VsZG4ndCB0YWtlIGFueSBhc3N1bXB0aW9uIGFib3V0IGhvdyBJT01NVSBkcml2
ZXIgd291bGQgcmVwb3J0IHRoZQo+IGZhdWx0IChzZXJpYWxseSBvciBpbiBwYXJhbGxlbCksIEkg
dGhpbmsuCgpZZXMgSSBtb2RpZmllZCB0aGUgbG9ja2luZwoKVGhhbmtzCgpFcmljCj4gCj4+ICvC
oMKgwqAgaW50IGhlYWQsIHRhaWwsIHNpemU7Cj4+ICvCoMKgwqAgaW50IHJldCA9IDA7Cj4+ICsK
Pj4gK8KgwqDCoCBpZiAoZmF1bHQtPnR5cGUgIT0gSU9NTVVfRkFVTFRfRE1BX1VOUkVDT1YpCj4+
ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVOT0VOVDsKPj4gKwo+PiArwqDCoMKgIG11dGV4X2xv
Y2soJnZkZXYtPmZhdWx0X3F1ZXVlX2xvY2spOwo+PiArCj4+ICvCoMKgwqAgaGVhZCA9IHJlZy0+
aGVhZDsKPj4gK8KgwqDCoCB0YWlsID0gcmVnLT50YWlsOwo+PiArwqDCoMKgIHNpemUgPSByZWct
Pm5iX2VudHJpZXM7Cj4+ICsKPj4gK8KgwqDCoCBpZiAoQ0lSQ19TUEFDRShoZWFkLCB0YWlsLCBz
aXplKSA8IDEpIHsKPj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IC1FTk9TUEM7Cj4+ICvCoMKgwqDC
oMKgwqDCoCBnb3RvIHVubG9jazsKPj4gK8KgwqDCoCB9Cj4+ICsKPj4gK8KgwqDCoCAqbmV3ID0g
KmZhdWx0Owo+PiArwqDCoMKgIHJlZy0+aGVhZCA9IChoZWFkICsgMSkgJSBzaXplOwo+PiArdW5s
b2NrOgo+PiArwqDCoMKgIG11dGV4X3VubG9jaygmdmRldi0+ZmF1bHRfcXVldWVfbG9jayk7Cj4+
ICvCoMKgwqAgcmV0dXJuIHJldDsKPj4gK30KPj4gKwo+PiDCoCAjZGVmaW5lIERNQV9GQVVMVF9S
SU5HX0xFTkdUSCA1MTIKPj4gwqAgwqAgc3RhdGljIGludCB2ZmlvX3BjaV9pbml0X2RtYV9mYXVs
dF9yZWdpb24oc3RydWN0IHZmaW9fcGNpX2RldmljZQo+PiAqdmRldikKPj4gQEAgLTMxNyw2ICsz
NTAsMTMgQEAgc3RhdGljIGludCB2ZmlvX3BjaV9pbml0X2RtYV9mYXVsdF9yZWdpb24oc3RydWN0
Cj4+IHZmaW9fcGNpX2RldmljZSAqdmRldikKPj4gwqDCoMKgwqDCoCBoZWFkZXItPmVudHJ5X3Np
emUgPSBzaXplb2Yoc3RydWN0IGlvbW11X2ZhdWx0KTsKPj4gwqDCoMKgwqDCoCBoZWFkZXItPm5i
X2VudHJpZXMgPSBETUFfRkFVTFRfUklOR19MRU5HVEg7Cj4+IMKgwqDCoMKgwqAgaGVhZGVyLT5v
ZmZzZXQgPSBzaXplb2Yoc3RydWN0IHZmaW9fcmVnaW9uX2RtYV9mYXVsdCk7Cj4+ICsKPj4gK8Kg
wqDCoCByZXQgPSBpb21tdV9yZWdpc3Rlcl9kZXZpY2VfZmF1bHRfaGFuZGxlcigmdmRldi0+cGRl
di0+ZGV2LAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmZpb19w
Y2lfaW9tbXVfZGV2X2ZhdWx0X2hhbmRsZXIsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB2ZGV2KTsKPj4gK8KgwqDCoCBpZiAocmV0KQo+PiArwqDCoMKgwqDCoMKg
wqAgZ290byBvdXQ7Cj4+ICsKPj4gwqDCoMKgwqDCoCByZXR1cm4gMDsKPj4gwqAgb3V0Ogo+PiDC
oMKgwqDCoMKgIGtmcmVlKHZkZXYtPmZhdWx0X3BhZ2VzKTsKPiAKPiAKPiBUaGFua3MsCj4gWmVu
Z2h1aQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
