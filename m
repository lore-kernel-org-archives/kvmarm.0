Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B64C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 12:54:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 530086504F
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 12:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 530086504F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE944B5AB;
	Tue, 16 Mar 2021 08:54:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7xsplGi2jVgj; Tue, 16 Mar 2021 08:53:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B24C84B405;
	Tue, 16 Mar 2021 08:53:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E65A4B24C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 08:53:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R2NFHwmodB-8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 08:53:57 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43EC94B24B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 08:53:57 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id k8so7364756wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 05:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=YhH9qDZ7UYlwG27TDzW+MnA+T1mgb+aVZ+2GGb51p/w=;
 b=TIM3a2FTxwFa4dUcd5GxP31tl7wKFqCYuHW1RCSsYGdx7PfVWPHK4rzncWHc1Wi7o/
 d2c3Bkjb6IsOlZBuk6rn54lnPctO+Kra4AXoGrH+tT7zTPwClbOKbkcQ9wbb+rGcmK3R
 HUv2leFtOacjysyoAyc9t7BDaMfJ4EoYue76wFoHsTLkgUWeXl3xaHcENikgGzeEy2QY
 2AZ211B1x7jPAMLqwIUBhegCNV14sv6beMz36g1/kzF9w2L1N5tTi2BNhRJlm8CoN6hW
 YRmJP03BcUurDZRpbei0PZIRVONf2SXSbDMfZVUktwxp5jFGb+cUr/XXkKviaSfLxp2l
 a+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=YhH9qDZ7UYlwG27TDzW+MnA+T1mgb+aVZ+2GGb51p/w=;
 b=MR3o5zfMOE7ZIo6zKcoQMxK2mlWldQWU/ZX+DVaikJsTC4+UuR2K7rcAbwVCXfx6rh
 VeSJ8tUTD9z4o2frns8sOrx9t+lMHhX9BznKdwSoq4zdzKOyE98lqlQQJH9dUklz2qiu
 UZFR/mCzbeU96wDsR/0PN7c8NJkJwAfDL1zUVgoeDEeDf1RXaPvwSqF9lVmkLkdAhQyu
 McA5Yxtmle3OGCv5xKskSMQi06WEWIG6kXCkhNaHf/V/vojysvokHXRbj+n7XFl4zQyL
 fpRZy6f+T464RI45OjRJQ7AlZGzps4YLLIDCyYxT6wjFIZ1SvKuxpw6zjY0TQyGVEiaB
 juIg==
X-Gm-Message-State: AOAM533LgNIHXK+F+/JUC9u25Te2A6xTuXzt5B10izrpKDCY2Ne9KiIs
 0c/3n1VvEjUt1gmNhG5JF5ug6Q==
X-Google-Smtp-Source: ABdhPJxGSb04ZRPkSOl7qX8cOElBY2c0oVdgp7I4wyUE4jKYntg8bGYi4e+uakNSKN8b4ZKHwnBiBg==
X-Received: by 2002:adf:fe48:: with SMTP id m8mr4694101wrs.135.1615899235994; 
 Tue, 16 Mar 2021 05:53:55 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id b186sm3074930wmc.44.2021.03.16.05.53.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 16 Mar 2021 05:53:55 -0700 (PDT)
Date: Tue, 16 Mar 2021 12:53:53 +0000
From: Quentin Perret <qperret@google.com>
To: Mate Toth-Pal <mate.toth-pal@arm.com>
Subject: Re: [PATCH v5 33/36] KVM: arm64: Wrap the host with a stage 2
Message-ID: <YFCqYT3Ib8kAN7/c@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-34-qperret@google.com>
 <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com>
Cc: kernel-team@android.com, android-kvm@google.com, catalin.marinas@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

T24gVHVlc2RheSAxNiBNYXIgMjAyMSBhdCAxMzoyODo0MiAoKzAxMDApLCBNYXRlIFRvdGgtUGFs
IHdyb3RlOgo+IFRlc3RpbmcgdGhlIGxhdGVzdCB2ZXJzaW9uIG9mIHRoZSBwYXRjaHNldCwgd2Ug
c2VlbSB0byBoYXZlIGZvdW5kIGFub3RoZXIKPiB0aGluZyByZWxhdGVkIHRvIEZFQVRfUzJGV0Iu
CgpBcmdoISBJIHdpc2ggSSBjb3VsZCBwdXQgbXkgaGFuZHMgb24gaGFyZHdhcmUgd2l0aCBGV0Iu
IFRoYW5rcyBhZ2FpbiBmb3IKdGhlIHJlcG9ydC4KCj4gVGhpcyBmdW5jdGlvbiBhbHdheXMgc2V0
cyBOb3JtYWwgbWVtb3J5IGluIHRoZSBzdGFnZSAyIHRhYmxlLCBldmVuIGlmIHRoZQo+IGFkZHJl
c3MgaW4gc3RhZ2UgMSB3YXMgbWFwcGVkIGFzIGEgZGV2aWNlIG1lbW9yeS4gSG93ZXZlciB3aXRo
IHRoZSBjdXJyZW50Cj4gc2V0dGluZ3MgZm9yIG5vcm1hbCBtZW1vcnkgKGkuZS4gTVRfUzJfRldC
X05PUk1BTCBiZWluZyBkZWZpbmVkIHRvIDYpCj4gYWNjb3JkaW5nIHRvIHRoZSBhcmNoaXRlY3R1
cmUgKFNlZSBBcm0gQVJNLCAnRDUuNS41IFN0YWdlIDIgbWVtb3J5IHJlZ2lvbgo+IHR5cGUgYW5k
IGNhY2hlYWJpbGl0eSBhdHRyaWJ1dGVzIHdoZW4gRkVBVF9TMkZXQiBpcyBpbXBsZW1lbnRlZCcp
IHRoZQo+IHJlc3VsdGluZyBhdHRyaWJ1dGVzIHdpbGwgYmUgJ05vcm1hbCBXcml0ZS1CYWNrJyBl
dmVuIGlmIHRoZSBzdGFnZSAxIG1hcHBpbmcKPiBzZXRzIGRldmljZSBtZW1vcnkuIEFjY2Vzc2lu
ZyBkZXZpY2UgbWVtb3J5IG1hcHBlZCBsaWtlIHRoaXMgY2F1c2VzIGFuCj4gU0Vycm9yIG9uIHNv
bWUgcGxhdGZvcm1zIHdpdGggRkVBVF9TMkZXQiBiZWluZyBpbXBsZW1lbnRlZC4KClJpZ2h0LgoK
PiBDaGFuZ2luZyB0aGUgdmFsdWUgb2YgTVRfUzJfRldCX05PUk1BTCB0byA3IHdvdWxkIGNoYW5n
ZSB0aGlzIGJlaGF2aW9yLCBhbmQKPiB0aGUgcmVzdWx0aW5nIG1lbW9yeSB0eXBlIHdvdWxkIGJl
IGRldmljZS4KClNvdW5kcyBsaWtlIHRoZSBjb3JyZWN0IGZpeCBoZXJlIC0tIHNlZSBiZWxvdy4K
Cj4gQW5vdGhlciBzb2x1dGlvbiB3b3VsZCBiZSB0byBhZGQgYW4gZWxzZSBicmFuY2ggdG8gdGhl
IGxhc3QgJ2lmJyBhYm92ZSBsaWtlCj4gdGhpczoKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9rdm0vaHlwL252aGUvbWVtX3Byb3RlY3QuYwo+IGIvYXJjaC9hcm02NC9rdm0vaHlwL252aGUv
bWVtX3Byb3RlY3QuYwo+IGluZGV4IGZmZmE0MzJjZTNlYi4uNTRlNWQzYjBiMmUxIDEwMDY0NAo+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL21lbV9wcm90ZWN0LmMKPiArKysgYi9hcmNo
L2FybTY0L2t2bS9oeXAvbnZoZS9tZW1fcHJvdGVjdC5jCj4gQEAgLTIxNCw2ICsyMTQsOCBAQCBz
dGF0aWMgaW50IGhvc3Rfc3RhZ2UyX2lkbWFwKHU2NCBhZGRyKQo+IAo+IMKgwqDCoMKgwqDCoMKg
IGlmIChpc19tZW1vcnkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHByb3QgfD0g
S1ZNX1BHVEFCTEVfUFJPVF9YOwo+ICvCoMKgwqDCoMKgwqAgZWxzZQo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHByb3QgfD0gS1ZNX1BHVEFCTEVfUFJPVF9ERVZJQ0U7Cj4gCj4gwqDC
oMKgwqDCoMKgwqAgaHlwX3NwaW5fbG9jaygmaG9zdF9rdm0ubG9jayk7Cj4gwqDCoMKgwqDCoMKg
wqAgcmV0ID0ga3ZtX3BndGFibGVfc3RhZ2UyX2ZpbmRfcmFuZ2UoJmhvc3Rfa3ZtLnBndCwgYWRk
ciwgcHJvdCwKPiAmcmFuZ2UpOwoKV2hpbGUgdGhpcyB3b3VsZCB3b3JrIGluIHRoaXMgcGFydGlj
dWxhciBjYXNlLCBJIGRvbid0IHRoaW5rIHdlIHNob3VsZApmb3JjZSBhbGwgbm9uLVJBTSBhY2Nl
c3NlcyBhcyBkZXZpY2UgYXMgdGhlIGhvc3QgbWF5IGhhdmUgcmVhc29ucyBub3QgdG8Kd2FudCB0
aGlzIChlLmcuIGFjY2Vzc2luZyBTUkFNKS4gWW91ciBmaXJzdCBzdWdnZXN0aW9ucyBhbGxvd3Mg
dXMgdG8gZG8KanVzdCB0aGF0LCBzbyBpdCBpcyBwcmVmZXJhYmxlIEkgdGhpbmsuCgpUaGFua3Ms
ClF1ZW50aW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
