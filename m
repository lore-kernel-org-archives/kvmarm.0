Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6485DC00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 23:35:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDEA94DDAB;
	Wed, 10 Aug 2022 19:35:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(invalid, public key: DNS query timeout for
	mimecast20190719._domainkey.redhat.com) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K4BS5Sa4jSYU; Wed, 10 Aug 2022 19:35:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B20FB4DDAE;
	Wed, 10 Aug 2022 19:35:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78FC84DDA9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 19:35:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 89uh+dycYm8a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 19:35:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE7144DDA8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 19:35:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660174507;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=p4aqIasYhaSzV49q+EWgbsENRoxcrDk8IPfuEQBuSyc=;
 b=AmysuECMBK366zTUC8ssSB0JeSkJWhT5I7CmYMhQLDKW0+PT3K0XnqucWERJcm1KtuqZln
 y46rk+6e16k8kQ2ILPhkJjApg38pCgt6KqO2bRaqKb63n74l2dkblXEsVPCJiSDARVwY1B
 pZmwTS+TifKJrptqgqBkfXzXpiF4H7Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-BD_3TpmPM_y3UTMOCkcRrg-1; Wed, 10 Aug 2022 19:35:04 -0400
X-MC-Unique: BD_3TpmPM_y3UTMOCkcRrg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A52D29DD9A3;
 Wed, 10 Aug 2022 23:35:03 +0000 (UTC)
Received: from [10.64.54.77] (vpn2-54-77.bne.redhat.com [10.64.54.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 798FF492C3B;
 Wed, 10 Aug 2022 23:34:59 +0000 (UTC)
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
To: Paolo Bonzini <pbonzini@redhat.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
 <bb97efaf-4f58-c192-a489-e71ebbebce8c@redhat.com>
 <392275844.358.1660133856396.JavaMail.zimbra@efficios.com>
 <ae135a39-4190-041b-93dd-be2610125631@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <49d8b8fb-4053-cdd2-4d3c-9bf693c23a47@redhat.com>
Date: Thu, 11 Aug 2022 09:34:57 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <ae135a39-4190-041b-93dd-be2610125631@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu <yihyu@redhat.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

SGkgUGFvbG8gYW5kIE1hdGhpZXUsCgpPbiA4LzEwLzIyIDEwOjE5IFBNLCBQYW9sbyBCb256aW5p
IHdyb3RlOgo+IE9uIDgvMTAvMjIgMTQ6MTcsIE1hdGhpZXUgRGVzbm95ZXJzIHdyb3RlOgo+PiBJ
bmRlZWQsIHRoaXMgaGFjayBzZWVtcyB0byBiZSBhIGdvb2QgYXBwcm9hY2ggdG8gaW1tZWRpYXRl
bHkgZml4IHRoaW5ncyB3aXRob3V0Cj4+IG1vdmluZyBhcm91bmQgYWxsIHNvdXJjZSBmaWxlcyBh
bmQgaGVhZGVycy4gSW4gdGhlIGxvbmdlciB0ZXJtLCBJJ2QgcHJlZmVyIFNlYW4ncwo+PiBwcm9w
b3NhbCB0byBtb3ZlIHJzZXEuYyB0byB0b29scy9saWIvIChhbmQgdG8gbW92ZSByc2VxIGhlYWRl
cnMgdG8gdG9vbHMvaW5jbHVkZS9yc2VxLykuCj4+IFRoaXMgY2FuIGJlIGRvbmUgaW4gYSBmb2xs
b3cgdXAgcGhhc2UgdGhvdWdoLiBJJ2xsIHB1dCBhIG5vdGUgb24gbXkgdG9kbyBsaXN0Cj4+IGZv
ciBhZnRlciBJIGNvbWUgYmFjayBmcm9tIHZhY2F0aW9uLgo+IAo+IEdyZWF0LCBHYXZpbiwgYXJl
IHlvdSBnb2luZyB0byByZXBvc3QgdXNpbmcgbGlicnNlcT8KPiAKCkl0IHNlZW1zIHlvdSd2ZSBt
ZXJnZWQgdjIuIEkgd2lsbCBwb3N0IGFkZGl0aW9uYWwgcGF0Y2hlcyB0bwp1c2UgdG9vbHMvbGli
L2xpYnJzZXEuc28sIGRlcGVuZGluZyBvbiB3aGF0IE1hdGhpZXUgd2lsbCBoYXZlLgoKTWF0aGll
dSwgUGxlYXNlIGxldCBtZSBrbm93IGlmIHRoZXJlIGFyZSBhbnl0aGluZyBJIGNhbiBoZWxwLgoK
Pj4+IFllYWgsIHJzZXFfdGVzdCBzaG91bGQgcmV1c2UgbGlicnNlcSBjb2RlLsKgIFRoZSBzaW1w
bGVzdCB3YXksCj4+PiBpZiBzbGlnaHRseSBoYWNraXNoLCBpcyB0byBkbyBzb21ldGhpbmcgbGlr
ZQo+Pj4KPj4+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vTWFrZWZp
bGUKPj4+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlCj4+PiBpbmRleCA2
OTBiNDk5YzM0NzEuLjZjMTkyYjBlYzMwNCAxMDA2NDQKPj4+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2t2bS9NYWtlZmlsZQo+Pj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
a3ZtL01ha2VmaWxlCj4+PiBAQCAtMzcsNiArMzcsNyBAQCBpZmVxICgkKEFSQ0gpLHJpc2N2KQo+
Pj4gwqDCoMKgwqAgVU5BTUVfTSA6PSByaXNjdgo+Pj4gwqBlbmRpZgo+Pj4KPj4+IMKgTElCS1ZN
ICs9IGxpYi9hc3NlcnQuYwo+Pj4gwqBMSUJLVk0gKz0gbGliL2VsZi5jCj4+PiDCoExJQktWTSAr
PSBsaWIvZ3Vlc3RfbW9kZXMuYwo+Pj4gQEAgLTE5OCw3ICsxOTksNyBAQCBlbmRpZgo+Pj4gwqBD
RkxBR1MgKz0gLVdhbGwgLVdzdHJpY3QtcHJvdG90eXBlcyAtV3VuaW5pdGlhbGl6ZWQgLU8yIC1n
IC1zdGQ9Z251OTkgXAo+Pj4gwqDCoMKgwqAgLWZuby1zdGFjay1wcm90ZWN0b3IgLWZuby1QSUUg
LUkkKExJTlVYX1RPT0xfSU5DTFVERSkgXAo+Pj4gwqDCoMKgwqAgLUkkKExJTlVYX1RPT0xfQVJD
SF9JTkNMVURFKSAtSSQoTElOVVhfSERSX1BBVEgpIC1JaW5jbHVkZSBcCj4+PiAtwqDCoMKgIC1J
JCg8RCkgLUlpbmNsdWRlLyQoVU5BTUVfTSkgLUkuLiAkKEVYVFJBX0NGTEFHUykgJChLSERSX0lO
Q0xVREVTKQo+Pj4gK8KgwqDCoCAtSSQoPEQpIC1JaW5jbHVkZS8kKFVOQU1FX00pIC1JLi4gJChF
WFRSQV9DRkxBR1MpICQoS0hEUl9JTkNMVURFUykgLUkuLi9yc2VxCj4+Pgo+Pj4gwqBuby1waWUt
b3B0aW9uIDo9ICQoY2FsbCB0cnktcnVuLCBlY2hvICdpbnQgbWFpbigpIHsgcmV0dXJuIDA7IH0n
IHwgXAo+Pj4gwqDCoMKgwqDCoMKgwqDCoCAkKENDKSAtV2Vycm9yIC1uby1waWUgLXggYyAtIC1v
ICIkJFRNUCIsIC1uby1waWUpCj4+Pgo+Pj4KPj4+IGFuZCBqdXN0ICNpbmNsdWRlICIuLi9yc2Vx
L3JzZXEuYyIgaW4gcnNlcV90ZXN0LmMuCgpUaGFua3MsCkdhdmluCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
