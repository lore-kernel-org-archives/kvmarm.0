Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C61C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 14:16:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32DEC208E4
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 14:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32DEC208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D9084C0B8;
	Mon, 17 Aug 2020 10:16:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J6YPMh2RuwVD; Mon, 17 Aug 2020 10:16:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 800164C0A8;
	Mon, 17 Aug 2020 10:16:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AABBE4BFD4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 10:15:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 73a-btaH7Nv7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 10:15:58 -0400 (EDT)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC9F04C0A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 10:15:57 -0400 (EDT)
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.54])
 by Forcepoint Email with ESMTP id 5AC8B462E995EFE33ED2;
 Mon, 17 Aug 2020 22:15:51 +0800 (CST)
Received: from [10.174.186.8] (10.174.186.8) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Mon, 17
 Aug 2020 22:15:50 +0800
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
To: Marc Zyngier <maz@kernel.org>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
 <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
 <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
From: yezengruan <yezengruan@huawei.com>
Message-ID: <3ff3b016-3f63-7d03-ed4b-c98d74db4af8@huawei.com>
Date: Mon, 17 Aug 2020 22:15:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.186.8]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Cc: joelaf@google.com,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

T24gMjAyMC84LzE3IDIwOjI1LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMC0wOC0xNyAx
MzowMywgeWV6ZW5ncnVhbiB3cm90ZToKPj4gT24gMjAyMC84LzE3IDEwOjAzLCBTZXJnZXkgU2Vu
b3poYXRza3kgd3JvdGU6Cj4+PiBPbiAoMjAvMDcvMjEgMTM6MTcpLCBTZXJnZXkgU2Vub3poYXRz
a3kgd3JvdGU6Cj4+Pj4gSGVsbG8sCj4+Pj4KPj4+PiDCoMKgwqDCoFJGQwo+Pj4+Cj4+Pj4gwqDC
oMKgwqBXZSBub3RpY2VkIHRoYXQgaW4gYSBudW1iZXIgb2YgY2FzZXMgd2hlbiB3ZSB3YWtlX3Vw
X3Byb2Nlc3MoKQo+Pj4+IG9uIGFybTY0IGd1ZXN0IHdlIGVuZCB1cCBlbnF1ZXVpbmcgdGhhdCB0
YXNrIG9uIGEgcHJlZW1wdGVkIFZDUFUuIFRoZSBjdWxwcml0Cj4+Pj4gYXBwZWFycyB0byBiZSB0
aGUgZmFjdCB0aGF0IGFybTY0IGd1ZXN0cyBhcmUgbm90IGF3YXJlIG9mIFZDUFUgcHJlZW1wdGlv
bgo+Pj4+IGFzIHN1Y2gsIHNvIHdoZW4gc2NoZWQgcGlja3MgdXAgYW4gaWRsZSBWQ1BVIGl0IGFs
d2F5cyBhc3N1bWVzIHRoYXQgVkNQVQo+Pj4+IGlzIGF2YWlsYWJsZToKPj4+Pgo+Pj4+IMKgwqDC
oMKgwqAgd2FrZV91cF9wcm9jZXNzKCkKPj4+PiDCoMKgwqDCoMKgwqAgdHJ5X3RvX3dha2VfdXAo
KQo+Pj4+IMKgwqDCoMKgwqDCoMKgIHNlbGVjdF90YXNrX3JxX2ZhaXIoKQo+Pj4+IMKgwqDCoMKg
wqDCoMKgwqAgYXZhaWxhYmxlX2lkbGVfY3B1KCkKPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgdmNw
dV9pc19wcmVlbXB0ZWQoKcKgwqDCoCAvLyByZXR1cm4gZmFsc2U7Cj4+Pj4KPj4+PiBXaGljaCBp
cywgb2J2aW91c2x5LCBub3QgdGhlIGNhc2UuCj4+Pj4KPj4+PiBUaGlzIFJGQyBwYXRjaCBzZXQg
YWRkcyBhIHNpbXBsZSB2Y3B1X2lzX3ByZWVtcHRlZCgpIGltcGxlbWVudGF0aW9uIHNvCj4+Pj4g
dGhhdCBzY2hlZHVsZXIgY2FuIG1ha2UgYmV0dGVyIGRlY2lzaW9ucyB3aGVuIGl0IHNlYXJjaCBm
b3IgdGhlIGlkbGUKPj4+PiAodilDUFUuCj4+PiBIaSwKPj4+Cj4+PiBBIGdlbnRsZSBwaW5nLgo+
Pj4KPj4+IMKgwqDCoMKgLXNzCj4+PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwo+Pj4ga3ZtYXJtIG1haWxpbmcgbGlzdAo+Pj4ga3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQo+Pj4gaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0KPj4+IC4KPj4KPj4gSGkgU2VyZ2V5LAo+Pgo+PiBJIGhhdmUgYSBzZXQg
b2YgcGF0Y2hlcyBzaW1pbGFyIHRvIHlvdXJzLgo+Pgo+PiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9sa21sLzIwMTkxMjI2MTM1ODMzLjEwNTItMS15ZXplbmdydWFuQGh1YXdlaS5jb20vCj4KPiBJ
dCByZWFsbHkgaXNuJ3QgdGhlIHNhbWUgdGhpbmcgYXQgYWxsLiBZb3UgYXJlIGV4cG9zaW5nIFBW
IHNwaW5sb2NrcywKPiB3aGlsZSBTZXJnZXkgZXhwb3NlcyBwcmVlbXB0aW9uIHRvIHZjcHVzLiBU
aGUgZm9ybWVyIGlzIGEgbWFzc2l2ZSwKPiBhbmQgcHJvYmFibHkgdW5uZWNlc3Nhcnkgc3VwZXJz
ZXQgb2YgdGhlIGxhdGVyLCB3aGljaCBvbmx5IGltcGFjdHMKPiB0aGUgc2NoZWR1bGVyIChpdCBk
b2Vzbid0IGNoYW5nZSB0aGUgd2F5IGxvY2tzIGFyZSBpbXBsZW1lbnRlZCkuCj4KPiBZb3UgcmVh
bGx5IHNob3VsZG4ndCBjb25mbGF0ZSB0aGUgdHdvICh3aGljaCB5b3UgaGF2ZSBkb25lIGluIHlv
dXIKPiBzZXJpZXMpLgo+Cj4gwqDCoMKgwqDCoMKgwqAgTS4KCgpIaSBNYXJjLAoKQWN0dWFsbHks
IGJvdGggc2VyaWVzIHN1cHBvcnQgcGFyYXZpcnR1YWxpemF0aW9uIHZjcHVfaXNfcHJlZW1wdGVk
LiBNeQpzZXJpZXMgcmVnYXJkIHRoaXMgYXMgUFYgbG9jaywgYnV0IG9ubHkgdGhlIHZjcHVfaXNf
cHJlZW1wdGVkIGludGVyZmFjZQpvZiBwdl9sb2NrX29wdCBpcyBpbXBsZW1lbnRlZC4KCkV4Y2Vw
dCB3YWtlX3VwX3Byb2Nlc3MoKSwgdGhlIHZjcHVfaXNfcHJlZW1wdGVkIGludGVyZmFjZSBvZiB0
aGUgY3VycmVudAprZXJuZWwgaXMgdXNlZCBpbiB0aGUgZm9sbG93aW5nIHNjZW5hcmlvczoKCmtl
cm5lbC9zY2hlZC9jb3JlLmM6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIDwtLS0tIHdha2VfdXBfcHJvY2VzcygpCi0tLS0tLS0tLS0tLS0tLS0t
LS0tCmF2YWlsYWJsZV9pZGxlX2NwdQrCoMKgwqAgdmNwdV9pc19wcmVlbXB0ZWQKCmtlcm5lbC9s
b2NraW5nL3J3c2VtLmM6Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCnJ3c2VtX29wdGltaXN0aWNf
c3BpbgrCoMKgwqAgcndzZW1fc3Bpbl9vbl9vd25lcgrCoMKgwqAgwqDCoMKgIG93bmVyX29uX2Nw
dQrCoMKgwqAgwqDCoMKgIMKgwqDCoCB2Y3B1X2lzX3ByZWVtcHRlZAoKa2VybmVsL2xvY2tpbmcv
bXV0ZXguYzoKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KbXV0ZXhfb3B0aW1pc3RpY19zcGluCsKg
wqDCoCBtdXRleF9zcGluX29uX293bmVyCsKgwqDCoCDCoMKgwqAgdmNwdV9pc19wcmVlbXB0ZWQK
Cmtlcm5lbC9sb2NraW5nL29zcV9sb2NrLmM6Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCm9z
cV9sb2NrCsKgwqDCoCB2Y3B1X2lzX3ByZWVtcHRlZAoKClRoYW5rcywKClplbmdydWFuCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
