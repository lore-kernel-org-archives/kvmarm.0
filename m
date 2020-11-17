Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D49C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 09:47:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02BFB2168B
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 09:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2L4fgzw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02BFB2168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22C2F4B7DF;
	Tue, 17 Nov 2020 04:47:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VJvGSkD0-RgU; Tue, 17 Nov 2020 04:47:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA434B7F5;
	Tue, 17 Nov 2020 04:47:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C47674B7DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 04:47:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bob8ua1N3doF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 04:47:30 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1994B747
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 04:47:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605606450;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Bu5x+H+Bnz2zQiGdHqKojzUdpKyg3Vir6SAo3F4rtgE=;
 b=J2L4fgzwTK22qSKG2oCjU+k+rbh7jK4X1d7aVYaHWpdlcWEVTucPbC1ldaEtXISgnCn2E4
 2gEROxqFrOXC0ttbFkJbn2yXoJTsucnLHvzhsBfLmqhwh2ihbfg9ChtVKOgzP05nG3Vzgp
 Dzs7INYiCVkRFsoJSmvTauOu2zIYVZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-s2NKkLE0PFC24vsg_YzNkw-1; Tue, 17 Nov 2020 04:47:26 -0500
X-MC-Unique: s2NKkLE0PFC24vsg_YzNkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89190A0CD9;
 Tue, 17 Nov 2020 09:47:17 +0000 (UTC)
Received: from [10.36.113.230] (ovpn-113-230.ams2.redhat.com [10.36.113.230])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A764660C04;
 Tue, 17 Nov 2020 09:47:14 +0000 (UTC)
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
Message-ID: <ea719c25-911e-345a-61fa-648d2f01ab4a@redhat.com>
Date: Tue, 17 Nov 2020 10:47:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c20865a267e44d1e2c0d52ce4e012263@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgWmVuZ2h1aSwKCk9uIDExLzE3LzIwIDk6NDkgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBI
aSBaZW5naHVpLAo+IAo+IE9uIDIwMjAtMTEtMTYgMTQ6NTcsIFplbmdodWkgWXUgd3JvdGU6Cj4+
IEhpIE1hcmMsCj4+Cj4+IE9uIDIwMjAvMTEvMTYgMjI6MTAsIE1hcmMgWnluZ2llciB3cm90ZToK
Pj4+PiBNeSB0YWtlIGlzIHRoYXQgb25seSBpZiB0aGUgIltSZV1EaXN0cmlidXRvciBiYXNlIGFk
ZHJlc3MiIGlzIHNwZWNpZmllZAo+Pj4+IGluIHRoZSBzeXN0ZW0gbWVtb3J5IG1hcCwgd2lsbCB0
aGUgdXNlci1wcm92aWRlZCBrdm1fZGV2aWNlX2F0dHIub2Zmc2V0Cj4+Pj4gbWFrZSBzZW5zZS4g
QW5kIHdlIGNhbiB0aGVuIGhhbmRsZSB0aGUgYWNjZXNzIHRvIHRoZSByZWdpc3RlciB3aGljaCBp
cwo+Pj4+IGRlZmluZWQgYnkgImJhc2UgYWRkcmVzcyArIG9mZnNldCIuCj4+Pgo+Pj4gSSdkIHRl
bmQgdG8gYWdyZWUsIGJ1dCBpdCBpcyBqdXN0IHRoYXQgdGhpcyBpcyBhIGxhcmdlIGNoYW5nZSBh
dCAtcmM0Lgo+Pj4gSSdkIHJhdGhlciBoYXZlIGEgcXVpY2sgZml4IGZvciA1LjEwLCBhbmQgYSBt
b3JlIGludmFzaXZlIGNoYW5nZSBmb3IKPj4+IDUuMTEsCj4+PiBzcGFubmluZyBhbGwgdGhlIHBv
c3NpYmxlIHZnaWMgZGV2aWNlcy4KPj4KPj4gU28geW91IHByZWZlciBmaXhpbmcgaXQgYnkgInJl
dHVybiBhIHZhbHVlIHRoYXQgZG9lc24ndCBoYXZlIHRoZSBMYXN0Cj4+IGJpdCBzZXQiIGZvciB2
NS4xMD8gSSdtIG9rIHdpdGggaXQgYW5kIGNhbiBzZW5kIHYyIGZvciBpdC4KPiAKPiBDb29sLiBU
aGFua3MgZm9yIHRoYXQuCj4gCj4+IEJ0dywgbG9va2luZyBhZ2FpbiBhdCB0aGUgd2F5IHdlIGhh
bmRsZSB0aGUgdXNlci1yZWFkaW5nIG9mIEdJQ1JfVFlQRVIKPj4KPj4gwqDCoMKgwqB2Z2ljX21t
aW9fcmVhZF92M3JfdHlwZXIodmNwdSwgYWRkciwgbGVuKQo+Pgo+PiBpdCBzZWVtcyB0aGF0IEBh
ZGRyIGlzIGFjdHVhbGx5IHRoZSAqb2Zmc2V0KiBvZiBHSUNSX1RZUEVSICgweDAwMDgpIGFuZAo+
PiBAYWRkciBpcyB1bmxpa2VseSB0byBiZSBlcXVhbCB0byBsYXN0X3JkaXN0X3R5cGVyLCB3aGlj
aCBpcyB0aGUgKkdQQSogb2YKPj4gdGhlIGxhc3QgUkQuIExvb2tzIGxpa2UgdGhlIHVzZXItcmVh
ZGluZyBvZiBHSUNSX1RZUEVSLkxhc3QgaXMgYWx3YXlzCj4+IGJyb2tlbj8KPiAKPiBJIHRoaW5r
IHlvdSBhcmUgcmlnaHQuIFNvbWVob3csIHdlIGRvbid0IHNlZW0gdG8gdHJhY2sgdGhlIGluZGV4
IG9mCj4gdGhlIFJEIGluIHRoZSByZWdpb24sIHNvIHdlIGNhbiBuZXZlciBjb21wdXRlIHRoZSBh
ZGRyZXNzIG9mIHRoZSBSRAo+IGV2ZW4gaWYgdGhlIGJhc2UgYWRkcmVzcyBpcyBzZXQuCj4gCj4g
TGV0J3MgZHJvcCB0aGUgcmVwb3J0aW5nIG9mIExhc3QgZm9yIHVzZXJzcGFjZSBmb3Igbm93LCBh
cyBpdCBuZXZlcgo+IHdvcmtlZC4gSWYgeW91IHBvc3QgYSBwYXRjaCBhZGRyZXNzaW5nIHRoYXQg
cXVpY2tseSwgSSdsbCBnZXQgaXQgdG8KPiBQYW9sbyBieSB0aGUgZW5kIG9mIHRoZSB3ZWVrICh0
aGVyZSdzIGFub3RoZXIgZml4IHRoYXQgbmVlZHMgbWVyZ2luZykuCj4gCj4gRXJpYzogZG8gd2Ug
aGF2ZSBhbnkgdGVzdCBjb3ZlcmluZyB0aGUgdXNlcnNwYWNlIEFQST8KTm8sIHRoZXJlIGFyZSBu
byBLVk0gc2VsZnRlc3RzIGZvciB0aGF0IHlldC4KClRoYW5rcwoKRXJpYwoKPiAKPiBUaGFua3Ms
Cj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
