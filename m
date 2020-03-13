Return-Path: <SRS0=NSSj=46=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77347C4CECE
	for <kvmarm@archiver.kernel.org>; Fri, 13 Mar 2020 08:18:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E667C20749
	for <kvmarm@archiver.kernel.org>; Fri, 13 Mar 2020 08:18:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XelB5Jvp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E667C20749
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1124E4AEE8;
	Fri, 13 Mar 2020 04:18:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m1c1DFFAPOyF; Fri, 13 Mar 2020 04:17:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D979E4A5A3;
	Fri, 13 Mar 2020 04:17:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F20B4A536
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2020 04:17:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 04Kj4JCbG3Wn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2020 04:17:56 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF7374A51E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2020 04:17:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584087476;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BkfTBkxp5txNCOlskJxS6kz6+SU8BlpUA68Svo5CBgs=;
 b=XelB5JvpGi08hvfy649aiGGfRzGDDicFzUNsm2PioNRddcMqy+sT9MHrE35lTa4ZMM1oJp
 MloxHTZy+WfuloUPgAuLGombD0Ir8CKuZXOGXlUZyUPovPxq2s5zSz56e2PAP20oKnX1Cq
 Oa9rcd8hg0BYiKBZJe6lvsgX8HDdvHM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-5CGfopJANheQnmlY3EVVng-1; Fri, 13 Mar 2020 04:17:51 -0400
X-MC-Unique: 5CGfopJANheQnmlY3EVVng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 092BA800D5B;
 Fri, 13 Mar 2020 08:17:50 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 709175C1B5;
 Fri, 13 Mar 2020 08:17:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v6 10/13] arm/arm64: ITS: INT functional
 tests
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200311135117.9366-1-eric.auger@redhat.com>
 <20200311135117.9366-11-eric.auger@redhat.com>
 <7d79cc12-acdb-ff56-594d-3fa830f7d053@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <881583f3-ea9c-64ba-437f-4401f3aaf1ac@redhat.com>
Date: Fri, 13 Mar 2020 09:17:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7d79cc12-acdb-ff56-594d-3fa830f7d053@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: andre.przywara@arm.com, thuth@redhat.com
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

SGkgWmVuZ2h1aSwKT24gMy8xMy8yMCAzOjA2IEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+IE9uIDIw
MjAvMy8xMSAyMTo1MSwgRXJpYyBBdWdlciB3cm90ZToKPj4gK3N0YXRpYyB2b2lkIHRlc3RfaXRz
X3RyaWdnZXIodm9pZCkKPj4gK3sKPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKmNv
bDMsICpjb2wyOwo+PiArwqDCoMKgIHN0cnVjdCBpdHNfZGV2aWNlICpkZXYyLCAqZGV2NzsKPj4g
Kwo+PiArwqDCoMKgIGlmIChpdHNfcHJlcmVxdWlzaXRlcyg0KSkKPj4gK8KgwqDCoMKgwqDCoMKg
IHJldHVybjsKPj4gKwo+PiArwqDCoMKgIGRldjIgPSBpdHNfY3JlYXRlX2RldmljZSgyIC8qIGRl
diBpZCAqLywgOCAvKiBuYl9pdGVzICovKTsKPj4gK8KgwqDCoCBkZXY3ID0gaXRzX2NyZWF0ZV9k
ZXZpY2UoNyAvKiBkZXYgaWQgKi8sIDggLyogbmJfaXRlcyAqLyk7Cj4+ICsKPj4gK8KgwqDCoCBj
b2wzID0gaXRzX2NyZWF0ZV9jb2xsZWN0aW9uKDMgLyogY29sIGlkICovLCAzLyogdGFyZ2V0IFBF
ICovKTsKPj4gK8KgwqDCoCBjb2wyID0gaXRzX2NyZWF0ZV9jb2xsZWN0aW9uKDIgLyogY29sIGlk
ICovLCAyLyogdGFyZ2V0IFBFICovKTsKPj4gKwo+PiArwqDCoMKgIGdpY3YzX2xwaV9zZXRfY29u
ZmlnKDgxOTUsIExQSV9QUk9QX0RFRkFVTFQpOwo+PiArwqDCoMKgIGdpY3YzX2xwaV9zZXRfY29u
ZmlnKDgxOTYsIExQSV9QUk9QX0RFRkFVTFQpOwo+PiArCj4+ICvCoMKgwqAgcmVwb3J0X3ByZWZp
eF9wdXNoKCJpbnQiKTsKPj4gK8KgwqDCoCAvKgo+PiArwqDCoMKgwqAgKiBkZXY9MiwgZXZlbnRp
ZD0yMMKgIC0+IGxwaT0gODE5NSwgY29sPTMKPj4gK8KgwqDCoMKgICogZGV2PTcsIGV2ZW50aWQ9
MjU1IC0+IGxwaT0gODE5NiwgY29sPTIKPj4gK8KgwqDCoMKgICogVHJpZ2dlciBkZXYyLCBldmVu
dGlkPTIwIGFuZCBkZXY3LCBldmVudGlkPTI1NQo+PiArwqDCoMKgwqAgKiBDaGVjayBib3RoIExQ
SXMgaGl0Cj4+ICvCoMKgwqDCoCAqLwo+PiArCj4+ICvCoMKgwqAgaXRzX3NlbmRfbWFwZChkZXYy
LCB0cnVlKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9tYXBkKGRldjcsIHRydWUpOwo+PiArCj4+ICvC
oMKgwqAgaXRzX3NlbmRfbWFwYyhjb2wzLCB0cnVlKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9tYXBj
KGNvbDIsIHRydWUpOwo+PiArCj4+ICvCoMKgwqAgaXRzX3NlbmRfaW52YWxsKGNvbDIpOwo+PiAr
wqDCoMKgIGl0c19zZW5kX2ludmFsbChjb2wzKTsKPj4gKwo+PiArwqDCoMKgIGl0c19zZW5kX21h
cHRpKGRldjIsIDgxOTUgLyogbHBpIGlkICovLCAyMCAvKiBldmVudCBpZCAqLywgY29sMyk7Cj4+
ICvCoMKgwqAgaXRzX3NlbmRfbWFwdGkoZGV2NywgODE5NiAvKiBscGkgaWQgKi8sIDI1NSAvKiBl
dmVudCBpZCAqLywgY29sMik7Cj4+ICsKPj4gK8KgwqDCoCBscGlfc3RhdHNfZXhwZWN0KDMsIDgx
OTUpOwo+PiArwqDCoMKgIGl0c19zZW5kX2ludChkZXYyLCAyMCk7Cj4+ICvCoMKgwqAgY2hlY2tf
bHBpX3N0YXRzKCJkZXY9MiwgZXZlbnRpZD0yMMKgIC0+IGxwaT0gODE5NSwgY29sPTMiKTsKPj4g
Kwo+PiArwqDCoMKgIGxwaV9zdGF0c19leHBlY3QoMiwgODE5Nik7Cj4+ICvCoMKgwqAgaXRzX3Nl
bmRfaW50KGRldjcsIDI1NSk7Cj4+ICvCoMKgwqAgY2hlY2tfbHBpX3N0YXRzKCJkZXY9NywgZXZl
bnRpZD0yNTUgLT4gbHBpPSA4MTk2LCBjb2w9MiIpOwo+PiArCj4+ICvCoMKgwqAgcmVwb3J0X3By
ZWZpeF9wb3AoKTsKPj4gKwo+PiArwqDCoMKgIHJlcG9ydF9wcmVmaXhfcHVzaCgiaW52L2ludmFs
bCIpOwo+PiArCj4+ICvCoMKgwqAgLyoKPj4gK8KgwqDCoMKgICogZGlzYWJsZSA4MTk1LCBjaGVj
ayBkZXYyL2V2ZW50aWQ9MjAgZG9lcyBub3QgdHJpZ2dlciB0aGUKPj4gK8KgwqDCoMKgICogY29y
cmVzcG9uZGluZyBMUEkKPj4gK8KgwqDCoMKgICovCj4+ICvCoMKgwqAgZ2ljdjNfbHBpX3NldF9j
b25maWcoODE5NSwgTFBJX1BST1BfREVGQVVMVCAmIH5MUElfUFJPUF9FTkFCTEVEKTsKPj4gK8Kg
wqDCoCBpdHNfc2VuZF9pbnYoZGV2MiwgMjApOwo+PiArCj4+ICvCoMKgwqAgbHBpX3N0YXRzX2V4
cGVjdCgtMSwgLTEpOwo+PiArwqDCoMKgIGl0c19zZW5kX2ludChkZXYyLCAyMCk7Cj4+ICvCoMKg
wqAgY2hlY2tfbHBpX3N0YXRzKCJkZXYyL2V2ZW50aWQ9MjAgZG9lcyBub3QgdHJpZ2dlciBhbnkg
TFBJIik7Cj4+ICsKPj4gK8KgwqDCoCAvKgo+PiArwqDCoMKgwqAgKiByZS1lbmFibGUgdGhlIExQ
SSBidXQgd2lsbGluZ2x5IGRvIG5vdCBjYWxsIGludmFsbAo+PiArwqDCoMKgwqAgKiBzbyB0aGUg
Y2hhbmdlIGluIGNvbmZpZyBpcyBub3QgdGFrZW4gaW50byBhY2NvdW50Lgo+PiArwqDCoMKgwqAg
KiBUaGUgTFBJIHNob3VsZCBub3QgaGl0Cj4+ICvCoMKgwqDCoCAqLwo+PiArwqDCoMKgIGdpY3Yz
X2xwaV9zZXRfY29uZmlnKDgxOTUsIExQSV9QUk9QX0RFRkFVTFQpOwo+PiArwqDCoMKgIGxwaV9z
dGF0c19leHBlY3QoLTEsIC0xKTsKPj4gK8KgwqDCoCBpdHNfc2VuZF9pbnQoZGV2MiwgMjApOwo+
PiArwqDCoMKgIGNoZWNrX2xwaV9zdGF0cygiZGV2Mi9ldmVudGlkPTIwIHN0aWxsIGRvZXMgbm90
IHRyaWdnZXIgYW55IExQSSIpOwo+PiArCj4+ICvCoMKgwqAgLyogTm93IGNhbGwgdGhlIGludmFs
bCBhbmQgY2hlY2sgdGhlIExQSSBoaXRzICovCj4+ICvCoMKgwqAgaXRzX3NlbmRfaW52YWxsKGNv
bDMpOwo+PiArwqDCoMKgIGxwaV9zdGF0c19leHBlY3QoMywgODE5NSk7Cj4+ICvCoMKgwqAgaXRz
X3NlbmRfaW50KGRldjIsIDIwKTsKPj4gK8KgwqDCoCBjaGVja19scGlfc3RhdHMoImRldjIvZXZl
bnRpZD0yMCBub3cgdHJpZ2dlcnMgYW4gTFBJIik7Cj4+ICsKPj4gK8KgwqDCoCByZXBvcnRfcHJl
Zml4X3BvcCgpOwo+PiArCj4+ICvCoMKgwqAgcmVwb3J0X3ByZWZpeF9wdXNoKCJtYXBkIHZhbGlk
PWZhbHNlIik7Cj4+ICvCoMKgwqAgLyoKPj4gK8KgwqDCoMKgICogVW5tYXAgZGV2aWNlIDIgYW5k
IGNoZWNrIHRoZSBldmVudGlkIDIwIGZvcm1lcmx5Cj4+ICvCoMKgwqDCoCAqIGF0dGFjaGVkIHRv
IGl0IGRvZXMgbm90IGhpdCBhbnltb3JlCj4+ICvCoMKgwqDCoCAqLwo+PiArCj4+ICvCoMKgwqAg
aXRzX3NlbmRfbWFwZChkZXYyLCBmYWxzZSk7Cj4+ICvCoMKgwqAgbHBpX3N0YXRzX2V4cGVjdCgt
MSwgLTEpOwo+PiArwqDCoMKgIGl0c19zZW5kX2ludChkZXYyLCAyMCk7Cj4gCj4gSGVyZS4gWW91
IGlzc3VlZCBhbiBJTlQgY29tbWFuZCB3aGlsZSB0aGUgZGV2MiBoYXMganVzdCBiZWVuIHVubWFw
cGVkLAo+IHRoaXMgd2lsbCBiZSBkZXRlY3RlZCBieSBJVFMgYXMgYSBjb21tYW5kIGVycm9yLiBX
ZSBtYXkgZW5kLXVwIGZhaWxlZAo+IHRvIHNlZSB0aGUgY29tcGxldGlvbiBvZiB0aGlzIGNvbW1h
bmQgKHVuZGVyIHRoZSBJVFMgc3RhbGwgbW9kZSkuCkkgYWdyZWUgdGhpcyBpcyBhIGNhc2Ugd2hl
cmUgaXQgaXMgZXhwZWN0ZWQgdG8gZmFpbC4gSG93ZXZlciBhdCB0aGUKbW9tZW50IHdlIGRvbid0
IGhhdmUgc3RhbGwga2VybmVsIHN1cHBvcnQgYW5kIHRoZSB3YXkgSSB0ZXN0IGl0IGZhaWxzIGlz
CmJ5IGlzc3VpbmcgdGhlIGJlbG93CmxwaV9zdGF0c19leHBlY3QoLTEsIC0xKTsKY2hlY2tfbHBp
X3N0YXRzKCJubyBMUEkgYWZ0ZXIgZGV2aWNlIHVubWFwIik7CgpPdGhlcndpc2UgSSBjYW5ub3Qg
dGVzdCB0aGlzIHNjZW5hcmlvLgoKSSBzdWdnZXN0IG9uY2Ugd2UgZ2V0IHRoZSBzdGFsbCBzdXBw
b3J0IGluIGtlcm5lbCwgd2UgcmV2aXNpdCB0aGUgdGVzdHMuCgpUaGFua3MKCkVyaWMKCj4gCj4g
Cj4gVGhhbmtzLAo+IFplbmdodWkKPiAKPj4gK8KgwqDCoCBjaGVja19scGlfc3RhdHMoIm5vIExQ
SSBhZnRlciBkZXZpY2UgdW5tYXAiKTsKPj4gK8KgwqDCoCByZXBvcnRfcHJlZml4X3BvcCgpOwo+
PiArfQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
