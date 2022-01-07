Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4125C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 17:11:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E8F04B293;
	Fri,  7 Jan 2022 12:11:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DdwFRdl+VE1e; Fri,  7 Jan 2022 12:10:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E6D4B29B;
	Fri,  7 Jan 2022 12:10:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FB334B293
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 12:10:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id go9pCO2X1QJz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 12:10:56 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 394974B28A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 12:10:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641575455;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3pHZETgLBLv2UtRUl6D+BkLJ1jpxDMC+Tp9BPH2rI4Y=;
 b=CNNP5aJYi8BQHcqf02peUI0SqoPhZwOwGUJQFTl1mCSgMue7LMhE9p2zvqSkgDBHaNzKvs
 YIRSYkX0kqTrRdsW0dSePCzGAe1qndWsrtkZ4oTvRzIjPAg8wWqQ64AAdU8Q/Ensw6aKKA
 RyG06EudQ0Fzjh4axSEx3LF5TRCimVQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-cKSNKlSQNR6p3QeJU_hj5A-1; Fri, 07 Jan 2022 12:10:54 -0500
X-MC-Unique: cKSNKlSQNR6p3QeJU_hj5A-1
Received: by mail-wm1-f69.google.com with SMTP id
 i81-20020a1c3b54000000b003467c58cbddso4623057wma.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 09:10:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=3pHZETgLBLv2UtRUl6D+BkLJ1jpxDMC+Tp9BPH2rI4Y=;
 b=FfQUS//TKDj0ZqZjRI1b4nHJbA2hgYvVKhRqe2m/dEQ0YIlz3UuG1YNnET/SABewJP
 0EOi14/e2kGvMz5ggb1jt6PWartvEqkDXN504rhk/GUoXFHpzqcl602+TVrXWkH9HQ3o
 jmE2qwsfKa8kTgO9Gm5fy/IDc0RMysW+d893pNiWkL03uo2FprDuinDKoWyDLYzF7Ovk
 Ws/tu8Ne9FmJ1SH/KakyQWchpqhSBDs+Tm/BuwyOcGVnLCljqcQSp07PjAh4oe73GDAi
 jaYy0qwB+79Pw9MkjpjptfEzqgS9nwHTwxGFMhpO3K92rU61b5wyP4m3M1DezEs6Wps1
 P9zw==
X-Gm-Message-State: AOAM530Os4ujJLsp1N0mS0XUNd/GHVtu3s3gwfTGtdM1xXi00ZPceW2N
 rNu1tHYAZFpT93/Ayy6gTf8Bej5tZnqfUSgmYDpJF+VzofddPX2DC4Xw3DhDgnpa8u4MlyA6EFE
 ckR1CM/JWiZANEhmmj7DN71Nn
X-Received: by 2002:a05:6000:1e07:: with SMTP id
 bj7mr5846332wrb.126.1641575453603; 
 Fri, 07 Jan 2022 09:10:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9B+o3El0zBY9MRT5nLG9njMtu1q5Pq4PQVdvKApvURcNkIL2mU6w3Vbnbe92sMBLQ4jEp8A==
X-Received: by 2002:a05:6000:1e07:: with SMTP id
 bj7mr5846317wrb.126.1641575453396; 
 Fri, 07 Jan 2022 09:10:53 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id p23sm5013096wms.3.2022.01.07.09.10.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 07 Jan 2022 09:10:52 -0800 (PST)
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
To: Marc Zyngier <maz@kernel.org>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
 <dbe883ca-880e-7f2b-1de7-4b2d3361545d@redhat.com>
 <87pmpiyrfw.wl-maz@kernel.org>
 <b9031d40-897e-b8c5-4240-fc2936dcbcb9@redhat.com>
 <877dbfywpj.wl-maz@kernel.org>
 <cb9f6c39-40f8-eea7-73bf-13df1e5dae9d@redhat.com>
 <8735m0zmhq.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <44fcbe49-4eb2-8891-2cb9-2e2df7dee98b@redhat.com>
Date: Fri, 7 Jan 2022 18:10:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8735m0zmhq.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

SGkgTWFyYywKCk9uIDEvNi8yMiA4OjM0IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgRXJp
YywKPgo+IE9uIFdlZCwgMDUgSmFuIDIwMjIgMDk6NDE6MTkgKzAwMDAsCj4gRXJpYyBBdWdlciA8
ZXJpYy5hdWdlckByZWRoYXQuY29tPiB3cm90ZToKPj4gY291bGRuJ3QgeW91IHNpbXBseSBpbnRy
b2R1Y2UgaGlnaG1lbV9yZWRpc3Qgd2hpY2ggaXMgdHJ1bHkgbWlzc2luZy4gWW91Cj4+IGNvdWxk
IHNldCBpdCBpbiB2aXJ0X3NldF9tZW1tYXAoKSBpbiBjYXNlIHlvdSBza2lwIGV4dGVuZGVkX21h
cCBvdmVybGF5Cj4+IGFuZCB1c2UgaXQgaW4gdmlydF9naWN2M19yZWRpc3RfcmVnaW9uX2NvdW50
KCkgYXMgeW91IGRpZD8KPj4gSW4gYWRkaXRpb24gdG8gdGhlIGRldmljZSBtZW1vcnkgdG9wIGFk
ZHJlc3MgY2hlY2sgYWdhaW5zdCB0aGUgNEdCIGxpbWl0Cj4+IGlmICFoaWdobWVtLCB3ZSBzaG91
bGQgYmUgZmluZSB0aGVuPwo+IE5vLCBoaWdobWVtIHJlYWxseSBpc24ndCBuZWFybHkgZW5vdWdo
Lgo+Cj4gSW1hZ2luZSB5b3UgaGF2ZSAobGlrZSBJIGRvKSBhIHN5c3RlbSB3aXRoIDM2IGJpdHMg
b2YgSVBBIHNwYWNlLgo+IENyZWF0ZSBhIFZNIHdpdGggOEdCIG9mIFJBTSAod2hpY2ggbWVhbnMg
dGhlIGxvdy1lbmQgb2YgSVBBIHNwYWNlIGlzCj4gYWxyZWFkeSA5R0IpLiBPYnZpb3VzbHksIGhp
Z2htZW09dHJ1ZSBoZXJlLiBXaXRoIHRoZSBjdXJyZW50IGNvZGUsIHdlCj4gd2lsbCB0cnkgdG8g
ZXhwb3NlIHRoaXMgUENJIE1NSU8gcmFuZ2UsIHdoaWNoIGZhbGxzIHdheSBvdXQgb2YgdGhlIElQ
QQo+IHNwYWNlICh5b3UgbmVlZCBhdCBsZWFzdCA0MCBiaXRzIG9mIElQQSB0byBldmVuIGNvdmVy
IGl0IHdpdGggdGhlCj4gc21hbGxlc3QgY29uZmlndXJhdGlvbikuCkluIHRoYXQgY2FzZSB0aGUg
aGUgSGlnaCBNTUlPIHJlZ2lvbiBpcyBhY2NvdW50ZWQgaW4gdGhlIHZtcy0+aGlnaGVzdF9ncGE6
CgrCoMKgwqAgZm9yIChpID0gVklSVF9MT1dNRU1NQVBfTEFTVDsgaSA8IEFSUkFZX1NJWkUoZXh0
ZW5kZWRfbWVtbWFwKTsgaSsrKSB7CsKgwqDCoMKgwqDCoMKgIGh3YWRkciBzaXplID0gZXh0ZW5k
ZWRfbWVtbWFwW2ldLnNpemU7CgrCoMKgwqDCoMKgwqDCoCBiYXNlID0gUk9VTkRfVVAoYmFzZSwg
c2l6ZSk7CsKgwqDCoMKgwqDCoMKgIHZtcy0+bWVtbWFwW2ldLmJhc2UgPSBiYXNlOwrCoMKgwqDC
oMKgwqDCoCB2bXMtPm1lbW1hcFtpXS5zaXplID0gc2l6ZTsKwqDCoMKgwqDCoMKgwqAgYmFzZSAr
PSBzaXplOwrCoMKgwqAgfQrCoMKgwqAgdm1zLT5oaWdoZXN0X2dwYSA9IGJhc2UgLSAxOwoKYW5k
IHZpcnRfa3ZtX3R5cGUoKSBzaG91bGQgZXhpdCBpbiB0aGF0IGNhc2UgYXQ6CmlmIChyZXF1ZXN0
ZWRfcGFfc2l6ZSA+IG1heF92bV9wYV9zaXplKSB7CsKgwqDCoMKgwqDCoMKgIGVycm9yX3JlcG9y
dCgiLW0gYW5kICxtYXhtZW0gb3B0aW9uIHZhbHVlcyAiCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgInJlcXVpcmUgYW4gSVBBIHJhbmdlICglZCBiaXRzKSBsYXJnZXIg
dGhhbiAiCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgInRoZSBvbmUg
c3VwcG9ydGVkIGJ5IHRoZSBob3N0ICglZCBiaXRzKSIsCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmVxdWVzdGVkX3BhX3NpemUsIG1heF92bV9wYV9zaXplKTsKwqDC
oMKgwqDCoMKgwqAgZXhpdCgxKTsKwqDCoMKgIH0KCj8KPgo+IGhpZ2htZW0gcmVhbGx5IGlzIGEg
Y29udHJvbCB0aGF0IHNheXMgJ3RoaW5ncyBtYXkgbGl2ZSBhYm92ZSA0R0InLiBJdAo+IGRvZXNu
J3Qgc2F5ICpob3cgZmFyKiBhYm92ZSA0R0IgaXQgY2FuIGJlIHBsYWNlZC4gV2hpY2ggaXMgd2hh
dCBJIGFtCj4gdHJ5aW5nIHRvIGFkZHJlc3MuCgpPSyBJIHdpbGwgbG9vayBhdCB5b3VyIHY0IDst
KQoKVGhhbmtzCgpFcmljCj4KPiBUaGFua3MsCj4KPiAJTS4KPgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
