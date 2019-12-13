Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0273C43603
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 10:55:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6BEAE2073D
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 10:55:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWHBP7Gv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BEAE2073D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFFF24A959;
	Fri, 13 Dec 2019 05:55:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KV7wkJ07wCMh; Fri, 13 Dec 2019 05:55:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D344A598;
	Fri, 13 Dec 2019 05:55:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79ADB4A54B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 05:55:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 67w+u6j0NrEO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 05:55:18 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 919C24A4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 05:55:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576234518;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1kwjbmvTQEgQPtwglmAiSLhwOadpCH9FVfDLCODG9fU=;
 b=eWHBP7Gvv3gOifWnqRdKrM+J/IDi1tiCdl5WhPdlBQXUxCb5XzCF6dsDcggfy90XqvQpmk
 tRIBUfqO+Y6R4oFdpXkBCX6FIb5QLuoWK/5GTWEiAX99hOk1KKPXy4cLop16rR45gph1KJ
 al4L/GphUvqbtWl23niCmhBwJKNdlyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-PdXFiR_lNhG6kYJICE0Xog-1; Fri, 13 Dec 2019 05:55:14 -0500
X-MC-Unique: PdXFiR_lNhG6kYJICE0Xog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92C77DB63;
 Fri, 13 Dec 2019 10:55:13 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BEFE10013A1;
 Fri, 13 Dec 2019 10:55:12 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Fix restoration of unmapped
 collections
To: Marc Zyngier <maz@kernel.org>
References: <20191213094237.19627-1-eric.auger@redhat.com>
 <2634d1361ac3d5518b3bea62dc40ab06@www.loen.fr>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <9d84b239-3901-f995-765b-97b7574d0d74@redhat.com>
Date: Fri, 13 Dec 2019 11:55:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2634d1361ac3d5518b3bea62dc40ab06@www.loen.fr>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 eric.auger.pro@gmail.com
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

SGkgTWFyYywKCk9uIDEyLzEzLzE5IDExOjQzIEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDE5LTEyLTEzIDA5OjQyLCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBTYXZp
bmcvcmVzdG9yaW5nIGFuIHVubWFwcGVkIGNvbGxlY3Rpb24gaXMgYSB2YWxpZCBzY2VuYXJpby4g
Rm9yCj4+IGV4YW1wbGUgdGhpcyBoYXBwZW5zIGlmIGEgTUFQVEkgY29tbWFuZCB3YXMgc2VudCwg
ZmVhdHVyaW5nIGFuCj4+IHVubWFwcGVkIGNvbGxlY3Rpb24uIEF0IHRoZSBtb21lbnQgdGhlIENU
RSBmYWlscyB0byBiZSByZXN0b3JlZC4KPj4gT25seSBjb21wYXJlIGFnYWluc3QgdGhlIG51bWJl
ciBvZiBvbmxpbmUgdmNwdXMgaWYgdGhlIHJkaXN0Cj4+IGJhc2UgaXMgc2V0Lgo+Pgo+PiBDYzog
c3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY0LjExKwo+PiBGaXhlczogZWExYWQ1M2UxZTMxYSAo
IktWTTogYXJtNjQ6IHZnaWMtaXRzOiBDb2xsZWN0aW9uIHRhYmxlCj4+IHNhdmUvcmVzdG9yZSIp
Cj4+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4g
LS0tCj4+IMKgdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pdHMuYyB8IDMgKystCj4+IMKgMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pgo+PiBkaWZmIC0tZ2l0
IGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pdHMuYyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMt
aXRzLmMKPj4gaW5kZXggOThjNzM2MGQ5ZmI3Li4xNzkyMGQxYjM1MGEgMTAwNjQ0Cj4+IC0tLSBh
L3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaXRzLmMKPj4gKysrIGIvdmlydC9rdm0vYXJtL3ZnaWMv
dmdpYy1pdHMuYwo+PiBAQCAtMjQ3NSw3ICsyNDc1LDggQEAgc3RhdGljIGludCB2Z2ljX2l0c19y
ZXN0b3JlX2N0ZShzdHJ1Y3QgdmdpY19pdHMKPj4gKml0cywgZ3BhX3QgZ3BhLCBpbnQgZXN6KQo+
PiDCoMKgwqDCoCB0YXJnZXRfYWRkciA9ICh1MzIpKHZhbCA+PiBLVk1fSVRTX0NURV9SREJBU0Vf
U0hJRlQpOwo+PiDCoMKgwqDCoCBjb2xsX2lkID0gdmFsICYgS1ZNX0lUU19DVEVfSUNJRF9NQVNL
Owo+Pgo+PiAtwqDCoMKgIGlmICh0YXJnZXRfYWRkciA+PSBhdG9taWNfcmVhZCgma3ZtLT5vbmxp
bmVfdmNwdXMpKQo+PiArwqDCoMKgIGlmICh0YXJnZXRfYWRkciAhPSBDT0xMRUNUSU9OX05PVF9N
QVBQRUQgJiYKPj4gK8KgwqDCoMKgwqDCoMKgIHRhcmdldF9hZGRyID49IGF0b21pY19yZWFkKCZr
dm0tPm9ubGluZV92Y3B1cykpCj4+IMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+
Cj4+IMKgwqDCoMKgIGNvbGxlY3Rpb24gPSBmaW5kX2NvbGxlY3Rpb24oaXRzLCBjb2xsX2lkKTsK
PiAKPiBMb29rcyBnb29kIHRvIG1lLiBPdXQgb2YgY3VyaW9zaXR5LCBob3cgd2FzIHRoaXMgc3Bv
dHRlZD8KCkkgYW0gY3VycmVudGx5IHdyaXRpbmcgc29tZSBrdm0tdW5pdC10ZXN0cyB0byBiZXR0
ZXIgdGVzdCBJVFMgYW5kIGl0cwptaWdyYXRpb24uCgpUaGFua3MKCkVyaWMKPiAKPiBUaGFua3Ms
Cj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
