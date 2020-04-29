Return-Path: <SRS0=ff4l=6N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B377C83003
	for <kvmarm@archiver.kernel.org>; Wed, 29 Apr 2020 07:35:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77CF7206D9
	for <kvmarm@archiver.kernel.org>; Wed, 29 Apr 2020 07:35:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77CF7206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0C7E4B2DD;
	Wed, 29 Apr 2020 03:35:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ylz1z7d4bY2t; Wed, 29 Apr 2020 03:35:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D92864B2E8;
	Wed, 29 Apr 2020 03:35:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE684B30D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 22:20:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BUQ4wLSujmis for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 22:20:28 -0400 (EDT)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91B594B2F9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 22:20:27 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R731e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01355;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=36; SR=0;
 TI=SMTPD_---0Tx-0ovS_1588126817; 
Received: from 30.27.118.60(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0Tx-0ovS_1588126817) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 29 Apr 2020 10:20:19 +0800
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
To: Thomas Huth <thuth@redhat.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Cornelia Huck <cohuck@redhat.com>
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
 <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
 <20200422154543.2efba3dd.cohuck@redhat.com>
 <dc5e0fa3-558b-d606-bda9-ed281cf9e9ae@de.ibm.com>
 <20200422180403.03f60b0c.cohuck@redhat.com>
 <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
 <20200423123901.72a4c6a4.cohuck@redhat.com>
 <71344f73-c34f-a373-49d1-5d839c6be5f6@linux.alibaba.com>
 <1d73b700-4a20-3d7a-66d1-29b5afa03f4d@de.ibm.com>
 <73f6ecd0-ac47-eaad-0e4f-2d41c2b34450@redhat.com>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <1b8167f2-eb91-5f17-8dc4-dcfaa5bbb075@linux.alibaba.com>
Date: Wed, 29 Apr 2020 10:20:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <73f6ecd0-ac47-eaad-0e4f-2d41c2b34450@redhat.com>
X-Mailman-Approved-At: Wed, 29 Apr 2020 03:35:54 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-mips@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, maz@kernel.org, joro@8bytes.org, x86@kernel.org,
 mingo@redhat.com, gor@linux.ibm.com, kvm-ppc@vger.kernel.org, bp@alien8.de,
 tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, sean.j.christopherson@intel.com,
 linux-kernel@vger.kernel.org, mpe@ellerman.id.au, pbonzini@redhat.com,
 vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
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

CgpPbiAyMDIwLzQvMjYgMjA6NTksIFRob21hcyBIdXRoIHdyb3RlOgo+IE9uIDIzLzA0LzIwMjAg
MTMuMDAsIENocmlzdGlhbiBCb3JudHJhZWdlciB3cm90ZToKPj4KPj4KPj4gT24gMjMuMDQuMjAg
MTI6NTgsIFRpYW5qaWEgWmhhbmcgd3JvdGU6Cj4+Pgo+Pj4KPj4+IE9uIDIwMjAvNC8yMyAxODoz
OSwgQ29ybmVsaWEgSHVjayB3cm90ZToKPj4+PiBPbiBUaHUsIDIzIEFwciAyMDIwIDExOjAxOjQz
ICswODAwCj4+Pj4gVGlhbmppYSBaaGFuZyA8dGlhbmppYS56aGFuZ0BsaW51eC5hbGliYWJhLmNv
bT4gd3JvdGU6Cj4+Pj4KPj4+Pj4gT24gMjAyMC80LzIzIDA6MDQsIENvcm5lbGlhIEh1Y2sgd3Jv
dGU6Cj4+Pj4+PiBPbiBXZWQsIDIyIEFwciAyMDIwIDE3OjU4OjA0ICswMjAwCj4+Pj4+PiBDaHJp
c3RpYW4gQm9ybnRyYWVnZXIgPGJvcm50cmFlZ2VyQGRlLmlibS5jb20+IHdyb3RlOgo+Pj4+Pj4g
ICAgCj4+Pj4+Pj4gT24gMjIuMDQuMjAgMTU6NDUsIENvcm5lbGlhIEh1Y2sgd3JvdGU6Cj4+Pj4+
Pj4+IE9uIFdlZCwgMjIgQXByIDIwMjAgMjA6NTg6MDQgKzA4MDAKPj4+Pj4+Pj4gVGlhbmppYSBa
aGFuZyA8dGlhbmppYS56aGFuZ0BsaW51eC5hbGliYWJhLmNvbT4gd3JvdGU6Cj4+Pj4+Pj4+ICAg
ICAgIAo+Pj4+Pj4+Pj4gSW4gdGhlIGN1cnJlbnQga3ZtIHZlcnNpb24sICdrdm1fcnVuJyBoYXMg
YmVlbiBpbmNsdWRlZCBpbiB0aGUgJ2t2bV92Y3B1Jwo+Pj4+Pj4+Pj4gc3RydWN0dXJlLiBFYXJs
aWVyIHRoYW4gaGlzdG9yaWNhbCByZWFzb25zLCBtYW55IGt2bS1yZWxhdGVkIGZ1bmN0aW9uCj4+
Pj4+Pj4+Cj4+Pj4+Pj4+IHMvRWFybGllciB0aGFuL0Zvci8gPwo+Pj4+Pj4+PiAgICAgICAKPj4+
Pj4+Pj4+IHBhcmFtZXRlcnMgcmV0YWluIHRoZSAna3ZtX3J1bicgYW5kICdrdm1fdmNwdScgcGFy
YW1ldGVycyBhdCB0aGUgc2FtZSB0aW1lLgo+Pj4+Pj4+Pj4gVGhpcyBwYXRjaCBkb2VzIGEgdW5p
ZmllZCBjbGVhbnVwIG9mIHRoZXNlIHJlbWFpbmluZyByZWR1bmRhbnQgcGFyYW1ldGVycy4KPj4+
Pj4+Pj4+Cj4+Pj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBUaWFuamlhIFpoYW5nIDx0aWFuamlhLnpo
YW5nQGxpbnV4LmFsaWJhYmEuY29tPgo+Pj4+Pj4+Pj4gLS0tCj4+Pj4+Pj4+PiAgwqDCoCBhcmNo
L3MzOTAva3ZtL2t2bS1zMzkwLmMgfCAzNyArKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tCj4+Pj4+Pj4+PiAgwqDCoCAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwg
MTUgZGVsZXRpb25zKC0pCj4+Pj4+Pj4+Pgo+Pj4+Pj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvczM5
MC9rdm0va3ZtLXMzOTAuYyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYwo+Pj4+Pj4+Pj4gaW5k
ZXggZTMzNWE3ZTVlYWQ3Li5kN2JiMmU3YTA3ZmYgMTAwNjQ0Cj4+Pj4+Pj4+PiAtLS0gYS9hcmNo
L3MzOTAva3ZtL2t2bS1zMzkwLmMKPj4+Pj4+Pj4+ICsrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMz
OTAuYwo+Pj4+Pj4+Pj4gQEAgLTQxNzYsOCArNDE3Niw5IEBAIHN0YXRpYyBpbnQgX192Y3B1X3J1
bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+Pj4+Pj4+PiAgwqDCoMKgwqDCoMKgIHJldHVybiBy
YzsKPj4+Pj4+Pj4+ICDCoMKgIH0KPj4+Pj4+Pj4+ICDCoMKgIC1zdGF0aWMgdm9pZCBzeW5jX3Jl
Z3NfZm10MihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcnVuICprdm1fcnVuKQo+
Pj4+Pj4+Pj4gK3N0YXRpYyB2b2lkIHN5bmNfcmVnc19mbXQyKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkKPj4+Pj4+Pj4+ICDCoMKgIHsKPj4+Pj4+Pj4+ICvCoMKgwqAgc3RydWN0IGt2bV9ydW4gKmt2
bV9ydW4gPSB2Y3B1LT5ydW47Cj4+Pj4+Pj4+PiAgwqDCoMKgwqDCoMKgIHN0cnVjdCBydW50aW1l
X2luc3RyX2NiICpyaWNjYjsKPj4+Pj4+Pj4+ICDCoMKgwqDCoMKgwqAgc3RydWN0IGdzX2NiICpn
c2NiOwo+Pj4+Pj4+Pj4gIMKgwqAgQEAgLTQyMzUsNyArNDIzNiw3IEBAIHN0YXRpYyB2b2lkIHN5
bmNfcmVnc19mbXQyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9ydW4gKmt2bV9y
dW4pCj4+Pj4+Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+Pj4+Pj4+Pj4gIMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGlmICh2Y3B1LT5hcmNoLmdzX2VuYWJsZWQpIHsKPj4+Pj4+Pj4+ICDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGN1cnJlbnQtPnRocmVhZC5nc19jYiA9IChzdHJ1Y3Qg
Z3NfY2IgKikKPj4+Pj4+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICZ2Y3B1LT5ydW4tPnMucmVncy5nc2NiOwo+Pj4+Pj4+Pj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmt2bV9ydW4tPnMucmVncy5nc2Ni
Owo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBOb3Qgc3VyZSBpZiB0aGVzZSBjaGFuZ2VzICh2Y3B1LT5ydW4t
PiA9PiBrdm1fcnVuLT4pIGFyZSByZWFsbHkgd29ydGgKPj4+Pj4+Pj4gaXQuIChJdCBzZWVtcyB0
aGV5IGFtb3VudCB0byBhdCBsZWFzdCBhcyBtdWNoIGFzIHRoZSBjaGFuZ2VzIGFkdmVydGlzZWQK
Pj4+Pj4+Pj4gaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9uLikKPj4+Pj4+Pj4KPj4+Pj4+Pj4gT3Ro
ZXIgb3BpbmlvbnM/Cj4+Pj4+Pj4KPj4+Pj4+PiBBZ3JlZWQuIEl0IGZlZWxzIGtpbmQgb2YgcmFu
ZG9tLiBNYXliZSBqdXN0IGRvIHRoZSBmaXJzdCBsaW5lIChtb3ZlIGt2bV9ydW4gZnJvbSB0aGUK
Pj4+Pj4+PiBmdW5jdGlvbiBwYXJhbWV0ZXIgbGlzdCBpbnRvIHRoZSB2YXJpYWJsZSBkZWNsYXJh
dGlvbik/IE5vdCBzdXJlIGlmIHRoaXMgaXMgYmV0dGVyLgo+Pj4+Pj4+ICAgIAo+Pj4+Pj4KPj4+
Pj4+IFRoZXJlJ3MgbW9yZSBpbiB0aGlzIHBhdGNoIHRoYXQgSSBjdXQuLi4gYnV0IEkgdGhpbmsg
anVzdCBtb3ZpbmcKPj4+Pj4+IGt2bV9ydW4gZnJvbSB0aGUgcGFyYW1ldGVyIGxpc3Qgd291bGQg
YmUgbXVjaCBsZXNzIGRpc3J1cHRpdmUuCj4+Pj4+PiAgICAgCj4+Pj4+Cj4+Pj4+IEkgdGhpbmsg
dGhlcmUgYXJlIHR3byBraW5kcyBvZiBjb2RlKGB2Y3B1LT5ydW4tPmAgYW5kIGBrdm1fcnVuLT5g
KSwgYnV0Cj4+Pj4+IHRoZXJlIHdpbGwgYmUgbW9yZSBkaXNydXB0aXZlLCBub3QgbGVzcy4KPj4+
Pgo+Pj4+IEkganVzdCBmYWlsIHRvIHNlZSB0aGUgYmVuZWZpdDsgc3VyZSwga3ZtX3J1bi0+IGlz
IGNvbnZlbmllbnQsIGJ1dCB0aGUKPj4+PiBjdXJyZW50IGNvZGUgaXMganVzdCBmaW5lLCBhbmQg
YW55IHJld29yayBzaG91bGQgYmUgYmFsYW5jZWQgYWdhaW5zdAo+Pj4+IHRoZSBjb3N0IChlLmcu
IGNsdXR0ZXJpbmcgZ2l0IGFubm90YXRlKS4KPj4+Pgo+Pj4KPj4+IGNsdXR0ZXJpbmcgZ2l0IGFu
bm90YXRlID8gRG9lcyBpdCBtZWFuIEZpeCB4eHh4ICgiY29tbWVudCIpLiBJcyBpdCBwb3NzaWJs
ZSB0byBzb2x2ZSB0aGlzIHByb2JsZW0gYnkgc3BsaXR0aW5nIHRoaXMgcGF0Y2g/Cj4+Cj4+IE5v
IGl0cyBhYm91dCBicmVha2luZyBnaXQgYmxhbWUgKGFuZCBidWdmaXggYmFja3BvcnRzKSBmb3Ig
anVzdCBhIGNvc21ldGljIGltcHJvdmVtZW50Lgo+IAo+IEl0IGNvdWxkIGJlIHNsaWdodGx5IG1v
cmUgdGhhbiBhIGNvc21ldGljIGltcHJvdmVtZW50IChkZXBlbmRpbmcgb24gdGhlCj4gc21hcnRu
ZXNzIG9mIHRoZSBjb21waWxlcik6IHZjcHUtPnJ1bi0+IGFyZSB0d28gZGVyZWZlcmVuY2VzLCB3
aGlsZQo+IGt2bV9ydW4tPiBpcyBvbmx5IG9uZSBkZXJlZmVyZW5jZS4gU28gaXQgY291bGQgYmUg
c2xpZ2h0bHkgbW9yZSBjb21wYWN0Cj4gYW5kIGZhc3RlciBjb2RlLgo+IAo+ICAgVGhvbWFzCj4g
CgpJZiB0aGUgY29tcGlsZXIgaXMgc21hcnQgZW5vdWdoLCB0aGlzIHBsYWNlIGNhbiBiZSBhdXRv
bWF0aWNhbGx5IApvcHRpbWl6ZWQsIGJ1dCB3ZSBjYW4ndCBqdXN0IHJlbHkgb24gdGhlIGNvbXBp
bGVyLCBpZiBub3Q/IFRoaXMgcmVxdWlyZXMgCmEgdHJhZGUtb2ZmIGJldHdlZW4gY29kZSBjbGVh
bmxpbmVzcyByZWFkYWJpbGl0eSBhbmQgYnJlYWtpbmcgZ2l0IGJsYW1lLgpJbiBhZGRpdGlvbiwg
SSBoYXZlIHJlbW92ZWQgdGhlIGNoYW5nZXMgaGVyZSBhbmQgc2VudCBhIHY0IHBhdGNoLiBQbGVh
c2UgCmFsc28gaGVscCByZXZpZXcgaXQuCgpUaGFua3MgYW5kIGJlc3QsClRpYW5qaWEKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
