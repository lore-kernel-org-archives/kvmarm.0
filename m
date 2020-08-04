Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C7BC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 14:47:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02E31206DA
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 14:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aVExCt4o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02E31206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E5384B722;
	Tue,  4 Aug 2020 10:47:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id unuGyc7--1uW; Tue,  4 Aug 2020 10:47:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A3494B713;
	Tue,  4 Aug 2020 10:47:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98BFF4B6E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 10:47:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c6-6o1EL3jmS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 10:47:11 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C3814B6ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 10:47:11 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id p14so2938074wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2020 07:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:in-reply-to:date
 :message-id:mime-version:content-transfer-encoding;
 bh=r6kGfPE/KsV7nTfH/d4o6yMleyqMBQteeLYhE/uXEe8=;
 b=aVExCt4oLxLR9aFvpeWEL25FVcXyMBmA32sEnExxpKELRADyd/9R8grqfipU4KCnal
 xw/mDJ1vB99SSCGocIuUpjfn/n+6sq37uzwOBd9mLMKkVAI+lqriN5bX9rydaC5fOnbj
 0JtNaK5ZOpnv/jS7GrAf3KIXRvmO0w8y8UIlljMRS32B26TgTdXAdQygC7MBMHn5lvoP
 AxItZMMHNLnLZ4HD7gvVz87UAMtI4b+WfUKZPyuyAhPhQZn3H0V7TXQuP4XID2r4pBE8
 0WVBskw0itNLwIU1bhZ/+0X4da9muIyp02S9F8OzsA8dAJ6ZSM4dlKp55if4+eS/15qd
 3g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject
 :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
 bh=r6kGfPE/KsV7nTfH/d4o6yMleyqMBQteeLYhE/uXEe8=;
 b=ZQ8hKDVJ6Vi8bkccGF6kc17mrQZDwWpgXkQdEEsBF/Rp8GKqdgVUzA8LvgkTgRLQQ2
 7qxM5tZ3Ns0aXsXSeaTQW4VFFaOy2Auwj5B9Fck6Kyqr1VCiXsRstmpKHlAKt4pnt9wV
 2GG9C2v0jNb1Mv+lsA/SXHQ5hOQ00ZLt8bipeROXNCxUfNcA/gQ61seGZ87ur/rPwmPa
 f+8afYGfl1w2p7qaEQBpWawQNeHOelP1neAzp/b/bW8yFjBehyyMkReTDF3CkbKHn3AL
 qwky5EqPItlamVvucRtgQmyDMiPPQc5qdYdfeMMOQ1kect2o2GVIDgWsKSU6lvii9YjJ
 T4AQ==
X-Gm-Message-State: AOAM532hDS/Go5CWZ23RkEN9ie9vM3RvGdNvyvf/aXsDKP84qvQsBFvu
 1ET5WU7Hp2V8DNPWI+se5T+v5A==
X-Google-Smtp-Source: ABdhPJygwsnCNO92emQNPWtLheZnx+hxAUxJL5JREQ4YEEZj8ftsQfnryzZlL6jATdGaMqcJvVKRKw==
X-Received: by 2002:a1c:f605:: with SMTP id w5mr4306747wmc.26.1596552430480;
 Tue, 04 Aug 2020 07:47:10 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id t25sm4403673wmj.18.2020.08.04.07.47.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Aug 2020 07:47:09 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 48B801FF7E;
 Tue,  4 Aug 2020 15:47:08 +0100 (BST)
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <CAMj1kXErSf7sQ4pPu-1em4AM=9JejA_-w3iwv4Wt=dgbQHxp-g@mail.gmail.com>
User-agent: mu4e 1.5.5; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH v1 0/3] put arm64 kvm_config on a diet
In-reply-to: <CAMj1kXErSf7sQ4pPu-1em4AM=9JejA_-w3iwv4Wt=dgbQHxp-g@mail.gmail.com>
Date: Tue, 04 Aug 2020 15:47:08 +0100
Message-ID: <87o8nqmpsj.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
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

CkFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+IHdyaXRlczoKCj4gT24gVHVlLCA0IEF1
ZyAyMDIwIGF0IDE0OjQ1LCBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+IHdy
b3RlOgo+Pgo+PiBIaSwKPj4KPj4gV2hlbiBidWlsZGluZyBndWVzdCBrZXJuZWxzIGZvciB2aXJ0
dWFsaXNhdGlvbiB3ZSB3ZXJlIGJyaW5naW5nIGluIGEKPj4gYnVuY2ggb2Ygc3R1ZmYgZnJvbSBw
aHlzaWNhbCBoYXJkd2FyZSB3aGljaCB3ZSBkb24ndCBuZWVkIGZvciBvdXIKPj4gaWRlYWxpc2Vk
IGZpeGFibGUgdmlydHVhbCBQQ0kgZGV2aWNlcy4gVGhpcyBzZXJpZXMgbWFrZXMgc29tZSBLY29u
ZmlnCj4+IGNoYW5nZXMgdG8gYWxsb3cgdGhlIFRodW5kZXJYIGFuZCBYR2VuZSBQQ0kgZHJpdmVy
cyB0byBiZSBjb21waWxlZAo+PiBvdXQuIEl0IGFsc28gZHJvcHMgUENJX1FVSVJLUyBmcm9tIHRo
ZSBLVk0gZ3Vlc3QgYnVpbGQgYXMgYSB2aXJ0dWFsCj4+IFBDSSBkZXZpY2Ugc2hvdWxkIGJlIHF1
aXJrIGZyZWUuCj4+Cj4KPiBXaGF0IGFib3V0IFBDSSBwYXNzdGhyb3VnaD8KClRoYXQgaXMgYSBn
b29kIHBvaW50IC0gaG93IG11Y2ggb2YgdGhlIGhvc3QgUENJIGNvbnRyb2xsZXIgaXMgdmlzaWJs
ZSB0bwphIHBhc3MtdGhyb3VnaCBndWVzdD8KCkFJVUkgaW4gcGFzc3Rocm91Z2ggdGhlIGRyaXZl
ciBvbmx5IGludGVyYWN0cyB3aXRoIHRoZSBwYXJ0aWN1bGFyIGNhcmRzCklPIHdpbmRvdy4gSG93
IG1hbnkgcXVpcmtzIGFyZSB2aXNpYmxlIGp1c3QgYXQgdGhlIGRldmljZSBsZXZlbCAocmF0aGVy
CnRoYW4gdGhlIGJ1cyBpdHNlbGYpPwoKVGhhdCBzYWlkIEkgdGhpbmsgdGhlIGxhc3QgcGF0Y2gg
bWlnaHQgZ2V0IGRyb3BwZWQgYXMgbG9uZyBhcyB0aGUgdXNlcgpoYXMgdGhlIG9wdGlvbiB0byBz
bGltIGRvd24gdGhlaXIga2VybmVsIHdpdGggdGhlIGZpcnN0IHR3by4KCj4KPj4gVGhpcyBpcyBt
eSBmaXJzdCB0aW1lIGhhY2tpbmcgYXJvdW5kIEtjb25maWcgc28gSSBob3BlIEkndmUgZ290IHRo
ZQo+PiBiYWxhbmNlIGJldHdlZW4gZGVwZW5kcyBhbmQgc2VsZWN0cyByaWdodCBidXQgcGxlYXNl
IGxldCBiZSBrbm93IGlmIGl0Cj4+IGNvdWxkIGJlIHNwZWNpZmllZCBpbiBhIGNsZWFuZXIgd2F5
Lgo+Pgo+PiBBbGV4IEJlbm7DqWUgKDMpOgo+PiAgIGFybTY0OiBhbGxvdyBkZS1zZWxlY3Rpb24g
b2YgVGh1bmRlclggUENJIGNvbnRyb2xsZXJzCj4+ICAgYXJtNjQ6IGdhdGUgdGhlIHdob2xlIG9m
IHBjaS14Z2VuZSBvbiBDT05GSUdfUENJX1hHRU5FCj4+ICAga2VybmVsL2NvbmZpZ3M6IGRvbid0
IGluY2x1ZGUgUENJX1FVSVJLUyBpbiBLVk0gZ3Vlc3QgY29uZmlncwo+Pgo+PiAgYXJjaC9hcm02
NC9LY29uZmlnLnBsYXRmb3JtcyAgICB8IDIgKysKPj4gIGFyY2gvYXJtNjQvY29uZmlncy9kZWZj
b25maWcgICAgfCAxICsKPj4gIGRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvS2NvbmZpZyAgfCA3ICsr
KysrKysKPj4gIGRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvTWFrZWZpbGUgfCA4ICsrKy0tLS0tCj4+
ICBrZXJuZWwvY29uZmlncy9rdm1fZ3Vlc3QuY29uZmlnIHwgMSArCj4+ICA1IGZpbGVzIGNoYW5n
ZWQsIDE0IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4+Cj4+IC0tCj4+IDIuMjAuMQo+
Pgo+Pgo+PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+
PiBsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdAo+PiBsaW51eC1hcm0ta2VybmVsQGxpc3Rz
LmluZnJhZGVhZC5vcmcKPj4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW51eC1hcm0ta2VybmVsCgoKLS0gCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
