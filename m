Return-Path: <SRS0=6J9q=BV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18FCC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 01:48:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36FA220716
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 01:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36FA220716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D8574B201;
	Mon, 10 Aug 2020 21:48:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nkEchcux1bO0; Mon, 10 Aug 2020 21:48:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 737274B362;
	Mon, 10 Aug 2020 21:48:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 506D24B360
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2020 21:48:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UeW2kbKzPtux for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2020 21:48:35 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFC0B4B201
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2020 21:48:34 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 33EC877B1A183CF848FE;
 Tue, 11 Aug 2020 09:48:31 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Tue, 11 Aug 2020
 09:48:24 +0800
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
To: Marc Zyngier <maz@kernel.org>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
Date: Tue, 11 Aug 2020 09:48:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0bd81d1da9040fce660af46763507ac2@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDgvNS8yMDIwIDg6MTMgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDIwLTA4LTA1IDEyOjU0LCBKaW5neWkgV2FuZyB3cm90ZToKPj4gSGkgYWxsLAo+Pgo+PiBDdXJy
ZW50bHksIGt2bS11bml0LXRlc3RzIG9ubHkgc3VwcG9ydCBHSUN2MyB2TFBJIGluamVjdGlvbi4g
TWF5IEkgYXNrCj4+IGlzIHRoZXJlIGFueSBwbGFuIG9yIHN1Z2dlc3Rpb24gb24gY29uc3RydWN0
aW5nIGlycSBieXBhc3MgbWVjaGFuaXNtCj4+IHRvIHRlc3QgdkxQSSBkaXJlY3QgaW5qZWN0aW9u
IGluIGt2bS11bml0LXRlc3RzPwo+IAo+IEknbSBub3Qgc3VyZSB3aGF0IHlvdSBhcmUgYXNraW5n
IGZvciBoZXJlLiBWTFBJcyBhcmUgb25seSBkZWxpdmVyZWQKPiBmcm9tIGEgSFcgZGV2aWNlLCBh
bmQgdGhlIG9mZmxvYWRpbmcgbWVjaGFuaXNtIGlzbid0IHZpc2libGUgZnJvbQo+IHVzZXJzcGFj
ZSAoeW91IGVpdGhlciBoYXZlIGFuIGVuYWJsZWQgR0lDdjQgaW1wbGVtZW50YXRpb24sIG9yCj4g
eW91IGRvbid0KS4KPiAKPiBUaGVyZSBhcmUgd2F5cyB0byAqdHJpZ2dlciogZGV2aWNlIE1TSXMg
ZnJvbSB1c2Vyc3BhY2UgYW5kIGluamVjdAo+IHRoZW0gaW4gYSBndWVzdCwgYnV0IHRoYXQncyBv
bmx5IGEgZGVidWcgZmVhdHVyZSwgd2hpY2ggc2hvdWxkbid0Cj4gYmUgZW5hYmxlZCBvbiBhIHBy
b2R1Y3Rpb24gc3lzdGVtLgo+IAo+ICDCoMKgwqDCoMKgwqDCoCBNLgoKU29ycnkgZm9yIHRoZSBs
YXRlIHJlcGx5LgoKQXMgSSBtZW50aW9uZWQgYmVmb3JlLCB3ZSB3YW50IHRvIGFkZCB2TFBJIGRp
cmVjdCBpbmplY3Rpb24gdGVzdAppbiBLVVQsIG1lYW53aGlsZSBtZWFzdXJlIHRoZSBsYXRlbmN5
IG9mIGhhcmR3YXJlIHZMUEkgaW5qZWN0aW9uLgoKU3VyZSwgdkxQSSBpcyB0cmlnZ2VyZWQgYnkg
aGFyZHdhcmUuIFNpbmNlIGtlcm5lbCBzdXBwb3J0cyBzZW5kaW5nCklUUyBJTlQgY29tbWFuZCBp
biBndWVzdCB0byB0cmlnZ2VyIHZMUEksIEkgd29uZGVyIGlmIGl0IGlzIHBvc3NpYmxlCnRvIGFk
ZCBhbiBleHRyYSBpbnRlcmZhY2UgdG8gbWFrZSBhIHZMUEkgaGFyZHdhcmUtb2ZmbG9hZChqdXN0
IGFzCmt2bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKCkgZG9lcykuIElmIHNvLCB2Z2ljX2l0c190
cmlnZ2VyX21zaSgpCmNhbiBpbmplY3QgdkxQSSBkaXJlY3RseSBpbnN0ZWFkIG9mIHVzaW5nIExS
LgoKVGhhbmtzLApKaW5neWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
