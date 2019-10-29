Return-Path: <SRS0=yVTD=YW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771F3CA9EAE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 13:31:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0027620578
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 13:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0027620578
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 769424A597;
	Tue, 29 Oct 2019 09:31:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lpQdcLc+Lnbe; Tue, 29 Oct 2019 09:31:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BB6A4A94E;
	Tue, 29 Oct 2019 09:31:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD2F4A8E8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 09:31:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jCxxz7xjUURV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Oct 2019 09:31:36 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81DC94A4CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 09:31:36 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id B145089EF28F21D4DC20;
 Tue, 29 Oct 2019 21:31:27 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 29 Oct 2019
 21:31:19 +0800
Subject: Re: [PATCH 3/3] KVM: arm/arm64: vgic: Don't rely on the wrong pending
 table
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20191029071919.177-1-yuzenghui@huawei.com>
 <20191029071919.177-4-yuzenghui@huawei.com> <86mudjykfa.wl-maz@kernel.org>
 <f8a30e65-7077-301a-1558-7fc504b5e891@huawei.com>
 <e2141f6a-c530-46d5-d5d9-26806b02d55b@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <01638947-ce47-2e09-68f0-a95eb6e9b2d0@huawei.com>
Date: Tue, 29 Oct 2019 21:31:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <e2141f6a-c530-46d5-d5d9-26806b02d55b@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgRXJpYywKCk9uIDIwMTkvMTAvMjkgMjA6NDksIEF1Z2VyIEVyaWMgd3JvdGU6Cj4gT24gMTAv
MjkvMTkgMToyNyBQTSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4gb2theSwgdGhlIHJlbWFpbmluZyBx
dWVzdGlvbiBpcyB0aGF0IGluIHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcygpOgo+Pgo+PiAg
wqDCoMKgwqBzdG9yZWQgPSB2YWwgJiAoMVUgPDwgYml0X25yKTsKPj4gIMKgwqDCoMKgaWYgKHN0
b3JlZCA9PSBpcnEtPnBlbmRpbmdfbGF0Y2gpCj4+ICDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsK
Pj4KPj4gIMKgwqDCoMKgaWYgKGlycS0+cGVuZGluZ19sYXRjaCkKPj4gIMKgwqDCoMKgwqDCoMKg
IHZhbCB8PSAxIDw8IGJpdF9ucjsKPj4gIMKgwqDCoMKgZWxzZQo+PiAgwqDCoMKgwqDCoMKgwqAg
dmFsICY9IH4oMSA8PCBiaXRfbnIpOwo+Pgo+PiBEbyB3ZSByZWFsbHkgaGF2ZSBhIHNjZW5hcmlv
IHdoZXJlIGlycS0+cGVuZGluZ19sYXRjaD09ZmFsc2UgYW5kCj4+IHN0b3JlZD09dHJ1ZSAoY29y
cmVzcG9uZHMgdG8gdGhlIGFib3ZlICJlbHNlIikgYW5kIHRoZW4gd2UgY2xlYXIKPj4gcGVuZGlu
ZyBzdGF0dXMgb2YgdGhpcyBMUEkgaW4gZ3Vlc3QgbWVtb3J5Pwo+PiBJIGNhbiBub3QgdGhpbmsg
b3V0IG9uZSBub3cuCj4gCj4gaWYgeW91IHNhdmUsIHJlc3RvcmUgYW5kIHNhdmUgYWdhaW4uIE9u
IHRoZSAxc3Qgc2F2ZSB0aGUgTFBJIG1heSBiZQo+IHBlbmRpbmcsIGl0IGdldHMgc3RvcmVkLiBP
biB0aGUgc2Vjb25kIHNhdmUgdGhlIExQSSBtYXkgYmUgbm90IHBlbmRpbmcKPiBhbnltb3JlPwoK
SSBhc3N1bWUgeW91IG1lYW4gdGhlICJyZXN0b3JlIiBieSB2Z2ljX2l0c19yZXN0b3JlX2l0ZSgp
LgoKV2hpbGUgcmVzdG9yaW5nIGEgTFBJLCB3ZSB3aWxsIHN5bmMgdGhlIHBlbmRpbmcgc3RhdHVz
IGZyb20gZ3Vlc3QKcGVuZGluZyB0YWJsZSAoaW50byB0aGUgc29mdHdhcmUgcGVuZGluZ19sYXRj
aCksIGFuZCBjbGVhciB0aGUKY29ycmVzcG9uZGluZyBiaXQgaW4gZ3Vlc3QgbWVtb3J5LgpTZWUg
dmdpY192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cygpLgoKU28gb24gdGhlIHNlY29uZCBzYXZl
LCB0aGUgTFBJIGNhbiBiZSBub3QgcGVuZGluZywgdGhlIGd1ZXN0IHBlbmRpbmcKdGFibGUgd2ls
bCBhbHNvIGluZGljYXRlIG5vdCBwZW5kaW5nLgoKClRoYW5rcywKWmVuZ2h1aQoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
