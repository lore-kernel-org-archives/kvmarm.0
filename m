Return-Path: <SRS0=8W4i=6K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9F1C54FCB
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 12:59:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8449B20700
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 12:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMl/8ryP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8449B20700
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B8E4B1A7;
	Sun, 26 Apr 2020 08:59:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zfHomSnDZAGL; Sun, 26 Apr 2020 08:59:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0894B1A9;
	Sun, 26 Apr 2020 08:59:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A86AF4B1A6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 08:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gBVOYU+lu2DG for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Apr 2020 08:59:45 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D654B1A0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 08:59:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587905985;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references:openpgp:openpgp;
 bh=cS6N3dz+H92wTTUjeik0cWhJVJMk8JtsySToZ32DZB8=;
 b=aMl/8ryPi9d+jjVbN8PB6eKImZsR5rdDtWa1xfi1jNTVPlKpQ1lcMPMW4vw3f054jdCZWC
 kVC8uUDI86xGRwYWIOUnl0jkHZPq8425382RKqFWotQnVSCzpyG2cHlwoQsOw5VzF/9FuW
 8GdkB5ZGCuIKVIja7od18Emc9e0kEQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-L1Gr5bIyNaSAU5A4TdMIqA-1; Sun, 26 Apr 2020 08:59:40 -0400
X-MC-Unique: L1Gr5bIyNaSAU5A4TdMIqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CAF545F;
 Sun, 26 Apr 2020 12:59:36 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-33.ams2.redhat.com [10.36.112.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26AC460C05;
 Sun, 26 Apr 2020 12:59:19 +0000 (UTC)
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
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
From: Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <73f6ecd0-ac47-eaad-0e4f-2d41c2b34450@redhat.com>
Date: Sun, 26 Apr 2020 14:59:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1d73b700-4a20-3d7a-66d1-29b5afa03f4d@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjMvMDQvMjAyMCAxMy4wMCwgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOgo+IAo+IAo+
IE9uIDIzLjA0LjIwIDEyOjU4LCBUaWFuamlhIFpoYW5nIHdyb3RlOgo+Pgo+Pgo+PiBPbiAyMDIw
LzQvMjMgMTg6MzksIENvcm5lbGlhIEh1Y2sgd3JvdGU6Cj4+PiBPbiBUaHUsIDIzIEFwciAyMDIw
IDExOjAxOjQzICswODAwCj4+PiBUaWFuamlhIFpoYW5nIDx0aWFuamlhLnpoYW5nQGxpbnV4LmFs
aWJhYmEuY29tPiB3cm90ZToKPj4+Cj4+Pj4gT24gMjAyMC80LzIzIDA6MDQsIENvcm5lbGlhIEh1
Y2sgd3JvdGU6Cj4+Pj4+IE9uIFdlZCwgMjIgQXByIDIwMjAgMTc6NTg6MDQgKzAyMDAKPj4+Pj4g
Q2hyaXN0aWFuIEJvcm50cmFlZ2VyIDxib3JudHJhZWdlckBkZS5pYm0uY29tPiB3cm90ZToKPj4+
Pj4gwqDCoAo+Pj4+Pj4gT24gMjIuMDQuMjAgMTU6NDUsIENvcm5lbGlhIEh1Y2sgd3JvdGU6Cj4+
Pj4+Pj4gT24gV2VkLCAyMiBBcHIgMjAyMCAyMDo1ODowNCArMDgwMAo+Pj4+Pj4+IFRpYW5qaWEg
WmhhbmcgPHRpYW5qaWEuemhhbmdAbGludXguYWxpYmFiYS5jb20+IHdyb3RlOgo+Pj4+Pj4+IMKg
wqDCoMKgwqAKPj4+Pj4+Pj4gSW4gdGhlIGN1cnJlbnQga3ZtIHZlcnNpb24sICdrdm1fcnVuJyBo
YXMgYmVlbiBpbmNsdWRlZCBpbiB0aGUgJ2t2bV92Y3B1Jwo+Pj4+Pj4+PiBzdHJ1Y3R1cmUuIEVh
cmxpZXIgdGhhbiBoaXN0b3JpY2FsIHJlYXNvbnMsIG1hbnkga3ZtLXJlbGF0ZWQgZnVuY3Rpb24K
Pj4+Pj4+Pgo+Pj4+Pj4+IHMvRWFybGllciB0aGFuL0Zvci8gPwo+Pj4+Pj4+IMKgwqDCoMKgwqAK
Pj4+Pj4+Pj4gcGFyYW1ldGVycyByZXRhaW4gdGhlICdrdm1fcnVuJyBhbmQgJ2t2bV92Y3B1JyBw
YXJhbWV0ZXJzIGF0IHRoZSBzYW1lIHRpbWUuCj4+Pj4+Pj4+IFRoaXMgcGF0Y2ggZG9lcyBhIHVu
aWZpZWQgY2xlYW51cCBvZiB0aGVzZSByZW1haW5pbmcgcmVkdW5kYW50IHBhcmFtZXRlcnMuCj4+
Pj4+Pj4+Cj4+Pj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFRpYW5qaWEgWmhhbmcgPHRpYW5qaWEuemhh
bmdAbGludXguYWxpYmFiYS5jb20+Cj4+Pj4+Pj4+IC0tLQo+Pj4+Pj4+PiDCoMKgIGFyY2gvczM5
MC9rdm0va3ZtLXMzOTAuYyB8IDM3ICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0KPj4+Pj4+Pj4gwqDCoCAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMTUgZGVs
ZXRpb25zKC0pCj4+Pj4+Pj4+Cj4+Pj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL3MzOTAva3ZtL2t2
bS1zMzkwLmMgYi9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMKPj4+Pj4+Pj4gaW5kZXggZTMzNWE3
ZTVlYWQ3Li5kN2JiMmU3YTA3ZmYgMTAwNjQ0Cj4+Pj4+Pj4+IC0tLSBhL2FyY2gvczM5MC9rdm0v
a3ZtLXMzOTAuYwo+Pj4+Pj4+PiArKysgYi9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMKPj4+Pj4+
Pj4gQEAgLTQxNzYsOCArNDE3Niw5IEBAIHN0YXRpYyBpbnQgX192Y3B1X3J1bihzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpCj4+Pj4+Pj4+IMKgwqDCoMKgwqDCoCByZXR1cm4gcmM7Cj4+Pj4+Pj4+IMKg
wqAgfQo+Pj4+Pj4+PiDCoMKgIC1zdGF0aWMgdm9pZCBzeW5jX3JlZ3NfZm10MihzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcnVuICprdm1fcnVuKQo+Pj4+Pj4+PiArc3RhdGljIHZv
aWQgc3luY19yZWdzX2ZtdDIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4+Pj4+PiDCoMKgIHsK
Pj4+Pj4+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3J1biAqa3ZtX3J1biA9IHZjcHUtPnJ1bjsKPj4+
Pj4+Pj4gwqDCoMKgwqDCoMKgIHN0cnVjdCBydW50aW1lX2luc3RyX2NiICpyaWNjYjsKPj4+Pj4+
Pj4gwqDCoMKgwqDCoMKgIHN0cnVjdCBnc19jYiAqZ3NjYjsKPj4+Pj4+Pj4gwqDCoCBAQCAtNDIz
NSw3ICs0MjM2LDcgQEAgc3RhdGljIHZvaWQgc3luY19yZWdzX2ZtdDIoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAqa3ZtX3J1bikKPj4+Pj4+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfQo+Pj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodmNwdS0+YXJjaC5nc19l
bmFibGVkKSB7Cj4+Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3VycmVudC0+
dGhyZWFkLmdzX2NiID0gKHN0cnVjdCBnc19jYiAqKQo+Pj4+Pj4+PiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmdmNwdS0+cnVuLT5zLnJlZ3MuZ3NjYjsK
Pj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Jmt2bV9ydW4tPnMucmVncy5nc2NiOwo+Pj4+Pj4+Cj4+Pj4+Pj4gTm90IHN1cmUgaWYgdGhlc2Ug
Y2hhbmdlcyAodmNwdS0+cnVuLT4gPT4ga3ZtX3J1bi0+KSBhcmUgcmVhbGx5IHdvcnRoCj4+Pj4+
Pj4gaXQuIChJdCBzZWVtcyB0aGV5IGFtb3VudCB0byBhdCBsZWFzdCBhcyBtdWNoIGFzIHRoZSBj
aGFuZ2VzIGFkdmVydGlzZWQKPj4+Pj4+PiBpbiB0aGUgcGF0Y2ggZGVzY3JpcHRpb24uKQo+Pj4+
Pj4+Cj4+Pj4+Pj4gT3RoZXIgb3BpbmlvbnM/Cj4+Pj4+Pgo+Pj4+Pj4gQWdyZWVkLiBJdCBmZWVs
cyBraW5kIG9mIHJhbmRvbS4gTWF5YmUganVzdCBkbyB0aGUgZmlyc3QgbGluZSAobW92ZSBrdm1f
cnVuIGZyb20gdGhlCj4+Pj4+PiBmdW5jdGlvbiBwYXJhbWV0ZXIgbGlzdCBpbnRvIHRoZSB2YXJp
YWJsZSBkZWNsYXJhdGlvbik/IE5vdCBzdXJlIGlmIHRoaXMgaXMgYmV0dGVyLgo+Pj4+Pj4gwqAg
Cj4+Pj4+Cj4+Pj4+IFRoZXJlJ3MgbW9yZSBpbiB0aGlzIHBhdGNoIHRoYXQgSSBjdXQuLi4gYnV0
IEkgdGhpbmsganVzdCBtb3ZpbmcKPj4+Pj4ga3ZtX3J1biBmcm9tIHRoZSBwYXJhbWV0ZXIgbGlz
dCB3b3VsZCBiZSBtdWNoIGxlc3MgZGlzcnVwdGl2ZS4KPj4+Pj4gwqDCoCAKPj4+Pgo+Pj4+IEkg
dGhpbmsgdGhlcmUgYXJlIHR3byBraW5kcyBvZiBjb2RlKGB2Y3B1LT5ydW4tPmAgYW5kIGBrdm1f
cnVuLT5gKSwgYnV0Cj4+Pj4gdGhlcmUgd2lsbCBiZSBtb3JlIGRpc3J1cHRpdmUsIG5vdCBsZXNz
Lgo+Pj4KPj4+IEkganVzdCBmYWlsIHRvIHNlZSB0aGUgYmVuZWZpdDsgc3VyZSwga3ZtX3J1bi0+
IGlzIGNvbnZlbmllbnQsIGJ1dCB0aGUKPj4+IGN1cnJlbnQgY29kZSBpcyBqdXN0IGZpbmUsIGFu
ZCBhbnkgcmV3b3JrIHNob3VsZCBiZSBiYWxhbmNlZCBhZ2FpbnN0Cj4+PiB0aGUgY29zdCAoZS5n
LiBjbHV0dGVyaW5nIGdpdCBhbm5vdGF0ZSkuCj4+Pgo+Pgo+PiBjbHV0dGVyaW5nIGdpdCBhbm5v
dGF0ZSA/IERvZXMgaXQgbWVhbiBGaXggeHh4eCAoImNvbW1lbnQiKS4gSXMgaXQgcG9zc2libGUg
dG8gc29sdmUgdGhpcyBwcm9ibGVtIGJ5IHNwbGl0dGluZyB0aGlzIHBhdGNoPwo+IAo+IE5vIGl0
cyBhYm91dCBicmVha2luZyBnaXQgYmxhbWUgKGFuZCBidWdmaXggYmFja3BvcnRzKSBmb3IganVz
dCBhIGNvc21ldGljIGltcHJvdmVtZW50LgoKSXQgY291bGQgYmUgc2xpZ2h0bHkgbW9yZSB0aGFu
IGEgY29zbWV0aWMgaW1wcm92ZW1lbnQgKGRlcGVuZGluZyBvbiB0aGUKc21hcnRuZXNzIG9mIHRo
ZSBjb21waWxlcik6IHZjcHUtPnJ1bi0+IGFyZSB0d28gZGVyZWZlcmVuY2VzLCB3aGlsZQprdm1f
cnVuLT4gaXMgb25seSBvbmUgZGVyZWZlcmVuY2UuIFNvIGl0IGNvdWxkIGJlIHNsaWdodGx5IG1v
cmUgY29tcGFjdAphbmQgZmFzdGVyIGNvZGUuCgogVGhvbWFzCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
