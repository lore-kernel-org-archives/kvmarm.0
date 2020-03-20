Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BC6C4332E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 11:09:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CABF2072C
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 11:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BTYBcJCC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CABF2072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9B44B08F;
	Fri, 20 Mar 2020 07:09:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xNRK7qaPtxQw; Fri, 20 Mar 2020 07:09:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B81304A578;
	Fri, 20 Mar 2020 07:09:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B4654A4FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 07:09:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dorTTgisCHln for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 07:09:31 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A994A4AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 07:09:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584702570;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=FG3rV03ORdL5dZYsmjHuCpupbanGtM2DORWeRbjL06s=;
 b=BTYBcJCCk6QFYVX73N6jfPHZjc2Ol/bnYAOADhsbYdSilTco0vL1QrNyVZL+khpsWzZbo5
 q0cwDFb6NEuaQsWEkUAEm23l+G+84Nm2UnbkvcOOEiqIseRcY7J5UUtikj2VGrG67Dp2PV
 WvKxpZcMpR5sWbaFVSZ909DHnVr/v7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-XhybzQHaNwiNF6Rbkf4nkw-1; Fri, 20 Mar 2020 07:09:29 -0400
X-MC-Unique: XhybzQHaNwiNF6Rbkf4nkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4D3D189D6C3;
 Fri, 20 Mar 2020 11:09:26 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B60AD60C18;
 Fri, 20 Mar 2020 11:09:22 +0000 (UTC)
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
 <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
 <e60578b5-910c-0355-d231-29322900679d@redhat.com>
 <dfaf8a1b7c7fd8b769a244a8a779d952@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <02350520-8591-c62c-e7fa-33db30c25b96@redhat.com>
Date: Fri, 20 Mar 2020 12:09:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <dfaf8a1b7c7fd8b769a244a8a779d952@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
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

SGkgTWFyYywKCk9uIDMvMjAvMjAgMTA6NDYgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDIwLTAzLTIwIDA3OjU5LCBBdWdlciBFcmljIHdyb3RlOgo+PiBIaSBaZW5naHVpLAo+Pgo+PiBP
biAzLzIwLzIwIDQ6MDggQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4+PiBPbiAyMDIwLzMvMjAgNDoz
OCwgQXVnZXIgRXJpYyB3cm90ZToKPj4+PiBIaSBNYXJjLAo+Pj4+IE9uIDMvMTkvMjAgMToxMCBQ
TSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+PiBIaSBaZW5naHVpLAo+Pj4+Pgo+Pj4+PiBPbiAy
MDIwLTAzLTE4IDA2OjM0LCBaZW5naHVpIFl1IHdyb3RlOgo+Pj4+Pj4gSGkgTWFyYywKPj4+Pj4+
Cj4+Pj4+PiBPbiAyMDIwLzMvNSA0OjMzLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4+Pj4gVGhl
IEdJQ3Y0LjEgYXJjaGl0ZWN0dXJlIGdpdmVzIHRoZSBoeXBlcnZpc29yIHRoZSBvcHRpb24gdG8g
bGV0Cj4+Pj4+Pj4gdGhlIGd1ZXN0IGNob29zZSB3aGV0aGVyIGl0IHdhbnRzIHRoZSBnb29kIG9s
ZCBTR0lzIHdpdGggYW4KPj4+Pj4+PiBhY3RpdmUgc3RhdGUsIG9yIHRoZSBuZXcsIEhXLWJhc2Vk
IG9uZXMgdGhhdCBkbyBub3QgaGF2ZSBvbmUuCj4+Pj4+Pj4KPj4+Pj4+PiBGb3IgdGhpcywgcGx1
bWIgdGhlIGNvbmZpZ3VyYXRpb24gb2YgU0dJcyBpbnRvIHRoZSBHSUN2MyBNTUlPCj4+Pj4+Pj4g
aGFuZGxpbmcsIHByZXNlbnQgdGhlIEdJQ0RfVFlQRVIyLm5BU1NHSWNhcCB0byB0aGUgZ3Vlc3Qs
Cj4+Pj4+Pj4gYW5kIGhhbmRsZSB0aGUgR0lDRF9DVExSLm5BU1NHSXJlcSBzZXR0aW5nLgo+Pj4+
Pj4+Cj4+Pj4+Pj4gSW4gb3JkZXIgdG8gYmUgYWJsZSB0byBkZWFsIHdpdGggdGhlIHJlc3RvcmUg
b2YgYSBndWVzdCwgYWxzbwo+Pj4+Pj4+IGFwcGx5IHRoZSBHSUNEX0NUTFIubkFTU0dJcmVxIHNl
dHRpbmcgYXQgZmlyc3QgcnVuIHNvIHRoYXQgd2UKPj4+Pj4+PiBjYW4gbW92ZSB0aGUgcmVzdG9y
ZWQgU0dJcyB0byB0aGUgSFcgaWYgdGhhdCdzIHdoYXQgdGhlIGd1ZXN0Cj4+Pj4+Pj4gaGFkIHNl
bGVjdGVkIGluIGEgcHJldmlvdXMgbGlmZS4KPj4+Pj4+Cj4+Pj4+PiBJJ20gb2theSB3aXRoIHRo
ZSByZXN0b3JlIHBhdGguwqAgQnV0IGl0IHNlZW1zIHRoYXQgd2Ugc3RpbGwgZmFpbCB0bwo+Pj4+
Pj4gc2F2ZSB0aGUgcGVuZGluZyBzdGF0ZSBvZiB2U0dJIC0gc29mdHdhcmUgcGVuZGluZ19sYXRj
aCBvZiBIVy1iYXNlZAo+Pj4+Pj4gdlNHSXMgd2lsbCBub3QgYmUgdXBkYXRlZCAoYW5kIGFsd2F5
cyBiZSBmYWxzZSkgYmVjYXVzZSB3ZSBkaXJlY3RseQo+Pj4+Pj4gaW5qZWN0IHRoZW0gdGhyb3Vn
aCBJVFMsIHNvIHZnaWNfdjNfdWFjY2Vzc19yZWFkX3BlbmRpbmcoKSBjYW4ndAo+Pj4+Pj4gdGVs
bCB0aGUgY29ycmVjdCBwZW5kaW5nIHN0YXRlIHRvIHVzZXItc3BhY2UgKHRoZSBjb3JyZWN0IG9u
ZSBzaG91bGQKPj4+Pj4+IGJlIGxhdGNoZWQgaW4gSFcpLgo+Pj4+Pj4KPj4+Pj4+IEl0IHdvdWxk
IGJlIGdvb2QgaWYgd2UgY2FuIHN5bmMgdGhlIGhhcmR3YXJlIHN0YXRlIGludG8gcGVuZGluZ19s
YXRjaAo+Pj4+Pj4gYXQgYW4gYXBwcm9wcmlhdGUgdGltZSAoanVzdCBiZWZvcmUgc2F2ZSksIGJ1
dCBub3Qgc3VyZSBpZiB3ZSBjYW4uLi4KPj4+Pj4KPj4+Pj4gVGhlIHByb2JsZW0gaXMgdG8gZmlu
ZCB0aGUgImFwcHJvcHJpYXRlIHRpbWUiLiBJdCB3b3VsZCByZXF1aXJlIHRvCj4+Pj4+IGRlZmlu
ZQo+Pj4+PiBhIHBvaW50IGluIHRoZSBzYXZlIHNlcXVlbmNlIHdoZXJlIHdlIHRyYW5zaXRpb24g
dGhlIHN0YXRlIGZyb20gSFcgdG8KPj4+Pj4gU1cuIEknbSBub3Qga2VlbiBvbiBhZGRpbmcgbW9y
ZSBzdGF0ZSB0aGFuIHdlIGFscmVhZHkgaGF2ZS4KPj4+Pgo+Pj4+IG1heSBiZSB3ZSBjb3VsZCB1
c2UgYSBkZWRpY2F0ZWQgZGV2aWNlIGdyb3VwL2F0dHIgYXMgd2UgaGF2ZSBmb3IgdGhlCj4+Pj4g
SVRTCj4+Pj4gc2F2ZSB0YWJsZXM/IHRoZSB1c2VyIHNwYWNlIHdvdWxkIGNob29zZS4KPj4+Cj4+
PiBJdCBtZWFucyB0aGF0IHVzZXJzcGFjZSB3aWxsIGJlIGF3YXJlIG9mIHNvbWUgZm9ybSBvZiBH
SUN2NC4xIGRldGFpbHMKPj4+IChlLmcuLCBnZXQvc2V0IHZTR0kgc3RhdGUgYXQgSFcgbGV2ZWwp
IHRoYXQgS1ZNIGhhcyBpbXBsZW1lbnRlZC4KPj4+IElzIGl0IHNvbWV0aGluZyB0aGF0IHVzZXJz
cGFjZSByZXF1aXJlZCB0byBrbm93PyBJJ20gb3BlbiB0byB0aGlzIDstKQo+PiBOb3Qgc3VyZSB3
ZSB3b3VsZCBiZSBvYmxpZ2VkIHRvIGV4cG9zZSBmaW5lIGRldGFpbHMuIFRoaXMgY291bGQgYmUg
YQo+PiBnZW5lcmljIHNhdmUvcmVzdG9yZSBkZXZpY2UgZ3JvdXAvYXR0ciB3aG9zZSBpbXBsZW1l
bnRhdGlvbiBhdCBLVk0gbGV2ZWwKPj4gY291bGQgZGlmZmVyIGRlcGVuZGluZyBvbiB0aGUgdmVy
c2lvbiBiZWluZyBpbXBsZW1lbnRlZCwgbm8/Cj4gCj4gV2hhdCBwcmV2ZW50cyB1cyBmcm9tIGhv
b2tpbmcgdGhpcyBzeW5jaHJvbml6YXRpb24gdG8gdGhlIGN1cnJlbnQgYmVoYXZpb3VyCj4gb2Yg
S1ZNX0RFVl9BUk1fVkdJQ19TQVZFX1BFTkRJTkdfVEFCTEVTPyBBZnRlciBhbGwsIHRoaXMgaXMg
YWxyZWFkeSB0aGUKPiBwb2ludAo+IHdoZXJlIHdlIHN5bmNocm9uaXplIHRoZSBLVk0gdmlldyBv
ZiB0aGUgcGVuZGluZyBzdGF0ZSB3aXRoIHVzZXJzcGFjZS4KPiBIZXJlLCBpdCdzIGp1c3QgYSBt
YXR0ZXIgb2YgcGlja2luZyB0aGUgaW5mb3JtYXRpb24gZnJvbSBzb21lIG90aGVyIHBsYWNlCj4g
KGkuZS4gdGhlIGhvc3QncyB2aXJ0dWFsIHBlbmRpbmcgdGFibGUpLgphZ3JlZWQKPiAKPiBUaGUg
dGhpbmcgd2UgbmVlZCB0aG91Z2ggaXMgdGhlIGd1YXJhbnRlZSB0aGF0IHRoZSBndWVzdCBpc24n
dCBnb2luZyB0bwo+IGdldCBtb3JlIHZMUElzIGF0IHRoYXQgc3RhZ2UsIGFzIHRoZXkgd291bGQg
YmUgbG9zdC4gVGhpcyBlZmZlY3RpdmVseQo+IGFzc3VtZXMgdGhhdCB3ZSBjYW4gYWxzbyBzYXZl
L3Jlc3RvcmUgdGhlIHN0YXRlIG9mIHRoZSBzaWduYWxsaW5nIGRldmljZXMsCj4gYW5kIEkgZG9u
J3Qga25vdyBpZiB3ZSdyZSBxdWl0ZSB0aGVyZSB5ZXQuCk9uIFFFTVUsIHdoZW4gS1ZNX0RFVl9B
Uk1fVkdJQ19TQVZFX1BFTkRJTkdfVEFCTEVTIGlzIGNhbGxlZCwgdGhlIFZNIGlzCnN0b3BwZWQu
ClNlZSBjZGRhZmQ4ZjM1M2QgKCJody9pbnRjL2FybV9naWN2M19pdHM6IEltcGxlbWVudCBzdGF0
ZSBzYXZlL3Jlc3RvcmUiKQpTbyBJIHRoaW5rIGl0IHNob3VsZCB3b3JrLCBubz8KClRoYW5rcwoK
RXJpYwoKPiAKPiBUaGFua3MsCj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
