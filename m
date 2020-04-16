Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3152BC2BB55
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8A8B21973
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8A8B21973
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A106E4B226;
	Thu, 16 Apr 2020 07:10:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XcAHfIi2Pfya; Thu, 16 Apr 2020 07:10:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBEAE4B26F;
	Thu, 16 Apr 2020 07:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D55BB4B11F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 05:08:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IGulCchIstuk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 05:08:59 -0400 (EDT)
Received: from out30-54.freemail.mail.aliyun.com
 (out30-54.freemail.mail.aliyun.com [115.124.30.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B3434B1D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 05:08:58 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=36; SR=0;
 TI=SMTPD_---0TvhGIdK_1587028131; 
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0TvhGIdK_1587028131) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 16 Apr 2020 17:08:53 +0800
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To: Cornelia Huck <cohuck@redhat.com>
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
 <878sivx67g.fsf@vitty.brq.redhat.com>
 <1000159f971a6fa3b5bd9e5871ce4d82@kernel.org>
 <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
 <20200416105019.51191d79.cohuck@redhat.com>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <668a12b9-eda5-2d42-95f9-8d5e2990a465@linux.alibaba.com>
Date: Thu, 16 Apr 2020 17:08:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416105019.51191d79.cohuck@redhat.com>
X-Mailman-Approved-At: Thu, 16 Apr 2020 07:10:16 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, borntraeger@de.ibm.com, mingo@redhat.com, thuth@redhat.com,
 gor@linux.ibm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
 sean.j.christopherson@intel.com, mpe@ellerman.id.au, pbonzini@redhat.com,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

CgpPbiAyMDIwLzQvMTYgMTY6NTAsIENvcm5lbGlhIEh1Y2sgd3JvdGU6Cj4gT24gVGh1LCAxNiBB
cHIgMjAyMCAxNjo0NTozMyArMDgwMAo+IFRpYW5qaWEgWmhhbmcgPHRpYW5qaWEuemhhbmdAbGlu
dXguYWxpYmFiYS5jb20+IHdyb3RlOgo+IAo+PiBPbiAyMDIwLzQvMTYgMTY6MjgsIE1hcmMgWnlu
Z2llciB3cm90ZToKPj4+IE9uIDIwMjAtMDQtMTYgMDg6MDMsIFZpdGFseSBLdXpuZXRzb3Ygd3Jv
dGU6Cj4+Pj4gVGlhbmppYSBaaGFuZyA8dGlhbmppYS56aGFuZ0BsaW51eC5hbGliYWJhLmNvbT4g
d3JpdGVzOgo+Pj4+ICAgCj4+Pj4+IEluIGVhcmxpZXIgdmVyc2lvbnMgb2Yga3ZtLCAna3ZtX3J1
bicgaXMgYW4gaW5kZXBlbmRlbnQgc3RydWN0dXJlCj4+Pj4+IGFuZCBpcyBub3QgaW5jbHVkZWQg
aW4gdGhlIHZjcHUgc3RydWN0dXJlLiBBdCBwcmVzZW50LCAna3ZtX3J1bicKPj4+Pj4gaXMgYWxy
ZWFkeSBpbmNsdWRlZCBpbiB0aGUgdmNwdSBzdHJ1Y3R1cmUsIHNvIHRoZSBwYXJhbWV0ZXIKPj4+
Pj4gJ2t2bV9ydW4nIGlzIHJlZHVuZGFudC4KPj4+Pj4KPj4+Pj4gVGhpcyBwYXRjaCBzaW1wbGlm
eSB0aGUgZnVuY3Rpb24gZGVmaW5pdGlvbiwgcmVtb3ZlcyB0aGUgZXh0cmEKPj4+Pj4gJ2t2bV9y
dW4nIHBhcmFtZXRlciwgYW5kIGV4dHJhY3QgaXQgZnJvbSB0aGUgJ2t2bV92Y3B1JyBzdHJ1Y3R1
cmUKPj4+Pj4gaWYgbmVjZXNzYXJ5Lgo+Pj4+Pgo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBUaWFuamlh
IFpoYW5nIDx0aWFuamlhLnpoYW5nQGxpbnV4LmFsaWJhYmEuY29tPgo+Pj4+PiAtLS0KPj4+Pj4K
Pj4+Pj4gdjIgY2hhbmdlOgo+Pj4+PiAgwqAgcmVtb3ZlICdrdm1fcnVuJyBwYXJhbWV0ZXIgYW5k
IGV4dHJhY3QgaXQgZnJvbSAna3ZtX3ZjcHUnCj4+Pj4+Cj4+Pj4+ICDCoGFyY2gvbWlwcy9rdm0v
bWlwcy5jwqDCoMKgwqDCoMKgIHzCoCAzICsrLQo+Pj4+PiAgwqBhcmNoL3Bvd2VycGMva3ZtL3Bv
d2VycGMuYyB8wqAgMyArKy0KPj4+Pj4gIMKgYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jwqDCoCB8
wqAgMyArKy0KPj4+Pj4gIMKgYXJjaC94ODYva3ZtL3g4Ni5jwqDCoMKgwqDCoMKgwqDCoCB8IDEx
ICsrKysrKy0tLS0tCj4+Pj4+ICDCoGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaMKgwqAgfMKgIDIg
Ky0KPj4+Pj4gIMKgdmlydC9rdm0vYXJtL2FybS5jwqDCoMKgwqDCoMKgwqDCoCB8wqAgNiArKyst
LS0KPj4+Pj4gIMKgdmlydC9rdm0va3ZtX21haW4uY8KgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4+
Pj4+ICDCoDcgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0p
Cj4gCj4+PiBPdmVyYWxsLCB0aGVyZSBpcyBhIGxhcmdlIHNldCBvZiBjbGVhbnVwcyB0byBiZSBk
b25lIHdoZW4gYm90aCB0aGUgdmNwdQo+Pj4gYW5kIHRoZSBydW4KPj4+IHN0cnVjdHVyZXMgYXJl
IHBhc3NlZCBhcyBwYXJhbWV0ZXJzIGF0IHRoZSBzYW1lIHRpbWUuIEp1c3QgZ3JlcHBpbmcgdGhl
Cj4+PiB0cmVlIGZvcgo+Pj4ga3ZtX3J1biBpcyBwcmV0dHkgaW5zdHJ1Y3RpdmUuCj4+Pgo+Pj4g
ICDCoMKgwqDCoMKgwqDCoCBNLgo+Pgo+PiBTb3JyeSwgaXQncyBteSBtaXN0YWtlLCBJIG9ubHkg
Y29tcGlsZWQgdGhlIHg4NiBwbGF0Zm9ybSwgSSB3aWxsIHN1Ym1pdAo+PiBwYXRjaCBhZ2Fpbi4K
PiAKPiBJIHRoaW5rIGl0J3MgY29tcGxldGVseSBmaW5lIChhbmQgZXZlbiBwcmVmZXJhYmxlKSB0
byBkbyBjbGVhbnVwcyBsaWtlCj4gdGhhdCBvbiB0b3AuCj4gCj4gW0ZXSVcsIEkgY29tcGlsZWQg
czM5MCBoZXJlLl0KPiAKClZlcnkgZ29vZCwgSSB3aWxsIGRvIGEgY29tcHJlaGVuc2l2ZSBjbGVh
bnVwIG9mIHRoaXMgdHlwZSBvZiBjb2RlLgoKVGhhbmtzLApUaWFuamlhCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
