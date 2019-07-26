Return-Path: <SRS0=RR3A=VZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC35CC433FF
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A476A2075B
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OX77yu64"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A476A2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B64C4A553;
	Sun, 28 Jul 2019 06:21:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id twvz7i-NG2d0; Sun, 28 Jul 2019 06:21:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A094A562;
	Sun, 28 Jul 2019 06:21:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 512424A4DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 10:05:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yiwgAUu3MqGj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jul 2019 10:05:14 -0400 (EDT)
Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com
 [209.85.167.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1FA64A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 10:05:13 -0400 (EDT)
Received: by mail-lf1-f65.google.com with SMTP id z15so32894041lfh.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 07:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=XRsk0iEI3zTElR2u2jt3WIaXl85qXr9Noy6MPl/LLlU=;
 b=OX77yu642sxgg1HWdyQx9x41cx1WuDT18/aO9UX6rY4u4nAODv+wC6yhBaw3+9QX5T
 dBV1+B9FKTO/C+WlDI5n+NiBhKRsKNedmV8BCjk0uTgaB5MapIid4HUVGa8JaZKYD3yD
 nlg5wjSYvBF7Gf8MnPUS+JftzW8zigSkaenRy2Uw5jyAdHFjkJIQ8Oe3qzzp0Jl3BdRY
 UvCzsbkTsgl3SeExNSjo80CItXkQUHBePxaN2g7ANgbH7nPjhp5EV5EQ5W5GwhhAT7za
 mYlEKOBBkzDnZNJeVptuM4S9BVNtUQrKp6ObQSUIgCqUFZn3URJCZvD2air0iweLKLrk
 Y+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=XRsk0iEI3zTElR2u2jt3WIaXl85qXr9Noy6MPl/LLlU=;
 b=auJoftpP7MauKMBX0YjdT3ediDIvxbdALG1vsryagOLwxyH4ntHyAQ/nU61Xgislbq
 ogQZibZyoh7FXNQpaEragIJu3hFIIICqc/QW78o5/cpQpTcTly57zHsplQNVOBTTVATP
 /cFR7+VlDAZDd+SxBfiC4rjB62BYTyAuvYGEx2JYc1cKAvwgpYmTfdC1lzuR5+DF3+70
 QKolvkLm9vaKIS91BIzJ8tcon2KHzqeQZNrGdxRqmkAF1QfmxLvEA7b2uII+csM2SWC3
 WbTVjnITGtvc2BZooB+Y8DkhW+SiveHqEanocS3VxuBX9bJPWl1y8rRucnXst4m/zEaW
 QPWg==
X-Gm-Message-State: APjAAAWeYRk5Q9rv/ZSKALP0YxrOe+OKybUNDFUvhit7GntdBW5xZ/RU
 q87+3i07cqgiz5u9li2yV/56XFb6faCa85eDweAdZQ==
X-Google-Smtp-Source: APXvYqwa4920tCYVHHu9I4QKSrBmf0RTIQ5b6Q2RM0JOBEekZMUOdfpLbKuHuoNm3VkGJHdz7S50cU4xJ9G0jxWt3ec=
X-Received: by 2002:ac2:44b1:: with SMTP id c17mr33687690lfm.87.1564149912518; 
 Fri, 26 Jul 2019 07:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190726112705.19000-1-anders.roxell@linaro.org>
 <86ef2dnfkb.wl-marc.zyngier@arm.com>
In-Reply-To: <86ef2dnfkb.wl-marc.zyngier@arm.com>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 26 Jul 2019 16:05:01 +0200
Message-ID: <CADYN=9+RpC1xkBwvjUO=Figy5VSw-LFxazEE32fx9eLoPPMjRA@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: KVM: regmap: Mark expected switch fall-through
To: Marc Zyngier <marc.zyngier@arm.com>
X-Mailman-Approved-At: Sun, 28 Jul 2019 06:21:14 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

T24gRnJpLCAyNiBKdWwgMjAxOSBhdCAxNDozMCwgTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJA
YXJtLmNvbT4gd3JvdGU6Cj4KPiBIaSBBbmRlcnMsCj4KPiBPbiBGcmksIDI2IEp1bCAyMDE5IDEy
OjI3OjA1ICswMTAwLAo+IEFuZGVycyBSb3hlbGwgPGFuZGVycy5yb3hlbGxAbGluYXJvLm9yZz4g
d3JvdGU6Cj4gPgo+ID4gV2hlbiBmYWxsLXRocm91Z2ggd2FybmluZ3Mgd2FzIGVuYWJsZWQgYnkg
ZGVmYXVsdCwgY29tbWl0IGQ5MzUxMmVmMGYwZQo+ID4gKCJNYWtlZmlsZTogR2xvYmFsbHkgZW5h
YmxlIGZhbGwtdGhyb3VnaCB3YXJuaW5nIiksIHRoZSBmb2xsb3dpbmcKPiA+IHdhcm5pbmdzIHdh
cyBzdGFydGluZyB0byBzaG93IHVwOgo+ID4KPiA+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSAuLi9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9lbXVsYXRlLmg6MTksCj4gPiAgICAgICAgICAgICAg
ICAgIGZyb20gLi4vYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTM6Cj4gPiAuLi9hcmNoL2FybTY0
L2t2bS9yZWdtYXAuYzogSW4gZnVuY3Rpb24g4oCYdmNwdV93cml0ZV9zcHNyMzLigJk6Cj4gPiAu
Li9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaDozMTozOiB3YXJuaW5nOiB0aGlzIHN0
YXRlbWVudCBtYXkgZmFsbAo+ID4gIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQo+
ID4gICAgYXNtIHZvbGF0aWxlKEFMVEVSTkFUSVZFKF9fbXNyX3MociMjbnZoLCAiJXgwIiksIFwK
PiA+ICAgIF5+fgo+ID4gLi4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faHlwLmg6NDY6MzE6
IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJh3cml0ZV9zeXNyZWdfZWx44oCZCj4gPiAg
I2RlZmluZSB3cml0ZV9zeXNyZWdfZWwxKHYscikgd3JpdGVfc3lzcmVnX2VseCh2LCByLCBfRUwx
LCBfRUwxMikKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+
fn5+Cj4gPiAuLi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxODA6Mzogbm90ZTogaW4gZXhwYW5z
aW9uIG9mIG1hY3JvIOKAmHdyaXRlX3N5c3JlZ19lbDHigJkKPiA+ICAgIHdyaXRlX3N5c3JlZ19l
bDEodiwgU1lTX1NQU1IpOwo+ID4gICAgXn5+fn5+fn5+fn5+fn5+fgo+ID4gLi4vYXJjaC9hcm02
NC9rdm0vcmVnbWFwLmM6MTgxOjI6IG5vdGU6IGhlcmUKPiA+ICAgY2FzZSBLVk1fU1BTUl9BQlQ6
Cj4gPiAgIF5+fn4KPiA+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSAuLi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2NwdXR5cGUuaDoxMzIsCj4gPiAgICAgICAgICAgICAgICAgIGZyb20gLi4vYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9jYWNoZS5oOjgsCj4gPiAgICAgICAgICAgICAgICAgIGZyb20gLi4v
aW5jbHVkZS9saW51eC9jYWNoZS5oOjYsCj4gPiAgICAgICAgICAgICAgICAgIGZyb20gLi4vaW5j
bHVkZS9saW51eC9wcmludGsuaDo5LAo+ID4gICAgICAgICAgICAgICAgICBmcm9tIC4uL2luY2x1
ZGUvbGludXgva2VybmVsLmg6MTUsCj4gPiAgICAgICAgICAgICAgICAgIGZyb20gLi4vaW5jbHVk
ZS9hc20tZ2VuZXJpYy9idWcuaDoxOCwKPiA+ICAgICAgICAgICAgICAgICAgZnJvbSAuLi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2J1Zy5oOjI2LAo+ID4gICAgICAgICAgICAgICAgICBmcm9tIC4u
L2luY2x1ZGUvbGludXgvYnVnLmg6NSwKPiA+ICAgICAgICAgICAgICAgICAgZnJvbSAuLi9pbmNs
dWRlL2xpbnV4L21tZGVidWcuaDo1LAo+ID4gICAgICAgICAgICAgICAgICBmcm9tIC4uL2luY2x1
ZGUvbGludXgvbW0uaDo5LAo+ID4gICAgICAgICAgICAgICAgICBmcm9tIC4uL2FyY2gvYXJtNjQv
a3ZtL3JlZ21hcC5jOjExOgo+ID4gLi4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaDo4
Mzc6Mjogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5IGZhbGwKPiA+ICB0aHJvdWdoIFstV2lt
cGxpY2l0LWZhbGx0aHJvdWdoPV0KPiA+ICAgYXNtIHZvbGF0aWxlKCJtc3IgIiBfX3N0cmluZ2lm
eShyKSAiLCAleDAiICBcCj4gPiAgIF5+fgo+ID4gLi4vYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6
MTgyOjM6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJh3cml0ZV9zeXNyZWfigJkKPiA+
ICAgIHdyaXRlX3N5c3JlZyh2LCBzcHNyX2FidCk7Cj4gPiAgICBefn5+fn5+fn5+fn4KPiA+IC4u
L2FyY2gvYXJtNjQva3ZtL3JlZ21hcC5jOjE4MzoyOiBub3RlOiBoZXJlCj4gPiAgIGNhc2UgS1ZN
X1NQU1JfVU5EOgo+ID4gICBefn5+Cj4gPgo+ID4gUmV3b3JrIHRvIGFkZCBhICdicmVhazsnIGlu
IHRoZSBzd2ljaC1jYXNlIHNpbmNlIGl0IGRpZG4ndCBoYXZlIHRoYXQuCj4gPiBUaGF0IGFsc28g
bWFkZSB0aGUgY29tcGlsZXIgaGFwcHkgYW5kIGRpZG4ndCB3YXJuIGFib3V0IGZhbGwtdGhyb3Vn
aC4KPiA+Cj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHYzLjE2Kwo+Cj4gRXJtLi4u
IEFyZSB5b3Ugc3VyZSBhYm91dCB0aGF0PwoKSSBtYWRlIHR3byBtaXN0YWtlcy4KMS4gc2F5aW5n
IDMueCBpbnN0ZWFkIG9mIDQueAoyLiBJIHNhaWQgdGhlIHNhbWUga2VybmVsIHRoYXQgJ2dpdCBk
ZXNjcmliZScgc2hvd2VkIGFuZCBub3QgdGhlIGxhdGVyIG9uZS4KCkkgZGlkIG5vdCBrbm93IGFi
b3V0ICctLW1hdGNoPScuCgo+IEhlcmUncyB3aGF0IEkgaGF2ZToKPgo+ICQgZ2l0IGRlc2NyaWJl
IC0tY29udGFpbnMgIGE4OTI4MTk1NjBjNAo+IGt2bS1hcm0tZm9yLXY0LjE3fjQ0Cj4gJCBnaXQg
ZGVzY3JpYmUgLS1jb250YWlucyAtLW1hdGNoPSd2KicgYTg5MjgxOTU2MGM0Cj4gdjQuMTctcmMx
fjcyXjJ+MzZeMn40NAoKVGhhdCdzIGNvcnJlY3QuCgo+Cj4KPiA+IEZpeGVzOiBhODkyODE5NTYw
YzQgKCJLVk06IGFybTY0OiBQcmVwYXJlIHRvIGhhbmRsZSBkZWZlcnJlZCBzYXZlL3Jlc3RvcmUg
b2YgMzItYml0IHJlZ2lzdGVycyIpCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRlcnMgUm94ZWxsIDxh
bmRlcnMucm94ZWxsQGxpbmFyby5vcmc+Cj4gPiAtLS0KPiA+ICBhcmNoL2FybTY0L2t2bS9yZWdt
YXAuYyB8IDUgKysrKysKPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCj4gPgo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3JlZ21hcC5jIGIvYXJjaC9hcm02NC9rdm0v
cmVnbWFwLmMKPiA+IGluZGV4IDBkNjBlNGYwYWY2Ni4uYTkwMDE4MWUzODY3IDEwMDY0NAo+ID4g
LS0tIGEvYXJjaC9hcm02NC9rdm0vcmVnbWFwLmMKPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3Jl
Z21hcC5jCj4gPiBAQCAtMTc4LDEzICsxNzgsMTggQEAgdm9pZCB2Y3B1X3dyaXRlX3Nwc3IzMihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcgdikKPiA+ICAgICAgIHN3aXRjaCAo
c3Bzcl9pZHgpIHsKPiA+ICAgICAgIGNhc2UgS1ZNX1NQU1JfU1ZDOgo+ID4gICAgICAgICAgICAg
ICB3cml0ZV9zeXNyZWdfZWwxKHYsIFNZU19TUFNSKTsKPiA+ICsgICAgICAgICAgICAgYnJlYWs7
Cj4gPiAgICAgICBjYXNlIEtWTV9TUFNSX0FCVDoKPiA+ICAgICAgICAgICAgICAgd3JpdGVfc3lz
cmVnKHYsIHNwc3JfYWJ0KTsKPiA+ICsgICAgICAgICAgICAgYnJlYWs7Cj4gPiAgICAgICBjYXNl
IEtWTV9TUFNSX1VORDoKPiA+ICAgICAgICAgICAgICAgd3JpdGVfc3lzcmVnKHYsIHNwc3JfdW5k
KTsKPiA+ICsgICAgICAgICAgICAgYnJlYWs7Cj4gPiAgICAgICBjYXNlIEtWTV9TUFNSX0lSUToK
PiA+ICAgICAgICAgICAgICAgd3JpdGVfc3lzcmVnKHYsIHNwc3JfaXJxKTsKPiA+ICsgICAgICAg
ICAgICAgYnJlYWs7Cj4gPiAgICAgICBjYXNlIEtWTV9TUFNSX0ZJUToKPiA+ICAgICAgICAgICAg
ICAgd3JpdGVfc3lzcmVnKHYsIHNwc3JfZmlxKTsKPiA+ICsgICAgICAgICAgICAgYnJlYWs7Cj4g
PiAgICAgICB9Cj4gPiAgfQo+Cj4gT3RoZXJ3aXNlIGxvb2tzIGxpa2UgdGhlIHJpZ2h0IGZpeCB0
byBtZS4gTGV0IG1lIGtub3cgd2hhdCB5b3UgdGhpbmsKPiBhYm91dCB0aGUgRml4ZXM6IHRhZyAo
bm8gbmVlZCB0byByZXNlbmQgZm9yIHRoYXQpLgoKSXQgc2hvdWxkIGJlIHY0LjE3Ky4KCkNoZWVy
cywKQW5kZXJzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
