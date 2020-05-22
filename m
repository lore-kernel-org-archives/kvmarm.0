Return-Path: <SRS0=EL0d=7E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59C4C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 22 May 2020 02:32:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 590A22078B
	for <kvmarm@archiver.kernel.org>; Fri, 22 May 2020 02:32:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 590A22078B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA0D64B306;
	Thu, 21 May 2020 22:32:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SKbPQ0Njc656; Thu, 21 May 2020 22:32:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9BE04B308;
	Thu, 21 May 2020 22:32:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEE654B306
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 May 2020 22:32:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Seh6ffWFbZ4a for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 May 2020 22:32:47 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A1184B2F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 May 2020 22:32:47 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 52FBB1F03C6E47C4B648;
 Fri, 22 May 2020 10:32:43 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.58) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 22 May 2020
 10:32:37 +0800
Subject: Re: [kvm-unit-tests PATCH 1/6] arm64: microbench: get correct ipi
 recieved num
To: Zenghui Yu <yuzenghui@huawei.com>, <drjones@redhat.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
References: <20200517100900.30792-1-wangjingyi11@huawei.com>
 <20200517100900.30792-2-wangjingyi11@huawei.com>
 <8e011659-4e4d-7312-4466-5ed3ea54cc9b@huawei.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <8b9d51f2-3906-9e0a-38ae-564424c38ff5@huawei.com>
Date: Fri, 22 May 2020 10:32:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8e011659-4e4d-7312-4466-5ed3ea54cc9b@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.58]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

Ck9uIDUvMjEvMjAyMCAxMDowMCBQTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBPbiAyMDIwLzUvMTcg
MTg6MDgsIEppbmd5aSBXYW5nIHdyb3RlOgo+PiBJZiBpcGlfZXhlYygpIGZhaWxzIGJlY2F1c2Ug
b2YgdGltZW91dCwgd2Ugc2hvdWxkbid0IGluY3JlYXNlCj4+IHRoZSBudW1iZXIgb2YgaXBpIHJl
Y2VpdmVkLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBKaW5neWkgV2FuZyA8d2FuZ2ppbmd5aTExQGh1
YXdlaS5jb20+Cj4+IC0tLQo+PiDCoCBhcm0vbWljcm8tYmVuY2guYyB8IDQgKysrLQo+PiDCoCAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Cj4+IGRpZmYg
LS1naXQgYS9hcm0vbWljcm8tYmVuY2guYyBiL2FybS9taWNyby1iZW5jaC5jCj4+IGluZGV4IDQ2
MTJmNDEuLmNhMDIyZDkgMTAwNjQ0Cj4+IC0tLSBhL2FybS9taWNyby1iZW5jaC5jCj4+ICsrKyBi
L2FybS9taWNyby1iZW5jaC5jCj4+IEBAIC0xMDMsNyArMTAzLDkgQEAgc3RhdGljIHZvaWQgaXBp
X2V4ZWModm9pZCkKPj4gwqDCoMKgwqDCoCB3aGlsZSAoIWlwaV9yZWNlaXZlZCAmJiB0cmllcy0t
KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgY3B1X3JlbGF4KCk7Cj4+IC3CoMKgwqAgKytyZWNlaXZl
ZDsKPj4gK8KgwqDCoCBpZiAoaXBpX3JlY2lldmVkKQo+IAo+IEkgdGhpbmsgeW91IG1heSB3YW50
ICppcGlfcmVjZWl2ZWQqIDstKSBPdGhlcndpc2UgaXQgY2FuIG5vdCBldmVuCj4gY29tcGlsZSEK
PiAKPj4gK8KgwqDCoMKgwqDCoMKgICsrcmVjZWl2ZWQ7Cj4+ICsKPj4gwqDCoMKgwqDCoCBhc3Nl
cnRfbXNnKGlwaV9yZWNlaXZlZCwgImZhaWxlZCB0byByZWNlaXZlIElQSSBpbiB0aW1lLCBidXQg
Cj4+IHJlY2VpdmVkICVkIHN1Y2Nlc3NmdWxseVxuIiwgcmVjZWl2ZWQpOwo+PiDCoCB9Cj4gCj4g
V2l0aCB0aGlzIGZpeGVkLCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUsCj4gCj4gUmV2aWV3ZWQtYnk6
IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+IAo+IAo+IFRoYW5rcy4KPiAKPiAu
ClRoaXMgdmFyaWFibGUgbmFtZSBpcyBtb2RpZmllZCBpbiB0aGUgbmV4dCBwYXRjaCwgc28gSSBp
Z25vcmVkIHRoYXQKbWlzdGFrZSwgdGhhbmtzLgoKVGhhbmtzLApKaW5neWkKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
