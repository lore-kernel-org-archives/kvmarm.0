Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DBBC433ED
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 16:32:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14FC861418
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 16:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14FC861418
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53C924B228;
	Wed, 28 Apr 2021 12:32:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vUkkOpTLTdN9; Wed, 28 Apr 2021 12:32:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 314084B278;
	Wed, 28 Apr 2021 12:32:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C68C44B276
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 12:32:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nMrMGulJDXvH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 12:32:51 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96CC24B228
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 12:32:51 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id d11so5885004wrw.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 09:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=vMvP7yT7h0EJmqJtDWRQoTiz4uSh0TU3K6GL9MOqQzg=;
 b=rNnMJW8MV/b+T1qXUq5CprIbKb3o5zKrUNQnUSN6zt+H57dBz+5m4Dka/+/gQZ8+oP
 xU6Cp3yy8PUGARwnsQiTdLZLPXFXfVxFbHSdUKDzvKcBvraC31szfWCiNSb5yXOkXvxY
 df6xjOOqXLRcIdEkSWgqRRMEZ8gPKW/L/yaj50kp7MJAywFAqjvK+xWWa74U98jAlwG3
 mEEjQ/nhs3U7v1+tPzGFBDsO3seUZMBJyBDXZDfxZc9d7VxSESZ+ZblMkVallHGStxUH
 FZD6iLH7tMs82vbr3DXtrwEhx3XRlzeLLYDJ72awnFyMCiypeptgla2+J+ejeBgVEgTQ
 Ezmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=vMvP7yT7h0EJmqJtDWRQoTiz4uSh0TU3K6GL9MOqQzg=;
 b=MSTkv5kOR98q/yM9BHplWxrlF9XA0s31UyTXNut/G1eRuWrv5fHJdbtz8EpG/AoqTg
 z7ung8P3JXmYKnrugLkTuzilJ01vuQUx3C0+W8mKIgSRaRsbqR7uCi8gY8Kic1tww1hn
 HErQi4+B1JfTtdcKVSaIsCL+2AbxE+k1YllcJrmoTJrh1K1CgsyBD8pOuRRJhNGc0vmv
 sxy4xZSf4//6JVDGJzk79pmu8iJQifwQTeJ+XUQAHQSSJuKrAOT9R6KD0ypbtxbIkfjh
 JlZGTvFUMGN9/xcyPY730RtKnofajU4bYUN7rmjuS8X2dBuh8SEFo/UlTRh6V8bHSS1f
 fenw==
X-Gm-Message-State: AOAM530DxFoR9F3TZi48mdToRme/qc7JDEcqF4lFFVQmnkdNPhbX/igZ
 CCJvjDWZUFj7xOC+9Yy4YRpzsg==
X-Google-Smtp-Source: ABdhPJzOUG0QIk3RFE1BxF3PoLYlTmc5Oy+854AX6CAz9G5nz1e/tyUANGyEiZRCxDXLPZZK94u1hQ==
X-Received: by 2002:a5d:68c3:: with SMTP id p3mr38833351wrw.62.1619627570577; 
 Wed, 28 Apr 2021 09:32:50 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id u17sm6548332wmq.30.2021.04.28.09.32.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 09:32:49 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id E47051FF7E;
 Wed, 28 Apr 2021 17:32:48 +0100 (BST)
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
 <eaed3c63988513fe2849c2d6f22937af@kernel.org> <87fszasjdg.fsf@linaro.org>
 <996210ae-9c63-54ff-1a65-6dbd63da74d2@arm.com>
 <87k0omo4rr.wl-maz@kernel.org> <87czues90k.fsf@linaro.org>
User-agent: mu4e 1.5.12; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test
 into KVM and TCG variants
Date: Wed, 28 Apr 2021 17:31:27 +0100
In-reply-to: <87czues90k.fsf@linaro.org>
Message-ID: <877dkms72n.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

CkFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBNYXJjIFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPiB3cml0ZXM6Cj4KPj4gT24gV2VkLCAyOCBBcHIgMjAyMSAx
NTowMDoxNSArMDEwMCwKPj4gQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0u
Y29tPiB3cm90ZToKPj4+IAo+Pj4gSSBpbnRlcnByZXQgdGhhdCBhcyB0aGF0IGFuIElOVkFMTCBn
dWFyYW50ZWVzIHRoYXQgYSBjaGFuZ2UgaXMKPj4+IHZpc2libGUsIGJ1dCBpdCB0aGUgY2hhbmdl
IGNhbiBiZWNvbWUgdmlzaWJsZSBldmVuIHdpdGhvdXQgdGhlCj4+PiBJTlZBTEwuCj4+Cj4+IFll
cy4gRXhwZWN0aW5nIHRoZSBMUEkgdG8gYmUgZGVsaXZlcmVkIG9yIG5vdCBpbiB0aGUgYWJzZW5j
ZSBvZiBhbgo+PiBpbnZhbGlkYXRlIHdoZW4gaXRzIGNvbmZpZ3VyYXRpb24gaGFzIGJlZW4gYWx0
ZXJlZCBpcyB3cm9uZy4gVGhlCj4+IGFyY2hpdGVjdHVyZSBkb2Vzbid0IGd1YXJhbnRlZSBhbnl0
aGluZyBvZiB0aGUgc29ydC4KPgo+IElzIHRoZSB1bmRlcmx5aW5nIGh5cGVydmlzb3IgYWxsb3dl
ZCB0byBpbnZhbGlkYXRlIGFuZCByZWxvYWQgdGhlCj4gY29uZmlndXJhdGlvbiB3aGVuZXZlciBp
dCB3YW50cyBvciBzaG91bGQgaXQgb25seSBiZSBkcml2ZW4gYnkgdGhlCj4gZ3Vlc3RzIHJlcXVl
c3RzPwo+Cj4gSSBkaWQgY29uc2lkZXIgYSBtb3JlIG51YW5jZWQgdmFyaWFudCBvZiB0aGUgdGVz
dCB0aGF0IGFsbG93ZWQgZm9yIGEKPiBkZWxpdmVyeSBwcmUtaW52YWwgYW5kIGEgcGFzcyBmb3Ig
cG9zdC1pbnZhbCBhcyBsb25nIGFzIGl0IGhhZCBiZWVuCj4gZGVsaXZlcmVkIG9uZSB3YXkgb3Ig
YW5vdGhlcjoKPgo+IC0tODwtLS0tLS0tLS0tLS0tLS1jdXQgaGVyZS0tLS0tLS0tLS0tLS0tLXN0
YXJ0LS0tLS0tLS0tLS0tLT44LS0tCj4gbW9kaWZpZWQgICBhcm0vZ2ljLmMKPiBAQCAtMzYsNiAr
MzYsNyBAQCBzdGF0aWMgc3RydWN0IGdpYyAqZ2ljOwo+ICBzdGF0aWMgaW50IGFja2VkW05SX0NQ
VVNdLCBzcHVyaW91c1tOUl9DUFVTXTsKPiAgc3RhdGljIGludCBpcnFfc2VuZGVyW05SX0NQVVNd
LCBpcnFfbnVtYmVyW05SX0NQVVNdOwo+ICBzdGF0aWMgY3B1bWFza190IHJlYWR5Owo+ICtzdGF0
aWMgYm9vbCB1bmRlcl90Y2c7Cj4gIAo+ICBzdGF0aWMgdm9pZCBucl9jcHVfY2hlY2soaW50IG5y
KQo+ICB7Cj4gQEAgLTY4Nyw2ICs2ODgsNyBAQCBzdGF0aWMgdm9pZCB0ZXN0X2l0c190cmlnZ2Vy
KHZvaWQpCj4gIAlzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKmNvbDM7Cj4gIAlzdHJ1Y3QgaXRzX2Rl
dmljZSAqZGV2MiwgKmRldjc7Cj4gIAljcHVtYXNrX3QgbWFzazsKPiArCWJvb2wgYmVmb3JlLCBh
ZnRlcjsKPiAgCj4gIAlpZiAoaXRzX3NldHVwMSgpKQo+ICAJCXJldHVybjsKPiBAQCAtNzM0LDE1
ICs3MzYsMTcgQEAgc3RhdGljIHZvaWQgdGVzdF9pdHNfdHJpZ2dlcih2b2lkKQo+ICAJLyoKPiAg
CSAqIHJlLWVuYWJsZSB0aGUgTFBJIGJ1dCB3aWxsaW5nbHkgZG8gbm90IGNhbGwgaW52YWxsCj4g
IAkgKiBzbyB0aGUgY2hhbmdlIGluIGNvbmZpZyBpcyBub3QgdGFrZW4gaW50byBhY2NvdW50Lgo+
IC0JICogVGhlIExQSSBzaG91bGQgbm90IGhpdAo+ICsJICogVGhlIExQSSBzaG91bGQgbm90IGhp
dC4gVGhpcyBkb2VzIGhvd2V2ZXIgZGVwZW5kIG9uCj4gKwkgKiBpbXBsZW1lbnRhdGlvbiBkZWZp
bmVkIGJlaGF2aW91ciAtIHVuZGVyIFFFTVUgVENHIGVtdWxhdGlvbgo+ICsJICogaXQgY2FuIHF1
aXRlIGNvcnJlY3RseSBwcm9jZXNzIHRoZSBldmVudCBkaXJlY3RseS4KPiAgCSAqLwo+ICAJZ2lj
djNfbHBpX3NldF9jb25maWcoODE5NSwgTFBJX1BST1BfREVGQVVMVCk7Cj4gIAlzdGF0c19yZXNl
dCgpOwo+ICAJY3B1bWFza19jbGVhcigmbWFzayk7Cj4gIAlpdHNfc2VuZF9pbnQoZGV2MiwgMjAp
Owo+ICAJd2FpdF9mb3JfaW50ZXJydXB0cygmbWFzayk7Cj4gLQlyZXBvcnQoY2hlY2tfYWNrZWQo
Jm1hc2ssIC0xLCAtMSksCj4gLQkJCSJkZXYyL2V2ZW50aWQ9MjAgc3RpbGwgZG9lcyBub3QgdHJp
Z2dlciBhbnkgTFBJIik7Cj4gKwliZWZvcmUgPSBjaGVja19hY2tlZCgmbWFzaywgLTEsIC0xKTsK
PiArCXJlcG9ydF94ZmFpbCh1bmRlcl90Y2csIGJlZm9yZSwgImRldjIvZXZlbnRpZD0yMCBzdGls
bCBtYXkgbm90IHRyaWdnZXIgYW55IExQSSIpOwo+ICAKPiAgCS8qIE5vdyBjYWxsIHRoZSBpbnZh
bGwgYW5kIGNoZWNrIHRoZSBMUEkgaGl0cyAqLwo+ICAJc3RhdHNfcmVzZXQoKTsKPiBAQCAtNzUw
LDggKzc1NCw4IEBAIHN0YXRpYyB2b2lkIHRlc3RfaXRzX3RyaWdnZXIodm9pZCkKPiAgCWNwdW1h
c2tfc2V0X2NwdSgzLCAmbWFzayk7Cj4gIAlpdHNfc2VuZF9pbnZhbGwoY29sMyk7Cj4gIAl3YWl0
X2Zvcl9pbnRlcnJ1cHRzKCZtYXNrKTsKPiAtCXJlcG9ydChjaGVja19hY2tlZCgmbWFzaywgMCwg
ODE5NSksCj4gLQkJCSJkZXYyL2V2ZW50aWQ9MjAgcGVuZGluZyBMUEkgaXMgcmVjZWl2ZWQiKTsK
PiArCWFmdGVyID0gY2hlY2tfYWNrZWQoJm1hc2ssIDAsIDgxOTUpOwo+ICsJcmVwb3J0KGJlZm9y
ZSAhPSBhZnRlciwgImRldjIvZXZlbnRpZD0yMCBwZW5kaW5nIExQSSBpcwo+ICAJcmVjZWl2ZWQi
KTsKCkFjdHVhbGx5IHRoYXQgc2hvdWxkIGJlOgoKICAgICAgICAgcmVwb3J0KGFmdGVyIHx8ICFi
ZWZvcmUsICJkZXYyL2V2ZW50aWQ9MjAgcGVuZGluZyBMUEkgaXMgcmVjZWl2ZWQiKTsKCnNvIGVp
dGhlciB0aGUgSVJRIGFycml2ZXMgYWZ0ZXIgdGhlIGZsdXNoIG9yIGl0IGhhZCBwcmV2aW91c2x5
LgoKLS0gCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
