Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AC8C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:43:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E24E1206F1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="MIAYt/eE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E24E1206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59DDD4B0CD;
	Mon, 22 Jun 2020 06:43:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PP0LsD327Uj8; Mon, 22 Jun 2020 06:43:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 110994B0D0;
	Mon, 22 Jun 2020 06:43:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6704B0C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:43:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O+Re6oVrfLfL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 06:43:41 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 751804AEE2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:43:41 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id t194so15211311wmt.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 03:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=41akXYz0zWUNhlfBjzUWwsJTByPRnzWKiqrdZU1i7G4=;
 b=MIAYt/eEyjzjrMOC9tR0Rnjpy7E0R2DfPDd1YOevwED1wfhVpIvxZ8+xdaPMEzy312
 0tboK0HYL6xZtrqlj5k4dLNaEVV4TGi03EQ6q1oQoKIA7nHHG56OXkjKWemGkLHGeXTN
 0V5NrB/LKvE1oYoNQiIcl4r7cS8wK3E62GQXqGpgKj84VOfwGlcSZXvczqE8TZCIOxYc
 NsxHTCKIwNvQCOxJG/hGYNTJOGLQILiBr59fktX+0IFo0zaXlq+bzEBfU16Lqs9R38vM
 rzn7z6v7QgBthMpLVDcn1vXwfPLx6Hf9x+kCALK4KjxZ49wlhkvobTDvkXApPfzXetOg
 j/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=41akXYz0zWUNhlfBjzUWwsJTByPRnzWKiqrdZU1i7G4=;
 b=kihOB+VMlA6wVAauYvja19MAzoE73/D4Y4K9p+sH+COvSDDDAm2r7UBvI0k+//sNsT
 V+rc2GRDtqc21HtHgtTdVoZzSk3hYQgEnffREWtcPhyzjdmRXJHDZiFL9Nr4dqbmrOlP
 xK53gD/lvW0jkS72yuvHoYxf98OFBBK+NfdK1ftcR05hKC/W+pFh6WFsnd4ebmwMsI21
 mDfjuiCzXNH46bxcjNj/nwBMXLUo5UhZ5l8/q2EZopEMW2kCuU5wfBHB4ZXCgVTFbUER
 9N2QRYmvI3nI0RK4NTiR8+JnMp0WiOEf7Y3ezaaInW3pehVM+iWHiKFlk2pZ5JvWU+9t
 ZWsA==
X-Gm-Message-State: AOAM530PRcGN0wXSJAeEqooIlPcvcrtpusLZg/hYnq99RJ6YHAUbyb+v
 UrbqUunJ393tJQnLuJXwZbmgtw==
X-Google-Smtp-Source: ABdhPJwAZ7DVXsoNP8LJ1W76bsiRbgL84gXPr8NS+WTEdcfmi6/xbh/HvI6TdqdIux1Q492mPuTN9Q==
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr15237237wma.66.1592822620197; 
 Mon, 22 Jun 2020 03:43:40 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id j6sm15851487wmb.3.2020.06.22.03.43.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Jun 2020 03:43:39 -0700 (PDT)
Date: Mon, 22 Jun 2020 11:43:35 +0100
From: Andrew Scull <ascull@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622104335.GB178085@google.com>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
 <20200622103932.GA178085@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200622103932.GA178085@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

T24gTW9uLCBKdW4gMjIsIDIwMjAgYXQgMTE6Mzk6MzJBTSArMDEwMCwgQW5kcmV3IFNjdWxsIHdy
b3RlOgo+IE9uIE1vbiwgSnVuIDIyLCAyMDIwIGF0IDEwOjE1OjA4QU0gKzAxMDAsIE1hcmsgUnV0
bGFuZCB3cm90ZToKPiA+IE9uIE1vbiwgSnVuIDIyLCAyMDIwIGF0IDA5OjA2OjQzQU0gKzAxMDAs
IE1hcmMgWnluZ2llciB3cm90ZToKPiAKPiAKPiA+ID4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1fcHRyYXV0aC5oCj4gPiA+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3Zt
X3B0cmF1dGguaAo+ID4gPiBAQCAtNjEsNDQgKzYxLDM2IEBACj4gPiA+ICAKPiA+ID4gIC8qCj4g
PiA+ICAgKiBCb3RoIHB0cmF1dGhfc3dpdGNoX3RvX2d1ZXN0IGFuZCBwdHJhdXRoX3N3aXRjaF90
b19ob3N0IG1hY3JvcyB3aWxsCj4gPiA+IC0gKiBjaGVjayBmb3IgdGhlIHByZXNlbmNlIG9mIG9u
ZSBvZiB0aGUgY3B1ZmVhdHVyZSBmbGFnCj4gPiA+IC0gKiBBUk02NF9IQVNfQUREUkVTU19BVVRI
X0FSQ0ggb3IgQVJNNjRfSEFTX0FERFJFU1NfQVVUSF9JTVBfREVGIGFuZAo+ID4gPiArICogY2hl
Y2sgZm9yIHRoZSBwcmVzZW5jZSBBUk02NF9IQVNfQUREUkVTU19BVVRILCB3aGljaCBpcyBkZWZp
bmVkIGFzCj4gPiA+ICsgKiAoQVJNNjRfSEFTX0FERFJFU1NfQVVUSF9BUkNIIHx8IEFSTTY0X0hB
U19BRERSRVNTX0FVVEhfSU1QX0RFRikgYW5kCj4gPiA+ICAgKiB0aGVuIHByb2NlZWQgYWhlYWQg
d2l0aCB0aGUgc2F2ZS9yZXN0b3JlIG9mIFBvaW50ZXIgQXV0aGVudGljYXRpb24KPiA+ID4gLSAq
IGtleSByZWdpc3RlcnMuCj4gPiA+ICsgKiBrZXkgcmVnaXN0ZXJzIGlmIGVuYWJsZWQgZm9yIHRo
ZSBndWVzdC4KPiA+ID4gICAqLwo+ID4gPiAgLm1hY3JvIHB0cmF1dGhfc3dpdGNoX3RvX2d1ZXN0
IGdfY3R4dCwgcmVnMSwgcmVnMiwgcmVnMwo+ID4gPiAtYWx0ZXJuYXRpdmVfaWYgQVJNNjRfSEFT
X0FERFJFU1NfQVVUSF9BUkNICj4gPiA+ICthbHRlcm5hdGl2ZV9pZl9ub3QgQVJNNjRfSEFTX0FE
RFJFU1NfQVVUSAo+ID4gPiAgCWIJMTAwMGYKPiA+ID4gIGFsdGVybmF0aXZlX2Vsc2Vfbm9wX2Vu
ZGlmCj4gPiA+IC1hbHRlcm5hdGl2ZV9pZl9ub3QgQVJNNjRfSEFTX0FERFJFU1NfQVVUSF9JTVBf
REVGCj4gPiA+IC0JYgkxMDAxZgo+ID4gPiAtYWx0ZXJuYXRpdmVfZWxzZV9ub3BfZW5kaWYKPiA+
ID4gLTEwMDA6Cj4gPiA+ICAJbXJzCVxyZWcxLCBoY3JfZWwyCj4gPiA+ICAJYW5kCVxyZWcxLCBc
cmVnMSwgIyhIQ1JfQVBJIHwgSENSX0FQSykKPiA+ID4gLQljYnoJXHJlZzEsIDEwMDFmCj4gPiA+
ICsJY2J6CVxyZWcxLCAxMDAwZgo+ID4gPiAgCWFkZAlccmVnMSwgXGdfY3R4dCwgI0NQVV9BUElB
S0VZTE9fRUwxCj4gPiA+ICAJcHRyYXV0aF9yZXN0b3JlX3N0YXRlCVxyZWcxLCBccmVnMiwgXHJl
ZzMKPiA+ID4gLTEwMDE6Cj4gPiA+ICsxMDAwOgo+ID4gPiAgLmVuZG0KPiA+IAo+ID4gU2luY2Ug
dGhlc2UgYXJlIGluIG1hY3Jvcywgd2UgY291bGQgdXNlIFxAIHRvIGdlbmVyYXRlIGEgbWFjcm8t
c3BlY2lmaWMKPiA+IGxhdmVsIHJhdGhlciB0aGFuIGEgbWFnaWMgbnVtYmVyLCB3aGljaCB3b3Vs
ZCBiZSBsZXNzIGxpa2VseSB0byBjb25mbGljdAo+ID4gd2l0aCB0aGUgc3Vycm91bmRpbmcgZW52
aXJvbm1lbnQgYW5kIHdvdWxkIGJlIG1vcmUgZGVzY3JpcHRpdmUuIFdlIGRvCj4gPiB0aGF0IGlu
IGEgZmV3IHBsYWNlcyBhbHJlYWR5LCBhbmQgaGVyZSBpdCBjb3VsZCBsb29rIHNvbWV0aGluZyBs
aWtlOgo+ID4gCj4gPiB8IGFsdGVybmF0aXZlX2lmX25vdCBBUk02NF9IQVNfQUREUkVTU19BVVRI
Cj4gPiB8IAliCS5MX19za2lwX3BhdXRoX3N3aXRjaFxACj4gPiB8IGFsdGVybmF0aXZlX2Vsc2Vf
bm9wX2VuZGlmCj4gPiB8IAkKPiA+IHwgCS4uLgo+ID4gfCAKPiA+IHwgLkxfX3NraXBfcGF1dGhf
c3dpdGNoXEA6Cj4gPiAKPiA+IFBlciB0aGUgZ2FzIGRvY3VtZW50YXRpb24KPiA+IAo+ID4gfCBc
QAo+ID4gfAo+ID4gfCAgICBhcyBtYWludGFpbnMgYSBjb3VudGVyIG9mIGhvdyBtYW55IG1hY3Jv
cyBpdCBoYXMgZXhlY3V0ZWQgaW4gdGhpcwo+ID4gfCAgICBwc2V1ZG8tdmFyaWFibGU7IHlvdSBj
YW4gY29weSB0aGF0IG51bWJlciB0byB5b3VyIG91dHB1dCB3aXRoIOKAmFxA4oCZLAo+ID4gfCAg
ICBidXQgb25seSB3aXRoaW4gYSBtYWNybyBkZWZpbml0aW9uLgo+IAo+IElzIHRoaXMgcmVsaWJh
bGUgZm9yIHRoaXMgc29ydCBvZiBhcHBsaWNhdGlvbj8gVGhlIGRlc2NyaXB0aW9uIGp1c3QKPiBz
b3VuZHMgbGlrZSBhIGNvdW50ZXIgb2YgbWFjcm9zIHJhdGhlciB0aGFuIHNwZWNpZmljYWxseSBh
IHVuaXF1ZSBsYWJlbAo+IGdlbmVyYXRvci4gSXQgbWF5IHdvcmsgbW9zdCBvZiB0aGUgdGltZSBi
dXQgYWxzbyBzZWVtcyB0aGF0IGl0IGhhcyB0aGUKPiBwb3RlbnRpYWwgdG8gYmUgbW9yZSBmcmFn
aWxlIGdpdmVuIHRoYXQgaXQgd291bGQgY2hhbmdlIGJhc2VkIG9uIHRoZQo+IHJlc3Qgb2YgdGhl
IGNvZGUgaW4gdGhlIGZpbGUgdG8gcG90ZW50aWFsbHkgY29uZmxpY3Qgd2l0aCBzb21ldGhpbmcg
aXQKPiBkaWRuJ3QgcHJldmlvdXNseSBjb25mbGljdCB3aXRoLiAKCkFoLCB5b3UgaW52b2tlIGEg
bWFjcm8gaW4gb3JkZXIgZm9yIHRoZSBsYWJlbCB0byBiZSBnZW5lcmF0ZWQgc28gaXQgd2lsbApp
bmNyZW1lbnQgYW5kIHRoZSBsYWJlbCBpcyBuYW1lc3BhY2VkIGJ5IHRoZSBwcmVmaXguIEkgc2Vl
LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
