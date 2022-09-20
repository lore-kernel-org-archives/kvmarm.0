Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC8AECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 09:40:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FDA4B653;
	Tue, 20 Sep 2022 05:40:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xtDOupFX6jxA; Tue, 20 Sep 2022 05:40:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 665924B640;
	Tue, 20 Sep 2022 05:40:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D1FA4B640
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:40:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vgSmB2YTz2Gj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 05:39:59 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 369A94B0CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:39:59 -0400 (EDT)
Date: Tue, 20 Sep 2022 11:39:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663666797;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7dNROyoxS+g3hHfCHA0pUmuMDvUdin/kdGo/Zdh4wHQ=;
 b=v8o2BsttYYNeFs2fJPrLnNZu5NubYl4wo6Cn3DwPe9sFXkE4zh9amzOnksQlmGPttjShY7
 FF7o/ChkRR4Hf0cjN0Bb+2T7XvGQz555K2Sfk2r+HGIQmgER4GPDmF5H+77/rzAhcgKJqv
 iDXxoR/FsQeO7MFFcw/a/b9PDBtToRA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 13/19] arm: page.h: Add missing
 libcflat.h include
Message-ID: <20220920093956.sh4lunjssia376gf@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-14-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-14-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

CkkgZ3Vlc3MgdGhpcyBzaG91bGQgYmUgc3F1YXNoZWQgaW50byBvbmUgb2YgdGhlIGVhcmx5IHBh
dGNoZXMgaW4gdGhpcwpzZXJpZXMgc2luY2Ugd2UgZG9uJ3QgaGF2ZSB0aGlzIGlzc3VlIHdpdGgg
dGhlIGN1cnJlbnQgY29kZS4KClRoYW5rcywKZHJldwoKCk9uIFR1ZSwgQXVnIDA5LCAyMDIyIGF0
IDEwOjE1OjUyQU0gKzAxMDAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4gSW5jbHVkZSBsaWJj
ZmxhdCBmcm9tIHBhZ2UuaCB0byBhdm9pZCBlcnJvciBsaWtlIHRoaXMgb25lOgo+IAo+IC9wYXRo
L3RvL2t2bS11bml0LXRlc3RzL2xpYi9hc20vcGFnZS5oOjE5Ojk6IGVycm9yOiB1bmtub3duIHR5
cGUgbmFtZSDigJh1NjTigJkKPiAgICAxOSB8IHR5cGVkZWYgdTY0IHB0ZXZhbF90Owo+ICAgICAg
IHwgICAgICAgICBefn4KPiBbLi5dCj4gL3BhdGgvdG8va3ZtLXVuaXQtdGVzdHMvbGliL2FzbS9w
YWdlLmg6NDc6ODogZXJyb3I6IHVua25vd24gdHlwZSBuYW1lIOKAmHBoeXNfYWRkcl904oCZCj4g
ICAgNDcgfCBleHRlcm4gcGh5c19hZGRyX3QgX192aXJ0X3RvX3BoeXModW5zaWduZWQgbG9uZyBh
ZGRyKTsKPiAgICAgICB8ICAgICAgICBefn5+fn5+fn5+fgo+ICAgICAgIHwgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn4KPiBbLi5dCj4gL3BhdGgvdG8va3Zt
LXVuaXQtdGVzdHMvbGliL2FzbS9wYWdlLmg6NTA6NDc6IGVycm9yOiB1bmtub3duIHR5cGUgbmFt
ZSDigJhzaXplX3TigJkKPiAgICA1MCB8IGV4dGVybiB2b2lkICpfX2lvcmVtYXAocGh5c19hZGRy
X3QgcGh5c19hZGRyLCBzaXplX3Qgc2l6ZSk7Cj4gCj4gVGhlIGFybTY0IHZlcnNpb24gb2YgdGhl
IGhlYWRlciBhbHJlYWR5IGluY2x1ZGVzIGxpYmNmbGF0IHNpbmNlIGNvbW1pdAo+IGEyZDA2ODUy
ZmU1OSAoImFybTY0OiBBZGQgc3VwcG9ydCBmb3IgY29uZmlndXJpbmcgdGhlIHRyYW5zbGF0aW9u
Cj4gZ3JhbnVsZSIpLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhh
bmRydS5lbGlzZWlAYXJtLmNvbT4KPiAtLS0KPiAgbGliL2FybS9hc20vcGFnZS5oIHwgMiArKwo+
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2xpYi9h
cm0vYXNtL3BhZ2UuaCBiL2xpYi9hcm0vYXNtL3BhZ2UuaAo+IGluZGV4IDhlYjRhODgzODA4ZS4u
MGE0NmJkYTAxOGM3IDEwMDY0NAo+IC0tLSBhL2xpYi9hcm0vYXNtL3BhZ2UuaAo+ICsrKyBiL2xp
Yi9hcm0vYXNtL3BhZ2UuaAo+IEBAIC04LDYgKzgsOCBAQAo+ICAKPiAgI2luY2x1ZGUgPGxpbnV4
L2NvbnN0Lmg+Cj4gIAo+ICsjaW5jbHVkZSA8bGliY2ZsYXQuaD4KPiArCj4gICNkZWZpbmUgUEFH
RV9TSElGVAkJMTIKPiAgI2RlZmluZSBQQUdFX1NJWkUJCShfQUMoMSxVTCkgPDwgUEFHRV9TSElG
VCkKPiAgI2RlZmluZSBQQUdFX01BU0sJCSh+KFBBR0VfU0laRS0xKSkKPiAtLSAKPiAyLjM3LjEK
PiAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
