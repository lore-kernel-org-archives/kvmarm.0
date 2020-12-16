Return-Path: <SRS0=5C08=FU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F80C4361B
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 10:36:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D18623359
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 10:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D18623359
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 533C74B4CE;
	Wed, 16 Dec 2020 05:36:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 440eoY7RfGm2; Wed, 16 Dec 2020 05:36:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3026D4B4D4;
	Wed, 16 Dec 2020 05:36:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 897714B4CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 05:36:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k2Li25UkiZcW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2020 05:36:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B3B54B3DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 05:36:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1608114971;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=t9CKeWnWAx3u5eiNFnwtMWhwXN3PXTOPoJxw+acCycA=;
 b=D7vAADOETkmzX7MpmZt4RyiXhLVq49rfKFzzElh5ICu4C2qf/jNWwROPhR/Yai/A/6Spru
 /hLARqnbA7DEbokqBBUUDKNLg5fETqMqHvzZzKzrMIZNM24l7wC+LK/9wDboowln9ATZ7s
 VVDmEiCY2z/zcehJeeqFL0n4N1kI6Dw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-njN3WV6WMg-q2N8opfkSmQ-1; Wed, 16 Dec 2020 05:36:06 -0500
X-MC-Unique: njN3WV6WMg-q2N8opfkSmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83CB58030AC;
 Wed, 16 Dec 2020 10:36:03 +0000 (UTC)
Received: from [10.36.112.243] (ovpn-112-243.ams2.redhat.com [10.36.112.243])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7449860C43;
 Wed, 16 Dec 2020 10:35:55 +0000 (UTC)
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
To: Shenming Lu <lushenming@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
 <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
 <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
 <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
 <274dafb2e21f49326a64bb575e668793@kernel.org>
 <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <f8b398df-9945-9ce6-18e6-970637a1bb51@redhat.com>
Date: Wed, 16 Dec 2020 11:35:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Neo Jia <cjia@nvidia.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

SGkgU2hlbm1pbmcsCgpPbiAxMi8xLzIwIDE6MTUgUE0sIFNoZW5taW5nIEx1IHdyb3RlOgo+IE9u
IDIwMjAvMTIvMSAxOTo1MCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIwLTEyLTAxIDEx
OjQwLCBTaGVubWluZyBMdSB3cm90ZToKPj4+IE9uIDIwMjAvMTIvMSAxODo1NSwgTWFyYyBaeW5n
aWVyIHdyb3RlOgo+Pj4+IE9uIDIwMjAtMTEtMzAgMDc6MjMsIFNoZW5taW5nIEx1IHdyb3RlOgo+
Pj4+Cj4+Pj4gSGkgU2hlbm1pbmcsCj4+Pj4KPj4+Pj4gV2UgYXJlIHBvbmRlcmluZyBvdmVyIHRo
aXMgcHJvYmxlbSB0aGVzZSBkYXlzLCBidXQgc3RpbGwgZG9uJ3QgZ2V0IGEKPj4+Pj4gZ29vZCBz
b2x1dGlvbi4uLgo+Pj4+PiBDb3VsZCB5b3UgZ2l2ZSB1cyBzb21lIGFkdmljZSBvbiB0aGlzPwo+
Pj4+Pgo+Pj4+PiBPciBjb3VsZCB3ZSBtb3ZlIHRoZSByZXN0b3Jpbmcgb2YgdGhlIHBlbmRpbmcg
c3RhdGVzIChpbmNsdWRlIHRoZSBzeW5jCj4+Pj4+IGZyb20gZ3Vlc3QgUkFNIGFuZCB0aGUgdHJh
bnNmZXIgdG8gSFcpIHRvIHRoZSBHSUMgVk0gc3RhdGUgY2hhbmdlIGhhbmRsZXIsCj4+Pj4+IHdo
aWNoIGlzIGNvbXBsZXRlbHkgY29ycmVzcG9uZGluZyB0byBzYXZlX3BlbmRpbmdfdGFibGVzICht
b3JlIHN5bW1ldHJpYz8pCj4+Pj4+IGFuZCBkb24ndCBleHBvc2UgR0lDdjQuLi4KPj4+Pgo+Pj4+
IFdoYXQgaXMgInRoZSBHSUMgVk0gc3RhdGUgY2hhbmdlIGhhbmRsZXIiPyBJcyB0aGF0IGEgUUVN
VSB0aGluZz8KPj4+Cj4+PiBZZWFoLCBpdCBpcyBhIGEgUUVNVSB0aGluZy4uLgo+Pj4KPj4+PiBX
ZSBkb24ndCByZWFsbHkgaGF2ZSB0aGF0IGNvbmNlcHQgaW4gS1ZNLCBzbyBJJ2QgYXBwcmVjaWF0
ZSBpZiB5b3UgY291bGQKPj4+PiBiZSBhIGJpdCBtb3JlIGV4cGxpY2l0IG9uIHRoaXMuCj4+Pgo+
Pj4gTXkgdGhvdWdodCBpcyB0byBhZGQgYSBuZXcgaW50ZXJmYWNlICh0byBRRU1VKSBmb3IgdGhl
IHJlc3RvcmluZyBvZgo+Pj4gdGhlIHBlbmRpbmcgc3RhdGVzLCB3aGljaCBpcyBjb21wbGV0ZWx5
IGNvcnJlc3BvbmRpbmcgdG8KPj4+IEtWTV9ERVZfQVJNX1ZHSUNfU0FWRV9QRU5ESU5HX1RBQkxF
Uy4uLgo+Pj4gQW5kIGl0IGlzIGNhbGxlZCBmcm9tIHRoZSBHSUMgVk0gc3RhdGUgY2hhbmdlIGhh
bmRsZXIgaW4gUUVNVSwgd2hpY2gKPj4+IGlzIGhhcHBlbmluZyBhZnRlciB0aGUgcmVzdG9yaW5n
IChjYWxsIGt2bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKCkpCj4+PiBidXQgYmVmb3JlIHRoZSBz
dGFydGluZyAocnVubmluZykgb2YgdGhlIFZGSU8gZGV2aWNlLgo+Pgo+PiBSaWdodCwgdGhhdCBt
YWtlcyBzZW5zZS4gSSBzdGlsbCB3b25kZXIgaG93IG11Y2ggdGhlIEdJQyBzYXZlL3Jlc3RvcmUK
Pj4gc3R1ZmYgZGlmZmVycyBmcm9tIG90aGVyIGFyY2hpdGVjdHVyZXMgdGhhdCBpbXBsZW1lbnQg
c2ltaWxhciBmZWF0dXJlcywKPj4gc3VjaCBhcyB4ODYgd2l0aCBWVC1ELgo+IAo+IEkgYW0gbm90
IGZhbWlsaWFyIHdpdGggaXQuLi4KPiAKPj4KPj4gSXQgaXMgb2J2aW91c2x5IHRvbyBsYXRlIHRv
IGNoYW5nZSB0aGUgdXNlcnNwYWNlIGludGVyZmFjZSwgYnV0IEkgd29uZGVyCj4+IHdoZXRoZXIg
d2UgbWlzc2VkIHNvbWV0aGluZyBhdCB0aGUgdGltZS4KPiAKPiBUaGUgaW50ZXJmYWNlIHNlZW1z
IHRvIGJlIHJlYWxseSBhc3ltbWV0cmljYWw/Li4uCgppbiBxZW11IGQ1YWEwYzIyOWEgKCJody9p
bnRjL2FybV9naWN2M19rdm06IEltcGxlbWVudCBwZW5kaW5nIHRhYmxlCnNhdmUiKSBjb21taXQg
bWVzc2FnZSwgaXQgaXMgdHJhY2VkOgoKIlRoZXJlIGlzIG5vIGV4cGxpY2l0IHJlc3RvcmUgYXMg
dGhlIHRhYmxlcyBhcmUgaW1wbGljaXRseSBzeW5jJ2VkCm9uIElUUyB0YWJsZSByZXN0b3JlIGFu
ZCBvbiBMUEkgZW5hYmxlIGF0IHJlZGlzdHJpYnV0b3IgbGV2ZWwuIgoKQXQgdGhhdCB0aW1lIHRo
ZXJlIHdhcyBubyByZWFsIGp1c3RpZmljYXRpb24gYmVoaW5kIGFkZGluZyB0aGUgUkVTVE9SRQpm
ZWxsb3cgYXR0ci4KCk1heWJlIGEgc3R1cGlkIHF1ZXN0aW9uIGJ1dCBpc24ndCBpdCBwb3NzaWJs
ZSB0byB1bnNldCB0aGUgZm9yd2FyZGluZwp3aGVuIHNhdmluZyBhbmQgcmVseSBvbiBWRklPIHRv
IGF1dG9tYXRpY2FsbHkgcmVzdG9yZSBpdCB3aGVuIHJlc3VtaW5nCm9uIGRlc3RpbmF0aW9uPwoK
VGhhbmtzCgpFcmljCgoKPiAKPiBPciBpcyB0aGVyZSBhIHBvc3NpYmlsaXR5IHRoYXQgd2UgY291
bGQga25vdyB3aGljaCBpcnEgaXMgaHcgYmVmb3JlIHRoZSBWRklPCj4gZGV2aWNlIGNhbGxzIGt2
bV92Z2ljX3Y0X3NldF9mb3J3YXJkaW5nKCk/Cj4gCj4gVGhhbmtzLAo+IFNoZW5taW5nCj4gCj4+
Cj4+IFRoYW5rcywKPj4KPj4gwqDCoMKgwqDCoMKgwqAgTS4KPiAKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
