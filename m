Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46236C3F2D1
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 06:30:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C45D8207FD
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 06:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C45D8207FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0205A4AEB2;
	Thu,  5 Mar 2020 01:30:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eulqmdqm0TaS; Thu,  5 Mar 2020 01:30:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E08884AEA4;
	Thu,  5 Mar 2020 01:30:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 623004AC86
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 01:30:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F9L6xqclkLlh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2020 01:30:36 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6CB44A578
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 01:30:35 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 4BB4BA99A342402E1B34;
 Thu,  5 Mar 2020 14:30:29 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 14:30:18 +0800
Subject: Re: [kvm-unit-tests PATCH v3 08/14] arm/arm64: ITS:
 its_enable_defaults
To: Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-9-eric.auger@redhat.com>
 <10d0630f-1464-b12a-5ad5-ee617eaa5cca@huawei.com>
 <a49227ce-355a-be35-c006-441e2adca8e1@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1b91ddb6-5139-5deb-2325-c18af7657825@huawei.com>
Date: Thu, 5 Mar 2020 14:30:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <a49227ce-355a-be35-c006-441e2adca8e1@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgRXJpYywKCk9uIDIwMjAvMy80IDIyOjI2LCBBdWdlciBFcmljIHdyb3RlOgo+IEhpIFplbmdo
dWksCj4gT24gMi83LzIwIDQ6MjAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4+IEhpIEVyaWMsCj4+
Cj4+IE9uIDIwMjAvMS8yOCAxODozNCwgRXJpYyBBdWdlciB3cm90ZToKPj4+IGl0c19lbmFibGVf
ZGVmYXVsdHMoKSBpcyB0aGUgdG9wIGluaXQgZnVuY3Rpb24gdGhhdCBhbGxvY2F0ZXMgdGhlCj4+
PiBjb21tYW5kIHF1ZXVlIGFuZCBhbGwgdGhlIHJlcXVlc3RlZCB0YWJsZXMgKGRldmljZSwgY29s
bGVjdGlvbiwKPj4+IGxwaSBjb25maWcgYW5kIHBlbmRpbmcgdGFibGVzKSwgZW5hYmxlIExQSXMg
YXQgZGlzdHJpYnV0b3IgbGV2ZWwKPj4+IGFuZCBJVFMgbGV2ZWwuCj4+Pgo+Pj4gZ2ljdjNfZW5h
YmxlX2RlZmF1bHRzIG11c3QgYmUgY2FsbGVkIGJlZm9yZS4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5
OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+Pgo+Pj4gLS0tCj4+Pgo+Pj4g
djIgLT4gdjM6Cj4+PiAtIGludHJvZHVjZSBpdHNfc2V0dXBfYmFzZXIgaW4gdGhpcyBwYXRjaAo+
Pj4gLSBzcXVhc2ggImFybS9hcm02NDogSVRTOiBJbml0IHRoZSBjb21tYW5kIHF1ZXVlIiBpbiB0
aGlzIHBhdGNoLgo+Pj4gLS0tCj4+PiAgwqAgbGliL2FybS9hc20vZ2ljLXYzLWl0cy5oIHzCoCA4
ICsrKysKPj4+ICDCoCBsaWIvYXJtL2dpYy12My1pdHMuY8KgwqDCoMKgIHwgODkgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+Pj4gIMKgIDIgZmlsZXMgY2hhbmdlZCwg
OTcgaW5zZXJ0aW9ucygrKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9saWIvYXJtL2FzbS9naWMtdjMt
aXRzLmggYi9saWIvYXJtL2FzbS9naWMtdjMtaXRzLmgKPj4+IGluZGV4IDgxNWM1MTUuLmZlNzNj
MDQgMTAwNjQ0Cj4+PiAtLS0gYS9saWIvYXJtL2FzbS9naWMtdjMtaXRzLmgKPj4+ICsrKyBiL2xp
Yi9hcm0vYXNtL2dpYy12My1pdHMuaAo+Pj4gQEAgLTM2LDYgKzM2LDggQEAgc3RydWN0IGl0c19k
YXRhIHsKPj4+ICDCoMKgwqDCoMKgIHZvaWQgKmJhc2U7Cj4+PiAgwqDCoMKgwqDCoCBzdHJ1Y3Qg
aXRzX3R5cGVyIHR5cGVyOwo+Pj4gIMKgwqDCoMKgwqAgc3RydWN0IGl0c19iYXNlciBiYXNlcltH
SVRTX0JBU0VSX05SX1JFR1NdOwo+Pj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NtZF9ibG9jayAqY21k
X2Jhc2U7Cj4+PiArwqDCoMKgIHN0cnVjdCBpdHNfY21kX2Jsb2NrICpjbWRfd3JpdGU7Cj4+PiAg
wqAgfTsKPj4+ICDCoCDCoCBleHRlcm4gc3RydWN0IGl0c19kYXRhIGl0c19kYXRhOwo+Pj4gQEAg
LTg4LDEwICs5MCwxNiBAQCBleHRlcm4gc3RydWN0IGl0c19kYXRhIGl0c19kYXRhOwo+Pj4gIMKg
ICNkZWZpbmUgR0lUU19CQVNFUl9UWVBFX0RFVklDRcKgwqDCoMKgwqDCoMKgIDEKPj4+ICDCoCAj
ZGVmaW5lIEdJVFNfQkFTRVJfVFlQRV9DT0xMRUNUSU9OwqDCoMKgIDQKPj4+ICDCoCArCj4+PiAr
c3RydWN0IGl0c19jbWRfYmxvY2sgewo+Pj4gK8KgwqDCoCB1NjQgcmF3X2NtZFs0XTsKPj4+ICt9
Owo+Pj4gKwo+Pj4gIMKgIGV4dGVybiB2b2lkIGl0c19wYXJzZV90eXBlcih2b2lkKTsKPj4+ICDC
oCBleHRlcm4gdm9pZCBpdHNfaW5pdCh2b2lkKTsKPj4+ICDCoCBleHRlcm4gaW50IGl0c19wYXJz
ZV9iYXNlcihpbnQgaSwgc3RydWN0IGl0c19iYXNlciAqYmFzZXIpOwo+Pj4gIMKgIGV4dGVybiBz
dHJ1Y3QgaXRzX2Jhc2VyICppdHNfbG9va3VwX2Jhc2VyKGludCB0eXBlKTsKPj4+ICtleHRlcm4g
dm9pZCBpdHNfZW5hYmxlX2RlZmF1bHRzKHZvaWQpOwo+Pj4gIMKgIMKgICNlbHNlIC8qIF9fYXJt
X18gKi8KPj4+ICDCoCBkaWZmIC0tZ2l0IGEvbGliL2FybS9naWMtdjMtaXRzLmMgYi9saWIvYXJt
L2dpYy12My1pdHMuYwo+Pj4gaW5kZXggMmMwY2UxMy4uZDFlN2U1MiAxMDA2NDQKPj4+IC0tLSBh
L2xpYi9hcm0vZ2ljLXYzLWl0cy5jCj4+PiArKysgYi9saWIvYXJtL2dpYy12My1pdHMuYwo+Pj4g
QEAgLTg2LDMgKzg2LDkyIEBAIHZvaWQgaXRzX2luaXQodm9pZCkKPj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqAgaXRzX3BhcnNlX2Jhc2VyKGksICZpdHNfZGF0YS5iYXNlcltpXSk7Cj4+PiAgwqAgfQo+
Pj4gIMKgICtzdGF0aWMgdm9pZCBpdHNfc2V0dXBfYmFzZXIoaW50IGksIHN0cnVjdCBpdHNfYmFz
ZXIgKmJhc2VyKQo+Pj4gK3sKPj4+ICvCoMKgwqAgdW5zaWduZWQgbG9uZyBuID0gKGJhc2VyLT5u
cl9wYWdlcyAqIGJhc2VyLT5wc3opID4+IFBBR0VfU0hJRlQ7Cj4+PiArwqDCoMKgIHVuc2lnbmVk
IGxvbmcgb3JkZXIgPSBpc19wb3dlcl9vZl8yKG4pID8gZmxzKG4pIDogZmxzKG4pICsgMTsKPj4+
ICvCoMKgwqAgdTY0IHZhbDsKPj4+ICsKPj4+ICvCoMKgwqAgYmFzZXItPnRhYmxlX2FkZHIgPSAo
dTY0KXZpcnRfdG9fcGh5cyhhbGxvY19wYWdlcyhvcmRlcikpOwo+Pj4gKwo+Pj4gK8KgwqDCoCB2
YWwgPSAoKHU2NCliYXNlci0+dGFibGVfYWRkcsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHwKPj4+ICvCoMKgwqDCoMKgwqDCoCAoKHU2NCliYXNlci0+dHlwZcKgwqDCoCA8
PCBHSVRTX0JBU0VSX1RZUEVfU0hJRlQpwqDCoMKgIHwKPj4+ICvCoMKgwqDCoMKgwqDCoCAoKHU2
NCkoYmFzZXItPmVzeiAtIDEpwqDCoMKgIDw8IEdJVFNfQkFTRVJfRU5UUllfU0laRV9TSElGVCnC
oMKgwqAgfAo+Pj4gK8KgwqDCoMKgwqDCoMKgICgoYmFzZXItPm5yX3BhZ2VzIC0gMSnCoMKgwqAg
PDwgR0lUU19CQVNFUl9QQUdFU19TSElGVCnCoMKgwqAgfAo+Pj4gK8KgwqDCoMKgwqDCoMKgICh1
NjQpYmFzZXItPmluZGlyZWN0wqDCoMKgIDw8IDYywqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHwKPj4KPj4gSSBoYXZlbid0IHNlZW4gdGhlICducl9wYWdlcycgYW5kICdpbmRpcmVjdCcg
YXJlIHByb2dyYW1tZWQgYW55d2hlcmUKPj4gZXhjZXB0IGluIGl0c19wYXJzZV9iYXNlcigpLiBJ
dCBsb29rcyBsaWtlIHRoZXkncmUgdHJlYXRlZCBhcyBSTyAoYnV0Cj4+IHRoZXkgc2hvdWxkbid0
KSBhbmQgSSBub3cgZG9uJ3QgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdG8gcGFyc2UgdGhlbSBpbgo+
PiBpdHNfcGFyc2VfYmFzZXIoKSwgaW4gcGF0Y2gjNS4KPiAKPiBGaXJzdCBvZiBhbGwgcGxlYXNl
IGZvcmdpdmUgbWUgZm9yIHRoZSBkZWxheS4KCk5ldmVyIG1pbmQuCgo+IAo+IEkgYWdyZWUgd2l0
aCB5b3Ugb24gbnJfcGFnZXMuIEhvd2V2ZXIgaW5kaXJlY3QgYWxzbyBpbmRpY2F0ZXMgdGhlIEJB
U0VSCj4gY2FwYWJpbGl0eSB0byBzdXBwb3J0IG9yIG5vdCAyIGxldmVsIHRhYmxlcy4gU28gSSB0
aGluayBpdCBtYWtlcyBzZW5zZQo+IHRvIHJlYWQgaXQgb24gaW5pdC4KClllcywgeW91J3JlIHJp
Z2h0LiBBcyB0aGUgc3BlYyBzYXlzLCB0aGUgSW5kaXJlY3QgZmllbGQgImlzIFJBWi9XSSBmb3IK
R0lDIGltcGxlbWVudGF0aW9ucyB0aGF0IG9ubHkgc3VwcG9ydCBmbGF0IHRhYmxlcyIuCgoKVGhh
bmtzLApaZW5naHVpCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
