Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D9FC2D0A3
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:52:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 348ED22226
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:52:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbFtpAX3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 348ED22226
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1404B3B6;
	Tue,  3 Nov 2020 08:52:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OodmG3kyHqvn; Tue,  3 Nov 2020 08:52:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96C974B343;
	Tue,  3 Nov 2020 08:52:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CEE54B343
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:52:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w3RrkNQR8hwY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 08:52:54 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 997ED4B31D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:52:54 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604411574;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5s1o/DGi//7okuKPAs+fgFfyMIVMys/OQo4UThSJDlY=;
 b=PbFtpAX32lxhfepdjpgTw5tYshlqNeDTt8GiVcYBbOMo3iDF6uKrgLZKXkTzfTKjl2wFoo
 XUHpID0sLcn+hTKPCbpNsK2YBXZ8IbKghWZvNgelUnEdHuCJOeOZttK4G4zJY3CVEm9KRg
 ZNYAipfJL6To5N7tb0eaPUr1JZBXtKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-MD1kglPSMuqrJbfSPRE1yA-1; Tue, 03 Nov 2020 08:52:50 -0500
X-MC-Unique: MD1kglPSMuqrJbfSPRE1yA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E6396D242;
 Tue,  3 Nov 2020 13:52:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B41186266E;
 Tue,  3 Nov 2020 13:52:47 +0000 (UTC)
Date: Tue, 3 Nov 2020 14:52:44 +0100
From: Andrew Jones <drjones@redhat.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fix get-reg-list regression
Message-ID: <20201103135244.bbgpp2b33mlqpan4@kamzik.brq.redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201103113726.GJ6882@arm.com>
MIME-Version: 1.0
In-Reply-To: <20201103113726.GJ6882@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, xu910121@sina.com, kvmarm@lists.cs.columbia.edu
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

T24gVHVlLCBOb3YgMDMsIDIwMjAgYXQgMTE6Mzc6MjdBTSArMDAwMCwgRGF2ZSBNYXJ0aW4gd3Jv
dGU6Cj4gT24gTW9uLCBOb3YgMDIsIDIwMjAgYXQgMDc6NTA6MzRQTSArMDEwMCwgQW5kcmV3IEpv
bmVzIHdyb3RlOgo+ID4g5byg5Lic5petIDx4dTkxMDEyMUBzaW5hLmNvbT4gcmVwb3J0ZWQgYSBy
ZWdyZXNzaW9uIHNlZW4gd2l0aCBDZW50T1MKPiA+IHdoZW4gbWlncmF0aW5nIGZyb20gYW4gb2xk
IGtlcm5lbCB0byBhIG5ldyBvbmUuIFRoZSBwcm9ibGVtIHdhcwo+ID4gdGhhdCBRRU1VIHJlamVj
dGVkIHRoZSBtaWdyYXRpb24gc2luY2UgS1ZNX0dFVF9SRUdfTElTVCByZXBvcnRlZAo+ID4gYSBy
ZWdpc3RlciB3YXMgbWlzc2luZyBvbiB0aGUgZGVzdGluYXRpb24uIEV4dHJhIHJlZ2lzdGVycyBh
cmUgT0sKPiA+IG9uIHRoZSBkZXN0aW5hdGlvbiwgYnV0IG5vdCBtaXNzaW5nIG9uZXMuIFRoZSBy
ZWdyZXNzaW9uIHJlcHJvZHVjZXMKPiA+IHdpdGggdXBzdHJlYW0ga2VybmVscyB3aGVuIG1pZ3Jh
dGluZyBmcm9tIGEgNC4xNSBvciBsYXRlciBrZXJuZWwsCj4gPiB1cCB0byBvbmUgd2l0aCBjb21t
aXQgNzM0MzM3NjJmY2FlICgiS1ZNOiBhcm02NC9zdmU6IFN5c3RlbSByZWdpc3Rlcgo+ID4gY29u
dGV4dCBzd2l0Y2ggYW5kIGFjY2VzcyBzdXBwb3J0IiksIHRvIGEga2VybmVsIHRoYXQgaW5jbHVk
ZXMgdGhhdAo+ID4gY29tbWl0LCBlLmcuIHRoZSBsYXRlc3QgbWFpbmxpbmUgKDUuMTAtcmMyKS4K
PiA+IAo+ID4gVGhlIGZpcnN0IHBhdGNoIG9mIHRoaXMgc2VyaWVzIGlzIHRoZSBmaXguIFRoZSBu
ZXh0IHR3byBwYXRjaGVzLAo+ID4gd2hpY2ggZG9uJ3QgaGF2ZSBhbnkgaW50ZW5kZWQgZnVuY3Rp
b25hbCBjaGFuZ2VzLCBhbGxvdyBJRF9TQU5JVElTRUQKPiA+IHRvIGJlIHVzZWQgZm9yIHJlZ2lz
dGVycyB0aGF0IGZsaXAgYmV0d2VlbiBleHBvc2luZyBmZWF0dXJlcyBhbmQKPiA+IGJlaW5nIFJB
Wiwgd2hpY2ggYWxsb3dzIHNvbWUgY29kZSB0byBiZSByZW1vdmVkLgo+IAo+IElzIGl0IHdvcnRo
IHVwZGF0aW5nIERvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdCB0byBjbGFyaWZ5IHRoZQo+
IGV4cGVjdGVkIHVzZSBkdXJpbmcgVk0gbWlncmF0aW9ucywgYW5kIHRoZSBndWFyYW50ZWVzIHRo
YXQgYXJlIGV4cGVjdGVkCj4gdG8gaG9sZCBiZXR3ZWVuIG1pZ3JhdGFibGUga2VybmVsIHZlcnNp
b25zPyAgQ3VycmVudGx5IHRoZSBzcGVjaWZpY2F0aW9uCj4gaXMgYSBtaXh0dXJlIG9mICJzdXJl
bHkgaXQncyBvYnZpb3VzIiBhbmQgIndoYXRldmVyIG1ha2VzIFFFTVUgd29yayIuCj4gCj4gSSBn
dWVzcyB0aGF0IGNhdWdodCBtZSBvdXQsIGJ1dCBJJ2xsIGxldCBvdGhlcnMganVkZ2Ugd2hldGhl
ciBvdGhlcgo+IHBlb3BsZSBhcmUgbGlrZWx5IHRvIGdldCBzaW1pbGFybHkgY29uZnVzZWQuCj4K
CkknbSBub3Qgc3VyZSB3aGF0IHNlY3Rpb24gdGhpcyB3b3VsZCBmaXQgaW4gaW4gYXBpLnJzdC4g
SXQgZmVlbHMgbGlrZQp0aGlzIHNob3VsZCBiZSBhIGhpZ2hlciBsZXZlbCBkb2N1bWVudCB0aGF0
IGNvdmVycyB0aGUgbWlncmF0aW9uCmd1YXJhbnRlZXMgb2YgdGhlIEFQSSBpbiBnZW5lcmFsLiBP
ZiBjb3Vyc2UsIHdpdGggaG9zdCBjcHUgcGFzc3Rocm91Z2gsCm5vdGhpbmcgaXMgcmVhbGx5IGd1
YXJhbnRlZWQuIFRoZSB1cGdyYWRlIHBhdGggaXMgcmVhc29uYWJsZSBhbmQgcHJvYmFibHkKZG9h
YmxlIHRob3VnaC4KClRoYW5rcywKZHJldwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
