Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B4AC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 07:13:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB81B4B0B3;
	Thu, 13 Jan 2022 02:13:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DiZiZIafrvQi; Thu, 13 Jan 2022 02:13:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC11C4AC78;
	Thu, 13 Jan 2022 02:13:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95EA14AC78
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:13:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4w+zFKaJAVbt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 02:13:40 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FED54A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:13:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642058020;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ArUbr7W7ik02hU0NABKd25g1aVuXZ4WkMZc8n6qsFfo=;
 b=V65KADkQMzYRz8Bd+xS86mGiP/2XFgonMpBxqqqGQvasbp9pUJDJn82q/OCRhYo/dyk1S0
 05B7fiv0rjp+UknU0trBTvGJBalcPei/NGx1quw0QfH8WeIU3lhMUVnndpwynVIE+UyI/R
 m8VCVslhM+rtBNvQ0ld6P2GpbOYij24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-ttrmkoK6M72JdX4nAPg7JA-1; Thu, 13 Jan 2022 02:13:39 -0500
X-MC-Unique: ttrmkoK6M72JdX4nAPg7JA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30AD883DD21;
 Thu, 13 Jan 2022 07:13:38 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DA3D16A50;
 Thu, 13 Jan 2022 07:13:33 +0000 (UTC)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
From: Gavin Shan <gshan@redhat.com>
To: Shannon Zhao <shannon.zhaosl@gmail.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
 <40d818a2-0c91-e06e-6ce8-ac8123b8d1d4@gmail.com>
 <798ecbb0-f369-f3e7-ad50-78acfd902d1d@redhat.com>
Message-ID: <71b87778-ea60-b01d-9010-789feb1e16fa@redhat.com>
Date: Thu, 13 Jan 2022 15:13:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <798ecbb0-f369-f3e7-ad50-78acfd902d1d@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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

SGkgU2hhbm5vbiwKCk9uIDEvMTMvMjIgMzowMiBQTSwgR2F2aW4gU2hhbiB3cm90ZToKPiBPbiAx
LzExLzIyIDU6NDMgUE0sIFNoYW5ub24gWmhhbyB3cm90ZToKPj4gT24gMjAyMS84LzE1IDg6MTMs
IEdhdmluIFNoYW4gd3JvdGU6Cj4+PiArc3RhdGljIHVuc2lnbmVkIGxvbmcga3ZtX3NkZWlfaHlw
ZXJjYWxsX2NvbnRleHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4gK3sKPj4+ICvCoMKgwqAg
c3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOwo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlf
a3ZtICprc2RlaSA9IGt2bS0+YXJjaC5zZGVpOwo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlf
dmNwdSAqdnNkZWkgPSB2Y3B1LT5hcmNoLnNkZWk7Cj4+PiArwqDCoMKgIHN0cnVjdCBrdm1fc2Rl
aV92Y3B1X3JlZ3MgKnJlZ3M7Cj4+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgaW5kZXggPSBzbWNj
Y19nZXRfYXJnMSh2Y3B1KTsKPj4+ICvCoMKgwqAgdW5zaWduZWQgbG9uZyByZXQgPSBTREVJX1NV
Q0NFU1M7Cj4+PiArCj4+PiArwqDCoMKgIC8qIFNhbml0eSBjaGVjayAqLwo+Pj4gK8KgwqDCoCBp
ZiAoIShrc2RlaSAmJiB2c2RlaSkpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBTREVJX05P
VF9TVVBQT1JURUQ7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+PiArwqDCoMKgIH0K
Pj4gTWF5YmUgd2UgY291bGQgbW92ZSB0aGVzZSBjb21tb24gc2FuaXR5IGNoZWNrIGNvZGVzIHRv
IGt2bV9zZGVpX2h5cGVyY2FsbCB0byBzYXZlIHNvbWUgbGluZXMuCj4+Cj4gCj4gTm90IGFsbCBo
eXBlcmNhbGxzIG5lZWQgdGhpcyBjaGVjay4gRm9yIGV4YW1wbGUsIENPTVBMRVRFL0NPTVBMRVRF
X1JFU1VNRS9DT05URVhUIGRvbid0Cj4gaGF2ZSBTREVJIGV2ZW50IG51bWJlciBhcyB0aGUgYXJn
dW1lbnQuIElmIHdlIHJlYWxseSB3YW50IG1vdmUgdGhpcyBjaGVjayBpbnRvIGZ1bmN0aW9uCj4g
a3ZtX3NkZWlfaHlwZXJjYWxsKCksIHdlIHdvdWxkIGhhdmUgY29kZSBsaWtlIGJlbG93LiBUb28g
bXVjaCBkdXBsaWNhdGVkIHNuaXBwZXRzIHdpbGwKPiBiZSBzZWVuLiBJIGRvbid0IHRoaW5rIGl0
J3MgYmV0dGVyIHRoYW4gd2hhdCB3ZSBoYXZlIGlmIEkgZnVsbHkgdW5kZXJzdGFuZCB5b3VyIGNv
bW1lbnRzLgo+IAoKb29wcy4uLiBzb3JyeS4gUGxlYXNlIGlnbm9yZSBteSBwcmV2aW91cyByZXBs
eS4gSSB0aG91Z2h0IHlvdSB0YWxrIGFib3V0CnRoZSBjaGVjayBvbiB0aGUgU0RFSSBldmVudCBu
dW1iZXIgd3JvbmdseS4gWWVzLCB5b3UncmUgY29ycmVjdCB0aGF0IHRoZQpjaGVjayBzaG91bGQg
YmUgbW92ZWQgdG8ga3ZtX3NkZWlfaHlwZXJjYWxsKCkuCgpUaGFua3MsCkdhdmluCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
