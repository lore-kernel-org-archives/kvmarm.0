Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCEBC2BB85
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 08:50:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 996FB20784
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 08:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAZOXk8e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 996FB20784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1387A4B14D;
	Thu, 16 Apr 2020 04:50:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FF5MlgxiYYRN; Thu, 16 Apr 2020 04:50:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 198304B1D1;
	Thu, 16 Apr 2020 04:50:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFDFF4B142
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 04:50:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yP34+T9OUCX1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 04:50:48 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DADD14B120
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 04:50:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587027048;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HBOSp8KoaqgQUXlL6khiQxh82SbQfD3UXPaPxlc3NpI=;
 b=SAZOXk8e3bOfIiblT3KEanC34Cr2ERHz2OAj1z5udHAIYoMzy7FEBAiLU3tOkG3vjFBXLU
 RJ1+UhYcNWRmanl/jDRIR+NLsaMtjBZk/1GV7FNoFaE1tJlNcojdz6CEPLZ0gyeSPCoaxI
 vu2BVvUEOncDoo6OHYGGljUZxbKLZSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-MuypNbuHM0uD0I3hVYYtuw-1; Thu, 16 Apr 2020 04:50:46 -0400
X-MC-Unique: MuypNbuHM0uD0I3hVYYtuw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 994A818C35A6;
 Thu, 16 Apr 2020 08:50:42 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 330E27E7C4;
 Thu, 16 Apr 2020 08:50:22 +0000 (UTC)
Date: Thu, 16 Apr 2020 10:50:19 +0200
From: Cornelia Huck <cohuck@redhat.com>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
Message-ID: <20200416105019.51191d79.cohuck@redhat.com>
In-Reply-To: <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
 <878sivx67g.fsf@vitty.brq.redhat.com>
 <1000159f971a6fa3b5bd9e5871ce4d82@kernel.org>
 <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gVGh1LCAxNiBBcHIgMjAyMCAxNjo0NTozMyArMDgwMApUaWFuamlhIFpoYW5nIDx0aWFuamlh
LnpoYW5nQGxpbnV4LmFsaWJhYmEuY29tPiB3cm90ZToKCj4gT24gMjAyMC80LzE2IDE2OjI4LCBN
YXJjIFp5bmdpZXIgd3JvdGU6Cj4gPiBPbiAyMDIwLTA0LTE2IDA4OjAzLCBWaXRhbHkgS3V6bmV0
c292IHdyb3RlOiAgCj4gPj4gVGlhbmppYSBaaGFuZyA8dGlhbmppYS56aGFuZ0BsaW51eC5hbGli
YWJhLmNvbT4gd3JpdGVzOgo+ID4+ICAKPiA+Pj4gSW4gZWFybGllciB2ZXJzaW9ucyBvZiBrdm0s
ICdrdm1fcnVuJyBpcyBhbiBpbmRlcGVuZGVudCBzdHJ1Y3R1cmUKPiA+Pj4gYW5kIGlzIG5vdCBp
bmNsdWRlZCBpbiB0aGUgdmNwdSBzdHJ1Y3R1cmUuIEF0IHByZXNlbnQsICdrdm1fcnVuJwo+ID4+
PiBpcyBhbHJlYWR5IGluY2x1ZGVkIGluIHRoZSB2Y3B1IHN0cnVjdHVyZSwgc28gdGhlIHBhcmFt
ZXRlcgo+ID4+PiAna3ZtX3J1bicgaXMgcmVkdW5kYW50Lgo+ID4+Pgo+ID4+PiBUaGlzIHBhdGNo
IHNpbXBsaWZ5IHRoZSBmdW5jdGlvbiBkZWZpbml0aW9uLCByZW1vdmVzIHRoZSBleHRyYQo+ID4+
PiAna3ZtX3J1bicgcGFyYW1ldGVyLCBhbmQgZXh0cmFjdCBpdCBmcm9tIHRoZSAna3ZtX3ZjcHUn
IHN0cnVjdHVyZQo+ID4+PiBpZiBuZWNlc3NhcnkuCj4gPj4+Cj4gPj4+IFNpZ25lZC1vZmYtYnk6
IFRpYW5qaWEgWmhhbmcgPHRpYW5qaWEuemhhbmdAbGludXguYWxpYmFiYS5jb20+Cj4gPj4+IC0t
LQo+ID4+Pgo+ID4+PiB2MiBjaGFuZ2U6Cj4gPj4+IMKgIHJlbW92ZSAna3ZtX3J1bicgcGFyYW1l
dGVyIGFuZCBleHRyYWN0IGl0IGZyb20gJ2t2bV92Y3B1Jwo+ID4+Pgo+ID4+PiDCoGFyY2gvbWlw
cy9rdm0vbWlwcy5jwqDCoMKgwqDCoMKgIHzCoCAzICsrLQo+ID4+PiDCoGFyY2gvcG93ZXJwYy9r
dm0vcG93ZXJwYy5jIHzCoCAzICsrLQo+ID4+PiDCoGFyY2gvczM5MC9rdm0va3ZtLXMzOTAuY8Kg
wqAgfMKgIDMgKystCj4gPj4+IMKgYXJjaC94ODYva3ZtL3g4Ni5jwqDCoMKgwqDCoMKgwqDCoCB8
IDExICsrKysrKy0tLS0tCj4gPj4+IMKgaW5jbHVkZS9saW51eC9rdm1faG9zdC5owqDCoCB8wqAg
MiArLQo+ID4+PiDCoHZpcnQva3ZtL2FybS9hcm0uY8KgwqDCoMKgwqDCoMKgwqAgfMKgIDYgKysr
LS0tCj4gPj4+IMKgdmlydC9rdm0va3ZtX21haW4uY8KgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4g
Pj4+IMKgNyBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkK
Cj4gPiBPdmVyYWxsLCB0aGVyZSBpcyBhIGxhcmdlIHNldCBvZiBjbGVhbnVwcyB0byBiZSBkb25l
IHdoZW4gYm90aCB0aGUgdmNwdSAKPiA+IGFuZCB0aGUgcnVuCj4gPiBzdHJ1Y3R1cmVzIGFyZSBw
YXNzZWQgYXMgcGFyYW1ldGVycyBhdCB0aGUgc2FtZSB0aW1lLiBKdXN0IGdyZXBwaW5nIHRoZSAK
PiA+IHRyZWUgZm9yCj4gPiBrdm1fcnVuIGlzIHByZXR0eSBpbnN0cnVjdGl2ZS4KPiA+IAo+ID4g
IMKgwqDCoMKgwqDCoMKgIE0uICAKPiAKPiBTb3JyeSwgaXQncyBteSBtaXN0YWtlLCBJIG9ubHkg
Y29tcGlsZWQgdGhlIHg4NiBwbGF0Zm9ybSwgSSB3aWxsIHN1Ym1pdCAKPiBwYXRjaCBhZ2Fpbi4K
CkkgdGhpbmsgaXQncyBjb21wbGV0ZWx5IGZpbmUgKGFuZCBldmVuIHByZWZlcmFibGUpIHRvIGRv
IGNsZWFudXBzIGxpa2UKdGhhdCBvbiB0b3AuCgpbRldJVywgSSBjb21waWxlZCBzMzkwIGhlcmUu
XQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
