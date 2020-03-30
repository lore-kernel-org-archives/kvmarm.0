Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BF1C43331
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 13:18:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 584822073B
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 13:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 584822073B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A301E4B1A9;
	Mon, 30 Mar 2020 09:18:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id knHFJCOXKs9c; Mon, 30 Mar 2020 09:18:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B79DA4B1B0;
	Mon, 30 Mar 2020 09:18:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB17D4B1A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 09:18:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DgvRabcLocvp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 09:18:02 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68F0B4B12F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 09:18:00 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 6D6481EB6A23AB42A64A;
 Mon, 30 Mar 2020 21:17:54 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 21:17:48 +0800
Subject: Re: [kvm-unit-tests PATCH v7 13/13] arm/arm64: ITS: pending table
 migration test
To: Auger Eric <eric.auger@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-14-eric.auger@redhat.com>
 <296c574b-810c-9c90-a613-df732a9ac193@huawei.com>
 <ea74559c-2ab4-752c-e587-2bf40eab14b0@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <0e73fd13-ca18-2d17-2267-fd5d852e3ac8@huawei.com>
Date: Mon, 30 Mar 2020 21:17:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <ea74559c-2ab4-752c-e587-2bf40eab14b0@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

T24gMjAyMC8zLzMwIDIwOjM4LCBBdWdlciBFcmljIHdyb3RlOgo+IEhpIFplbmdodWksCgpbLi4u
XQoKPj4+ICsKPj4+ICvCoMKgwqAgcHRyID0gZ2ljdjNfZGF0YS5yZWRpc3RfYmFzZVtwZTBdICsg
R0lDUl9QRU5EQkFTRVI7Cj4+PiArwqDCoMKgIHBlbmRiYXNlciA9IHJlYWRxKHB0cik7Cj4+PiAr
wqDCoMKgIHdyaXRlcShwZW5kYmFzZXIgJiB+R0lDUl9QRU5EQkFTRVJfUFRaLCBwdHIpOwo+Pj4g
Kwo+Pj4gK8KgwqDCoCBwdHIgPSBnaWN2M19kYXRhLnJlZGlzdF9iYXNlW3BlMV0gKyBHSUNSX1BF
TkRCQVNFUjsKPj4+ICvCoMKgwqAgcGVuZGJhc2VyID0gcmVhZHEocHRyKTsKPj4+ICvCoMKgwqAg
d3JpdGVxKHBlbmRiYXNlciAmIH5HSUNSX1BFTkRCQVNFUl9QVFosIHB0cik7Cj4+PiArCj4+PiAr
wqDCoMKgIGdpY3YzX2xwaV9yZGlzdF9lbmFibGUocGUwKTsKPj4+ICvCoMKgwqAgZ2ljdjNfbHBp
X3JkaXN0X2VuYWJsZShwZTEpOwo+Pgo+PiBJIGRvbid0IGtub3cgaG93IHRoZSBtaWdyYXRpb24g
Z2V0cyBpbXBsZW1lbnRlZCBpbiBrdm0tdW5pdC10ZXN0cy4KPj4gQnV0IGlzIHRoZXJlIGFueSBn
dWFyYW50ZWUgdGhhdCB0aGUgTFBJcyB3aWxsIG9ubHkgYmUgdHJpZ2dlcmVkIG9uIHRoZQo+PiBk
ZXN0aW5hdGlvbiBzaWRlPyBBcyBvbmNlIHRoZSBFbmFibGVMUElzIGJpdCBiZWNvbWVzIDEsIFZH
SUMgd2lsbCBzdGFydAo+PiByZWFkaW5nIHRoZSBwZW5kaW5nIGJpdCBpbiBndWVzdCBtZW1vcnkg
YW5kIHBvdGVudGlhbGx5IGluamVjdGluZyBMUElzCj4+IGludG8gdGhlIHRhcmdldCB2Y3B1IChp
biB0aGUgc291cmNlIHNpZGUpLgo+IAo+IEkgZXhwZWN0IHNvbWUgTFBJcyB0byBoaXQgb24gc291
cmNlIGFuZCBzb21lIG90aGVycyB0byBoaXQgb24gdGhlCj4gZGVzdGluYXRpb24uIFRvIG1lLCB0
aGlzIGRvZXMgbm90IHJlYWxseSBtYXR0ZXIgYXMgbG9uZyBhcyB0aGUgaGFuZGxlcnMKPiBnZXRz
IGNhbGxlZCBhbmQgYWNjdW11bGF0ZSB0aGUgc3RhdHMuIEdpdmVuIHRoZSBudW1iZXIgb2YgTFBJ
cywgd2Ugd2lsbAo+IGF0IGxlYXN0IHRlc3QgdGhlIG1pZ3JhdGlvbiBvZiBzb21lIG9mIHRoZSBw
ZW5kaW5nIGJpdHMgYW5kIGVzcGVjaWFsbHkKPiBhZGphY2VudCBvbmVzLiBJdCBkb2VzIHdvcmsg
YXMgaXQgYWxsb3dzIHRvIHRlc3QgeW91ciBmaXg6Cj4gCj4gY2ExODViMjYwOTUxICBLVk06IGFy
bS9hcm02NDogdmdpYzogRG9uJ3QgcmVseSBvbiB0aGUgd3JvbmcgcGVuZGluZyB0YWJsZQoKRmFp
ciBlbm91Z2guIFRoYW5rcyBmb3IgeW91ciBleHBsYW5hdGlvbiEKCgpaZW5naHVpCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
