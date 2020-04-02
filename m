Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39B7C2BA15
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 12:18:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C9ECA20757
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 12:18:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9ECA20757
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E0644B146;
	Thu,  2 Apr 2020 08:18:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H-adEgbbcIWw; Thu,  2 Apr 2020 08:18:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10E8C4B159;
	Thu,  2 Apr 2020 08:18:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55A254B146
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 08:18:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqqflb8oqEl7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 08:18:20 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B67884B145
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 08:18:19 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 8DCB6735F0E567C3E1DB;
 Thu,  2 Apr 2020 20:18:15 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.58) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 20:18:08 +0800
Subject: Re: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
To: Zenghui Yu <yuzenghui@huawei.com>, Andrew Jones <drjones@redhat.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
 <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
 <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <492aeb1e-39d0-5b56-8a4b-887de37b8c42@huawei.com>
Date: Thu, 2 Apr 2020 20:18:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.58]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

SGkgRHJldywgWmVuZ2h1aSwKCk9uIDQvMi8yMDIwIDc6NTIgUE0sIFplbmdodWkgWXUgd3JvdGU6
Cj4gSGkgRHJldywgSmluZ3lpLAo+IAo+IE9uIDIwMjAvNC8xIDIwOjI0LCBBbmRyZXcgSm9uZXMg
d3JvdGU6Cj4+IE9uIFdlZCwgQXByIDAxLCAyMDIwIGF0IDA2OjA4OjEwUE0gKzA4MDAsIEppbmd5
aSBXYW5nIHdyb3RlOgo+Pj4gV2l0aCB0aGUgZGV2ZWxvcG1lbnQgb2YgYXJtIGdpYyBhcmNoaXRl
Y3R1cmUsIHdlIHRoaW5rIGl0IHdpbGwgYmUgdXNlZnVsCj4+PiB0byBhZGQgc29tZSBzaW1wbGUg
cGVyZm9ybWFuY2UgdGVzdCBpbiBrdXQgdG8gbWVhc3VyZSB0aGUgY29zdCBvZgo+Pj4gaW50ZXJy
dXB0cy4gWDg2IGFyY2ggaGFzIGltcGxlbWVudGVkIHNpbWlsYXIgdGVzdC4KPj4+Cj4+PiBKaW5n
eWkgV2FuZyAoMik6Cj4+PiDCoMKgIGFybS9hcm02NDogZ2ljOiBBZGQgSVBJIGxhdGVuY3kgdGVz
dAo+Pj4gwqDCoCBhcm0vYXJtNjQ6IEFkZCB2dGltZXIgbGF0ZW5jeSB0ZXN0Cj4+Pgo+Pj4gwqAg
YXJtL2dpYy5jwqDCoCB8IDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKwo+Pj4gwqAgYXJt
L3RpbWVyLmMgfCAxMSArKysrKysrKysrKwo+Pj4gwqAgMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNl
cnRpb25zKCspCj4+Pgo+Pj4gLS0gCj4+PiAyLjE5LjEKPj4+Cj4+Pgo+Pgo+PiBIaSBKaW5neWks
Cj4+Cj4+IFdlIGFscmVhZHkgaGF2ZSBhbiBJUEkgbGF0ZW5jeSB0ZXN0IGluIGFybS9taWNyby1i
ZW5jaC5jIEknZCBwcmVmZXIgdGhhdAo+PiBvbmUgYmUgdXNlZCwgaWYgcG9zc2libGUsIHJhdGhl
ciB0aGFuIGNvbmZsYXRpbmcgdGhlIGdpYyBmdW5jdGlvbmFsIHRlc3RzCj4+IHdpdGggbGF0ZW5j
eSB0ZXN0cy4gQ2FuIHlvdSB0YWtlIGEgbG9vayBhdCBpdCBhbmQgc2VlIGlmIGl0IHNhdGlzZmll
cwo+PiB5b3VyIG5lZWRzLCBleHRlbmRpbmcgaXQgaWYgbmVjZXNzYXJ5Pwo+IAo+IEkgdGhpbmsg
aXQnZCBiZSBnb29kIHRvIGhhdmUgdGhlc2UgaW50ZXJydXB0IGxhdGVuY3kgbWVhc3VyZW1lbnRz
IGluCj4ga3ZtLXVuaXQtdGVzdHMsIGFuZCB3ZSBjYW4gdGFrZSB0aGUgZm9sbG93aW5nIGludGVy
cnVwdCB0eXBlcyBpbnRvCj4gYWNjb3VudDoKPiAKPiAtIElQSQo+ICDCoCBBcyBEcmV3IHBvaW50
ZWQgb3V0LCB3ZSBhbHJlYWR5IGhhdmUgb25lIGluIHRoZSBtaWNyby1iZW5jaCBncm91cC4KPiAg
wqAgQnV0IHdoYXQgSSdtIGFjdHVhbGx5IGludGVyZXN0ZWQgaW4gaXMgdGhlIGxhdGVuY3kgb2Yg
dGhlIG5ldyBHSUN2NC4xCj4gIMKgIHZTR0lzICh3aGljaCB3aWxsIGJlIGRpcmVjdGx5IGluamVj
dGVkIHRocm91Z2ggSVRTKS7CoCBUbyBtZWFzdXJlIGl0LAo+ICDCoCB3ZSBzaG91bGQgZmlyc3Qg
bWFrZSBLVVQgYmUgR0lDdjQuMS1hd2FyZW5lc3MsIHNlZSBbMV0gZm9yIGRldGFpbHMuCj4gIMKg
IChUaGlzIHdheSwgd2UgY2FuIGV2ZW4gaGF2ZSBhIGxvb2sgYXQgdGhlIGludGVycnVwdCBsYXRl
bmN5IGluIEhXCj4gIMKgIGxldmVsLiBJcyBpdCBwb3NzaWJsZSB0byBoYXZlIHRoaXMgaW4ga3Zt
LXVuaXQtdGVzdHMsIERyZXc/KQo+IAo+IC0gUFBJCj4gIMKgIExpa2Ugd2hhdCBoYXMgYmVlbiBk
b25lIGluIHBhdGNoICMyLCB5b3UgY2FuIGNob29zZSB0aGUgdnRpbWVyCj4gIMKgIGludGVycnVw
dCBhcyBhbiBleGFtcGxlLgo+IAo+IC0gTFBJCj4gIMKgIEkgdGhpbmsgd2UgY2FuIGVhc2lseSBi
dWlsZCBhIExQSSBsYXRlbmN5IHRlc3QgYmFzZWQgb24gRXJpYydzICJJVFMKPiAgwqAgdGVzdHMi
IHNlcmllcyBbMl0sIHdoaWNoIHNob3VsZCBiZSB1cHN0cmVhbWVkIHNvb24uCj4gCj4gLSBpZiB5
b3Ugd2FudCB0byBhZGQgbW9yZS4uLgo+IAo+IFdoYXQgZG8geW91IHRoaW5rPyBJJ2QgbGlrZSB0
byBzZWUgYSBWMiBvZiB0aGlzIHNlcmllcyA6LSkuCj4gCj4gCj4gWzFdIAo+IGh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9j
b21taXQvP2lkPTBiMDQ3NThiMDAyYmRlOTQzNDA1M2JlMmZmZjgwNjRhYzNkOWQ4YmIgCj4gCj4g
WzJdIAo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDIwMDMyMDA5MjQyOC4yMDg4MC0x
LWVyaWMuYXVnZXJAcmVkaGF0LmNvbS8KPiAKPiAKPiBUaGFua3MsCj4gWmVuZ2h1aQo+IAo+IAo+
IC4KCkFzIERyZXcgbWVudGlvbmVkLCBJIGFtIHRoaW5raW5nIGFib3V0IGFkZGluZyBvdGhlciBn
aWMgZnVuY3Rpb25hbCB0ZXN0cwppbiBhcm0vbWljcm8tYmVuY2guYy4gVGhhbmtzIGZvciB5b3Vy
IHN1Z2dlc3Rpb24sIEkgdGhpbmsgaXQncyBvZiBncmVhdApoZWxwLgoKVGhhbmtzLApKaW5neWkK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
