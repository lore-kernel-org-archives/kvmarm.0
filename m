Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EF4C33CB1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:50:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EFD8324656
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFD8324656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 660A84B133;
	Wed, 15 Jan 2020 08:50:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7CiPcJ7BwVUs; Wed, 15 Jan 2020 08:50:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66F204B136;
	Wed, 15 Jan 2020 08:50:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A8F4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:50:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TEgwL5W6IxIi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 08:50:16 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D530C4A59D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:50:14 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id E0AF1764F196C96C2BC7;
 Wed, 15 Jan 2020 21:50:10 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 Jan 2020
 21:49:59 +0800
Subject: Re: [PATCH v3 29/32] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
To: Marc Zyngier <maz@kernel.org>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-30-maz@kernel.org>
 <cc5fe20c-7a0c-c266-e78a-2a85963ab20f@hisilicon.com>
 <6e24d53e-64d9-a682-6753-9e16155c7fde@huawei.com>
 <c30b23cf220a4b2965a42ea87b27285f@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <99ed8894-9d30-7dac-9826-abf95b9a5e80@huawei.com>
Date: Wed, 15 Jan 2020 21:49:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <c30b23cf220a4b2965a42ea87b27285f@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Shaokun Zhang <zhangshaokun@hisilicon.com>,
 Robert Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
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

SGkgTWFyYywKCk9uIDIwMjAvMS8xNSAyMTozMiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MjAtMDEtMTUgMDM6NDksIFplbmdodWkgWXUgd3JvdGU6Cj4+IEhpLAo+Pgo+PiBPbiAyMDIwLzEv
MTUgMTA6NDksIFNoYW9rdW4gWmhhbmcgd3JvdGU6Cj4+PiBIaSBNYXJjLCBbVGhpcyBpcyBmcm9t
IE5pYW55YW9dCj4+Pgo+Pj4gT24gMjAxOS8xMi8yNCAxOToxMCwgTWFyYyBaeW5naWVyIHdyb3Rl
Ogo+Pj4+IEluIG9yZGVyIHRvIGxldCBhIGd1ZXN0IGJ1eSBpbiB0aGUgbmV3LCBhY3RpdmUtbGVz
cyBTR0lzLCB3ZQo+Pj4+IG5lZWQgdG8gYmUgYWJsZSB0byBzd2l0Y2ggYmV0d2VlbiB0aGUgdHdv
IG1vZGVzLgo+Pj4+Cj4+Pj4gSGFuZGxlIHRoaXMgYnkgc3RvcHBpbmcgYWxsIGd1ZXN0IGFjdGl2
aXR5LCB0cmFuc2ZlciB0aGUgc3RhdGUKPj4+PiBmcm9tIG9uZSBtb2RlIHRvIHRoZSBvdGhlciwg
YW5kIHJlc3VtZSB0aGUgZ3Vlc3QuCj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdp
ZXIgPG1hekBrZXJuZWwub3JnPgo+Pj4+IC0tLQo+Pgo+PiBbLi4uXQo+Pgo+Pj4+IGRpZmYgLS1n
aXQgYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLXY0LmMgYi92aXJ0L2t2bS9hcm0vdmdpYy92Z2lj
LXY0LmMKPj4+PiBpbmRleCBjMmZjZGUxMDRlYTIuLjA2Mzc4NWZkMmRjNyAxMDA2NDQKPj4+PiAt
LS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLXY0LmMKPj4+PiArKysgYi92aXJ0L2t2bS9hcm0v
dmdpYy92Z2ljLXY0LmMKPj4+PiBAQCAtOTcsNiArOTcsMTAyIEBAIHN0YXRpYyBpcnFyZXR1cm5f
dCB2Z2ljX3Y0X2Rvb3JiZWxsX2hhbmRsZXIoaW50IAo+Pj4+IGlycSwgdm9pZCAqaW5mbykKPj4+
PiDCoMKgwqDCoMKgIHJldHVybiBJUlFfSEFORExFRDsKPj4+PiDCoCB9Cj4+Pj4gwqAgK3N0YXRp
YyB2b2lkIHZnaWNfdjRfc3luY19zZ2lfY29uZmlnKHN0cnVjdCBpdHNfdnBlICp2cGUsIHN0cnVj
dCAKPj4+PiB2Z2ljX2lycSAqaXJxKQo+Pj4+ICt7Cj4+Pj4gK8KgwqDCoCB2cGUtPnNnaV9jb25m
aWdbaXJxLT5pbnRpZF0uZW5hYmxlZMKgwqDCoCA9IGlycS0+ZW5hYmxlZDsKPj4+PiArwqDCoMKg
IHZwZS0+c2dpX2NvbmZpZ1tpcnEtPmludGlkXS5ncm91cMKgwqDCoMKgID0gaXJxLT5ncm91cDsK
Pj4+PiArwqDCoMKgIHZwZS0+c2dpX2NvbmZpZ1tpcnEtPmludGlkXS5wcmlvcml0ecKgwqDCoCA9
IGlycS0+cHJpb3JpdHk7Cj4+Pj4gK30KPj4+PiArCj4+Pj4gK3N0YXRpYyB2b2lkIHZnaWNfdjRf
ZW5hYmxlX3ZzZ2lzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+PiArewo+Pj4+ICvCoMKgwqAg
c3RydWN0IGl0c192cGUgKnZwZSA9ICZ2Y3B1LT5hcmNoLnZnaWNfY3B1LnZnaWNfdjMuaXRzX3Zw
ZTsKPj4+PiArwqDCoMKgIGludCBpOwo+Pj4+ICsKPj4+PiArwqDCoMKgIC8qCj4+Pj4gK8KgwqDC
oMKgICogV2l0aCBHSUN2NC4xLCBldmVyeSB2aXJ0dWFsIFNHSSBjYW4gYmUgZGlyZWN0bHkgaW5q
ZWN0ZWQuIFNvCj4+Pj4gK8KgwqDCoMKgICogbGV0J3MgcHJldGVuZCB0aGF0IHRoZXkgYXJlIEhX
IGludGVycnVwdHMsIHRpZWQgdG8gYSBob3N0Cj4+Pj4gK8KgwqDCoMKgICogSVJRLiBUaGUgU0dJ
IGNvZGUgd2lsbCBkbyBpdHMgbWFnaWMuCj4+Pj4gK8KgwqDCoMKgICovCj4+Pj4gK8KgwqDCoCBm
b3IgKGkgPSAwOyBpIDwgVkdJQ19OUl9TR0lTOyBpKyspIHsKPj4+PiArwqDCoMKgwqDCoMKgwqAg
c3RydWN0IHZnaWNfaXJxICppcnEgPSB2Z2ljX2dldF9pcnEodmNwdS0+a3ZtLCB2Y3B1LCBpKTsK
Pj4+PiArwqDCoMKgwqDCoMKgwqAgc3RydWN0IGlycV9kZXNjICpkZXNjOwo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCBpbnQgcmV0Owo+Pj4+ICsKPj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGlycS0+aHcp
IHsKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2Z2ljX3B1dF9pcnEodmNwdS0+a3ZtLCBp
cnEpOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCB9Cj4+Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpcnEtPmh3ID0gdHJ1ZTsKPj4+
PiArwqDCoMKgwqDCoMKgwqAgaXJxLT5ob3N0X2lycSA9IGlycV9maW5kX21hcHBpbmcodnBlLT5z
Z2lfZG9tYWluLCBpKTsKPj4+Cj4+PiBJIHRoaW5rIHdlIG5lZWQgdG8gY2hlY2sgd2hldGhlciBp
cnFfZmluZF9tYXBwaW5nIHJldHVybnMgMC4KPj4+Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHZnaWNf
djRfc3luY19zZ2lfY29uZmlnKHZwZSwgaXJxKTsKPj4+PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4+
PiArwqDCoMKgwqDCoMKgwqDCoCAqIFNHSXMgYXJlIGluaXRpYWxpc2VkIGFzIGRpc2FibGVkLiBF
bmFibGUgdGhlbSBpZgo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgICogcmVxdWlyZWQgYnkgdGhlIHJl
c3Qgb2YgdGhlIFZHSUMgaW5pdCBjb2RlLgo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgICovCj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIGRlc2MgPSBpcnFfdG9fZGVzYyhpcnEtPmhvc3RfaXJxKTsKPj4+PiAr
wqDCoMKgwqDCoMKgwqAgcmV0ID0gaXJxX2RvbWFpbl9hY3RpdmF0ZV9pcnEoaXJxX2Rlc2NfZ2V0
X2lycV9kYXRhKGRlc2MpLAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBmYWxzZSk7Cj4+Pgo+Pj4gSWYgaXJxLT5ob3N0X2lycSBpcyBub3Qg
dmFsaWQgLCBpbiBpcnFfZG9tYWluX2FjdGl2YXRlX2lycSwgaXQgd2lsbCAKPj4+IHRyaWdnZXIg
TlVMTCBwb2ludGVyCj4+PiBkZXJlZmVyZW5jZSBpbiBob3N0IGtlcm5lbC4KPj4+IEkgbWVldCBh
IHByb2JsZW0gaGVyZS4gV2hlbiBodyBzdXBwb3J0IEdJQzQuMSwgYW5kIGhvc3Qga2VybmVsIGlz
IAo+Pj4gc3RhcnRlZCB3aXRoCj4+PiBrdm0tYXJtLnZnaWNfdjRfZW5hYmxlPTAsIHN0YXJ0aW5n
IGEgdmlydHVhbCBtYWNoaW5lIHdpbGwgdHJpZ2dlciAKPj4+IE5VTEwgcG9pbnRlcgo+Pj4gZGVy
ZWZlcmVuY2UgaW4gaG9zdC4KPj4KPj4gSSB0aGluayB0aGUgdGhpbmcgaXMgdGhhdCB3ZSBzaG91
bGQgX25vdF8gdHJ5IHRvIGNvbmZpZ3VyZSB2U0dJcyBhdCBhbGwKPj4gaWYga3ZtLWFybS52Z2lj
X3Y0X2VuYWJsZT0wICh3aGljaCBpbmRpY2F0ZXMgd2UgZG9uJ3QgYWxsb3cgdXNlIG9mIHRoZQo+
PiBHSUN2NCBvZiBkaXJlY3QgaW5qZWN0aW9uKS4KPj4KPj4gV2UgY3VycmVudGx5IHNldCBrdm1f
dmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEgdG8gdHJ1ZSBpZiBIVyBzdXBwb3J0Cj4+IEdJ
Q3Y0LjEsIHJlZ2FyZGxlc3Mgd2hhdGV2ZXIgdGhlIGdpY3Y0X2VuYWJsZSBpcyAoc2VlIHBhdGNo
IzIzIC0KPj4gdmdpY192M19wcm9iZSkuwqAgSSB0aGluayB0aGlzIGlzIHdoYXQgYWN0dWFsbHkg
bmVlZHMgZml4aW5nLgo+IAo+IFllcywgbXkgcG9pbnQgZXhhY3RseS4gSSd2ZSBwdXNoZWQgb3V0
IGEgcG90ZW50aWFsIGZpeCBbMV0sIGFuZCBJJ2QgYmUKPiBncmF0ZWZ1bCBpZiB5b3UgY291bGQg
bGV0IG1lIGtub3cgd2hldGhlciB0aGF0IGZpeGVzIGl0IGZvciB5b3UuCgpJIGhhdmVuJ3QgaGFk
IHRoZSBhcHByb3ByaWF0ZSBIVyB5ZXQuLiBOaWFueWFvIG9yIFNoYW9rdW4gY2FuIGhlbHAgdG8K
dGVzdCBpdCB0b21vcnJvdywgSSB0aGluay4KCj4gCj4gVGhhbmtzLAo+IAo+ICDCoMKgwqDCoMKg
wqDCoCBNLgo+IAo+IFsxXSAKPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9tYXovYXJtLXBsYXRmb3Jtcy5naXQvY29tbWl0Lz9oPWlycS9naWMtdjQuMS1k
ZXZlbCZpZD1iODJjMmVlMWQzZmVmNjZmYjg1NzkzOTY1YzM0NDI2MGY2MTgyMTlkIAoKQW55d2F5
LCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUuCgoKVGhhbmtzLApaZW5naHVpCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
