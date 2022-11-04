Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C318C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 23:58:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E90543399;
	Fri,  4 Nov 2022 19:58:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KHv9M6ua3GlZ; Fri,  4 Nov 2022 19:58:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3807548F99;
	Fri,  4 Nov 2022 19:58:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A8334291D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:58:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dc20SEH8zfFD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 19:58:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7A00413E2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:58:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667606280;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZnzJmimE900iiRy7VTWPGN9EpNmm/Y1LD4I/QC6tB0Q=;
 b=Q8ScUAZSm85Zpe9XcltcIOvTaQik44ERoDXKoLRKkGD3jG3BnTGj7RiB6IM38rJOuz8Gco
 T8Pqiy/cX6EtPbNHsfR5JDJQqZNCjy7wAnP/429r0w1jN7pvb79yjA2G7fnh4wF5u0BW7M
 dOp8u25S4zZuWxABvgBFpszZDStQgB4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-T678CyveNP-D_kNb-7hxrA-1; Fri, 04 Nov 2022 19:57:57 -0400
X-MC-Unique: T678CyveNP-D_kNb-7hxrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20CF785A583;
 Fri,  4 Nov 2022 23:57:46 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 343EFC16932;
 Fri,  4 Nov 2022 23:57:26 +0000 (UTC)
Subject: Re: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64
 cleanup/fixes
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20221020071209.559062-1-gshan@redhat.com>
 <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ee1167f3-5b43-55a9-c815-b759d243dc4e@redhat.com>
Date: Sat, 5 Nov 2022 07:57:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

T24gMTAvMjUvMjIgNzoxOCBBTSwgTWFjaWVqIFMuIFN6bWlnaWVybyB3cm90ZToKPiBPbiAyMC4x
MC4yMDIyIDA5OjEyLCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBrdm0vc2VsZnRlc3RzL21lbXNsb3Rz
X3BlcmZfdGVzdCBkb2Vzbid0IHdvcmsgd2l0aCA2NEtCLXBhZ2Utc2l6ZS1ob3N0Cj4+IGFuZCA0
S0ItcGFnZS1zaXplLWd1ZXN0IG9uIGFhcmNoNjQuIEluIHRoZSBpbXBsZW1lbnRhdGlvbiwgdGhl
IGhvc3QgYW5kCj4+IGd1ZXN0IHBhZ2Ugc2l6ZSBoYXZlIGJlZW4gaGFyZGNvZGVkIHRvIDRLQi4g
SXQncyBvdmJpb3VzbHkgbm90IHdvcmtpbmcKPj4gb24gYWFyY2g2NCB3aGljaCBzdXBwb3J0cyA0
S0IsIDE2S0IsIDY0S0IgaW5kaXZpZHVhbGx5IG9uIGhvc3QgYW5kIGd1ZXN0Lgo+Pgo+PiBUaGlz
IHNlcmllcyB0cmllcyB0byBmaXggaXQuIEFmdGVyIHRoZSBzZXJpZXMgaXMgYXBwbGllZCwgdGhl
IHRlc3QgcnVucwo+PiBzdWNjZXNzZnVsbHkgd2l0aCA2NEtCLXBhZ2Utc2l6ZS1ob3N0IGFuZCA0
S0ItcGFnZS1zaXplLWd1ZXN0Lgo+Pgo+PiDCoMKgwqAgIyAuL21lbXNsb3RzX3BlcmZfdGVzdHMg
LXYgLXMgNTEyCj4+Cj4+IFNpbmNlIHdlJ3JlIGhlcmUsIHRoZSBjb2RlIGlzIGNsZWFuZWQgdXAg
YSBiaXQgYXMgUEFUQ0hbMS0zXSBkby4gVGhlCj4+IG90aGVyIHBhdGNoZXMgYXJlIGZpeGVzIHRv
IGhhbmRsZSB0aGUgbWlzbWF0Y2hlZCBob3N0L2d1ZXN0IHBhZ2UKPj4gc2l6ZWQuCj4+Cj4+IHYx
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm1hcm0vMjAyMjEwMTQwNzE5MTQuMjI3MTM0LTEt
Z3NoYW5AcmVkaGF0LmNvbS9ULyN0Cj4+IHYyOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm1h
cm0vMjAyMjEwMTgwNDA0NTQuNDA1NzE5LTEtZ3NoYW5AcmVkaGF0LmNvbS9ULyN0Cj4+Cj4+IENo
YW5nZWxvZwo+PiA9PT09PT09PT0KPj4gdjM6Cj4+IMKgwqAgKiBJbXByb3ZlZCBjb21tZW50cyBh
Ym91dCBNRU1fVEVTVF9NT1ZFX1NJWkUsIHdoaWNoIGlzIHNldAo+PiDCoMKgwqDCoCB0byA2NEtC
IGluIFBBVENIW3YzIDQvNl0gYW5kIGZpbmFsbHkgZml4ZWQgdG8gMTkyS0IgaW4KPj4gwqDCoMKg
wqAgUEFUQ0hbdjMgNS82XS7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKE1hY2ll
aikKPj4gwqDCoCAqIFVzZSBzaXplIGluc3RlYWQgb2YgcGFnZXMgdG8gZG8gdGhlIGNvbXBhcmlz
b24gaW4KPj4gwqDCoMKgwqAgdGVzdF9tZW1zbG90X21vdmVfcHJlcGFyZSgpwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoTWFj
aWVqKQo+PiDCoMKgICogVXNlIHRvb2xzL2luY2x1ZGUvbGludXgvc2l6ZXMuaCBpbnN0ZWFkIG9m
IGludmVudGluZwo+PiDCoMKgwqDCoCBvdXIgb3duIG1hY3Jvcy7CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIChPbGl2ZXIpCj4+IHYyOgo+PiDCoMKgICogUGljayB0aGUgc21hbGxlciB2
YWx1ZSBiZXR3ZWVuIHRoZSBvbmVzIHNwZWNpZmllZCBieQo+PiDCoMKgwqDCoCB1c2VyIG9yIHBy
b2JlZCBmcm9tIEtWTV9DQVBfTlJfTUVNU0xPVFMgaW4gUEFUQ0hbdjIgMy82XcKgwqDCoCAoTWFj
aWVqKQo+PiDCoMKgICogSW1wcm92ZWQgY29tbWVudHMgYWJvdXQgTUVNX1RFU1RfTU9WRV9TSVpF
IGluCj4+IMKgwqDCoMKgIFBBVENIW3YyIDQvNl3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAoTWFjaWVqKQo+PiDCoMKgICogQXZvaWQgbWlzbWF0Y2hlZCBndWVzdCBwYWdlIHNp
emUgYWZ0ZXIgVk0gaXMgc3RhcnRlZCBpbgo+PiDCoMKgwqDCoCBwcmVwYXJlX3ZtKCkgaW4gUEFU
Q0hbdjIgNC82XcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAoTWFjaWVqKQo+PiDCoMKgICogRml4IGNvbmRpdGlvbiB0byBjaGVjayBN
RU1fVEVTVF97VU5NQVAsIFVOTUFQX0NIVU5LfV9TSVpFCj4+IMKgwqDCoMKgIGluIGNoZWNrX21l
bW9yeV9zaXplKCkgaW4gUEFUQ0hbdjIgNC82XcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgKE1hY2llaikKPj4gwqDCoCAqIERlZmluZSBiYXNlIGFuZCBodWdlIHBhZ2Ug
c2l6ZSBpbiBrdm1fdXRpbF9iYXNlLmggaW4KPj4gwqDCoMKgwqAgUEFUQ0hbdjIgNS82XcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIChTZWFuKQo+PiDCoMKgICogQWRkIGNoZWNr
cyBvbiBob3N0L2d1ZXN0IHBhZ2Ugc2l6ZSBpbiBjaGVja19tZW1vcnlfc2l6ZSgpCj4+IMKgwqDC
oMKgIGFuZCBmYWlsIGVhcmx5IGlmIGFueSBvZiB0aGVtIGV4Y2VlZHMgNjRLQiBpbiBQQVRDSFt2
MiA1LzZdIChNYWNpZWopCj4+Cj4+Cj4+IEdhdmluIFNoYW4gKDYpOgo+PiDCoMKgIEtWTTogc2Vs
ZnRlc3RzOiBtZW1zbG90X3BlcmZfdGVzdDogVXNlIGRhdGEtPm5zbG90cyBpbiBwcmVwYXJlX3Zt
KCkKPj4gwqDCoCBLVk06IHNlbGZ0ZXN0czogbWVtc2xvdF9wZXJmX3Rlc3Q6IENvbnNvbGlkYXRl
IGxvb3AgY29uZGl0aW9ucyBpbgo+PiDCoMKgwqDCoCBwcmVwYXJlX3ZtKCkKPj4gwqDCoCBLVk06
IHNlbGZ0ZXN0czogbWVtc2xvdF9wZXJmX3Rlc3Q6IFByb2JlIG1lbW9yeSBzbG90cyBmb3Igb25j
ZQo+PiDCoMKgIEtWTTogc2VsZnRlc3RzOiBtZW1zbG90X3BlcmZfdGVzdDogU3VwcG9ydCB2YXJp
YWJsZSBndWVzdCBwYWdlIHNpemUKPj4gwqDCoCBLVk06IHNlbGZ0ZXN0czogbWVtc2xvdF9wZXJm
X3Rlc3Q6IENvbnNvbGlkYXRlIG1lbW9yeQo+PiDCoMKgIEtWTTogc2VsZnRlc3RzOiBtZW1zbG90
X3BlcmZfdGVzdDogUmVwb3J0IG9wdGltYWwgbWVtb3J5IHNsb3RzCj4+Cj4gCj4gVGhpcyBwYXRj
aCBzZXQgbm93IGxvb2tzIGdvb2QgdG8gbWUsIHNvIGZvciB0aGUgd2hvbGUgc2VyaWVzOgo+IFJl
dmlld2VkLWJ5OiBNYWNpZWogUy4gU3ptaWdpZXJvIDxtYWNpZWouc3ptaWdpZXJvQG9yYWNsZS5j
b20+Cj4gCgpUaGFua3MgZm9yIHlvdXIgdGltZSBvbiByZXZpZXdzLCBNYWNpZWouIFRoZSBicm9r
ZW4gdGVzdCBjYXNlIHdhcyByZXBvcnRlZAppbiBvdXIgZG93bnN0cmVhbSBMaW51eCwgd2hpY2gg
bWVhbnMgb3VyIGRvd25zdHJlYW0gbGludXggbmVlZHMgdGhlIGltcHJvdmVtZW50cwphbmQgZml4
ZXMgdG8gbWFrZSB0aGUgdGVzdCBjYXNlIHdvcmtpbmcuCgpUaGFua3MsCkdhdmluCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
