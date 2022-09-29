Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72212C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Sep 2022 11:31:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D674A40BA3;
	Thu, 29 Sep 2022 07:31:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N9gEAwAcKrm7; Thu, 29 Sep 2022 07:31:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7294E41175;
	Thu, 29 Sep 2022 07:31:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D264240BA9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 07:31:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xolYPZapWUPQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Sep 2022 07:31:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 664D940BA3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Sep 2022 07:31:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664451111;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pEKfUYSB+7V62VJkV4AjzMMtYng+NhW8XBng+EdVuoU=;
 b=H175DD8zKyl7pxmlqZx4ezcQCRv3ckVC1hdOivDzYwbjUHNSI9QdKLi7Rc37SublsmSrr0
 bY+NpVqQ2vlhwvyRzQYSNARhuN8Ag1opO7UTReuHUMBpoXCzqrFeSLyXsfv+wpUtIdYSHc
 B5nvrPgdelELAv9ZckFK7ZCvULfUjb0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-nLrVoXaQOaWQY-yLIcflHQ-1; Thu, 29 Sep 2022 07:31:44 -0400
X-MC-Unique: nLrVoXaQOaWQY-yLIcflHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71171185A7A4;
 Thu, 29 Sep 2022 11:31:43 +0000 (UTC)
Received: from [10.64.54.143] (vpn2-54-143.bne.redhat.com [10.64.54.143])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 12E2340C6EC2;
 Thu, 29 Sep 2022 11:31:36 +0000 (UTC)
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory tracking
From: Gavin Shan <gshan@redhat.com>
To: Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com> <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org> <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org> <YzRfkBWepX2CD88h@x1n>
 <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
Message-ID: <ddc4166c-81b6-2f7b-87a7-4af3d7db888a@redhat.com>
Date: Thu, 29 Sep 2022 21:31:34 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

SGkgUGV0ZXIgYW5kIE1hcmMsCgpPbiA5LzI5LzIyIDc6NTAgUE0sIEdhdmluIFNoYW4gd3JvdGU6
Cj4gT24gOS8yOS8yMiAxMjo1MiBBTSwgUGV0ZXIgWHUgd3JvdGU6Cj4+IE9uIFdlZCwgU2VwIDI4
LCAyMDIyIGF0IDA5OjI1OjM0QU0gKzAxMDAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IE9uIFdl
ZCwgMjggU2VwIDIwMjIgMDA6NDc6NDMgKzAxMDAsCj4+PiBHYXZpbiBTaGFuIDxnc2hhbkByZWRo
YXQuY29tPiB3cm90ZToKPj4+Cj4+Pj4gSSBoYXZlIHJvdWdoIGlkZWEgYXMgYmVsb3cuIEl0J3Mg
YXBwcmVjaWF0ZWQgaWYgeW91IGNhbiBjb21tZW50IGJlZm9yZSBJJ20KPj4+PiBnb2luZyBhIGhl
YWQgZm9yIHRoZSBwcm90b3R5cGUuIFRoZSBvdmVyYWxsIGlkZWEgaXMgdG8gaW50cm9kdWNlIGFu
b3RoZXIKPj4+PiBkaXJ0eSByaW5nIGZvciBLVk0gKGt2bS1kaXJ0eS1yaW5nKS4gSXQncyB1cGRh
dGVkIGFuZCB2aXNpdGVkIHNlcGFyYXRlbHkKPj4+PiB0byBkaXJ0eSByaW5nIGZvciB2Y3B1ICh2
Y3B1LWRpcnR5LXJpbmcpLgo+Pj4+Cj4+Pj4gwqDCoMKgIC0gV2hlbiB0aGUgdmFyaW91cyBWR0lD
L0lUUyB0YWJsZSBiYXNlIGFkZHJlc3NlcyBhcmUgc3BlY2lmaWVkLCBrdm0tZGlydHktcmluZwo+
Pj4+IMKgwqDCoMKgwqAgZW50cmllcyBhcmUgYWRkZWQgdG8gbWFyayB0aG9zZSBwYWdlcyBhcyAn
YWx3YXlzLWRpcnR5Jy4gSW4gbWFya19wYWdlX2RpcnR5X2luX3Nsb3QoKSwKPj4+PiDCoMKgwqDC
oMKgIHRob3NlICdhbHdheXMtZGlydHknIHBhZ2VzIHdpbGwgYmUgc2tpcHBlZCwgbm8gZW50cmll
cyBwdXNoZWQgdG8gdmNwdS1kaXJ0eS1yaW5nLgo+Pj4+Cj4+Pj4gwqDCoMKgIC0gU2ltaWxhciB0
byB2Y3B1LWRpcnR5LXJpbmcsIGt2bS1kaXJ0eS1yaW5nIGlzIGFjY2Vzc2VkIGZyb20gdXNlcnNw
YWNlIHRocm91Z2gKPj4+PiDCoMKgwqDCoMKgIG1tYXAoa3ZtLT5mZCkuIEhvd2V2ZXIsIHRoZXJl
IHdvbid0IGhhdmUgc2ltaWxhciByZXNldCBpbnRlcmZhY2UuIEl0IG1lYW5zCj4+Pj4gwqDCoMKg
wqDCoCAnc3RydWN0IGt2bV9kaXJ0eV9nZm46OmZsYWdzJyB3b24ndCB0cmFjayBhbnkgaW5mb3Jt
YXRpb24gYXMgd2UgZG8gZm9yCj4+Pj4gwqDCoMKgwqDCoCB2Y3B1LWRpcnR5LXJpbmcuIEluIHRo
aXMgcmVnYXJkLCBrdm0tZGlydHktcmluZyBpcyBwdXJlbHkgc2hhcmVkIGJ1ZmZlciB0bwo+Pj4+
IMKgwqDCoMKgwqAgYWR2ZXJ0aXNlICdhbHdheXMtZGlydHknIHBhZ2VzIGZyb20gaG9zdCB0byB1
c2Vyc3BhY2UuCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCAtIEZvciBRRU1VLCBzaHV0ZG93bi9zdXNw
ZW5kL3Jlc3VtZSBjYXNlcyB3b24ndCBiZSBjb25jZXJuaW5nCj4+Pj4gdXMgYW55IG1vcmUuIFRo
ZQo+Pj4+IMKgwqDCoMKgwqAgb25seSBjb25jZXJuZWQgY2FzZSBpcyBtaWdyYXRpb24uIFdoZW4g
dGhlIG1pZ3JhdGlvbiBpcyBhYm91dCB0byBjb21wbGV0ZSwKPj4+PiDCoMKgwqDCoMKgIGt2bS1k
aXJ0eS1yaW5nIGVudHJpZXMgYXJlIGZldGNoZWQgYW5kIHRoZSBkaXJ0eSBiaXRzIGFyZSB1cGRh
dGVkIHRvIGdsb2JhbAo+Pj4+IMKgwqDCoMKgwqAgZGlydHkgcGFnZSBiaXRtYXAgYW5kIFJBTUJs
b2NrJ3MgZGlydHkgcGFnZSBiaXRtYXAuIEZvciB0aGlzLCBJJ20gc3RpbGwgcmVhZGluZwo+Pj4+
IMKgwqDCoMKgwqAgdGhlIGNvZGUgdG8gZmluZCB0aGUgYmVzdCBzcG90IHRvIGRvIGl0Lgo+Pj4K
Pj4+IEkgdGhpbmsgaXQgbWFrZXMgYSBsb3Qgb2Ygc2Vuc2UgdG8gaGF2ZSBhIHdheSB0byBsb2cg
d3JpdGVzIHRoYXQgYXJlCj4+PiBub3QgZ2VuZXJhdGVkIGJ5IGEgdnBjdSwgc3VjaCBhcyB0aGUg
R0lDIGFuZCBtYXliZSBvdGhlciB0aGluZ3MgaW4gdGhlCj4+PiBmdXR1cmUsIHN1Y2ggYXMgRE1B
IHRyYWZmaWMgKHNvbWUgU01NVXMgYXJlIGFibGUgdG8gdHJhY2sgZGlydHkgcGFnZXMKPj4+IGFz
IHdlbGwpLgo+Pj4KPj4+IEhvd2V2ZXIsIEkgZG9uJ3QgcmVhbGx5IHNlZSB0aGUgcG9pbnQgaW4g
aW52ZW50aW5nIGEgbmV3IG1lY2hhbmlzbSBmb3IKPj4+IHRoYXQuIFdoeSBkb24ndCB3ZSBzaW1w
bHkgYWxsb3cgbm9uLXZwY3UgZGlydHkgcGFnZXMgdG8gYmUgdHJhY2tlZCBpbgo+Pj4gdGhlIGRp
cnR5ICpiaXRtYXAqPwo+Pj4KPj4+IMKgRnJvbSBhIGtlcm5lbCBwZXJzcGVjdGl2ZSwgdGhpcyBp
cyBkZWFkIGVhc3k6Cj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92
aXJ0L2t2bS9rdm1fbWFpbi5jCj4+PiBpbmRleCA1YjA2NGRiYWRhZjQuLmFlOTEzOGYyOWQ1MSAx
MDA2NDQKPj4+IC0tLSBhL3ZpcnQva3ZtL2t2bV9tYWluLmMKPj4+ICsrKyBiL3ZpcnQva3ZtL2t2
bV9tYWluLmMKPj4+IEBAIC0zMzA1LDcgKzMzMDUsNyBAQCB2b2lkIG1hcmtfcGFnZV9kaXJ0eV9p
bl9zbG90KHN0cnVjdCBrdm0gKmt2bSwKPj4+IMKgwqDCoMKgwqAgc3RydWN0IGt2bV92Y3B1ICp2
Y3B1ID0ga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsKPj4+IMKgICNpZmRlZiBDT05GSUdfSEFWRV9L
Vk1fRElSVFlfUklORwo+Pj4gLcKgwqDCoCBpZiAoV0FSTl9PTl9PTkNFKCF2Y3B1KSB8fCBXQVJO
X09OX09OQ0UodmNwdS0+a3ZtICE9IGt2bSkpCj4+PiArwqDCoMKgIGlmIChXQVJOX09OX09OQ0Uo
dmNwdSAmJiB2Y3B1LT5rdm0gIT0ga3ZtKSkKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47
Cj4+PiDCoCAjZW5kaWYKPj4+IEBAIC0zMzEzLDEwICszMzEzLDExIEBAIHZvaWQgbWFya19wYWdl
X2RpcnR5X2luX3Nsb3Qoc3RydWN0IGt2bSAqa3ZtLAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHVu
c2lnbmVkIGxvbmcgcmVsX2dmbiA9IGdmbiAtIG1lbXNsb3QtPmJhc2VfZ2ZuOwo+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgIHUzMiBzbG90ID0gKG1lbXNsb3QtPmFzX2lkIDw8IDE2KSB8IG1lbXNsb3Qt
PmlkOwo+Pj4gLcKgwqDCoMKgwqDCoMKgIGlmIChrdm0tPmRpcnR5X3Jpbmdfc2l6ZSkKPj4+ICvC
oMKgwqDCoMKgwqDCoCBpZiAodnBjdSAmJiBrdm0tPmRpcnR5X3Jpbmdfc2l6ZSkKPj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9kaXJ0eV9yaW5nX3B1c2goJnZjcHUtPmRpcnR5X3Jp
bmcsCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBzbG90LCByZWxfZ2ZuKTsKPj4+IC3CoMKgwqDCoMKgwqDCoCBlbHNlCj4+PiArwqDCoMKgwqDC
oMKgwqAgLyogbm9uLXZwY3UgZGlydHlpbmcgZW5kcyB1cCBpbiB0aGUgZ2xvYmFsIGJpdG1hcCAq
Lwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICghdmNwdSAmJiBtZW1zbG90LT5kaXJ0eV9iaXRtYXAp
Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXRfYml0X2xlKHJlbF9nZm4sIG1lbXNs
b3QtPmRpcnR5X2JpdG1hcCk7Cj4+PiDCoMKgwqDCoMKgIH0KPj4+IMKgIH0KPj4+Cj4+PiB0aG91
Z2ggSSdtIHN1cmUgdGhlcmUgaXMgYSBmZXcgbW9yZSB0aGluZ3MgdG8gaXQuCj4+Cj4+IFllcywg
Y3VycmVudGx5IHRoZSBiaXRtYXBzIGFyZSBub3QgY3JlYXRlZCB3aGVuIHJpbmdzIGFyZSBlbmFi
bGVkLgo+PiBrdm1fcHJlcGFyZV9tZW1vcnlfcmVnaW9uKCkgaGFzOgo+Pgo+PiDCoMKgwqDCoMKg
wqDCoCBlbHNlIGlmICgha3ZtLT5kaXJ0eV9yaW5nX3NpemUpIHsKPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByID0ga3ZtX2FsbG9jX2RpcnR5X2JpdG1hcChuZXcpOwo+Pgo+PiBCdXQgSSB0aGlu
ayBtYXliZSB0aGF0J3MgYSBzb2x1dGlvbiB3b3J0aCBjb25zaWRlcmluZy7CoCBVc2luZyB0aGUg
cmluZ3MKPj4gaGF2ZSBhIG1ham9yIGNoYWxsZW5nZSBvbiB0aGUgbGltaXRhdGlvbiBvZiByaW5n
IHNpemUsIHNvIHRoYXQgZm9yIGUuZy4gYW4KPj4gaW9jdGwgd2UgbmVlZCB0byBtYWtlIHN1cmUg
dGhlIHBhZ2VzIHRvIGRpcnR5IHdpdGhpbiBhbiBpb2N0bCBwcm9jZWR1cmUKPj4gd2lsbCBub3Qg
YmUgbW9yZSB0aGFuIHRoZSByaW5nIGNhbiB0YWtlLsKgIFVzaW5nIGRpcnR5IGJpdG1hcCBmb3Ig
YSBsYXN0Cj4+IHBoYXNlIHN5bmMgb2YgY29uc3RhbnQgKGJ1dCBzdGlsbCB2ZXJ5IHNtYWxsIGFt
b3VudCBvZikgZGlydHkgcGFnZXMgZG9lcwo+PiBzb3VuZCByZWFzb25hYmxlIGFuZCBjYW4gYXZv
aWQgdGhhdCBjb21wbGV4aXR5LsKgIFRoZSBwYXlvZmYgaXMgd2UnbGwgbmVlZAo+PiB0byBhbGxv
Y2F0ZSBib3RoIHRoZSByaW5ncyBhbmQgdGhlIGJpdG1hcHMuCj4+Cj4gCj4gT2suIEkgd2FzIHRo
aW5raW5nIG9mIHVzaW5nIHRoZSBiaXRtYXAgdG8gY29udmV5IHRoZSBkaXJ0eSBwYWdlcyBmb3IK
PiB0aGlzIHBhcnRpY3VsYXIgY2FzZSwgd2hlcmUgd2UgZG9uJ3QgaGF2ZSBydW5uaW5nIHZjcHUu
IFRoZSBjb25jZXJuIEkgaGFkCj4gaXMgdGhlIG5hdHVyYWwgZGlmZmVyZW5jZSBiZXR3ZWVuIGEg
cmluZyBhbmQgYml0bWFwLiBUaGUgcmluZy1idWZmZXIgaXMKPiBkaXNjcmV0ZSwgY29tcGFyaW5n
IHRvIGJpdG1hcC4gQmVzaWRlcywgaXQgc291bmRzIGEgbGl0dGxlIHN0cmFuZ2UgdG8KPiBoYXZl
IHR3byBkaWZmZXJlbnQgc2V0cyBvZiBtZXRhLWRhdGEgdG8gdHJhY2sgdGhlIGRhdGEgKGRpcnR5
IHBhZ2VzKS4KPiAKPiBIb3dldmVyLCBiaXRtYXAgaXMgZWFzaWVyIHdheSB0aGFuIHBlci12bSBy
aW5nLiBUaGUgY29uc3RyYWlucyB3aXRoCj4gcGVyLXZtIHJpbmcgaXMganVzdCBhcyBQZXRlciBw
b2ludGVkLiBTbyBsZXRzIHJldXNlIHRoZSBiaXRtYXAgdG8KPiBjb252ZXkgdGhlIGRpcnR5IHBh
Z2VzIGZvciB0aGlzIHBhcnRpY3VsYXIgY2FzZS4gSSB0aGluayB0aGUgcGF5b2ZmLAo+IGV4dHJh
IGJpdG1hcCwgaXMgYWNjZXB0YWJsZS4gRm9yIHRoaXMsIHdlIG5lZWQgYW5vdGhlciBjYXBhYmls
aXR5Cj4gKEtWTV9DQVBfRElSVFlfTE9HX1JJTkdfQklUTUFQPykgc28gdGhhdCBRRU1VIGNhbiBj
b2xsZWN0cyB0aGUgZGlydHkKPiBiaXRtYXAgaW4gdGhlIGxhc3QgcGhhc2Ugb2YgbWlncmF0aW9u
Lgo+IAo+IElmIGFsbCBvZiB1cyBhZ3JlZSBvbiB0aGlzLCBJIGNhbiBzZW5kIGFub3RoZXIga2Vy
bmVsIHBhdGNoIHRvIGFkZHJlc3MKPiB0aGlzLiBRRU1VIHN0aWxsIG5lZWQgbW9yZSBwYXRjaGVz
IHNvIHRoYXQgdGhlIGZlYXR1cmUgY2FuIGJlIHN1cHBvcnRlZC4KPiAKCkkndmUgaGFkIHRoZSBm
b2xsb3dpbmcgUEFUQ0hbdjUgMy83XSB0byByZXVzZSBiaXRtYXAgZm9yIHRoZXNlIHBhcnRpY3Vs
YXIKY2FzZXMuIEtWTV9HRVRfRElSVFlfTE9HIGFuZCBLVk1fQ0xFQVJfRElSVFlfTE9HIGlvY3Rs
cyBhcmUgdXNlZCB0byB2aXNpdAp0aGUgYml0bWFwLiBUaGUgbmV3IGNhcGFiaWxpdHkgaXMgYWR2
ZXJ0aXNlZCBieSBLVk1fQ0FQX0RJUlRZX0xPR19SSU5HX0JJVE1BUC4KTm90ZSB0aG9zZSB0d28g
aW9jdGxzIGFyZSBkaXNhYmxlZCB3aGVuIGRpcnR5LXJpbmcgaXMgZW5hYmxlZCwgd2UgbmVlZCB0
bwplbmFibGUgdGhlbSBhY2NvcmRpbmdseS4KCiAgICBQQVRDSFt2NSAzLzddIEtWTTogeDg2OiBV
c2UgYml0bWFwIGluIHJpbmctYmFzZWQgZGlydHkgcGFnZSB0cmFja2luZwoKSSB3b3VsZCBsaWtl
IHRvIHBvc3QgdjUgYWZ0ZXIgc29tZW9uZSByZXZpZXdzIG9yIGFja3Mga3ZtL3NlbGZ0ZXN0cyBw
YXJ0Cm9mIHRoaXMgc2VyaWVzLgoKWy4uLl0KClRoYW5rcywKR2F2aW4KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
