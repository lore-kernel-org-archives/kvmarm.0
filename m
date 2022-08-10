Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BE3C25B08
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 09:59:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 412FA4D753;
	Wed, 10 Aug 2022 05:59:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PZ-m2QZn3GXV; Wed, 10 Aug 2022 05:59:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E64484D75B;
	Wed, 10 Aug 2022 05:59:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F37954D753
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id secFbLyi9w0k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 05:59:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 917664D751
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:59:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660125559;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8foxS5OTM5HYev6CZ4Rcys+eRHI332c6y7bWUfe28UQ=;
 b=Vc8GwjkG18VgnnxTiA9VEWTa2sDHWXftAF9u5SPu04+M8ernJ5zEedYfJK0VGpMC0p3BWs
 298f2U6sZiWyw019aB/RvGjxM9MgRkHfU7byAfwuffyX1hKZ+t9HOociXVmNmjy7XQtr7Z
 OquxeQkUP/GwBYuWvBN+/Gt6pomnReo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-LYXixRy1MdShMhEGEMMVFg-1; Wed, 10 Aug 2022 05:59:16 -0400
X-MC-Unique: LYXixRy1MdShMhEGEMMVFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F5AC811E81;
 Wed, 10 Aug 2022 09:59:15 +0000 (UTC)
Received: from [10.64.54.77] (vpn2-54-77.bne.redhat.com [10.64.54.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D98C02166B29;
 Wed, 10 Aug 2022 09:59:10 +0000 (UTC)
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
From: Gavin Shan <gshan@redhat.com>
Message-ID: <5be21a93-8a28-0214-59f0-21b56b0946a2@redhat.com>
Date: Wed, 10 Aug 2022 19:59:07 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <bb97efaf-4f58-c192-a489-e71ebbebce8c@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 andrew jones <andrew.jones@linux.dev>, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

SGkgUGFvbG8sCgpPbiA4LzEwLzIyIDc6MTQgUE0sIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gT24g
OC85LzIyIDE0OjIxLCBNYXRoaWV1IERlc25veWVycyB3cm90ZToKPj4+IEZvciBrdm0vc2VsZnRl
c3RzLCB0aGVyZSBhcmUgMyBhcmNoaXRlY3R1cmVzIGludm9sdmVkIGFjdHVhbGx5LiBTbyB3ZQo+
Pj4ganVzdCBuZWVkIGNvbnNpZGVyIDQgY2FzZXM6IGFhcmNoNjQsIHg4NiwgczM5MCBhbmQgb3Ro
ZXIuIEZvciBvdGhlcgo+Pj4gY2FzZSwgd2UganVzdCB1c2UgX19idWlsdGluX3RocmVhZF9wb2lu
dGVyKCkgdG8gbWFpbnRhaW4gY29kZSdzCj4+PiBpbnRlZ3JpdHksIGJ1dCBpdCdzIG5vdCBjYWxs
ZWQgYXQgYWxsLgo+Pj4KPj4+IEkgdGhpbmsga3ZtL3NlbGZ0ZXN0IGlzIGFsd2F5cyByZWx5aW5n
IG9uIGdsaWJjIGlmIEknbSBjb3JyZWN0Lgo+PiBBbGwgdGhvc2UgYXJlIGhhbmRsZWQgaW4gdGhl
IHJzZXEgc2VsZnRlc3RzIGFuZCBpbiBsaWJyc2VxLiBXaHkgZHVwbGljYXRlIGFsbCB0aGF0IGxv
Z2ljIGFnYWluPwo+IAo+IFllYWgsIHJzZXFfdGVzdCBzaG91bGQgcmV1c2UgbGlicnNlcSBjb2Rl
LsKgIFRoZSBzaW1wbGVzdCB3YXksCj4gaWYgc2xpZ2h0bHkgaGFja2lzaCwgaXMgdG8gZG8gc29t
ZXRoaW5nIGxpa2UKPiAKPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3Zt
L01ha2VmaWxlIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlCj4gaW5kZXgg
NjkwYjQ5OWMzNDcxLi42YzE5MmIwZWMzMDQgMTAwNjQ0Cj4gLS0tIGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtL01ha2VmaWxlCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3Zt
L01ha2VmaWxlCj4gQEAgLTM3LDYgKzM3LDcgQEAgaWZlcSAoJChBUkNIKSxyaXNjdikKPiAgwqDC
oMKgwqAgVU5BTUVfTSA6PSByaXNjdgo+ICDCoGVuZGlmCj4gCj4gIMKgTElCS1ZNICs9IGxpYi9h
c3NlcnQuYwo+ICDCoExJQktWTSArPSBsaWIvZWxmLmMKPiAgwqBMSUJLVk0gKz0gbGliL2d1ZXN0
X21vZGVzLmMKPiBAQCAtMTk4LDcgKzE5OSw3IEBAIGVuZGlmCj4gIMKgQ0ZMQUdTICs9IC1XYWxs
IC1Xc3RyaWN0LXByb3RvdHlwZXMgLVd1bmluaXRpYWxpemVkIC1PMiAtZyAtc3RkPWdudTk5IFwK
PiAgwqDCoMKgwqAgLWZuby1zdGFjay1wcm90ZWN0b3IgLWZuby1QSUUgLUkkKExJTlVYX1RPT0xf
SU5DTFVERSkgXAo+ICDCoMKgwqDCoCAtSSQoTElOVVhfVE9PTF9BUkNIX0lOQ0xVREUpIC1JJChM
SU5VWF9IRFJfUEFUSCkgLUlpbmNsdWRlIFwKPiAtwqDCoMKgIC1JJCg8RCkgLUlpbmNsdWRlLyQo
VU5BTUVfTSkgLUkuLiAkKEVYVFJBX0NGTEFHUykgJChLSERSX0lOQ0xVREVTKQo+ICvCoMKgwqAg
LUkkKDxEKSAtSWluY2x1ZGUvJChVTkFNRV9NKSAtSS4uICQoRVhUUkFfQ0ZMQUdTKSAkKEtIRFJf
SU5DTFVERVMpIC1JLi4vcnNlcQo+IAo+ICDCoG5vLXBpZS1vcHRpb24gOj0gJChjYWxsIHRyeS1y
dW4sIGVjaG8gJ2ludCBtYWluKCkgeyByZXR1cm4gMDsgfScgfCBcCj4gIMKgwqDCoMKgwqDCoMKg
wqAgJChDQykgLVdlcnJvciAtbm8tcGllIC14IGMgLSAtbyAiJCRUTVAiLCAtbm8tcGllKQo+IAo+
IAo+IGFuZCBqdXN0ICNpbmNsdWRlICIuLi9yc2VxL3JzZXEuYyIgaW4gcnNlcV90ZXN0LmMuCj4g
CgpUaGFuayB5b3UuIEl0J3MgcmVhbGx5IGEgbmljZSBpZGVhLiBJIHRoaW5rIGl0J3MgYmVzdCB3
YXkgdG8gc2hhcmUKIi4uL3JzZXEvcnNlcS5jIi4gSW4gdGhpcyB3YXksIHdlIG5lZWRuJ3QgdG8g
cmVseSBvbiAiLi4vcnNlcS9saWJyc2VxLnNvIiwKd2hpY2ggaXMgY29tcGlsZWQgYnkgIi4uL3Jz
ZXEvTWFrZWZpbGUiLgoKSSB3aWxsIG1vZGlmeSB0aGUgY29kZSBhY2NvcmRpbmdseSBpbiB2MiA6
KQoKVGhhbmtzLApHYXZpbgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
