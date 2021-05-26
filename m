Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3AEC47088
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 15:06:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC4DA613D3
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 15:06:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4DA613D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90D094029C;
	Wed, 26 May 2021 11:06:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eyfok0j7rhsH; Wed, 26 May 2021 11:06:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3474C402A9;
	Wed, 26 May 2021 11:06:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0FD1405A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 11:06:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PRpB+y4g0V2w for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 11:06:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B794029C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 11:06:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622041572;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=afXKeP+aN56rheXDqzdBoDJQ8Rg9z3z074x1aSluMhg=;
 b=M54MRcvE64ZvrlYbbzxOIII9hPXnYy4tb9BRXTY9uYTPNHL7cX7tSWfE/sAckKRCy1bCxv
 rPMmJVEPatDAC9EqsnJ8BwsShTYe5z5EHhQk1h+XNjilpanXy2ycNDPt3BH2LtD6Dz54tq
 bVy7WGEUnjKFcySmlrQ6eSAqhJrMuGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-tJpmB5i8Nb2M4hnRU64YeQ-1; Wed, 26 May 2021 11:06:05 -0400
X-MC-Unique: tJpmB5i8Nb2M4hnRU64YeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 735B9FCA3;
 Wed, 26 May 2021 15:06:04 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9436061094;
 Wed, 26 May 2021 15:06:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] scripts/arch-run: don't use
 deprecated server/nowait options
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-3-alex.bennee@linaro.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <b99b2c07-33e9-7f18-5a43-8ece655fe594@redhat.com>
Date: Wed, 26 May 2021 17:05:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-3-alex.bennee@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgQWxleCwKCk9uIDUvMjUvMjEgNzoyNiBQTSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IFRoZSB2
ZXJ5IGZhY3QgdGhhdCBRRU1VIGRyb3BzIHRoZSBkZXByZWNhdGlvbiB3YXJuaW5nIHdoaWxlIHJ1
bm5pbmcgaXMKPiBlbm91Z2ggdG8gY29uZnVzZSB0aGUgaXRzLW1pZ3JhdGlvbiB0ZXN0IGludG8g
ZmFpbGluZy4gVGhlIGJvb2xlYW4KPiBvcHRpb25zIHNlcnZlciBhbmQgd2FpdCBoYXZlIGFjY2Vw
dGVkIHRoZSBsb25nIGZvcm0gb3B0aW9ucyBmb3IgYSBsb25nCj4gdGltZS4KPiAKPiBTaWduZWQt
b2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Cj4gQ2M6IFNoYXNo
aSBNYWxsZWxhIDxzaGFzaGkubWFsbGVsYUBsaW5hcm8ub3JnPgpSZXZpZXdlZC1ieTogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKRXJpYwoKPiAtLS0KPiAgc2NyaXB0cy9hcmNo
LXJ1bi5iYXNoIHwgNCArKy0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL3NjcmlwdHMvYXJjaC1ydW4uYmFzaCBiL3Nj
cmlwdHMvYXJjaC1ydW4uYmFzaAo+IGluZGV4IDU5OTdlMzguLjcwNjkzZjIgMTAwNjQ0Cj4gLS0t
IGEvc2NyaXB0cy9hcmNoLXJ1bi5iYXNoCj4gKysrIGIvc2NyaXB0cy9hcmNoLXJ1bi5iYXNoCj4g
QEAgLTEyMiwxNCArMTIyLDE0IEBAIHJ1bl9taWdyYXRpb24gKCkKPiAgCXRyYXAgJ2tpbGwgMDsg
ZXhpdCAyJyBJTlQgVEVSTQo+ICAJdHJhcCAncm0gLWYgJHttaWdvdXQxfSAke21pZ3NvY2t9ICR7
cW1wMX0gJHtxbXAyfSAke2ZpZm99JyBSRVRVUk4gRVhJVAo+ICAKPiAtCWV2YWwgIiRAIiAtY2hh
cmRldiBzb2NrZXQsaWQ9bW9uMSxwYXRoPSR7cW1wMX0sc2VydmVyLG5vd2FpdCBcCj4gKwlldmFs
ICIkQCIgLWNoYXJkZXYgc29ja2V0LGlkPW1vbjEscGF0aD0ke3FtcDF9LHNlcnZlcj1vbix3YWl0
PW9mZiBcCj4gIAkJLW1vbiBjaGFyZGV2PW1vbjEsbW9kZT1jb250cm9sIHwgdGVlICR7bWlnb3V0
MX0gJgo+ICAKPiAgCSMgV2UgaGF2ZSB0byB1c2UgY2F0IHRvIG9wZW4gdGhlIG5hbWVkIEZJRk8s
IGJlY2F1c2UgbmFtZWQgRklGTydzLCB1bmxpa2UKPiAgCSMgcGlwZXMsIHdpbGwgYmxvY2sgb24g
b3BlbigpIHVudGlsIHRoZSBvdGhlciBlbmQgaXMgYWxzbyBvcGVuZWQsIGFuZCB0aGF0Cj4gIAkj
IHRvdGFsbHkgYnJlYWtzIFFFTVUuLi4KPiAgCW1rZmlmbyAke2ZpZm99Cj4gLQlldmFsICIkQCIg
LWNoYXJkZXYgc29ja2V0LGlkPW1vbjIscGF0aD0ke3FtcDJ9LHNlcnZlcixub3dhaXQgXAo+ICsJ
ZXZhbCAiJEAiIC1jaGFyZGV2IHNvY2tldCxpZD1tb24yLHBhdGg9JHtxbXAyfSxzZXJ2ZXI9b24s
d2FpdD1vZmYgXAo+ICAJCS1tb24gY2hhcmRldj1tb24yLG1vZGU9Y29udHJvbCAtaW5jb21pbmcg
dW5peDoke21pZ3NvY2t9IDwgPChjYXQgJHtmaWZvfSkgJgo+ICAJaW5jb21pbmdfcGlkPWBqb2Jz
IC1sICUrIHwgYXdrICd7cHJpbnQkMn0nYAo+ICAKPiAKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
