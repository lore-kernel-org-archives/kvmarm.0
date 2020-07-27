Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FB2C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:25:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7FAE20729
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IP1gtyvv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7FAE20729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 502074B5C1;
	Mon, 27 Jul 2020 13:25:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y+FMbA9VMNxJ; Mon, 27 Jul 2020 13:25:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E90A4B7CD;
	Mon, 27 Jul 2020 13:25:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 935F44B5C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:25:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CMMldQAaUdoE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 13:25:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A22A54B58E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:25:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A68F120714;
 Mon, 27 Jul 2020 17:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595870752;
 bh=vvXv3MqStMqM3NJh9jNTJpPY13GTNJPkpotn8K9FhpE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IP1gtyvvlK0+39RXufLMg06D6Mr2c4oupeOaksv4EiPfYKokBVfaFqw0kUMQWw56U
 +6sRjM1XbMUQaROfF+kju2j7zhv8IiXnuQqZLT+0PRUprsHSdEUnvCWSpmNNcx82uA
 YcgeonMt4LoEnwkzP4fF6xhV7hkzU9vk1IwHEcys=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k06sp-00FNbL-02; Mon, 27 Jul 2020 18:25:51 +0100
MIME-Version: 1.0
Date: Mon, 27 Jul 2020 18:25:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/5] KVM: arm64: pvtime: steal-time is only supported when
 configured
In-Reply-To: <20200711100434.46660-2-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-2-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <e2f23a105af0d7cf2daa6f3f8b596177@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgQW5kcmV3LAoKT24gMjAyMC0wNy0xMSAxMTowNCwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+IERv
bid0IGNvbmZ1c2UgdGhlIGd1ZXN0IGJ5IHNheWluZyBzdGVhbC10aW1lIGlzIHN1cHBvcnRlZCB3
aGVuCj4gaXQgaGFzbid0IGJlZW4gY29uZmlndXJlZCBieSB1c2Vyc3BhY2UgYW5kIHdvbid0IHdv
cmsuCj4gCj4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+
Cj4gLS0tCj4gIGFyY2gvYXJtNjQva3ZtL3B2dGltZS5jIHwgNSArKysrLQo+ICAxIGZpbGUgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQva3ZtL3B2dGltZS5jIGIvYXJjaC9hcm02NC9rdm0vcHZ0aW1lLmMKPiBpbmRleCBm
N2I1MmNlMTU1N2UuLjJiMjIyMTQ5MDliZSAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9w
dnRpbWUuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3B2dGltZS5jCj4gQEAgLTQyLDkgKzQyLDEy
IEBAIGxvbmcga3ZtX2h5cGVyY2FsbF9wdl9mZWF0dXJlcyhzdHJ1Y3Qga3ZtX3ZjcHUgCj4gKnZj
cHUpCj4gCj4gIAlzd2l0Y2ggKGZlYXR1cmUpIHsKPiAgCWNhc2UgQVJNX1NNQ0NDX0hWX1BWX1RJ
TUVfRkVBVFVSRVM6Cj4gLQljYXNlIEFSTV9TTUNDQ19IVl9QVl9USU1FX1NUOgo+ICAJCXZhbCA9
IFNNQ0NDX1JFVF9TVUNDRVNTOwo+ICAJCWJyZWFrOwo+ICsJY2FzZSBBUk1fU01DQ0NfSFZfUFZf
VElNRV9TVDoKPiArCQlpZiAodmNwdS0+YXJjaC5zdGVhbC5iYXNlICE9IEdQQV9JTlZBTElEKQo+
ICsJCQl2YWwgPSBTTUNDQ19SRVRfU1VDQ0VTUzsKPiArCQlicmVhazsKPiAgCX0KPiAKPiAgCXJl
dHVybiB2YWw7CgpJJ20gbm90IHNvIHN1cmUgYWJvdXQgdGhpcy4gSSBoYXZlIGFsd2F5cyBjb25z
aWRlcmVkIHRoZQpkaXNjb3ZlcnkgaW50ZXJmYWNlIHRvIGJlICJkbyB5b3Uga25vdyBhYm91dCB0
aGlzIFNNQ0NDCmZ1bmN0aW9uIi4gQW5kIGlmIHlvdSBsb29rIGF0IHRoZSBzcGVjLCBpdCBzYXlz
ICg0LjIsClBWX1RJTUVfRkVBVFVSRVMpOgoKPHF1b3RlPgpJZiBQVl9jYWxsX2lkIGlkZW50aWZp
ZXMgUFZfVElNRV9GRUFUVVJFUywgdGhpcyBjYWxsIHJldHVybnM6CuKAoiBOT1RfU1VQUE9SVEVE
ICgtMSkgdG8gaW5kaWNhdGUgdGhhdCBhbGwKcGFyYXZpcnR1YWxpemVkIHRpbWUgZnVuY3Rpb25z
IGluIHRoaXMgc3BlY2lmaWNhdGlvbiBhcmUgbm90CnN1cHBvcnRlZC4K4oCiIFNVQ0NFU1MgKDAp
IHRvIGluZGljYXRlIHRoYXQgYWxsIHRoZSBwYXJhdmlydHVhbGl6ZWQgdGltZQpmdW5jdGlvbnMg
aW4gdGhpcyBzcGVjaWZpY2F0aW9uIGFyZSBzdXBwb3J0ZWQuCjwvcXVvdGU+CgpTbyB0aGUgd2F5
IEkgdW5kZXJzdGFuZCBpdCwgeW91IGNhbm5vdCByZXR1cm4gInN1cHBvcnRlZCIKZm9yIFBWX1RJ
TUVfRkVBVFVSRVMsIGFuZCB5ZXQgcmV0dXJuIE5PVF9TVVBQT1JURUQgZm9yClBWX1RJTUVfU1Qu
IEl0IGFwcGxpZXMgdG8gKmFsbCogZmVhdHVyZXMuCgpZZXMsIHRoaXMgaXMgdmVyeSBiaXphcnJl
LiBCdXQgSSBkb24ndCB0aGluayB3ZSBjYW4gZGV2aWF0ZQpmcm9tIGl0LgoKVGhhbmtzLAoKICAg
ICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
