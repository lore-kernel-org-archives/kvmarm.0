Return-Path: <SRS0=WTva=7O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AB4C433DF
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jun 2020 09:21:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D561206A4
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jun 2020 09:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlgRQi64"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D561206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 815AD4B215;
	Mon,  1 Jun 2020 05:21:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z8f1l5t1km6e; Mon,  1 Jun 2020 05:21:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80BCC4B21C;
	Mon,  1 Jun 2020 05:21:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B254B215
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2020 05:21:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jqmnR03I4YOW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jun 2020 05:21:45 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAE514B20C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2020 05:21:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1591003305;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IuLK2sSn5CddFiGq7dQ41qvUoboLyFr4AuyNbWpmRVE=;
 b=WlgRQi64rupsUZsIt6GXIWniHTN0ge0W3L8al0gH4s3zbWjpUGH+AKn5spVU8fDUy+OIVn
 POmPE7zyvImjhFh2JSN8HS/BBfc+v7SRv7Iuj8qL5QkasZ9zuSF/p19YZ6/iFl5PbvVgJq
 FxcroLykBuTDHTvKTe72U7s64XHx0xw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-KronKw7EPkaBE03K5USkhw-1; Mon, 01 Jun 2020 05:21:44 -0400
X-MC-Unique: KronKw7EPkaBE03K5USkhw-1
Received: by mail-wr1-f72.google.com with SMTP id s17so4622766wrt.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Jun 2020 02:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=IuLK2sSn5CddFiGq7dQ41qvUoboLyFr4AuyNbWpmRVE=;
 b=qRPK1HpfKMlGah30u08PVQj4n8KYM8iF5ol0yXxpuPoWu9gbtb4Ygx4iX3Lbs+KxDf
 FIPCQew+hbO+mLF92kKBn75on/FHaSOH/bELwMNsCmAlZ63M9J7IGymFyhHix3ZKp0b3
 nopVzdmcPx1mPNBW1Fbc5/0FHNakv4sc06KoM+Vp+TRJf5idtSrMbyRF8q1vVHxL7ePu
 4SNYJ/ZQ0bux/z+wBE98j88J6LWFuTQq73KuaKaGmseOb7X0lEb3md1F1LyGrctgI/Jg
 GpMSf79faGdxCPnZHqEeDh2vyhNcMTc1rgzeMcv+Db8sbwGMj3GdiQZ8vBF04oA/2Gjo
 HIVQ==
X-Gm-Message-State: AOAM531OW0uMAGYfDJPHpfLNfs705aiftkOBtyh0orZwSh4BE3kWF7BA
 1bC4n8PV69C/KO3sa+p+It4m4F259UevoXP7q4jgkXaLS3HgQ+LbN8T4M/laZzndQ6HjYo4FkST
 aEQJbDS9RRIgrlLBlxUsj1d9t
X-Received: by 2002:a1c:9cca:: with SMTP id f193mr20301255wme.71.1591003302913; 
 Mon, 01 Jun 2020 02:21:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZjBowPYwC+DKgI4BRKZhXw+nZFZK73A3GMy1xVVIrdJTX5qghOe0isbEbZkUkMPrdG2E5KQ==
X-Received: by 2002:a1c:9cca:: with SMTP id f193mr20301235wme.71.1591003302659; 
 Mon, 01 Jun 2020 02:21:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e044:3d2:1991:920c?
 ([2001:b07:6468:f312:e044:3d2:1991:920c])
 by smtp.gmail.com with ESMTPSA id d4sm19487104wre.22.2020.06.01.02.21.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 01 Jun 2020 02:21:42 -0700 (PDT)
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
To: Marc Zyngier <maz@kernel.org>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
 <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
 <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
 <8ab64c6a-582b-691d-79ab-21cdc0455cd3@redhat.com>
 <6a4a82a4-af01-98c2-c854-9199f55f7bd3@redhat.com>
 <6965aaf641a23fab64fbe2ceeb790272@kernel.org>
 <d0bfb944-b50a-608a-7dcc-5a409cdc4524@redhat.com>
 <4337cca152df47c93d96e092189a0e36@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5c72c597-732e-7dbf-d056-665674ec1792@redhat.com>
Date: Mon, 1 Jun 2020 11:21:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4337cca152df47c93d96e092189a0e36@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMzEvMDUvMjAgMTQ6NDQsIE1hcmMgWnluZ2llciB3cm90ZToKPj4KPj4gSXMgdGhlcmUgYW4g
QVJNLWFwcHJvdmVkIHdheSB0byByZXVzZSB0aGUgUzIgZmF1bHQgc3luZHJvbWVzIHRvIGRldGVj
dAo+PiBhc3luYyBwYWdlIGZhdWx0cz8KPiAKPiBJdCB3b3VsZCBtZWFuIGJlaW5nIGFibGUgdG8g
c2V0IGFuIEVTUl9FTDIgcmVnaXN0ZXIgdmFsdWUgaW50byBFU1JfRUwxLAo+IGFuZCB0aGVyZSBp
cyBub3RoaW5nIGluIHRoZSBhcmNoaXRlY3R1cmUgdGhhdCB3b3VsZCBhbGxvdyB0aGF0LAoKSSB1
bmRlcnN0YW5kIHRoYXQgdGhpcyBpcyBub3Qgd2hhdCB5b3Ugd2FudCB0byBkbyBhbmQgSSdtIG5v
dCBwcm9wb3NpbmcKaXQsIGJ1dCBJIHdhbnQgdG8gdW5kZXJzdGFuZCB0aGlzIGJldHRlcjogX2lu
IHByYWN0aWNlXyBkbyBDUFVzIGNoZWNrCmNsb3NlbHkgd2hhdCBpcyB3cml0dGVuIGluIEVTUl9F
TDE/CgpJbiBhbnkgY2FzZSwgdGhlIG9ubHkgd2F5IHRvIGltcGxlbWVudCB0aGlzLCBpdCBzZWVt
cyB0byBtZSwgd291bGQgYmUgYQpjb21wbGV0ZWx5IHBhcmF2aXJ0dWFsaXplZCBleGNlcHRpb24g
dmVjdG9yIHRoYXQgZG9lc24ndCB1c2UgRVNSIGF0IGFsbC4KCk9uIHRoZSBvdGhlciBoYW5kLCBm
b3IgdGhlIHBhZ2UgcmVhZHkgKGludGVycnVwdCkgc2lkZSBhc3NpZ25pbmcgYSBQUEkKc2VlbXMg
Y29tcGxpY2F0ZWQgYnV0IGRvYWJsZS4KClBhb2xvCgo+IHdpdGgKPiB0aGUgZXhjZXB0aW9uIG9m
IG5lc3RlZCB2aXJ0OiBhIFZIRSBndWVzdCBoeXBlcnZpc29yIHJ1bm5pbmcgYXQgRUwxCj4gbXVz
dCBiZSBhYmxlIHRvIG9ic2VydmUgUzIgZmF1bHRzIGZvciBpdHMgb3duIFMyLCBhcyBzeW50aGVz
aXplZCBieQo+IHRoZSBob3N0IGh5cGVydmlzb3IuCgo+IFRoZSB0cm91YmxlIGlzIHRoYXQ6Cj4g
LSB0aGVyZSBpcyBzbyBmYXIgbm8gY29tbWVyY2lhbGx5IGF2YWlsYWJsZSBDUFUgc3VwcG9ydGlu
ZyBOVgo+IC0gZXZlbiBpZiB5b3UgY291bGQgZ2V0IGhvbGQgb2Ygc3VjaCBhIG1hY2hpbmUsIHRo
ZXJlIGlzIG5vCj4gwqAgZ3VhcmFudGVlIHRoYXQgc3VjaCAiRUwyIHN5bmRyb21lIGF0IEVMMSIg
aXMgdmFsaWQgb3V0c2lkZSBvZgo+IMKgIHRoZSBuZXN0ZWQgY29udGV4dAo+IC0gdGhpcyBkb2Vz
bid0IHNvbHZlIHRoZSBpc3N1ZSBmb3Igbm9uLU5WIENQVXMgYW55d2F5CgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
