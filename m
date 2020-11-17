Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A83BC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 09:59:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 735BB2464E
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 09:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZK2cnXt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 735BB2464E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 926524B788;
	Tue, 17 Nov 2020 04:59:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0D+YDicOyx6z; Tue, 17 Nov 2020 04:59:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81A484B82F;
	Tue, 17 Nov 2020 04:59:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA214B788
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 04:59:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UvwUbBVdenGQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 04:59:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 899D84B749
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 04:59:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605607178;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8mOqkemx80iqAEbsvZPEHgtzkP43+VniYkthIUbTgE4=;
 b=RZK2cnXtwrMmdRiyMhNN/KSqtllShn6yXf+ieMk+b/E5rU62aMf1pqFnVp0uwdxl2i7SJS
 a1plT0N4VP8+FvwKNUDexpeJVCiEJek5C1qn53FJoDhdE4+ztEN+mz+DiWJKdkYcfvUX9/
 KcjHhbh99UanRWfPpQ1b60HgE4NF0UQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-_3BCSZ60ORWuvma_yhqS-Q-1; Tue, 17 Nov 2020 04:59:34 -0500
X-MC-Unique: _3BCSZ60ORWuvma_yhqS-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5EA91899422;
 Tue, 17 Nov 2020 09:59:32 +0000 (UTC)
Received: from [10.36.113.230] (ovpn-113-230.ams2.redhat.com [10.36.113.230])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5A335D9CC;
 Tue, 17 Nov 2020 09:59:29 +0000 (UTC)
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Forbid invalid userspace
 Redistributor accesses
To: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20201113142801.1659-1-yuzenghui@huawei.com>
 <20201113142801.1659-2-yuzenghui@huawei.com>
 <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
 <584b7ff1-ecf2-b0ec-cea3-ccc29902f43a@huawei.com>
 <cc45285fe491aff5c28a24f94c124508@kernel.org>
 <7e58200c-814e-3598-155a-9a7e6cc24374@huawei.com>
 <c20865a267e44d1e2c0d52ce4e012263@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <5ba4a98e-276b-2462-0580-fe0e007e9b38@redhat.com>
Date: Tue, 17 Nov 2020 10:59:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c20865a267e44d1e2c0d52ce4e012263@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDExLzE3LzIwIDk6NDkgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBa
ZW5naHVpLAo+IAo+IE9uIDIwMjAtMTEtMTYgMTQ6NTcsIFplbmdodWkgWXUgd3JvdGU6Cj4+IEhp
IE1hcmMsCj4+Cj4+IE9uIDIwMjAvMTEvMTYgMjI6MTAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+
PiBNeSB0YWtlIGlzIHRoYXQgb25seSBpZiB0aGUgIltSZV1EaXN0cmlidXRvciBiYXNlIGFkZHJl
c3MiIGlzIHNwZWNpZmllZAo+Pj4+IGluIHRoZSBzeXN0ZW0gbWVtb3J5IG1hcCwgd2lsbCB0aGUg
dXNlci1wcm92aWRlZCBrdm1fZGV2aWNlX2F0dHIub2Zmc2V0Cj4+Pj4gbWFrZSBzZW5zZS4gQW5k
IHdlIGNhbiB0aGVuIGhhbmRsZSB0aGUgYWNjZXNzIHRvIHRoZSByZWdpc3RlciB3aGljaCBpcwo+
Pj4+IGRlZmluZWQgYnkgImJhc2UgYWRkcmVzcyArIG9mZnNldCIuCj4+Pgo+Pj4gSSdkIHRlbmQg
dG8gYWdyZWUsIGJ1dCBpdCBpcyBqdXN0IHRoYXQgdGhpcyBpcyBhIGxhcmdlIGNoYW5nZSBhdCAt
cmM0Lgo+Pj4gSSdkIHJhdGhlciBoYXZlIGEgcXVpY2sgZml4IGZvciA1LjEwLCBhbmQgYSBtb3Jl
IGludmFzaXZlIGNoYW5nZSBmb3IKPj4+IDUuMTEsCj4+PiBzcGFubmluZyBhbGwgdGhlIHBvc3Np
YmxlIHZnaWMgZGV2aWNlcy4KPj4KPj4gU28geW91IHByZWZlciBmaXhpbmcgaXQgYnkgInJldHVy
biBhIHZhbHVlIHRoYXQgZG9lc24ndCBoYXZlIHRoZSBMYXN0Cj4+IGJpdCBzZXQiIGZvciB2NS4x
MD8gSSdtIG9rIHdpdGggaXQgYW5kIGNhbiBzZW5kIHYyIGZvciBpdC4KPiAKPiBDb29sLiBUaGFu
a3MgZm9yIHRoYXQuCj4gCj4+IEJ0dywgbG9va2luZyBhZ2FpbiBhdCB0aGUgd2F5IHdlIGhhbmRs
ZSB0aGUgdXNlci1yZWFkaW5nIG9mIEdJQ1JfVFlQRVIKPj4KPj4gwqDCoMKgwqB2Z2ljX21taW9f
cmVhZF92M3JfdHlwZXIodmNwdSwgYWRkciwgbGVuKQo+Pgo+PiBpdCBzZWVtcyB0aGF0IEBhZGRy
IGlzIGFjdHVhbGx5IHRoZSAqb2Zmc2V0KiBvZiBHSUNSX1RZUEVSICgweDAwMDgpIGFuZAo+PiBA
YWRkciBpcyB1bmxpa2VseSB0byBiZSBlcXVhbCB0byBsYXN0X3JkaXN0X3R5cGVyLCB3aGljaCBp
cyB0aGUgKkdQQSogb2YKPj4gdGhlIGxhc3QgUkQuIExvb2tzIGxpa2UgdGhlIHVzZXItcmVhZGlu
ZyBvZiBHSUNSX1RZUEVSLkxhc3QgaXMgYWx3YXlzCj4+IGJyb2tlbj8KPiAKPiBJIHRoaW5rIHlv
dSBhcmUgcmlnaHQuIFNvbWVob3csIHdlIGRvbid0IHNlZW0gdG8gdHJhY2sgdGhlIGluZGV4IG9m
Cj4gdGhlIFJEIGluIHRoZSByZWdpb24sIHNvIHdlIGNhbiBuZXZlciBjb21wdXRlIHRoZSBhZGRy
ZXNzIG9mIHRoZSBSRAo+IGV2ZW4gaWYgdGhlIGJhc2UgYWRkcmVzcyBpcyBzZXQuCj4gCj4gTGV0
J3MgZHJvcCB0aGUgcmVwb3J0aW5nIG9mIExhc3QgZm9yIHVzZXJzcGFjZSBmb3Igbm93LCBhcyBp
dCBuZXZlcgo+IHdvcmtlZC4gSWYgeW91IHBvc3QgYSBwYXRjaCBhZGRyZXNzaW5nIHRoYXQgcXVp
Y2tseSwgSSdsbCBnZXQgaXQgdG8KPiBQYW9sbyBieSB0aGUgZW5kIG9mIHRoZSB3ZWVrICh0aGVy
ZSdzIGFub3RoZXIgZml4IHRoYXQgbmVlZHMgbWVyZ2luZykuCj4gCj4gRXJpYzogZG8gd2UgaGF2
ZSBhbnkgdGVzdCBjb3ZlcmluZyB0aGUgdXNlcnNwYWNlIEFQST8KClNvIGFzIHRoaXMgaXNzdWUg
c2VlbXMgcmVsYXRlZCB0byB0aGUgY2hhbmdlcyBtYWRlIHdoZW4gaW1wbGVtZW50aW5nIHRoZQpt
dWx0aXBsZSBSRElTVCByZWdpb25zLCBJIHZvbHVudGVlciB0byB3cml0ZSB0aG9zZSBLVk0gc2Vs
ZnRlc3RzIDotKQoKVGhhbmtzCgpFcmljCgo+IAo+IFRoYW5rcywKPiAKPiDCoMKgwqDCoMKgwqDC
oCBNLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
