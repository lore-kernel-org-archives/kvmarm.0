Return-Path: <SRS0=pAxc=S3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BABDDC43219
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 15:04:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B0BD2081C
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 15:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jDwLcnkF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B0BD2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 904D94A46E;
	Thu, 25 Apr 2019 11:04:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UdrURw6YChjX; Thu, 25 Apr 2019 11:04:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CD7F4A47A;
	Thu, 25 Apr 2019 11:04:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D64564A460
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 11:04:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id itrYPAPr8zhR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 11:04:39 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E2654A34E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 11:04:39 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id h18so11081544wml.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 08:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:in-reply-to:date
 :message-id:mime-version:content-transfer-encoding;
 bh=XVoHwt6A0g/p8WFsHPzyMda+AytP+sYgkW5D6zHxBcw=;
 b=jDwLcnkFHq0HiHGiZqPOrUh3VZVMDvNFeOiHCDsDHwRx8DDGgSispIP+X5rr80Bi49
 e4lNAmaaPRcAB6rPzboBVWOHqJXdP+XErNnR07qSr74Uv6DDdd5T2qiCgJ3E0Fz0dZn5
 rWWgplZxPh4G1hxE8Sg/+7YkwY/chB5qHd9EdaV+24l6fqkDFl4tN3/5VtN4+l82gjiu
 HFaDzSj1utylfZTgU2r40XqknWGoiKbbHpjd3FJZs2u6UG4jginWs0HwYi7hf3DWGA4j
 AC0xTwYrvf885aDgEAgJIA4DEZ/DpH6Md7FlJ05smDmBx3+4UQVv5AbEbMs2ILUeI+S7
 gC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject
 :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
 bh=XVoHwt6A0g/p8WFsHPzyMda+AytP+sYgkW5D6zHxBcw=;
 b=bmGYMnmkHWcGT5UkjKsM59BaMpSxGrGKOyJGaZL7+OCtNxjGYvW8QgKJPGj5CLzN2/
 nahDRlMN4mWy8G2cpVuiGhWESUm/dKUjPl/V1Md4rkfqz7IvFhZllQTJDjBdl4tnrqIr
 EJ7b38u31p5KfZ9/uaACPWi1zWa09GNbJPG79LnK9bTota2d1G1DVEjW2Akqe/GWp1WZ
 cYxsRPk4lXFeEoXazE6tHRgvsdxa+uY9QwkA8v2cHpuTD7cPHLDTlviv97+eEqMf4UEC
 IryfyGwsYS7r9yrPZRASzbzeUOEOmPjnQasBhywMYHNF6X36vSSclvS0LGidxl7aEX7W
 yDCg==
X-Gm-Message-State: APjAAAUi9pNwp4ojD1My13M2zNtm81zP20MMyTHUpugIYv4MuuWcHyRM
 Rhb89OgFkZVOJOBXH49pYoPA0g==
X-Google-Smtp-Source: APXvYqxdCWhDeP9Z0uiM1UlLGqWS0xvq/U08hQBPkfQnlEfEXWebwtlrzig2F0a+pkoZzl+yn4mryg==
X-Received: by 2002:a1c:7610:: with SMTP id r16mr3712522wmc.21.1556204678110; 
 Thu, 25 Apr 2019 08:04:38 -0700 (PDT)
Received: from zen.linaroharston ([81.128.185.34])
 by smtp.gmail.com with ESMTPSA id w83sm4038205wmg.40.2019.04.25.08.04.36
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Thu, 25 Apr 2019 08:04:36 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 6EB911FF87;
 Thu, 25 Apr 2019 16:04:36 +0100 (BST)
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
 <1555603631-8107-8-git-send-email-Dave.Martin@arm.com>
 <877ebiw9lm.fsf@zen.linaroharston>
 <20190425130424.GA3567@e103592.cambridge.arm.com>
User-agent: mu4e 1.3.1; emacs 26.1
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 07/14] KVM: arm64/sve: Make register ioctl access
 errors more consistent
In-reply-to: <20190425130424.GA3567@e103592.cambridge.arm.com>
Date: Thu, 25 Apr 2019 16:04:36 +0100
Message-ID: <87pnpaunwb.fsf@zen.linaroharston>
MIME-Version: 1.0
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190425150436.l00shXZ046-WxSdNmbLq4JyFjstLVTjiBqFZsOXIAXg@z>

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIFRodSwgQXBy
IDI1LCAyMDE5IGF0IDAxOjMwOjI5UE0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
RGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+IHdyaXRlczoKPj4KPj4gPiBDdXJyZW50
bHksIHRoZSB3YXkgZXJyb3IgY29kZXMgYXJlIGdlbmVyYXRlZCB3aGVuIHByb2Nlc3NpbmcgdGhl
Cj4+ID4gU1ZFIHJlZ2lzdGVyIGFjY2VzcyBpb2N0bHMgaW4gYSBiaXQgaGFwaGF6YXJkLgo+PiA+
Cj4+ID4gVGhpcyBwYXRjaCByZWZhY3RvcnMgdGhlIGNvZGUgc28gdGhhdCB0aGUgYmVoYXZpb3Vy
IGlzIG1vcmUKPj4gPiBjb25zaXN0ZW50OiBub3csIC1FSU5WQUwgc2hvdWxkIGJlIHJldHVybmVk
IG9ubHkgZm9yIHVucmVjb2duaXNlZAo+PiA+IHJlZ2lzdGVyIElEcyBvciB3aGVuIHNvbWUgb3Ro
ZXIgcnVudGltZSBlcnJvciBvY2N1cnMuICAtRU5PRU5UIGlzCj4+ID4gcmV0dXJuZWQgZm9yIHJl
Z2lzdGVyIElEcyB0aGF0IGFyZSByZWNvZ25pc2VkLCBidXQgd2hvc2UKPj4gPiBjb3JyZXNwb25k
aW5nIHJlZ2lzdGVyIChvciBzbGljZSkgZG9lcyBub3QgZXhpc3QgZm9yIHRoZSB2Y3B1Lgo+PiA+
Cj4+ID4gVG8gdGhpcyBlbmQsIGluIHtnZXQsc2V0fV9zdmVfcmVnKCkgd2Ugbm93IGRlbGVnYXRl
IHRoZQo+PiA+IHZjcHVfaGFzX3N2ZSgpIGNoZWNrIGRvd24gaW50byB7Z2V0LHNldH1fc3ZlX3Zs
cygpIGFuZAo+PiA+IHN2ZV9yZWdfdG9fcmVnaW9uKCkuICBUaGUgS1ZNX1JFR19BUk02NF9TVkVf
VkxTIHNwZWNpYWwgY2FzZSBpcwo+PiA+IHBpY2tlZCBvZmYgZmlyc3QsIHRoZW4gc3ZlX3JlZ190
b19yZWdpb24oKSBwbGF5cyB0aGUgcm9sZSBvZgo+PiA+IGV4aGF1c3RpdmVseSB2YWxpZGF0aW5n
IG9yIHJlamVjdGluZyB0aGUgcmVnaXN0ZXIgSUQgYW5kICh3aGVyZQo+PiA+IGFjY2VwdGVkKSBj
b21wdXRpbmcgdGhlIGFwcGxpY2FibGUgcmVnaXN0ZXIgcmVnaW9uIGFzIGJlZm9yZS4KPj4gPgo+
PiA+IHN2ZV9yZWdfdG9fcmVnaW9uKCkgaXMgcmVhcnJhbmdlZCBzbyB0aGF0IC1FTk9FTlQgb3Ig
LUVQRVJNIGlzIG5vdAo+PiA+IHJldHVybmVkIHByZW1hdHVyZWx5LCBiZWZvcmUgY2hlY2tpbmcg
d2hldGhlciByZWctPmlkIGlzIGluIGEKPj4gPiByZWNvZ25pc2VkIHJhbmdlLgo+PiA+Cj4+ID4g
LUVQRVJNIGlzIG5vdyBvbmx5IHJldHVybmVkIHdoZW4gYW4gYXR0ZW1wdCBpcyBtYWRlIHRvIGFj
Y2VzcyBhbgo+PiA+IGFjdHVhbGx5IGV4aXN0aW5nIHJlZ2lzdGVyIHNsaWNlIG9uIGFuIHVuZmlu
YWxpemVkIHZjcHUuCj4+ID4KPj4gPiBGaXhlczogZTFjOWM5ODM0NWIzICgiS1ZNOiBhcm02NC9z
dmU6IEFkZCBTVkUgc3VwcG9ydCB0byByZWdpc3RlciBhY2Nlc3MgaW9jdGwgaW50ZXJmYWNlIikK
Pj4gPiBGaXhlczogOTAzM2JiYTRiNTM1ICgiS1ZNOiBhcm02NC9zdmU6IEFkZCBwc2V1ZG8tcmVn
aXN0ZXIgZm9yIHRoZSBndWVzdCdzIHZlY3RvciBsZW5ndGhzIikKPj4gPiBTdWdnZXN0ZWQtYnk6
IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPgo+PiA+IFNpZ25lZC1vZmYtYnk6IERh
dmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgo+PiA+IFJldmlld2VkLWJ5OiBBbmRyZXcg
Sm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4KPgo+IFsuLi5dCj4KPj4gPiBAQCAtMzM1LDI1ICsz
NDQsMzAgQEAgc3RhdGljIGludCBzdmVfcmVnX3RvX3JlZ2lvbihzdHJ1Y3Qgc3ZlX3N0YXRlX3Jl
Z19yZWdpb24gKnJlZ2lvbiwKPj4gPiAgCS8qIFZlcmlmeSB0aGF0IHdlIG1hdGNoIHRoZSBVQVBJ
IGhlYWRlcjogKi8KPj4gPiAgCUJVSUxEX0JVR19PTihTVkVfTlVNX1NMSUNFUyAhPSBLVk1fQVJN
NjRfU1ZFX01BWF9TTElDRVMpOwo+PiA+Cj4+ID4gLQlpZiAoKHJlZy0+aWQgJiBTVkVfUkVHX1NM
SUNFX01BU0spID4gMCkKPj4gPiAtCQlyZXR1cm4gLUVOT0VOVDsKPj4gPiAtCj4+ID4gLQl2cSA9
IHN2ZV92cV9mcm9tX3ZsKHZjcHUtPmFyY2guc3ZlX21heF92bCk7Cj4+ID4gLQo+PiA+ICAJcmVn
X251bSA9IChyZWctPmlkICYgU1ZFX1JFR19JRF9NQVNLKSA+PiBTVkVfUkVHX0lEX1NISUZUOwo+
PiA+Cj4+ID4gIAlpZiAocmVnLT5pZCA+PSB6cmVnX2lkX21pbiAmJiByZWctPmlkIDw9IHpyZWdf
aWRfbWF4KSB7Cj4+ID4gKwkJaWYgKCF2Y3B1X2hhc19zdmUodmNwdSkgfHwgKHJlZy0+aWQgJiBT
VkVfUkVHX1NMSUNFX01BU0spID4gMCkKPj4gPiArCQkJcmV0dXJuIC1FTk9FTlQ7Cj4+ID4gKwo+
PiA+ICsJCXZxID0gc3ZlX3ZxX2Zyb21fdmwodmNwdS0+YXJjaC5zdmVfbWF4X3ZsKTsKPj4gPiAr
Cj4+ID4gIAkJcmVxb2Zmc2V0ID0gU1ZFX1NJR19aUkVHX09GRlNFVCh2cSwgcmVnX251bSkgLQo+
PiA+ICAJCQkJU1ZFX1NJR19SRUdTX09GRlNFVDsKPj4gPiAgCQlyZXFsZW4gPSBLVk1fU1ZFX1pS
RUdfU0laRTsKPj4gPiAgCQltYXhsZW4gPSBTVkVfU0lHX1pSRUdfU0laRSh2cSk7Cj4+ID4gIAl9
IGVsc2UgaWYgKHJlZy0+aWQgPj0gcHJlZ19pZF9taW4gJiYgcmVnLT5pZCA8PSBwcmVnX2lkX21h
eCkgewo+PiA+ICsJCWlmICghdmNwdV9oYXNfc3ZlKHZjcHUpIHx8IChyZWctPmlkICYgU1ZFX1JF
R19TTElDRV9NQVNLKSA+IDApCj4+ID4gKwkJCXJldHVybiAtRU5PRU5UOwo+PiA+ICsKPj4gPiAr
CQl2cSA9IHN2ZV92cV9mcm9tX3ZsKHZjcHUtPmFyY2guc3ZlX21heF92bCk7Cj4+ID4gKwo+Pgo+
PiBJIHN1cHBvc2UgeW91IGNvdWxkIGFyZ3VlIGZvciBhOgo+Pgo+PiAJaWYgKHJlZy0+aWQgPj0g
enJlZ19pZF9taW4gJiYgcmVnLT5pZCA8PSBwcmVnX2lkX21heCkgewo+PiAJCWlmICghdmNwdV9o
YXNfc3ZlKHZjcHUpIHx8IChyZWctPmlkICYgU1ZFX1JFR19TTElDRV9NQVNLKSA+IDApCj4+IAkJ
CXJldHVybiAtRU5PRU5UOwo+Pgo+PiAJCXZxID0gc3ZlX3ZxX2Zyb21fdmwodmNwdS0+YXJjaC5z
dmVfbWF4X3ZsKTsKPj4KPj4gICAgICAgICAgICAgICAgIGlmIChyZWctPmlkIDw9IHpyZWdfaWRf
bWF4KSB7Cj4+IAkJCXJlcW9mZnNldCA9IFNWRV9TSUdfWlJFR19PRkZTRVQodnEsIHJlZ19udW0p
IC0KPj4gCQkJCVNWRV9TSUdfUkVHU19PRkZTRVQ7Cj4+IAkJCXJlcWxlbiA9IEtWTV9TVkVfWlJF
R19TSVpFOwo+PiAJCQltYXhsZW4gPSBTVkVfU0lHX1pSRUdfU0laRSh2cSk7Cj4+ICAgICAgICAg
ICAgICAgICB9IGVsc2Ugewo+PiAJCQlyZXFvZmZzZXQgPSBTVkVfU0lHX1BSRUdfT0ZGU0VUKHZx
LCByZWdfbnVtKSAtCj4+IAkJCQlTVkVfU0lHX1JFR1NfT0ZGU0VUOwo+PiAJCQlyZXFsZW4gPSBL
Vk1fU1ZFX1BSRUdfU0laRTsKPj4gCQkJbWF4bGVuID0gU1ZFX1NJR19QUkVHX1NJWkUodnEpOwo+
PiAJCX0KPj4gCX0gZWxzZSB7Cj4+IAkJcmV0dXJuIC1FSU5WQUw7Cj4+IAl9Cj4+Cj4+IGJ1dCBv
bmx5IGZvciBtaW5pbWFsIERSWSByZWFzb25zLgo+Cj4gQWdyZWVkLCBidXQgdGhhdCBiYWtlcyBp
biBhbm90aGVyIGFzc3VtcHRpb246IHRoYXQgdGhlIFpSRUcgYW5kIFBSRUcgSUQKPiByYW5nZXMg
YXJlIGNvbnRpZ3VvdXMuCgpBaGggSSdkIG1pc3JlYWQ6CgogIC8qIHJlZyBJRCByYW5nZXMgZm9y
IFAtIHJlZ2lzdGVycyBhbmQgRkZSICh3aGljaCBhcmUgY29udGlndW91cykgKi8KCkhvd2V2ZXIg
dGhlc2UgYXJlIGRlZmluZWQgaW4gdGhlIFVBQkk6CgogIC8qIFotIGFuZCBQLXJlZ3Mgb2NjdXB5
IGJsb2NrcyBhdCB0aGUgZm9sbG93aW5nIG9mZnNldHMgd2l0aGluIHRoaXMgcmFuZ2U6ICovCiAg
I2RlZmluZSBLVk1fUkVHX0FSTTY0X1NWRV9aUkVHX0JBU0UJMAogICNkZWZpbmUgS1ZNX1JFR19B
Uk02NF9TVkVfUFJFR19CQVNFCTB4NDAwCiAgI2RlZmluZSBLVk1fUkVHX0FSTTY0X1NWRV9GRlJf
QkFTRQkweDYwMAoKc28gdGhlcmUgcG9zaXRpb24gaXMgcHJldHR5IGZpeGVkIG5vdyByaWdodD8K
Cj4gSSBwcmVmZXJyZWQgdG8ga2VlcCB0aGUgbnVtYmVyIG9mIGFzc3VtcHRpb25zIGRvd24uCj4K
PiBBbHRob3VnIHRoZSByZXN1bHRpbmcgY29kZSB3YXNuJ3QgaWRlYWwsIHRoZSBhY3R1YWwgYW1v
dW50IG9mCj4gZHVwbGljYXRpb24gdGhhdCBJIGVuZGVkIHVwIHdpdGggaGVyZSBzZWVtZWQgbG93
IGVub3VnaCBhcyB0byBiZQo+IGFjY2VwdGFibGUgKHRob3VnaCBvcGluaW9ucyBjYW4gZGlmZmVy
IG9uIHRoYXQpLgoKSXQncyBubyBiaWdnaWUgOy0pCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
