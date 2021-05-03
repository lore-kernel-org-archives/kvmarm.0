Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406DCC433ED
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 08:07:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE56261244
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 08:07:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE56261244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E08F4B451;
	Mon,  3 May 2021 04:07:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ay20YYVKqoKz; Mon,  3 May 2021 04:07:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11F714B450;
	Mon,  3 May 2021 04:07:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 283394B450
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 04:07:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VT7J7E5ZiRD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 04:07:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22BD74B44E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 04:07:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620029227;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lQ3DC7AtOQDLcIS5zcoeo9H4pxzVMTr3J/iLQuTR5t4=;
 b=dRxL/fsC1wk5Tn1efHulq6x4pkW2NuxNoM36gFiMXBrAxz+1D2fcHInrhX8Uw0Bidhhhng
 BRAub8G6SnzSW0CiLgKHZWiK71jUoT1VUDP7ZJ+y4FTrr0vrIGW+ntAxSeGXpmaJiVx1RD
 dhO/WXVqREiICI7cmGukfN4ZmSHYg6E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-6jB4piEQMcaP-MnC-PHTEA-1; Mon, 03 May 2021 04:07:04 -0400
X-MC-Unique: 6jB4piEQMcaP-MnC-PHTEA-1
Received: by mail-wm1-f71.google.com with SMTP id
 h128-20020a1cb7860000b0290148da43c895so331461wmf.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 May 2021 01:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=lQ3DC7AtOQDLcIS5zcoeo9H4pxzVMTr3J/iLQuTR5t4=;
 b=Jnj3d6kNs1pkdkYVELxBd7f4gpOUs4pvch5gDfj//dpNIgOPG2/eJ8LzuG0yDjOZxQ
 4opG0YqQ9Oop03GD0Qv+krUeigIn+DpNX3Cqjq3vyrJ4CEHmzQ/R1Ed5WrTvk7HkuK9j
 K5rYdkZ5V9Qk0+rjxYhBenLjGfu5yx8hQnJ3Rc8EJt7ry3JeEACRdaY14lBorDli7q50
 9lUnx7PHCvZIk8FcJKgXckRl6WlqhDxsDvAdgeYdOU7QGl8zxBl4JtLfVoeKcQqTKwmb
 QLJVpHJ9o1kM5009BFh+LIK5zVYVQrGwSdN/JchukzmsqWo/XrHoPuzfH7FXog13Egd0
 b/hQ==
X-Gm-Message-State: AOAM5333r7kH5w/CjJQk8IrutLRwltH4MhxF6LwVCwvEHwFHmxJjlEzh
 /eaRG2kUSM9tsGnUdtJHVbkbvAFeoRtjZk3buS+ew+HzbtclSz2lKmDlFMnYhIyOq0Gjv9WgQ9J
 yIR2T4e+DSC2KbrjRCWCcoSoF
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr23514598wrw.108.1620029222805; 
 Mon, 03 May 2021 01:07:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztudGlR+1pwFh0JGWAmGAGZpGgLxmVHb9G+bDK9iqTp0teBnknMNyF222oyWVrdGbBg32OIQ==
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr23514565wrw.108.1620029222505; 
 Mon, 03 May 2021 01:07:02 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c649f.dip0.t-ipconnect.de. [91.12.100.159])
 by smtp.gmail.com with ESMTPSA id f6sm13386613wru.72.2021.05.03.01.07.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 03 May 2021 01:07:02 -0700 (PDT)
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
To: Mike Rapoport <rppt@kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <YIZNq5HMfJ1rWytv@kernel.org>
 <2d879629-3059-fd42-428f-4b7c2a73d698@huawei.com>
 <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
 <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
 <YIpY8TXCSc7Lfa2Z@kernel.org>
 <0cb013e4-1157-f2fa-96ec-e69e60833f72@huawei.com>
 <YIvTM5Yqit8AB4W8@kernel.org>
 <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
 <YI+XrAg4KOzOyt7c@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <24b37c01-fc75-d459-6e61-d67e8f0cf043@redhat.com>
Date: Mon, 3 May 2021 10:07:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YI+XrAg4KOzOyt7c@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMDMuMDUuMjEgMDg6MjYsIE1pa2UgUmFwb3BvcnQgd3JvdGU6Cj4gT24gRnJpLCBBcHIgMzAs
IDIwMjEgYXQgMDc6MjQ6MzdQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6Cj4+Cj4+Cj4+IE9u
IDIwMjEvNC8zMCAxNzo1MSwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPj4+IE9uIFRodSwgQXByIDI5
LCAyMDIxIGF0IDA2OjIyOjU1UE0gKzA4MDAsIEtlZmVuZyBXYW5nIHdyb3RlOgo+Pj4+Cj4+Pj4g
T24gMjAyMS80LzI5IDE0OjU3LCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+Pj4+Cj4+Pj4+Pj4gRG8g
eW91IHVzZSBTUEFSU01FTT8gSWYgeWVzLCB3aGF0IGlzIHlvdXIgc2VjdGlvbiBzaXplPwo+Pj4+
Pj4+IFdoYXQgaXMgdGhlIHZhbHVlIGlmIENPTkZJR19GT1JDRV9NQVhfWk9ORU9SREVSIGluIHlv
dXIgY29uZmlndXJhdGlvbj8KPj4+Pj4+IFllcywKPj4+Pj4+Cj4+Pj4+PiBDT05GSUdfU1BBUlNF
TUVNPXkKPj4+Pj4+Cj4+Pj4+PiBDT05GSUdfU1BBUlNFTUVNX1NUQVRJQz15Cj4+Pj4+Pgo+Pj4+
Pj4gQ09ORklHX0ZPUkNFX01BWF9aT05FT1JERVIgPSAxMQo+Pj4+Pj4KPj4+Pj4+IENPTkZJR19Q
QUdFX09GRlNFVD0weEMwMDAwMDAwCj4+Pj4+PiBDT05GSUdfSEFWRV9BUkNIX1BGTl9WQUxJRD15
Cj4+Pj4+PiBDT05GSUdfSElHSE1FTT15Cj4+Pj4+PiAjZGVmaW5lIFNFQ1RJT05fU0laRV9CSVRT
ICAgIDI2Cj4+Pj4+PiAjZGVmaW5lIE1BWF9QSFlTQUREUl9CSVRTICAgIDMyCj4+Pj4+PiAjZGVm
aW5lIE1BWF9QSFlTTUVNX0JJVFMgICAgIDMyCj4+Pj4KPj4+Pgo+Pj4+IFdpdGggdGhlIHBhdGNo
LMKgIHRoZSBhZGRyIGlzIGFsaWduZWQsIGJ1dCB0aGUgcGFuaWMgc3RpbGwgb2NjdXJyZWQsCj4+
Pgo+Pj4gSXMgdGhpcyB0aGUgc2FtZSBwYW5pYyBhdCBtb3ZlX2ZyZWVwYWdlcygpIGZvciByYW5n
ZSBbZGU2MDAsIGRlN2ZmXT8KPj4+Cj4+PiBEbyB5b3UgZW5hYmxlIENPTkZJR19BUk1fTFBBRT8K
Pj4KPj4gbm8sIHRoZSBDT05GSUdfQVJNX0xQQUUgaXMgbm90IHNldCwgYW5kIHllcyB3aXRoIHNh
bWUgcGFuaWMgYXQKPj4gbW92ZV9mcmVlcGFnZXMgYXQKPj4KPj4gc3RhcnRfcGZuL2VuZF9wZm4g
W2RlNjAwLCBkZTdmZl0sIFtkZTYwMDAwMCwgZGU3ZmYwMDBdIDogIHBmbiA9ZGU2MDAsIHBhZ2UK
Pj4gPWVmM2NjMDAwLCBwYWdlLWZsYWdzID0gZmZmZmZmZmYsICBwZm4ycGh5ID0gZGU2MDAwMDAK
Pj4KPj4+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGIwMjAwMDAwIC0gMHhjMDAwMDAw
MCwgcGZuOiBiMDIwMCAtIGIwMjAwCj4+Pj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhj
YzAwMDAwMCAtIDB4ZGNhMDAwMDAsIHBmbjogY2MwMDAgLSBiMDIwMAo+Pj4+IF9fZnJlZV9tZW1v
cnlfY29yZSwgcmFuZ2U6IDB4ZGU3MDAwMDAgLSAweGRlYTAwMDAwLCBwZm46IGRlNzAwIC0gYjAy
MDAKPiAKPiBIbW0sIFtkZTYwMCwgZGU3ZmZdIGlzIG5vdCBhZGRlZCB0byB0aGUgZnJlZSBsaXN0
cyB3aGljaCBpcyBjb3JyZWN0LiBCdXQKPiB0aGVuIGl0J3MgdW5jbGVhciBob3cgdGhlIHBhZ2Ug
Zm9yIGRlNjAwIGdldHMgdG8gbW92ZV9mcmVlcGFnZXMoKS4uLgo+IAo+IENhbid0IHNheSBJIGhh
dmUgYW55IGJyaWdodCBpZGVhcyB0byB0cnkgaGVyZS4uLgoKQXJlIHdlIG1pc3Npbmcgc29tZSBj
aGVja3MgKGUuZy4sIFBhZ2VSZXNlcnZlZCgpKSB0aGF0IApwZm5fdmFsaWRfd2l0aGluKCkgd291
bGQgaGF2ZSAiY2F1Z2h0IiBiZWZvcmU/CgotLSAKVGhhbmtzLAoKRGF2aWQgLyBkaGlsZGVuYgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
