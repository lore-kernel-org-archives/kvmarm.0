Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B03C433DF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 03:39:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1ADB207E8
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 03:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1ADB207E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CAF44B1E7;
	Thu,  2 Jul 2020 23:39:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F+Ru-Xz2QLuS; Thu,  2 Jul 2020 23:39:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B7A4B230;
	Thu,  2 Jul 2020 23:39:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A55834B21A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 23:39:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g7bnRjWYCVUM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 23:39:27 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 253FB4B1EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 23:39:27 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id E3CDB7BB1C4195A30671;
 Fri,  3 Jul 2020 11:39:21 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Jul 2020
 11:39:11 +0800
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
 <05a3da5fa35568606e55eb6428ce91d8@kernel.org>
 <69a37427-7e93-3411-f61c-50525a0ca3e1@redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <2a50fc3a-c3d1-0fc9-dccc-d878ce0a7bb5@huawei.com>
Date: Fri, 3 Jul 2020 11:39:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <69a37427-7e93-3411-f61c-50525a0ca3e1@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
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

CgpPbiA3LzIvMjAyMCA5OjQyIFBNLCBBdWdlciBFcmljIHdyb3RlOgo+IEhpIE1hcmMsCj4gCj4g
T24gNy8yLzIwIDM6MDggUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkgRXJpYywKPj4KPj4g
T24gMjAyMC0wNy0wMiAxMzo1NywgQXVnZXIgRXJpYyB3cm90ZToKPj4+IEhpIEppbmd5aSwKPj4+
Cj4+PiBPbiA3LzIvMjAgNTowMSBBTSwgSmluZ3lpIFdhbmcgd3JvdGU6Cj4+Pj4gSWYgZ2ljdjQu
MShzZ2kgaGFyZHdhcmUgaW5qZWN0aW9uKSBzdXBwb3J0ZWQsIHdlIHRlc3QgaXBpIGluamVjdGlv
bgo+Pj4+IHZpYSBody9zdyB3YXkgc2VwYXJhdGVseS4KPj4+Pgo+Pj4+IFNpZ25lZC1vZmYtYnk6
IEppbmd5aSBXYW5nIDx3YW5namluZ3lpMTFAaHVhd2VpLmNvbT4KPj4+PiAtLS0KPj4+PiAgwqBh
cm0vbWljcm8tYmVuY2guY8KgwqDCoCB8IDQ1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tCj4+Pj4gIMKgbGliL2FybS9hc20vZ2ljLXYzLmggfMKgIDMgKysrCj4+
Pj4gIMKgbGliL2FybS9hc20vZ2ljLmjCoMKgwqAgfMKgIDEgKwo+Pj4+ICDCoDMgZmlsZXMgY2hh
bmdlZCwgNDQgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPj4+Pgo+Pj4+IGRpZmYgLS1n
aXQgYS9hcm0vbWljcm8tYmVuY2guYyBiL2FybS9taWNyby1iZW5jaC5jCj4+Pj4gaW5kZXggZmM0
ZDM1Ni4uODBkOGRiMyAxMDA2NDQKPj4+PiAtLS0gYS9hcm0vbWljcm8tYmVuY2guYwo+Pj4+ICsr
KyBiL2FybS9taWNyby1iZW5jaC5jCj4+Pj4gQEAgLTkxLDkgKzkxLDQwIEBAIHN0YXRpYyB2b2lk
IGdpY19wcmVwX2NvbW1vbih2b2lkKQo+Pj4+ICDCoMKgwqDCoCBhc3NlcnQoaXJxX3JlYWR5KTsK
Pj4+PiAgwqB9Cj4+Pj4KPj4+PiAtc3RhdGljIHZvaWQgaXBpX3ByZXAodm9pZCkKPj4+PiArc3Rh
dGljIGJvb2wgaXBpX3ByZXAodm9pZCkKPj4+IEFueSByZWFzb24gd2h5IHRoZSBib29sIHJldHVy
bmVkIHZhbHVlIGlzIHByZWZlcnJlZCBvdmVyIHRoZSBzdGFuZGFyZAo+Pj4gaW50Pwo+Pj4+ICDC
oHsKPj4+PiArwqDCoMKgIHUzMiB2YWw7Cj4+Pj4gKwo+Pj4+ICvCoMKgwqAgdmFsID0gcmVhZGwo
dmdpY19kaXN0X2Jhc2UgKyBHSUNEX0NUTFIpOwo+Pj4+ICvCoMKgwqAgaWYgKHJlYWRsKHZnaWNf
ZGlzdF9iYXNlICsgR0lDRF9UWVBFUjIpICYgR0lDRF9UWVBFUjJfbkFTU0dJY2FwKSB7Cj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIHZhbCAmPSB+R0lDRF9DVExSX0VOQUJMRV9HMUE7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgIHZhbCAmPSB+R0lDRF9DVExSX25BU1NHSXJlcTsKPj4+PiArwqDCoMKgwqDCoMKg
wqAgd3JpdGVsKHZhbCwgdmdpY19kaXN0X2Jhc2UgKyBHSUNEX0NUTFIpOwo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCB2YWwgfD0gR0lDRF9DVExSX0VOQUJMRV9HMUE7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKg
IHdyaXRlbCh2YWwsIHZnaWNfZGlzdF9iYXNlICsgR0lDRF9DVExSKTsKPj4+IFdoeSBkbyB3ZSBu
ZWVkIHRoaXMgRzFBIGRhbmNlPwo+Pgo+PiBCZWNhdXNlIGl0IGlzbid0IGxlZ2FsIHRvIGNoYW5n
ZSB0aGUgU0dJIGJlaGF2aW91ciB3aGVuIGdyb3VwcyBhcmUgZW5hYmxlZC4KPj4gWWVzLCBpdCBp
cyBkZXNjcmliZWQgaW4gdGhpcyBiaXQgb2YgZG9jdW1lbnRhdGlvbiBub2JvZHkgaGFzIGFjY2Vz
cyB0by4KPiAKPiBPSyB0aGFuayB5b3UgZm9yIHRoZSBleHBsYW5hdGlvbi4gSmluZ3lpLCBtYXli
ZSBhZGQgYSBjb21tZW50IHRvIGF2b2lkCj4gdGhlIHF1ZXN0aW9uIGFnYWluIDstKQo+IAo+IFRo
YW5rcwo+IAo+IEVyaWMKCk9rYXksIEkgd2lsbCBhZGQgYSBjb21tZW50IGhlcmUgaW4gdGhlIG5l
eHQgdmVyc2lvbi4KClRoYW5rcywKSmluZ3lpCgo+Pgo+PiBBbmQgdGhpcyBjb2RlIG5lZWRzIHRv
IHRyYWNrIFJXUCBvbiBkaXNhYmxpbmcgR3JvdXAtMS4KPj4KPj4gIMKgwqDCoMKgwqDCoMKgIE0u
Cj4gCj4gCj4gLgo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
