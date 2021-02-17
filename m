Return-Path: <SRS0=BQox=HT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17059C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 17:24:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86F8264E45
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 17:24:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86F8264E45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD704B432;
	Wed, 17 Feb 2021 12:24:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fupjHcVsrZvT; Wed, 17 Feb 2021 12:24:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E91934B3EF;
	Wed, 17 Feb 2021 12:24:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1538B4B3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 12:24:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xpsl-Sx+EBl3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2021 12:24:37 -0500 (EST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5FDD4B397
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 12:24:36 -0500 (EST)
Received: by mail-wm1-f47.google.com with SMTP id a207so4347424wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 09:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=28sKZ6GoDDfm+skTZwXVa7BJ4NxVV664zFdxuUjXxhg=;
 b=P1Rr2sTWnxR8gFceqInN8wXy+MYiOtuyz/fJWPTDDnjaJf2CrCSaZYc6dGFxotRXDT
 54qgwZ5gMWO9xYX+gjI5cXG5CpPyS+8hNYWDfsrnr9PKIUfFQ3ehD0k6DE53Ew+2WMEx
 zFmfZONvPNWBcJSIbUe7EKB4Xuo0Z8qDWpXg2htcKpcs29NGMzcNbdDGEZNgbhcFHCit
 F+kOq0Gzp7NqUNRYPChUFsgOq0YBaz265xjOXNV0qOZ0sR2slGntyGJESD9NxFiXFM6h
 OusM8fzuRzLAEt0CXFlEo51EG2jP4ZmGJtLjoY59XZCaePhGSmsl2npTcW4IQXVnOf94
 wDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=28sKZ6GoDDfm+skTZwXVa7BJ4NxVV664zFdxuUjXxhg=;
 b=SwLOwVvofmEWsVFF/4h/x7cqhLkh97mzKbHHKglgzXJVd6dhY31xkO+9KPlM2ac5NA
 eJqxzAlOHFhkotdBIqJqNfuDh7MIgmV+UIcywsTNDqYRhlmXrwNafD158KBtMLWkuRyK
 zRlzU1vhD6RD2Pzyl2TFnhg0CA9nA+iAFMpve7x8dxymYGHDbtSQWlJP8lh6D4Hl/ebJ
 4Lsb+yEH2D0HXzoLoCQb4ou3ZRHvKQ1Ve9ktmGqEYW4c6mtAOXi0jMAWwGW5yD5tgWCu
 vCjg5MOQmPomxv67UMLwNF/hu6fQp7kxLb9+ffWcpTYRdbjx1j3vuZV/V3A2YfSUxggh
 7wyQ==
X-Gm-Message-State: AOAM5308SciYGWicUa6yajvTX8Q7qNDDQg4LWs+2zWHyR7nENQOsk4SW
 Dbtim+7ydCtb3rf24x1MHLf61g==
X-Google-Smtp-Source: ABdhPJyqlM3AbEF+i/vd8Ow0XcODR/KRVqiSywaqCamaAIs/m85374DnOOb2h1qv63RmhoHLO+zDBQ==
X-Received: by 2002:a7b:c007:: with SMTP id c7mr7841039wmb.59.1613582675427;
 Wed, 17 Feb 2021 09:24:35 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id v204sm3995339wmg.38.2021.02.17.09.24.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 17 Feb 2021 09:24:35 -0800 (PST)
Date: Wed, 17 Feb 2021 17:24:32 +0000
From: Quentin Perret <qperret@google.com>
To: Mate Toth-Pal <mate.toth-pal@arm.com>, r@google.com
Subject: Re: [RFC PATCH v2 00/26] KVM/arm64: A stage 2 for the host
Message-ID: <YC1RUGv5eL1+dZDs@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <18756e24-ca87-9c98-0e20-7c7a4c4d5433@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <18756e24-ca87-9c98-0e20-7c7a4c4d5433@arm.com>
Cc: devicetree@vger.kernel.org, nd@arm.com, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

SGkgTWF0ZSwKCk9uIFdlZG5lc2RheSAxNyBGZWIgMjAyMSBhdCAxNzoyNzowNyAoKzAxMDApLCBN
YXRlIFRvdGgtUGFsIHdyb3RlOgo+IFdlIHRlc3RlZCB0aGUgcEtWTSBjaGFuZ2VzIHB1bGxlZCBm
cm9tIGhlcmU6Cj4gCj4gCj4gPiAgICAgIGh0dHBzOi8vYW5kcm9pZC1rdm0uZ29vZ2xlc291cmNl
LmNvbS9saW51eCBxcGVycmV0L2hvc3Qtc3RhZ2UyLXYyCj4gCj4gCj4gV2Ugd2VyZSB1c2luZyBh
IHRhcmdldCB3aXRoIEFybSBhcmNoaXRlY3R1cmUgd2l0aCBGRUFUX1MyRldCLCBhbmQgZm91bmQg
dGhhdAo+IHRoZXJlIGlzIGEgYnVnIGluIHRoZSBwYXRjaC4KPiAKPiAKPiBJdCB0dXJuZWQgb3V0
IHRoYXQgdGhlIEtlcm5lbCBjaGVja3MgZm9yIHRoZSBleHRlbnNpb24sIGFuZCBzZXRzIHVwIHRo
ZQo+IHN0YWdlIDIgdHJhbnNsYXRpb24gc28gdGhhdCBpdCBmb3JjZXMgdGhlIGhvc3QgbWVtb3J5
IHR5cGUgdG8gd3JpdGUtdGhyb3VnaC4KPiBIb3dldmVyIGl0IHNlZW1zIHRoYXQgdGhlIGNvZGUg
ZG9lc24ndCB0dXJuIG9uIHRoZSBmZWF0dXJlIGluIHRoZSBIQ1JfRUwyCj4gcmVnaXN0ZXIuCj4g
Cj4gCj4gV2Ugd2VyZSBhYmxlIHRvIGZpeCB0aGUgaXNzdWUgYnkgYXBwbHlpbmcgdGhlIGZvbGxv
d2luZyBwYXRjaDoKPiAKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL252aGUv
bWVtX3Byb3RlY3QuYwo+IGIvYXJjaC9hcm02NC9rdm0vaHlwL252aGUvbWVtX3Byb3RlY3QuYwo+
IGluZGV4IDBjZDNlYjE3OGYzYi4uZTg1MjFhMDcyZWE2IDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL2h5cC9udmhlL21lbV9wcm90ZWN0LmMKPiArKysgYi9hcmNoL2FybTY0L2t2bS9oeXAv
bnZoZS9tZW1fcHJvdGVjdC5jCj4gQEAgLTEwNSw2ICsxMDUsOCBAQCBpbnQga3ZtX2hvc3RfcHJl
cGFyZV9zdGFnZTIodm9pZCAqbWVtX3BndF9wb29sLCB2b2lkCj4gKmRldl9wZ3RfcG9vbCkKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGFyYW1zLT52dHRiciA9IGt2bV9nZXRfdnR0
YnIobW11KTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGFyYW1zLT52dGNyID0g
aG9zdF9rdm0uYXJjaC52dGNyOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwYXJh
bXMtPmhjcl9lbDIgfD0gSENSX1ZNOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlm
IChjcHVzX2hhdmVfY29uc3RfY2FwKEFSTTY0X0hBU19TVEFHRTJfRldCKSkKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGFyYW1zLT5oY3JfZWwyIHw9IEhD
Ul9GV0I7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fZmx1c2hfZGNhY2hlX2Fy
ZWEocGFyYW1zLCBzaXplb2YoKnBhcmFtcykpOwo+IMKgwqDCoMKgwqDCoMKgIH0KCkFoYSwgaW5k
ZWVkLCB0aGlzIGxvb2tzIHJpZ2h0LiBJJ2xsIGRvdWJsZSBjaGVjayBIQ1JfRUwyIHRvIHNlZSBp
ZiBJJ20KbWlzc2luZyBhbnkgb3RoZXIsIGFuZCBJJ2xsIGFkZCB0aGlzIHRvIHYzLgoKVGhhbmtz
IGZvciB0ZXN0aW5nLCBhbmQgdGhlIGZvciB0aGUgcmVwb3J0LgpRdWVudGluCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
