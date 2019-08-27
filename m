Return-Path: <SRS0=Zu31=WX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D797C41514
	for <kvmarm@archiver.kernel.org>; Tue, 27 Aug 2019 07:53:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB408206BA
	for <kvmarm@archiver.kernel.org>; Tue, 27 Aug 2019 07:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB408206BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 255144A571;
	Tue, 27 Aug 2019 03:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BDjWJMGtUgCu; Tue, 27 Aug 2019 03:53:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E58D14A599;
	Tue, 27 Aug 2019 03:53:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8DB44A599
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Aug 2019 03:53:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U4oohdBh9l5E for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Aug 2019 03:53:30 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FDC84A571
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Aug 2019 03:53:30 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 5B6E43082E25;
 Tue, 27 Aug 2019 07:53:29 +0000 (UTC)
Received: from [10.36.116.105] (ovpn-116-105.ams2.redhat.com [10.36.116.105])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B010C600D1;
 Tue, 27 Aug 2019 07:53:25 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Use a single IO device per
 redistributor
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20190823173330.23342-1-eric.auger@redhat.com>
 <f5b47614-de48-f3cb-0e6f-8a667cb951c0@redhat.com>
 <5cdcfe9e-98d8-454e-48e7-992fe3ee5eae@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <ccb49856-f958-8bea-4b27-9a808415c43d@redhat.com>
Date: Tue, 27 Aug 2019 09:53:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5cdcfe9e-98d8-454e-48e7-992fe3ee5eae@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.46]); Tue, 27 Aug 2019 07:53:29 +0000 (UTC)
Cc: zhang.zhanghailiang@huawei.com, andre.przywara@arm.com, qemu-arm@nongnu.org
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

SGkgWmVuZ2h1aSwKT24gOC8yNy8xOSA5OjQ5IEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+IEhpIEVy
aWMsCj4gCj4gVGhhbmtzIGZvciB0aGlzIHBhdGNoIQo+IAo+IE9uIDIwMTkvOC8yNCAxOjUyLCBB
dWdlciBFcmljIHdyb3RlOgo+PiBIaSBaZW5naHVpLCBNYXJjLAo+Pgo+PiBPbiA4LzIzLzE5IDc6
MzMgUE0sIEVyaWMgQXVnZXIgd3JvdGU6Cj4+PiBBdCB0aGUgbW9tZW50IHdlIHVzZSAyIElPIGRl
dmljZXMgcGVyIEdJQ3YzIHJlZGlzdHJpYnV0b3I6IG9uZQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBeXl4KPj4+IG9uZSBm
b3IgdGhlIFJEX2Jhc2UgZnJhbWUgYW5kIG9uZSBmb3IgdGhlIFNHSV9iYXNlIGZyYW1lLgo+IMKg
IF5eXgo+Pj4KPj4+IEluc3RlYWQgd2UgY2FuIHVzZSBhIHNpbmdsZSBJTyBkZXZpY2UgcGVyIHJl
ZGlzdHJpYnV0b3IgKHRoZSAyCj4+PiBmcmFtZXMgYXJlIGNvbnRpZ3VvdXMpLiBUaGlzIHNhdmVz
IHNsb3RzIG9uIHRoZSBLVk1fTU1JT19CVVMKPj4+IHdoaWNoIGlzIGN1cnJlbnRseSBsaW1pdGVk
IHRvIE5SX0lPQlVTX0RFVlMgKDEwMDApLgo+Pj4KPj4+IFRoaXMgY2hhbmdlIGFsbG93cyB0byBp
bnN0YW50aWF0ZSB1cCB0byA1MTIgcmVkaXN0cmlidXRvcnMgYW5kIG1heQo+Pj4gc3BlZWQgdGhl
IGd1ZXN0IGJvb3Qgd2l0aCBhIGxhcmdlIG51bWJlciBvZiBWQ1BVcy4KPj4+Cj4+PiBTaWduZWQt
b2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+Cj4+IEkgdGVzdGVk
IHRoaXMgcGF0Y2ggd2l0aCBiZWxvdyBrZXJuZWwgYW5kIFFFTVUgYnJhbmNoZXM6Cj4+IGtlcm5l
bDogaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9saW51eC90cmVlLzI1NmZpeC12MQo+PiAoTWFy
YydzIHBhdGNoICsgdGhpcyBwYXRjaCkKPj4gaHR0cHM6Ly9naXRodWIuY29tL2VhdWdlci9xZW11
L3RyZWUvdjQuMS4wLTI1NmZpeC1yZmMxLXJjMAo+PiAoaGVhZGVyIHVwZGF0ZSArIGt2bV9hcm1f
Z2ljX3NldF9pcnEgbW9kaWZpY2F0aW9uKQo+IAo+IEkgYWxzbyB0ZXN0ZWQgdGhlc2UgdGhyZWUg
Y2hhbmdlcyBvbiBIaVNpIEQwNSAod2l0aCA2NCBwY3B1cyksIGFuZCB5ZXMsCj4gSSBjYW4gZ2V0
IGEgNTEyVSBndWVzdCB0byBib290IHByb3Blcmx5IG5vdy4KCk1hbnkgdGhhbmtzIGZvciB0aGUg
dGVzdGluZyAoYW5kIHRoZSBidWcgcmVwb3J0KS4gSSB3aWxsIGZvcm1hbGx5IHBvc3QKdGhlIFFF
TVUgY2hhbmdlcyBhc2FwLgoKVGhhbmtzCgpFcmljCj4gCj4gVGVzdGVkLWJ5OiBaZW5naHVpIFl1
IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPiAKPj4gT24gYSBtYWNoaW5lIHdpdGggMjI0IHBjcHVz
LCBJIHdhcyBhYmxlIHRvIGJvb3QgYSA1MTIgdmNwdSBndWVzdC4KPj4KPj4gQXMgZXhwZWN0ZWQs
IHFlbXUgb3V0cHV0cyB3YXJuaW5nczoKPj4KPj4gcWVtdS1zeXN0ZW0tYWFyY2g2NDogd2Fybmlu
ZzogTnVtYmVyIG9mIFNNUCBjcHVzIHJlcXVlc3RlZCAoNTEyKSBleGNlZWRzCj4+IHRoZSByZWNv
bW1lbmRlZCBjcHVzIHN1cHBvcnRlZCBieSBLVk0gKDIyNCkKPj4gcWVtdS1zeXN0ZW0tYWFyY2g2
NDogd2FybmluZzogTnVtYmVyIG9mIGhvdHBsdWdnYWJsZSBjcHVzIHJlcXVlc3RlZAo+PiAoNTEy
KSBleGNlZWRzIHRoZSByZWNvbW1lbmRlZCBjcHVzIHN1cHBvcnRlZCBieSBLVk0gKDIyNCkKPj4K
Pj4gb24gdGhlIGd1ZXN0OiBnZXRjb25mIF9OUFJPQ0VTU09SU19PTkxOIHJldHVybnMgNTEyCj4+
Cj4+IFRoZW4gSSBoYXZlIG5vIGNsdWUgYWJvdXQgd2hhdCBjYW4gYmUgZXhwZWN0ZWQgb2Ygc3Vj
aCBvdmVyY29tbWl0IGNvbmZpZwo+PiBhbmQgSSBoYXZlIG5vdCBmdXJ0aGVyIGV4ZXJjaXNlZCB0
aGUgZ3Vlc3QgYXQgdGhlIG1vbWVudC4gQnV0IGF0IGxlYXN0Cj4+IGl0IHNlZW1zIHRvIGJvb3Qg
cHJvcGVybHkuIEkgYWxzbyB0ZXN0ZWQgd2l0aG91dCBvdmVyY29tbWl0IGFuZCBpdCBzZWVtcwo+
PiB0byBiZWhhdmUgYXMgYmVmb3JlIChib290LCBtaWdyYXRpb24pLgo+Pgo+PiBJIHN0aWxsIG5l
ZWQgdG8gbG9vayBhdCB0aGUgbWlncmF0aW9uIG9mID4gMjU2dmNwdSBndWVzdCBhdCBxZW11IGxl
dmVsLgo+IAo+IExldCB1cyBrbm93IGlmIGZ1cnRoZXIgdGVzdHMgYXJlIG5lZWRlZC4KPiAKPiAK
PiBUaGFua3MsCj4gemVuZ2h1aQo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
